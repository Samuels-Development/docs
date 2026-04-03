# Configuration

All configuration is in `config.lua` in the resource root. The main table is `Beekeeping` — all options are nested under it.

## Locale

```lua
Locale.LoadLocale('en')  -- Options: 'en', 'de', 'es', 'fr', 'ar'
```

Check the `locales/` folder for available translations. See the [FAQ on changing locales](/faq/changing-locales) for adding custom languages.

## General Settings

```lua
Beekeeping.DebugZones = false        -- Visualize honey zones, interaction areas
Beekeeping.Interaction = 'target'    -- 'target' or 'textui'
Beekeeping.InteractionDistance = 3.0 -- Distance to interact with facilities
Beekeeping.SpawnRange = 100          -- Render distance for hives/houses (meters)
Beekeeping.RaycastingDistance = 10.0 -- Max distance when placing structures
Beekeeping.LoadOnStart = true        -- true = load on resource start, false = on player load
```

| Setting | Default | Description |
|---|---|---|
| `DebugZones` | `false` | Shows debug markers for zones and interactions |
| `Interaction` | `'target'` | Use `'target'` (ox_target/qb-target/qtarget) or `'textui'` |
| `InteractionDistance` | `3.0` | How close a player must be to interact |
| `SpawnRange` | `100` | Object render distance from player |
| `RaycastingDistance` | `10.0` | How far you can place from your position |
| `LoadOnStart` | `true` | Load all objects on resource start vs. per-player |

## Placement Limits

```lua
Beekeeping.Max = {
    Hives = 5,   -- Max bee hives per player
    Houses = 5   -- Max bee houses per player
}
```

## Save System

```lua
Beekeeping.Saving = {
    Method = 'txadmin',  -- 'txadmin', 'interval', or 'resourceStop'
    Interval = 30        -- Minutes (only used when Method = 'interval')
}
```

| Method | Behavior |
|---|---|
| `txadmin` | Saves on txAdmin scheduled restart |
| `interval` | Automatic save every N minutes |
| `resourceStop` | Saves when the resource stops |

::: tip
The `interval` method is safest for production servers. A server crash with `resourceStop` loses all unsaved data.
:::

## Prop Types

```lua
Beekeeping.Type = 'native'  -- 'native', 'bzzz', 'nopixel', 'custom'
```

| Type | House Prop | Hive Prop |
|---|---|---|
| `native` | `hp3d_beehive1` | `hp3d_beehive2` |
| `bzzz` | `bzzz_props_beehive_box_002` | `bzzz_props_beehive_box_001` |
| `nopixel` | `np_beehive` | `np_beehive02` |
| `custom` | Set your own prop names | Set your own prop names |

::: info
The `bzzz` and `nopixel` prop types require their respective asset packs to be streamed.
:::

## Durability & Decay

```lua
Beekeeping.Expiry = {
    EnableExpiration = true,
    DecaySettings = {
        hive = {
            DecayRate = 1,       -- Durability points lost per interval
            DecayInterval = 60   -- Minutes between decay ticks
        },
        house = {
            DecayRate = 2,
            DecayInterval = 120
        }
    },
    RepairCostPerOne = 100       -- $ per durability point restored
}
```

| Facility | Decay Rate | Interval | Full repair cost (0→100) |
|---|---|---|---|
| **Hive** | 1 per tick | Every 60 min | $10,000 |
| **House** | 2 per tick | Every 120 min | $10,000 |

## Pickup

```lua
Beekeeping.Pickup = {
    Enable = true,
    MinDurability = 95  -- Minimum % durability to pick up (0-100)
}
```

::: warning
A hive at 94% durability cannot be picked up. Repair it to at least 95% first.
:::

## Access Control

```lua
Beekeeping.LockAccess = true  -- Only owner + collaborators can interact
```

## Infection System

```lua
Beekeeping.Infection = {
    Enable = true,
    CheckInterval = 10,            -- Minutes between infection checks
    SeverityIncreaseInterval = 1,  -- Minutes between severity increases
    InfectionChance = 1,           -- 1 in X chance of infection per check

    WorkerDeathChance = 20,        -- Base % chance workers die per check
    WorkerDeathCountRange = {1, 3},
    QueenDeathBaseChance = 0,      -- Base % per severity level

    TreatmentEnabled = true,       -- Allow thymol treatment

    SeverityLevels = {
        [1] = {
            WorkerDeathChance = 20,
            WorkerDeathCountRange = {1, 3},
            QueenDeathChance = 0,
            ProductionDelayMultiplier = 2.0
        },
        [2] = {
            WorkerDeathChance = 30,
            WorkerDeathCountRange = {2, 4},
            QueenDeathChance = 5,
            ProductionDelayMultiplier = 2.5
        },
        [3] = {
            WorkerDeathChance = 50,
            WorkerDeathCountRange = {3, 6},
            QueenDeathChance = 10,
            ProductionDelayMultiplier = 3.0
        }
    },
}
```

### Severity Effects

| Level | Worker Death % | Workers Lost | Queen Death % | Production Speed |
|---|---|---|---|---|
| 1 | 20% | 1–3 | 0% | 2x slower |
| 2 | 30% | 2–4 | 5% | 2.5x slower |
| 3 | 50% | 3–6 | 10% | 3x slower |

### Infection Shields

Time-limited protection that prevents infection while active:

```lua
Beekeeping.Infection.ShieldsEnabled = true

Beekeeping.Infection.ProtectionTiers = {
    [1] = { cost = 500,  duration = 720  },  -- 12 hours
    [2] = { cost = 1000, duration = 1440 },  -- 24 hours
    [3] = { cost = 2000, duration = 2880 },  -- 48 hours
}
```

| Tier | Cost | Duration |
|---|---|---|
| **1** | $500 | 12 hours |
| **2** | $1,000 | 24 hours |
| **3** | $2,000 | 48 hours |

## Aggression System

```lua
Beekeeping.Aggression = {
    Enable = true,
    DefaultLevel = 1,          -- Starting level (1-4)
    UpdateInterval = 120,      -- Minutes between aggression rolls

    Levels = {
        [1] = { nameKey = "aggression.name_calm",       damage = 0  },
        [2] = { nameKey = "aggression.name_alert",       damage = 5  },
        [3] = { nameKey = "aggression.name_defensive",   damage = 10 },
        [4] = { nameKey = "aggression.name_aggressive",  damage = 20 },
    },

    StingChance = {
        [1] = 0,    -- Calm: no stings
        [2] = 20,   -- Alert: 20%
        [3] = 50,   -- Defensive: 50%
        [4] = 80,   -- Aggressive: 80%
    },

    SmokerReduceBy = 'all',    -- 'all' or number of levels to reduce
    SmokerRemoveChance = 25,   -- % chance smoker breaks on use
}
```

### Aggression Increase Factors

Aggression rolls happen every `UpdateInterval` minutes. The chance to increase is:

```lua
Beekeeping.Aggression.Chance = {
    Base = 5,            -- Base %
    PerWorker = 0.1,     -- +% per worker bee in the hive
    PerSeverity = 2,     -- +% per infection severity level
    FullHiveBonus = 5,   -- +% if hive is full of honey
    FullHouseBonus = 5,  -- +% if house is full of bees
    Max = 90             -- Hard cap at 90%
}
```

**Example:** A hive with 30 workers and severity 2 infection:
`5 + (30 × 0.1) + (2 × 2) = 12%` chance to increase aggression per roll.

### Protective Clothing

```lua
Beekeeping.Aggression.ProtectiveClothing = {
    Enable = true,
    Mode = "any",  -- 'any', 'all', 'category_any', 'category_all'

    Components = {
        Common = { { id = "hats", drawable = 5 } },
        Male   = { { id = "masks", drawable = 21 } },
        Female = { { id = "masks", drawable = 15 } },
    },
    Props = {
        Common = { { id = "hats", drawable = 14 } },
        Male   = { { id = "masks", drawable = 5 } },
        Female = { { id = "masks", drawable = 2 } },
    },
    Categories = { "masks" },  -- Required categories for category modes
}
```

| Mode | Behavior |
|---|---|
| `any` | Any single protective item reduces sting chance |
| `all` | All defined items must be worn for protection |
| `category_any` | Any item from required categories is enough |
| `category_all` | All required categories must have a matching item |

## Bee House Settings

```lua
Beekeeping.House = {
    CaptureTime = 300,         -- Seconds to capture bees (5 min)
    QueenSpawnChance = 10,     -- % chance to get a queen
    BeesPerCapture = {2, 3},   -- Min/max workers per capture
    QueensPerCapture = 1,      -- Queens per successful queen capture
    MaxQueens = 5,             -- Max queens per house
    MaxWorkers = 50,           -- Max workers per house
    UseItemImages = true       -- Show item images in the menu
}
```

## Hive Settings

```lua
Beekeeping.Hives = {
    -- Honey
    HoneyTime = 600,           -- Seconds between production cycles (10 min)
    HoneyPerTime = {1, 2},     -- Min/max honey per cycle
    MaxHoney = 100,            -- Max honey capacity

    -- Wax
    ChanceOfWax = 10,          -- % chance to also produce wax
    WaxPerTime = {1, 2},       -- Min/max wax per cycle
    MaxWax = 20,               -- Max wax capacity

    -- Bees Required
    NeededQueens = 1,          -- Queens needed to start producing
    NeededWorkers = 5,         -- Workers needed to start producing
    MaxWorkers = 50,           -- Max workers per hive

    UseItemImages = true
}
```

::: info
Production only begins once the hive has at least `NeededQueens` queens and `NeededWorkers` workers. Below that threshold, nothing is produced.
:::

## Production Multipliers

```lua
Beekeeping.WorkerThreshold = 10  -- Workers per multiplier tier

Beekeeping.Multipliers = {
    [1] = 1.2,   -- 10-19 workers
    [2] = 1.3,   -- 20-29 workers
    [3] = 1.4,   -- 30-39 workers
    [4] = 1.5,   -- 40-49 workers
    [5] = 2.0,   -- 50+ workers
}
```

## Honey Zones

Three geographic zones define where regional honey is produced:

```lua
Beekeeping.HoneyZones = {
    Enable = true,
    { name = 'Chiliad Meadow',  honeyType = 'chiliad',     thickness = 750, points = { ... } },
    { name = 'Green Hills',     honeyType = 'green_hills',  thickness = 750, points = { ... } },
    { name = 'Alamo Grove',     honeyType = 'alamo',        thickness = 750, points = { ... } },
}

Beekeeping.HoneyTypes = {
    ['chiliad']     = { displayName = 'Chiliad Honey',     item = 'chiliad-honey' },
    ['green_hills'] = { displayName = 'Green Hills Honey', item = 'green-hills-honey' },
    ['alamo']       = { displayName = 'Alamo Honey',       item = 'alamo-honey' },
    ['basic']       = { displayName = 'Bee Honey',         item = 'bee-honey' },
}
```

Hives outside all zones produce `basic` (Bee Honey).

## Beekeeper NPC

```lua
Beekeeping.Beekeeper = {
    Enable = true,
    Location = {
        { x = 426.05, y = 6478.9, z = 27.84, w = 234.9 }
    },
    Model = "a_m_m_farmer_01",
    Interaction = {
        Icon = "fas fa-circle",
        Distance = 3.0
    },
    SpawnDistance = 50.0,
    Scenario = "WORLD_HUMAN_STAND_IMPATIENT"
}
```

::: tip
Add multiple entries to `Location` to create additional beekeeper spawn points around the map.
:::

## Blips

### Beekeeper Blip

```lua
Beekeeping.Blip = {
    Enable = true,
    Sprite = 106,
    Display = 4,
    Scale = 0.7,
    Colour = 33,
    Name = "Beekeeper"
}
```

### Facility Blips (Player-Toggleable)

```lua
Beekeeping.FacilityBlip = {
    Enable = true,
    ["house"] = { sprite = 40, color = 10, scale = 0.6, label = "Bee House" },
    ["hive"]  = { sprite = 40, color = 5,  scale = 0.6, label = "Bee Hive" },
}
```

Players can toggle their own facility blips on/off from the hive management menu.

## Shop Prices

```lua
Beekeeping.Shop = {
    UseItemImages = false,
    ShowPricesOnTitles = true,

    BuyItems = {
        { product = "bee-house", price = 1000 },
        { product = "bee-hive",  price = 1000 },
        { product = "thymol",    price = 500  },
        { product = "bee-smoker", price = 750 },
    },

    SellItems = {
        { product = "bee-wax",           price = 750 },
        { product = "chiliad-honey",     price = 750 },
        { product = "green-hills-honey", price = 750 },
        { product = "alamo-honey",       price = 750 },
        { product = "bee-honey",         price = 500 },
    },
}
```

## Collaborator System

```lua
Beekeeping.LimitCollaborators = {
    Enable = false,  -- Enforce max collaborations per player
    Max = 5          -- Max facilities a player can collaborate on
}

Beekeeping.NearbyInvite = {
    Enable = true,
    Distance = 10.0,
    Display = {
        Source = true,          -- Show server ID
        Identifier = false,    -- Show citizenid
        CharacterName = true   -- Show character name
    }
}
```

## Exclusion Zones

Define areas where hives/houses cannot be placed:

```lua
Beekeeping.ExclusionZones = {
    { coords = vector3(426.05, 6478.9, 27.84), radius = 100 }
}
```

## Item References

Map logical names to actual item IDs (change these if your items have different names):

```lua
Beekeeping.Items = {
    QueenItem     = 'bee-queen',
    WorkerItem    = 'bee-worker',
    HoneyItem     = 'bee-honey',
    WaxItem       = 'bee-wax',
    HiveItem      = 'bee-hive',
    HouseItem     = 'bee-house',
    TreatmentItem = 'thymol',
    SmokerItem    = 'bee-smoker',
}
```

::: tip
If you rename items in your inventory system, update these references to match. The script uses these keys internally to add/remove items.
:::
