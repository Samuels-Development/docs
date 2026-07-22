---
title: Main Configuration
description: Main configuration options for Shops Pro including locale, serial numbers, metadata, loyalty, categories, and base products.
---

# Main Configuration

The main configuration file (`configs/config.lua`) controls the core behavior of Shops Pro. The file returns a single table -- all options are accessed as keys of this table (e.g., `Config.Locale`, `Config.Debug`).

::: info Config File Location
All configuration options documented on this page are in `configs/config.lua`.
:::

## General Settings

### Locale

```lua
Locale = 'en'
```

Sets the language for all UI text and notifications. Locales are loaded from JSON files in the `locales/` directory.

| Value | Language |
|---|---|
| `'en'` | English |
| `'de'` | German (Deutsch) |

### Debug Mode

```lua
Debug = false
```

Enables debug prints and polyzone visualization. Useful for development and shop placement.

::: warning
Disable debug mode in production. It can impact performance and expose internal data in the console.
:::

### Periodic Saving

```lua
Saving = {
    enabled = true,
    interval = 10, -- minutes
}
```

| Option | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `true` | Enable periodic saving while the server is running |
| `interval` | `number` | `10` | How often to save in minutes |

::: info
Shop data is automatically saved on txAdmin server shutdown/restart AND when the resource itself stops (covers `restart sd-shops`). Interval saving is a safety net against crashes. Saves use column-level dirty tracking, so each save only writes the data that actually changed since the last one -- cheap even on busy servers, and safe to keep enabled.
:::

### Data Retention

```lua
DataRetention = {
    societyTransactions = 500,
    customerPurchaseHistory = 50,
    productPurchaseHistory = 100,
}
```

Caps the persisted per-shop history lists so shop records cannot grow without limit over months of activity. When a list exceeds its cap, the oldest entries are trimmed.

| Option | Type | Default | Description |
|---|---|---|---|
| `societyTransactions` | `number` | `500` | Transaction history per shop (sales, deposits, withdrawals, upgrades, stock orders) |
| `customerPurchaseHistory` | `number` | `50` | Purchase history entries per customer per shop |
| `productPurchaseHistory` | `number` | `100` | Purchase records per product (feeds product analytics) |

Set a value to `0` for unlimited (not recommended on busy servers). Running totals and statistics (revenue, counts, analytics) are separate counters and are never affected by trimming.

### Security

```lua
Security = {
    maxPurchaseDiscount = 0.95,
    maxPurchaseQuantity = 10000,
}
```

Every purchase is validated server-side against the shop's real product list: items must actually be sold at the shop, quantities must be sane, and prices are clamped to the authoritative catalog. These options tune the limits used to reject tampered purchases before any money or items move.

| Option | Type | Default | Description |
|---|---|---|---|
| `maxPurchaseDiscount` | `number` | `0.95` | Maximum fraction of the catalog price a purchase may be discounted (sale + coupon + loyalty combined) before it is treated as tampering and rejected. `0.95` = up to 95% off allowed |
| `maxPurchaseQuantity` | `number` | `10000` | Hard ceiling on the quantity of a single item per purchase line |

::: tip
Raise `maxPurchaseDiscount` toward `1.0` if you run legitimately deeper promotions; lower it for tighter protection.
:::

### Pawn Shop Display

```lua
PawnShop = {
    showAllBuyableItems = true,
}
```

| Option | Type | Default | Description |
|---|---|---|---|
| `showAllBuyableItems` | `boolean` | `true` | When `true`, the pawn shop sell menu lists **every** item the shop buys with its payout price, greying out items the player isn't carrying. When `false`, only items the player actually has are listed |

## Weapon Serial Numbers

```lua
WeaponSerial = {
    enabled = true,
    registerToOwner = true,

    serialFormat = {
        digitCount = 6,
        letterCount = 3,
        excludedTexts = { 'POL', 'EMS' },
    },

    serialPrefix = nil,

    shopTypePrefixes = {
        ['police_armory'] = 'POL',
    },

    serialWeapons = {
        'WEAPON_PISTOL',
        'WEAPON_PISTOL_MK2',
        -- ... full list in config
    },
}
```

| Option | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `true` | Enable/disable serial number generation on weapon sales |
| `registerToOwner` | `boolean` | `true` | Include the buyer's character name in weapon metadata |
| `serialFormat.digitCount` | `number` | `6` | Number of random digits on each side of the serial |
| `serialFormat.letterCount` | `number` | `3` | Number of random uppercase letters in the middle |
| `serialFormat.excludedTexts` | `table` | `{ 'POL', 'EMS' }` | Letter combinations excluded from random generation (reserved for prefixes) |
| `serialPrefix` | `string\|nil` | `nil` | Global default prefix replacing the random letters. Set to `nil` for random |
| `shopTypePrefixes` | `table` | `{ ['police_armory'] = 'POL' }` | Per-shop-type prefix overrides |
| `serialWeapons` | `table` | *(long list)* | Weapon items that should receive serial numbers. Only items in this list get serials |

Serial numbers follow the format: `[digits][letters/prefix][digits]`

Example with default settings: `482917ABK637201`

Example with police armory prefix: `482917POL637201`

::: tip
The `serialWeapons` list includes all firearms and the stungun by default (matching ox_inventory's weapon data). Melee weapons, throwables, and utility items are excluded. Add or remove items as needed for your server.
:::

## Global Item Metadata

```lua
ApplyMetadata = {
    enabled = false,
    groups = {
        { applyTo = 'all', metadata = { durability = 100 } },
        { applyTo = { 'lockpick', 'screwdriver' }, metadata = { durability = 50 } },
        { applyTo = { 'bandage', 'firstaid' }, metadata = { sterile = true } },
    },
    displayMetadata = {
        sterile = 'Sterile',
    },
}
```

When enabled, applies metadata to all items purchased from any shop without configuring each item individually.

### Groups

Each group has:

| Property | Type | Description |
|---|---|---|
| `applyTo` | `'all'` or `table` | `'all'` for every item, or a list of specific item names |
| `metadata` | `table` | The metadata key-value pairs to apply |

Groups are processed in order. Later groups override earlier groups for the same key. Per-item metadata (from `BaseProducts` or shop items) overrides group values. Weapon serial metadata always takes highest priority.

**Priority order:** Groups (earliest to latest) -> Per-item metadata -> Weapon metadata (highest)

### Display Metadata

Maps metadata keys to display labels shown in ox_inventory item tooltips.

| Format | Example | Result |
|---|---|---|
| String | `sterile = 'Sterile'` | Booleans display as "Yes"/"No" |
| Table | `sterile = { label = 'Sterile', trueValue = 'Sanitized', falseValue = 'Contaminated' }` | Custom boolean display text |

::: warning
Do NOT add these keys to `displayMetadata` -- ox_inventory already displays them by default: `durability`, `description`, `ammo`, `serial`, `components`, `weapontint`, `type`, `label`. Adding them will cause duplicate tooltip entries.
:::

## Ped and Interaction

```lua
PedSpawnDistance = 50.0
InteractionDistance = 2.0
```

| Option | Type | Default | Description |
|---|---|---|---|
| `PedSpawnDistance` | `number` | `50.0` | Distance (in game units) at which shop peds spawn and despawn |
| `InteractionDistance` | `number` | `2.0` | Distance at which the player can interact with a shop ped |

## Variant Display Metadata

```lua
VariantDisplayMetadata = true
```

**ox_inventory only.** When a shop item or whitelist entry defines a custom `label` (an item "variant", e.g. two `speaker` entries with different labels/images/metadata), the purchase injects the entry's label, description, and image into the granted item's metadata (`metadata.label` / `metadata.description` / `metadata.imageurl`) so the item also looks like the variant inside the inventory -- not just in the shop UI.

- Explicit keys in the entry's own `metadata` table always take priority.
- Entries without a custom label are never touched, so plain items keep stacking normally.

## Society Payments

```lua
SocietyPayments = {
    enabled = true,
    allowedSocieties = {
        ['police'] = {
            minGrade = 2,
            label = 'Police Society'
        },
        ['ambulance'] = {
            minGrade = 2,
            label = 'Ambulance Society'
        },
        ['mechanic'] = {
            minGrade = 1,
            label = 'Mechanic Society',
            -- allowedShops = { 'hardware' },
        },
    }
}
```

Allows players to purchase items using their job society funds.

| Option | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `true` | Enable/disable society payments in shops |
| `allowedSocieties` | `table` | *(see above)* | Map of society/job names to their configuration |

Each society entry:

| Property | Type | Description |
|---|---|---|
| `minGrade` | `number` | Minimum job grade required to use society funds |
| `label` | `string` | Display name for the society in the UI |
| `allowedShops` | `table` *(optional)* | Restrict this society to paying for items at ONLY the listed shop IDs (e.g. `{ 'hardware' }`). Omit to allow all shops |

### Per-Shop Control

Both restrictions are enforced server-side and filter the payment options shown in the UI:

- **Per society:** add `allowedShops = { 'shopId1', 'shopId2' }` to a society entry above to limit that society's item payments to those shops.
- **Per shop:** add `disableSocietyPayment = true` to any shop in `configs/shops.lua` to block society payments at that shop entirely (see [Shops Configuration](./config-shops)).

## Unowned Shop Stock

```lua
UnownedShopStock = {
    default = {
        infinite = true,
        startingStock = 50,
    },
    ['247store'] = {
        infinite = true,
        startingStock = 50,
    },
}
```

Controls starting stock levels for shops that do not have an owner.

| Option | Type | Default | Description |
|---|---|---|---|
| `default.infinite` | `boolean` | `true` | When `true`, unowned shops have infinite stock (displayed as 999) |
| `default.startingStock` | `number` | `50` | Starting stock per item when `infinite` is `false` |

Per-shop-type overrides can be added using the shop type as the key (e.g., `['247store']`). If not specified for a shop type, it falls back to the `default` settings.

## Coupons

```lua
Coupons = {
    ['WELCOME10'] = {
        discount = 10,
        description = 'Welcome discount'
    },
    ['SUMMER20'] = {
        discount = 20,
        description = 'Summer sale'
    },
    ['VIP25'] = {
        discount = 25,
        description = 'VIP discount'
    },
    ['GRANDOPENING'] = {
        discount = 15,
        description = 'Grand opening special'
    }
}
```

Default coupons available in all shops. The table key is the coupon code.

| Property | Type | Description |
|---|---|---|
| `discount` | `number` | Discount percentage (e.g., `10` = 10% off) |
| `description` | `string` | Description text for the coupon |

::: tip
If shops are ownable, shop owners can freely create their own coupons through the management interface in addition to these defaults.
:::

## Loyalty System

```lua
LoyaltySystem = {
    enabled = true,
    requireUpgrade = true,
    pointsPerDollar = 1,
}
```

| Option | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `true` | Enable/disable the loyalty system globally. When `false`, even owned shops cannot use loyalty |
| `requireUpgrade` | `boolean` | `true` | If `true`, shops must purchase the `loyalty_program` upgrade to use it. If `false`, loyalty is always available |
| `pointsPerDollar` | `number` | `1` | How many loyalty points customers earn per dollar spent |

### Default Loyalty Rewards

```lua
DefaultLoyaltyRewards = {
    {
        id = 'default_reward_1',
        name = '5% Off Coupon',
        description = 'Get 5% off your next purchase',
        type = 'coupon',
        cost = 100,
        icon = '...',
        discountPercent = 5
    },
    -- ... more rewards
}
```

These are the default rewards shown when a shop is not owned by a player. Owned shops configure their own rewards through the management interface.

| Property | Type | Description |
|---|---|---|
| `id` | `string` | Unique identifier for the reward |
| `name` | `string` | Display name |
| `description` | `string` | Description text |
| `type` | `string` | Reward type (e.g., `'coupon'`) |
| `cost` | `number` | Loyalty points required to redeem |
| `discountPercent` | `number` | Discount percentage granted |

## Shop Type Display

```lua
ShopTypeDisplay = {
    ['247store'] = { icon = 'shopping-cart', color = 'emerald' },
    ['liquorstore'] = { icon = 'wine', color = 'purple' },
    ['hardware'] = { icon = 'wrench', color = 'orange' },
    ['pharmacy'] = { icon = 'heart', color = 'red' },
    ['gunstore'] = { icon = 'crosshair', color = 'red' },
    ['pawn'] = { icon = 'hand-coins', color = 'amber' },
    ['item'] = { icon = 'Gem', color = 'purple' },
}
```

Defines the icon and color scheme for each shop type in the UI.

| Property | Type | Description |
|---|---|---|
| `icon` | `string` | Icon name from [Lucide Icons](https://lucide.dev/icons) (kebab-case format) |
| `color` | `string` | Color name from the available palette |

**Available colors:** `emerald`, `purple`, `orange`, `red`, `slate`, `blue`, `green`, `yellow`, `pink`, `indigo`, `cyan`, `teal`, `lime`, `amber`, `rose`, `fuchsia`, `violet`, `sky`, `gray`, `zinc`, `neutral`, `stone`

## Categories

```lua
Categories = {
    colorsEnabled = true,

    ['food'] = {
        title = 'Food & Drinks',
        color = 'green',
        types = { '247store', 'liquorstore' },
        items = { 'water', 'sandwich', 'coffee', ... }
    },
    ['medical'] = {
        title = 'Medical',
        color = 'red',
        types = { '247store', 'pharmacy' },
        items = { 'bandage', 'painkillers', ... }
    },
    -- ... more categories
}
```

Global product categories used across all shops for filtering and display grouping.

| Option | Type | Description |
|---|---|---|
| `colorsEnabled` | `boolean` | Set to `false` to disable category colors/badges globally |

Each category:

| Property | Type | Description |
|---|---|---|
| `title` | `string` | Display title for the category |
| `color` | `string` | Color name for the category badge |
| `types` | `table` | Shop types that use this category. Use an empty array `{}` if the category should apply to all types |
| `items` | `table` | Item names belonging to this category |

::: tip
Categories defined here include: `food`, `alcohol`, `snacks`, `medical`, `tools`, `electronics`, `valuables`, `weapons`, `ammo`, `attachments`, `clothing`, `accessories`, `automotive`, `hardware`, `materials`, `supplies`.
:::

## Base Products

```lua
BaseProducts = {
    enabled = true,

    ['247store'] = {
        items = {
            { item = 'water', price = 2 },
            { item = 'coffee', price = 4 },
            { item = 'burger', price = 8 },
            -- ...
        }
    },
    ['liquorstore'] = { ... },
    ['hardware'] = { ... },
    ['pharmacy'] = { ... },
    ['gunstore'] = { ... },
    ['pawn'] = { ... },
    ['police_armory'] = { ... },
}
```

When `enabled = true`, all shops of a given type use these centralized items and prices. When `enabled = false`, shops fall back to their individual `items` table defined in `configs/shops.lua`. If a shop type used in `configs/shops.lua` is not defined here, it also falls back to individual shop items.

| Option | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `true` | Use base products for all shops of each type |

### Item Properties

Each item in a base products list supports:

| Property | Type | Required | Description |
|---|---|---|---|
| `item` | `string` | Yes | Item name matching your inventory system |
| `price` | `number` | Yes | Default price for this item |
| `license` | `string` | No | Required license to purchase (e.g., `'weapon'`) |
| `currencyItem` | `string` | No | Pay with this item instead of cash. The `price` becomes the quantity needed |
| `label` | `string` | No | Custom display name (overrides inventory label) |
| `description` | `string` | No | Custom description text |
| `image` | `string` | No | Custom image filename or full NUI/URL path |
| `metadata` | `table` | No | Metadata passed to inventory on purchase |
| `displayMetadata` | `table` | No | ox_inventory tooltip display labels for metadata keys |

### Pawn Shop (Special Type)

The `pawn` base products entry defines items that the pawn shop **buys from players**. The `price` is what the **player receives** for selling the item. Players bring items from their inventory, and the shop displays only items they have that match the list.

### Item Display Override Examples

```lua
-- Custom label, description, and image
{ item = 'water', price = 5, label = 'Premium Spring Water', description = 'Imported artisan spring water.', image = 'lockpick.png' }

-- Full NUI path for image
{ item = 'radio', price = 250, image = 'nui://ox_inventory/web/images/custom_radio.png' }

-- Metadata with display metadata
{ item = 'bandage', price = 15, metadata = { durability = 100, sterile = true }, displayMetadata = { sterile = 'Sterile' } }

-- Per-item currency override (costs 5 metalscrap instead of $5)
{ item = 'iron', price = 5, currencyItem = 'metalscrap' }
```
