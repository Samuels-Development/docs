---
title: Management Configuration
description: Configure shop ownership, upgrades, product whitelists, employee permissions, and stock delivery in Shops Pro.
---

# Management Configuration

The management configuration file (`configs/management.lua`) controls everything related to shop ownership, employee management, upgrades, product whitelists, stock delivery, and permissions. The file returns a single table.

::: info Config File Location
All options documented on this page are in `configs/management.lua`.
:::

## Inventory Management Features

```lua
InventoryManagement = {
    enableAddFromInventory = true,
    enableWithdrawFromStock = true,
    requireStockToAddProduct = true,
}
```

| Option | Type | Default | Description |
|---|---|---|---|
| `enableAddFromInventory` | `boolean` | `true` | Show "Add from Inventory" button in stock management |
| `enableWithdrawFromStock` | `boolean` | `true` | Show "Withdraw from Stock" button in stock management |
| `requireStockToAddProduct` | `boolean` | `true` | If `true`, items with 0 stock will not appear in the Add Product modal (prevents adding non-orderable items as products until they are in stock) |

## Stock Capacity

```lua
StockCapacity = 5000
```

Maximum total stock capacity across all items in the shop. Set to `0` or `nil` for unlimited capacity (this also disables the stock capacity upgrade).

## Product Slots

```lua
ProductSlots = 5
```

Maximum number of different products that can be sold in the shop. Set to `0` or `nil` for unlimited product slots (this also disables the product slots upgrade).

## Employee Slots

```lua
EmployeeSlots = 3
```

Maximum number of employees that can be hired for the shop. Set to `0` or `nil` for unlimited employee slots (this also disables the employee slots upgrade).

## Network/Franchise System

```lua
NetworkSystem = {
    enabled = false,
    requireUpgrade = true,
}
```

::: warning Work In Progress
The network/franchise system is still a work in progress. Keep this set to `false`.
:::

## Purchase Restrictions

```lua
PurchaseRestrictions = {
    enabled = false,
    allowedIdentifiers = {
        -- 'XV3T39I3',
        -- 'XYZ98765',
    },
}
```

When enabled, only whitelisted character identifiers can purchase shops.

| Option | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `false` | Enable purchase restriction whitelist |
| `allowedIdentifiers` | `table` | `{}` | List of allowed character identifiers (QBCore: CitizenID, ESX: Character identifier) |

::: tip
Individual shops can override this with their own `purchaseRestrictions` table in `configs/shops.lua`.
:::

## Ownership Limits

```lua
OwnershipLimits = {
    enabled = false,
    maxShops = 1,
}
```

| Option | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `false` | Enable ownership limits |
| `maxShops` | `number` | `1` | Maximum number of shops one player can own |

## Shop Selling

```lua
SellShop = {
    enabled = true,
}
```

| Option | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `true` | Allow shop owners to sell their shops back to the server. When `false`, hides the option in the Danger Zone |

## Shop Transfer

```lua
TransferShop = {
    enabled = true,
    restrictions = {
        enabled = false,
        usePurchaseRestrictions = false,
        allowedIdentifiers = {},
    },
}
```

| Option | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `true` | Allow shop owners to transfer ownership to other players |
| `restrictions.enabled` | `boolean` | `false` | Enable transfer recipient whitelist |
| `restrictions.usePurchaseRestrictions` | `boolean` | `false` | If `true`, uses the same identifiers from `PurchaseRestrictions.allowedIdentifiers` |
| `restrictions.allowedIdentifiers` | `table` | `{}` | Separate list of allowed transfer recipient identifiers (only used if `usePurchaseRestrictions = false`) |

## Settings Menu

```lua
SettingsOptions = {
    general = {
        enabled = true,
        shopName = true,
        blipEnabled = true,
        blipColor = true,
        blipSprite = true,
    },
    openingHours = {
        enabled = true,
        configure = true,
    },
}
```

Controls which settings are available in the management menu for shop owners.

### General Settings

| Option | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `true` | Show or hide the entire General Settings block |
| `shopName` | `boolean` | `true` | Allow changing the shop name |
| `blipEnabled` | `boolean` | `true` | Allow toggling the map blip |
| `blipColor` | `boolean` | `true` | Allow changing blip color |
| `blipSprite` | `boolean` | `true` | Allow changing blip sprite |

### Opening Hours

| Option | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `true` | Show or hide the Opening Hours block |
| `configure` | `boolean` | `true` | Allow configuring opening hours |

## Available Jobs

```lua
Jobs = {
    { value = 'police', label = 'Police Department' },
    { value = 'ambulance', label = 'Emergency Medical Services' },
    { value = 'mechanic', label = 'Mechanic' },
    -- ... more jobs
}
```

List of jobs available for product restrictions in the management UI. Shop owners can restrict items to specific jobs when adding/editing products.

## Available Gangs

```lua
Gangs = {
    { value = 'ballas', label = 'Ballas' },
    { value = 'vagos', label = 'Vagos' },
    -- ... more gangs
}
```

List of gangs available for product restrictions in the management UI.

## Available Licenses

```lua
AvailableLicenses = {
    { value = 'weapon', label = 'Weapon License' },
    { value = 'driver', label = 'Driver License' },
    { value = 'hunting', label = 'Hunting License' },
    { value = 'fishing', label = 'Fishing License' },
    { value = 'business', label = 'Business License' },
    { value = 'pilot', label = 'Pilot License' },
    { value = 'boat', label = 'Boat License' },
}
```

Licenses that shop owners can require customers to have when purchasing certain products. These must match the license types used by your server's license system.

## Shop Upgrades

```lua
Upgrades = {
    stock_capacity = {
        enabled = true,
        name = 'Max Stock Capacity',
        description = '...',
        icon = 'box',
        levels = {
            { level = 1, cost = 10000, capacityIncrease = 100 },
            { level = 2, cost = 15000, capacityIncrease = 150 },
            -- ... up to level 10
        }
    },
    -- ... more upgrades
}
```

Upgrades build on top of `StockCapacity`, `ProductSlots`, and `EmployeeSlots` base values.

### Available Upgrades

| Upgrade Key | Name | Levels | Description |
|---|---|---|---|
| `stock_capacity` | Max Stock Capacity | 10 | Increases total stock capacity. Adds `capacityIncrease` per level |
| `reputation` | Reputation | 5 | Provides `discountPercent` discount on stock orders (up to 30% total) |
| `express_logistics` | Express Logistics | 5 | Reduces delivery time by `speedPercent` (up to 50% total) |
| `product_slots` | Product Slots | 10 | Adds `slotsIncrease` product slots per level (up to +53 total) |
| `employee_slots` | Employee Slots | 5 | Adds `slotsIncrease` employee slots per level (up to +15 total) |
| `loyalty_program` | Loyalty Program | 1 | One-time unlock for the loyalty rewards system ($100,000) |

::: info
The `loyalty_program` upgrade only appears if `Config.LoyaltySystem.requireUpgrade = true` in `configs/config.lua`. If `requireUpgrade = false`, loyalty is automatically available without purchasing this upgrade.
:::

### Upgrade Level Properties

Each level in an upgrade has:

| Property | Type | Description |
|---|---|---|
| `level` | `number` | Level number |
| `cost` | `number` | Cost to purchase this level |
| `capacityIncrease` | `number` | Stock capacity increase (stock_capacity only) |
| `discountPercent` | `number` | Order discount percentage (reputation only) |
| `speedPercent` | `number` | Delivery speed increase percentage (express_logistics only) |
| `slotsIncrease` | `number` | Slot increase (product_slots and employee_slots only) |

## Starting Stock

```lua
StartingStock = {
    ['247store'] = { enabled = true, amount = 100 },
    ['liquorstore'] = { enabled = true, amount = 150 },
    ['hardware'] = { enabled = true, amount = 75 },
    ['pharmacy'] = { enabled = true, amount = 200 },
    ['gunstore'] = { enabled = true, amount = 50 },
}
```

Controls whether newly purchased shops receive starting stock and how much per item.

| Property | Type | Description |
|---|---|---|
| `enabled` | `boolean` | Whether to give starting stock when the shop is purchased |
| `amount` | `number` | Starting stock quantity per item |

## Stock Delivery

```lua
StockDelivery = {
    baseTime = 60,
    timePerItem = 0.5,
    minTime = 60,
    maxTime = 3600,
}
```

| Option | Type | Default | Description |
|---|---|---|---|
| `baseTime` | `number` | `60` | Base delivery time in seconds |
| `timePerItem` | `number` | `0.5` | Additional seconds per item ordered |
| `minTime` | `number` | `60` | Minimum delivery time in seconds (1 minute) |
| `maxTime` | `number` | `3600` | Maximum delivery time in seconds (1 hour) |

**Formula:** `Total delivery time = baseTime + (totalItems * timePerItem)` (clamped between `minTime` and `maxTime`)

The `express_logistics` upgrade reduces the calculated delivery time by a percentage.

## Employee Permissions

```lua
Permissions = {
    'viewProducts',
    'addProduct',
    'editProduct',
    'deleteProduct',
    'managePricing',
    -- ... 50+ permissions
}
```

This is the complete list of assignable employee permissions. Owners automatically have all permissions.

::: warning
Do not modify the `Permissions` table unless you understand the implications. Removing permissions from this list will prevent them from being assignable to employees.
:::

### Permission Categories

| Category | Permissions |
|---|---|
| **Inventory & Products** | `viewProducts`, `addProduct`, `editProduct`, `deleteProduct`, `managePricing` |
| **Stock** | `viewStock`, `addFromInventory`, `withdrawFromStock`, `orderStock`, `viewActiveOrders`, `viewStockHistory` |
| **Finances** | `viewFinances`, `viewTransactionHistory`, `depositMoney`, `withdrawMoney` |
| **Coupons** | `viewCoupons`, `createCoupon`, `editCoupon`, `deleteCoupon`, `viewCouponAnalytics` |
| **Sales** | `viewSales`, `createSale`, `editSale`, `deleteSale`, `viewSalesAnalytics`, `viewProductAnalytics` |
| **Customers** | `viewCustomers`, `banCustomer`, `unbanCustomer`, `viewBanList`, `viewCustomerAnalytics` |
| **Employees** | `viewEmployees`, `addEmployees`, `manageEmployees`, `removeEmployees`, `changeEmployeePicture`, `viewEmployeeActivity`, `viewEmployeeLog` |
| **Loyalty** | `viewLoyalty`, `changeLoyaltySettings`, `changeTierThresholds`, `addRewards`, `editReward`, `deleteReward`, `viewLoyaltyStats` |
| **Settings** | `viewSettings`, `changeStoreName`, `toggleBlip`, `changeBlipSettings`, `changeOpeningHours`, `manageNetwork`, `sellShop` |
| **Upgrades** | `viewUpgrades`, `buyUpgrades` |
| **Transactions** | `processSales`, `refundTransactions`, `viewReports` |

## Owned Shop Behavior

### Empty Product Behavior

```lua
IfNoProductsShowDefault = false
```

| Value | Behavior |
|---|---|
| `true` | Owned shops with no custom products show default items for that shop type (using `UnownedShopStock` for stock levels) |
| `false` | Owned shops with no custom products show an empty state message. The owner must configure products before customers can shop |

### Zero Stock Display

```lua
ShowZeroStockNonOrderableItems = false
```

| Value | Behavior |
|---|---|
| `true` | Items with `canOrder = false` AND stock = 0 will appear in the stock ordering tab |
| `false` | Items with `canOrder = false` AND stock = 0 will not appear (cleaner interface) |

::: info
Items with `canOrder = true` or stock > 0 always show regardless of this setting.
:::

## Product Whitelist

```lua
ProductWhitelist = {
    ['247store'] = {
        { item = 'water', canOrder = true, orderPrice = 2 },
        { item = 'sandwich', canOrder = true, orderPrice = 3 },
        -- ... more items
    },
    ['liquorstore'] = { ... },
    ['hardware'] = { ... },
    ['pharmacy'] = { ... },
    ['gunstore'] = { ... },
}
```

Defines what items each **owned** shop type is allowed to sell, with ordering options. This controls what appears in the management stock ordering interface.

Each whitelist entry:

| Property | Type | Required | Description |
|---|---|---|---|
| `item` | `string` | Yes | Item name |
| `canOrder` | `boolean` | Yes | If `true`, the item can be ordered from suppliers. If `false`, it can only be added from inventory |
| `orderPrice` | `number` | Yes (if `canOrder`) | Price to order this item from suppliers |
| `label` | `string` | No | Custom display name |
| `description` | `string` | No | Custom description text |
| `image` | `string` | No | Custom image (filename or full NUI/URL path) |
| `metadata` | `table` | No | Metadata passed to inventory on purchase |
| `displayMetadata` | `table` | No | ox_inventory tooltip display labels |

::: tip
The same item can appear multiple times with different labels/metadata to offer different "versions" (e.g., regular water and premium water). Individual shops can override the global whitelist with their own `productWhitelist` in `configs/shops.lua`.
:::
