# Configuration

All configuration is done in `config.lua`.

## General Settings

```lua
Config.CokeDebug = false
Config.MinimumPolice = 3
Config.PoliceJobs = { 'police', --[['sheriff']] }
Config.RunCost = 100000
Config.Cooldown = 45
Config.SendEmail = false
Config.Interaction = 'target'
Config.EnableAnimation = true
Config.FlareTime = 15
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.CokeDebug` | boolean | `false` | Enable PolyZone debug visualization for testing. Some targeting solutions like ox_target may not display PolyZones. |
| `Config.MinimumPolice` | number | `3` | Minimum police online required to start the run |
| `Config.PoliceJobs` | table | `{ 'police' }` | Array of job names counted toward the police check. Uncomment `'sheriff'` or add others as needed. |
| `Config.RunCost` | number | `100000` | Cash cost to initiate a cocaine run |
| `Config.Cooldown` | number | `45` | Personal cooldown in minutes between runs |
| `Config.SendEmail` | boolean | `false` | Send an email to start the run. Only triggers when `Config.EnableMinigame` is `false`. When the minigame is enabled, the email fires from the minigame regardless of this setting. |
| `Config.Interaction` | string | `'target'` | Interaction mode: `'target'` (qb-target / qtarget / ox_target) or `'textui'` (cd_drawtextui / qb-core / ox_lib textui) |
| `Config.EnableAnimation` | boolean | `true` | Play a talking animation when interacting with the boss ped |
| `Config.FlareTime` | number | `15` | Minutes that flare effects remain burning at cache drop locations |

::: tip
It is recommended to always keep some form of cooldown active to prevent players from running the mission back-to-back.
:::

::: info
If both `Config.SendEmail` and `Config.EnableMinigame` are set to `false`, the run starts immediately with only a notification.
:::

## Sealed Cache System

When `Config.UsingSealedCache` is `true`, players receive sealed cache items from the submerged vehicles instead of direct reward items. Caches must be opened separately and can optionally require a key.

```lua
Config.UsingSealedCache = true

Config.SealedCache = {
    Item = 'sealed_cache',
    RequiresKeyToOpen = true,
    KeyItem = 'cache_key',
    KeyItemChance = 10,
    ChanceToRemoveKey = 35,
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.UsingSealedCache` | boolean | `true` | Enable sealed cache mode. When `false`, reward items drop directly from submerged vehicles. |
| `Config.SealedCache.Item` | string | `'sealed_cache'` | Item name for the sealed cache |
| `Config.SealedCache.RequiresKeyToOpen` | boolean | `true` | Whether the cache requires a key item to open |
| `Config.SealedCache.KeyItem` | string | `'cache_key'` | Item name for the cache key |
| `Config.SealedCache.KeyItemChance` | number | `10` | Percentage chance to receive a key when looting a cache |
| `Config.SealedCache.ChanceToRemoveKey` | number | `35` | Percentage chance the key is consumed when used to open a cache |

::: warning
The `Config.SealedCache` table is only created when `Config.UsingSealedCache` is `true`. Make sure the `sealed_cache` and `cache_key` items exist in your inventory system.
:::

## Rewards

Reward items are given either from each sealed cache or directly from each submerged vehicle, depending on the `Config.UsingSealedCache` setting.

```lua
Config.RewardItems = {
    { item = 'coke_brick' },
    { item = 'weed_brick' },
    -- Add more reward items as needed
}

Config.RewardAmount = 2
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.RewardItems` | table | See above | List of possible reward items. Each entry is a table with an `item` key. |
| `Config.RewardAmount` | number | `2` | Number of reward items given per cache opening or per vehicle looted |

## Phone Booth Minigame

When enabled, players must complete a phone number minigame before the cocaine drop locations are revealed. Players receive phone numbers via email and must visit the correct phone booths in order. Three wrong attempts and the supplier abandons the run.

```lua
Config.EnableMinigame = false
Config.EnableMinigameTimeout = true
Config.MinigameTimeout = 30

Config.PhoneBooths = {
    { x = -1224.1, y = -322.62, z = 37.58, heading = 30.0 },
    { x = -1073.98, y = -397.78, z = 36.96, heading = 30.0 },
    { x = -523.79, y = -299.86, z = 35.35, heading = 30.0 },
    { x = -544.16, y = -157.43, z = 38.54, heading = 30.0 },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.EnableMinigame` | boolean | `false` | Enable the phone number minigame before drops are revealed. When `true`, the email event fires from the minigame regardless of `Config.SendEmail`. |
| `Config.EnableMinigameTimeout` | boolean | `true` | Enable a timeout that clears zones, blips, and variables if the minigame is not completed in time |
| `Config.MinigameTimeout` | number | `30` | Minutes before the minigame times out and resets |
| `Config.PhoneBooths` | table | 4 locations | Coordinates and headings for the phone booth interaction points |

::: tip
Reference `Config.Phone` in `sd_lib/sh_config.lua` and the `SendEmail` utility function in `sd_lib/client/cl_utils.lua` for further customization of the minigame email system.
:::

## Boss Ped

The boss ped is the NPC that players interact with to start a cocaine run. One of the defined locations is chosen at random each time.

```lua
Config.BossPed = 's_m_y_uscg_01'

Config.BossLocation = {
    [1] = vector4(-1201.16, -266.51, 36.92, 44.09),
    [2] = vector4(1087.24, 244.29, 79.99, 324.59),
    [3] = vector4(866.52, -1997.13, 29.26, 264.41),
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.BossPed` | string | `'s_m_y_uscg_01'` | Model name of the boss ped |
| `Config.BossLocation` | table | 3 locations | Possible spawn positions for the boss ped (one is selected at random) |

## Boss Ped Blip

Controls whether a map blip is shown for the boss ped location.

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
| `Config.Blip.Sprite` | number | `480` | Blip icon sprite ID |
| `Config.Blip.Display` | number | `4` | Blip display mode |
| `Config.Blip.Scale` | number | `0.6` | Blip size on the map |
| `Config.Blip.Colour` | number | `1` | Blip color ID |
| `Config.Blip.Name` | string | `'Mysterious Person'` | Label shown on the blip |

## Blackout Mode

When enabled, the cocaine run can only be started during an active power outage.

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.CheckForBlackout` | boolean | `false` | Restrict the mission to blackout periods only |

::: warning
Blackout mode currently only supports `qb-weathersync`. Ensure it is running on your server before enabling this option.
:::

## Boat Spawn

An optional boat can be spawned in the Alamo Sea to assist players in reaching submerged vehicle locations.

```lua
Config.EnableBoat = false
Config.Boatspawn = vector3(2225.68, 4018.5, 36.33)
Config.BoatTimeout = 5
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.EnableBoat` | boolean | `false` | Spawn a boat in the Alamo Sea when the run starts |
| `Config.Boatspawn` | vector3 | `vector3(2225.68, 4018.5, 36.33)` | Coordinates where the boat spawns |
| `Config.BoatTimeout` | number | `5` | Minutes before the boat blip disappears from the map |

## Submerged Vehicles

During a run, vehicles from `Config.CarModels` are spawned at random underwater locations from `Config.CarSpawnList`. Players must dive to these vehicles to retrieve caches or rewards.

```lua
Config.CarModels = {
    'voodoo',
    'virgo3',
    'dukes3',
}

Config.CarSpawnList = {
    vector3(-3426.810, 1700.721, -64.30),
    vector3(-3612.931, 751.214, -50.39),
    vector3(-1297.913, 5799.770, -30.04),
    vector(1406.560, 6937.847, -28.51),
    vector(3546.872, 5780.012, -21.24),
    vector(3836.941, 5153.833, -57.15),
    vector(4231.236, 3950.319, -48.87),
    vector(3251.902, 1360.341, -52.64),
    vector(1647.259, -3111.905, -65.95),
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.CarModels` | table | `'voodoo'`, `'virgo3'`, `'dukes3'` | Vehicle models that can spawn underwater. A random model is chosen for each spawn point. |
| `Config.CarSpawnList` | table | 9 locations | Underwater coordinates where vehicles are placed during a run |

::: info
The spawn locations are spread across the entire map coastline and ocean floor, with depths ranging from roughly -21 to -66 units below the surface.
:::

## Police Dispatch

The `policeAlert` function is called when a cocaine package drop occurs. It uses `SD.PoliceDispatch` and can be customized to fit any dispatch system.

```lua
policeAlert = function()
    SD.PoliceDispatch({
        displayCode = "10-31C",
        title = 'Cocaine Package Drop',
        description = "Mysterious package drop spotted",
        message = "Suspicious activity reported along the shore",
        sprite = 501,
        scale = 1.0,
        colour = 6,
        blipText = "Cocaine Drop",
        dispatchcodename = "cocaine_drop",
    })
end
```

| Key | Type | Default | Description |
|---|---|---|---|
| `displayCode` | string | `"10-31C"` | Dispatch code shown in the alert |
| `title` | string | `'Cocaine Package Drop'` | Alert title (used in cd_dispatch / ps-dispatch) |
| `description` | string | `"Mysterious package drop spotted"` | Short description of the event |
| `message` | string | `"Suspicious activity reported along the shore"` | Additional context message |
| `sprite` | number | `501` | Blip sprite for the dispatch alert |
| `scale` | number | `1.0` | Blip scale on the map |
| `colour` | number | `6` | Blip color on the map |
| `blipText` | string | `"Cocaine Drop"` | Text label for the dispatch blip |
| `dispatchcodename` | string | `"cocaine_drop"` | Code name used by ps-dispatch in `sv_dispatchcodes.lua` or under `Config.Blips` |

::: tip
The blip parameters (`sprite`, `scale`, `colour`, `blipText`) apply to all dispatch systems except ps-dispatch. For ps-dispatch, configure the matching entry using the `dispatchcodename` value in your ps-dispatch config.
:::

## Locale

Change the language by editing the locale line in `config.lua`:

```lua
SD.Locale.LoadLocale('en')  -- Options: 'en', 'de', 'es', 'fr', 'ar'
```
