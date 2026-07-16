---
title: Server Exports
description: Server-side exports for querying shop ownership, permissions, and shop data from other scripts.
---

# Server Exports

Shops Pro provides server-side exports for querying shop ownership, checking management permissions, validating items, and reading or writing shop data. All shop identifiers are the keys defined in `configs/shops.lua` (e.g. `"247store_1"`).

## CheckShopOwnership

Check whether a player owns a specific shop.

**Syntax**
```lua
local owns = exports['sd-shops']:CheckShopOwnership(source, shopId)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `shopId` | `string` | The shop key from `configs/shops.lua` |

| Return | Type | Description |
|---|---|---|
| `owns` | `boolean` | `true` if the player is the registered owner of the shop |

**Example**
```lua
if exports['sd-shops']:CheckShopOwnership(source, '247store_1') then
    print('Player owns the 24/7 store')
end
```

## HasPermission

Check whether a player has a specific shop management permission. The owner always passes; employees must have the permission granted to them.

**Syntax**
```lua
local allowed = exports['sd-shops']:HasPermission(source, shopId, permission)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `shopId` | `string` | The shop key from `configs/shops.lua` |
| `permission` | `string` | The permission name to check (see `configs/management.lua`) |

| Return | Type | Description |
|---|---|---|
| `allowed` | `boolean` | `true` if the player owns the shop or has the permission as an employee |

**Example**
```lua
if exports['sd-shops']:HasPermission(source, '247store_1', 'manage_stock') then
    -- allow the player to adjust stock
end
```

## GetShopData

Retrieve the stored data for an owned shop (settings, stock, employees, finances, etc.) from the database.

**Syntax**
```lua
local shopData = exports['sd-shops']:GetShopData(shopId)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | The shop key from `configs/shops.lua` |

| Return | Type | Description |
|---|---|---|
| `shopData` | `table?` | The stored shop data table, or `nil` if the shop has no database record |

**Example**
```lua
local data = exports['sd-shops']:GetShopData('247store_1')
if data then
    print('Shop has been purchased and has stored data')
end
```

## UpdateShopData

Write shop data back to the database. If the shop has no record yet, a system-owned record is created automatically.

**Syntax**
```lua
local success = exports['sd-shops']:UpdateShopData(shopId, shopData)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | The shop key from `configs/shops.lua` |
| `shopData` | `table` | The shop data table to save |

| Return | Type | Description |
|---|---|---|
| `success` | `boolean` | `true` if the data was saved (or the record created) successfully |

**Example**
```lua
local data = exports['sd-shops']:GetShopData('247store_1')
if data then
    data.someCustomField = true
    exports['sd-shops']:UpdateShopData('247store_1', data)
end
```

::: warning
`GetShopData` / `UpdateShopData` operate on the raw stored shop data. Read the current data, modify only the fields you need, and write it back — overwriting with a partial table will discard the rest of the shop's state.
:::

## IsItemAllowed

Check whether an item is allowed to be stocked/ordered in a shop, based on that shop's product whitelist (per-shop override, or the shop type whitelist from `configs/management.lua`).

**Syntax**
```lua
local allowed = exports['sd-shops']:IsItemAllowed(shopId, itemName)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | The shop key from `configs/shops.lua` |
| `itemName` | `string` | The item spawn name to check |

| Return | Type | Description |
|---|---|---|
| `allowed` | `boolean` | `true` if the item is in the shop's whitelist (or no whitelist is defined) |

**Example**
```lua
if exports['sd-shops']:IsItemAllowed('247store_1', 'water') then
    print('Water can be stocked at this shop')
end
```

## Hook Registration

Shops Pro also exposes `registerServerHook` and `unregisterServerHook` for reacting to (and in some cases blocking) shop events on the server (e.g. `onShopPurchase`, `onItemPurchase`). These are documented in detail on the [Server Hooks](./hooks-server) page.

```lua
exports['sd-shops']:registerServerHook('onItemPurchase', function(data)
    print(('Player %s bought %s'):format(data.source, data.itemName))
end)
```

::: tip
Use `CheckShopOwnership` and `HasPermission` to gate your own shop-related features behind the same ownership and permission rules the script uses internally.
:::
