# Configuration

All configuration for sd-dumpsters is split across three files in the `configs/` directory:

- **`configs/config.lua`** -- Main configuration (locale, items, cooldowns, events, Hobo King, levels, loot tables, shop, daily system, milestones, zones)
- **`configs/rats.lua`** -- Rat companion configuration (levels, perks, expeditions, exports)
- **`configs/recycler.lua`** -- Recycler configuration (locations, items, processing times)

## Locale

The locale is loaded at the top of `configs/config.lua`:

```lua
Locale.LoadLocale('en') -- Options: 'en', 'es', 'de', 'fr', 'ar'
```

Change the string to load a different language. Locale files are stored in the `locales/` directory as JSON files.

## Core Items

```lua
Config.Items = {
    BottleCap = 'bottle_cap', -- Currency item for the Hobo King shop
    Grinder = 'powersaw'      -- Tool required to open locked dumpsters
}
```

These define the item names used internally. Change them to match your inventory system if you use different item names.

## Cooldown System

```lua
Config.DumpsterCooldown = 10 -- Cooldown in minutes before a player can loot a dumpster or trash can again
Config.GlobalCooldown = true -- true = shared cooldowns across all players, false = per-player cooldowns
```

| Setting | Default | Description |
|---|---|---|
| `Config.DumpsterCooldown` | `10` | Minutes before the same dumpster can be looted again |
| `Config.GlobalCooldown` | `true` | When `true`, cooldowns are shared (uses networking). When `false`, each player has independent cooldowns |

::: warning
If your server produces a large volume of networked entities, dumpster networking may fail and prevent looting. If you experience this, set `Config.GlobalCooldown` to `false` to use per-player cooldowns without networking.
:::

## Payout Method

```lua
Config.Payout = 'caps' -- 'cash' or 'caps'
```

Controls how buying/selling transactions with the Hobo King are handled:
- `'caps'` -- Uses the `bottle_cap` item as currency
- `'cash'` -- Uses the framework's in-game money system

## Stash and Loot Delivery

```lua
Config.Stashes = {
    Enable = true, -- Enable openable stashes on dumpsters and trash cans (requires ox_inventory)
}

Config.LootToStash = false -- true = loot goes into a temporary stash, false = items go directly to inventory
```

| Setting | Default | Description |
|---|---|---|
| `Config.Stashes.Enable` | `true` | Adds a "Open Dumpster"/"Open Trash Can" target option that opens a persistent stash. Requires `ox_inventory` |
| `Config.LootToStash` | `false` | When `true`, search loot is deposited into a temporary stash instead of the player's inventory. Requires `ox_inventory` |

## Chance-Based Events

```lua
Config.Events = {
    NeedlePrick = {
        Enable = true,      -- Toggle needle prick events
        Duration = 120,     -- Duration of the drunk/drug effect in seconds
        Cooldown = 600,     -- Cooldown before the player can get pricked again (seconds)
    },
    HoboAttack = {
        Enable = true,      -- Toggle hobo attack events
        Cooldown = 600,     -- Cooldown before the player can get attacked again (seconds)
        Models = {          -- Ped models used for attacking hobos (randomized)
            'a_m_m_tramp_01',
            'a_m_m_trampbeac_01',
            'a_m_m_hillbilly_01',
            'a_m_m_hillbilly_02',
            'a_f_m_tramp_01',
            'a_f_m_trampbeac_01',
        },
        MaxDistance = 150,   -- Distance before the hobo despawns
        Weapon = {
            Enable = true,          -- Give the hobo a weapon
            Name = "WEAPON_KNIFE",  -- Weapon to equip
            DropWeapon = true       -- Add the weapon to the hobo's loot pool when looted
        }
    }
}
```

::: info
The **chance** of needle pricks and hobo attacks is not set here. It is defined **per level** in `Config.Levels` as `NeedlePrickChance` and `HoboAttackChance`. This means higher-level players have lower event chances.
:::

## Hobo King NPC

```lua
Config.Ped = {
    Enable = true,
    Location = {
        {x = 3.152987, y = -1215.155, z = 25.70303, w = 267.1587}
        -- Add more locations as needed; one is chosen at random each script start
    },
    Model = "u_m_y_militarybum",
    Interaction = {
        Icon = "fas fa-circle",
        Distance = 3.0,
    },
    Scenario = "WORLD_HUMAN_BUM_STANDING"
}

Config.Blip = {
    Enable = false,     -- Show a map blip for the Hobo King
    Sprite = 480,
    Display = 4,
    Scale = 0.6,
    Colour = 1,
    Name = "Hobo King",
}
```

| Setting | Default | Description |
|---|---|---|
| `Config.Ped.Enable` | `true` | Toggle the Hobo King NPC entirely |
| `Config.Ped.Location` | 1 location | Array of `{x, y, z, w}` tables. A random one is picked each script start |
| `Config.Ped.Model` | `"u_m_y_militarybum"` | The ped model used for the Hobo King |
| `Config.Ped.Interaction.Distance` | `3.0` | Target interaction distance |
| `Config.Ped.Scenario` | `"WORLD_HUMAN_BUM_STANDING"` | The ambient animation the NPC plays |
| `Config.Blip.Enable` | `false` | Whether to show a map blip for the King's location |

## Shop

```lua
Config.Shop = {
    Buy = {
        ['lockpick'] = { price = 150 },
        ['weapon_knuckle'] = { price = 100 },
        ['weapon_switchblade'] = { price = 150 },
        ['low_quality_meth'] = { price = 150, level = 3 }, -- Optional level restriction
    },
    Sell = {
        ['metalscrap'] = { price = 5 },
        ['plastic'] = { price = 5 },
        -- ... more items
    },
}
```

- **Buy items** can have an optional `level` field to restrict purchases to players at or above that scavenging level
- Prices are in caps or cash depending on `Config.Payout`
- The currency label and behavior is handled automatically

## Item Metadata

```lua
Config.ItemsMetadata = {
    ['lockpick'] = { label = 'Lockpick', icon = 'fas fa-tools' },
    ['metalscrap'] = { label = 'Scrap Metal', icon = 'fas fa-cogs' },
    -- ... more items
}
```

This table defines the display label and Font Awesome icon for every item used in the script's menus and notifications. Add entries here for any custom items you add to loot tables.

## Leveling System

Players progress through 5 levels. Each level adjusts multiple gameplay parameters:

```lua
Config.Levels = {
    [1] = {
        Duration = 10,          -- Seconds to search a dumpster
        XPThreshold = 2000,     -- XP needed to reach the NEXT level
        LockChance = 25,        -- % chance a large dumpster is locked
        SawDuration = 15,       -- Seconds to saw open a locked dumpster
        LockCooldown = 30,      -- Minutes between locked dumpster encounters
        BagLootChance = 25,     -- % chance of finding loot in bags
        DumpsterLootChance = 60,-- % chance of finding loot in dumpsters
        CampLootChance = 50,    -- % chance of finding loot in camps
        NeedlePrickChance = 25, -- % chance of needle prick event
        HoboAttackChance = 15   -- % chance of hobo attack event
    },
    [2] = { ... },
    [3] = { ... },
    [4] = { ... },
    [5] = { ... }
}
```

### Default Level Progression

| Level | Search Duration | XP to Next | Lock Chance | Dumpster Loot % | Camp Loot % | Bag Loot % | Needle % | Hobo % |
|---|---|---|---|---|---|---|---|---|
| 1 | 10s | 2,000 | 25% | 60% | 50% | 25% | 25% | 15% |
| 2 | 9s | 5,000 | 20% | 65% | 55% | 30% | 22% | 14% |
| 3 | 8s | 10,000 | 15% | 70% | 60% | -- | 20% | 13% |
| 4 | 6s | 16,000 | 10% | 75% | 65% | 50% | 18% | 11% |
| 5 | 4s | 24,000 | 5% | 80% | 70% | 75% | 15% | 9% |

## Locked Dumpsters

```lua
Config.LockedDumpster = {
    Enable = true, -- Toggle locked dumpsters (large dumpsters only)
}
```

When enabled, large dumpsters have a chance (per `Config.Levels[level].LockChance`) of being locked. Players need the `powersaw` item (defined in `Config.Items.Grinder`) to open them.

## Bin and Dumpster Props

```lua
Config.BinProps = {
    Small = {  -- Trash cans/bins
        'prop_bin_07b', 'prop_bin_01a', 'prop_recyclebin_03_a', -- ... more
    },
    Large = {  -- Dumpsters/skips (can be locked)
        'prop_skip_05a', 'prop_dumpster_3a', 'prop_skip_08a', -- ... more
    },
}
```

These lists define which GTA V prop models the script recognizes as searchable containers. Large props can be locked; small props cannot.

## Loot Tables

### Dumpster Loot

```lua
Config.DumpsterLoot = {
    [1] = { -- Level 1
        Amount = {min = 2, max = 3},
        Items = {
            { name = 'metalscrap', quantity = {min = 1, max = 2}, chance = 50, xp = 5 },
            { name = 'plastic', quantity = {min = 1, max = 2}, chance = 30, xp = 5 },
            { name = 'glass', quantity = {min = 1, max = 2}, chance = 20, xp = 5 }
        },
        RareItem = {
            Enable = true,
            Items = {
                { name = 'lockpick', quantity = {min = 1, max = 1}, xp = 50 },
            },
            Quantity = {min = 1, max = 2},
            Chance = 2,        -- % chance of rare drop
            Cooldown = 30      -- Minutes between rare drops
        }
    },
    -- [2] through [5] with progressively better loot
}
```

Each loot table entry works as follows:
- **`Amount`**: How many item rolls are made from the `Items` list (uses `{min, max}` range)
- **`Items[].chance`**: Weighted probability for that item being selected in a roll
- **`Items[].xp`**: Bonus XP awarded to the player if this item is selected
- **`RareItem.Chance`**: Flat percentage chance of a rare item dropping in addition to normal loot
- **`RareItem.Cooldown`**: Minutes before another rare item can drop for the same player

### Bag Loot

Defined in `Config.Bags.Loot` with the same per-level structure as dumpster loot. Bags also have their own prop models and enable/disable toggle:

```lua
Config.Bags = {
    Enable = true,
    Models = { 'bkr_prop_fakeid_binbag_01', 'prop_rub_binbag_01', ... },
    Loot = {
        [1] = { ... }, -- Same structure as Config.DumpsterLoot
    }
}
```

### Hobo Camp Loot

Defined in `Config.HoboCamps` with camp-specific models and an independent cooldown:

```lua
Config.HoboCamps = {
    Enable = true,
    Cooldown = 30,   -- Minutes before a camp can be searched again
    Models = { "prop_skid_tent_01b", "prop_skid_tent_cloth", ... },
    Loot = {
        [1] = { ... }, -- Same per-level loot structure
    }
}
```

### Hobo Loot

Loot from defeated hobo NPCs (after a hobo attack event):

```lua
Config.HoboLoot = {
    Enable = true,
    Amount = {min = 2, max = 4},
    Items = {
        { name = 'bottle_cap', quantity = {min = 1, max = 2}, chance = 50, xp = 10 },
        { name = 'metalscrap', quantity = {min = 1, max = 3}, chance = 40, xp = 5 },
        { name = 'plastic', quantity = {min = 1, max = 2}, chance = 30, xp = 5 },
        { name = 'lockpick', quantity = {min = 1, max = 1}, chance = 3, xp = 25 },
    },
    RareItem = {
        Enable = true,
        Items = {
            { name = 'md_silverearings', quantity = {min = 1, max = 1}, xp = 100 },
        },
        Quantity = {min = 1, max = 1},
        Chance = 5,
        Cooldown = 15,
    }
}
```

## Custom Zones

Override loot tables in specific map areas using polygon zones:

```lua
Config.Zones = {
    Enable = false,
    {
        name = "Burgershot",
        points = {
            vector3(-1155.22, -892.34, 0.0),
            vector3(-1205.06, -921.80, 0.0),
            vector3(-1223.98, -893.33, 0.0),
            vector3(-1174.48, -860.87, 0.0)
        },
        thickness = 100,
        debug = true,
        LootTable = {
            Amount = 1,
            Items = {
                { name = 'WEAPON_CARBINERIFLE', quantity = {min = 1, max = 1}, chance = 5, xp = 100 },
            }
        }
    },
}
```

When a player searches a dumpster inside a defined zone, the zone's `LootTable` is used instead of the default `Config.DumpsterLoot`.

## Minigames

Configure which minigame/skill-check is required for looting dumpsters and camps:

```lua
Config.Minigame = {
    Dumpsters = {
        Enable = true,
        Minigame = 'lib.skillCheck', -- Which minigame to use
        Args = {
            ['lib.skillCheck'] = {
                {'easy', 'medium', {areaSize = 40, speedMultiplier = 1.2}},
                {'w', 'a', 's', 'd'}
            },
            -- Arguments for other supported minigames...
        }
    },
    Camps = {
        Minigame = 'lib.skillCheck',
        Args = { ... }
    }
}
```

### Supported Minigames

The script supports a wide variety of minigame resources:

| Resource | Minigame Keys |
|---|---|
| **ox_lib** | `lib.skillCheck` |
| **ps-ui** | `ps-circle`, `ps-maze`, `ps-varhack`, `ps-thermite`, `ps-scrambler` |
| **memorygame** | `memorygame-thermite` |
| **ran-minigames** | `ran-memorycard`, `ran-openterminal` |
| **hacking** | `hacking-opengame` |
| **howdy-hackminigame** | `howdy-begin` |
| **SN-Hacking** | `sn-memorygame`, `sn-skillcheck`, `sn-thermite`, `sn-keypad`, `sn-colorpicker` |
| **rm_minigames** | `rm-typinggame`, `rm-timedlockpick`, `rm-timedaction`, `rm-quicktimeevent`, `rm-combinationlock`, `rm-buttonmashing`, `rm-angledlockpick`, `rm-fingerprint`, `rm-hotwirehack`, `rm-hackerminigame`, `rm-safecrack` |
| **bl_ui** | `bl-circlesum`, `bl-digitdazzle`, `bl-lightsout`, `bl-minesweeper`, `bl-pathfind`, `bl-printlock`, `bl-untangle`, `bl-wavematch`, `bl-wordwiz` |
| **glitch-minigames** | `gl-firewall-pulse`, `gl-backdoor-sequence`, `gl-circuit-rhythm`, `gl-surge-override`, `gl-circuit-breaker`, `gl-data-crack`, `gl-brute-force`, `gl-var-hack` |

Set `Config.Minigame.Dumpsters.Minigame` (or `.Camps.Minigame`) to the key of your chosen minigame, and ensure the corresponding arguments are configured in the `Args` table.

## Statistics and Leaderboard

```lua
Config.Stats = {
    Enable = true, -- Track player statistics (dumpsters searched, items collected, etc.)
}

Config.Leaderboard = {
    Enable = true,
    ShowNames = true,  -- Show player names; false = "Anonymous"
    Amount = 5,        -- Number of top players to display
    LevelMultipliers = {
        [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5
    }
}
```

The leaderboard score is calculated as: **total stats x level multiplier**.

## Daily Objectives and Challenges

```lua
Config.Daily = {
    EnableObjectives = true,   -- Personal daily objectives
    EnableChallenges = true,   -- Server-wide daily challenges
    ObjectiveCount = 5,        -- Objectives per player per cycle
    ChallengeCount = 3,        -- Challenges per server cycle

    Objectives = {
        {
            id = "dumpstersSearched", -- Hardcoded action identifier
            name = "Dumpster Diver",
            target = 20,
            reward = { type = "xp", amount = 150 }
        },
        {
            id = "plastic",           -- Item name as identifier
            name = "Plastic Picker",
            target = 100,
            reward = { type = "item", name = "plastic", amount = 15 }
        },
        -- ... more objectives
    },
    Challenges = {
        {
            id = "dumpstersSearched",
            name = "First Dumpster Dive",
            target = 1,
            reward = { type = "money", amount = 500 }
        },
        -- ... more challenges
    }
}
```

### Available Objective/Challenge IDs

| ID | Tracks |
|---|---|
| `dumpstersSearched` | Total dumpsters and bins searched |
| `campSearched` | Total hobo camps searched |
| `hoboLooted` | Total hobos looted |
| `bagsLooted` | Total trash bags searched |
| Any item name (e.g. `plastic`, `metalscrap`, `bottle_cap`) | Total of that item collected |

### Reward Types

| Type | Required Fields |
|---|---|
| `"item"` | `name`, `amount` (and optionally `label`) |
| `"xp"` | `amount` |
| `"money"` | `amount` |

## Milestones

```lua
Config.Milestones = {
    Enable = true,

    ["dumpstersSearched"] = {
        Name = "Dumpster Diver",
        [1] = {
            RequiredAmount = 5,
            Reward = { Type = "item", Name = "bottle_cap", Amount = 250, Label = "Bottle Caps" }
        },
        [2] = {
            RequiredAmount = 10,
            Reward = { Type = "xp", Amount = 200 }
        },
        [3] = {
            RequiredAmount = 20,
            Reward = { Type = "money", Amount = 500 }
        }
    },
    -- Also: "campSearched", "hoboLooted", "bagsLooted", and item-specific milestones
}
```

Milestones use the same ID system as daily objectives. Each milestone category can have multiple stages with increasing `RequiredAmount` and escalating rewards. Players redeem completed milestones through the Hobo King menu.
