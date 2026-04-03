# Configuration

All configuration is done in `config.lua` in the resource root.

## Locale

```lua
SD.Locale.LoadLocale('en')
```

Sets the language for all translations. Change `'en'` to any language code that has a matching file in the `locales/` folder.

## Map Settings

```lua
Config.MLOType = 'gabz'
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.MLOType` | `string` | `'gabz'` | MLO variant to use. Determines which preset coordinates are loaded for doors, loot crates, guards, blips, and alarms |

Supported values:

| Value | MLO |
|---|---|
| `'gabz'` | Gabz Bobcat Security |
| `'nopixel'` | Tobii / NoPixel Bobcat Security |
| `'k4mb1'` | K4MB1 Bobcat Security |

::: warning
Make sure the MLO you have installed matches the value set here. Using incorrect coordinates will break door interactions, guard spawns, and loot positions.
:::

## General Settings

```lua
Config.BobcatDebug = false
Config.MinimumPolice = 3
Config.PoliceJobs = { 'police', --[['sheriff']] }
Config.Cooldown = 60
Config.Interaction = 'target'
Config.UseTargetForDoors = true
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.BobcatDebug` | `boolean` | `false` | Enable PolyZone debug visualization for testing. Some targeting solutions (e.g. ox_target) may not display PolyZones |
| `Config.MinimumPolice` | `number` | `3` | Minimum police officers online to allow the heist to start |
| `Config.PoliceJobs` | `table` | `{'police'}` | Array of job names that count toward the police check. Uncomment `'sheriff'` or add other jobs as needed |
| `Config.Cooldown` | `number` | `60` | Global cooldown between heists in minutes |
| `Config.Interaction` | `string` | `'target'` | Interaction method: `'target'` (qb-target / qtarget / ox_target) or `'textui'` (cd_drawtextui / qb-core / ox_lib textui) |
| `Config.UseTargetForDoors` | `boolean` | `true` | When `true`, players use the target/interact system on doors instead of using the thermite item directly |

## Items

```lua
Config.Items = {
    Thermite = 'thermite_h',
    Keycard = 'bobcatkeycard',
    Bomb = 'c4_bomb'
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Thermite` | `string` | `'thermite_h'` | Item used to breach doors via thermite |
| `Keycard` | `string` | `'bobcatkeycard'` | Bobcat Security keycard item used to initiate hacking |
| `Bomb` | `string` | `'c4_bomb'` | C4 explosive item used to blow the vault door |

::: tip
Change these values to match the item names in your inventory system if they differ from the defaults.
:::

## Item Removal on Use/Fail

```lua
Config.RemoveKeyCardOnUse = true
Config.RemoveKeyCardOnFail = false
Config.RemoveThermiteOnFail = false
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.RemoveKeyCardOnUse` | `boolean` | `true` | Remove the keycard after a successful hack |
| `Config.RemoveKeyCardOnFail` | `boolean` | `false` | Remove the keycard when the hack fails |
| `Config.RemoveThermiteOnFail` | `boolean` | `false` | Remove thermite when the hack fails |

## Police Alert

```lua
policeAlert = function()
    SD.PoliceDispatch({
        displayCode = "10-31B",
        title = 'Bobcat Weapons Heist',
        description = "Weapons depot heist in progress",
        message = "Suspects reported at the Bobcat Security weapons depot",
        sprite = 313,
        scale = 1.0,
        colour = 2,
        blipText = "Bobcat Heist",
        dispatchcodename = "bobcat_heist"
    })
end
```

| Key | Type | Default | Description |
|---|---|---|---|
| `displayCode` | `string` | `"10-31B"` | Dispatch code displayed in the alert |
| `title` | `string` | `'Bobcat Weapons Heist'` | Alert title (used in cd_dispatch / ps-dispatch) |
| `description` | `string` | `"Weapons depot heist in progress"` | Description shown in the dispatch |
| `message` | `string` | `"Suspects reported at the Bobcat Security weapons depot"` | Additional detail message |
| `sprite` | `number` | `313` | Blip sprite icon on the map |
| `scale` | `number` | `1.0` | Blip size on the map |
| `colour` | `number` | `2` | Blip color |
| `blipText` | `string` | `"Bobcat Heist"` | Text label on the blip |
| `dispatchcodename` | `string` | `"bobcat_heist"` | Code name for ps-dispatch (used in `sv_dispatchcodes.lua` or the ps-dispatch config) |

::: info
The blip settings (`sprite`, `scale`, `colour`, `blipText`) apply to all dispatch systems **except** ps-dispatch. For ps-dispatch, configure the blip appearance using `dispatchcodename` in your ps-dispatch `sv_dispatchcodes.lua` or `config.lua`.
:::

## Explosion & Bomb Settings

```lua
Config.ExplosionType = 2
Config.MaxBombTime = 90
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.ExplosionType` | `number` | `2` | GTA explosion type ID used for the vault door C4 detonation. See the [FiveM explosion type reference](https://docs.fivem.net/natives/?_0xE3AD2BDBAEE269AC) for all available types |
| `Config.MaxBombTime` | `number` | `90` | Maximum duration in seconds that the player can set for the C4 charge timer |

## Alarm Settings

```lua
Config.Alarm = {
    SoundAlarm = false,
    Coordinates = {
        gabz = vector3(877.35, -2129.76, 31.92),
        nopixel = vector3(890.13, -2294.9, 31.17),
    },
    SoundSettings = {
        Name = "ALARMS_KLAXON_03_CLOSE",
        Ref = "",
        Timeout = 2,
    }
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `SoundAlarm` | `boolean` | `false` | Enable or disable the alarm sound when the heist triggers |
| `Coordinates.gabz` | `vector3` | `(877.35, -2129.76, 31.92)` | Alarm sound origin for the Gabz MLO |
| `Coordinates.nopixel` | `vector3` | `(890.13, -2294.9, 31.17)` | Alarm sound origin for the NoPixel MLO |
| `SoundSettings.Name` | `string` | `"ALARMS_KLAXON_03_CLOSE"` | GTA native sound name |
| `SoundSettings.Ref` | `string` | `""` | Sound reference (leave empty for default) |
| `SoundSettings.Timeout` | `number` | `2` | Duration of the alarm sound in minutes |

::: info
There is no alarm coordinate defined for the K4MB1 MLO by default. If you use `k4mb1`, add a `k4mb1` entry to `Coordinates` if you want alarm sounds.
:::

## Blip Settings

```lua
Config.Blip = {
    Enable = true,
    Sprite = 106,
    Display = 4,
    Scale = 0.6,
    Colour = 5,
    Name = "Bobcat Security",
    Locations = {
        gabz = vector3(905.75, -2121.06, 31.23),
        nopixel = vector3(881.36, -2266.83, 30.47),
        k4mb1 = vector3(1385.19, -2618.13, 49.48)
    }
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Enable` | `boolean` | `true` | Show the Bobcat Security blip on the map |
| `Sprite` | `number` | `106` | Blip sprite icon |
| `Display` | `number` | `4` | Blip display type |
| `Scale` | `number` | `0.6` | Blip size on the map |
| `Colour` | `number` | `5` | Blip color |
| `Name` | `string` | `"Bobcat Security"` | Label shown on the blip |
| `Locations` | `table` | See above | Map-specific blip coordinates for each MLO variant |

## Locations & State Management

Each MLO variant has a set of named locations with state tracking for doors and loot crates. The config ships with full coordinate presets for all three supported MLOs.

```lua
Config.Locations = {
    gabz = {
        FirstDoor  = { location = vector3(...), busy = false, hacked = false },
        SecondDoor = { location = vector3(...), busy = false, hacked = false },
        ThirdDoor  = { location = vector3(...), busy = false, hacked = false },
        VaultDoor  = { location = vector3(...), busy = false, hacked = false },
        SMGs       = { location = vector3(...), busy = false, looted = true },
        Explosives = { location = vector3(...), busy = false, looted = true },
        Rifles     = { location = vector3(...), busy = false, looted = true },
        Ammo       = { location = vector3(...), busy = false, looted = true },
    },
    nopixel = { ... },
    k4mb1 = { ... },
}
```

| Key | Type | Description |
|---|---|---|
| `location` | `vector3` | World coordinates for the interaction point |
| `busy` | `boolean` | Whether someone is currently interacting (runtime state, always starts `false`) |
| `hacked` | `boolean` | Whether this door has been hacked open (runtime state, always starts `false`) |
| `looted` | `boolean` | Whether this crate has been looted (runtime state, always starts `true` -- set to `false` when heist starts) |

Each MLO variant (`gabz`, `nopixel`, `k4mb1`) defines four doors (`FirstDoor`, `SecondDoor`, `ThirdDoor`, `VaultDoor`) and four loot locations (`SMGs`, `Explosives`, `Rifles`, `Ammo`).

## Points (Building Zone)

Defines a sphere encompassing the entire Bobcat building for each MLO. Used for proximity detection.

```lua
Config.Points = {
    gabz = {
        coords = vector3(896.08, -2122.36, 30.0),
        distance = 35.0,
    },
    nopixel = {
        coords = vector3(882.62, -2277.83, 30.0),
        distance = 30.0,
    },
    k4mb1 = {
        coords = vector3(1384.48, -2621.55, 52.5),
        distance = 40.0,
    }
}
```

| Key | Type | Description |
|---|---|---|
| `coords` | `vector3` | Approximate center of the Bobcat building |
| `distance` | `number` | Effective radius in game units around the center point |

## Hacking Minigames

Each door and the vault has its own independent minigame configuration. Set the `Minigame` key to the name of the minigame you want to use, and configure the matching entry in the `Args` table.

```lua
Config.Hacking = {
    FirstDoor = {
        Minigame = 'ps-thermite',
        Args = { ... }
    },
    SecondDoor = {
        Minigame = 'ps-thermite',
        Args = { ... }
    },
    ThirdDoor = {
        Enable = true,
        Minigame = 'hacking-opengame',
        Args = { ... }
    },
    Vault = {
        Enable = false,
        Minigame = 'hacking-opengame',
        Args = { ... }
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `FirstDoor.Minigame` | `string` | `'ps-thermite'` | Minigame used for the first door |
| `SecondDoor.Minigame` | `string` | `'ps-thermite'` | Minigame used for the second door |
| `ThirdDoor.Enable` | `boolean` | `true` | Enable or disable the third door hack entirely |
| `ThirdDoor.Minigame` | `string` | `'hacking-opengame'` | Minigame used for the third door |
| `Vault.Enable` | `boolean` | `false` | Enable or disable the vault hack (the vault is breached with C4 by default) |
| `Vault.Minigame` | `string` | `'hacking-opengame'` | Minigame used for the vault |

::: tip
The `ThirdDoor` and `Vault` stages have an `Enable` toggle. Setting `Vault.Enable = true` requires a successful hack in addition to (or instead of) the C4 explosion. The `FirstDoor` and `SecondDoor` stages are always enabled.
:::

### How the Args Table Works

Each minigame entry in the `Args` table defines the parameters for that specific minigame. Only the arguments for the **selected** `Minigame` are used -- all other entries are ignored at runtime but kept for easy switching.

For example, if `Minigame = 'ps-thermite'`, only the `['ps-thermite']` entry in `Args` is read:

```lua
Args = {
    ['ps-thermite'] = {10, 5, 3}, -- {Time in seconds, Grid size, Incorrect blocks}
}
```

### Supported Minigames & Arguments

Below is the full list of supported minigames with their argument structures. Default values shown are from the `FirstDoor` stage.

#### Project Sloth Minigames

| Minigame | Args | Description |
|---|---|---|
| `ps-circle` | `{2, 20}` | Number of circles, Time in milliseconds |
| `ps-maze` | `{20}` | Time in seconds |
| `ps-varhack` | `{2, 3}` | Number of blocks, Time in seconds |
| `ps-thermite` | `{10, 5, 3}` | Time in seconds, Grid size, Incorrect blocks |
| `ps-scrambler` | `{'numeric', 30, 0}` | Type, Time in seconds, Mirrored option |

#### Memorygame / Ran / Hacking / Howdy Minigames

| Minigame | Args | Description |
|---|---|---|
| `memorygame-thermite` | `{10, 3, 3, 10}` | Correct blocks, Incorrect blocks, Show time (seconds), Lose time (seconds) |
| `ran-memorycard` | `{120}` | Time in seconds (FirstDoor: 120, SecondDoor+: 360) |
| `ran-openterminal` | `{}` | No additional arguments |
| `hacking-opengame` | `{15, 4, 1}` | Time in seconds, Number of blocks, Number of repeats |
| `howdy-begin` | `{3, 5000}` | Number of icons, Time in milliseconds |

#### SN Minigames

| Minigame | Args | Description |
|---|---|---|
| `sn-memorygame` | `{3, 2, 10000}` | Keys needed, Number of rounds, Time in milliseconds |
| `sn-skillcheck` | `{50, 5000, {'w','a','s','w'}, 2, 20, 3}` | Speed (ms), Time (ms), Keys, Number of rounds, Number of bars, Number of safe bars |
| `sn-thermite` | `{7, 5, 10000, 2, 2, 3000}` | Number of boxes, Correct boxes, Time (ms), Lives, Rounds, Show time (ms) |
| `sn-keypad` | `{999, 3000}` | Code number, Time in milliseconds |
| `sn-colorpicker` | `{3, 7000, 3000}` | Number of icons, Type time (ms), View time (ms) |

#### RM Minigames

| Minigame | Args | Description |
|---|---|---|
| `rm-typinggame` | `{'easy', 20}` | Difficulty, Duration in seconds |
| `rm-timedlockpick` | `{200}` | Speed value |
| `rm-timedaction` | `{3}` | Number of locks |
| `rm-quicktimeevent` | `{'easy'}` | Difficulty |
| `rm-combinationlock` | `{'easy'}` | Difficulty |
| `rm-buttonmashing` | `{5, 10}` | Decay rate, Increment rate |
| `rm-angledlockpick` | `{'easy'}` | Difficulty |
| `rm-fingerprint` | `{200, 5}` | Time in seconds, Number of lives |
| `rm-hotwirehack` | `{10}` | Time in seconds |
| `rm-hackerminigame` | `{5, 3}` | Length, Number of lives |
| `rm-safecrack` | `{'easy'}` | Difficulty |

::: info
You can use different minigames for different doors. For example, `ps-thermite` for the first two doors and `hacking-opengame` for the third door and vault.
:::

## Crate Rewards

Rewards from the four loot crates inside the vault. Each crate category gives a random number of items from its item pool.

```lua
Config.Crates = {
    smgs = {
        Amount = {5, 8},
        Items = {
            "weapon_smg",
            "weapon_microsmg",
            "weapon_machinepistol",
            "weapon_minismg",
            "weapon_pistol50"
        }
    },
    rifles = {
        Amount = {3, 6},
        Items = {
            "weapon_assaultrifle",
            "weapon_compactrifle",
            "weapon_mg",
            "weapon_pumpshotgun",
        }
    },
    explosives = {
        Amount = {2, 4},
        Items = {
            "weapon_grenade",
            "weapon_molotov",
            "weapon_stickybomb",
        }
    },
    ammo = {
        Amount = {6, 8},
        Items = {
            "mg_ammo",
            "shotgun_ammo",
            "smg_ammo",
            "rifle_ammo",
            "pistol_ammo",
        }
    }
}
```

| Crate | Amount Range | Items |
|---|---|---|
| `smgs` | 5 -- 8 | `weapon_smg`, `weapon_microsmg`, `weapon_machinepistol`, `weapon_minismg`, `weapon_pistol50` |
| `rifles` | 3 -- 6 | `weapon_assaultrifle`, `weapon_compactrifle`, `weapon_mg`, `weapon_pumpshotgun` |
| `explosives` | 2 -- 4 | `weapon_grenade`, `weapon_molotov`, `weapon_stickybomb` |
| `ammo` | 6 -- 8 | `mg_ammo`, `shotgun_ammo`, `smg_ammo`, `rifle_ammo`, `pistol_ammo` |

The `Amount` field is a pair `{min, max}` -- the actual count given is randomized between the two values (inclusive). One random item from `Items` is selected each time.

## Guards

```lua
Config.EnableGuards = true
Config.EnableLooting = true
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.EnableGuards` | `boolean` | `true` | Enable NPC guards inside Bobcat Security |
| `Config.EnableLooting` | `boolean` | `true` | Allow players to loot dead guards |

### Guard Ped Parameters

Controls the appearance, health, weapons, and combat behavior of all spawned guards.

```lua
Config.PedParameters = {
    Ped = "s_m_m_prisguard_01",
    Health = 200,
    Weapon = {"WEAPON_PISTOL", "WEAPON_SMG", "WEAPON_ASSAULTRIFLE"},
    MinArmor = 50,
    MaxArmor = 100,
    Headshots = true,
    CombatAbility = 100,
    Accuracy = 60,
    CombatRange = 2,
    CombatMovement = 2,
    CanRagdoll = true
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Ped` | `string` | `"s_m_m_prisguard_01"` | Ped model name for the guards |
| `Health` | `number` | `200` | Both maximum and initial health of each guard |
| `Weapon` | `table` | `{"WEAPON_PISTOL", "WEAPON_SMG", "WEAPON_ASSAULTRIFLE"}` | Pool of weapons -- each guard is randomly assigned one |
| `MinArmor` | `number` | `50` | Minimum armor value (randomized between min and max) |
| `MaxArmor` | `number` | `100` | Maximum armor value |
| `Headshots` | `boolean` | `true` | Whether guards can suffer critical hits (headshots) |
| `CombatAbility` | `number` | `100` | Combat skill level (0--100, 100 = highest) |
| `Accuracy` | `number` | `60` | Shooting accuracy (0--100, 100 = highest) |
| `CombatRange` | `number` | `2` | Preferred combat range: `0` = short, `1` = medium, `2` = long |
| `CombatMovement` | `number` | `2` | Movement style in combat: `0` = calm, `1` = normal, `2` = aggressive |
| `CanRagdoll` | `boolean` | `true` | Whether guards can be ragdolled from player impact |

### Guard Spawn Locations

Guard spawn coordinates are defined per MLO in `Config.Guards`. Each MLO has an array of `vector4` positions (x, y, z, heading). By default, each MLO has 6 guard spawn points.

```lua
Config.Guards = {
    gabz = {
        {
            coords = {
                vector4(898.9, -2124.34, 31.23, 350.39),
                vector4(895.61, -2129.21, 31.23, 344.53),
                vector4(898.04, -2134.72, 31.23, 355.54),
                vector4(890.74, -2135.87, 31.23, 338.76),
                vector4(883.63, -2135.02, 31.23, 261.97),
                vector4(877.78, -2132.36, 31.23, 248.4)
            }
        },
    },
    nopixel = { ... },
    k4mb1 = { ... },
}
```

### Guard Loot Rewards

When `Config.EnableLooting` is `true`, dead guards can be looted. The reward system uses weighted categories.

```lua
Config.Rewards = {
    weaponChance = 40,
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
        items = {"bandage"},
        chance = 45,
        amount = {min = 1, max = 2}
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `weaponChance` | `number` | `40` | Overall percentage chance of receiving any gun-related reward per loot |
| `itemRange` | `table` | `{min = 2, max = 3}` | Minimum and maximum total items a player receives per loot |

#### Reward Categories

| Category | Items | Chance (Weight) | Gun Reward | Amount |
|---|---|---|---|---|
| `PistolRewards` | `weapon_heavypistol`, `weapon_pistol`, `weapon_pistol_mk2` | 37 | Yes | 1 |
| `RareRewards` | `weapon_assaultrifle`, `weapon_compactrifle`, `weapon_mg` | 15 | Yes | 1 |
| `SMGRewards` | `weapon_assaultsmg`, `weapon_minismg`, `weapon_combatpdw` | 32 | Yes | 1 |
| `ShotgunRewards` | `weapon_sawnoffshotgun`, `weapon_pumpshotgun`, `weapon_dbshotgun` | 25 | Yes | 1 |
| `AmmoRewards` | `pistol_ammo`, `shotgun_ammo`, `rifle_ammo`, `smg_ammo` | 45 | No | 1 -- 2 |
| `MedicRewards` | `bandage` | 45 | No | 1 -- 2 |

::: info
The `chance` value is a **weight**, not a strict percentage. A category with chance `45` is three times as likely to be selected as one with chance `15`. Weights do not need to sum to 100.
:::

::: warning
Only **one** gun reward (`isGunReward = true`) can be selected per loot. Even if `itemRange` allows for 3 items, at most one will be a weapon. The remaining slots are filled from non-gun categories (`AmmoRewards`, `MedicRewards`) or skipped. If you want players to potentially receive multiple weapons per loot, set `isGunReward = false` on the additional weapon categories.
:::
