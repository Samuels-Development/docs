# Configuration

All configuration is done in `config.lua`.

## General Settings

```lua
Config.OxyRunDebug = false
Config.MinimumPolice = 3
Config.PoliceJobs = { 'police', --[['sheriff']] }
Config.RunCost = 500
Config.SendEmail = false
Config.ViewLevel = false
Config.Interaction = 'target'
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.OxyRunDebug` | boolean | `false` | Enable PolyZone debug visualization for testing |
| `Config.MinimumPolice` | number | `3` | Minimum police online required to start a run |
| `Config.PoliceJobs` | table | `{ 'police' }` | Array of job names counted toward the police requirement |
| `Config.RunCost` | number | `500` | Cash cost to start a run |
| `Config.SendEmail` | boolean | `false` | Send an email notification when a job is accepted; if `false`, a standard notification plays instead |
| `Config.ViewLevel` | boolean | `false` | Allow players to view their current level and XP when interacting with the boss ped |
| `Config.Interaction` | string | `'target'` | Interaction mode: `'target'` (qb-target/ox_target) or `'textui'` (drawtext UI) |

## Item Requirements

```lua
Config.CheckForItem = {
    Enable = false,
    Item = "vpn",
    Consume = {
        Enable = false,
        Chance = 50,
    },
}

Config.Items = {
    Package = "package",
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.CheckForItem.Enable` | boolean | `false` | Require an item in the player's inventory before they can start a run |
| `Config.CheckForItem.Item` | string | `"vpn"` | Item name to check for |
| `Config.CheckForItem.Consume.Enable` | boolean | `false` | Whether the required item can be consumed on use |
| `Config.CheckForItem.Consume.Chance` | number | `50` | Percent chance the item is consumed when a run starts |
| `Config.Items.Package` | string | `"package"` | Item given by the supplier and exchanged for oxy |

## Cooldown System

```lua
Config.Cooldown = {
    EnableTimeout = false,
    Timeout = 30,
    BuyerTimeout = 5,
    EnableGlobalCooldown = false,
    GlobalCooldown = 20,
    EnablePersonalCooldown = false,
    PersonalCooldown = 20,
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Cooldown.EnableTimeout` | boolean | `false` | End the run automatically after the timeout elapses |
| `Config.Cooldown.Timeout` | number | `30` | Run timeout in minutes |
| `Config.Cooldown.BuyerTimeout` | number | `5` | Minutes after leaving the selling zone (without re-entering) before the run resets |
| `Config.Cooldown.EnableGlobalCooldown` | boolean | `false` | Enable a server-wide cooldown between runs |
| `Config.Cooldown.GlobalCooldown` | number | `20` | Global cooldown duration in minutes |
| `Config.Cooldown.EnablePersonalCooldown` | boolean | `false` | Enable a per-player cooldown before starting another run |
| `Config.Cooldown.PersonalCooldown` | number | `20` | Personal cooldown duration in minutes |

::: tip
You can combine multiple cooldown types. For example, enable both the global and personal cooldowns to limit how frequently any individual player or the server as a whole can run oxy.
:::

## Money Washing

```lua
Config.MoneyWashing = {
    WashItem = {
        Enable = false,
        Chance = 33,
        ItemName = "",
        MinAmount = 500,
        MaxAmount = 2500,
    },
}

Config.Amount = { Type = 'one', max = 20 }
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.MoneyWashing.WashItem.Enable` | boolean | `false` | Enable item-based money laundering (1:1 ratio, e.g. 1 item = $1) |
| `Config.MoneyWashing.WashItem.Chance` | number | `33` | Percent chance money washing triggers on delivery |
| `Config.MoneyWashing.WashItem.ItemName` | string | `""` | Dirty money item name (set this to your marked-money item) |
| `Config.MoneyWashing.WashItem.MinAmount` | number | `500` | Minimum quantity of the item required to trigger washing |
| `Config.MoneyWashing.WashItem.MaxAmount` | number | `2500` | Maximum quantity that can be laundered in a single wash |
| `Config.Amount.Type` | string | `'one'` | `'one'` for a fixed amount of 1 per delivery, or `'random'` for a random amount up to the player's quantity or `max` |
| `Config.Amount.max` | number | `20` | Upper limit when `Type` is `'random'` (ignored when `Type` is `'one'`) |

::: warning
If `Config.MoneyWashing.WashItem.Enable` is `true`, the per-level `Washing` settings inside `Config.Levels` are overridden. The per-level `Tax` percentage still applies.
:::

::: info
**Example scenario:** A player has 1,000 units of the dirty money item. The script checks whether the player holds at least `MinAmount` (500). If so, a random quantity between `MinAmount` and the lesser of the player's quantity or `MaxAmount` (2,500) is selected for laundering.
:::

## Level Rewards

The levelling system has three tiers. Set `Config.Levels.GiveItem` to `true` to grant item rewards on each delivery, or `false` to use the script solely as a money wash.

```lua
Config.Levels = {
    GiveItem = true,
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Levels.GiveItem` | boolean | `true` | Give the player an item reward on each delivery |

### Level 1

```lua
Config.Levels[1] = {
    XPPerDelivery = 1,
    CallCopsChance = 33,
    ItemReward = { Item = "oxy", Min = 3, Max = 5 },
    Washing = {
        Enable = true,
        Bills = { min = 750, max = 2000, chance = 20 },
        Bands = { min = 750, max = 2000, chance = 15 },
        Rolls = { min = 250, max = 750,  chance = 25 },
    },
    Tax = { Enable = true, Percentage = 25 },
    RareItem = {
        Enable = true, Chance = 5,
        Reward = { Items = { "advancedlockpick", "security_card_01" }, Min = 1, Max = 1 },
    },
    Robbery = {
        Enable = false, Delay = 1000,
        Difficulty = { 'easy', 'medium', 'medium', 'hard' },
        Chance = 25, Inputs = { 'w', 'a', 's', 'd' },
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `XPPerDelivery` | number | `1` | XP gained per package delivered |
| `CallCopsChance` | number | `33` | Percent chance police are alerted on delivery |
| `ItemReward.Item` | string | `"oxy"` | Item rewarded per delivery |
| `ItemReward.Min` | number | `3` | Minimum reward quantity |
| `ItemReward.Max` | number | `5` | Maximum reward quantity |
| `Washing.Enable` | boolean | `true` | Enable money washing at this level |
| `Washing.Bills` | table | `{ min = 750, max = 2000, chance = 20 }` | Marked bills payout range and trigger chance (%) |
| `Washing.Bands` | table | `{ min = 750, max = 2000, chance = 15 }` | Money bands payout range and trigger chance (%) |
| `Washing.Rolls` | table | `{ min = 250, max = 750, chance = 25 }` | Money rolls payout range and trigger chance (%) |
| `Tax.Enable` | boolean | `true` | Enable tax on money washing proceeds |
| `Tax.Percentage` | number | `25` | Tax percentage deducted from washing payouts |
| `RareItem.Enable` | boolean | `true` | Enable rare item drops |
| `RareItem.Chance` | number | `5` | Percent chance of receiving a rare item |
| `RareItem.Reward.Items` | table | `{ "advancedlockpick", "security_card_01" }` | Possible rare items (one is selected at random) |
| `RareItem.Reward.Min` | number | `1` | Minimum rare item quantity |
| `RareItem.Reward.Max` | number | `1` | Maximum rare item quantity |
| `Robbery.Enable` | boolean | `false` | Enable the robbery minigame where the buyer may attempt to steal your package |
| `Robbery.Delay` | number | `1000` | Delay in milliseconds before the minigame starts |
| `Robbery.Difficulty` | table | `{ 'easy', 'medium', 'medium', 'hard' }` | Skill-check difficulties; number of entries = number of checks |
| `Robbery.Chance` | number | `25` | Percent chance a robbery attempt occurs |
| `Robbery.Inputs` | table | `{ 'w', 'a', 's', 'd' }` | Key inputs for the skill check |

::: info
`Washing.Bills` payouts are only applied if the marked bills item does not already carry a `worth` metadata value. If a single `markedbills` item already equals a set dollar amount via metadata, that value is used instead.
:::

### Level 2

```lua
Config.Levels[2] = {
    XPThreshold = 150,
    XPPerDelivery = 1,
    CallCopsChance = 25,
    ItemReward = { Item = "oxy", Min = 5, Max = 7 },
    Washing = {
        Enable = true,
        Bills = { min = 750, max = 2000, chance = 25 },
        Bands = { min = 750, max = 2000, chance = 20 },
        Rolls = { min = 250, max = 750,  chance = 40 },
    },
    Tax = { Enable = true, Percentage = 15 },
    RareItem = {
        Enable = true, Chance = 8,
        Reward = { Items = { "advancedlockpick", "security_card_02" }, Min = 1, Max = 1 },
    },
    Robbery = {
        Enable = false, Delay = 1000,
        Difficulty = { 'easy', 'medium', 'medium' },
        Chance = 18, Inputs = { 'w', 'a', 's', 'd' },
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `XPThreshold` | number | `150` | XP required to reach Level 2 |
| `XPPerDelivery` | number | `1` | XP gained per package delivered |
| `CallCopsChance` | number | `25` | Percent chance police are alerted on delivery |
| `ItemReward.Item` | string | `"oxy"` | Item rewarded per delivery |
| `ItemReward.Min` | number | `5` | Minimum reward quantity |
| `ItemReward.Max` | number | `7` | Maximum reward quantity |
| `Washing.Bills` | table | `{ min = 750, max = 2000, chance = 25 }` | Marked bills payout range and trigger chance (%) |
| `Washing.Bands` | table | `{ min = 750, max = 2000, chance = 20 }` | Money bands payout range and trigger chance (%) |
| `Washing.Rolls` | table | `{ min = 250, max = 750, chance = 40 }` | Money rolls payout range and trigger chance (%) |
| `Tax.Enable` | boolean | `true` | Enable tax on money washing proceeds |
| `Tax.Percentage` | number | `15` | Tax percentage deducted from washing payouts |
| `RareItem.Chance` | number | `8` | Percent chance of receiving a rare item |
| `RareItem.Reward.Items` | table | `{ "advancedlockpick", "security_card_02" }` | Possible rare items |
| `Robbery.Difficulty` | table | `{ 'easy', 'medium', 'medium' }` | Skill-check difficulties (3 checks) |
| `Robbery.Chance` | number | `18` | Percent chance a robbery attempt occurs |

### Level 3

```lua
Config.Levels[3] = {
    XPThreshold = 300,
    XPPerDelivery = 1,
    CallCopsChance = 10,
    ItemReward = { Item = "oxy", Min = 7, Max = 10 },
    Washing = {
        Enable = true,
        Bills = { min = 750, max = 2000, chance = 40 },
        Bands = { min = 750, max = 2000, chance = 45 },
        Rolls = { min = 250, max = 750,  chance = 55 },
    },
    Tax = { Enable = false, Percentage = 0 },
    RareItem = {
        Enable = true, Chance = 12,
        Reward = { Items = { "security_card_oil", "security_card_02" }, Min = 1, Max = 1 },
    },
    Robbery = {
        Enable = false, Delay = 1500,
        Difficulty = { 'easy', 'easy', 'easy' },
        Chance = 7, Inputs = { 'w', 'a', 's', 'd' },
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `XPThreshold` | number | `300` | XP required to reach Level 3 |
| `XPPerDelivery` | number | `1` | XP gained per package delivered |
| `CallCopsChance` | number | `10` | Percent chance police are alerted on delivery |
| `ItemReward.Item` | string | `"oxy"` | Item rewarded per delivery |
| `ItemReward.Min` | number | `7` | Minimum reward quantity |
| `ItemReward.Max` | number | `10` | Maximum reward quantity |
| `Washing.Bills` | table | `{ min = 750, max = 2000, chance = 40 }` | Marked bills payout range and trigger chance (%) |
| `Washing.Bands` | table | `{ min = 750, max = 2000, chance = 45 }` | Money bands payout range and trigger chance (%) |
| `Washing.Rolls` | table | `{ min = 250, max = 750, chance = 55 }` | Money rolls payout range and trigger chance (%) |
| `Tax.Enable` | boolean | `false` | Tax is disabled at Level 3 |
| `Tax.Percentage` | number | `0` | No tax deducted |
| `RareItem.Chance` | number | `12` | Percent chance of receiving a rare item |
| `RareItem.Reward.Items` | table | `{ "security_card_oil", "security_card_02" }` | Possible rare items |
| `Robbery.Delay` | number | `1500` | Delay in milliseconds before the minigame starts |
| `Robbery.Difficulty` | table | `{ 'easy', 'easy', 'easy' }` | Skill-check difficulties (3 easy checks) |
| `Robbery.Chance` | number | `7` | Percent chance a robbery attempt occurs |

::: tip
As players progress through levels, they receive more oxy per delivery, face lower police alert chances, pay less tax, and have a higher chance of rare item drops. Customize these values to fit your server's economy.
:::

### Level Comparison

| Attribute | Level 1 | Level 2 | Level 3 |
|---|---|---|---|
| XP Threshold | -- | 150 | 300 |
| XP Per Delivery | 1 | 1 | 1 |
| Police Alert Chance | 33% | 25% | 10% |
| Oxy Reward | 3-5 | 5-7 | 7-10 |
| Tax | 25% | 15% | 0% |
| Rare Item Chance | 5% | 8% | 12% |
| Robbery Chance | 25% | 18% | 7% |

## Supplier

```lua
Config.Supplier = {
    Roaming = false,
    Peds = {
        'a_m_y_skater_01', 'a_m_y_vinewood_03', 'a_m_y_soucent_02',
        'a_m_y_soucent_03', 'a_m_y_methhead_01', 'a_m_m_eastsa_01',
        'a_m_m_genfat_01', 'a_m_m_mexlabor_01',
    },
    Locations = { ... }, -- 13 vector4 coordinates
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Supplier.Roaming` | boolean | `false` | If `true`, the supplier gives one package at a time and moves to a new location for each pickup. If `false`, a single supplier location is chosen and all packages are collected there. |
| `Config.Supplier.Peds` | table | 8 models | Ped models that can spawn as the supplier |
| `Config.Supplier.Locations` | table | 13 coordinates | Possible supplier spawn locations |

## Delivery Settings

```lua
Config.DriveStyle = 39
Config.Deliveries = { Min = 4, Max = 6 }
Config.TimeBetweenCars = { Min = 15, Max = 30 }
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.DriveStyle` | number | `39` | NPC driving style flag ([reference](https://www.vespura.com/fivem/drivingstyle/)) |
| `Config.Deliveries.Min` | number | `4` | Minimum number of deliveries per run |
| `Config.Deliveries.Max` | number | `6` | Maximum number of deliveries per run |
| `Config.TimeBetweenCars.Min` | number | `15` | Minimum seconds between buyer vehicle arrivals |
| `Config.TimeBetweenCars.Max` | number | `30` | Maximum seconds between buyer vehicle arrivals |

## Vehicles & Drivers

```lua
Config.Cars = {
    "glendale", "ingot", "buccaneer2", "dominator", "dukes",
    "ruiner", "tampa", "futo", "brioso", "rocoto",
    "serrano", "buffalo", "exemplar", "felon",
}

Config.DriverPed = {
    "s_m_m_gentransport", "a_m_m_eastsa_01", "s_m_m_trucker_01",
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Cars` | table | 14 models | Vehicle models used for buyer deliveries (randomly selected) |
| `Config.DriverPed` | table | 3 models | Ped models for the driver NPC |

## Boss NPC

```lua
Config.Ped = {
    Location = {
        { x = -1563.99, y = -441.44, z = 35.89, w = 101.3 },
        { x = 569.92, y = -1016.13, z = 32.56, w = 104.47 },
        { x = 683.48, y = -789.34, z = 23.5, w = 0.13 },
    },
    Model = "a_m_m_mlcrisis_01",
    Interaction = {
        Icon = "fas fa-circle",
        Distance = 3.0,
    },
    Scenario = "WORLD_HUMAN_STAND_IMPATIENT",
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Ped.Location` | table | 3 locations | Boss ped spawn locations (one is chosen at random on script start) |
| `Config.Ped.Model` | string | `"a_m_m_mlcrisis_01"` | Ped model for the boss NPC |
| `Config.Ped.Interaction.Icon` | string | `"fas fa-circle"` | Target interaction icon |
| `Config.Ped.Interaction.Distance` | number | `3.0` | Interaction distance in game units |
| `Config.Ped.Scenario` | string | `"WORLD_HUMAN_STAND_IMPATIENT"` | Idle animation scenario ([full list](https://pastebin.com/6mrYTdQv)) |

::: tip
Add more entries to `Config.Ped.Location` to increase randomization of the boss ped's position each time the script starts.
:::

## Blips

```lua
Config.Blip = {
    Enable = false,
    Sprite = 480,
    Display = 4,
    Scale = 0.6,
    Colour = 1,
    Name = "Mysterious Person",
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Blip.Enable` | boolean | `false` | Show a blip on the map for the boss ped |
| `Config.Blip.Sprite` | number | `480` | Blip icon sprite |
| `Config.Blip.Display` | number | `4` | Blip display type |
| `Config.Blip.Scale` | number | `0.6` | Blip size on the map |
| `Config.Blip.Colour` | number | `1` | Blip color |
| `Config.Blip.Name` | string | `"Mysterious Person"` | Blip label text |

## Police Dispatch

The `policeAlert` function is called whenever police are meant to be notified. It uses `SD.PoliceDispatch` and can be customized freely:

```lua
policeAlert = function()
    SD.PoliceDispatch({
        displayCode = "10-95",
        title = 'Suspicious handoff',
        description = "Suspicious handoff reported",
        message = "Potential drug deal in progress",
        sprite = 51,
        scale = 1.0,
        colour = 1,
        blipText = "Suspicious handoff",
        dispatchcodename = "oxy_run",  -- ps-dispatch code name
    })
end
```

::: info
The `dispatchcodename` field is used by ps-dispatch users. Reference the `sv_dispatchcodes.lua` or `config.lua` under the `Config.Blips` entry in ps-dispatch (depending on version) and add an `oxy_run` entry there.
:::

## Minigame Configuration

The minigame is triggered during robbery attempts (see `Config.Levels[i].Robbery`). The active minigame is set by `Config.Minigame.Minigame`, and its arguments are read from the matching key in `Config.Minigame.Args`.

```lua
Config.Minigame = {
    Minigame = 'lib.skillCheck',
    Args = {
        ['lib.skillCheck'] = {
            { 'easy', 'medium', { areaSize = 40, speedMultiplier = 1.2 } },
            { 'w', 'a', 's', 'd' },
        },
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.Minigame.Minigame` | string | `'lib.skillCheck'` | Active minigame resource name |
| `Config.Minigame.Args` | table | see below | Arguments table keyed by minigame name |

The following minigames are supported out of the box. Set `Config.Minigame.Minigame` to any key below and its matching `Args` entry will be used:

| Minigame | Default Args | Description |
|---|---|---|
| `ps-circle` | `{2, 10}` | Number of circles, time in ms |
| `ps-maze` | `{20}` | Time in seconds |
| `ps-varhack` | `{2, 3}` | Number of blocks, time in seconds |
| `ps-thermite` | `{10, 5, 3}` | Time in seconds, grid size, incorrect blocks |
| `ps-scrambler` | `{'numeric', 30, 0}` | Type, time in seconds, mirrored option |
| `memorygame-thermite` | `{10, 3, 3, 10}` | Correct blocks, incorrect blocks, show time (s), lose time (s) |
| `ran-memorycard` | `{360}` | Time in seconds |
| `ran-openterminal` | `{}` | No additional arguments |
| `hacking-opengame` | `{15, 4, 1}` | Time in seconds, number of blocks, repeats |
| `howdy-begin` | `{3, 5000}` | Number of icons, time in ms |
| `sn-memorygame` | `{3, 2, 10000}` | Keys needed, rounds, time in ms |
| `sn-skillcheck` | `{50, 5000, {'w','a','s','w'}, 2, 20, 3}` | Speed (ms), time (ms), keys, rounds, bars, safe bars |
| `sn-thermite` | `{7, 5, 10000, 2, 2, 3000}` | Boxes, correct boxes, time (ms), lives, rounds, show time (ms) |
| `sn-keypad` | `{999, 3000}` | Code number, time in ms |
| `sn-colorpicker` | `{3, 7000, 3000}` | Icons, type time (ms), view time (ms) |
| `rm-typinggame` | `{'easy', 20}` | Difficulty, duration in seconds |
| `rm-timedlockpick` | `{200}` | Speed value |
| `rm-timedaction` | `{3}` | Number of locks |
| `rm-quicktimeevent` | `{'easy'}` | Difficulty |
| `rm-combinationlock` | `{'easy'}` | Difficulty |
| `rm-buttonmashing` | `{5, 10}` | Decay rate, increment rate |
| `rm-angledlockpick` | `{'easy'}` | Difficulty |
| `rm-fingerprint` | `{200, 5}` | Time in seconds, number of lives |
| `rm-hotwirehack` | `{10}` | Time in seconds |
| `rm-hackerminigame` | `{5, 3}` | Length, number of lives |
| `rm-safecrack` | `{'easy'}` | Difficulty |
| `lib.skillCheck` | `{{'easy','medium',{areaSize=40,speedMultiplier=1.2}}, {'w','a','s','d'}}` | Preset/custom difficulties, key inputs |

::: tip
You can also use custom difficulty objects in `Config.Levels[i].Robbery.Difficulty` instead of preset strings:
```lua
{
    areaSize = 35,
    speedMultiplier = 1.25,
}
```
:::

## Routes

Routes are defined per level in `Config.Routes`. Each route contains a spawn point, a delivery (stop) point, and a despawn point. Routes are occupied exclusively per player to prevent overlapping.

```lua
Config.Routes = {
    [1] = { -- Level 1: 7 routes
        {
            info = {
                occupied = false,
                hash = "",              -- Internal; do not modify
                startHeading = 121.76,  -- Vehicle heading at spawn
            },
            locations = {
                { pos = vector3(-691.34, -1058.22, 14.5), stop = false },  -- Spawn
                { pos = vector3(-742.16, -1047.58, 12.3), stop = true },   -- Delivery
                { pos = vector3(-745.23, -915.48, 19.34), stop = false },  -- Despawn
            },
        },
        -- ... 6 more routes
    },
    [2] = { ... }, -- Level 2: 8 routes
    [3] = { ... }, -- Level 3: 8 routes
}
```

| Level | Route Count | Description |
|---|---|---|
| Level 1 | 7 | City-area routes |
| Level 2 | 8 | Expanded routes including Paleto Bay and Kortz Center |
| Level 3 | 8 | Spread across the full map including Vinewood, Globe Oil, and the university |

::: warning
Do not modify the `hash` field inside route `info` tables -- it is managed internally by the script.
:::

## Locale

Change the language by editing line 2 of `config.lua`:

```lua
SD.Locale.LoadLocale('en')  -- Options: 'en', 'de', 'es', 'fr', 'ar'
```
