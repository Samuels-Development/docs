---
title: Shop Definitions
description: How to define and configure individual shops in Shops Pro.
---

# Shop Definitions

The shop configuration file (`configs/shops.lua`) defines each individual shop on your server -- its location, type, items, restrictions, ownership, and behavior. The file returns a table keyed by unique shop identifiers.

::: info Config File Location
All shop definitions documented on this page are in `configs/shops.lua`.
:::

## Defining a Shop

Each shop is an entry in the returned table, keyed by a unique string identifier:

```lua
return {
    ['247store_1'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        itemOverride = false,
        targetDistance = 3.0,
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vec3(24.5, -1345.78, 29.5),
            heading = 269.19,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(24.95, -1347.29, 29.61),
                vector3(24.95, -1344.95, 29.61)
            }
        },
        items = { ... },
        ownership = {
            enabled = true,
            coords = vector3(29.37, -1338.72, 29.33),
            price = 50000
        },
    },
}
```

## Shop Properties

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `name` | `string` | Yes | -- | Display name shown in the UI and on the map blip |
| `subtitle` | `string` | No | -- | Subtitle text shown below the shop name |
| `shopType` | `string` | Yes | -- | Shop type identifier (e.g., `'247store'`, `'liquorstore'`, `'hardware'`, `'pharmacy'`, `'gunstore'`, `'pawn'`, `'police_armory'`) |
| `itemOverride` | `boolean` | No | `false` | When `true`, use this shop's `items` table instead of `BaseProducts` (even when `BaseProducts.enabled = true`) |
| `targetDistance` | `number` | No | `3.0` | Distance from which players can interact with the shop ped |
| `targetLabel` | `string` | No | *(locale default)* | Custom label for the ped interaction prompt |
| `targetIcon` | `string` | No | `'fas fa-shopping-basket'` | Custom Font Awesome icon for the ped interaction |
| `illegal` | `boolean` | No | `false` | When `true`, the shop exclusively uses dirty/black money |
| `currencyItem` | `string` | No | -- | Item name used as currency (players pay with this inventory item) |
| `currencyLabel` | `string` | No | *(auto-fetched)* | Display label for the currency item (auto-fetched from inventory if omitted) |
| `blip` | `table` | No | -- | Map blip configuration |
| `ped` | `table` | Yes | -- | Shopkeeper ped configuration |
| `registers` | `table` | No | -- | Cash register prop positions |
| `items` | `table` | No | -- | Item list (used when `BaseProducts.enabled = false` or `itemOverride = true`) |
| `ownership` | `table` | No | -- | Shop ownership/purchase configuration |
| `openingHours` | `table` | No | -- | Default opening hours for the shop |
| `jobRestrictions` | `table` | No | -- | Restrict shop access to specific jobs |
| `gangRestrictions` | `table` | No | -- | Restrict shop access to specific gangs |
| `frameworkJob` | `table` | No | -- | Link shop ownership to a framework job |
| `purchaseRestrictions` | `table` | No | -- | Per-shop purchase whitelist (overrides global) |
| `productWhitelist` | `table` | No | -- | Per-shop product whitelist (overrides global) |
| `payoutType` | `string` | No | `'clean'` | Pawn shop payout type: `'clean'` (cash) or `'dirty'` (black money) |

### Per-Shop UI Toggles

These boolean flags disable specific UI features for a shop:

| Property | Type | Default | Description |
|---|---|---|---|
| `disableTransactionHistory` | `boolean` | `false` | Hide transaction history in the shop |
| `disableLoyalty` | `boolean` | `false` | Hide loyalty program features |
| `disablePresets` | `boolean` | `false` | Hide preset/favorites features |
| `disableCoupons` | `boolean` | `false` | Hide coupon input |

## Blip Configuration

```lua
blip = {
    sprite = 52,
    color = 2,
    scale = 0.7,
    display = 4
}
```

| Property | Type | Description |
|---|---|---|
| `sprite` | `number` | GTA V blip sprite ID. Set to `0` to disable the blip entirely |
| `color` | `number` | GTA V blip color ID |
| `scale` | `number` | Blip size on the map |
| `display` | `number` | Blip display mode (typically `4` for both map and minimap) |

::: info
Blips use the ped coordinates as their position on the map.
:::

## Ped Configuration

```lua
ped = {
    enabled = true,
    model = 'mp_m_shopkeep_01',
    coords = vec3(24.5, -1345.78, 29.5),
    heading = 269.19,
    scenario = 'WORLD_HUMAN_STAND_MOBILE'
}
```

| Property | Type | Required | Description |
|---|---|---|---|
| `enabled` | `boolean` | Yes | Whether to spawn the ped |
| `model` | `string` | Yes | Ped model name |
| `coords` | `vector3` | Yes* | Ped spawn position |
| `heading` | `number` | Yes* | Ped facing direction |
| `scenario` | `string` | No | Ped animation scenario (e.g., `'WORLD_HUMAN_STAND_MOBILE'`, `'WORLD_HUMAN_CLIPBOARD'`) |

### Rotating Ped Locations

Instead of fixed `coords`/`heading`, use the `locations` array to randomize the ped's spawn point each server start:

```lua
ped = {
    enabled = true,
    model = 'g_m_m_chicold_01',
    locations = {
        { coords = vector3(839.48, 2176.82, 52.29), heading = 154.0 },
        { coords = vector3(118.34, -3025.31, 6.02), heading = 88.23 },
        { coords = vector3(-1256.44, -820.15, 17.1), heading = 126.58 },
    },
    scenario = 'WORLD_HUMAN_DRUG_DEALER'
}
```

One location is randomly selected on server start and synced to all clients via GlobalState.

## Register Configuration

```lua
registers = {
    enabled = true,
    coords = {
        vector3(24.95, -1347.29, 29.61),
        vector3(24.95, -1344.95, 29.61)
    }
}
```

| Property | Type | Description |
|---|---|---|
| `enabled` | `boolean` | Whether to add target zones on cash registers |
| `coords` | `table` | Array of `vector3` positions for register props |

## Items Configuration

Each item in the `items` table supports:

```lua
items = {
    { item = 'water', price = 5 },
    { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
    { item = 'iron', price = 5, currencyItem = 'metalscrap' },
    { item = 'water', price = 10, label = 'Premium Spring Water', description = 'Imported artisan spring water.', metadata = { quality = 100 } },
    { item = 'WEAPON_CARBINERIFLE', price = 2500, jobRestriction = { { name = 'police', minGrade = 3 }, { name = 'swat' } } },
}
```

| Property | Type | Required | Description |
|---|---|---|---|
| `item` | `string` | Yes | Item name matching your inventory system |
| `price` | `number` | Yes | Price for this item (or quantity of currency item if `currencyItem` is set) |
| `license` | `string` | No | Required license to purchase (e.g., `'weapon'`). Omit to skip license check |
| `currencyItem` | `string` | No | Pay with this item instead of cash. `price` becomes the quantity needed |
| `jobRestriction` | `table` | No | Restrict this item to specific jobs (items hidden from non-qualifying players) |
| `gangRestriction` | `table` | No | Restrict this item to specific gangs |
| `label` | `string` | No | Custom display name |
| `description` | `string` | No | Custom description text |
| `image` | `string` | No | Custom image (filename or full NUI/URL path) |
| `metadata` | `table` | No | Metadata passed to inventory on purchase |
| `displayMetadata` | `table` | No | ox_inventory tooltip display labels |

::: tip
When `BaseProducts.enabled = true` and `itemOverride = false`, the shop's `items` table is ignored and items come from `BaseProducts` for the matching `shopType`. Set `itemOverride = true` to force use of the shop's own items.
:::

## Job/Gang Restrictions

### Shop-Level Restrictions

Restrict who can **access** the entire shop:

```lua
-- String format (any grade)
jobRestrictions = { 'police', 'ambulance' }

-- Table format (with minimum grade)
jobRestrictions = { { name = 'police', minGrade = 2 }, { name = 'sheriff', minGrade = 1 } }

-- Mixed format
jobRestrictions = { 'ambulance', { name = 'police', minGrade = 2 } }
```

Gang restrictions work identically:

```lua
gangRestrictions = { 'ballas', 'vagos' }
gangRestrictions = { { name = 'ballas', minGrade = 2 }, { name = 'vagos', minGrade = 1 } }
```

::: warning
If a shop has **both** `jobRestrictions` and `gangRestrictions`, the player must satisfy **both** (AND logic). Within each restriction type, the player only needs to match **one** entry (OR logic).
:::

### Item-Level Restrictions

Restrict individual items within a shop. Items are **hidden** from players who do not meet the requirements:

```lua
-- Job restriction on an item
{ item = 'WEAPON_CARBINERIFLE', price = 2500, jobRestriction = { { name = 'police', minGrade = 3 }, { name = 'swat' } } }

-- Gang restriction on an item
{ item = 'WEAPON_PISTOL', price = 5000, gangRestriction = { { name = 'ballas', minGrade = 2 } } }
```

If `minGrade` is omitted, it defaults to `0` (any grade in that job/gang).

If an item has **both** `jobRestriction` and `gangRestriction`, the player must satisfy **both** (AND logic).

## Opening Hours

```lua
openingHours = { enabled = true, open = '08:00', close = '22:00' }
```

| Property | Type | Description |
|---|---|---|
| `enabled` | `boolean` | Whether opening hours are active |
| `open` | `string` | Opening time in `'HH:MM'` format |
| `close` | `string` | Closing time in `'HH:MM'` format |

::: info
These are default opening hours. If the shop is owned, the owner can override the schedule through the management interface.
:::

## Ownership Configuration

```lua
ownership = {
    enabled = true,
    coords = vector3(29.37, -1338.72, 29.33),
    price = 50000
}
```

| Property | Type | Description |
|---|---|---|
| `enabled` | `boolean` | Whether this shop can be purchased by players |
| `coords` | `vector3` | Location of the ownership interaction point (purchase/management access) |
| `price` | `number` | Purchase price of the shop |

## Framework Job Integration

```lua
frameworkJob = {
    enabled = true,
    job = 'shopowner',
    grade = 0
}
```

When enabled, purchasing the shop assigns the player a framework job. The job must already exist in your framework's job configuration.

| Property | Type | Description |
|---|---|---|
| `enabled` | `boolean` | Enable/disable framework job assignment |
| `job` | `string` | Framework job name to assign |
| `grade` | `number` | Grade assigned on purchase |

**Behavior:**
- **Purchase:** Player receives the job at the specified grade
- **Sell:** Player's job is removed (set to unemployed)
- **Transfer:** Old owner loses job, new owner receives it (if online)
- **Management access:** Blocked if player switches to a different active job

## Per-Shop Purchase Restrictions

```lua
purchaseRestrictions = {
    enabled = true,
    allowedIdentifiers = { 'ABC12345', 'XYZ98765' },
    restrictedMessage = 'This shop is reserved for specific players.'
}
```

Overrides the global `PurchaseRestrictions` from `configs/management.lua` for this specific shop.

## Per-Shop Product Whitelist

```lua
productWhitelist = {
    { item = 'water', canOrder = true, orderPrice = 2 },
    { item = 'sandwich', canOrder = true, orderPrice = 3 },
    { item = 'special_local_item', canOrder = true, orderPrice = 10 },
}
```

Overrides the global `ProductWhitelist` from `configs/management.lua` for this specific shop. When set, **only** items in this list appear in stock management.

## Pawn Shop Example

```lua
['pawn_1'] = {
    name = 'Pawn Shop',
    subtitle = 'We buy your items',
    shopType = 'pawn',
    -- payoutType = 'dirty', -- Pay in black money instead of cash
    itemOverride = false,
    targetDistance = 3.0,
    blip = { sprite = 267, color = 46, scale = 0.7, display = 4 },
    ped = {
        enabled = true,
        model = 'a_m_y_business_02',
        coords = vector3(412.22, 314.6, 103.02),
        heading = 204.5,
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
    },
    registers = { enabled = false, coords = {} },
    items = {
        { item = 'phone', price = 100 },
        { item = 'radio', price = 75 },
        { item = 'goldbar', price = 500 },
    },
    ownership = { enabled = false, coords = vector3(0, 0, 0), price = 0 }
}
```

Pawn shops **buy items from players**. The `price` is what the player **receives**. The shop only displays items the player has in their inventory that match the configured list.

## Illegal Shop Example

```lua
['illegal_dealer_1'] = {
    name = 'Black Market Dealer',
    subtitle = 'Open 24/7 - Fast Service',
    shopType = 'blackmarket',
    illegal = true, -- Forces black_money only
    gangRestrictions = { { name = 'ballas', minGrade = 2 }, 'vagos' },
    blip = { sprite = 0, color = 0, scale = 0, display = 4 },
    ped = {
        enabled = true,
        model = 'g_m_m_chicold_01',
        locations = {
            { coords = vector3(839.48, 2176.82, 52.29), heading = 154.0 },
            { coords = vector3(118.34, -3025.31, 6.02), heading = 88.23 },
        },
        scenario = 'WORLD_HUMAN_DRUG_DEALER'
    },
    registers = { enabled = false, coords = {} },
    items = {
        { item = 'lockpick', price = 500 },
        { item = 'weapon_pistol', price = 15000, gangRestriction = { { name = 'ballas', minGrade = 2 } } },
    },
    ownership = { enabled = false, coords = vector3(0, 0, 0), price = 0 }
}
```

::: info Illegal Shop Currency
- **ox_inventory:** Uses `black_money` item
- **QBCore:** Uses `markedbills` item with `worth` metadata
- **ESX:** Uses `black_money` account
:::

## Item Currency Shop Example

```lua
['gold_trader_1'] = {
    name = 'Gold Trader',
    subtitle = 'Trade gold for goods',
    shopType = 'item',
    currencyItem = 'goldbar',
    -- currencyLabel = 'Gold Bar', -- Optional (auto-fetched from inventory)
    itemOverride = true,
    targetDistance = 3.0,
    blip = { sprite = 605, color = 46, scale = 0.7, display = 4 },
    ped = { ... },
    registers = { enabled = false, coords = {} },
    items = {
        { item = 'lockpick', price = 2 },  -- Costs 2 goldbars
        { item = 'radio', price = 3 },      -- Costs 3 goldbars
    },
    ownership = { enabled = false, coords = vector3(0, 0, 0), price = 0 }
}
```

::: warning
Item currency shops do not support ownership, loyalty, or coupons. The `price` field represents the quantity of the currency item required.
:::

## Police Armory Example

```lua
['police_armory'] = {
    name = 'Police Armory',
    subtitle = 'LSPD Equipment',
    shopType = 'police_armory',
    itemOverride = true,
    targetDistance = 3.0,
    targetLabel = 'Access Armory',
    targetIcon = 'fas fa-shield-alt',
    jobRestrictions = { 'police', 'sheriff' },
    disableTransactionHistory = true,
    disableLoyalty = true,
    disableCoupons = true,
    blip = { sprite = 0, color = 0, scale = 0.0, display = 0 },
    ped = { ... },
    registers = { enabled = false, coords = {} },
    items = {
        -- Grade 0 (all officers)
        { item = 'armour', price = 0 },
        { item = 'bandage', price = 25 },
        { item = 'WEAPON_NIGHTSTICK', price = 100 },

        -- Grade 1+ only
        { item = 'WEAPON_STUNGUN', price = 350, jobRestriction = { { name = 'police', minGrade = 1 } } },
        { item = 'WEAPON_PISTOL', price = 500, jobRestriction = { { name = 'police', minGrade = 1 } } },

        -- Grade 3+ only
        { item = 'WEAPON_CARBINERIFLE', price = 2500, jobRestriction = { { name = 'police', minGrade = 3 }, { name = 'swat' } } },
    },
    ownership = { enabled = false, coords = vector3(0, 0, 0), price = 0 }
}
```

::: tip
The police armory demonstrates combining shop-level `jobRestrictions` (only police/sheriff can access the shop) with item-level `jobRestriction` (different equipment tiers based on grade).
:::

## Default Shop Counts

The default configuration includes:

| Shop Type | Count | Ownable |
|---|---|---|
| 24/7 Stores (`247store`) | 10 | Yes |
| Liquor Stores (`liquorstore`) | 5 | Yes |
| Hardware Stores (`hardware`) | 2 | No (by default) |
| Gun Stores (`gunstore`) | 9 | No (by default) |
| Pawn Shop (`pawn`) | 1 | No |
| Police Armory (`police_armory`) | 1 | No |
| Illegal Dealer (`blackmarket`) | 1 | No |
| Item Currency Shop (`item`) | 1 | No |
