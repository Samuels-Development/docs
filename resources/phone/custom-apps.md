---
title: Custom Apps
description: Build your own apps for the phone. Any webpage becomes an installable app with one export call, and custom apps written for lb-phone run unmodified.
---

# Custom Apps

Other resources can put their own apps on the phone. An app is just a webpage served from your resource: the phone loads it inside the app frame, injects a small API for popups, notifications, settings and data fetching, and gives it an icon on the home screen, an App Store listing, notification badges, and a launch splash.

Apps written for lb-phone are fully compatible. The registration exports, the injected globals (both capitalizations), the `componentsLoaded` handshake and the message relay all match lb-phone's behaviour, so an existing lb-phone app registers and runs without changes. See [lb-phone Compatibility](./lb-phone-compatibility) for the wider layer.

::: tip Start from a template
[sd-phone-app-templates](https://github.com/Samuels-Development/sd-phone-app-templates) contains five complete example resources, one per stack: plain HTML/CSS/JS, React (JavaScript), React (TypeScript), Vue 3, and Svelte 5. Copy one, rename it, and start building. Everything below is demonstrated inside them.
:::

## Registering an app

Call `addCustomApp` from your resource's client script once sd-phone is running.

::: warning Start your resource after sd-phone
Ensure your app resource **after** sd-phone in `server.cfg` (place its `ensure` line below sd-phone's). The `addCustomApp` export only exists once sd-phone has started, so a resource that starts before the phone can fail to register until it is restarted. Starting after sd-phone avoids this entirely.
:::

**Syntax**
```lua
local ok, err = exports['sd-phone']:addCustomApp(app)
```

::: warning The name is camelCase on this export
`exports['sd-phone']` uses sd-phone's own camelCase names. The PascalCase lb-phone names
(`AddCustomApp`, `RemoveCustomApp`, `SendCustomAppMessage`, `CloseApp`) exist **only** on
`exports['lb-phone']`, never on `exports['sd-phone']`.

Calling `exports['sd-phone']:AddCustomApp(...)` indexes a nil and throws. If your registration
sits behind a `pcall` and a retry loop, that throw is easy to misread as "the phone has not
started yet", and the loop will retry until it gives up even though sd-phone was ready the whole
time. See [Supporting both phones](#supporting-both-phones).
:::

| Field | Type | Required | Description |
|---|---|---|---|
| `identifier` | `string` | yes | Unique app id, never shown to players. Built-in app ids are reserved |
| `name` | `string` | yes | Display name on the home screen and App Store |
| `description` | `string` | no | App Store description |
| `developer` | `string` | no | App Store provider attribution |
| `defaultApp` | `boolean` | no | `true` = pre-installed for everyone, `false`/absent = downloadable from the App Store |
| `devices` | `string` \| `string[]` | no | Devices that list the app: `'phone'`, `'tablet'`. Absent = every device. See [Limiting who sees an app](#limiting-who-sees-an-app) |
| `job` | `string` \| `string[]` \| `table` | no | Jobs that see the app, optionally with a minimum grade. Absent = everyone. **Cosmetic only.** See [Limiting who sees an app](#limiting-who-sees-an-app) |
| `requires` | `table` | no | Hide the app until the player clears a gate: an item, player metadata, a job, or your own export. **Cosmetic only.** See [`requires`](#requires) |
| `ui` | `string` | no | The app webpage: `resourcename/path/index.html`, or a full `http(s)://` URL (a Vite dev server, or a remote site) |
| `icon` | `string` | no | Icon URL, usually `https://cfx-nui-<resource>/ui/icon.svg`. Without one the phone renders a monogram tile |
| `images` | `string[]` | no | Screenshot URLs for the App Store listing |
| `widgets` | `table[]` | no | Home screen widgets your app offers. See [Home screen widgets](#home-screen-widgets) |
| `lockscreenWidgets` | `table[]` | no | Cards your app can push onto the lock screen. See [Lock screen widgets](#lock-screen-widgets) |
| `wifi` | `string` | no | Network id from `configs/wifi.lua`; the app is only downloadable on that network. Needs `defaultApp` off, since it gates the **download**. UI-only for custom apps |
| `size` | `number` | no | Cosmetic size in kB shown in the App Store |
| `price` | `number` | no | Displayed price in the App Store |
| `fixBlur` | `boolean` | no | Applies lb-phone's crispness fix; requires rem/em units in your CSS |
| `game`<br>`keepOpen`<br>`landscape` | `boolean` | no | Accepted for lb-phone parity, not honoured yet. See [Notes and limits](#notes-and-limits) |
| `onOpen` | `function` | no | Fired when the player opens the app. `onUse` works as an alias |
| `onClose` | `function` | no | Fired when the player closes the app |
| `onDelete` | `function` | no | Fired when the player uninstalls the app |

| Return | Type | Description |
|---|---|---|
| `ok` | `boolean` | Whether the app was registered |
| `err` | `string?` | Reason when `ok` is false |

Registrations live in sd-phone's memory, so register once the phone is started and again whenever it restarts:

```lua
local function register()
    local ok, err = exports['sd-phone']:addCustomApp({
        identifier  = 'my-app',
        name        = 'My App',
        description = 'Does something great.',
        defaultApp  = true,
        ui          = GetCurrentResourceName() .. '/ui/index.html',
        icon        = ('https://cfx-nui-%s/ui/icon.svg'):format(GetCurrentResourceName()),
        onOpen      = function() print('opened') end,
        onClose     = function() print('closed') end,
    })
    if not ok then print('registration failed:', err) end
end

CreateThread(function()
    while GetResourceState('sd-phone') ~= 'started' do Wait(500) end
    Wait(1000)
    register()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= 'sd-phone' then return end
    Wait(1000)
    register()
end)
```

Re-registering the same identifier from the same resource replaces it, so calling `register()` twice is safe. Apps are removed automatically when your resource stops, or explicitly:

```lua
exports['sd-phone']:removeCustomApp('my-app')
```

### Every field at once

Nothing below is required beyond `identifier` and `name`. This is a reference, not a template to copy
wholesale — most apps set five or six of these.

```lua
exports['sd-phone']:addCustomApp({
    -- Identity
    identifier  = 'my-app',                       -- unique; built-in ids are reserved
    name        = 'My App',
    description = 'Does something great.',
    developer   = 'My Studio',

    -- Where it lives
    ui          = GetCurrentResourceName() .. '/ui/index.html',
    icon        = ('https://cfx-nui-%s/ui/icon.svg'):format(GetCurrentResourceName()),

    -- App Store presentation
    defaultApp  = true,                           -- pre-installed; false = downloadable
    images      = {                               -- screenshots on the listing
        ('https://cfx-nui-%s/ui/shot1.png'):format(GetCurrentResourceName()),
    },
    size        = 24,                             -- cosmetic kB
    price       = 0,

    -- Who sees it
    devices     = { 'phone', 'tablet' },          -- absent = every device
    job         = { police = 3 },                 -- name, array, or name = minimum grade
    requires    = {                               -- every condition must pass
        item     = 'usb_drive',
        metadata = { vip = true },
        jobs     = { police = 3, ambulance = 0 },
        check    = 'my_resource.canSeeApp',
        consume  = false,                         -- true = permanent unlock instead of a live check
    },
    wifi        = 'mazebank',                     -- needs defaultApp = false to mean anything

    -- Home screen widgets
    widgets     = {
        {
            id    = 'summary',                    -- defaults to a slug of `name`
            name  = 'Summary',
            ui    = GetCurrentResourceName() .. '/ui/widget.html',
            sizes = { 'sm', 'md', 'lg' },         -- absent = all three
            interactive = false,                  -- true = real pointer events
        },
    },

    -- Lock screen cards, pushed with showLockscreenWidget
    lockscreenWidgets = {
        {
            id          = 'ride',
            name        = 'Ride',
            ui          = GetCurrentResourceName() .. '/ui/lock.html',
            height      = 84,                     -- px, clamped to 48-240
            interactive = false,
        },
    },

    -- Rendering
    fixBlur     = true,                           -- needs rem/em units in your CSS
    game        = false,                          -- accepted for lb-phone parity, not honoured yet
    keepOpen    = false,                          -- ditto
    landscape   = false,                          -- ditto

    -- Lifecycle
    onOpen      = function() end,                 -- `onUse` is an accepted alias
    onClose     = function() end,
    onDelete    = function() end,
})
```

::: tip Setting `job` and `requires` together
Both apply, and both have to pass. `job` is the older field and is kept for lb-phone parity;
`requires.jobs` does the same thing with the rest of the gate vocabulary available alongside it, so
prefer `requires` for anything new.
:::

## The app webpage

Whitelist your UI files in `fxmanifest.lua` and declare a `ui_page`:

```lua
files { 'ui/**/*' }
ui_page 'ui/index.html'
```

Two rules apply to every app page:

**Keep the body hidden and transparent by default.** FiveM renders every resource's `ui_page` as a fullscreen overlay in the game at all times. Your stylesheet must set `visibility: hidden` on `html, body` so that overlay never paints over the game, and the body background must stay transparent: a background color on `html` or `body` is painted onto the page canvas even while the element is hidden, which floods the whole game screen with that color. Put your background color on a wrapper element instead (the templates use the `#root` / `#app` mount node). The phone reveals the body when it loads your page inside the app frame; your dev-mode branch reveals it in a plain browser.

```css
html, body {
    visibility: hidden;
    background: transparent;
}
```

**Render only after `componentsLoaded`.** In game, the phone injects the API globals into your page and then posts the string `componentsLoaded` to your window. The injection happens *after* your page has loaded, so none of the globals exist while your own scripts are parsing. Touching one at that point throws `ReferenceError`.

Wait on both signals the phone gives. The posted string fires once, so a page that attaches its listener late never hears it; the `componentsLoaded` flag covers that case because a poll can re-read it. Racing the two is the only form that is correct whether the phone is fast or slow:

```js
const devMode = !window.invokeNative;

function whenReady() {
    return new Promise((resolve) => {
        if (window.componentsLoaded) return resolve();

        const poll = setInterval(() => {
            if (window.componentsLoaded) { clearInterval(poll); resolve(); }
        }, 50);

        window.addEventListener('message', (e) => {
            if (e.data === 'componentsLoaded') { clearInterval(poll); resolve(); }
        });
    });
}

if (devMode) {
    document.body.style.visibility = 'visible';
    render();
} else {
    whenReady().then(render);
}
```

A listener on its own is the common mistake, and it fails intermittently: it works on a slow phone and breaks on a fast one, which makes it painful to reproduce. Registering DOM event handlers at parse time is fine, because they only reach for the globals once something is clicked.

`window.invokeNative` only exists inside FiveM, which makes it the dev-mode detector: in a plain browser the app renders immediately with mocked data.

## The injected API

After the handshake these globals exist on your page's `window`. Both capitalizations work for every helper (`SetPopUp` and `setPopUp`).

| Global | Description |
|---|---|
| `fetchNui(event, data)` | POSTs to your own resource's `RegisterNUICallback` handlers, returns a Promise. Resolves `undefined` on any failure |
| `fetchNuiStrict(event, data)` | As `fetchNui`, but rejects instead of swallowing, so a failed call is distinguishable from a handler that returned nothing |
| `useNuiEvent(action, cb)` | Receives `sendCustomAppMessage` pushes matching `action`. Returns an unsubscribe function |
| `SetPopUp(data)` | Phone-native dialog: `title`, `description`, optional `input`, `buttons` with `cb` callbacks |
| `SetContextMenu(data)` | Phone-native action sheet with `buttons` |
| `SendNotification({ title, content })` | Raises a phone notification and unread badge tied to your app |
| `GetSettings()`<br>`OnSettingsChange(cb)` | Phone settings; read `settings.display.theme` for light/dark support |
| `SelectGallery`<br>`SelectEmoji`<br>`SelectGIF`<br>`colorPicker`<br>`contactSelector` | Phone-native pickers. Each takes a callback *and* resolves the same value, so `await` works too |
| `UseCamera()` | Opens the phone's camera. Resolves the uploaded photo URL, or `null` if the player backs out |
| `ShowConfirm(text)` | Yes/no dialog over `SetPopUp`, resolving a boolean |
| `GetPhoneNumber()` | The acting character's number, or `null` when it cannot be resolved |
| `GetStorage(key, fallback)`<br>`SetStorage(key, value)` | Per-app persistence, JSON in and out |
| `OnAppOpen(cb)`<br>`OnAppClose(cb)` | Fires as your app is foregrounded and backgrounded |
| `componentsSupports(name)` | Feature test that accounts for stubs; see below |
| `openMedia({ src })` | Fullscreen image viewer |
| `setApp(name)` | Navigate to another app |
| `createCall({ number })` | Opens the phone dialer |
| `formatPhoneNumber(value)` | Formats a number the way the phone does |
| `components.*` | lb-phone's own component vocabulary, for apps ported straight across: `setPopUp`, `setContextMenu`, `setGallery`, `setColorPicker`, `setContactSelector`, `setContactModal`, `setEmojiPickerVisible`, `setGifPickerVisible`, `setMusicSelector`, `setShareComponent`, `setFullscreenImage`, `setHomeIndicatorVisible`, `GameMap`, plus `uploadMedia`, `saveToGallery` and `createGameRender`. These are **not** camelCase aliases of the globals above — `components.setGallery` is what the global `SelectGallery` wraps |
| `appName`<br>`resourceName`<br>`appIdentifier` | Your app's registered name, owning resource, and identifier |

Types for the whole surface ship with the phone at `web/build/sdphone-sdk.d.ts`. Copy it next to your app source for autocomplete and type checking; it carries the same version as the API it describes, so it cannot drift from the phone you are running.

### Feature detection

`typeof UseCamera === 'function'` is not a reliable test. A handful of names exist as callable functions but are not implemented by the host and simply resolve `null` — `SetContactModal` is one today. `componentsSupports()` accounts for that:

```js
if (componentsSupports('UseCamera')) {
    const photo = await UseCamera();
}
```

`componentsUnsupported` is the frozen list of those names, and `componentsVersion` is bumped whenever the surface changes. Because the phone serves the API to your page, the two can never disagree: whatever your app can see, the phone implements.

### Storage

`SetStorage` and `GetStorage` give your app a namespaced key/value store, JSON-encoded on the way in and decoded on the way out:

```js
await SetStorage('prefs', { sort: 'newest', compact: true });
const prefs = await GetStorage('prefs', { sort: 'newest' });
```

Pass `null` as the value to delete a key. `GetStorage` returns the fallback when the key is missing or unreadable.

Two things to design around. It is **device-local**, so it does not follow a character between machines and a cleared cache loses it — persist anything that matters server-side through your own resource. And each app has a budget of **64 KB across 64 keys**; a write that would exceed it is refused and `SetStorage` resolves `false` rather than throwing. Check the return value if you store anything unbounded.

### Lifecycle

A backgrounded app is not unloaded. The player can switch away and the page keeps running, timers and all, so an app that polls will keep polling off-screen. `OnAppOpen` and `OnAppClose` are how you notice:

```js
const stop = OnAppClose(() => clearInterval(pollTimer));
```

Both return an unsubscribe function.

## Talking between Lua and the UI

The UI pulls data with `fetchNui`, answered by `RegisterNUICallback` in your client script:

```lua
RegisterNUICallback('getDashboard', function(_, cb)
    cb({ balance = 5000 })
end)
```

```js
const data = await fetchNui('getDashboard');
```

Lua pushes data to the UI with `sendCustomAppMessage`, received by `useNuiEvent`:

```lua
exports['sd-phone']:sendCustomAppMessage('my-app', {
    action = 'balanceChanged',
    data = { balance = 4200 },
})
```

```js
useNuiEvent('balanceChanged', (data) => setBalance(data.balance));
```

Do not push initial data from `onOpen`; the page may still be loading when it fires. Let the UI pull on mount instead.

## Limiting who sees an app

Three optional fields decide whether the app's icon is drawn. Leave any of them out and it does not
restrict anything.

### `devices`

Some apps only make sense on one device. `devices` is an allow-list of device ids, matched
case-insensitively:

```lua
devices = 'tablet'              -- tablet only
devices = { 'phone', 'tablet' } -- both, same as leaving it out
```

Current ids are `phone` and `tablet`. An empty list is treated as "no restriction" rather than
"no devices", so a mistake never silently hides your app everywhere.

### `job`

`job` restricts the app to one or more jobs, in whichever of these shapes suits you:

```lua
job = 'police'                            -- one job, any grade
job = { 'police', 'ambulance' }           -- several jobs, any grade
job = { police = 3, ambulance = 0 }       -- minimum grade per job
```

The icon appears and disappears as the player's job changes; there is nothing to poll and nothing
to re-register. Before the framework has loaded a job for the player, gated apps are hidden.

### `requires`

`requires` hides the app until the player clears a gate. It takes the same conditions the phone's own
built-in apps use in `configs/apps.lua`, so a third-party app gates exactly like a first-party one.

The **server** answers it, and the client is only ever told the result. An app the player cannot see
never reaches their phone at all — not its identifier, not its name, not the item that would unlock
it. That makes `requires` the right field for an app that is meant to be a secret, where `job` and
`devices` only decide what is drawn from a list the phone already holds.

Every condition present has to pass:

```lua
requires = {
    item     = 'usb_drive',              -- hold at least one
    metadata = { vip = true },           -- framework player metadata
    jobs     = { police = 3 },           -- a job, at a minimum grade
    check    = 'my_resource.canSeeApp',  -- your own server export
}
```

#### `item`

```lua
item = 'usb_drive'                                      -- hold at least one
item = { name = 'usb_drive', count = 3 }                -- hold at least three
item = { name = 'usb_drive', metadata = { tier = 3 } }  -- hold one whose slot metadata matches
```

Metadata matching needs an inventory that exposes per-slot metadata (ox_inventory does). On one that
does not, the condition falls back to a plain count rather than refusing every player.

#### `metadata`

Framework player metadata, each key compared to the value you give:

```lua
metadata = { vip = true, licence_hacking = true }
```

QBCore and QBox read `PlayerData.metadata`. ESX needs `getMeta`, added in ESX 1.10; on older builds
there is no metadata store to read and the condition never passes.

#### `jobs`

The same shapes as `job` above:

```lua
jobs = 'police'
jobs = { 'police', 'ambulance' }
jobs = { police = 3, ambulance = 0 }   -- a police sergeant OR any medic
```

#### `check`

Anything the fields above cannot express. Your export is called as `(source, appId)`:

```lua
-- In YOUR resource, server side.
exports('canSeeApp', function(source, appId)
    return isHacker(source)
end)
```

Only a literal `true` opens the gate. An error inside the export, a `nil` return, or a resource that
is not started all keep the app hidden, and the phone logs the reason once to the server console.

#### Permanent unlocks

`consume = true` swaps the **item** check for a permanent per-character unlock. Every other condition
in the same table stays live:

```lua
requires = { consume = true }                          -- unlocked entirely by your script
requires = { consume = true, jobs = { police = 0 } }   -- unlocked, and still police-only
```

Grant and revoke it from your own server code:

```lua
exports['sd-phone']:unlockApp(source, 'my_app')
exports['sd-phone']:revokeApp(source, 'my_app')
local owned = exports['sd-phone']:hasAppUnlock(source, 'my_app')
```

The unlock is stored against the character and survives relogs, restarts and an empty inventory.

::: tip Built-in apps can spend an item for you
For an app in `configs/apps.lua`, `requires = { item = 'usb', consume = true }` makes the phone
register that item as usable and spend it on use. A custom app cannot get that automatically — the
phone will not let a client-side registration claim which item unlocks what — so call `unlockApp`
from your own usable-item handler instead.
:::

#### When it re-evaluates

On every phone open, on every job change, and immediately whenever you grant or revoke an unlock.
Picking an item up with the phone closed means the app is there when the player next opens it.

::: danger These fields are cosmetic. They are not security.
`job` and `requires` decide whether an **icon is drawn**. They do not protect anything behind it.

A player can trigger your resource's events and call your callbacks directly, whether or not the
phone ever drew your icon for them. Anything that matters must be checked **server-side**, in your
own resource:

```lua
-- In YOUR resource, server side. Do not rely on the icon being hidden.
lib.callback.register('my-app:server:doThing', function(source)
    if not hasPoliceJob(source) then return false end
    -- ...
end)
```

Treat `job` and `requires` as a way to keep home screens tidy, not as an access control list. This
holds even for a `requires` the player has never cleared: the phone never drew the icon, but nothing
stops them calling your resource directly if they learn the event name.
:::

## Home screen widgets

An app can offer widgets that sit on the home screen next to the built-in ones. The player adds them
from the widget gallery; each is a separate page of yours, framed at the size they chose.

```lua
widgets = {
    {
        id    = 'summary',                                   -- optional, defaults to a slug of `name`
        name  = 'Summary',                                   -- required, shown in the gallery
        ui    = GetCurrentResourceName() .. '/ui/widget.html', -- required
        sizes = { 'sm', 'md', 'lg' },                        -- optional, absent means all three
        interactive = false,                                 -- optional, see Interactive widgets below
    },
}
```

A widget with no `name`, no `ui`, or no usable size is skipped with a debug line rather than failing
the whole registration. Duplicate ids within one app are dropped. A widget cannot frame sd-phone
itself.

### What your widget page receives

The size and geometry arrive twice — as query parameters on the URL, and again as a `postMessage`
whenever they change:

```js
const params = new URLSearchParams(location.search);
params.get('app');     // your app identifier
params.get('widget');  // this widget's id
params.get('size');    // 'sm' | 'md' | 'lg'
params.get('width');   // px
params.get('height');  // px

window.addEventListener('message', (e) => {
    if (e.data?.type !== 'sd-phone:widget') return;
    const { size, width, height, theme } = e.data;   // theme is 'light' | 'dark'
});
```

The message fires on load and again on any size or theme change, so treat it as the source of truth
and the query string as the first paint.

Two more things to design around. A widget renders **while your app is closed**, so it cannot rely on
state the app set up — fetch what it needs itself. And it is framed with a `no-referrer` policy in a
sandbox allowing scripts and same-origin only, so treat it as a small standalone page.

If the owning resource stops, or the widget id disappears from a later registration, the tile stays
on the player's home screen showing "Not available" rather than vanishing.

### Interactive widgets

By default a widget is display-only: its frame is rendered with `pointer-events: none`, taps fall
through to the tile and open your app, and your page cannot have working buttons. That is still the
default, so widgets written before this existed behave exactly as they did.

Set `interactive = true` to receive real pointer events instead:

```lua
widgets = {
    { name = 'Controls', ui = UI('widget.html'), interactive = true },
}
```

The trade is that your page now swallows every gesture over it, because a cross-origin frame's
events never reach the page hosting it. Two home screen behaviours stop working on their own, and
your page has to hand them back:

```js
// Treat this like a tap on the tile: opens your app, zooming out of the widget.
window.parent.postMessage({ type: 'sd-phone:widget:open' }, '*');

// Enter the home screen's rearrange mode, as a long press on the tile would.
window.parent.postMessage({ type: 'sd-phone:widget:longpress' }, '*');
```

Wire the second one to your own long-press detection, otherwise a widget that fills its tile cannot
be moved or removed without the player long-pressing somewhere else on the home screen first.

Both messages are ignored unless the home screen is the view in front, so a widget cannot pull a
player out of an app they are using, and repeats inside half a second are dropped. The frame also
goes inert while the home screen is in rearrange mode, so drag and drop keeps working.

::: warning What an interactive widget gives up
Gestures that start on your page no longer reach the home screen. Swiping across a wide interactive
widget will not turn the page, and a widget inside a stack cannot be scrolled to the next card.
Prefer the smallest size that fits your controls, and leave a margin your page does not handle.
:::

## Lock screen widgets

A lock screen widget is a card your resource pushes onto the lock screen, above the notification
stack. The player never places it and it has no gallery entry: you show it when it is relevant and
hide it when it is not, which suits a ride in progress, an active job, or a countdown.

Declare them alongside `widgets`:

```lua
lockscreenWidgets = {
    {
        id          = 'ride',                                  -- optional, defaults to a slug of `name`
        name        = 'Ride',                                  -- optional, defaults to a positional name
        ui          = GetCurrentResourceName() .. '/ui/lock.html', -- required
        height      = 84,                                      -- optional, px, clamped to 48-240
        interactive = true,                                    -- optional, off by default
    },
}
```

Declaring one does not show it. Push it with
[`showLockscreenWidget`](/resources/phone/exports-client#showlockscreenwidget) and take it away with
[`hideLockscreenWidget`](/resources/phone/exports-client#hidelockscreenwidget). Cards from a resource
that stops are removed for you.

Like home screen widgets, the frame is inert unless you set `interactive = true`. Leave it off for a
card that only displays, so the player can still scroll their notifications past it.

### What your lock screen page receives

```js
const params = new URLSearchParams(location.search);
params.get('app');      // your app identifier
params.get('widget');   // this widget's id
params.get('surface');  // always 'lockscreen'

window.addEventListener('message', (e) => {
    if (e.data?.type !== 'sd-phone:lockscreen-widget') return;
    const { key, data } = e.data;   // `data` is the payload you passed to showLockscreenWidget
});
```

The message fires on load and again on every `showLockscreenWidget` call, so pushing an update is
just calling that export again with a new payload.

An interactive card relays interactions back to your `onAction` handler:

```js
window.parent.postMessage({
    type: 'sd-phone:lockscreenWidget:action',
    action: 'cancel',
    value: 1,
}, '*');
```

`action` and `value` arrive as the first two arguments of the `onAction` you passed to
`showLockscreenWidget`, with any `data` field as the third.

::: warning The phone is locked
This renders in front of the passcode and Face ID gate. Anything on the card is readable by whoever
is holding the phone, so keep private detail out of it and never put an action there that you would
gate behind the lock.
:::

## Development workflow

Point the app at a live dev server for hot reload: set `ui_page 'http://localhost:5173'` in your manifest (the templates read `ui_page` back to build the `ui` field), restart your resource, and the phone loads the dev server inside the app frame. Swap back to the built page for production.

::: warning `ui_page` also renders your page over the game
FiveM treats `ui_page` as your resource's **own** NUI overlay, mounted on top of the game at all
times. The phone does not need it: listing the page in `files{}` is what serves it over
`https://cfx-nui-<resource>/...`, which is all the `ui` field resolves to.

A page with a transparent background hides this. One with a solid full-height background covers the
player's whole screen, with the phone closed and nothing to dismiss. If you keep `ui_page` for the
hot-reload convenience above, either keep the page transparent or drop the field and pass the path
to `addCustomApp` as a literal:

```lua
ui = GetCurrentResourceName() .. '/ui/index.html',
```
:::

## Supporting both phones

If you are shipping an app that should work on sd-phone **and** lb-phone, do not detect which one is
running. Call `exports['lb-phone']` unconditionally and use lb-phone's PascalCase names.

```lua
-- Works on both. sd-phone answers this through its compatibility layer.
local ok, err = exports['lb-phone']:AddCustomApp(app)
```

This works because of how FiveM resolves exports, not because of `provide`. Indexing
`exports['lb-phone'].AddCustomApp` fires a `__cfx_export_lb-phone_AddCustomApp` event and uses
whichever handler answers. On a server running only sd-phone, that handler is sd-phone's
compatibility layer, and every lb-shaped export listed under
[export coverage](./lb-phone-compatibility#export-coverage) answers. On a server running the real
lb-phone it is lb-phone. **No resource named `lb-phone` has to exist for this to work.**

::: danger Do not gate on `GetResourceState('lb-phone')`
`provide 'lb-phone'` does **not** make `GetResourceState('lb-phone')` report `started`. It only
satisfies other resources' `dependency 'lb-phone'` declarations. On a server running just sd-phone
that state reads as missing, so a readiness check written against it will wait forever and never
call an export that would have answered immediately.

Check the real resource instead, and call the alias regardless:

```lua
local function phoneStarted()
    return GetResourceState('sd-phone') == 'started'
        or GetResourceState('lb-phone') == 'started'
end
```
:::

The trap is doing it the other way around: resolving *which* phone is running and then calling
lb-shaped names on whichever one you found. That works for lb-phone and throws for sd-phone, because
the names differ per namespace:

| Called on `exports['lb-phone']` | Equivalent on `exports['sd-phone']` |
| --- | --- |
| `AddCustomApp` | `addCustomApp` |
| `RemoveCustomApp` | `removeCustomApp` |
| `SendCustomAppMessage` | `sendCustomAppMessage` |
| `CloseApp` | `close` |

Note the last row. It is not a pure case difference, so lowercasing the first letter is not a safe
shim.

Two things to know before you rely on this path:

- The compatibility layer is on by default but an admin can switch it off with
  `set sd_phone_lbcompat "false"`, which takes the `lb-phone` exports with it. If your app targets
  sd-phone specifically rather than both phones, prefer sd-phone's own camelCase names.
- Restarting the phone strands consumers that already resolved an `exports['lb-phone']` function,
  until those consumers restart too. See the
  [restart caveat](./lb-phone-compatibility#enabling-and-disabling). During development, restart
  your app resource after restarting the phone.

::: danger A leftover lb-phone folder disables the layer, even stopped
sd-phone's compatibility layer stands down on purpose when it finds any resource named `lb-phone`
that is not its own shim, so that it never competes with a real lb-phone. That check enumerates
resources rather than reading their state, so a folder that is present but **never started** is
enough to switch the layer off, and with it every `exports['lb-phone']` name.

The symptom is registration that retries and gives up while the phone is plainly running. Move any
old lb-phone folder out of `resources/` entirely rather than merely leaving it unstarted.
:::

## Notes and limits

- `defaultApp = false` apps appear in the App Store for players to install; installs persist across phone reopens. `price` is currently display-only.
- `keepOpen`, `landscape` and `game` are accepted for lb-phone parity but not honoured yet.
- Built-in app identifiers are reserved and `'any'` is reserved for broadcast messages.
- External assets (fonts, CDN images) load normally; media capture helpers (`useCamera`, microphone access) are not available to custom apps yet.
