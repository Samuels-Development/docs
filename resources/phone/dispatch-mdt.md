---
title: Dispatch on the MDT
description: Mirror the alerts from your dispatch resource onto the MDT's call board - six systems automatically, three with one line of code.
---

# Dispatch on the MDT

The MDT ships its own CAD: a live call board, units on the air, 10-codes and a map. This page is about filling that board from the dispatch resource you already run, so an officer sitting at the terminal sees the same calls their colleagues are getting on screen.

It is one-way by design. The MDT mirrors alerts; it never acknowledges, attaches to, or closes anything in your dispatch. Both keep working exactly as they do now, and turning the mirror off changes nothing about either.

::: info
This needs the MDT itself, which is off by default. Set `Enabled = true` in `configs/mdt.lua` first — the mirror is a feature of the terminal, not a standalone one.
:::

## Picked up automatically

Six systems announce their alerts through an event, which means the phone can listen for one without you changing a line of their code or yours. Install nothing, paste nothing:

| Dispatch | What the phone listens to |
|---|---|
| **ps-dispatch** | `ps-dispatch:server:notify` |
| **qb-dispatch** | `dispatch:server:notify` (and its many forks) |
| **cd_dispatch** | `cd_dispatch:AddNotification` |
| **qs-dispatch** | `qs-dispatch:server:CreateDispatchCall` |
| **rcore_dispatch** | `rcore_dispatch:server:sendAlert` |
| **aty_dispatchv2** | `aty_dispatchv2:client:sendDispatch`, relayed by the client half |

A handler is registered for every one of them whether or not you run it. A system that is not installed simply never fires its event, so there is nothing to configure and nothing to detect — if you swap dispatch resources later, the new one is already supported.

Each alert keeps its own routing. The jobs an alert names decide whether it lands on the police board or the medical one, which is how all six of these systems address a call in the first place.

## The three that need one line

**tk_dispatch**, **codem-dispatch** and **fd_dispatch** publish alerts through an *export* rather than an event. An export call is a direct function call into that resource, and there is no way for a third resource to observe one from outside — so these cannot be picked up automatically, and any resource claiming otherwise is hooking something it should not.

Instead, forward the alert yourself from wherever you already raise it, with one extra call.

### mdtMirrorCall

Put a third-party alert on the MDT call board.

**Syntax**
```lua
local mirrored = exports['sd-phone']:mdtMirrorCall(alert)
```

| Field | Type | Description |
|---|---|---|
| `code` | `string?` | Ten-code shown at the head of the row, e.g. `10-90` |
| `type` | `string?` | The headline, e.g. `Store Robbery`. One of `code` or `type` is required |
| `priority` | `number?` | `1` to `4`, defaulting to `3`. Mirrored calls are held at `2` or worse — see below |
| `location` | `string?` | Street or area text shown on the row |
| `coords` | `vector3?` | Map pin. A `{ x, y, z }` table works too |
| `domain` | `string?` | `'leo'` or `'ems'` to name a board directly |
| `jobs` | `table?` | Or name the jobs, the way the six automatic systems do |
| `suspect` | `string?` | Free-text detail line |
| `weapon` | `string?` | Weapon description |
| `direction` | `string?` | Direction of travel |

| Return | Type | Description |
|---|---|---|
| `mirrored` | `boolean` | `true` when the alert reached at least one board |

**Example — tk_dispatch**

Add the mirror beside the `addCall` you already make:

```lua
local coords = GetEntityCoords(GetPlayerPed(-1))

exports.tk_dispatch:addCall({
    title = 'Store Robbery',
    priority = 1,
    coords = coords,
})

exports['sd-phone']:mdtMirrorCall({
    code = '10-90',
    type = 'Store Robbery',
    priority = 2,
    location = 'Vespucci Boulevard',
    coords = coords,
    domain = 'leo',
})
```

**Example — codem-dispatch**

Its export is client-side only, so the mirror needs a server half. Guard the payload: this is an event a modified client can fire with anything it likes.

```lua
-- client
exports['codem-dispatch']:CustomDispatch(data)
TriggerServerEvent('my-resource:mirrorAlert', {
    code = '10-31',
    type = data.header,
    location = data.text,
    coords = GetEntityCoords(PlayerPedId()),
})

-- server
RegisterNetEvent('my-resource:mirrorAlert', function(data)
    if type(data) ~= 'table' then return end
    exports['sd-phone']:mdtMirrorCall(data)
end)
```

::: warning
Do not use `mdtCreateCall` for this. That export is the *trusted* server-side writer: it takes the whole board, accepts priority 1 and has no rate limit, because it exists for your own server code. Feeding it a payload that came from a client lets anyone who can fake that event clear the board of real calls. `mdtMirrorCall` takes the identical payload and applies the quarantine below.
:::

## How mirrored calls behave

Every one of these entry points is an event a modified client can fire, and that is true of your dispatch resource with or without the phone. What the MDT guarantees is that a mirrored call can never cost you a real one:

- **They hold their own share of the board.** Mirrored calls take at most half of `MaxCalls`, and past that share the oldest *mirrored* call is evicted to make room — never one of yours, and never the incoming alert either.
- **They are evicted first.** When the board is full, a mirrored call goes before any call your officers filed, whatever its priority.
- **They can never be priority 1.** A mirrored alert claiming the top priority is filed at `2`, so a forged "officer down" cannot outrank a real one.
- **Repeats are swallowed.** Several of these systems fire one incident as half a dozen alerts, and the relayed one arrives once per player who received it. An alert whose whole body matches one already on the board from the same 25 metre cell is dropped.
- **One source has one budget.** At most `RateMax` alerts per `RateWindow`, keyed on the character for a client-sent alert and on the firing resource for a server-sent one — so reconnecting does not reset it, and two dispatch resources never spend each other's.

## Configuration

Everything lives in `configs/mdt.lua` under `Dispatch.Ingest`:

| Setting | Default | What it does |
|---|---|---|
| `Enabled` | `true` | Master switch for the mirror |
| `Systems` | all `true` | Per-system switches. Setting one to `false` closes its entry point rather than merely ignoring what arrives on it. Anything not listed is on |
| `DedupeSeconds` | `45` | How long the same alert is swallowed for. Capped at 5 minutes |
| `RateWindow` | `10000` | Flood window, in milliseconds |
| `RateMax` | `12` | Alerts accepted from one source per window |
| `DefaultDomain` | `'leo'` | Board an alert lands on when the jobs it names are not departments this server runs |

Set `RateMax` above the mirrored share of the board and the server warns at startup: past that point one window can cycle every slot the mirror is allowed, so nothing on it survives long enough to be read.

## Nothing is appearing

Work down this list:

1. **Is the MDT on?** `Enabled = true` in `configs/mdt.lua`. The mirror does nothing without the terminal.
2. **Is the dispatch resource actually named what you think?** The phone listens for the event names in the table above. A renamed or heavily forked resource may raise something else entirely.
3. **Are you looking at the right board?** An alert naming only EMS jobs lands on the medical terminal, not the police one. Alerts naming jobs this server does not run fall back to `DefaultDomain`.
4. **Is it a repeat?** An identical alert from the same 25 metre cell inside `DedupeSeconds` is deliberately dropped.
5. **For the export-only three**, check your own snippet is calling `mdtMirrorCall` and that it returns `true`.
