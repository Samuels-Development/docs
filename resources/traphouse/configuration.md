# Configuration

All configuration is done in `config.lua` in the resource root. Logging settings are in `server/logs.lua`.

## Locale

```lua
SD.Locale.LoadLocale('en')
```

Sets the language for all translations. Change `'en'` to any language code that has a matching file in the `locales/` folder (e.g. `'de'`, `'es'`, `'fr'`, `'ar'`).

## General Settings

```lua
Config.TraphouseDebug = false
Config.MinimumCops = 3
Config.PoliceJobs = { 'police', --[['sheriff']] }
Config.Cooldown = 60
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.TraphouseDebug` | `boolean` | `false` | Enable PolyZone debug visualization for testing. Some targeting solutions (e.g. ox_target) may not display PolyZones |
| `Config.MinimumCops` | `number` | `3` | Minimum police officers online to allow the robbery to start |
| `Config.PoliceJobs` | `table` | `{'police'}` | Array of job names that count toward the police check. Uncomment `'sheriff'` or add other jobs as needed |
| `Config.Cooldown` | `number` | `60` | Global cooldown between robberies in minutes |

## Items

```lua
Config.Items = {
    FrontDoor = { Name = 'gang-keychain', Chance = 100 },
    Vault     = { Name = 'safecracker',   Chance = 100 },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `FrontDoor.Name` | `string` | `'gang-keychain'` | Item required to enter through the front door |
| `FrontDoor.Chance` | `number` | `100` | Percentage chance (0-100) that the item is removed from inventory when used |
| `Vault.Name` | `string` | `'safecracker'` | Item required to open the vault |
| `Vault.Chance` | `number` | `100` | Percentage chance (0-100) that the item is removed from inventory when used |

::: tip
Set `Chance` to a value below 100 to allow the item to be reused. For example, `Chance = 50` gives a 50 % chance of removal on each use.
:::

## Blip

```lua
Config.Blip = {
    Enable = false,
    Coordinates = vector3(505.84, -1817.38, 28.90),
    Sprite = 40,
    Display = 4,
    Scale = 0.6,
    Colour = 1,
    Name = "Vagos Traphouse",
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Enable` | `boolean` | `false` | Show a blip on the map for the traphouse |
| `Coordinates` | `vector3` | `505.84, -1817.38, 28.90` | World position of the blip |
| `Sprite` | `number` | `40` | Blip icon sprite ID |
| `Display` | `number` | `4` | Blip display mode |
| `Scale` | `number` | `0.6` | Size of the blip on the map |
| `Colour` | `number` | `1` | Colour of the blip (1 = red) |
| `Name` | `string` | `'Vagos Traphouse'` | Text label shown on the map |

## Police Alert

```lua
policeAlert = function()
    SD.PoliceDispatch({
        displayCode = "10-31H",
        title = 'Traphouse Robbery',
        description = "Traphouse Robbery in progress",
        message = "Suspects reported entering a traphouse.",
        sprite = 310,
        scale = 1.0,
        colour = 1,
        blipText = "Traphouse Robbery",
        dispatchcodename = "traphouse_robbery"
    })
end
```

| Key | Type | Default | Description |
|---|---|---|---|
| `displayCode` | `string` | `'10-31H'` | Dispatch code shown in the alert |
| `title` | `string` | `'Traphouse Robbery'` | Alert title (used by cd_dispatch / ps-dispatch) |
| `description` | `string` | `'Traphouse Robbery in progress'` | Description of the heist |
| `message` | `string` | `'Suspects reported entering a traphouse.'` | Additional information text |
| `sprite` | `number` | `310` | Blip sprite for the dispatch alert |
| `scale` | `number` | `1.0` | Size of the dispatch blip on the map |
| `colour` | `number` | `1` | Colour of the dispatch blip |
| `blipText` | `string` | `'Traphouse Robbery'` | Text shown on the dispatch blip |
| `dispatchcodename` | `string` | `'traphouse_robbery'` | Code name used by ps-dispatch in `sv_dispatchcodes.lua` or its config |

::: info
The `policeAlert` function is called when police should be notified. You can replace the entire body with your own dispatch logic if needed.
:::

## Point Detection Area

```lua
Config.Point = {
    coords = vector3(505.84, -1817.38, 28.90),
    distance = 15.0,
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `coords` | `vector3` | `505.84, -1817.38, 28.90` | Approximate center of the traphouse building |
| `distance` | `number` | `15.0` | Effective detection radius around the center point |

## Model Hiding

Props listed here are hidden inside the traphouse so they do not overlap with the custom loot props.

```lua
Config.ModelsToHide = {
    -98167313,
    'p_watch_06',
    'ex_prop_exec_cashpile',
    'ex_cash_roll_01',
    'bkr_prop_bkr_cashpile_01',
    'ex_cash_pile_01',
    'ba_prop_battle_laptop_dj',
    'prop_cash_case_02',
    'prop_drug_package_02',
    'prop_gold_bar',
    'prop_cash_pile_02',
    'prop_cs_cashenvelope'
}
```

::: tip
Add or remove model hashes / names here if your MLO has additional props that conflict with the robbery objects. Comment a line out (prefix with `--`) to keep the original prop visible.
:::

## Hacking Minigames

Three separate minigame stages can be configured independently: **Front Door**, **Objects** (in-room loot), and **Vault**. Each stage has the same structure.

```lua
Config.Hacking = {
    FrontDoor = {
        Enable = true,
        Minigame = 'ps-circle',
        Args = { ... },
    },
    Object = {
        Enable = true,
        Minigame = 'ps-circle',
        Args = { ... },
    },
    Vault = {
        Enable = true,
        Minigame = 'hacking-opengame',
        Args = { ... },
    },
}
```

| Key | Type | Default (FrontDoor) | Default (Object) | Default (Vault) | Description |
|---|---|---|---|---|---|
| `Enable` | `boolean` | `true` | `true` | `true` | Enable or disable the minigame for this stage |
| `Minigame` | `string` | `'ps-circle'` | `'ps-circle'` | `'hacking-opengame'` | Which minigame to use (see supported list below) |
| `Args` | `table` | *(per-minigame)* | *(per-minigame)* | *(per-minigame)* | Arguments table keyed by minigame name; only the selected minigame's args are read |

Set `Minigame` to any key from the `Args` table. The matching entry supplies the parameters for that minigame.

### Supported Minigames

#### ps_ui Minigames

| Minigame | Default Args | Parameters |
|---|---|---|
| `ps-circle` | `{2, 20}` | Number of circles, Time (ms) |
| `ps-maze` | `{20}` | Time (s) |
| `ps-varhack` | `{2, 3}` | Number of blocks, Time (s) |
| `ps-thermite` | `{10, 5, 3}` | Time (s), Grid size, Incorrect blocks |
| `ps-scrambler` | `{'numeric', 30, 0}` | Type, Time (s), Mirrored option |

#### Standalone

| Minigame | Default Args | Parameters |
|---|---|---|
| `memorygame-thermite` | `{10, 3, 3, 10}` | Correct blocks, Incorrect blocks, Show time (s), Lose time (s) |

#### Ran Minigames

| Minigame | Default Args | Parameters |
|---|---|---|
| `ran-memorycard` | `{360}` | Time (s) |
| `ran-openterminal` | `{}` | No additional arguments |

#### NoPixel Hacking

| Minigame | Default Args | Parameters |
|---|---|---|
| `hacking-opengame` | `{15, 4, 1}` | Time (s), Number of blocks, Number of repeats |

#### Howdy Minigame

| Minigame | Default Args | Parameters |
|---|---|---|
| `howdy-begin` | `{3, 5000}` | Number of icons, Time (ms) |

#### SN Minigames

| Minigame | Default Args | Parameters |
|---|---|---|
| `sn-memorygame` | `{3, 2, 10000}` | Keys needed, Number of rounds, Time (ms) |
| `sn-skillcheck` | `{50, 5000, {'w','a','s','w'}, 2, 20, 3}` | Speed (ms), Time (ms), Keys, Rounds, Bars, Safe bars |
| `sn-thermite` | `{7, 5, 10000, 2, 2, 3000}` | Boxes, Correct boxes, Time (ms), Lives, Rounds, Show time (ms) |
| `sn-keypad` | `{999, 3000}` | Code number, Time (ms) |
| `sn-colorpicker` | `{3, 7000, 3000}` | Icons, Type time (ms), View time (ms) |

#### Rainmad (rm_) Minigames

| Minigame | Default Args | Parameters |
|---|---|---|
| `rm-typinggame` | `{'easy', 20}` | Difficulty, Duration (s) |
| `rm-timedlockpick` | `{200}` | Speed value |
| `rm-timedaction` | `{3}` | Number of locks |
| `rm-quicktimeevent` | `{'easy'}` | Difficulty |
| `rm-combinationlock` | `{'easy'}` | Difficulty |
| `rm-buttonmashing` | `{5, 10}` | Decay rate, Increment rate |
| `rm-angledlockpick` | `{'easy'}` | Difficulty |
| `rm-fingerprint` | `{200, 5}` | Time (s), Number of lives |
| `rm-hotwirehack` | `{10}` | Time (s) |
| `rm-hackerminigame` | `{5, 3}` | Length, Number of lives |
| `rm-safecrack` | `{'easy'}` | Difficulty |

#### ox_lib

::: v-pre
| Minigame | Default Args | Parameters |
|---|---|---|
| `lib.skillCheck` | `{{'easy','medium',{areaSize=40,speedMultiplier=1.2}}, {'w','a','s','d'}}` | Difficulty presets / custom config, Input keys |
:::

::: warning
If you use `lib.skillCheck`, you must add `ox_lib` to this resource's imports / dependencies.
:::

#### bl_ui Minigames

| Minigame | Default Args | Parameters |
|---|---|---|
| `bl-circlesum` | `{3, {length=4, duration=5000}}` | Iterations, {length, duration} |
| `bl-digitdazzle` | `{3, {length=4, duration=5000}}` | Iterations, {length, duration} |
| `bl-lightsout` | `{3, {level=2, duration=5000}}` | Iterations, {level, duration} |
| `bl-minesweeper` | `{3, {grid=4, duration=10000, target=4, previewDuration=2000}}` | Iterations, {grid, duration, target, previewDuration} |
| `bl-pathfind` | `{3, {numberOfNodes=10, duration=5000}}` | Iterations, {numberOfNodes, duration} |
| `bl-printlock` | `{3, {grid=4, duration=5000, target=4}}` | Iterations, {grid, duration, target} |
| `bl-untangle` | `{3, {numberOfNodes=10, duration=5000}}` | Iterations, {numberOfNodes, duration} |
| `bl-wavematch` | `{3, {duration=5000}}` | Iterations, {duration} |
| `bl-wordwiz` | `{3, {length=4, duration=5000}}` | Iterations, {length, duration} |

#### Glitch Minigames

::: v-pre
| Minigame | Default Args | Parameters |
|---|---|---|
| `gl-firewall-pulse` | `{3, 2, 10, 10, 40, 120, 10}` | requiredHacks, initialSpeed, maxSpeed, timeLimit (s), safeZoneMinWidth (px), safeZoneMaxWidth (px), safeZoneShrinkAmount (px) |
| `gl-backdoor-sequence` | `{3, 5, 15, 3, 1.0, 1, 3, {...}, "..."}` | requiredSeq, seqLength, timeLimit (s), maxAttempts, timePenalty (s), minSimKeys, maxSimKeys, customKeys, keyHintText |
| `gl-circuit-rhythm` | `{4, {'A','S','D','F'}, 150, 1000, 20, 'normal', 5, 3}` | lanes, keys, noteSpeed, noteSpawnRate (ms), requiredNotes, difficulty, maxWrongKeys, maxMissedNotes |
| `gl-surge-override` | `{{'E'}, 50, 2, false, {{'E','F'},{'SPACE','B'}}}` | possibleKeys, requiredPresses, decayRate, multiKeyMode, keyCombinations |
| `gl-circuit-breaker` | `{1, 0, 1000, 5000, 5000, 0, 0, 3000, 30000}` | levelNumber, difficultyLevel, delayStart (ms), minFailDelay (ms), maxFailDelay (ms), disconnectChance, disconnectChanceRate, minReconnectTime (ms), maxReconnectTime (ms) |
| `gl-data-crack` | `{3}` | difficulty |
| `gl-brute-force` | `{}` | No arguments (default numLives = 5) |
| `gl-var-hack` | `{5, 5}` | blocks, speed (s) |
:::

## Props

22 lootable props are defined in `Config.Props`. Each entry controls what spawns inside the traphouse and what the player receives when interacting with it.

```lua
Config.Props = {
    [1] = {
        model = 'bkr_prop_money_wrapped_01',
        coords = vector4(505.10, -1813.70, 28.81, -110.00),
        rotation = vector3(0.0, 0.0, 0.0),
        item = {name = 'money_wrapped', min = 400, max = 1000},
        label = locale('objects.grab_money'),
        money = true,
        taken = false,
        networkID = 0,
    },
    -- ... 21 more entries
}
```

### Prop Entry Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `model` | `string` | Yes | GTA V model name or hash for the prop |
| `coords` | `vector4` | Yes | World position and heading of the prop |
| `rotation` | `vector3` | Yes | Rotation offset applied to the prop |
| `item` | `table` | Yes (unless vault) | `{name, min, max}` -- reward item name and random amount range |
| `label` | `string` | Yes | Locale key used for the interaction prompt |
| `money` | `boolean` | No | If `true`, the `item.name` amount is given as cash instead of an inventory item |
| `vault` | `boolean` | No | If `true`, this prop is the vault door (no item, triggers the vault hack) |
| `distance` | `number` | No | Custom interact / target distance override |
| `adjustX` | `number` | No | Fine-tune the interaction zone X offset |
| `adjustY` | `number` | No | Fine-tune the interaction zone Y offset |
| `adjustZ` | `number` | No | Fine-tune the interaction zone Z offset (height) |
| `taken` | `boolean` | Internal | Tracks whether the prop has been looted this cycle (always set to `false`) |
| `networkID` | `number` | Internal | Network entity ID, managed at runtime (always set to `0`) |

### Default Prop List

| # | Model | Item | Amount | Money | Label Key |
|---|---|---|---|---|---|
| 1 | `bkr_prop_money_wrapped_01` | `money_wrapped` | 400 - 1000 | Yes | `objects.grab_money` |
| 2 | `prop_drug_package_02` | `coke_brick` | 1 - 3 | No | `objects.grab_package` |
| 3 | `w_sb_microsmg` | `weapon_microsmg` | 1 | No | `objects.grab_weapon` |
| 4 | `xm3_prop_xm3_bag_coke_01a` | `cokebaggy` | 4 - 6 | No | `objects.grab_coke_baggy` |
| 5 | `xm3_prop_xm3_bag_coke_01a` | `cokebaggy` | 4 - 6 | No | `objects.grab_coke_baggy` |
| 6 | `xm3_prop_xm3_bag_coke_01a` | `cokebaggy` | 4 - 6 | No | `objects.grab_coke_baggy` |
| 7 | `h4_prop_h4_safe_01a` | *(vault)* | -- | -- | `objects.crack_open_vault` |
| 8 | `prop_cs_documents_01` | `yachtcodes` | 1 | No | `objects.grab_document` |
| 9 | `bkr_prop_coke_cutblock_01` | `coke_brick` | 1 - 2 | No | `objects.grab_coke_brick` |
| 10 | `prop_cs_cashenvelope` | `cash` | 1000 - 5000 | Yes | `objects.grab_cash` |
| 11 | `hei_prop_drug_statue_box_01` | `statue_box` | 1 | No | `objects.grab_statue` |
| 12 | `ch_prop_gold_bar_01a` | `goldbar` | 3 - 5 | No | `objects.grab_gold` |
| 13 | `prop_drug_package_02` | `coke_brick` | 1 - 3 | No | `objects.grab_package` |
| 14 | `bkr_prop_coke_cutblock_01` | `coke_brick` | 1 - 2 | No | `objects.grab_coke_brick` |
| 15 | `w_pi_pistol50` | `weapon_pistol50` | 1 | No | `objects.grab_weapon` |
| 16 | `ch_prop_gold_bar_01a` | `goldbar` | 1 - 3 | No | `objects.grab_gold_bar` |
| 17 | `p_watch_06` | `rolex` | 1 | No | `objects.grab_watch` |
| 18 | `prop_cash_pile_02` | `cash` | 400 - 1000 | Yes | `objects.grab_cash` |
| 19 | `prop_cash_pile_02` | `cash` | 400 - 1000 | Yes | `objects.grab_cash` |
| 20 | `w_me_bat` | `weapon_bat` | 1 | No | `objects.grab_bat` |
| 21 | `p_watch_06` | `rolex` | 1 | No | `objects.grab_watch` |
| 22 | `h4_prop_h4_cash_stack_02a` | `cash` | 1000 - 3000 | Yes | `objects.grab_money` |

::: info
Prop 7 is the vault door. It does not give an item directly -- instead it triggers the vault hacking minigame. Vault rewards are determined by additional props placed inside.
:::

## Vault

The vault is prop **#7** (`h4_prop_h4_safe_01a`). It uses its own hacking minigame (`Config.Hacking.Vault`) and requires the vault item (`Config.Items.Vault`).

```lua
[7] = {
    model = 'h4_prop_h4_safe_01a',
    coords = vector4(506.83, -1813.82, 27.90, 20.00),
    rotation = vector3(0.0, 0.0, 0.0),
    distance = 1.0,
    label = locale('objects.crack_open_vault'),
    adjustZ = 0.9,
    vault = true,
    taken = false,
    networkID = 0,
},
```

Props **8 - 12** are positioned inside or near the vault area and serve as the vault loot (documents, coke bricks, gold bars, statue box, cash envelope).

## Guards

### Enabling Guards

```lua
Config.EnableGuards = true
Config.EnableLooting = true
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.EnableGuards` | `boolean` | `true` | Spawn NPC guards inside the traphouse |
| `Config.EnableLooting` | `boolean` | `true` | Allow players to loot dead guards for rewards |

### Ped Parameters

```lua
Config.PedParameters = {
    Ped = {"csb_ballasog", "g_m_y_ballasout_01", "g_f_y_ballas_01", "ig_ballasog"},
    Health = 300,
    Weapon = {"WEAPON_PISTOL", "WEAPON_SMG"},
    MinArmor = 50,
    MaxArmor = 100,
    Headshots = false,
    CombatAbility = 100,
    Accuracy = 60,
    CombatRange = 2,
    CombatMovement = 2,
    CanRagdoll = true,
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Ped` | `table` | `{"csb_ballasog", "g_m_y_ballasout_01", "g_f_y_ballas_01", "ig_ballasog"}` | List of ped models, chosen randomly per guard |
| `Health` | `number` | `300` | Maximum and initial health of each guard |
| `Weapon` | `table` | `{"WEAPON_PISTOL", "WEAPON_SMG"}` | Possible weapons, assigned randomly per guard |
| `MinArmor` | `number` | `50` | Minimum armor value a guard can spawn with |
| `MaxArmor` | `number` | `100` | Maximum armor value a guard can spawn with |
| `Headshots` | `boolean` | `false` | Whether guards can suffer critical headshot damage |
| `CombatAbility` | `number` | `100` | Combat ability level (0 - 100, higher is better) |
| `Accuracy` | `number` | `60` | Shot accuracy (0 - 100, higher is more accurate) |
| `CombatRange` | `number` | `2` | Engagement range: 0 = short, 1 = medium, 2 = long |
| `CombatMovement` | `number` | `2` | Movement style: 0 = calm, 1 = normal, 2 = aggressive |
| `CanRagdoll` | `boolean` | `true` | Whether guards can ragdoll from player impact |

### Guard Spawn Positions

```lua
Config.Guards = {
    coords = {
        vector4(505.64, -1817.47, 28.90, 48.63),
        vector4(504.35, -1812.33, 28.90, 138.57),
        vector4(511.26, -1818.64, 28.90, 42.24),
        vector4(506.07, -1820.22, 28.90, 319.97),
    }
}
```

Four guards spawn by default. Add or remove `vector4` entries to change the number and positions of guards.

### Guard Loot Rewards

```lua
Config.GuardRewards = {
    weaponChance = 60,
    itemRange = {min = 2, max = 3},
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
        amount = {min = 1, max = 2},
    },
    MedicRewards = {
        items = {"bandage", "revivekit"},
        chance = 45,
        amount = {min = 1, max = 2},
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `weaponChance` | `number` | `60` | Overall percentage chance of receiving any gun-related reward |
| `itemRange` | `table` | `{min = 2, max = 3}` | Min and max number of items a player can receive per loot |

#### Reward Categories

| Category | Items | Chance | Gun Reward | Amount |
|---|---|---|---|---|
| `PistolRewards` | `weapon_heavypistol`, `weapon_pistol`, `weapon_pistol_mk2` | 37 | Yes | 1 |
| `RareRewards` | `weapon_assaultrifle`, `weapon_compactrifle`, `weapon_mg` | 15 | Yes | 1 |
| `SMGRewards` | `weapon_assaultsmg`, `weapon_minismg`, `weapon_combatpdw` | 32 | Yes | 1 |
| `ShotgunRewards` | `weapon_sawnoffshotgun`, `weapon_pumpshotgun`, `weapon_dbshotgun` | 25 | Yes | 1 |
| `AmmoRewards` | `pistol_ammo`, `shotgun_ammo`, `rifle_ammo`, `smg_ammo` | 45 | No | 1 - 2 |
| `MedicRewards` | `bandage`, `revivekit` | 45 | No | 1 - 2 |

::: warning
The `chance` values are **weights**, not percentages that must add up to 100. A category with chance 30 is twice as likely as one with chance 15.

Only **one** `isGunReward = true` category can be selected per loot. Even if `itemRange` allows 4 items, at most one will be a weapon when all weapon categories have `isGunReward = true`. To allow multiple weapons per loot, set `isGunReward = false` on the extra weapon categories.
:::

## Logging

Logging is configured in `server/logs.lua`.

```lua
return {
    logs = {
        service     = 'none',
        dataset     = 'sd-traphouse',
        screenshots = false,
        events = { ... },
        discord = { ... },
        loki = { ... },
        grafana = { ... },
    },
}
```

### Service

| Key | Type | Default | Description |
|---|---|---|---|
| `service` | `string` | `'none'` | Logging backend to use |
| `dataset` | `string` | `'sd-traphouse'` | Fivemanage dataset ID (only used when service is `'fivemanage'`) |
| `screenshots` | `boolean` | `false` | Include screenshots with logs (Fivemanage and Fivemerr only) |

Supported `service` values:

| Value | Description |
|---|---|
| `'none'` | Logging disabled |
| `'fivemanage'` | Fivemanage logging service |
| `'fivemerr'` | Fivemerr logging service |
| `'discord'` | Discord webhook |
| `'loki'` | Grafana Loki push endpoint |
| `'grafana'` | Grafana Cloud Logs |

### Log Events

Each event can be individually enabled (`true`) or disabled (`false`).

```lua
events = {
    remove_item         = true,
    give_object         = true,
    loot_guards         = true,
    start_cooldown      = true,
    has_frontdoor_item  = true,
    has_vault_item      = true,
}
```

| Event | Default | Description |
|---|---|---|
| `remove_item` | `true` | Logged when a player's front-door or vault item is removed (chance-based) |
| `give_object` | `true` | Logged when a player receives money or an item from a prop |
| `loot_guards` | `true` | Logged when a player loots a dead guard for rewards |
| `start_cooldown` | `true` | Logged when someone starts the global traphouse cooldown |
| `has_frontdoor_item` | `true` | Logged when checking whether a player has the front-door key item |
| `has_vault_item` | `true` | Logged when checking whether a player has the vault key item |

### Discord Settings

Only used when `service = 'discord'`.

```lua
discord = {
    name   = 'TrapHouse Logs',
    link   = '',
    image  = '',
    footer = '',
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | `string` | `'TrapHouse Logs'` | Display name of the webhook |
| `link` | `string` | `''` | Discord webhook URL |
| `image` | `string` | `''` | Webhook avatar image URL |
| `footer` | `string` | `''` | Webhook footer icon URL |

### Loki Settings

Only used when `service = 'loki'`.

```lua
loki = {
    endpoint = '',
    user     = '',
    password = '',
    tenant   = '',
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `endpoint` | `string` | `''` | Base URL without trailing slash (e.g. `https://loki.example.com`) |
| `user` | `string` | `''` | Basic auth username (optional) |
| `password` | `string` | `''` | Basic auth password or API key (optional) |
| `tenant` | `string` | `''` | `X-Scope-OrgID` header value (optional) |

### Grafana Settings

Only used when `service = 'grafana'`.

```lua
grafana = {
    endpoint = '',
    apiKey   = '',
    tenant   = '',
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `endpoint` | `string` | `''` | Base URL without trailing slash (e.g. `https://logs-prod.grafana.net`) |
| `apiKey` | `string` | `''` | Grafana API key (prefixed with `Bearer `) |
| `tenant` | `string` | `''` | `X-Scope-OrgID` header value (optional) |
