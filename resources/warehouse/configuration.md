# Configuration

All configuration is done in `config.lua` located in the root of the `sd-warehouse` resource folder.

## Locale

```lua
SD.Locale.LoadLocale('en')
```

Sets the language for all translations. Change `'en'` to any other available language file found in the `locales/` folder.

## General Settings

```lua
Config.WareHouseDebug = false
Config.MinimumPolice = 0
Config.PoliceJobs = { 'police', --[['sheriff']] }
Config.Cooldown = 60
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.WareHouseDebug` | `boolean` | `false` | Enable green debug zone visualization for testing |
| `Config.MinimumPolice` | `number` | `0` | Minimum police officers online to start the heist |
| `Config.PoliceJobs` | `table` | `{'police'}` | Array of job names counted toward the police check. Uncomment `'sheriff'` or add others as needed |
| `Config.Cooldown` | `number` | `60` | Global cooldown between heists in minutes |

## Items

```lua
Config.Items = {
    Thermite = 'thermite_h'
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Items.Thermite` | `string` | `'thermite_h'` | Item name for the thermite used to breach the junction box |

::: tip
Change this to match whatever thermite item exists in your server's inventory system.
:::

## Explosion Settings

```lua
Config.Explosion = {
    Enable = true,
    Location = vector3(-1075.54, -2008.53, 13.62),
    Type = 9
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Explosion.Enable` | `boolean` | `true` | Enable an explosion effect after thermiting the junction box |
| `Config.Explosion.Location` | `vector3` | `(-1075.54, -2008.53, 13.62)` | World coordinates where the explosion occurs |
| `Config.Explosion.Type` | `number` | `9` | GTA explosion type ID |

## Interaction Type

```lua
Config.Interaction = 'target'
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Interaction` | `string` | `'target'` | Interaction mode: `'target'` for qb-target/qtarget/ox_target, or `'textui'` for cd_drawtextui/qb-core/ox_lib textui |

## Blip

```lua
Config.Blip = {
    Enable = true,
    Location = vector3(-1056.95, -2004.16, 13.16),
    Sprite = 473,
    Display = 4,
    Scale = 0.6,
    Colour = 18,
    Name = "Secured Warehouse",
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Blip.Enable` | `boolean` | `true` | Show the warehouse blip on the map |
| `Config.Blip.Location` | `vector3` | `(-1056.95, -2004.16, 13.16)` | World coordinates for the blip |
| `Config.Blip.Sprite` | `number` | `473` | Blip icon sprite ID |
| `Config.Blip.Display` | `number` | `4` | Blip display mode |
| `Config.Blip.Scale` | `number` | `0.6` | Blip size on the map |
| `Config.Blip.Colour` | `number` | `18` | Blip color ID |
| `Config.Blip.Name` | `string` | `"Secured Warehouse"` | Label shown on the map |

## Police Alert

The `policeAlert` function is called when police should be notified of the heist. It uses `SD.PoliceDispatch` and supports multiple dispatch systems.

```lua
policeAlert = function()
    SD.PoliceDispatch({
        displayCode = "10-31W",
        title = 'Warehouse Heist',
        description = "Warehouse heist in progress",
        message = "Suspects reported at the warehouse",
        sprite = 303,
        scale = 1.0,
        colour = 3,
        blipText = "Warehouse Heist",
        dispatchcodename = "warehouse_heist"
    })
end
```

| Key | Type | Default | Description |
|---|---|---|---|
| `displayCode` | `string` | `"10-31W"` | Dispatch code displayed in the alert |
| `title` | `string` | `'Warehouse Heist'` | Title used in cd_dispatch/ps-dispatch |
| `description` | `string` | `"Warehouse heist in progress"` | Description of the heist event |
| `message` | `string` | `"Suspects reported at the warehouse"` | Additional alert message |
| `sprite` | `number` | `303` | Blip sprite for the dispatch alert |
| `scale` | `number` | `1.0` | Blip scale for the dispatch alert |
| `colour` | `number` | `3` | Blip color for the dispatch alert |
| `blipText` | `string` | `"Warehouse Heist"` | Text that appears on the dispatch blip |
| `dispatchcodename` | `string` | `"warehouse_heist"` | Code name used by ps-dispatch in `sv_dispatchcodes.lua` or `config.lua` under `Config.Blips` |

::: info
The blip-related fields (`sprite`, `scale`, `colour`, `blipText`) are used by all dispatch systems **except** ps-dispatch, which relies on `dispatchcodename` instead.
:::

## Location Coordinates

All key interaction points for the heist are defined in `Config.Locations`.

```lua
Config.Locations = {
    FirstHack = { location = vector3(-1067.46, -2006.27, 14.91), busy = false, hacked = false },
    SecondHack = { location = vector3(-985.17, -2042.49, -19.65), busy = false, hacked = false },
    Enter = { location = vector3(-1057.23, -2003.95, 13.16) },
    Leave = { location = vector3(-952.58, -2044.05, -19.72) },
    Leave2 = { location = vector3(-988.01, -2040.27, -19.72) },
    SecureWarehouse = { location = vector3(-952.5, -2040.99, -19.56) },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `FirstHack.location` | `vector3` | `(-1067.46, -2006.27, 14.91)` | Junction box / first hack location (outside) |
| `SecondHack.location` | `vector3` | `(-985.17, -2042.49, -19.65)` | Laptop / second hack location (inside warehouse) |
| `Enter.location` | `vector3` | `(-1057.23, -2003.95, 13.16)` | Warehouse entrance point |
| `Leave.location` | `vector3` | `(-952.58, -2044.05, -19.72)` | Primary exit point inside the warehouse |
| `Leave2.location` | `vector3` | `(-988.01, -2040.27, -19.72)` | Alternative exit point inside the warehouse |
| `SecureWarehouse.location` | `vector3` | `(-952.5, -2040.99, -19.56)` | Secure warehouse interaction point |

::: tip
`FirstHack` and `SecondHack` also carry `busy` and `hacked` state flags. These are managed at runtime and should be left as `false` in the config.
:::

## Hacking Minigames

Two separate minigame stages are configured: **Main** (the initial hack to enter the warehouse) and **Laptop** (the hack to disable locks from within the warehouse). Each stage selects one minigame from the `Minigame` key and passes the matching `Args` entry.

### Main Hack

```lua
Config.Hacking = {
    Main = {
        Minigame = 'hacking-opengame',
        Args = {
            ['ps-circle'] = {2, 20},
            ['ps-maze'] = {20},
            ['ps-varhack'] = {2, 3},
            ['ps-thermite'] = {2, 5, 3},
            ['ps-scrambler'] = {'numeric', 30, 0},
            ['memorygame-thermite'] = {10, 3, 3, 10},
            ['ran-memorycard'] = {360},
            ['ran-openterminal'] = {},
            ['hacking-opengame'] = {15, 4, 1},
            ['howdy-begin'] = {3, 5000},
            ['sn-memorygame'] = {3, 2, 10000},
            ['sn-skillcheck'] = {50, 5000, {'w','a','s','w'}, 2, 20, 3},
            ['sn-thermite'] = {7, 5, 10000, 2, 2, 3000},
            ['sn-keypad'] = {999, 3000},
            ['sn-colorpicker'] = {3, 7000, 3000},
            ['rm-typinggame'] = {'easy', 20},
            ['rm-timedlockpick'] = {200},
            ['rm-timedaction'] = {3},
            ['rm-quicktimeevent'] = {'easy'},
            ['rm-combinationlock'] = {'easy'},
            ['rm-buttonmashing'] = {5, 10},
            ['rm-angledlockpick'] = {'easy'},
            ['rm-fingerprint'] = {200, 5},
            ['rm-hotwirehack'] = {10},
            ['rm-hackerminigame'] = {5, 3},
            ['rm-safecrack'] = {'easy'}
        }
    },
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Main.Minigame` | `string` | `'hacking-opengame'` | Active minigame for the first hack stage |
| `Main.Args` | `table` | See above | Arguments table keyed by minigame name |

### Laptop Hack

```lua
    Laptop = {
        Enable = true,
        Minigame = 'hacking-opengame',
        Args = { ... } -- same structure as Main.Args
    }
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Laptop.Enable` | `boolean` | `true` | Enable or disable the laptop hack requirement inside the warehouse |
| `Laptop.Minigame` | `string` | `'hacking-opengame'` | Active minigame for the laptop hack stage |
| `Laptop.Args` | `table` | See Main | Arguments table keyed by minigame name (same structure and defaults as Main) |

::: info
The `Laptop.Args` defaults are identical to `Main.Args` with one exception: `ps-thermite` uses `{10, 5, 3}` for the Laptop (10 second timer) versus `{2, 5, 3}` for Main (2 second timer).
:::

### Supported Minigames

Set `Minigame` to any of the following values and provide matching `Args`:

| Minigame | Args | Description |
|---|---|---|
| `ps-circle` | `{circles, time_ms}` | Number of circles, time in milliseconds |
| `ps-maze` | `{time_s}` | Time in seconds |
| `ps-varhack` | `{blocks, time_s}` | Number of blocks, time in seconds |
| `ps-thermite` | `{time_s, grid_size, incorrect}` | Time in seconds, grid size, incorrect blocks |
| `ps-scrambler` | `{type, time_s, mirrored}` | Type (e.g. `'numeric'`), time in seconds, mirrored option |
| `memorygame-thermite` | `{correct, incorrect, show_s, lose_s}` | Correct blocks, incorrect blocks, show time, lose time (seconds) |
| `ran-memorycard` | `{time_s}` | Time in seconds |
| `ran-openterminal` | `{}` | No additional arguments |
| `hacking-opengame` | `{time_s, blocks, repeats}` | Time in seconds, number of blocks, number of repeats |
| `howdy-begin` | `{icons, time_ms}` | Number of icons, time in milliseconds |
| `sn-memorygame` | `{keys, rounds, time_ms}` | Keys needed, number of rounds, time in milliseconds |
| `sn-skillcheck` | `{speed_ms, time_ms, keys, rounds, bars, safe_bars}` | Speed, time (ms), key array, rounds, bars, safe bars |
| `sn-thermite` | `{boxes, correct, time_ms, lives, rounds, show_ms}` | Boxes, correct boxes, time (ms), lives, rounds, show time (ms) |
| `sn-keypad` | `{code, time_ms}` | Code number, time in milliseconds |
| `sn-colorpicker` | `{icons, type_ms, view_ms}` | Number of icons, type time (ms), view time (ms) |
| `rm-typinggame` | `{difficulty, duration_s}` | Difficulty, duration in seconds |
| `rm-timedlockpick` | `{speed}` | Speed value |
| `rm-timedaction` | `{locks}` | Number of locks |
| `rm-quicktimeevent` | `{difficulty}` | Difficulty |
| `rm-combinationlock` | `{difficulty}` | Difficulty |
| `rm-buttonmashing` | `{decay, increment}` | Decay rate, increment rate |
| `rm-angledlockpick` | `{difficulty}` | Difficulty |
| `rm-fingerprint` | `{time_s, lives}` | Time in seconds, number of lives |
| `rm-hotwirehack` | `{time_s}` | Time in seconds |
| `rm-hackerminigame` | `{length, lives}` | Length, number of lives |
| `rm-safecrack` | `{difficulty}` | Difficulty |

## Loot Crate Configuration

Six loot crates spawn inside the warehouse. Each crate awards a random selection of items from its own loot table. All crates use the prop model `ex_prop_crate_closed_bc`.

```lua
Config.Rewards = {
    [1] = {
        MinAmount = 4,
        MaxAmount = 6,
        Items = { "goldbar", "10kgoldchain", "rolex", "trojan_usb" }
    },
    -- ... crates 2-6
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `MinAmount` | `number` | `4` | Minimum number of items given per crate (all crates) |
| `MaxAmount` | `number` | `6` | Maximum number of items given per crate (all crates) |

### Crate 1 -- Valuables

| Item | Description |
|---|---|
| `goldbar` | Gold bar |
| `10kgoldchain` | 10k gold chain |
| `rolex` | Rolex watch |
| `trojan_usb` | Trojan USB drive |

### Crate 2 -- Weapons & Armor

| Item | Description |
|---|---|
| `weapon_smg` | SMG |
| `weapon_microsmg` | Micro SMG |
| `weapon_pistol50` | Pistol .50 |
| `heavyarmor` | Heavy armor |
| `weapon_smokegrenade` | Smoke grenade |

### Crate 3 -- Valuables & Nitrous

| Item | Description |
|---|---|
| `goldbar` | Gold bar |
| `10kgoldchain` | 10k gold chain |
| `rolex` | Rolex watch |
| `nitrous` | Nitrous |

### Crate 4 -- Electronics

| Item | Description |
|---|---|
| `laptop` | Laptop |
| `tablet` | Tablet |
| `samsungphone` | Samsung phone |
| `cryptostick` | Crypto stick |

### Crate 5 -- Weapons & Armor

| Item | Description |
|---|---|
| `weapon_smg` | SMG |
| `weapon_microsmg` | Micro SMG |
| `weapon_pistol50` | Pistol .50 |
| `heavyarmor` | Heavy armor |

### Crate 6 -- Contraband

| Item | Description |
|---|---|
| `coke_brick` | Cocaine brick |
| `xtcbaggy` | XTC baggy |
| `weed_brick` | Weed brick |

::: warning
Item names must match your inventory system. Update these values if your server uses different item names.
:::

## Filler Objects

Random prop objects are spawned throughout the warehouse interior to fill the space. The loot crate model and filler object models are defined in `Config.Props`.

```lua
Config.Props = {
    WarehouseLoot = {
        [1] = "ex_prop_crate_closed_bc",
    },
    WarehouseObjects = {
        [1] = "prop_boxpile_05a",
        [2] = "prop_boxpile_04a",
        [3] = "prop_boxpile_06b",
        [4] = "prop_boxpile_02c",
        [5] = "prop_boxpile_02b",
        [6] = "prop_boxpile_01a",
        [7] = "prop_boxpile_08a",
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `WarehouseLoot` | `table` | `{"ex_prop_crate_closed_bc"}` | Prop model(s) used for lootable crates |
| `WarehouseObjects` | `table` | 7 box pile models | Prop models randomly placed in the warehouse as filler decoration |

The config also includes 6 `LootLocations` (vector4 coordinates where crates spawn) and 24 `RandomLocations` (vector4 coordinates where filler objects spawn). These can be adjusted if you are using a different warehouse interior.

## Guards

NPC guards can optionally spawn inside the warehouse during the heist. Guards are **disabled by default**.

```lua
Config.EnableGuards = false
Config.EnableLooting = true
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.EnableGuards` | `boolean` | `false` | Enable NPC guard spawning inside the warehouse |
| `Config.EnableLooting` | `boolean` | `true` | Allow players to loot dead guards |

### Guard Spawn Locations

```lua
Config.Guards = {
    coords = {
        vector4(-980.88, -2044.84, -20.72, 297.41),
        vector4(-983.58, -2052.64, -20.72, 269.18),
        vector4(-986.65, -2039.13, -20.72, 255.34),
    }
}
```

Three guard positions are defined by default. Add or remove `vector4` entries to change the number and placement of guards.

### Guard Parameters

```lua
Config.PedParameters = {
    Ped = {"s_m_y_marine_01"},
    Health = 200,
    Weapon = {"WEAPON_PISTOL", "WEAPON_SMG", "WEAPON_ASSAULTRIFLE"},
    MinArmor = 50,
    MaxArmor = 100,
    Headshots = true,
    CombatAbility = 100,
    Accuracy = 60,
    CombatRange = 2,
    CombatMovement = 2,
    CanRagdoll = true,
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Ped` | `table` | `{"s_m_y_marine_01"}` | List of possible ped models (one is randomly selected per guard) |
| `Health` | `number` | `200` | Maximum and initial health of each guard |
| `Weapon` | `table` | `{"WEAPON_PISTOL", "WEAPON_SMG", "WEAPON_ASSAULTRIFLE"}` | Possible weapons (randomly assigned per guard) |
| `MinArmor` | `number` | `50` | Minimum armor value a guard can have |
| `MaxArmor` | `number` | `100` | Maximum armor value a guard can have |
| `Headshots` | `boolean` | `true` | Whether guards can suffer critical hits (headshots) |
| `CombatAbility` | `number` | `100` | Combat ability from 0 to 100 (100 = highest) |
| `Accuracy` | `number` | `60` | Shot accuracy from 0 to 100 (100 = highest) |
| `CombatRange` | `number` | `2` | Combat range: `0` = short, `1` = medium, `2` = long |
| `CombatMovement` | `number` | `2` | Combat movement style: `0` = calm, `1` = normal, `2` = aggressive |
| `CanRagdoll` | `boolean` | `true` | Whether guards can be ragdolled from player impact |

### Guard Loot Rewards

When `Config.EnableLooting` is `true`, players can loot dead guards for randomized rewards. The reward system uses weighted categories to determine what items drop.

```lua
Config.GuardRewards = {
    weaponChance = 60,
    itemRange = {min = 2, max = 3},
    PistolRewards = {
        items = {"weapon_heavypistol", "weapon_pistol", "weapon_pistol_mk2"},
        chance = 37,
        isGunReward = true
    },
    RareRewards = {
        items = {"weapon_assaultrifle", "weapon_compactrifle", "weapon_mg"},
        chance = 15,
        isGunReward = true
    },
    SMGRewards = {
        items = {"weapon_assaultsmg", "weapon_minismg", "weapon_combatpdw"},
        chance = 32,
        isGunReward = true
    },
    ShotgunRewards = {
        items = {"weapon_sawnoffshotgun", "weapon_pumpshotgun", "weapon_dbshotgun"},
        chance = 25,
        isGunReward = true
    },
    AmmoRewards = {
        items = {"pistol_ammo", "shotgun_ammo", "rifle_ammo", "smg_ammo"},
        chance = 45,
        amount = {min = 1, max = 2}
    },
    MedicRewards = {
        items = {"bandage", "revivekit"},
        chance = 45,
        amount = {min = 1, max = 2}
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `weaponChance` | `number` | `60` | Overall percentage chance of receiving any gun-related reward |
| `itemRange.min` | `number` | `2` | Minimum number of items per loot |
| `itemRange.max` | `number` | `3` | Maximum number of items per loot |

#### Reward Categories

| Category | Items | Chance | Gun Reward |
|---|---|---|---|
| `PistolRewards` | `weapon_heavypistol`, `weapon_pistol`, `weapon_pistol_mk2` | 37 | Yes |
| `RareRewards` | `weapon_assaultrifle`, `weapon_compactrifle`, `weapon_mg` | 15 | Yes |
| `SMGRewards` | `weapon_assaultsmg`, `weapon_minismg`, `weapon_combatpdw` | 32 | Yes |
| `ShotgunRewards` | `weapon_sawnoffshotgun`, `weapon_pumpshotgun`, `weapon_dbshotgun` | 25 | Yes |
| `AmmoRewards` | `pistol_ammo`, `shotgun_ammo`, `rifle_ammo`, `smg_ammo` | 45 | No (1-2 given) |
| `MedicRewards` | `bandage`, `revivekit` | 45 | No (1-2 given) |

::: info
The `chance` values are **relative weights**, not percentages that must add up to 100. A category with chance `45` is three times as likely to be selected as one with chance `15`.
:::

::: warning
Only **one** item from categories marked `isGunReward = true` can be given per loot. Even if `itemRange` allows more items, only one weapon category is selected. To allow multiple weapon drops, set `isGunReward = false` on additional weapon categories.
:::
