---
title: Client Exports
description: Client-side exports for opening the phone, launching apps, showing notifications, and reading phone state from other scripts.
---

# Client Exports

The phone provides client-side exports for opening and closing the shell, launching apps with deep links, showing local notification banners, and reading phone state. They are callable by other client scripts on the same machine only; the client and server export registries are completely independent.

## Phone state

### isOpen

Whether the phone UI is currently open.

**Syntax**
```lua
local open = exports['sd-phone']:isOpen()
```

| Return | Type | Description |
|---|---|---|
| `open` | `boolean` | Whether the phone is out |

### isLocked

Whether the phone is sitting on the lockscreen. The phone always opens locked.

**Syntax**
```lua
local locked = exports['sd-phone']:isLocked()
```

### open

Open the phone. Re-runs the dead/swimming/disabled safety blocks (a refusal shows a notify) but not the ownership gate: callers vouch for their own context. Opens onto the lockscreen.

**Syntax**
```lua
exports['sd-phone']:open()
```

### close

Close the phone. Idempotent, safe to call when already closed.

**Syntax**
```lua
exports['sd-phone']:close()
```

### openApp

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

### setDisabled

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

### isDisabled

Reads the disable switch.

**Syntax**
```lua
local disabled = exports['sd-phone']:isDisabled()
```

## Notifications

### showNotification

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

## Cell service

Cell service reflects where the player is standing relative to the configured masts in
`configs/celltowers.lua`. When the tower system is switched off every reading reports full
service, so these are safe to call unconditionally.

### getServiceLevel

Current cell service where the player stands, from `0.0` (dead zone) to `1.0` (at a mast).

**Syntax**

```lua
exports['sd-phone']:getServiceLevel()
```

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `level` | `number` | `0.0` to `1.0`. Always `1.0` when no masts are configured |

**Example**

```lua
if exports['sd-phone']:getServiceLevel() < 0.2 then
    print('signal is weak here')
end
```

### getServiceBars

The bar count the status bar is drawing, `0` to `4`.

**Syntax**

```lua
exports['sd-phone']:getServiceBars()
```

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `bars` | `number` | `0` to `4`. `0` is shown as "No Service" |

::: tip
Bars are a display bucket, not a capability check. Use [`hasService`](#hasservice) to ask whether
something will actually work.
:::

### hasService

Whether a capability is currently possible where the player stands.

**Syntax**

```lua
exports['sd-phone']:hasService(capability)
```

**Parameters**

| Parameter | Type | Description |
| --- | --- | --- |
| `capability` | `string?` | `'text'`, `'call'` or `'data'`. Defaults to `'data'` |

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `allowed` | `boolean` | `true` when the signal clears that capability's threshold |

**Example**

```lua
if not exports['sd-phone']:hasService('call') then
    print('too weak to place a call from here')
end
```

::: warning
This is the client's own reading, so treat it as a UI hint. Calls and texts are enforced
server-side, where the level is recomputed from the server's view of the player.
:::

### getCellTowers

Every configured mast with its coverage radius.

**Syntax**

```lua
exports['sd-phone']:getCellTowers()
```

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `towers` | `table[]` | `{ tower = vector3, range = number }`, mirroring `configs/celltowers.lua` |

Empty while the system is switched off. The table is rebuilt on every call, so mutating it never
touches the running config.

**Example**

```lua
for _, mast in ipairs(exports['sd-phone']:getCellTowers()) do
    print(('mast at %s covers %.0f units'):format(mast.tower, mast.range))
end
```

::: info
The lb-phone compatibility export `GetCellTowers` returns bare `vector3` values with no ranges,
matching lb-phone's own config shape. This one keeps the ranges.
:::

## Wi-Fi

Wi-Fi covers the local networks in `configs/wifi.lua`, which carry data where the masts do not
reach. These readings come from the phone's own scan, so they are exactly what the status bar and
the Wi-Fi list in Settings are drawing. When the system is switched off nothing is ever in range and
every reading reports no connection.

### isOnWifi

Whether the phone is joined to a network right now.

**Syntax**

```lua
exports['sd-phone']:isOnWifi()
```

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `connected` | `boolean` | `true` while joined to a network |

### getWifi

The joined network's id, as `configs/wifi.lua` names it.

**Syntax**

```lua
exports['sd-phone']:getWifi()
```

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `id` | `string?` | Network id, `nil` while off Wi-Fi |

**Example**

```lua
if exports['sd-phone']:getWifi() == 'mazebank' then
    print('on the bank router')
end
```

### getWifiNetwork

The joined network with its live signal.

**Syntax**

```lua
exports['sd-phone']:getWifiNetwork()
```

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `id` | `string` | Network id |
| `ssid` | `string` | The name the player reads on screen |
| `strength` | `number` | `0.0` to `1.0`, raw across the network's radius |
| `bars` | `number` | `0` to `3`, the bucket the Wi-Fi glyph draws |

`nil` while off Wi-Fi. Use `strength` when you want the real number and `bars` when you want to
match what the player is looking at.

### getWifiNetworks

Every configured network, in range or not.

**Syntax**

```lua
exports['sd-phone']:getWifiNetworks()
```

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `networks` | `table[]` | `{ id, ssid, coords, range, secured }`, mirroring `configs/wifi.lua` |

Empty while the system is switched off. The tables are rebuilt on every call, so mutating the result
never touches the running config.

::: warning
`secured` is the only password-derived value in this list. A network's password is checked
server-side and is never sent to a client, so no client export can leak one.
:::

### getNearbyWifi

What is in reach right now, strongest first, as of the last scan.

**Syntax**

```lua
exports['sd-phone']:getNearbyWifi()
```

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `networks` | `table[]` | `{ id, ssid, secured, strength, bars, known }`, strongest first |

`known` means this character has joined the network before, so rejoining it needs no password. Empty
while the radio is off or nothing is in range.

**Example**

```lua
for _, net in ipairs(exports['sd-phone']:getNearbyWifi()) do
    print(('%s  %d bars%s'):format(net.ssid, net.bars, net.secured and ' (locked)' or ''))
end
```

::: warning
Every export in this category is display-grade: it answers from where the client believes it is.
Anything that has to hold, such as gating a door, a terminal or a download, belongs on
[`hasWifiAccess`](./exports-server#haswifiaccess), which recomputes the connection from the server's
own view of the player.
:::

## SIM tray

### openSimTray

Opens the SIM tray of the phone in `slot`. Intended for the phone item's `buttons` entry in `ox_inventory/data/items.lua` under [`SimTray` mode](/resources/phone/unique-phones#physical-sim-trays); the server re-derives the tray from the slot, so it only ever opens a tray belonging to a phone the caller actually carries. A no-op outside tray mode.

**Syntax**
```lua
exports['sd-phone']:openSimTray(slot)
```

| Parameter | Type | Description |
|---|---|---|
| `slot` | `number` | Inventory slot holding the phone |

The remaining exports read the local player's Groups app state from a client-side cache, refreshed at boot and after every membership-affecting push.

## Groups

### getActiveGroupId

The local player's active group id. Instant, no server round trip.

**Syntax**
```lua
local id = exports['sd-phone']:getActiveGroupId()
```

### getActiveGroup

Cached export view of the local player's active group (same shape as the server `getGroup` view). Refetches lazily when the cache is cold, so a read before the boot fetch still gets an answer.

**Syntax**
```lua
local group = exports['sd-phone']:getActiveGroup()
```

### refreshActiveGroup

Force a re-fetch of the cached active group, for consumers that just performed a server action and want a guaranteed-fresh next read.

**Syntax**
```lua
exports['sd-phone']:refreshActiveGroup()
```

## Custom apps

### addCustomApp

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

### removeCustomApp

Unregisters a custom app. Only the resource that registered the identifier may remove it; apps are also removed automatically when their resource stops.

**Syntax**
```lua
local ok, err = exports['sd-phone']:removeCustomApp('my-app')
```

### sendCustomAppMessage

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
