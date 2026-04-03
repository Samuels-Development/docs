# Configuration

All configuration for sd-pacificbank is split across two files:

- **`config.lua`** -- Main configuration (general settings, items, police alert, locations, hacking minigames, drill settings, rewards, lasers, guards, and guard loot)
- **`server/logs.lua`** -- Logging configuration (service selection, event toggles, and webhook/API settings)

## Locale

The locale is loaded at the top of `config.lua`:

```lua
SD.Locale.LoadLocale('en')
```

Change the string to load a different language. Locale files are stored in the `locales/` directory.

## General Settings

```lua
Config.PacificDebug = false
Config.MinimumPolice = 3
Config.PoliceJobs = { 'police', --[['sheriff']] }
Config.DoorLock = 'ox'
Config.Cooldown = 120
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.PacificDebug` | `boolean` | `false` | Enable PolyZone debug visualizations for testing. Some targeting solutions (e.g. ox_target) may not display them |
| `Config.MinimumPolice` | `number` | `3` | Minimum number of police online to start the heist |
| `Config.PoliceJobs` | `table` | `{ 'police' }` | Array of job names that count toward the police requirement. Uncomment `'sheriff'` or add others as needed |
| `Config.DoorLock` | `string` | `'ox'` | Door lock system to use: `'ox'`, `'qb'`, or `'nui'` |
| `Config.Cooldown` | `number` | `120` | Global cooldown in minutes between heists |

## Items

```lua
Config.Items = {
    ComputerHack = 'laptop_pink',
    TerminalHack = 'laptop_gold',
    Drill = 'large_drill',
    Thermite = 'thermite',
    Bomb = 'c4_bomb'
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `ComputerHack` | `string` | `'laptop_pink'` | Item required for hacking office computers |
| `TerminalHack` | `string` | `'laptop_gold'` | Item required for hacking door consoles/terminals |
| `Drill` | `string` | `'large_drill'` | Item required for drilling deposit boxes |
| `Thermite` | `string` | `'thermite'` | Item required for thermite breaching doors |
| `Bomb` | `string` | `'c4_bomb'` | Item required for the vault bomb |

::: tip
Change the item names to match whatever items exist in your server's inventory system. Ensure all five items are registered and obtainable by players.
:::

## Police Alert

The `policeAlert` function is called when the heist begins and police are notified. It uses `SD.PoliceDispatch` and can be customized freely.

```lua
policeAlert = function()
    SD.PoliceDispatch({
        displayCode = "10-31P",
        title = 'Pacific Bank Heist',
        description = "Pacific Bank Heist in progress",
        message = "Multiple suspects reported inside Pacific Bank",
        sprite = 108,
        scale = 1.0,
        colour = 1,
        blipText = "Pacific Bank Heist",
        dispatchcodename = "pacific_bank_heist"
    })
end
```

| Key | Type | Default | Description |
|---|---|---|---|
| `displayCode` | `string` | `"10-31P"` | Dispatch code displayed to officers |
| `title` | `string` | `'Pacific Bank Heist'` | Title used in cd_dispatch/ps-dispatch |
| `description` | `string` | `"Pacific Bank Heist in progress"` | Description of the dispatch call |
| `message` | `string` | `"Multiple suspects reported inside Pacific Bank"` | Additional message or information |
| `sprite` | `number` | `108` | Blip sprite icon on the map |
| `scale` | `number` | `1.0` | Blip size on the map |
| `colour` | `number` | `1` | Blip color on the map |
| `blipText` | `string` | `"Pacific Bank Heist"` | Text that appears on the blip |
| `dispatchcodename` | `string` | `"pacific_bank_heist"` | Code name used by ps-dispatch in `sv_dispatchcodes.lua` or `config.lua` under `Config.Blips` |

::: info
The blip settings (`sprite`, `scale`, `colour`, `blipText`) are used for all dispatch systems **except** ps-dispatch. For ps-dispatch, configure the blip via `dispatchcodename` in your ps-dispatch config.
:::

## Item Removal Chances

Controls whether items are consumed after use and the probability of removal.

```lua
Config.RemoveItemOnUse = true
Config.RemoveItemChanceUse = 35

Config.RemoveDrillOnSuccess = false
Config.RemoveDrillChanceSuccess = 15

Config.RemoveDrillOnFail = true
Config.RemoveDrillChanceFail = 15
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.RemoveItemOnUse` | `boolean` | `true` | Remove the hacking item (laptop) on successful hack |
| `Config.RemoveItemChanceUse` | `number` | `35` | Percentage chance to remove the item on successful use |
| `Config.RemoveDrillOnSuccess` | `boolean` | `false` | Remove the drill on successful deposit box drilling |
| `Config.RemoveDrillChanceSuccess` | `number` | `15` | Percentage chance to remove the drill on success |
| `Config.RemoveDrillOnFail` | `boolean` | `true` | Remove the drill on a failed drilling minigame |
| `Config.RemoveDrillChanceFail` | `number` | `15` | Percentage chance to remove the drill on failure |

::: tip
Setting `RemoveItemOnUse` to `true` with `RemoveItemChanceUse` at `35` means there is a 35% chance the laptop is consumed after each successful hack. Set the chance to `100` for guaranteed removal, or `0` to never remove.
:::

## Computer & Console Locations

These define the target interaction positions for each stage of the heist.

### Office Computers

The four office computers that players hack to receive vault code fragments:

```lua
Config.Computer1Location = vector3(261.75, 234.91, 109.44) -- First Office
Config.Computer2Location = vector3(270.28, 231.75, 109.34) -- Second Office
Config.Computer3Location = vector3(260.63, 205.57, 109.31) -- Third Office
Config.Computer4Location = vector3(252.05, 208.86, 109.3)  -- Fourth Office
```

### Password Input

The laptop in the main office where players enter the combined vault code:

```lua
Config.InputPassword = vector3(278.95, 213.06, 109.43)
```

### Door Consoles

Hackable consoles that open doors in the vault area:

```lua
-- First two doors to enter the vault area
Config.DoorConsole1 = { pos = vector3(270.59, 221.26, 96.6), hacked = false }
Config.DoorConsole2 = { pos = vector3(267.43, 213.28, 96.6), hacked = false }

-- Doors for each side room
Config.DoorConsole3 = { pos = vector3(247.48, 233.82, 96.6), hacked = false }
Config.DoorConsole4 = { pos = vector3(241.7, 218.64, 96.61), hacked = false }

-- Console inside the vault
Config.DoorConsole5 = { pos = vector3(227.93, 228.5, 96.71), hacked = false }
```

### Thermite Doors

Doors in the middle of the vault area that require thermite to breach:

```lua
Config.ThermiteDoor1 = { pos = vector3(251.96, 216.95, 96.45), open = false }
Config.ThermiteDoor2 = { pos = vector3(256.07, 228.2, 96.36), open = false }
```

### Vault Door

```lua
Config.VaultDoor = vector3(235.52, 229.52, 97.65)
```

::: warning
Do not change the `hacked` or `open` default values. These are runtime state flags that the script manages internally. Only modify the `pos` coordinates if you need to adjust interaction positions.
:::

## Password Attempts

```lua
Config.UseChatMessages = false
Config.PasswordAttempts = 3
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.UseChatMessages` | `boolean` | `false` | `true` = display vault codes in chat; `false` = display codes as notifications |
| `Config.PasswordAttempts` | `number` | `3` | Number of attempts players have to enter the correct vault code before lockout |

## Bank Zone

Defines the area encompassing the entire Pacific Bank, used for proximity checks:

```lua
Config.Points = {
    pacific = {
        coords = vector3(253.38, 228.38, 101.68),
        distance = 35.0,
    }
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `coords` | `vector3` | `253.38, 228.38, 101.68` | Approximate center of the bank |
| `distance` | `number` | `35.0` | Effective radius of the zone |

## Hacking Minigames

Each hacking stage (Computer, Terminal, Thermite) has its own independent minigame configuration. Set the `Minigame` key to your preferred minigame, then configure its arguments in the `Args` table.

```lua
Config.Hacking = {
    Computer = {
        Minigame = 'hacking-opengame',
        Args = { ... }
    },
    Terminal = {
        Minigame = 'ps-varhack',
        Args = { ... }
    },
    Thermite = {
        Minigame = 'ps-thermite',
        Args = { ... }
    },
}
```

| Stage | Default Minigame | Description |
|---|---|---|
| `Computer` | `'hacking-opengame'` | Minigame used when hacking office computers for vault codes |
| `Terminal` | `'ps-varhack'` | Minigame used when hacking door console terminals |
| `Thermite` | `'ps-thermite'` | Minigame used when placing thermite on doors |

### Supported Minigames

Each stage supports the same set of minigames. Set the `Minigame` value to any key listed below, and the matching `Args` entry will be used automatically:

| Resource | Minigame Key | Default Args | Description |
|---|---|---|---|
| **ps-ui** | `ps-circle` | `{2, 20}` | Number of circles, time in ms |
| **ps-ui** | `ps-maze` | `{20}` | Time in seconds |
| **ps-ui** | `ps-varhack` | `{2, 3}` | Number of blocks, time in seconds |
| **ps-ui** | `ps-thermite` | `{10, 5, 3}` | Time in seconds, grid size, incorrect blocks |
| **ps-ui** | `ps-scrambler` | `{'numeric', 30, 0}` | Type, time in seconds, mirrored option |
| **memorygame** | `memorygame-thermite` | `{10, 3, 3, 10}` | Correct blocks, incorrect blocks, show time (s), lose time (s) |
| **ran-minigames** | `ran-memorycard` | `{120}` (Computer) / `{360}` (Terminal/Thermite) | Time in seconds |
| **ran-minigames** | `ran-openterminal` | `{}` | No additional arguments |
| **hacking** | `hacking-opengame` | `{15, 4, 1}` | Time in seconds, number of blocks, number of repeats |
| **howdy-hackminigame** | `howdy-begin` | `{3, 5000}` | Number of icons, time in ms |
| **SN-Hacking** | `sn-memorygame` | `{3, 2, 10000}` | Keys needed, number of rounds, time in ms |
| **SN-Hacking** | `sn-skillcheck` | `{50, 5000, {'w','a','s','w'}, 2, 20, 3}` | Speed (ms), time (ms), keys, rounds, bars, safe bars |
| **SN-Hacking** | `sn-thermite` | `{7, 5, 10000, 2, 2, 3000}` | Boxes, correct boxes, time (ms), lives, rounds, show time (ms) |
| **SN-Hacking** | `sn-keypad` | `{999, 3000}` | Code number, time in ms |
| **SN-Hacking** | `sn-colorpicker` | `{3, 7000, 3000}` | Icons, type time (ms), view time (ms) |
| **rm_minigames** | `rm-typinggame` | `{'easy', 20}` | Difficulty, duration in seconds |
| **rm_minigames** | `rm-timedlockpick` | `{200}` | Speed value |
| **rm_minigames** | `rm-timedaction` | `{3}` | Number of locks |
| **rm_minigames** | `rm-quicktimeevent` | `{'easy'}` | Difficulty |
| **rm_minigames** | `rm-combinationlock` | `{'easy'}` | Difficulty |
| **rm_minigames** | `rm-buttonmashing` | `{5, 10}` | Decay rate, increment rate |
| **rm_minigames** | `rm-angledlockpick` | `{'easy'}` | Difficulty |
| **rm_minigames** | `rm-fingerprint` | `{200, 5}` | Time in seconds, number of lives |
| **rm_minigames** | `rm-hotwirehack` | `{10}` | Time in seconds |
| **rm_minigames** | `rm-hackerminigame` | `{5, 3}` | Length, number of lives |
| **rm_minigames** | `rm-safecrack` | `{'easy'}` | Difficulty |

::: tip
You can use a different minigame for each stage. For example, use `hacking-opengame` for computers, `ps-varhack` for terminals, and `ps-thermite` for thermite -- each has independent difficulty tuning via its `Args` entry.
:::

## Drill Settings

Controls item consumption behavior for the deposit box drilling minigame:

```lua
Config.RemoveDrillOnSuccess = false
Config.RemoveDrillChanceSuccess = 15

Config.RemoveDrillOnFail = true
Config.RemoveDrillChanceFail = 15
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.RemoveDrillOnSuccess` | `boolean` | `false` | Remove the drill item after successfully drilling a deposit box |
| `Config.RemoveDrillChanceSuccess` | `number` | `15` | Percentage chance to remove the drill on success |
| `Config.RemoveDrillOnFail` | `boolean` | `true` | Remove the drill item after failing the drilling minigame |
| `Config.RemoveDrillChanceFail` | `number` | `15` | Percentage chance to remove the drill on failure |

## Tray Rewards

Cash trays are spawned in the vault area. Each tray contains money bags or gold bars.

```lua
Config.Rewards = {
    Trays = {
        MaxTrayAmount = 10,
        MinTrayAmount = 9,
        MoneyWorth = { Min = 20000, Max = 30000 },
        MoneyBagAmount = { Min = 1, Max = 2 },
        GoldChance = 35,
        GoldAmount = { Min = 3, Max = 6 },
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `MaxTrayAmount` | `number` | `10` | Maximum number of trays that will spawn. Cannot exceed the number of entries in `Config.Trays` |
| `MinTrayAmount` | `number` | `9` | Minimum number of trays that will spawn |
| `MoneyWorth` | `table` | `{ Min = 20000, Max = 30000 }` | Dollar value range per money tray |
| `MoneyBagAmount` | `table` | `{ Min = 1, Max = 2 }` | Number of money bag items received per tray. Total value = MoneyWorth x MoneyBagAmount |
| `GoldChance` | `number` | `35` | Percentage chance for a tray to contain gold bars instead of cash |
| `GoldAmount` | `table` | `{ Min = 3, Max = 6 }` | Number of gold bars received per gold tray |

::: info
There are 10 tray spawn positions defined in `Config.Trays` -- 4 in the two side rooms, 2 in the main vault, and 4 behind locked doors inside the vault. `MaxTrayAmount` should not exceed 10 unless you add more positions.
:::

## Deposit Box Rewards

Deposit boxes require drilling and yield random loot items. Each box has a set number of loot times (drill attempts available).

```lua
Config.Rewards.DepositBoxes = {
    MinAmountToGive = 2,
    MaxAmountToGive = 5,
    Items = {
        ["diamond"] = { MinAmount = 2, MaxAmount = 3, Chance = 20 },
        ["diamond_ring"] = { MinAmount = 2, MaxAmount = 5, Chance = 25 },
        ["10kgoldchain"] = { MinAmount = 3, MaxAmount = 5, Chance = 25 },
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `MinAmountToGive` | `number` | `2` | Minimum total number of different items given per loot |
| `MaxAmountToGive` | `number` | `5` | Maximum total number of different items given per loot |
| `Items` | `table` | See above | Loot pool with item name as key; each entry has `MinAmount`, `MaxAmount`, and `Chance` (percentage) |

### Default Deposit Box Loot

| Item | Min Amount | Max Amount | Chance |
|---|---|---|---|
| `diamond` | 2 | 3 | 20% |
| `diamond_ring` | 2 | 5 | 25% |
| `10kgoldchain` | 3 | 5 | 25% |

### Deposit Box Locations

There are 6 deposit box locations defined in `Config.DepositBoxes`:

| Box | Area | Loot Times |
|---|---|---|
| 1 | Side Room | 2 |
| 2 | Side Room | 3 |
| 3 | Side Room | 2 |
| 4 | Side Room | 3 |
| 5 | Inside Vault | 5 |
| 6 | Inside Vault | 5 |

::: tip
`LootTimes` controls how many times a deposit box can be drilled during a single heist. Vault boxes have more loot attempts than side room boxes.
:::

## Cash Payout Mode

Controls how cash rewards from trays are distributed to players.

```lua
Config.CashoutType = 'dirty'
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.CashoutType` | `string` | `'dirty'` | Payout mode: `'clean'`, `'dirty'`, or `'custom'` |

| Mode | Behavior |
|---|---|
| `'clean'` | Distributes unmarked (clean) cash directly |
| `'dirty'` | Distributes marked bills with a worth value, or `dirty_money` as 1:1 for ESX |
| `'custom'` | Distributes a custom item as currency (see below) |

### Custom Cash Mode

When `Config.CashoutType` is set to `'custom'`, an additional table becomes available:

```lua
Config.CustomCash = {
    CashItem = 'markedbills',
    CashQuantity = false,
    CashAmount = { min = 1, max = 2 },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `CashItem` | `string` | `'markedbills'` | Item identifier used as currency. Replace with your server's actual item name |
| `CashQuantity` | `boolean` | `false` | `false` = each item represents $1 (quantity determined by `Config.Rewards`). `true` = the number of items given equals `CashAmount`, where each item has its own server-defined worth |
| `CashAmount` | `table` | `{ min = 1, max = 2 }` | Number of `CashItem` given when `CashQuantity = true` |

::: info
If you use base ESX with `dirty_money` where each unit equals $1, use `'dirty'` mode rather than `'custom'`. The `'custom'` mode is intended for servers where a single item (like `markedbills`) represents a larger denomination (e.g. $5,000 each).
:::

## Laser Grid

```lua
Config.EnableLasers = true
Config.LaserResourceName = 'mka-lasers'
Config.CheckForBlackout = false
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.EnableLasers` | `boolean` | `true` | Enable the laser grid system in the vault room |
| `Config.LaserResourceName` | `string` | `'mka-lasers'` | Name of the laser resource. The script checks this resource is running before activating lasers |
| `Config.CheckForBlackout` | `boolean` | `false` | When `true`, if a blackout is active (via qb-weathersync), lasers will not start after the password is entered and thermite doors can be skipped |

::: warning
If `Config.EnableLasers` is `true`, ensure the resource specified in `Config.LaserResourceName` is installed and started on your server. If the resource is not found, lasers will not function.
:::

## Blackout Integration

```lua
Config.CheckForBlackout = false
```

When enabled, the script checks for an active blackout event (using `qb-weathersync`). During a blackout:

- Lasers will **not** activate after the vault password is entered
- Thermite doors can be **skipped** entirely

This provides an alternative heist path that bypasses laser and thermite stages.

## Guards

### Guard Toggle

```lua
Config.EnableGuards = true
Config.EnableLooting = true
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.EnableGuards` | `boolean` | `true` | Spawn NPC guards during the Pacific Bank heist |
| `Config.EnableLooting` | `boolean` | `true` | Allow players to loot dead guards |

### Guard Parameters

```lua
Config.PedParameters = {
    Ped = "s_m_m_security_01",
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
| `Ped` | `string` | `"s_m_m_security_01"` | Ped model used for guards |
| `Health` | `number` | `200` | Maximum and initial health of each guard |
| `Weapon` | `table` | `{"WEAPON_PISTOL", "WEAPON_SMG", "WEAPON_ASSAULTRIFLE"}` | List of weapons guards may carry (randomized per guard) |
| `MinArmor` | `number` | `50` | Minimum armor value a guard can have |
| `MaxArmor` | `number` | `100` | Maximum armor value a guard can have |
| `Headshots` | `boolean` | `true` | Whether guards can suffer critical hits (headshots) |
| `CombatAbility` | `number` | `100` | Combat ability rating (0-100, where 100 is highest) |
| `Accuracy` | `number` | `60` | Shot accuracy (0-100, where 100 is highest) |
| `CombatRange` | `number` | `2` | Combat engagement range: `0` = short, `1` = medium, `2` = long |
| `CombatMovement` | `number` | `2` | Combat movement style: `0` = calm, `1` = normal, `2` = aggressive |
| `CanRagdoll` | `boolean` | `true` | Whether guards can be ragdolled from player impact |

### Guard Spawn Locations

Guards spawn in the vault basement area. There are 10 spawn positions defined in `Config.Guards`:

```lua
Config.Guards = {
    {
        coords = {
            vector4(257.97, 214.94, 97.12, 311.59),
            vector4(255.25, 221.25, 97.12, 252.08),
            vector4(256.72, 224.23, 97.12, 244.81),
            vector4(263.59, 226.21, 97.12, 167.98),
            vector4(249.67, 218.95, 97.12, 327.85),
            vector4(251.46, 230.91, 97.12, 212.82),
            vector4(247.55, 227.88, 97.12, 240.08),
            vector4(246.09, 223.56, 97.12, 260.39),
            vector4(239.18, 220.99, 97.12, 310.68),
            vector4(243.1, 230.39, 97.12, 212.91),
        }
    },
}
```

Each entry is a `vector4` with x, y, z coordinates and heading.

## Guard Loot

When `Config.EnableLooting` is `true`, dead guards can be looted for weapons, ammo, and medical supplies.

```lua
Config.PedRewards = {
    weaponChance = 60,
    itemRange = { min = 2, max = 3 },
    PistolRewards = {
        items = {"weapon_heavypistol", "weapon_pistol", "weapon_pistol_mk2"},
        chance = 37,
        isGunReward = true,
    },
    RareRewards = {
        items = {"weapon_assaultrifle", "weapon_compactrifle", "weapon_mg"},
        chance = 15,
        isGunReward = true,
    },
    SMGRewards = {
        items = {"weapon_assaultsmg", "weapon_minismg", "weapon_combatpdw"},
        chance = 32,
        isGunReward = true,
    },
    ShotgunRewards = {
        items = {"weapon_sawnoffshotgun", "weapon_pumpshotgun", "weapon_dbshotgun"},
        chance = 25,
        isGunReward = true,
    },
    AmmoRewards = {
        items = {"pistol_ammo", "shotgun_ammo", "rifle_ammo", "smg_ammo"},
        chance = 45,
        amount = { min = 1, max = 2 },
    },
    MedicRewards = {
        items = {"bandage"},
        chance = 45,
        amount = { min = 1, max = 2 },
    },
}
```

### Global Loot Settings

| Key | Type | Default | Description |
|---|---|---|---|
| `weaponChance` | `number` | `60` | Overall percentage chance of receiving any gun-related reward from a loot |
| `itemRange` | `table` | `{ min = 2, max = 3 }` | Minimum and maximum number of items a player can receive from each loot |

### Reward Categories

| Category | Items | Chance (Weight) | Gun Reward |
|---|---|---|---|
| `PistolRewards` | weapon_heavypistol, weapon_pistol, weapon_pistol_mk2 | 37 | Yes |
| `RareRewards` | weapon_assaultrifle, weapon_compactrifle, weapon_mg | 15 | Yes |
| `SMGRewards` | weapon_assaultsmg, weapon_minismg, weapon_combatpdw | 32 | Yes |
| `ShotgunRewards` | weapon_sawnoffshotgun, weapon_pumpshotgun, weapon_dbshotgun | 25 | Yes |
| `AmmoRewards` | pistol_ammo, shotgun_ammo, rifle_ammo, smg_ammo | 45 | No |
| `MedicRewards` | bandage | 45 | No |

::: info
The `chance` values are **weights**, not strict percentages -- they indicate relative likelihood compared to other categories. A category with chance 45 is roughly three times as likely to be selected as one with chance 15.
:::

::: warning
Only **one** item from categories marked `isGunReward = true` can be selected per loot. Even if `itemRange` allows 3 items, at most one will be a weapon. Non-gun categories (`AmmoRewards`, `MedicRewards`) can each contribute items independently. To allow multiple weapons per loot, set `isGunReward = false` on additional weapon categories.
:::

### Ammo and Medic Amounts

| Category | Min Amount | Max Amount |
|---|---|---|
| `AmmoRewards` | 1 | 2 |
| `MedicRewards` | 1 | 2 |

## Logging

Logging is configured in `server/logs.lua`. It controls which events are recorded and where logs are sent.

```lua
return {
    logs = {
        service = 'none',
        dataset = 'sd-pacificbank',
        screenshots = false,
        events = {
            tray_loot   = true,
            give_loot   = true,
            reward_ped  = true,
            remove_item = true,
        },
        discord = { ... },
        loki = { ... },
        grafana = { ... },
    },
}
```

### Logging Service

| Key | Type | Default | Description |
|---|---|---|---|
| `service` | `string` | `'none'` | Logging service to use: `'fivemanage'`, `'fivemerr'`, `'discord'`, `'loki'`, `'grafana'`, or `'none'` |
| `dataset` | `string` | `'sd-pacificbank'` | Fivemanage dataset ID (only used when service is `'fivemanage'`) |
| `screenshots` | `boolean` | `false` | Include screenshots with logs (only supported by Fivemanage and Fivemerr) |

### Log Events

| Event | Default | Description |
|---|---|---|
| `tray_loot` | `true` | Log when a player successfully loots a cash tray |
| `give_loot` | `true` | Log when a player takes loot from a deposit box |
| `reward_ped` | `true` | Log when a player receives a guard loot reward |
| `remove_item` | `true` | Log when an item is removed from a player's inventory |

### Discord Webhook

Only used when `service = 'discord'`:

```lua
discord = {
    name   = 'Pacific Bank Logs',
    link   = '',
    image  = '',
    footer = '',
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | `string` | `'Pacific Bank Logs'` | Webhook display name |
| `link` | `string` | `''` | Discord webhook URL |
| `image` | `string` | `''` | Webhook avatar image URL |
| `footer` | `string` | `''` | Webhook footer icon URL |

### Loki

Only used when `service = 'loki'`:

```lua
loki = {
    endpoint = '',
    user     = '',
    password = '',
    tenant   = '',
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `endpoint` | `string` | `''` | Base URL without trailing slash (e.g. `'https://loki.example.com'`) |
| `user` | `string` | `''` | Basic auth username (optional) |
| `password` | `string` | `''` | Basic auth password or API key (optional) |
| `tenant` | `string` | `''` | X-Scope-OrgID header value (optional) |

### Grafana

Only used when `service = 'grafana'`:

```lua
grafana = {
    endpoint = '',
    apiKey   = '',
    tenant   = '',
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `endpoint` | `string` | `''` | Base URL without trailing slash (e.g. `'https://logs-prod.grafana.net'`) |
| `apiKey` | `string` | `''` | Grafana API key (prefixed with `'Bearer '`) |
| `tenant` | `string` | `''` | X-Scope-OrgID header value (optional) |
