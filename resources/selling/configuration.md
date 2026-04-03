# Configuration

All configuration for sd-selling is managed in `config.lua` located in the root of the resource folder. Logging is configured separately in `server/logs.lua`.

## General Settings

```lua
Config.Debug = false
SD.Locale.LoadLocale('en')
Config.PoliceJobs = { 'police', --[['sheriff']] }
Config.EnableLevels = true
Config.DisplayLevel = true
Config.EnableZones = true
Config.EnableMetadata = true
Config.EnableLaundering = false
Config.RetrieveCopsTime = 15
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Debug` | boolean | `false` | Enable debug mode. Note: debug points for zones may appear slightly larger than the actual area. |
| `SD.Locale.LoadLocale` | string | `'en'` | Language locale to load. Change `'en'` to any language file available in the `locales` folder. |
| `Config.PoliceJobs` | table | `{ 'police' }` | Array of job names counted when checking the current number of on-duty police. |
| `Config.EnableLevels` | boolean | `true` | Enable the reputation / level system. Highly recommended to keep enabled for the best experience. |
| `Config.DisplayLevel` | boolean | `true` | Show the player's current level in the reputation context menu. |
| `Config.EnableZones` | boolean | `true` | Enable zone-based selling. When `false`, the settings from `Config.Zones[1]` apply globally to all peds. |
| `Config.EnableMetadata` | boolean | `true` | Enable ox_inventory metadata support so items with specific metadata (e.g., different weed strains) can be sold. |
| `Config.EnableLaundering` | boolean | `false` | Enable the money laundering feature. |
| `Config.RetrieveCopsTime` | number | `15` | Interval in minutes for the server to broadcast the current cop count to all connected players. |

## Payout Type

```lua
Config.Payout = { Type = 'dirty', DirtyType = 'standard' }
Config.DirtyMoney = 'black_money'
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Payout.Type` | string | `'dirty'` | Payout mode: `'dirty'` or `'clean'`. This applies only to deliveries and encounters, **not** regular drug sales (unless `Config.EnableLevels` is `false`). |
| `Config.Payout.DirtyType` | string | `'standard'` | How dirty money is handled. `'standard'` uses a 1-to-1 ratio. |
| `Config.DirtyMoney` | string | `'black_money'` | The item name used for 1-to-1 dirty money transactions when `DirtyType` is set to `'1-1'` in level settings. |

::: info
Regular drug sale payouts are configured per-level inside `Config.Levels`. The `Config.Payout` table only governs deliveries and encounters.
:::

## Target Stand-Still

```lua
Config.TargetStandStill = {
    Enable   = true,
    Duration = 4000,
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Enable` | boolean | `true` | Whether targeting a ped forces them to stand still. Helpful when peds walk away while you are trying to interact. |
| `Duration` | number | `4000` | How long (in milliseconds) the ped remains standing still after being targeted. |

## Selling Zones

Zones define where players can sell drugs. Each zone supports either a **radius-based** area (single coordinate + size) or a **polygon-based** area (array of corner-points).

::: tip
When `Config.EnableZones` is `false`, the drug list and settings from `Config.Zones[1]` apply globally to every ped.
:::

```lua
Config.Zones = {
    [1] = {
        Coords = {x = 37.37, y = -1883.42, z = 22.44},
        -- Or, for a polygonal zone, supply an array of corner-points:
        --[[
        Coords = {
            { x = 42.67, y = -1388.19, z = 70.02 },
            { x = 532.56, y = -1790.96, z = 71.7 },
            { x = 273.98, y = -2292.74, z = 66.96 },
            { x = -255.44, y = -1761.41, z = 100.89 },
        },
        ]]
        Size = 250.0,
        PoliceRequirement = {Enable = false, Amount = 1},
        Cooldown = { Enable = true, Period = { Hour = 1, Min = 0 }, Max = 250 },
        LevelRestrict = { Enable = false, Level = 1 },
        Blip = {
            Enable = false,
            Name = 'Drug Selling Zone',
            Sprite = 51,
            Scale = 0.8,
            Colour = 1,
            Radius = {Enable = true, Colour = 1},
        },
        Drugs = {
            ['cokebaggy'] = {
                Label = "Cocaine",
                Icon = "fas fa-capsules",
                Price = {Randomize = true, Base = 100, Min = 80, Max = 120},
                Quantity = {Randomize = true, Base = 10, Min = 5, Max = 15},
                LevelRestrict = { Enable = false, Level = 1 },
            },
            -- more drugs...
        },
    },
}
```

### Zone Settings

| Key | Type | Default (Zone 1) | Description |
|---|---|---|---|
| `Coords` | vector / table | `{x=37.37, y=-1883.42, z=22.44}` | Center point for a radius zone, **or** an array of `{x, y, z}` points for a polygon zone. |
| `Size` | number | `250.0` | Radius of the zone (only used when `Coords` is a single point). |
| `PoliceRequirement.Enable` | boolean | `false` | Whether a minimum number of police must be online to sell in this zone. |
| `PoliceRequirement.Amount` | number | `1` | Number of police required when enabled. |
| `Cooldown.Enable` | boolean | `true` | Enable a per-player cooldown for this zone. |
| `Cooldown.Period` | table | `{ Hour = 1, Min = 0 }` | Cooldown duration. |
| `Cooldown.Max` | number | `250` | Maximum number of sales allowed per cooldown period. |
| `LevelRestrict.Enable` | boolean | `false` | Restrict zone access by player level. |
| `LevelRestrict.Level` | number | `1` | Minimum level required when restriction is enabled. |

### Zone Blip Settings

| Key | Type | Default | Description |
|---|---|---|---|
| `Blip.Enable` | boolean | `false` | Whether a map blip is shown for this zone. Polygon zones do not display a blip. |
| `Blip.Name` | string | `'Drug Selling Zone'` | Name displayed on the blip. |
| `Blip.Sprite` | number | `51` | Blip sprite icon ID. |
| `Blip.Scale` | number | `0.8` | Blip scale on the map. |
| `Blip.Colour` | number | `1` | Blip colour ID. |
| `Blip.Radius.Enable` | boolean | `true` | Show a radius circle around the blip. |
| `Blip.Radius.Colour` | number | `1` | Colour of the radius circle. |

### Zone Drug Entry

| Key | Type | Example | Description |
|---|---|---|---|
| `Label` | string | `"Cocaine"` | Display name of the drug. |
| `Icon` | string | `"fas fa-capsules"` | FontAwesome icon class. |
| `Price.Randomize` | boolean | `true` | Randomize the price between `Min` and `Max`, or use `Base` as a fixed price. |
| `Price.Base` | number | `100` | Fixed price when `Randomize` is `false`. |
| `Price.Min` / `Price.Max` | number | `80` / `120` | Range for randomized pricing. |
| `Quantity.Randomize` | boolean | `true` | Randomize the quantity the NPC wants to buy. |
| `Quantity.Base` | number | `10` | Fixed quantity when `Randomize` is `false`. |
| `Quantity.Min` / `Quantity.Max` | number | `5` / `15` | Range for randomized quantity. |
| `LevelRestrict.Enable` | boolean | `false` | Restrict this specific drug to a minimum level. |
| `LevelRestrict.Level` | number | `1` | Minimum level required to sell this drug. |

::: tip Metadata Variants
When `Config.EnableMetadata` is `true`, each drug entry can optionally include a `MetadataVariants` sub-table and a `SellBaseItem` boolean. This allows selling items with specific ox_inventory metadata (e.g., purity levels, batch identifiers) at different prices and quantities. See the commented examples in the config for cocaine and oxycodone.
:::

### Default Zones

The config ships with three example zones:

| Zone | Center Coords | Size | Police Required | Cooldown | Max Sales | Level Required | Drugs |
|---|---|---|---|---|---|---|---|
| 1 | `37.37, -1883.42, 22.44` | 250.0 | No | 1h / 250 | 250 | No | Cocaine, Crack, Ecstasy, Oxycodone |
| 2 | `284.0, 162.0, 104.0` | 250.0 | No | 1h / 100 | 100 | No | Meth, White Widow, Skunk, Purple Haze |
| 3 | `-1664.0, -1066.0, 18.0` | 150.0 | Yes (1) | 1h / 50 | 50 | Yes (1) | OG Kush, Amnesia, AK-47, Ecstasy |

## Level System

The level system controls XP progression, selling hours, price multipliers, risk chances, payout types, money washing, taxes, and cooldowns. There are 5 levels by default.

::: warning
It is highly recommended to keep `Config.EnableLevels = true`. When disabled, some Level 1 settings apply globally, but many features lose their progression mechanics.
:::

```lua
Config.Levels = {
    {
        Level = 1,
        XPThreshold = 250,
        XPPerSale = 10,
        Multiplier = 1.0,
        PoliceNotify = {Enable = true, Chance = 30},
        Robbery = {Enable = false, Chance = 33},
        Rejection = {Enable = true, Chance = 25, PoliceNotify = {Enable = true, Chance = 25}},
        TimeRequirement = {Enable = true, AllowedTime = {From = 21, To = 2}},
        Encounter = { Enable = true, Chance = 2, Quantity = { Min = 25, Max = 40 } },
        MoneyType = { Type = 'clean', DirtyType = 'standard' },
        Washing = { Enable = true, Bills = { min = 750, max = 2000, chance = 10 }, Bands = { min = 750, max = 2000, chance = 15 }, Rolls = { min = 250, max = 750, chance = 20 } },
        Tax = { Enable = true, Percentage = 25 },
        Cooldown = { Enable = true, Period = { Hour = 1, Min = 0 }, Max = 10 },
    },
    -- Levels 2 through 5 follow the same structure...
}
```

### All Five Levels at a Glance

| Setting | Level 1 | Level 2 | Level 3 | Level 4 | Level 5 |
|---|---|---|---|---|---|
| **XP Threshold** | 250 | 1000 | 2000 | 3500 | 1500* |
| **XP Per Sale** | 10 | 20 | 30 | 40 | 50 |
| **Price Multiplier** | 1.0 | 1.1 | 1.2 | 1.3 | 1.4 |
| **Selling Hours** | 21:00 - 02:00 | 20:00 - 04:00 | 19:00 - 05:00 | 18:00 - 06:00 | 17:00 - 07:00 |
| **Police Alert Chance** | 30% | 25% | 20% | 8% | 10% |
| **Rejection Chance** | 25% | 22% | 20% | 13% | 5% |
| **Rejection Police Chance** | 25% | 20% | 15% | 10% | 5% |
| **Robbery Enabled** | No | Yes | Yes | Yes | Yes |
| **Robbery Chance** | 33% | 15% | 13% | 20% | 3% |
| **Encounter Chance** | 2% | 3% | 4% | 5% | 6% |
| **Encounter Quantity** | 25 - 40 | 25 - 40 | 25 - 40 | 25 - 40 | 25 - 40 |
| **Money Type** | clean | clean | clean | clean | clean |
| **Dirty Type** | standard | standard | standard | standard | standard |
| **Money Tax** | 25% | 15% | 15% | 10% | 5% |
| **Cooldown** | 1h / 10 max | 1h / 20 max | 1h / 40 max | 30m / 60 max | Disabled / 50 max |

*Level 5's `XPThreshold` of 1500 is effectively ignored since there is no Level 6 by default. Add additional levels if desired.

### Level Setting Details

| Key | Type | Description |
|---|---|---|
| `Level` | number | The level number. |
| `XPThreshold` | number | XP required to advance to the next level. |
| `XPPerSale` | number | XP earned per successful sale at this level. |
| `Multiplier` | number | Price multiplier applied to all sales at this level. |
| `PoliceNotify.Enable` | boolean | Whether police can be alerted on a sale. |
| `PoliceNotify.Chance` | number | Percentage chance of a police alert per sale. |
| `Robbery.Enable` | boolean | Whether the player can be robbed during a sale. |
| `Robbery.Chance` | number | Percentage chance of being robbed. |
| `Rejection.Enable` | boolean | Whether the NPC can reject a sale. |
| `Rejection.Chance` | number | Percentage chance of rejection. |
| `Rejection.PoliceNotify.Enable` | boolean | Whether police can be alerted on a rejection. |
| `Rejection.PoliceNotify.Chance` | number | Percentage chance of police alert on rejection. |
| `TimeRequirement.Enable` | boolean | Whether selling is restricted to specific in-game hours. |
| `TimeRequirement.AllowedTime.From` | number | Starting hour (24h format). |
| `TimeRequirement.AllowedTime.To` | number | Ending hour (24h format). |
| `Encounter.Enable` | boolean | Whether random encounter/meetup events can trigger. |
| `Encounter.Chance` | number | Percentage chance per sale of triggering an encounter. |
| `Encounter.Quantity.Min` / `Max` | number | Range of drug quantity exchanged in an encounter. |
| `MoneyType.Type` | string | `'clean'` or `'dirty'` -- type of money the player receives from sales. |
| `MoneyType.DirtyType` | string | `'standard'` uses framework defaults (e.g., markedbills on qb-core, black_money account on es_extended). `'1-1'` uses `Config.DirtyMoney` item at a 1:1 ratio. |
| `Tax.Enable` | boolean | Whether a tax is applied to money washing payouts. |
| `Tax.Percentage` | number | Tax percentage deducted from washed money. |
| `Cooldown.Enable` | boolean | Whether a sale cooldown is active at this level. |
| `Cooldown.Period` | table | `{ Hour, Min }` -- cooldown duration. |
| `Cooldown.Max` | number | Maximum number of sales allowed per cooldown period. |

### Money Washing (Per-Level)

Each level includes a `Washing` table that controls the chance and value of receiving laundered money items after a sale.

```lua
Washing = {
    Enable = true,
    Bills = { min = 750, max = 2000, chance = 10 },
    Bands = { min = 750, max = 2000, chance = 15 },
    Rolls = { min = 250, max = 750, chance = 20 },
},
```

| Key | Type | Description |
|---|---|---|
| `Washing.Enable` | boolean | Enable money washing rewards at this level. |
| `Washing.Bills.min` / `max` | number | Value range for `markedbills`. On qb-core, if metadata is present it overrides these values. |
| `Washing.Bills.chance` | number | Percentage chance of receiving bills. |
| `Washing.Bands.min` / `max` | number | Value range for `bands`. |
| `Washing.Bands.chance` | number | Percentage chance of receiving bands. |
| `Washing.Rolls.min` / `max` | number | Value range for `rolls`. |
| `Washing.Rolls.chance` | number | Percentage chance of receiving rolls. |

**Default washing chances by level:**

| Item | Level 1 | Level 2 | Level 3 | Level 4 | Level 5 |
|---|---|---|---|---|---|
| Bills (750-2000) | 10% | 12% | 15% | 20% | 23% |
| Bands (750-2000) | 15% | 17% | 24% | 26% | 28% |
| Rolls (250-750) | 20% | 22% | 28% | 30% | 40% |

## Robbery Cooldown

```lua
Config.RobberyCooldown = { Enable = true, Period = { Hour = 0, Min = 5 } }
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Enable` | boolean | `true` | Enable a cooldown between robberies so the same player is not robbed repeatedly. |
| `Period.Hour` | number | `0` | Hours portion of the cooldown. |
| `Period.Min` | number | `5` | Minutes portion of the cooldown. |

## Encounters

Encounters are special bulk-sale meetup events that can trigger randomly after a regular sale.

```lua
Config.Encounters = {
    XPPerEncounter = 100,
    Cooldown = { Enable = true, Period = { Hour = 0, Min = 30 } },
    Locations = {
        { x = -471.2451, y = -936.0005, z = 22.59847, w = 87.16846 },
        -- 17 locations total...
    }
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `XPPerEncounter` | number | `100` | XP awarded for completing an encounter. |
| `Cooldown.Enable` | boolean | `true` | Enable a cooldown between potential encounters. |
| `Cooldown.Period` | table | `{ Hour = 0, Min = 30 }` | Cooldown duration (30 minutes by default). |
| `Locations` | table | 17 coordinates | List of `{x, y, z, w}` positions where encounter NPCs can spawn. Add or remove entries as needed. |

::: info
The per-level `Encounter.Chance` setting in `Config.Levels` determines how likely an encounter is to trigger after any given sale. The `Config.Encounters` table only controls XP, cooldown, and spawn locations.
:::

## Delivery Missions

Deliveries are route-based missions with three tiers: Small, Medium, and Large. Players pick a drug and a route, then complete stops along the way.

```lua
Config.Delivery = {
    Level = { Enable = false, Level = 3 },
    DisplayLevel = true,
    Small  = { ... },
    Medium = { ... },
    Large  = { ... },
    Drugs  = { ... },
}
```

### Delivery General Settings

| Key | Type | Default | Description |
|---|---|---|---|
| `Level.Enable` | boolean | `false` | Require a minimum level to access deliveries. |
| `Level.Level` | number | `3` | The minimum level required when enabled. |
| `DisplayLevel` | boolean | `true` | Show the player's level in the delivery menu. |

### Delivery Tiers

| Setting | Small | Medium | Large |
|---|---|---|---|
| **XP Per Stop** | 20 | 25 | 30 |
| **Drug Quantity** | 50 | 125 | 250 |
| **Processing Time** | 5 minutes | 5 minutes | 5 minutes |
| **Route Count** | 3 | 3 | 3 |
| **Route 1 Stops** | 4-6 (0% boost) | 5-7 (0% boost) | 8-9 (0% boost) |
| **Route 2 Stops** | 7-8 (15% boost) | 8-9 (10% boost) | 9-10 (10% boost) |
| **Route 3 Stops** | 9-11 (20% boost) | 10-12 (20% boost) | 11-13 (20% boost) |
| **Location Count** | 76 | 66 | 76 |

::: tip
Longer routes provide a percentage boost on top of the base drug price, rewarding players who choose the harder path. The number of stops is randomized within the range shown.
:::

### Delivery Tier Structure

```lua
Small = {
    XPPerStop = 20,
    Quantity = 50,
    ProcessingTime = { Enable = true, Period = { Hour = 0, Min = 5 } },
    Routes = {
        {Stops = math.random(4, 6), Boost = 0.0},
        {Stops = math.random(7, 8), Boost = 0.15},
        {Stops = math.random(9, 11), Boost = 0.20},
    },
    RouteCount = 3,
    Locations = { ... },
},
```

| Key | Type | Description |
|---|---|---|
| `XPPerStop` | number | XP earned for completing each delivery stop. |
| `Quantity` | number | Number of drug units required per delivery. |
| `ProcessingTime.Enable` | boolean | Whether a processing delay is required before starting. |
| `ProcessingTime.Period` | table | `{ Hour, Min }` -- the processing wait time. |
| `Routes` | table | Array of route options. Each has `Stops` (randomized count) and `Boost` (price multiplier bonus). |
| `RouteCount` | number | Number of routes offered to the player. If less than the routes table, a random subset is selected. |
| `Locations` | table | Array of `{x, y, z}` delivery stop coordinates. |

### Delivery Drugs

```lua
Drugs = {
    ['cokebaggy']        = { Label = "Cocaine",          Icon = "fas fa-capsules",                Price = 120 },
    ['crack_baggy']      = { Label = "Crack",            Icon = "fas fa-pills",                   Price = 100 },
    ['xtcbaggy']         = { Label = "Ecstasy",          Icon = "fas fa-tablets",                  Price = 75  },
    ['oxy']              = { Label = "Oxycodone",        Icon = "fas fa-prescription-bottle-alt",  Price = 135 },
    ['meth']             = { Label = "Methamphetamine",  Icon = "fas fa-flask",                    Price = 125 },
    ['weed_white-widow'] = { Label = "White Widow",      Icon = "fas fa-cannabis",                 Price = 45  },
    ['weed_skunk']       = { Label = "Skunk",            Icon = "fas fa-cannabis",                 Price = 50  },
    ['weed_purple-haze'] = { Label = "Purple Haze",      Icon = "fas fa-cannabis",                 Price = 55  },
    ['weed_og-kush']     = { Label = "OG Kush",          Icon = "fas fa-cannabis",                 Price = 60  },
    ['weed_amnesia']     = { Label = "Amnesia",          Icon = "fas fa-cannabis",                 Price = 65  },
    ['weed_ak47']        = { Label = "AK-47",            Icon = "fas fa-cannabis",                 Price = 70  },
}
```

| Key | Type | Description |
|---|---|---|
| `Label` | string | Display name shown in the delivery menu. |
| `Icon` | string | FontAwesome icon class. |
| `Price` | number | Base price per unit for this drug during deliveries. |

::: info
Delivery drugs also support metadata variants when `Config.EnableMetadata` is `true`. Add a `MetadataVariants` sub-table with `Label`, `Icon`, `Price`, and `Metadata` keys, and optionally set `SellBaseItem = false` to prevent delivering the base item without metadata.
:::

## Milestones

Milestones reward players for reaching cumulative sale thresholds. There are **general** milestones (across all drugs combined) and **drug-specific** milestones.

```lua
Config.Milestones = {
    Enable = true,
    ["general"] = { ... },
    ["oxy"] = { ... },
    -- etc.
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Milestones.Enable` | boolean | `true` | Enable or disable the entire milestone system. If disabled, the milestones menu option will not appear. |

### Reward Types

Milestone rewards can be one of three types:

| Type | Keys | Description |
|---|---|---|
| `"xp"` | `Amount` | Awards XP to the player. |
| `"item"` | `Name`, `Label`, `Amount` | Gives a specific item. |
| `"money"` | `Label`, `Amount` | Awards cash. |

### General Milestones

These count **all** drug sales combined.

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 5,000 | XP | 100 XP |
| 2 | 10,000 | Item | 1x Advanced Lockpick (`advancedlockpick`) |
| 3 | 20,000 | Money | $1,000 |

### Drug-Specific Milestones

Each drug can have its own milestone track. Below are the defaults:

**Oxycodone (`oxy`)**

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 1,000 | Item | 1x Advanced Lockpick (`advancedlockpick`) |
| 2 | 5,000 | Money | $1,000 |

**Cocaine (`cokebaggy`)**

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 800 | XP | 50 XP |
| 2 | 3,000 | XP | 150 XP |

**Crack (`crack_baggy`)**

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 600 | Item | 2x Medkit (`medkit`) |
| 2 | 2,500 | XP | 200 XP |

**Ecstasy (`xtcbaggy`)**

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 1,000 | XP | 100 XP |
| 2 | 4,000 | XP | 200 XP |

**Methamphetamine (`meth`)**

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 900 | Item | 1x Body Armor (`armor`) |
| 2 | 3,500 | XP | 200 XP |

**White Widow (`weed_white-widow`)**

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 1,200 | XP | 100 XP |
| 2 | 5,000 | XP | 200 XP |

**Skunk (`weed_skunk`)**

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 1,200 | Item | 1x Lockpick (`lockpick`) |
| 2 | 5,000 | XP | 200 XP |

**Purple Haze (`weed_purple-haze`)**

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 1,400 | XP | 100 XP |
| 2 | 6,000 | XP | 200 XP |

**OG Kush (`weed_og-kush`)**

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 1,500 | Item | 1x Advanced Medkit (`advanced_medkit`) |
| 2 | 6,000 | XP | 200 XP |

**Amnesia (`weed_amnesia`)**

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 1,600 | XP | 50 XP |
| 2 | 7,000 | XP | 100 XP |

**AK-47 (`weed_ak47`)**

| # | Required Amount | Reward Type | Reward Details |
|---|---|---|---|
| 1 | 1,800 | Item | 1x Heavy Armor (`heavyarmor`) |
| 2 | 7,500 | XP | 100 XP |

## Money Laundering / Washing

### Item-Based Money Washing

```lua
Config.MoneyWashing = {
    WashItem = { Enable = false, Chance = 100, ItemName = "black_money", MinAmount = 500, MaxAmount = 2500 },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `WashItem.Enable` | boolean | `false` | Enable item-based money washing with a 1-to-1 ratio (1 item = $1). |
| `WashItem.Chance` | number | `100` | Percentage chance of a successful wash. |
| `WashItem.ItemName` | string | `"black_money"` | The dirty money item to wash. |
| `WashItem.MinAmount` | number | `500` | Minimum amount washed per transaction. |
| `WashItem.MaxAmount` | number | `2500` | Maximum amount washed per transaction. |

::: warning
When `Config.MoneyWashing.WashItem.Enable` is `true`, it overrides the per-level `Washing` settings. However, the per-level `Tax` percentage still applies. It is recommended to disable this if your server does not use a 1-to-1 ratio marked money item.
:::

## NPC Ped Spawning (Command)

The dynamic ped spawning command lets players spawn sellable NPCs around them.

```lua
Config.Command = {
    Enable = false,
    Name = "cornerselling",
    Ped = {
        Models = { "a_m_y_hipster_01", "a_m_y_hipster_02", ... },
        DefaultModel = "a_m_y_business_01",
        Radius = 50.0,
        Network = false,
        DespawnDistance = 100.0,
        SpawnInterval = {min = 5000, max = 10000},
        MaxSpawned = 50,
        FieldOfView = 180,
        BehindPlayerDistance = 25.0,
        MaxZDifference = 0.5,
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Enable` | boolean | `false` | Enable or disable the spawning command. |
| `Name` | string | `"cornerselling"` | The chat command name (used as `/cornerselling`). |
| `Ped.Models` | table | 50 models | List of ped model names that can be randomly selected for spawning. |
| `Ped.DefaultModel` | string | `"a_m_y_business_01"` | Fallback model if none from the list can be loaded. |
| `Ped.Radius` | number | `50.0` | Radius around the player in which peds spawn. |
| `Ped.Network` | boolean | `false` | Whether spawned peds are networked. `false` is highly recommended to keep them client-side. |
| `Ped.DespawnDistance` | number | `100.0` | Distance at which spawned peds are automatically despawned. |
| `Ped.SpawnInterval.min` / `max` | number | `5000` / `10000` | Interval range (in milliseconds) between ped spawns. |
| `Ped.MaxSpawned` | number | `50` | Maximum number of peds that can exist at once. |
| `Ped.FieldOfView` | number | `180` | Degrees in front of the player where peds should **not** spawn (to avoid appearing in view). |
| `Ped.BehindPlayerDistance` | number | `25.0` | Minimum distance behind the player to spawn a ped. |
| `Ped.MaxZDifference` | number | `0.5` | Maximum allowed Z (height) difference above the player for ped spawning. |

## Delivery Ped

The delivery ped is the NPC that players interact with to start delivery missions.

```lua
Config.Ped = {
    Enable = true,
    Location = {
        {x = 1075.619, y = -2330.657, z = 29.29169, w = 352.8969},
        {x = 864.2555, y = -967.3761, z = 26.86267, w = 293.9679},
        {x = -594.4417, y = -748.6177, z = 28.48703, w = 177.1182},
    },
    Model = "ig_ballasog",
    Interaction = {
        Icon = "fas fa-circle",
        Distance = 3.0,
    },
    Scenario = "WORLD_HUMAN_STAND_IMPATIENT",
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Enable` | boolean | `true` | Enable or disable the delivery ped. |
| `Location` | table | 3 locations | Array of `{x, y, z, w}` positions. One is randomly selected each time the resource starts. |
| `Model` | string | `"ig_ballasog"` | Ped model to use. |
| `Interaction.Icon` | string | `"fas fa-circle"` | Target interaction icon. |
| `Interaction.Distance` | number | `3.0` | Interaction distance in game units. |
| `Scenario` | string | `"WORLD_HUMAN_STAND_IMPATIENT"` | The ambient animation scenario the ped plays while idle. |

### Delivery Ped Blip

```lua
Config.Blip = {
    Enable = false,
    Sprite = 480,
    Display = 4,
    Scale = 0.6,
    Colour = 1,
    Name = "Drug Lord Jeff",
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Enable` | boolean | `false` | Whether a map blip is displayed for the delivery ped. |
| `Sprite` | number | `480` | Blip sprite icon ID. |
| `Display` | number | `4` | Blip display type. |
| `Scale` | number | `0.6` | Blip scale. |
| `Colour` | number | `1` | Blip colour ID. |
| `Name` | string | `"Drug Lord Jeff"` | Blip label on the map. |

## Animations

Animation configuration supports shared settings for all drug handshake animations and per-drug overrides.

```lua
Config.Animations = {
    general = {
        cashModel = 'hei_prop_heist_cash_pile',
        cashPos   = { x = 0.13, y = 0.02, z = 0.0 },
        cashRot   = { x = -90.0, y = 0.0,  z = 0.0 },
        animDict  = 'mp_common',
        animClip  = 'givetake1_a',
    },
    drugs = {
        default = {
            drugModel = 'prop_weed_bottle',
            drugPos   = { x = 0.13, y = 0.02, z = 0.0 },
            drugRot   = { x = -90.0, y = 0.0,  z = 0.0 },
        },
        -- Per-drug overrides go here
    },
}
```

### General Animation Settings

| Key | Type | Default | Description |
|---|---|---|---|
| `general.cashModel` | string | `'hei_prop_heist_cash_pile'` | Model for the cash prop attached to the NPC's hand. Applies to all drugs. |
| `general.cashPos` | table | `{x=0.13, y=0.02, z=0.0}` | Attachment position of the cash prop relative to the hand bone. |
| `general.cashRot` | table | `{x=-90.0, y=0.0, z=0.0}` | Attachment rotation of the cash prop. |
| `general.animDict` | string | `'mp_common'` | Default animation dictionary for the handoff. |
| `general.animClip` | string | `'givetake1_a'` | Default animation clip for the handoff. |

### Per-Drug Animation Overrides

| Key | Type | Default | Description |
|---|---|---|---|
| `drugs.default.drugModel` | string | `'prop_weed_bottle'` | Fallback drug prop model when no override exists. |
| `drugs.default.drugPos` | table | `{x=0.13, y=0.02, z=0.0}` | Fallback attachment position. |
| `drugs.default.drugRot` | table | `{x=-90.0, y=0.0, z=0.0}` | Fallback attachment rotation. |

::: tip
To add a custom animation for a specific drug, add a new entry under `drugs` keyed by the drug's spawn name. You can override `drugModel`, `drugPos`, `drugRot`, and optionally `animDict` / `animClip`. Any property not specified falls back to the general/default values.
:::

## Blacklisted Peds

Ped models that cannot be interacted with or used for selling drugs.

```lua
Config.BlacklistedPeds = {
    [`s_m_y_ranger_01`]  = true,
    [`s_m_y_sheriff_01`] = true,
    [`s_m_y_cop_01`]     = true,
    [`s_f_y_sheriff_01`] = true,
    [`s_f_y_cop_01`]     = true,
    [`s_m_y_hwaycop_01`] = true,
}
```

| Key | Type | Description |
|---|---|---|
| Model hash | boolean | Set to `true` to blacklist a ped model. Uses backtick hash notation. |

The default blacklist includes all standard law enforcement ped models: rangers, sheriffs, cops, and highway patrol.

## Stats

```lua
Config.Stats = {
    Enable = true,
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Stats.Enable` | boolean | `true` | Show the Stats option in the menu. If disabled and `Config.Milestones.Enable` is `true`, only the Milestones option will appear. If both are disabled, no menu option is shown. |

## Police Alert

The `policeAlert` function is called whenever the police should be notified of suspicious dealings. It uses `SD.PoliceDispatch` and can be fully customized.

```lua
policeAlert = function()
    SD.PoliceDispatch({
        displayCode = "10-31S",
        title = 'Suspicious Dealings',
        description = "Suspicious activities reported",
        message = "Suspects reported engaging in suspicious dealings",
        sprite = 310,
        scale = 1.0,
        colour = 1,
        blipText = "Suspicious Dealings",
        dispatchcodename = "suspicious_dealings",
    })
end
```

| Key | Type | Default | Description |
|---|---|---|---|
| `displayCode` | string | `"10-31S"` | Dispatch code shown in the alert. |
| `title` | string | `'Suspicious Dealings'` | Title used in cd_dispatch / ps-dispatch. |
| `description` | string | `"Suspicious activities reported"` | Description of the incident. |
| `message` | string | `"Suspects reported engaging in suspicious dealings"` | Additional message text. |
| `sprite` | number | `310` | Blip sprite for the dispatch alert. |
| `scale` | number | `1.0` | Blip scale on the map. |
| `colour` | number | `1` | Blip colour (e.g., red). |
| `blipText` | string | `"Suspicious Dealings"` | Text label on the blip. |
| `dispatchcodename` | string | `"suspicious_dealings"` | Code name used by ps-dispatch in `sv_dispatchcodes.lua` or `Config.Blips`. |

## Logging

Logging is configured in `server/logs.lua` and supports multiple services.

```lua
return {
    logs = {
        service     = 'none',
        dataset     = 'sd-selling',
        screenshots = false,
        events = {
            complete_stop      = true,
            add_xp             = true,
            stash_drugs        = true,
            return_drugs       = true,
            complete_encounter = true,
            redeem_milestone   = true,
            sell_drug          = true,
            money_launder      = true,
        },
    },
}
```

### Logging Service

| Key | Type | Default | Description |
|---|---|---|---|
| `service` | string | `'none'` | Logging backend. Options: `'none'`, `'fivemanage'`, `'fivemerr'`, `'discord'`, `'loki'`, `'grafana'`. |
| `dataset` | string | `'sd-selling'` | Fivemanage dataset ID (only used when service is `'fivemanage'`). |
| `screenshots` | boolean | `false` | Include screenshots with logs. Only applicable to Fivemanage and Fivemerr. |

### Loggable Events

| Event | Default | Description |
|---|---|---|
| `complete_stop` | `true` | A delivery stop is completed. |
| `add_xp` | `true` | XP is awarded to a player. |
| `stash_drugs` | `true` | Drugs are marked as stolen. |
| `return_drugs` | `true` | Stolen drugs are returned. |
| `complete_encounter` | `true` | An encounter finishes. |
| `redeem_milestone` | `true` | A milestone is redeemed. |
| `sell_drug` | `true` | A player sells drugs / receives payout. |
| `money_launder` | `true` | A player launders money. |

### Discord Webhook Settings

| Key | Type | Default | Description |
|---|---|---|---|
| `discord.name` | string | `'Selling Logs'` | Webhook display name. |
| `discord.link` | string | `''` | Webhook URL. |
| `discord.image` | string | `''` | Webhook avatar image URL. |
| `discord.footer` | string | `''` | Webhook footer icon URL. |

### Loki Settings

| Key | Type | Default | Description |
|---|---|---|---|
| `loki.endpoint` | string | `''` | Loki push URL (without trailing slash). |
| `loki.user` | string | `''` | Basic auth username (optional). |
| `loki.password` | string | `''` | Basic auth password or API key (optional). |
| `loki.tenant` | string | `''` | `X-Scope-OrgID` header value (optional). |

### Grafana Cloud Logs Settings

| Key | Type | Default | Description |
|---|---|---|---|
| `grafana.endpoint` | string | `''` | Grafana Logs base URL (without trailing slash). |
| `grafana.apiKey` | string | `''` | Grafana API key (prefixed with `'Bearer '`). |
| `grafana.tenant` | string | `''` | `X-Scope-OrgID` header value (optional). |

## Locale

Change the language by editing the locale loader near the top of `config.lua`:

```lua
SD.Locale.LoadLocale('en')
```

Replace `'en'` with any available language file from the `locales` folder.
