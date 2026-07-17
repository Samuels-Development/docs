---
title: Client Exports
description: Client-side exports for opening the phone, launching apps, showing notifications, and reading phone state from other scripts.
---

# Client Exports

The phone provides client-side exports for opening and closing the shell, launching apps with deep links, showing local notification banners, and reading phone state. They are callable by other client scripts on the same machine only; the client and server export registries are completely independent.

## isOpen

Whether the phone UI is currently open.

**Syntax**
```lua
local open = exports['sd-phone']:isOpen()
```

| Return | Type | Description |
|---|---|---|
| `open` | `boolean` | Whether the phone is out |

## isLocked

Whether the phone is sitting on the lockscreen. The phone always opens locked.

**Syntax**
```lua
local locked = exports['sd-phone']:isLocked()
```

## open

Open the phone. Re-runs the dead/swimming/disabled safety blocks (a refusal shows a notify) but not the ownership gate: callers vouch for their own context. Opens onto the lockscreen.

**Syntax**
```lua
exports['sd-phone']:open()
```

## close

Close the phone. Idempotent, safe to call when already closed.

**Syntax**
```lua
exports['sd-phone']:close()
```

## openApp

Launch an app by home-screen id, opening the phone first if it is closed. The launch queues behind the lockscreen exactly like a tapped lockscreen notification; nothing bypasses or unlocks anything.

**Syntax**
```lua
local accepted = exports['sd-phone']:openApp(appId, link)
```

| Parameter | Type | Description |
|---|---|---|
| `appId` | `string` | Home-screen app id (e.g. `'messages'`, `'maps'`) |
| `link` | `table?` | Optional deep-link table the target app's notification-link handler understands |

| Return | Type | Description |
|---|---|---|
| `accepted` | `boolean` | `false` when a safety block refused the open, the id is not a string, or `link` is not a table |

**Example**
```lua
-- Jump straight into the Services app after a dispatch ping
RegisterNetEvent('mydispatch:ping', function()
    exports['sd-phone']:openApp('services')
end)
```

## showNotification

Show one iOS-style banner directly, client-local with no server trip. Same payload contract as the server `notify` export.

**Syntax**
```lua
exports['sd-phone']:showNotification(data)
```

| Parameter | Type | Description |
|---|---|---|
| `data.title` | `string` | Required banner title |
| `data.app` | `string?` | App id whose icon to show |
| `data.image` | `string?` | Custom icon URL, overrides `data.app` |
| `data.body` | `string?` | Banner body text |
| `data.time` | `string?` | Display time string |
| `data.appId` | `string?` | App opened when the banner is tapped |

## setDisabled

Session-local disable switch. While disabled the phone refuses to open, and disabling while it is out closes it immediately (extinguishing the lockscreen flashlight with it). Resets to enabled on resource restart.

**Syntax**
```lua
exports['sd-phone']:setDisabled(disabled)
```

| Parameter | Type | Description |
|---|---|---|
| `disabled` | `boolean` | Coerced strictly: only literal `true` disables |

**Example**
```lua
-- No phones inside the jail
exports['sd-phone']:setDisabled(true)
```

## isDisabled

Reads the disable switch.

**Syntax**
```lua
local disabled = exports['sd-phone']:isDisabled()
```

The remaining exports read the local player's Groups app state from a client-side cache, refreshed at boot and after every membership-affecting push.

## getActiveGroupId

The local player's active group id. Instant, no server round trip.

**Syntax**
```lua
local id = exports['sd-phone']:getActiveGroupId()
```

## getActiveGroup

Cached export view of the local player's active group (same shape as the server `getGroup` view). Refetches lazily when the cache is cold, so a read before the boot fetch still gets an answer.

**Syntax**
```lua
local group = exports['sd-phone']:getActiveGroup()
```

## refreshActiveGroup

Force a re-fetch of the cached active group, for consumers that just performed a server action and want a guaranteed-fresh next read.

**Syntax**
```lua
exports['sd-phone']:refreshActiveGroup()
```

## addCustomApp

Registers a third-party app on the phone. The full field table, page requirements and lifecycle live in the [Custom Apps guide](./custom-apps).

**Syntax**
```lua
local ok, err = exports['sd-phone']:addCustomApp({
    identifier = 'my-app',
    name       = 'My App',
    ui         = GetCurrentResourceName() .. '/ui/index.html',
})
```

| Return | Type | Description |
|---|---|---|
| `ok` | `boolean` | Whether the app was registered |
| `err` | `string?` | Reason when `ok` is false |

## removeCustomApp

Unregisters a custom app. Only the resource that registered the identifier may remove it; apps are also removed automatically when their resource stops.

**Syntax**
```lua
local ok, err = exports['sd-phone']:removeCustomApp('my-app')
```

## sendCustomAppMessage

Pushes a message into a custom app's UI, where `useNuiEvent(action, cb)` receives it. The reserved identifier `'any'` broadcasts to every custom app.

**Syntax**
```lua
local ok, err = exports['sd-phone']:sendCustomAppMessage('my-app', {
    action = 'balanceChanged',
    data = { balance = 4200 },
})
```

::: tip
Server-side exports for messages, mail, calls, contacts, and everything else are documented on the [Server Exports](./exports-server) page.
:::
