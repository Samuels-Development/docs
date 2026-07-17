---
title: Custom Apps
description: Build your own apps for the phone. Any webpage becomes an installable app with one export call, and custom apps written for lb-phone run unmodified.
---

# Custom Apps

Other resources can put their own apps on the phone. An app is just a webpage served from your resource: the phone loads it inside the app frame, injects a small API for popups, notifications, settings and data fetching, and gives it an icon on the home screen, an App Store listing, notification badges, and a launch splash.

Apps written for lb-phone are fully compatible. The registration exports, the injected globals (both capitalizations), the `componentsLoaded` handshake and the message relay all match lb-phone's behaviour, so an existing lb-phone app registers and runs without changes. See [lb-phone Compatibility](./lb-phone-compatibility) for the wider layer.

::: tip Start from a template
[sd-phone-app-templates](https://github.com/Samuels-Development/sd-phone-app-templates) contains four complete example resources, one per stack: plain HTML/CSS/JS, React (JavaScript), React (TypeScript), and Vue 3. Copy one, rename it, and start building. Everything below is demonstrated inside them.
:::

## Registering an app

Call `addCustomApp` from your resource's client script once sd-phone is running.

**Syntax**
```lua
local ok, err = exports['sd-phone']:addCustomApp(app)
```

| Field | Type | Required | Description |
|---|---|---|---|
| `identifier` | `string` | yes | Unique app id, never shown to players. Built-in app ids are reserved |
| `name` | `string` | yes | Display name on the home screen and App Store |
| `description` | `string` | no | App Store description |
| `developer` | `string` | no | App Store provider attribution |
| `defaultApp` | `boolean` | no | `true` = pre-installed for everyone, `false`/absent = downloadable from the App Store |
| `ui` | `string` | no | The app webpage: `resourcename/path/index.html`, or a full `http(s)://` URL (a Vite dev server, or a remote site) |
| `icon` | `string` | no | Icon URL, usually `https://cfx-nui-<resource>/ui/icon.svg`. Without one the phone renders a monogram tile |
| `images` | `string[]` | no | Screenshot URLs for the App Store listing |
| `size` | `number` | no | Cosmetic size in kB shown in the App Store |
| `price` | `number` | no | Displayed price in the App Store |
| `fixBlur` | `boolean` | no | Applies lb-phone's crispness fix; requires rem/em units in your CSS |
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

::: warning Start your resource after sd-phone
Ensure your app resource **after** sd-phone in `server.cfg` (place its `ensure` line below sd-phone's). The `addCustomApp` export only exists once sd-phone has started, so a resource that starts before the phone can fail to register until it is restarted. Starting after sd-phone avoids this entirely.
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

**Render only after `componentsLoaded`.** In game, the phone injects the API globals into your page and then posts the string `componentsLoaded` to your window. Rendering earlier means the globals do not exist yet.

```js
const devMode = !window.invokeNative;

if (window.name === '' || devMode) {
    if (devMode) {
        document.body.style.visibility = 'visible';
        render();
    } else {
        window.addEventListener('message', (e) => {
            if (e.data === 'componentsLoaded') render();
        });
    }
}
```

`window.invokeNative` only exists inside FiveM, which makes it the dev-mode detector: in a plain browser the app renders immediately with mocked data.

## The injected API

After the handshake these globals exist on your page's `window`. Both capitalizations work for every helper (`SetPopUp` and `setPopUp`).

| Global | Description |
|---|---|
| `fetchNui(event, data)` | POSTs to your own resource's `RegisterNUICallback` handlers, returns a Promise |
| `useNuiEvent(action, cb)` | Receives `sendCustomAppMessage` pushes matching `action` |
| `SetPopUp(data)` | Phone-native dialog: `title`, `description`, optional `input`, `buttons` with `cb` callbacks |
| `SetContextMenu(data)` | Phone-native action sheet with `buttons` |
| `SendNotification({ title, content })` | Raises a phone notification and unread badge tied to your app |
| `GetSettings()` / `OnSettingsChange(cb)` | Phone settings; read `settings.display.theme` for light/dark support |
| `SelectGallery` / `SelectEmoji` / `SelectGIF` / `colorPicker` / `contactSelector` | Phone-native pickers, callback style |
| `openMedia({ src })` | Fullscreen image viewer |
| `setApp(name)` | Navigate to another app |
| `createCall({ number })` | Opens the phone dialer |
| `formatPhoneNumber(value)` | Formats a number the way the phone does |
| `components.*` | The namespaced form of everything above, plus `uploadMedia`, `saveToGallery` and `createGameRender` |
| `appName` / `resourceName` / `appIdentifier` | Your app's registered name, owning resource, and identifier |

The TypeScript template ships a `components.d.ts` typing the common surface.

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

## Development workflow

Point the app at a live dev server for hot reload: set `ui_page 'http://localhost:5173'` in your manifest (the templates read `ui_page` back to build the `ui` field), restart your resource, and the phone loads the dev server inside the app frame. Swap back to the built page for production.

## Notes and limits

- `defaultApp = false` apps appear in the App Store for players to install; installs persist across phone reopens. `price` is currently display-only.
- `keepOpen`, `landscape` and `game` are accepted for lb-phone parity but not honoured yet.
- Built-in app identifiers are reserved and `'any'` is reserved for broadcast messages.
- External assets (fonts, CDN images) load normally; media capture helpers (`useCamera`, microphone access) are not available to custom apps yet.
