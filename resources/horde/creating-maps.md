# Creating Maps

This guide covers how to create custom maps for Horde Mission. Each map is a standalone Lua file in `configs/maps/` that returns a table defining the playable zone, spawn points, enemy configuration, difficulty tiers, shop items, and rewards.

## File Structure

Each map is a separate file in `configs/maps/`. The file name (without `.lua`) must match an entry in `Config.Maps` in `configs/config.lua`:

```lua
-- configs/config.lua
Maps = {
    'server_farm',
    'cayo_estate',
    'your_custom_map',  -- Add your map here
},
```

The map file returns a Lua table:

```lua
-- configs/maps/your_custom_map.lua
return {
    id = "your_custom_map",
    label = "Your Custom Map",
    description = "A description of your map.",
    icon = "fa-map",
    -- ... rest of configuration
}
```

## Map Identification

```lua
return {
    id = "your_custom_map",    -- Unique map identifier (used internally)
    label = "Your Custom Map", -- Display name in the UI
    description = "Description shown in map selection.",
    icon = "fa-map",           -- Font Awesome icon for the map
}
```

## Map Intro

Configure the intro screen shown when a game starts on this map:

```lua
intro = {
    enabled = true,
    title = "RAID THE\nCUSTOM MAP",     -- Supports \n for line breaks
    subtitle = nil,                       -- Optional subtitle (nil to hide)
    description = "YOUR MAP DESCRIPTION HERE.",
    tagline = "A CATCHY TAGLINE.",
    duration = 15000,                     -- Duration in milliseconds
},
```

## Requirements

Map-level requirements control who can access the map. If a difficulty defines its own `requirements`, those override the map-level ones.

```lua
requirements = {
    level = 5,                              -- Minimum horde level

    -- completedMaps (optional) - require completion of other maps
    -- completedMaps = {
    --     { map = "server_farm", difficulty = "normal" },
    --     { map = "another_map", difficulty = "easy" },
    -- },

    -- item (optional) - require a single item in inventory
    -- item = "access_key",                           -- Check only (not consumed)
    -- item = { name = "access_key", consume = true }, -- Consumed on start
    -- item = { name = "access_key", count = 3 },      -- Require multiple

    -- items (optional) - require MULTIPLE DIFFERENT items
    -- items = {
    --     { name = "key", consume = true },           -- This is consumed
    --     { name = "lockpick", count = 2 },           -- These are NOT consumed
    -- },
},
```

| Requirement | Type | Description |
|---|---|---|
| `level` | `number` | Minimum horde level required |
| `completedMaps` | `table` | Array of `{ map, difficulty }` that must be completed |
| `item` | `string` or `table` | Single item requirement |
| `items` | `table` | Multiple item requirements |

::: tip
Use `consume = true` on items to create ticket/key systems where the access item is removed when the horde starts. By default, items are checked but not consumed.
:::

## Locations

### Entry Location

Where players go to enter the horde (in the normal game world):

```lua
entryLocation = {
    coords = vector4(x, y, z, heading),
    blip = {
        sprite = 310,
        color = 1,
        scale = 0.8,
        label = "Horde Entry",
    },
    radius = 2.0,   -- Interaction radius
},
```

### Leave Location

Where players are teleported when the game ends:

```lua
leaveLocation = vec4(x, y, z, heading),
```

### End Loot Crate

Where the reward crate appears after the game:

```lua
endLootLocation = {
    coords = vector4(x, y, z, heading),
    model = 'v_ind_cfcrate3',
},
```

### Spawn Point

Where players spawn inside the map when the game begins:

```lua
spawnPoint = vector4(x, y, z, heading),
```

## Play Zone

The zone defines the playable area using polygon points. Players who leave receive a warning and are removed after `Config.ZoneExitTimeout` seconds.

```lua
zonePoints = {
    vec3(x1, y1, z1),
    vec3(x2, y2, z2),
    vec3(x3, y3, z3),
    -- ... more points defining the polygon
},
zoneThickness = 20.0,  -- Height of the zone above/below
```

::: warning
Use enough polygon points to accurately trace the playable area. For indoor maps, include all accessible rooms and corridors. Test zone boundaries in-game to ensure players cannot escape without triggering the zone exit warning.
:::

## Terminal (Shop)

The terminal is the shop access point inside the map:

```lua
terminal = {
    coords = vector3(x, y, z),
    object = {                        -- Optional: spawn a prop
        model = 'prop_laptop_01a',
        heading = 0.0,
    },
},
```

If `object` is omitted, no prop is spawned (useful when the map already has suitable objects at that position).

## Deposit Crate

Where players deposit loot objects to earn currency:

```lua
depositCrate = {
    model = 'tr_prop_tr_mil_crate_02',
    coords = vector3(x, y, z),
    heading = 0.0,
},
```

## Mystery Box

A COD-style random weapon box. Each map defines its own mystery box configuration and weapon pool:

```lua
mysteryBox = {
    enabled = true,
    coords = vector3(x, y, z),
    heading = 0.0,
    cost = 950,
    boxModelClosed = 'xm3_prop_xm3_crate_01a',
    boxModelOpen = 'xm3_prop_xm3_crate_01b',
    useCamera = false,
    enableParticles = true,
    lights = {
        enabled = true,
        pulsating = false,
    },
    cycleDuration = 8000,       -- Total cycling animation time (ms)
    cycleSpeedStart = 50,       -- Starting cycle speed (ms between swaps)
    cycleSpeedEnd = 1500,       -- Ending cycle speed (slows down)
    sounds = {
        open = { name = "PICK_UP", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
        cycle = { name = "NAV_UP_DOWN", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
        finish = { name = "WEAPON_PURCHASE", set = "HUD_AMMO_SHOP_SOUNDSET" },
    },
    weaponPool = {
        { name = "weapon_pistol", label = "PISTOL", rarity = "common", chance = 100, ammo = 60 },
        { name = "weapon_carbinerifle", label = "CARBINE RIFLE", rarity = "rare", chance = 20, ammo = 120 },
        { name = "weapon_rpg", label = "RPG", rarity = "epic", chance = 2, ammo = 5 },
        -- ... more weapons
    },
},
```

**Weapon pool entry fields:**

| Field | Type | Description |
|---|---|---|
| `name` | `string` | Weapon spawn name |
| `label` | `string` | Display name |
| `rarity` | `string` | `"common"`, `"uncommon"`, `"rare"`, or `"epic"` |
| `chance` | `number` | Weighted chance (higher = more likely) |
| `ammo` | `number` | Amount of ammo given with the weapon |

::: info
Weapon display models for the cycling animation are configured in `WeaponDisplayModels` in `configs/config.lua`, not in the map file. Add new weapon-to-prop mappings there.
:::

## Loot Objects

Define which loot crate models can spawn and their point values:

```lua
lootObjects = {
    { model = 'prop_box_ammo02a', value = 100 },
    { model = 'prop_box_ammo01a', value = 125 },
    { model = 'hei_prop_heist_box', value = 350 },
    { model = 'prop_mb_crate_01a', value = 950 },
    { model = 'm23_2_prop_m32_prof_crate_01a', value = 1000 },
},
```

### Loot Spawn Locations

Where loot objects can appear during the looting phase:

```lua
lootSpawns = {
    vec4(x, y, z, heading),
    vec4(x, y, z, heading),
    -- ... more locations
},
```

::: tip
Add more spawn locations than the maximum loot per round to create variety. The system randomly selects locations from this list each round.
:::

## Enemy Configuration

### Spawn Settings

```lua
enemySpawnSettings = {
    spawnMode = "furthest",    -- "furthest", "minDistance", or "random"
    minSpawnDistance = 15.0,    -- Minimum distance from players
},
```

| Mode | Description |
|---|---|
| `"furthest"` | Spawn at the locations furthest from all players (default) |
| `"minDistance"` | Random spawns filtered by minimum distance from players |
| `"random"` | Completely random, ignores player positions |

### Enemy Spawn Locations

```lua
enemySpawns = {
    vector4(x, y, z, heading),
    vector4(x, y, z, heading),
    -- ... more locations
},
```

### Spawn Point Guidelines

- Use at least **15-20 spawn points** spread across the map
- Place spawns behind cover, around corners, or at map edges
- Avoid clustering spawns -- spread them at least 10-15 units apart
- Test that no spawn points place enemies inside walls or underground

## Early Exit Rounds

Define which rounds allow players to vote to end the game early:

```lua
canEndGameOnRounds = {3, 5, 7, 10},
```

## End Game Loot

Map-level loot pool for end game rewards. Each difficulty can also define its own `endGameLoot` which takes priority.

```lua
endGameLoot = {
    rerollCost = 200,
    itemCount = 6,
    duration = 60,
    lootTable = {
        { name = "bands", label = "Band of Notes", rarity = "common", price = 800, chance = 100, quantity = 3 },
        { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 6000, chance = 18 },
        { name = "casino_case", label = "Casino Heist Case", rarity = "epic", price = 25000, chance = 2 },
        -- ... more items
    },
},
```

## Map-Specific Shop Items

Optionally override the global `ShopItems` from `configs/config.lua`:

```lua
shopItems = {
    guaranteeAmmoForWeapons = true,
    ammoBoostMultiplier = 3,
    items = {
        itemCount = 6,
        list = { ... },
    },
    weapons = {
        itemCount = 3,
        list = { ... },
    },
    perks = {
        itemCount = 2,
        list = { ... },
    },
},
```

If `shopItems` is not defined in the map config, the global `ShopItems` from `configs/config.lua` is used.

## IPLs and Interiors

For maps using custom interiors, you can specify IPLs to load and interior props to enable:

```lua
-- IPLs to load for this map
ipls = {
    "xm_x17dlc_int_placement_interior_33_x17dlc_int_02_milo_",
},

-- Interior prop configuration
interior = {
    coords = vector3(345.0, 4842.0, -60.0),   -- Coords to find interior ID
    propSets = {
        "set_int_02_decal_01",
        "set_int_02_lounge1",
        "set_int_02_security",
    },
    propColor = 2,   -- Color scheme (0 = default)
},

-- Doors to freeze (prevent opening)
doors = {
    { coords = vector4(x, y, z, heading), model = 1877137660, radius = 1.0 },
},
```

## Difficulty Tiers

Each map defines multiple difficulty tiers. This is the core of the gameplay configuration:

```lua
difficulties = {
    easy = {
        label = "Easy",
        description = "Light security detail.",
        icon = "fa-face-smile",

        -- Optional per-difficulty requirements (override map-level)
        requirements = {
            level = 1,
        },

        maxRounds = 5,
        killPoints = { min = 25, max = 75 },

        -- Optional: override global MaxAliveEnemies for this difficulty
        -- maxAliveEnemies = 10,

        enemiesPerRound = {
            [1] = 6,
            [2] = 10,
            [3] = 14,
            [4] = 18,
            [5] = 22,
        },

        lootPerRound = {
            [1] = 3,
            [2] = 4,
            [3] = 5,
            [4] = 6,
            [5] = 7,
        },

        enemies = {
            models = {
                "s_m_m_security_01",
                "s_m_y_doorman_01",
            },
            weapons = {
                `WEAPON_PISTOL`,
                `WEAPON_COMBATPISTOL`,
            },
            health = { min = 120, max = 180 },
            armor = { min = 0, max = 25 },
            accuracy = 25,
            combatAbility = 0,   -- 0=Poor, 1=Average, 2=Professional
            combatRange = 1,     -- 0=Near, 1=Medium, 2=Far
            canRagdoll = true,
        },

        bossFights = {
            {
                round = 3,                     -- Round when boss spawns
                name = "BOSS NAME",            -- Display name on health bar
                subtitle = "Boss Title",       -- Optional subtitle
                model = "s_m_m_highsec_01",    -- Ped model
                health = 1500,
                armor = 100,
                weapon = `WEAPON_SMG`,
                accuracy = 45,
                combatAbility = 2,
                combatRange = 2,
                canRagdoll = false,
                canHeadshot = false,            -- Headshots don't insta-kill
                killReward = 500,              -- Currency reward
            },
        },

        -- Optional: per-difficulty end game loot (overrides map-level)
        endGameLoot = {
            rerollCost = 200,
            itemCount = 6,
            duration = 60,
            lootTable = { ... },
        },
    },

    normal = { ... },
    hard = { ... },
    nightmare = { ... },
},
```

### Enemy Configuration Fields

| Field | Type | Description |
|---|---|---|
| `models` | `table` | Array of ped model names (randomly selected per spawn) |
| `weapons` | `table` | Array of weapon hashes (use backtick syntax: `` `WEAPON_PISTOL` ``) |
| `health` | `table` | `{ min, max }` -- random health in range |
| `armor` | `table` | `{ min, max }` -- random armor in range |
| `accuracy` | `number` | Shooting accuracy (0-100) |
| `combatAbility` | `number` | 0 = Poor, 1 = Average, 2 = Professional |
| `combatRange` | `number` | 0 = Near, 1 = Medium, 2 = Far |
| `canRagdoll` | `boolean` | Whether enemies can be knocked down by impacts |

### Boss Fight Fields

| Field | Type | Description |
|---|---|---|
| `round` | `number` | Round number when the boss spawns |
| `name` | `string` | Boss name shown on the health bar |
| `subtitle` | `string?` | Optional subtitle below the name |
| `model` | `string` | Ped model name |
| `health` | `number` | Total health |
| `armor` | `number` | Armor value |
| `weapon` | `hash` | Weapon hash |
| `accuracy` | `number` | Shooting accuracy |
| `combatAbility` | `number` | Combat ability level |
| `combatRange` | `number` | Combat range level |
| `canRagdoll` | `boolean` | Whether the boss can be ragdolled |
| `canHeadshot` | `boolean` | Whether headshots are instant kills |
| `killReward` | `number` | Currency reward for killing the boss |

::: warning
Boss fights with `canHeadshot = false` require sustained damage to defeat. This is important for balancing -- without it, a single sniper headshot could trivialize a boss encounter.
:::

## Complete Minimal Example

```lua
-- configs/maps/warehouse.lua
return {
    id = "warehouse",
    label = "Abandoned Warehouse",
    description = "A derelict warehouse on the outskirts of the city.",
    icon = "fa-warehouse",

    intro = {
        enabled = true,
        title = "CLEAR THE\nWAREHOUSE",
        subtitle = nil,
        description = "AN ABANDONED WAREHOUSE OVERRUN BY HOSTILES.",
        tagline = "NO ONE LEAVES ALIVE.",
        duration = 15000,
    },

    requirements = {
        level = 1,
    },

    entryLocation = {
        coords = vector4(1000.0, -2000.0, 30.0, 180.0),
        blip = { sprite = 310, color = 1, scale = 0.8, label = "Horde Entry" },
        radius = 2.0,
    },

    leaveLocation = vec4(1005.0, -2005.0, 30.0, 0.0),

    endLootLocation = {
        coords = vector4(1002.0, -2003.0, 30.0, 90.0),
        model = 'v_ind_cfcrate3',
    },

    spawnPoint = vector4(1000.0, -2000.0, 30.0, 180.0),

    zonePoints = {
        vec3(980.0, -2020.0, 28.0),
        vec3(1020.0, -2020.0, 28.0),
        vec3(1020.0, -1980.0, 28.0),
        vec3(980.0, -1980.0, 28.0),
    },
    zoneThickness = 20.0,

    terminal = {
        coords = vector3(998.0, -1998.0, 30.0),
        object = { model = 'prop_laptop_01a', heading = 180.0 },
    },

    depositCrate = {
        model = 'tr_prop_tr_mil_crate_02',
        coords = vector3(996.0, -1998.0, 30.0),
        heading = 0.0,
    },

    mysteryBox = {
        enabled = true,
        coords = vector3(1002.0, -1995.0, 30.0),
        heading = 0.0,
        cost = 950,
        boxModelClosed = 'xm3_prop_xm3_crate_01a',
        boxModelOpen = 'xm3_prop_xm3_crate_01b',
        useCamera = false,
        enableParticles = true,
        lights = { enabled = true, pulsating = false },
        cycleDuration = 8000,
        cycleSpeedStart = 50,
        cycleSpeedEnd = 1500,
        sounds = {
            open = { name = "PICK_UP", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
            cycle = { name = "NAV_UP_DOWN", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
            finish = { name = "WEAPON_PURCHASE", set = "HUD_AMMO_SHOP_SOUNDSET" },
        },
        weaponPool = {
            { name = "weapon_pistol", label = "PISTOL", rarity = "common", chance = 100, ammo = 60 },
            { name = "weapon_smg", label = "SMG", rarity = "uncommon", chance = 45, ammo = 100 },
            { name = "weapon_carbinerifle", label = "CARBINE RIFLE", rarity = "rare", chance = 20, ammo = 120 },
        },
    },

    lootObjects = {
        { model = 'prop_box_ammo02a', value = 100 },
        { model = 'hei_prop_heist_box', value = 350 },
        { model = 'prop_mb_crate_01a', value = 950 },
    },

    lootSpawns = {
        vec4(990.0, -2010.0, 30.0, 0.0),
        vec4(1010.0, -2010.0, 30.0, 90.0),
        vec4(1010.0, -1990.0, 30.0, 180.0),
        vec4(990.0, -1990.0, 30.0, 270.0),
    },

    enemySpawnSettings = {
        spawnMode = "furthest",
        minSpawnDistance = 15.0,
    },

    enemySpawns = {
        vector4(1015.0, -2015.0, 30.0, 225.0),
        vector4(985.0, -2015.0, 30.0, 315.0),
        vector4(1015.0, -1985.0, 30.0, 135.0),
        vector4(985.0, -1985.0, 30.0, 45.0),
    },

    canEndGameOnRounds = {3, 5},

    endGameLoot = {
        rerollCost = 200,
        itemCount = 6,
        duration = 60,
        lootTable = {
            { name = "bands", label = "Band of Notes", rarity = "common", price = 800, chance = 100, quantity = 3 },
            { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 6000, chance = 18 },
        },
    },

    difficulties = {
        easy = {
            label = "Easy",
            description = "A few thugs guarding the stash.",
            icon = "fa-face-smile",
            requirements = { level = 1 },
            maxRounds = 5,
            killPoints = { min = 25, max = 75 },
            enemiesPerRound = {
                [1] = 5, [2] = 8, [3] = 12, [4] = 16, [5] = 20,
            },
            lootPerRound = {
                [1] = 2, [2] = 3, [3] = 4, [4] = 5, [5] = 6,
            },
            enemies = {
                models = { "g_m_y_lost_01", "g_m_y_lost_02" },
                weapons = { `WEAPON_PISTOL`, `WEAPON_SAWNOFFSHOTGUN` },
                health = { min = 100, max = 150 },
                armor = { min = 0, max = 0 },
                accuracy = 20,
                combatAbility = 0,
                combatRange = 1,
                canRagdoll = true,
            },
            bossFights = {
                {
                    round = 5,
                    name = "WAREHOUSE BOSS",
                    subtitle = "Gang Leader",
                    model = "g_m_y_lost_03",
                    health = 2000,
                    armor = 100,
                    weapon = `WEAPON_ASSAULTRIFLE`,
                    accuracy = 40,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 750,
                },
            },
        },
    },
}
```

## Testing Your Map

1. Add the map file to `configs/maps/`
2. Add the file name (without `.lua`) to `Config.Maps` in `configs/config.lua`
3. Restart the resource: `ensure sd-horde`
4. Check server console for `[sd-horde] Loaded map: your_map_id`
5. Verify the map appears in the map selection menu

::: tip
Enable `DebugPrints = true` and `DebugZones = true` in the main config during development. This shows zone boundaries visually and prints detailed state information to the console.
:::

::: warning
Always test enemy spawn points and loot spawn locations in-game. Coordinates that look correct on paper can result in objects spawning inside walls, underground, or in unreachable locations. Walk through each point manually before finalizing.
:::
