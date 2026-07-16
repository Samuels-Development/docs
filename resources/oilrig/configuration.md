# Configuration

All configuration is done in `config.lua`, located in the root of the `sd-oilrig` resource folder.

## Locale

Change the language by editing line 3 of `config.lua`:

```lua
SD.Locale.LoadLocale('en') -- Options: 'en', 'de', 'es', 'fr', 'ar'
```

## MLO Type

The oil rig supports two MLO variants. Set this to match the MLO you have installed on your server:

```lua
Config.MLOType = 'k4mb1' -- 'k4mb1' or 'nopixel'
```

| Value | MLO |
|---|---|
| `'k4mb1'` | K4MB1's Oil Rig MLO |
| `'nopixel'` | NoPixel's Oil Rig MLO |

::: warning
All coordinates (locations, guards, barrels, blip) are pre-configured for both MLOs. Changing `Config.MLOType` switches the entire coordinate set automatically — no manual coordinate changes needed.
:::

## General Settings

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.OilRigDebug` | boolean | `false` | Enable PolyZone debug visualization for testing |
| `Config.HasSpawnedInOilrig` | boolean | `true` | Internal spawn flag. Set to `false` for testing only — must be `true` on live servers |
| `Config.MinimumCops` | number | `3` | Minimum on-duty police required to start the heist |
| `Config.PoliceJobs` | table | `{'police'}` | Array of job names counted toward the police requirement |
| `Config.Interaction` | string | `'target'` | Interaction mode: `'target'` (qb-target/ox_target) or `'textui'` (drawtext/ox_lib textui) |
| `Config.Cooldown` | number | `180` | Cooldown between heists in minutes |
| `Config.ResetOilOnLeave` | boolean | `false` | If `true`, resets the rig and cooldown when all players leave before the USB dongle has been used |
| `Config.CheckForItem` | boolean | `false` | If `true`, requires the `security_card_oil` item when entering the zone to trigger the heist |
| `Config.AlertPoliceOnEnter` | boolean | `false` | If `true`, alerts police when someone enters the zone. If `false`, alerts when the USB dongle is inserted |
| `Config.GiveHints` | boolean | `false` | Show hint messages guiding players through the heist stages |

::: warning
If you restart the script with `Config.HasSpawnedInOilrig = true`, the resource will not function correctly. Only set it to `false` for testing, and always change it back to `true` for your live server.
:::

## Police Alert

The police dispatch is configured via a function in the config. You can modify the alert details or replace the function entirely to integrate with your dispatch system.

```lua
policeAlert = function()
    SD.PoliceDispatch({
        displayCode = "10-31H",
        title = 'Oilrig Heist',
        description = "Oilrig Heist in progress",
        message = "Suspects reported on the oilrig",
        sprite = 310,
        scale = 1.0,
        colour = 1,
        blipText = "Oilrig Heist",
        dispatchcodename = "oilrig_heist"
    })
end
```

| Key | Type | Default | Description |
|---|---|---|---|
| `displayCode` | string | `"10-31H"` | Dispatch code shown in alerts |
| `title` | string | `'Oilrig Heist'` | Title used in cd_dispatch/ps-dispatch |
| `description` | string | `"Oilrig Heist in progress"` | Description of the alert |
| `message` | string | `"Suspects reported on the oilrig"` | Additional message or information |
| `sprite` | number | `310` | Blip sprite for the dispatch marker |
| `scale` | number | `1.0` | Dispatch blip size on the map |
| `colour` | number | `1` | Dispatch blip color |
| `blipText` | string | `"Oilrig Heist"` | Text on the dispatch blip |
| `dispatchcodename` | string | `"oilrig_heist"` | Code name used by ps-dispatch in `sv_dispatchcodes.lua` |

## Items Used

These are the items required throughout the heist:

```lua
Config.Items = {
    Laptop = 'laptop_pink',
    USB = 'security_card_oil',
    Barrel = 'oilbarrel',
    ReviveKit = 'revivekit'
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Laptop` | string | `'laptop_pink'` | Item required to hack laptop terminals |
| `USB` | string | `'security_card_oil'` | Item used to insert the dongle and start the heist |
| `Barrel` | string | `'oilbarrel'` | Item representing a collected oil barrel |
| `ReviveKit` | string | `'revivekit'` | Item used to revive downed teammates |

## Final Items

Items awarded to the player upon completing the heist (entering the correct password):

```lua
Config.FinalItems = {'security_card_01', 'security_card_02', 'token'}
```

You can add or replace any items in this array. Ensure all items exist in your inventory database.

## Laptop Behavior

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.RemoveLaptopOnUse` | boolean | `false` | If `true`, removes a laptop item each time a hack is started |
| `Config.RemoveLaptopOnSuccess` | boolean | `true` | If `true`, removes a laptop item each time a hack is successfully completed |
| `Config.ViewLetters` | boolean | `true` | Allow players to re-view revealed letters after hacking. If `false`, letters can only be viewed once |
| `Config.UseChatMessages` | boolean | `false` | If `true`, sends revealed letters via chat. If `false`, sends them as notifications |

### Laptop Props

Laptop props can be spawned at each hack location:

```lua
Config.SpawnLaptops = {
    Enable = true,
    Prop = 'h4_prop_h4_laptop_01a',
    locations = { ... }
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Enable` | boolean | `true` | Spawn laptop props at hack locations |
| `Prop` | string | `'h4_prop_h4_laptop_01a'` | Prop model for the laptop |

## Password System

A random 4-letter word is selected at the start of each robbery. Players discover the letters by hacking the 4 laptops.

```lua
Config.Password = {
    { word = "DART", letters = { "D", "A", "R", "T" } },
    { word = "EURO", letters = { "E", "U", "R", "O" } },
    -- Add more words as needed (must be 4 letters, all uppercase)
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.PasswordAttempts` | number | `2` | Number of password attempts allowed before the heist fails |
| `Config.SimplifiedMessages` | boolean | `false` | If `true`, tells players the position of the letter (e.g. "it's the first letter"). If `false`, only states the letter itself |

::: tip
You can add as many words as you like. Each must be exactly 4 letters and all uppercase.
:::

## Lever Sequence

By default, the lever sequence is randomized each robbery. To force a specific sequence, uncomment and set:

```lua
-- Config.LeverSequence = {3, 1, 2} -- Pull Lever 3, then Lever 1, then Lever 2
```

::: info
If `Config.LeverSequence` is not defined (commented out), the script automatically generates a random 3-lever sequence each robbery.
:::

## Pressure Management

After the levers are pulled, the automatic pressure regulators are deactivated. Players must manually regulate pressure using valves.

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.PressureToExplode` | number | `80` | Pressure threshold — if pressure exceeds this value, the oil rig explodes |

::: warning
Pressure must be regulated to approximately **55%**. If pressure rises above `Config.PressureToExplode` (default: 80), the rig will explode. If it drops too low, the rig seizes up and the heist fails.
:::

## Animation & Behavior Settings

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.ChangeTime` | boolean | `false` | If `true`, changes the weather and time of day when entering/leaving the oil rig zone (QBCore / qb-weathersync only) |
| `Config.FadeOutIn` | boolean | `true` | Fade the screen in/out when entering or leaving the oil rig zone |
| `Config.ForceAnimation` | boolean | `false` | Force players into a barrel-carry animation when holding the `oilbarrel` item |
| `Config.SendToBeachOnSpawn` | boolean | `true` | Send players to the beach if they spawn/log in on the oil rig, to prevent exploit re-entry |
| `Config.WashUpOnBeach` | boolean | `true` | Teleport players to the beach after completing the heist |
| `Config.RemoveGuardsOnEnd` | boolean | `true` | Remove guards when the heist ends (prevents opportunistic looting after the heist) |
| `Config.SendBackOnReset` | boolean | `true` | Send players to the beach if they are in the oil rig area when the cooldown resets |
| `Config.UsingReviveKits` | boolean | `true` | Enable revive kit functionality. If `false`, revive kits have no effect |

## Blip

```lua
Config.Blip = {
    Enable = true,
    Sprite = 378,
    Display = 4,
    Scale = 0.6,
    Colour = 1,
    Name = "Secured Oil Rig",
    Locations = {
        k4mb1   = vector3(-2729.26, 6598.01, 44.0),
        nopixel = vector3(-3560.24, 7378.44, 43.91),
    }
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Enable` | boolean | `true` | Show the oil rig blip on the map |
| `Sprite` | number | `378` | Blip icon sprite ID |
| `Display` | number | `4` | Blip display mode |
| `Scale` | number | `0.6` | Blip size on the map |
| `Colour` | number | `1` | Blip color ID |
| `Name` | string | `"Secured Oil Rig"` | Text label for the blip |
| `Locations.k4mb1` | vector3 | `(-2729.26, 6598.01, 44.0)` | Blip position for K4MB1 MLO |
| `Locations.nopixel` | vector3 | `(-3560.24, 7378.44, 43.91)` | Blip position for NoPixel MLO |

## Hacking Minigame

```lua
Config.Hacking = {
    Laptop = {
        Minigame = 'hacking-opengame',
        Args = { ... }
    }
}
```

Set the `Minigame` value to the name of the minigame you want to use. The `Args` table contains pre-configured arguments for every supported minigame — only the one matching your `Minigame` selection is used.

### Supported Minigames

::: v-pre
| Source | Minigame Key | Default Args | Description |
|---|---|---|---|
| **ps_ui** | `ps-circle` | `{2, 20}` | Number of circles, time (ms) |
| **ps_ui** | `ps-maze` | `{20}` | Time (seconds) |
| **ps_ui** | `ps-varhack` | `{2, 3}` | Number of blocks, time (seconds) |
| **ps_ui** | `ps-thermite` | `{10, 5, 3}` | Time (s), grid size, incorrect blocks |
| **ps_ui** | `ps-scrambler` | `{'numeric', 30, 0}` | Type, time (s), mirrored option |
| **memorygame** | `memorygame-thermite` | `{10, 3, 3, 10}` | Correct blocks, incorrect blocks, show time (s), lose time (s) |
| **ran** | `ran-memorycard` | `{360}` | Time (seconds) |
| **ran** | `ran-openterminal` | `{}` | No arguments |
| **nopixel** | `hacking-opengame` | `{15, 4, 1}` | Time (s), number of blocks, number of repeats |
| **howdy** | `howdy-begin` | `{3, 5000}` | Number of icons, time (ms) |
| **sn** | `sn-memorygame` | `{3, 2, 10000}` | Keys needed, rounds, time (ms) |
| **sn** | `sn-skillcheck` | `{50, 5000, {'w','a','s','w'}, 2, 20, 3}` | Speed (ms), time (ms), keys, rounds, bars, safe bars |
| **sn** | `sn-thermite` | `{7, 5, 10000, 2, 2, 3000}` | Boxes, correct boxes, time (ms), lives, rounds, show time (ms) |
| **sn** | `sn-keypad` | `{999, 3000}` | Code number, time (ms) |
| **sn** | `sn-colorpicker` | `{3, 7000, 3000}` | Icons, type time (ms), view time (ms) |
| **rainmad** | `rm-typinggame` | `{'easy', 20}` | Difficulty, duration (s) |
| **rainmad** | `rm-timedlockpick` | `{200}` | Speed value |
| **rainmad** | `rm-timedaction` | `{3}` | Number of locks |
| **rainmad** | `rm-quicktimeevent` | `{'easy'}` | Difficulty |
| **rainmad** | `rm-combinationlock` | `{'easy'}` | Difficulty |
| **rainmad** | `rm-buttonmashing` | `{5, 10}` | Decay rate, increment rate |
| **rainmad** | `rm-angledlockpick` | `{'easy'}` | Difficulty |
| **rainmad** | `rm-fingerprint` | `{200, 5}` | Time (s), lives |
| **rainmad** | `rm-hotwirehack` | `{10}` | Time (seconds) |
| **rainmad** | `rm-hackerminigame` | `{5, 3}` | Length, lives |
| **rainmad** | `rm-safecrack` | `{'easy'}` | Difficulty |
:::

## Guards

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.EnableGuards` | boolean | `true` | Enable NPC guard spawning on the oil rig |
| `Config.EnableLooting` | boolean | `true` | Allow players to loot dead guards |

### Guard Parameters

```lua
Config.PedParameters = {
    Ped = "s_m_y_marine_01",
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
| `Ped` | string | `"s_m_y_marine_01"` | Ped model for the guards |
| `Health` | number | `200` | Maximum and initial health of guards |
| `Weapon` | table | `{"WEAPON_PISTOL", "WEAPON_SMG", "WEAPON_ASSAULTRIFLE"}` | List of weapons randomly assigned to guards |
| `MinArmor` | number | `50` | Minimum armor value for guards |
| `MaxArmor` | number | `100` | Maximum armor value for guards |
| `Headshots` | boolean | `true` | Whether guards can receive critical hits (headshots) |
| `CombatAbility` | number | `100` | Combat ability (0-100, higher = better) |
| `Accuracy` | number | `60` | Shot accuracy (0-100, higher = more accurate) |
| `CombatRange` | number | `2` | Engagement range: `0` = short, `1` = medium, `2` = long |
| `CombatMovement` | number | `2` | Movement style: `0` = calm, `1` = normal, `2` = aggressive |
| `CanRagdoll` | boolean | `true` | Whether guards can be ragdolled from player impact |

### Guard Spawn Locations

Guards are defined in `Config.Guards` with separate coordinate sets for each MLO. Each entry is a `vector4` with x, y, z, and heading. K4MB1 includes 25 spawn points; NoPixel includes 23. You can add, remove, or reposition guards by editing the `coords` table for your MLO.

### Guard Loot Rewards

```lua
Config.Rewards = {
    weaponChance = 60,
    itemRange = { min = 2, max = 3 },
    PistolRewards  = { items = {"weapon_heavypistol", "weapon_pistol", "weapon_pistol_mk2"}, chance = 37, isGunReward = true },
    RareRewards    = { items = {"weapon_assaultrifle", "weapon_compactrifle", "weapon_mg"}, chance = 15, isGunReward = true },
    SMGRewards     = { items = {"weapon_assaultsmg", "weapon_minismg", "weapon_combatpdw"}, chance = 32, isGunReward = true },
    ShotgunRewards = { items = {"weapon_sawnoffshotgun", "weapon_pumpshotgun", "weapon_dbshotgun"}, chance = 25, isGunReward = true },
    AmmoRewards    = { items = {"pistol_ammo", "shotgun_ammo", "rifle_ammo", "smg_ammo"}, chance = 45, amount = {min = 1, max = 2} },
    MedicRewards   = { items = {"bandage", "revivekit"}, chance = 45, amount = {min = 1, max = 2} },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `weaponChance` | number | `60` | Overall percentage chance of receiving any gun-related reward |
| `itemRange` | table | `{min = 2, max = 3}` | Min/max number of items a player receives per loot |
| `PistolRewards.chance` | number | `37` | Weighted chance for pistol category |
| `RareRewards.chance` | number | `15` | Weighted chance for rare weapon category |
| `SMGRewards.chance` | number | `32` | Weighted chance for SMG category |
| `ShotgunRewards.chance` | number | `25` | Weighted chance for shotgun category |
| `AmmoRewards.chance` | number | `45` | Weighted chance for ammo category |
| `AmmoRewards.amount` | table | `{min = 1, max = 2}` | Random quantity of ammo items given |
| `MedicRewards.chance` | number | `45` | Weighted chance for medical supply category |
| `MedicRewards.amount` | table | `{min = 1, max = 2}` | Random quantity of medical items given |

::: info
The `chance` values are relative weights, not percentages that must add to 100. A category with `chance = 45` is three times more likely than one with `chance = 15`. Only **one** gun reward (`isGunReward = true`) can be selected per loot. Non-gun categories can stack freely within `itemRange`.
:::

## Gas Stations

Nine gas station locations are defined in `Config.GasStation`. Each has a world position and a randomized price generated at resource start.

```lua
Config.GasStation = {
    [1] = { coords = vector4(-702.93, -916.52, 19.44, 353.14), price = math.random(10000, 12299) },
    [2] = { coords = vector4(-41.16, -1748.3, 29.83, 133.28),  price = math.random(9000, 12299) },
    -- ... (9 stations total)
}
```

You can add, remove, or reposition stations by editing the `Config.GasStation` table. Prices are randomized between the given `min` and `max` when the resource starts.

## Locations

All interactable positions are defined per-MLO in `Config.Locations`. The correct set is selected automatically based on `Config.MLOType`.

```lua
Config.Locations = {
    k4mb1 = {
        BeachWashup      = vector4(-963.05, 5583.61, 2.83, 49.92),
        Levers           = vector3(-2733.54, 6607.53, 21.5),
        PuzzleStart      = vector3(-2723.67, 6600.28, 15.1),
        PressureValve    = vector3(-2714.35, 6607.18, 21.48),
        CheckPressure    = vector3(-2721.89, 6598.96, 22.98),
        AttemptPassword  = vector3(-2732.49, 6621.32, 25.29),
        HackLocation_1   = vector3(-2739.00, 6610.12, 21.74),
        HackLocation_2   = vector3(-2739.83, 6608.22, 15.04),
        HackLocation_3   = vector3(-2722.96, 6591.19, 14.90),
        HackLocation_4   = vector3(-2745.14, 6602.63, 29.45),
    },
    nopixel = { ... } -- Same keys, NoPixel-specific coordinates
}
```

## Oil Rig Detection Zone

The area detection zone is defined as a sphere:

```lua
Config.Points = {
    oilrig = {
        k4mb1   = { coords = vector3(-2825.73, 6596.33, 0.0), distance = 500.0 },
        nopixel = { coords = vector3(-3538.09, 7312.83, 0.0), distance = 500.0 },
    }
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `coords` | vector3 | *(per MLO)* | Approximate center of the oil rig area |
| `distance` | number | `500.0` | Detection radius around the center point |

## Puzzle Configuration

The puzzle state table tracks heist progression. These are internal default values and reset each robbery.

```lua
Config.Puzzle = {
    [1] = { levers = false },           -- Whether levers have been pulled
    [2] = { one = false },              -- Laptop 1 hacked
    [3] = { two = false },              -- Laptop 2 hacked
    [4] = { three = false },            -- Laptop 3 hacked
    [5] = { four = false },             -- Laptop 4 hacked
    [6] = { pressure = math.random(20, 80) }, -- Starting pressure (randomized)
    [7] = { bricked = false },          -- Whether the system has been bricked (failed)
}
```

::: warning
Do not modify `Config.Puzzle` unless you fully understand the heist flow. Incorrect changes can break the progression system.
:::
