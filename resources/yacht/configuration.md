# Configuration

All configuration is done in `config.lua`, located in the root of the `sd-yacht` resource folder.

## Locale

Change the language by editing line 2 of `config.lua`:

```lua
SD.Locale.LoadLocale('en') -- Options: 'en', 'de', 'es', 'fr', 'ar'
```

## General Settings

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.YachtDebug` | boolean | `false` | Enable PolyZone debug visualization for testing |
| `Config.MinimumCops` | number | `4` | Minimum on-duty police required to start the heist |
| `Config.PoliceJobs` | table | `{'police'}` | Array of job names counted toward the police requirement |
| `Config.HasSpawnedOnYacht` | boolean | `true` | Internal spawn flag. Set to `false` for testing only -- must be `true` on live servers |
| `Config.Cooldown` | number | `180` | Cooldown between heists in minutes (3 hours) |
| `Config.ResetYachtOnLeave` | boolean | `false` | If `true`, resets the yacht and cooldown when all players leave and codes have not been entered yet |
| `Config.CheckForItem` | boolean | `true` | Require the `YachtCodes` item to trigger the robbery |
| `Config.Interaction` | string | `'target'` | Interaction mode: `'target'` (qb-target/ox_target) or `'textui'` (drawtext/ox_lib textui) |
| `Config.AlertPoliceOnEnter` | boolean | `true` | If `true`, alerts police when someone enters the zone. If `false`, alerts when yacht codes are input |
| `Config.GiveHints` | boolean | `true` | Show hint messages guiding players through the heist |

::: warning
If you restart the script with `Config.HasSpawnedOnYacht = true`, the resource will not function correctly. Only set it to `false` for testing, and always change it back to `true` for your live server.
:::

## Police Alert

The police dispatch is configured via a function in the config. You can modify the alert details or replace the function entirely to integrate with your dispatch system.

```lua
policeAlert = function()
    SD.PoliceDispatch({
        displayCode = "10-31D",
        title = 'Yacht Heist',
        description = "Yacht Heist in progress",
        message = "Multiple suspects reported near the Yacht",
        sprite = 108,
        scale = 1.0,
        colour = 1,
        blipText = "Yacht Heist",
        dispatchcodename = "yacht_heist" -- Used by ps-dispatch
    })
end
```

| Key | Type | Default | Description |
|---|---|---|---|
| `displayCode` | string | `"10-31D"` | Dispatch code shown in alerts |
| `title` | string | `'Yacht Heist'` | Title used in cd_dispatch/ps-dispatch |
| `description` | string | `"Yacht Heist in progress"` | Description of the alert |
| `message` | string | `"Multiple suspects reported near the Yacht"` | Additional message or information |
| `sprite` | number | `108` | Blip sprite for the dispatch marker |
| `scale` | number | `1.0` | Dispatch blip size on the map |
| `colour` | number | `1` | Dispatch blip color |
| `blipText` | string | `"Yacht Heist"` | Text on the dispatch blip |
| `dispatchcodename` | string | `"yacht_heist"` | Code name used by ps-dispatch in `sv_dispatchcodes.lua` |

## Items Used

These are the items required throughout the heist:

```lua
Config.UsedItems = {
    USB = 'default_gateway_override',
    YachtCodes = 'yachtcodes',
    CasinoCodes = 'casinocodes',
    Safe = 'secured_safe',
    ReviveKit = 'revivekit',
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `USB` | string | `'default_gateway_override'` | Item used for hacking laptops |
| `YachtCodes` | string | `'yachtcodes'` | Item required to start the heist |
| `CasinoCodes` | string | `'casinocodes'` | Casino codes item (used in heist progression) |
| `Safe` | string | `'secured_safe'` | Safe item found on the yacht |
| `ReviveKit` | string | `'revivekit'` | Item used to revive downed teammates |

## Final Items

Items awarded to the player upon completing the heist:

```lua
Config.FinalItems = {'casinocodes'} -- Extend with additional items: {'casinocodes', 'another_item'}
```

You can add as many items as you like to the array.

## Cash Payout

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.CashoutType` | string | `'dirty'` | Payout mode: `'clean'` (unmarked cash), `'dirty'` (marked bills / dirty_money for ESX), or `'custom'` (custom item) |

For `'custom'` mode, configure the following:

```lua
Config.CustomCash = {
    CashItem = 'markedbills',   -- The item identifier to use as currency
    CashQuantity = false,       -- false = 1 item per $1; true = give CashAmount quantity of CashItem
    CashAmount = { min = 1, max = 2 }, -- Only used when CashQuantity = true
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `CashItem` | string | `'markedbills'` | Item identifier used as currency |
| `CashQuantity` | boolean | `false` | If `false`, each item = $1. If `true`, the number of items given equals `CashAmount` |
| `CashAmount` | table | `{min = 1, max = 2}` | Random quantity range of `CashItem` given when `CashQuantity = true` |

::: tip
For ESX servers using the default `dirty_money`, you can use `'dirty'` mode instead of `'custom'` since ESX dirty_money is already 1:1.
:::

## Screen Sequence & Yacht Codes

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.RandomizeYachtCodes` | boolean | `true` | Generate a new 3-segment code on every server restart |
| `Config.YachtCodeDefault` | string | `"21-65-31"` | Fallback code used when `RandomizeYachtCodes` is `false` |
| `Config.CasinoCodesFirstHalf` | string | `"Z892-25B6-14R4-"` | The first half of the casino codes displayed during the heist |

The screen sequence (the order of bridge screens to hack) is randomized each robbery by default. To force a specific order, uncomment and set:

```lua
-- Config.ScreenSequence = {3, 1, 2} -- Hack screen 3 first, then 1, then 2
```

::: info
If `Config.ScreenSequence` is not defined, the script automatically generates a random sequence each robbery.
:::

## Password Attempts

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.PasswordAttempts` | number | `2` | Number of password attempts allowed before the heist fails |

## Pressure Management

The yacht's engine pressure system is central to the heist. Pressure starts at 100 and auto-decreases over time. Players must manage two valves to keep it above the explosion threshold.

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.EnableExplosion` | boolean | `true` | If `true`, the yacht explodes when pressure falls to/below the threshold. If `false`, the yacht seizes up but does not explode |
| `Config.PressureToExplode` | number | `15` | Pressure threshold at or below which the yacht explodes |
| `Config.DecreaseTime` | number | `5` | How frequently (in seconds) pressure auto-decreases |
| `Config.DecreaseAmount` | number | `1` | How much pressure decreases per `DecreaseTime` interval |
| `Config.IncreasePressure1` | number | `math.random(3, 5)` | Amount valve 1 increases pressure (randomized between 3-5 per restart) |
| `Config.IncreasePressure2` | number | `math.random(5, 8)` | Amount valve 2 increases pressure (randomized between 5-8 per restart) |
| `Config.DecreasePressure1` | number | `math.random(1, 3)` | Amount valve 1 decreases pressure (randomized between 1-3 per restart) |
| `Config.DecreasePressure2` | number | `math.random(5, 8)` | Amount valve 2 decreases pressure (randomized between 5-8 per restart) |

::: tip
You can replace the `math.random()` calls with fixed values if you want consistent pressure behavior (e.g., `Config.IncreasePressure1 = 4`).
:::

## Animation & Behavior Settings

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.ForceAnimation` | boolean | `true` | Force the player into a carry/hold animation when holding certain heist items (e.g., safe on back, codes like a phone) |
| `Config.WashUpOnBeach` | boolean | `true` | Teleport players to the beach after completing the heist |
| `Config.SendToBeachOnSpawn` | boolean | `true` | If a player spawns/logs in on the yacht, send them to the beach to prevent exploit re-entry |
| `Config.SendBackOnReset` | boolean | `true` | Send players to the beach if they are in the yacht area when the cooldown resets |
| `Config.UsingReviveKits` | boolean | `true` | Enable revive kit functionality. If `false`, revive kits have no effect |
| `Config.GiveAll` | boolean | `false` | If `true`, give all items from a searched cabin. If `false`, give one random item |

## Blip

```lua
Config.Blip = {
    Enable = true,
    Location = vector3(-2031.6, -1038.13, 5.88),
    Sprite = 455,
    Display = 4,
    Scale = 0.6,
    Colour = 1,
    Name = "Secured Yacht",
    Radius = { Enable = true, Size = 100.0 },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Enable` | boolean | `true` | Show the yacht blip on the map |
| `Location` | vector3 | `(-2031.6, -1038.13, 5.88)` | Map coordinates for the blip |
| `Sprite` | number | `455` | Blip icon sprite ID |
| `Display` | number | `4` | Blip display mode |
| `Scale` | number | `0.6` | Blip size on the map |
| `Colour` | number | `1` | Blip color ID |
| `Name` | string | `"Secured Yacht"` | Text label for the blip |
| `Radius.Enable` | boolean | `true` | Show a radius circle around the blip |
| `Radius.Size` | number | `100.0` | Size of the radius circle |

## Hacking Minigames

Two separate hacking configurations are available -- one for laptops and one for bridge terminals. Each supports 30+ minigame options from various resources.

### Laptop Hacking

```lua
Config.Hacking.Laptop = {
    Minigame = 'hacking-opengame', -- Active minigame
    Args = { ... },                -- Arguments for each supported minigame
}
```

### Terminal Hacking

```lua
Config.Hacking.Terminal = {
    Minigame = 'ps-circle', -- Active minigame
    Args = { ... },         -- Arguments for each supported minigame
}
```

Set the `Minigame` value to the name of the minigame you want to use. The `Args` table contains pre-configured arguments for every supported minigame -- only the one matching your `Minigame` selection is used.

### Supported Minigames

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
| **bl_ui** | `bl-circlesum` | `{3, {length = 4, duration = 5000}}` | Iterations, length, duration (ms) |
| **bl_ui** | `bl-digitdazzle` | `{3, {length = 4, duration = 5000}}` | Iterations, length, duration (ms) |
| **bl_ui** | `bl-lightsout` | `{3, {level = 2, duration = 5000}}` | Iterations, level, duration (ms) |
| **bl_ui** | `bl-minesweeper` | `{3, {grid = 4, duration = 10000, target = 4, previewDuration = 2000}}` | Iterations, grid, duration, target, preview (ms) |
| **bl_ui** | `bl-pathfind` | `{3, {numberOfNodes = 10, duration = 5000}}` | Iterations, nodes, duration (ms) |
| **bl_ui** | `bl-printlock` | `{3, {grid = 4, duration = 5000, target = 4}}` | Iterations, grid, duration, target |
| **bl_ui** | `bl-untangle` | `{3, {numberOfNodes = 10, duration = 5000}}` | Iterations, nodes, duration (ms) |
| **bl_ui** | `bl-wavematch` | `{3, {duration = 5000}}` | Iterations, duration (ms) |
| **bl_ui** | `bl-wordwiz` | `{3, {length = 4, duration = 5000}}` | Iterations, length, duration (ms) |
| **glitch** | `gl-firewall-pulse` | `{3, 2, 10, 10, 40, 120, 10}` | Hacks, initial speed, max speed, time limit, min/max safe zone width, shrink amount |
| **glitch** | `gl-backdoor-sequence` | `{3, 5, 15, 3, 1.0, 1, 3, keys, hint}` | Sequences, length, time limit, attempts, penalty, min/max keys, custom keys, hint text |
| **glitch** | `gl-circuit-rhythm` | `{4, {'A','S','D','F'}, 150, 1000, 20, 'normal', 5, 3}` | Lanes, keys, note speed, spawn rate, required notes, difficulty, wrong keys, missed notes |
| **glitch** | `gl-surge-override` | `{{'E'}, 50, 2, false, combos}` | Keys, presses, decay rate, multi-key mode, combinations |
| **glitch** | `gl-circuit-breaker` | `{1, 0, 1000, 5000, 5000, 0, 0, 3000, 30000}` | Level, difficulty, delay, min/max fail delay, disconnect chance/rate, min/max reconnect time |
| **glitch** | `gl-data-crack` | `{3}` | Difficulty |
| **glitch** | `gl-brute-force` | `{}` | No args (default 5 lives) |
| **glitch** | `gl-var-hack` | `{5, 5}` | Blocks, speed (s) |

::: info
Both Laptop and Terminal support the same full list of minigames. Only the active `Minigame` value determines which one runs -- all other entries in `Args` are ignored at runtime.
:::

## Guards

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.EnableGuards` | boolean | `true` | Enable NPC guard spawning on the yacht |
| `Config.EnableLooting` | boolean | `true` | Allow players to loot dead guards |

### Guard Parameters

```lua
Config.PedParameters = {
    Ped = "mp_m_bogdangoon",
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
| `Ped` | string | `"mp_m_bogdangoon"` | Ped model for the guards |
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

The config defines 10 guard spawn positions in `Config.Guards`. Each entry is a `vector4` with x, y, z, and heading. You can add, remove, or reposition guards by editing the coords table.

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

## Puzzle Configuration

The puzzle state table tracks progression through the heist. These are default values and reset each robbery.

```lua
Config.Puzzle = {
    [1]  = { screens = false },   -- Whether the screen sequence has been completed
    [2]  = { one = false },       -- Screen 1 hacked
    [3]  = { two = false },       -- Screen 2 hacked
    [4]  = { three = false },     -- Screen 3 hacked
    [5]  = { four = false },      -- Screen 4 state
    [6]  = { pressure = 100 },    -- Starting pressure (psi)
    [7]  = { bricked = false },   -- Whether the system has been bricked (failed)
    [8]  = { word = math.random(1, 4) }, -- Random password word index (1-4)
    [9]  = { button = false },    -- Engine start button pressed
    [10] = { vault = false },     -- Vault opened
    [11] = { case = false },      -- Briefcase collected
    [12] = { codes = false },     -- Codes entered
}
```

::: warning
Do not modify `Config.Puzzle` unless you fully understand the heist flow. Incorrect changes can break the progression system.
:::

## Cabin Rewards

Five searchable cabins are defined in `Config.Cabins`. Each cabin has a location, search animation, and item pool.

```lua
Config.Cabins = {
    [1] = {
        coords = vector4(-2050.86, -1024.12, 8.8, 335.89),
        isSearched = false,
        isBusy = false,
        animDic = 'veh@break_in@0h@p_m_one@',
        animName = 'low_force_entry_ds',
        ['items'] = {
            [1] = { item_name = 'rolex', item_amount = 1 },
            [2] = { item_name = 'rolex', item_amount = 2 },
        }
    },
    -- Cabins 2-5 follow the same structure
}
```

### Default Cabin Item Pools

| Cabin | Items | Amounts |
|---|---|---|
| 1 | `rolex` | 1 or 2 |
| 2 | `rolex` | 1 or 2 |
| 3 | `rolex`, `10kgoldchain` | 1 or 2 |
| 4 | `goldbar`, `10kgoldchain` | 1 each |
| 5 | `10kgoldchain`, `tablet` | 2 or 1 |

::: tip
When `Config.GiveAll = false` (default), the player receives one random item from the cabin's pool. Set it to `true` to give all listed items.
:::

## Scattered Valuables

Eight pickupable items are placed around the yacht in `Config.Items`. These include champagne, watches, and a safe.

| Index | Model | Item | Label |
|---|---|---|---|
| 1 | `prop_champ_01b` | `expensive_champagne` | Champagne |
| 2 | `prop_champ_01b` | `expensive_champagne` | Champagne |
| 3 | `prop_champ_01b` | `expensive_champagne` | Champagne |
| 4 | `prop_champ_01b` | `expensive_champagne` | Champagne |
| 5 | `p_watch_05` | `rolex` | Watch |
| 6 | `p_watch_05` | `rolex` | Watch |
| 7 | `prop_champ_01b` | `expensive_champagne` | Champagne |
| 8 | `prop_ld_int_safe_01` | *(safe -- hardcoded)* | Safe |

## Cash Tray Settings

Three cash tray locations are defined, each spawning a cash stack prop on a desk.

```lua
Config.CashTrays = {
    [1] = {
        coords = vector4(-2099.54, -1020.7, 5.38, 162.57),
        isSearched = false,
        model = 'h4_prop_h4_cash_stack_01a',
        tabel_model = 'prop_office_desk_01',
        min = 5000,
        max = 10000,
    },
    -- Trays 2 and 3 use the same models and payout range
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `coords` | vector4 | *(per tray)* | World position and heading of the cash tray |
| `isSearched` | boolean | `false` | Tracks whether this tray has been looted (resets each robbery) |
| `model` | string | `'h4_prop_h4_cash_stack_01a'` | Prop model for the cash stack |
| `tabel_model` | string | `'prop_office_desk_01'` | Prop model for the desk under the cash |
| `min` | number | `5000` | Minimum cash payout from this tray |
| `max` | number | `10000` | Maximum cash payout from this tray |

::: info
The payout amount from each tray is randomized between `min` and `max`. The payout type (clean, dirty, or custom) is controlled by `Config.CashoutType`.
:::

## Screen Symbols

`Config.Screens` defines 30 symbol images used in the screen puzzle. Entries 1-14 are English letter symbols (R, L, G, D, U, E, O, N, P, F, W, M, I, A), and entries 15-30 are non-English character symbols. Each entry contains a `url` pointing to the image hosted externally.

You can replace these URLs with your own images to customize the puzzle appearance.

## Locations

All interactable positions are defined in `Config.Locations`:

```lua
Config.Locations = {
    BeachWashup = vector4(-1839.39, -885.44, 1.68, 117.33),
    Screen_One = vector3(-2086.77, -1019.86, 12.53),
    Screen_Two = vector3(-2086.66, -1017.5, 12.5),
    Screen_Three = vector3(-2085.31, -1015.74, 12.27),
    PuzzleStart = vector3(-2029.52, -1033.62, 2.8),
    PressureValve_One = vector3(-2063.6, -1025.01, 2.5),
    PressureValve_Two = vector3(-2052.57, -1032.55, 3.29),
    CheckPressure = vector3(-2068.92, -1023.55, 3.1),
    AttemptPassword = vector4(-2074.1, -1024.5, 11.62, 251.28),
    RedButton = vector3(-2030.78, -1037.69, 2.8),
    EnterVault = vector3(-2071.36, -1018.63, 3.24),
    ExitVault = vector3(-2072.83, -1018.49, 2.62),
    EnterVaultPlayer = vector4(-2072.94, -1018.59, 1.46, 72.14),
    ExitVaultPlayer = vector4(-2071.04, -1018.72, 1.95, 246.56),
    FinalBriefcase = vector4(-2074.31, -1018.11, 2.0, 72.12),
    Hack_1 = vector3(-2079.38, -1015.88, 5.91),
    Hack_2 = vector3(-2081.64, -1022.54, 8.38),
    Hack_3 = vector3(-2072.3, -1019.0, 11.82),
    Hack_4 = vector3(-2072.3, -1021.66, 2.99),
}
```

## Yacht Area Detection

The yacht area is defined as a sphere for player-in-zone detection:

```lua
Config.Points = {
    yacht = {
        coords = vector3(-2044.17, -1011.93, 0.0),
        distance = 60.0,
    }
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `coords` | vector3 | `(-2044.17, -1011.93, 0.0)` | Approximate center of the yacht |
| `distance` | number | `60.0` | Detection radius around the center point |
