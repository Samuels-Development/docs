---
title: Client Exports
description: Client-side exports for opening the phone, launching apps, showing notifications, and reading phone, Wi-Fi and Bluetooth state from other scripts.
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

## Bluetooth

Bluetooth covers the devices other resources register with the phone: boomboxes, car stereos,
headsets, smartwatches. These exports read a mirror the server pushes on every change, so they cost
nothing to call and never block. What they cannot do is answer for anyone but the local player.

### isBluetoothOn

Whether this character's Bluetooth radio is switched on.

**Syntax**

```lua
exports['sd-phone']:isBluetoothOn()
```

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `enabled` | `boolean` | `true` while the radio is on |

A switched-on radio with nothing in range is still on. This says nothing about what is connected.

### isBluetoothConnected

Whether this phone is connected to a device right now.

**Syntax**

```lua
exports['sd-phone']:isBluetoothConnected(deviceId)
```

**Parameters**

| Parameter | Type | Description |
| --- | --- | --- |
| `deviceId` | `string` | The device id its owning resource registered |

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `connected` | `boolean` | `true` while the phone holds a live connection to it |

**Example**

```lua
if exports['sd-phone']:isBluetoothConnected('dispatch_headset') then
    playRadioChatter()
end
```

### getConnectedDevices

Every device this phone is connected to.

**Syntax**

```lua
exports['sd-phone']:getConnectedDevices()
```

**Returns**

| Field | Type | Description |
| --- | --- | --- |
| `devices` | `table[]` | `{ id, name, kind }`, empty while nothing is connected |

The tables are rebuilt on every call, so mutating the result never touches the mirror.

**Example**

```lua
for _, device in ipairs(exports['sd-phone']:getConnectedDevices()) do
    print(('connected to %s (%s)'):format(device.name, device.kind))
end
```

::: warning
Every export in this category is display-grade: it answers from a mirror the client holds. Anything
that has to hold, such as gating what a boombox will play or what a headset can hear, belongs on the
[server exports](./exports-server#bluetooth), which answer from the registry itself.
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

Optional `devices` and `job` fields limit who sees the icon:

```lua
exports['sd-phone']:addCustomApp({
    identifier = 'mdt-lite',
    name       = 'MDT Lite',
    ui         = GetCurrentResourceName() .. '/ui/index.html',
    devices    = 'tablet',
    job        = { police = 2 },
})
```

Both only decide whether an icon is drawn. Neither authorises anything, so keep checking the job
server-side in your own resource. See [Limiting who sees an app](/resources/phone/custom-apps#limiting-who-sees-an-app).

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

## Lock screen widgets

A card your app pushes onto the player's lock screen, sitting above the notification stack. Unlike a
home screen widget, the player never places it: your resource decides when it appears and when it
goes away, which suits things that are only true for a while, such as a ride in progress, an active
call, or a running timer.

The widget must be declared in `lockscreenWidgets` on your `addCustomApp` registration first. See
[Lock screen widgets](/resources/phone/custom-apps#lock-screen-widgets) for the schema and what the
page receives.

### showLockscreenWidget

Shows one of your declared lock screen widgets, or updates the payload of one already showing.

**Syntax**
```lua
local ok = exports['sd-phone']:showLockscreenWidget(appId, widgetId, data, onAction)
```

| Parameter | Type | Required | Description |
|---|---|---|---|
| `appId` | `string` | yes | Your app identifier, as passed to `addCustomApp` |
| `widgetId` | `string` | yes | Id of an entry in that app's `lockscreenWidgets` |
| `data` | `table` | no | Payload delivered to the page. Sent again on every call, so this is how you push updates |
| `onAction` | `function` | no | Called as `onAction(action, value, data)` when the page relays an interaction |

| Return | Type | Description |
|---|---|---|
| `ok` | `boolean` | Whether the card was shown |

Returns `false` when the widget is not declared, when the calling resource is not the one that
registered the app, or when the player does not currently pass the app's `job` or `requires` gates.

**Example**
```lua
exports['sd-phone']:showLockscreenWidget('taxi-co', 'ride', {
    driver = 'Marla',
    eta    = 4,
}, function(action)
    if action == 'cancel' then cancelRide() end
end)
```

Call it again with a new `data` table to update the card in place. There is no separate update
export.

### hideLockscreenWidget

Removes a card you are showing.

**Syntax**
```lua
local ok = exports['sd-phone']:hideLockscreenWidget(appId, widgetId)
```

| Return | Type | Description |
|---|---|---|
| `ok` | `boolean` | Whether the card was hidden. `false` when your resource does not own it |

Only the resource that showed a card may hide it. Cards are also removed automatically when that
resource stops, so a restart never strands one on the lock screen.

## Now Playing

Lets a resource with its own audio engine drive the phone's media surfaces: the Control Center card,
the dynamic island mini player, the Now Playing home screen widget, and the lock screen card. Use it
when your script already plays the audio, so players get one set of controls instead of a phone
music player that knows nothing about what is actually playing.

This does not touch sd-phone's built-in Music app engine. Taking the slot pauses the built-in player
if it was running, and giving the slot back leaves the built-in player where it was.

### setExternalNowPlaying

Claims the Now Playing slot and sets what is displayed. Call it again to update.

**Syntax**
```lua
local ok = exports['sd-phone']:setExternalNowPlaying(appId, track, onAction)
```

| Parameter | Type | Required | Description |
|---|---|---|---|
| `appId` | `string` | yes | Identifier for your provider. A custom app id is the natural choice |
| `track` | `table` | yes | What to display. Fields below |
| `onAction` | `function` | no | Called as `onAction(action, value)` when the player uses a transport control |

`track` fields:

| Field | Type | Required | Description |
|---|---|---|---|
| `title` | `string` | yes | Track title |
| `artist` | `string` | no | Shown under the title |
| `thumb` | `string` | no | Artwork URL. Wins over any derived cover |
| `playing` | `boolean` | yes | Drives the play or pause glyph |
| `position` | `number` | yes | Playhead in seconds |
| `duration` | `number` | yes | Track length in seconds |
| `canNext`<br>`canPrev` | `boolean` | no | Accepted, not honoured yet. Both controls are always drawn |

`action` is one of `'toggle'`, `'next'`, `'prev'` or `'seek'`. Only `'seek'` carries `value`, the
target position in seconds.

| Return | Type | Description |
|---|---|---|
| `ok` | `boolean` | Whether the slot was set |

Returns `false` when another resource already owns that `appId`. One provider holds the slot at a
time and the most recent claim wins, so a second script calling this with its own `appId` takes over.

**Example**
```lua
CreateThread(function()
    while playing do
        exports['sd-phone']:setExternalNowPlaying('boombox', {
            title    = current.title,
            artist   = current.artist,
            thumb    = current.art,
            playing  = true,
            position = elapsed(),
            duration = current.length,
        }, function(action, value)
            if action == 'toggle' then togglePlayback()
            elseif action == 'next' then skip()
            elseif action == 'seek'  then seekTo(value) end
        end)
        Wait(1000)
    end
end)
```

::: tip
Push once a second at most. Every call re-renders the media surfaces, so a tighter loop buys nothing
and costs frames.
:::

### clearExternalNowPlaying

Gives the slot back, clearing the card everywhere.

**Syntax**
```lua
exports['sd-phone']:clearExternalNowPlaying(appId)
```

Only the resource that claimed an `appId` may clear it, so a stale call from a provider that already
lost the slot cannot wipe the current one. The slot is also released automatically when the owning
resource stops.

::: tip
Server-side exports for messages, mail, calls, contacts, and everything else are documented on the [Server Exports](./exports-server) page.
:::
