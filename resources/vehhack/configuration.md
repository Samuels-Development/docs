# Configuration

All top-level tunables live in `configs/config.lua`. The hack table lives in `configs/hacks.lua`. Logging lives in `configs/logs.lua`. **Restart `sd-vehhack` after any change.**

## General

| Option | Default | Description |
|---|---|---|
| `Locale` | `'en'` | Locale file in `locales/<code>.json`. Ships with `en` and `de`. |
| `DebugPrints` | `false` | Log validation steps to server console. Useful when a hack is being rejected and you need to know why. |

## Items & Currency

| Option | Default | Description |
|---|---|---|
| `HackingItem` | `'phone_plug'` | The device item — triggers the UI when used. Set to `nil` to gate entry to `/testhackui` only. |
| `ConsumeOnUse` | `false` | `true` = device deleted on every use. Keep `false` for a reusable dongle where SIMs are the real consumable. |
| `CurrencyItem` | `'hacking_sim'` | Stackable item spent per hack. Set to `nil` to use the player's **cash** balance instead. |
| `CurrencyLabel` | `'SIMS'` | Short text shown in the UI next to the balance. Change to `'$'` when using cash. |

## Targeting

| Option | Default | Description |
|---|---|---|
| `MaxTargetDistance` | `150.0` | Camera raycast reach. Must be **≥** the largest per-class limit below, otherwise heli targeting can't physically reach at range. |
| `MaxTargetDistanceCar` | `30.0` | Lock/execute range for cars, bikes, and boats (units). |
| `MaxTargetDistanceHeli` | `150.0` | Lock/execute range for helicopters (units). |
| `ShowPlate` | `true` | `true` shows the licence plate (e.g. `12ABC345`) in the targeting HUD; `false` shows the display name (e.g. `KURUMA`). Empty plates fall back to the display name. |

### Outline Color

```lua
OutlineColor = {
    followAccent = true,
    r = 74, g = 222, b = 128, a = 255,
}
```

| Field | Effect |
|---|---|
| `followAccent = true` | RGB is taken from the player's chosen accent (falls back to `Settings.defaultAccent`, or to this block if `Settings.allowAccent = false`). |
| `followAccent = false` | Always use the literal `r / g / b` below. |
| `a` | Always used as the outline alpha, regardless of `followAccent`. |

### Highlights

Toggle the three targeting visuals independently. Omitting the block or a key keeps it enabled (fail-open).

```lua
Highlights = {
    brackets = true,   -- subtle white corner brackets
    outline  = true,   -- coloured outline shader on the vehicle
    arrow    = false,  -- 3D arrow marker above the target
}
```

### Progress Highlights

Which highlights keep rendering on the locked vehicle **while the hack's progress bar is active**. Only applies when `UseProgressBar = true`.

```lua
ProgressHighlights = {
    outline  = true,
    brackets = false,
    arrow    = false,
}
```

::: tip
A key is only honoured when the matching `Highlights.<key>` above is also `true` — you can't re-enable a highlight here that's globally disabled. Setting everything to `false` reproduces the old behaviour where all visuals drop the moment the progress bar appears.
:::

## Hack Execution

| Option | Default | Description |
|---|---|---|
| `HackCooldown` | `5` | Per-user cooldown in seconds between any two hacks. `0` = disabled. |
| `VehicleCooldown` | `600` | Per-plate cooldown in seconds — a specific vehicle is protected from any player after being hacked. `0` = disabled. |
| `UseProgressBar` | `true` | Show a progress bar after confirming a hack. When `false`, hacks execute instantly on click. |
| `ProgressDuration` | `3000` | Default progress-bar length in ms. Per-hack `executeTime` overrides it. |
| `ProgressBarStyle` | `'custom'` | Which renderer to use: `'custom'` (in-house NUI with live distance sub-bar) or `'native'` (bridge `StartProgress` / ox_lib). Both paths re-validate distance; walking out of range aborts and no cost is deducted. |

## Per-Player UI Settings

Each player can reposition the panel and pick an accent colour from the in-game settings gear. The server can also force a single default for everyone by flipping the allow toggles off.

```lua
Settings = {
    enabled         = true,
    allowPosition   = true,
    allowAccent     = true,
    defaultPosition = 'center-right',
    defaultAccent   = '4ade80',
}
```

| Field | Effect when `false` |
|---|---|
| `enabled` | Hides the settings gear entirely. `defaultPosition` + `defaultAccent` apply to everyone. |
| `allowPosition` | Panel always sits at `defaultPosition`. |
| `allowAccent` | Accent colour is always `defaultAccent`. |

| Field | Accepted values |
|---|---|
| `defaultPosition` | `'top-left'`, `'top-right'`, `'center-left'`, `'center-right'`, `'bottom-left'`, `'bottom-right'` |
| `defaultAccent` | 6-char hex without `#` |

## Emergency Vehicles

When `OWNER_SCAN` runs on an **unowned** vehicle whose model appears in one of these lists, the card shows a department label (e.g. `POLICE`) instead of a fake randomised name. Owned vehicles still show the real player's name — ownership wins.

```lua
EmergencyVehicles = {
    POLICE = {
        'police', 'police2', 'police3', 'police4', 'policeb', 'policet',
        'policeold1', 'policeold2', 'sheriff', 'sheriff2',
        'fbi', 'fbi2', 'riot', 'riot2', 'pranger', 'predator',
    },
    EMS  = { 'ambulance' },
    FIRE = { 'firetruk' },
}
```

Add your server's custom emergency spawn names to the matching department list.

## Exempt Vehicles

Models listed here **cannot be hacked**. Attempts are rejected server-side before cost is deducted, and the player gets a notification. Leave the table empty to allow every vehicle.

```lua
ExemptVehicles = {
    -- 'stockade',
    -- 'rhino',
}
```

## Hacks Table

`Config.Hacks` is loaded from `configs/hacks.lua`. Each entry is a table with the fields below.

### Core fields

| Field | Type | Description |
|---|---|---|
| `id` | string | Unique identifier. Used in code — do not duplicate. |
| `enabled` | bool | `false` = hidden from the menu **and** rejected server-side. |
| `label` | string | Text shown on the button. |
| `icon` | string | Lucide icon name. See `web/src/App.tsx` `iconMap` for the supported set (add imports there to extend). |
| `cost` | number | SIMs (or cash) spent on success. |
| `duration` | number | Effect length in ms. `0` = instant / permanent. Ignored by hacks with no timed effect (`explode_car`, `pop_tires`, `owner_scan`, …). |
| `executeTime` | number? | Optional progress-bar duration in ms. Falls back to `ProgressDuration` when omitted. Ignored entirely if `UseProgressBar = false`. |
| `description` | string | Tooltip text. |
| `applies` | string? | Vehicle-class gate: `'car'` (cars + bikes), `'heli'`, or `nil` (any). |
| `excludes` | table? | Optional list of classes to block even when `applies` would allow them. Each entry must be `'car'`, `'heli'`, or `'bike'`. |
| `category` | string | UI tab: `'sabotage'` / `'control'` / `'chaos'` / `'intel'`. |
| `sound` | string | Success sound. One of `success` / `activate` / `select` / `target_lock` / `targeting_start` / `explode`. |
| `hackedFx` | string? | Screen effect shown to occupants of the hacked vehicle. One of `static` (default) / `nosignal` / `blackout`. Unknown values fall back to `static`. |

::: tip `applies = 'car'` is a legacy name
It covers **all ground vehicles** — cars AND bikes. Use `excludes = { 'bike' }` to narrow to cars only.
:::

### Extended fields

Only some hacks use these. Any field not listed is ignored by that hack.

| Field | Hacks using it | Description |
|---|---|---|
| `requiresSeat` | `EJECT_OCCUPANT` | When `true`, opens a seat-picker modal after click. Seat index (`-1` driver / `0` front-pass / `1` rear-left / `2` rear-right) is sent to the server. |
| `allMultiplier` | `EJECT_OCCUPANT` | Optional **ALL** button in the seat picker. Cost becomes `base * allMultiplier` and every occupant is ejected. Omit/`nil` to hide. |
| `requiresSpeed` | `SPEED_LIMITER` | When `true`, opens a speed-slider modal after click. |
| `speedMin`, `speedMax` | `SPEED_LIMITER` | Slider bounds in mph. |
| `costAtMin` | `SPEED_LIMITER` | Cost at `speedMin`. Cost slides linearly: `costAtMin` at the bottom, `cost` at `speedMax` — lower top speed = harder to escape = more expensive. |
| `speedThreshold` | `SPEED_BOMB` | Arming threshold in mph. Bomb arms when the driver hits this speed; dropping back below it detonates. |
| `fuelLevel` | `FUEL_PURGE` | Fuel level (0–100) the tank is forced down to. `10` leaves a splash so the driver gets a short limp; `0` is a hard drain; `25` makes it a "go-to-a-station" version. |

### Cost Tiers (guidance, not enforced)

| Tier | Range |
|---|---|
| Trivial | 5 – 10 |
| Cheap | 10 – 20 |
| Mid | 20 – 40 |
| Heavy | 40 – 75 |
| Top-tier | 100+ |

### Disable a hack

Flip `enabled = false` on the entry. It stays in the file but is hidden from the menu and the server rejects attempts to fire it.

### Remove a hack permanently

Delete its entry from `configs/hacks.lua`, then (optionally) its `elseif hackId == '...'` branch in `client/main.lua` inside `RegisterNetEvent('sd-hacking:client:ApplyHack', ...)`. Orphaned handlers are harmless.

### Add a new hack

1. Copy any existing entry in `configs/hacks.lua` and give it a unique `id`.
2. Open `client/main.lua`, find `RegisterNetEvent('sd-hacking:client:ApplyHack', ...)`, and add an `elseif hackId == 'your_id' then` branch with the in-game effect (native calls on the vehicle).
3. If you need a new icon, import it in `web/src/App.tsx`, add it to `iconMap`, then run `npm run build` inside `/web`.

## Logging

See [full-config-logs](./full-config-logs) for the full event-template reference. Supported backends: **Discord**, **Fivemanage**, **Fivemerr**, **Loki**, **Grafana**, or `none`.

Quick Discord setup:

1. In Discord: channel → **Settings → Integrations → Webhooks → New Webhook** → copy the URL.
2. In `configs/logs.lua`:

```lua
service = 'discord',
discord = {
    webhook       = 'paste-url-here',
    botName       = 'SD-Vehhack',
    footerText    = 'SD-Vehhack Logging',
    flushInterval = 5,      -- seconds between batched posts
    tagEveryone   = false,  -- @everyone on high-impact hacks
},
```

3. Restart the resource.

Two events ship out of the box:

| Event | Fires on | Default colour |
|---|---|---|
| `hack_executed` | Any successful hack | Yellow (16776960) |
| `owner_scan_performed` | Any successful `OWNER_SCAN` | Green (5763719) |

Each event is toggleable via `enabled`, and its `title` / `description` / `fields` are fully editable. See the [logs reference](./full-config-logs) for the full placeholder list (`{player}`, `{hackLabel}`, `{plate}`, `{ownerStatus}`, …).
