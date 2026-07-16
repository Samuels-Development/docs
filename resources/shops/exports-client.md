---
title: Client Exports
description: Client-side exports for opening shops, management menus, and blips from other scripts.
---

# Client Exports

Shops Pro provides client-side exports for opening shop and management menus, controlling blips, and managing spawned peds from other scripts. All shop identifiers are the keys defined in `configs/shops.lua` (e.g. `"247store_1"`).

## OpenShop

Open a shop's purchase UI for the local player. Runs the full access pipeline (ban check, job restriction, gang restriction) before opening — exactly as if the player had interacted with the shop ped or register.

**Syntax**
```lua
exports['sd-shops']:OpenShop(shopId)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | The shop key from `configs/shops.lua` (e.g. `"247store_1"`) |

**Example**
```lua
-- Open the 24/7 store when the player presses a key
RegisterCommand('openstore', function()
    exports['sd-shops']:OpenShop('247store_1')
end)
```

::: info
This export does not check opening hours — that gate lives in the ped/register interaction. Calling it directly will open the shop regardless of the configured hours.
:::

## CloseShop

Close the shop purchase UI if it is currently open.

**Syntax**
```lua
exports['sd-shops']:CloseShop()
```

**Example**
```lua
-- Force-close the shop when starting a cutscene
exports['sd-shops']:CloseShop()
```

## OpenManagement

Open the shop management UI for the local player. The player must own the shop (or be an employee with management access), otherwise a notification is shown and the menu does not open.

**Syntax**
```lua
exports['sd-shops']:OpenManagement(shopId, defaultTab)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | The shop key from `configs/shops.lua` |
| `defaultTab` | `string?` | Optional tab to open the menu on (e.g. `"products"`, `"employees"`, `"finances"`). Defaults to the first tab |

**Example**
```lua
-- Open the management menu straight to the employees tab
exports['sd-shops']:OpenManagement('247store_1', 'employees')
```

## CloseManagement

Close the shop management UI if it is currently open.

**Syntax**
```lua
exports['sd-shops']:CloseManagement()
```

## UpdateShopBlip

Create, update, or remove a shop's map blip at runtime. Useful when toggling a shop on/off or changing its appearance from another script.

**Syntax**
```lua
exports['sd-shops']:UpdateShopBlip(shopId, settings)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | The shop key from `configs/shops.lua` |
| `settings` | `table` | Blip settings (see below) |

| Setting | Type | Description |
|---|---|---|
| `blipEnabled` | `boolean` | Set `false` to remove the blip, `true` (or omit) to create/keep it |
| `blipSprite` | `number?` | Blip sprite ID (falls back to the shop's config sprite) |
| `blipColor` | `number?` | Blip color ID (falls back to the shop's config color) |
| `shopName` | `string?` | Blip label text (falls back to the shop's config name) |

::: info
A blip is skipped entirely if `blip.enabled = false` is set for that shop in `configs/shops.lua` — this export will not override a config-disabled blip.
:::

**Example**
```lua
-- Recolor a shop blip and rename it
exports['sd-shops']:UpdateShopBlip('247store_1', {
    blipEnabled = true,
    blipSprite = 52,
    blipColor = 2,
    shopName = 'My Store'
})
```

## CleanupPeds

Delete all spawned shop peds and remove their tracking points. Mainly intended for manual cleanup or debugging.

**Syntax**
```lua
exports['sd-shops']:CleanupPeds()
```

## ReinitializePeds

Clean up all spawned peds and re-create their spawn points from the current config. Useful after changing ped data at runtime.

**Syntax**
```lua
exports['sd-shops']:ReinitializePeds()
```

## Hook Registration

Shops Pro also exposes `registerClientHook` and `unregisterClientHook` for reacting to shop events on the client (e.g. `onShopOpened`, `onShopAccessDenied`). These are documented in detail on the [Client Hooks](./hooks-client) page.

```lua
exports['sd-shops']:registerClientHook('onShopOpened', function(data)
    print(('Shop opened: %s'):format(data.shopName))
end)
```

::: tip
Use exports for one-off actions (opening a menu, updating a blip) rather than in tight loops. For reacting to shop activity, prefer the [hook system](./hooks-client) over polling.
:::
