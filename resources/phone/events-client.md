---
title: Client Events
description: Client-local events the phone fires when it opens and closes, enters camera mode, or toggles the flashlight.
---

# Client Events

The phone announces client-side state changes as plain client-local events (`TriggerEvent` on the same machine). Listen with a standard handler:

```lua
AddEventHandler('sd-phone:client:openState', function(open)
    -- phone just opened or closed
end)
```

## Phone State

### sd-phone:client:openState

Fires when the phone opens (`true`) or closes (`false`).

```lua
AddEventHandler('sd-phone:client:openState', function(open)
    if open then StopScreenEffect('MenuMGIn') end
end)
```

| Parameter | Type | Description |
|---|---|---|
| `open` | `boolean` | The new visibility state |

::: info
The open announcement fires as the shell comes out, before app data has finished hydrating. Handlers run synchronously, keep them cheap.
:::

### sd-phone:client:cameraMode

Fires when the Camera app takes over the game view (`true` on enter, `false` on exit). The phone uses this internally to yield the hold pose; other scripts can use it to hide overlays that would land in photos. Both transitions are idempotent, listeners never see doubled events.

| Parameter | Type | Description |
|---|---|---|
| `active` | `boolean` | Coerce defensively: `active and true or false` |

### sd-phone:client:flashlight

Fires whenever the lockscreen flashlight beam changes state, including the forced shut-off when another script disables the phone via `setDisabled(true)`.

| Parameter | Type | Description |
|---|---|---|
| `on` | `boolean` | The resulting beam state |

## Server Pushes

::: tip
Beyond the client-local events above, the phone's server half pushes net events to its own client that other client resources may also observe with `AddEventHandler` (they are `RegisterNetEvent`-registered). The useful ones:

- `sd-phone:client:mail:received` (message) - a mail landed in a signed-in inbox
- `sd-phone:client:messages:incoming` (thread patch) - a live SMS arrived
- `sd-phone:client:call:incoming` / `outgoing` / `connected` / `ended` - call flow from this client's perspective
- `sd-phone:client:notify` (data) - a banner was pushed to this phone
- `sd-phone:client:badges` (counts) - the badge snapshot was recomputed

These are delivery internals first and integration surface second: their payloads serve the UI and may grow fields between versions. For a stable contract, prefer the [Server Events](./events-server).
:::
