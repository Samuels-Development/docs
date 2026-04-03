# Configuration

All settings are found in `configs/config.lua`. Map-specific settings are in `configs/maps/*.lua`, and logging is configured in `configs/logs.lua`. This page covers every configurable option in the main config file.

## Debug Options

```lua
DebugPrints = false,
DebugZones = false,
```

| Key | Type | Default | Description |
|---|---|---|---|
| `DebugPrints` | `boolean` | `false` | Enable console debug messages |
| `DebugZones` | `boolean` | `false` | Enable visual debug for zones and target spheres |

## Locale

```lua
Locale = "en",
```

Sets the language for all translations. The script loads the corresponding JSON file from `locales/`. Available locales: `en` (English), `de` (German). Falls back to English if the specified locale file is not found.

## UI Accent Color

```lua
AccentColor = "d97706",
```

Hex color code **without** the `#` prefix. Used for HUD elements, shop UI, and other interface components.

Examples: `"d97706"` (amber, default), `"3b82f6"` (blue), `"10b981"` (green), `"ef4444"` (red), `"8b5cf6"` (purple), `"ec4899"` (pink).

## Map Selection

```lua
Maps = {
    'server_farm',
    'cayo_estate',
    'doomsday_bunker',
    'gunrunning_bunker'
},
```

An array of map file names (without `.lua` extension) from `configs/maps/`. The script loads each map config on startup. Remove or add entries to control which maps are available.

## Cooldown

```lua
Cooldown = {
    enabled = true,
    duration = 60,
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Cooldown.enabled` | `boolean` | `true` | Enable the post-game cooldown |
| `Cooldown.duration` | `number` | `60` | Cooldown duration in minutes |

::: info
The cooldown is tracked per-player identifier. After completing a horde game, the player must wait before starting another.
:::

## Restart Restrictions

Integration with txAdmin prevents games from running into scheduled server restarts.

```lua
RestartRestrict = {
    enabled = true,
    blockNewGamesTime = 1800,
    endActiveGamesTime = 600,
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `RestartRestrict.enabled` | `boolean` | `true` | Enable restart detection and game blocking |
| `RestartRestrict.blockNewGamesTime` | `number` | `1800` | Seconds before restart to block new games and ped interaction (30 min) |
| `RestartRestrict.endActiveGamesTime` | `number` | `600` | Seconds before restart to force-end active/pending games (10 min) |

::: warning
This feature relies on txAdmin's scheduled restart events. If you use a different restart method, this setting will have no effect.
:::

## Rejoin System

If a player disconnects during a mission, the rejoin system allows them to return.

```lua
RejoinSystem = {
    enabled = true,
    allowRejoin = true,
    rejoinTimeout = 300,
    pauseOnEmpty = true,
    pauseTimeout = 120,
    resumeCountdown = 10,
    resumeEnemyDelay = 1000,
    deadPlayerTimeout = 120,
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `RejoinSystem.enabled` | `boolean` | `true` | Master toggle for the entire rejoin system |
| `RejoinSystem.allowRejoin` | `boolean` | `true` | Allow individual players to rejoin after disconnect |
| `RejoinSystem.rejoinTimeout` | `number` | `300` | Seconds a player has to rejoin (5 minutes) |
| `RejoinSystem.pauseOnEmpty` | `boolean` | `true` | Pause game instead of ending when all players disconnect |
| `RejoinSystem.pauseTimeout` | `number` | `120` | Seconds the game stays paused waiting for a rejoin (2 minutes) |
| `RejoinSystem.resumeCountdown` | `number` | `10` | Seconds countdown before game resumes after rejoin |
| `RejoinSystem.resumeEnemyDelay` | `number` | `1000` | Milliseconds delay before enemies resume attacking after game resumes |
| `RejoinSystem.deadPlayerTimeout` | `number` | `120` | Seconds before game ends when only dead players remain after alive players disconnect |

::: tip
If `pauseOnEmpty` is enabled and all players disconnect, the game freezes. Enemy spawning stops and the round timer pauses until at least one player reconnects or the timeout expires.
:::

## Inventory

### Confiscation and Return

```lua
ConfiscateInventory = true,
ManualInventoryReturn = true,
```

| Key | Type | Default | Description |
|---|---|---|---|
| `ConfiscateInventory` | `boolean` | `true` | Remove all items on entry and store them for return later |
| `ManualInventoryReturn` | `boolean` | `true` | Adds a target option on the ped to manually retrieve confiscated inventory (fallback for crashes) |

### Inventory Restrictions

```lua
InventoryRestrictions = {
    preventDrop = true,
    preventGive = true,
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `InventoryRestrictions.preventDrop` | `boolean` | `true` | Prevent players from dropping items during a horde game |
| `InventoryRestrictions.preventGive` | `boolean` | `true` | Prevent players from giving items to other players during a horde game |

::: warning
Inventory restrictions only work with **ox_inventory**. Other inventory systems do not support external hooks for preventing drop/give actions.
:::

### Starting Loadout

```lua
StartingLoadout = {
    enabled = true,
    items = {
        { name = "WEAPON_PISTOL", count = 1 },
        { name = "ammo-9", count = 200 },
        { name = "bandage", count = 10 },
        { name = "oxy", count = 10 },
        { name = "burger", count = 3 },
        { name = "water", count = 3 },
        { name = "radio", count = 1 },
    },
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `StartingLoadout.enabled` | `boolean` | `true` | Whether to give players the starting loadout on entry |
| `StartingLoadout.items` | `table` | See above | Array of `{ name, count }` entries. Item names must match your inventory system |

::: tip
If `ConfiscateInventory` is `true` and `StartWithLootRound` is `false`, players would start with no items and no weapons. Enable the starting loadout or start with a loot round to avoid this.
:::

## Zone Exit Timeout

```lua
ZoneExitTimeout = 3,
```

Seconds before a player is removed from the game when they leave the play area. Set to `0` for instant removal.

## Group Settings

```lua
MaxGroupMembers = 4,
FriendlyFire = false,
```

| Key | Type | Default | Description |
|---|---|---|---|
| `MaxGroupMembers` | `number` | `4` | Maximum players per group (including leader). Set to `0` for unlimited |
| `FriendlyFire` | `boolean` | `false` | Whether group members can damage each other |

## Revive Settings

```lua
ReviveOnExit = true,

ShopRevive = {
    enabled = true,
    cost = 5000,
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `ReviveOnExit` | `boolean` | `true` | Revive players when they leave or are removed from a horde game |
| `ShopRevive.enabled` | `boolean` | `true` | Allow reviving dead teammates from the shop menu |
| `ShopRevive.cost` | `number` | `5000` | Cost in points to revive a teammate |

## Radio Sync

Requires `pma-voice`. Players in a game are automatically assigned a shared radio channel.

```lua
RadioSync = {
    enabled = true,
    useChannelPool = false,
    channelPool = { 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010 },
    useRandomChannel = true,
    randomMin = 100000,
    randomMax = 999999,
    channelOffset = 1000,
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `RadioSync.enabled` | `boolean` | `true` | Enable radio sync (requires pma-voice) |
| `RadioSync.useChannelPool` | `boolean` | `false` | Use a predefined pool of channels |
| `RadioSync.channelPool` | `table` | `1001-1010` | Pool of available channels (only if `useChannelPool = true`) |
| `RadioSync.useRandomChannel` | `boolean` | `true` | Generate a random channel (only if `useChannelPool = false`) |
| `RadioSync.randomMin` | `number` | `100000` | Minimum random channel value |
| `RadioSync.randomMax` | `number` | `999999` | Maximum random channel value |
| `RadioSync.channelOffset` | `number` | `1000` | Channel = gameIdCounter + offset (fallback if both pool and random are disabled) |

::: info
Channel allocation priority: `useChannelPool` > `useRandomChannel` > `channelOffset`. The first enabled method is used.
:::

## Level System

```lua
LevelSystem = {
    levels = {
        [1] = 0,       -- Starting level
        [2] = 100,
        [3] = 250,
        [4] = 450,
        [5] = 700,
        [6] = 1000,
        [7] = 1400,
        [8] = 1900,
        [9] = 2500,
        [10] = 3200,
        [11] = 4000,
        [12] = 5000,
        [13] = 6200,
        [14] = 7600,
        [15] = 9200,
        [16] = 11000,
        [17] = 13000,
        [18] = 15500,
        [19] = 18500,
        [20] = 22000,
    },
    xpRewards = {
        enemyKill = 10,
        roundComplete = 50,
        hordeComplete = 200,
        lootDeposit = 5,
    },
},
```

The `levels` table maps level numbers to cumulative XP thresholds. You can add more levels by extending the table.

| XP Reward | Default | Description |
|---|---|---|
| `enemyKill` | `10` | XP per enemy killed |
| `roundComplete` | `50` | XP per round completed |
| `hordeComplete` | `200` | XP for completing all rounds |
| `lootDeposit` | `5` | XP per loot crate deposited |

## Ped Configuration

The NPC that players interact with to start missions. Uses `ox_lib` point-based spawning.

```lua
Ped = {
    enabled = true,
    model = 'g_m_y_lost_01',
    coords = vector4(705.81, -966.72, 29.41, 304.76),
    spawnDistance = 50.0,
    despawnDistance = 60.0,
    scenario = 'WORLD_HUMAN_SMOKING',
    invincible = true,
    freeze = true,
    blockEvents = true,
    target = {
        enabled = true,
        icon = 'fas fa-comments',
        label = 'Talk',
        distance = 2.5,
    }
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Ped.enabled` | `boolean` | `true` | Enable/disable ped spawning |
| `Ped.model` | `string` | `'g_m_y_lost_01'` | Ped model name |
| `Ped.coords` | `vector4` | See above | Spawn location (x, y, z, heading) |
| `Ped.spawnDistance` | `number` | `50.0` | Distance to spawn the ped |
| `Ped.despawnDistance` | `number` | `60.0` | Distance to despawn the ped (should be > spawnDistance) |
| `Ped.scenario` | `string` | `'WORLD_HUMAN_SMOKING'` | Ped scenario/animation (`nil` to disable) |
| `Ped.invincible` | `boolean` | `true` | Make ped invincible |
| `Ped.freeze` | `boolean` | `true` | Freeze ped in place |
| `Ped.blockEvents` | `boolean` | `true` | Block ped from reacting to events |
| `Ped.target.enabled` | `boolean` | `true` | Enable target interaction on the ped |
| `Ped.target.icon` | `string` | `'fas fa-comments'` | Font Awesome icon for the target |
| `Ped.target.label` | `string` | `'Talk'` | Target label text |
| `Ped.target.distance` | `number` | `2.5` | Interaction distance |

## Zone Configuration

An alternative (or supplement) to the ped -- a target zone without a ped model.

```lua
Zone = {
    enabled = false,
    coords = vector3(707.32, -967.67, 30.48),
    size = vector3(1.5, 1.5, 2.0),
    rotation = 0.0,
    debug = false,
    target = {
        icon = 'fas fa-skull-crossbones',
        label = 'Horde Mode',
        distance = 2.5,
    }
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Zone.enabled` | `boolean` | `false` | Enable the zone target |
| `Zone.coords` | `vector3` | See above | Zone center position |
| `Zone.size` | `vector3` | `1.5, 1.5, 2.0` | Zone dimensions (width, depth, height) |
| `Zone.rotation` | `number` | `0.0` | Zone rotation in degrees |
| `Zone.debug` | `boolean` | `false` | Show debug zone outline |

::: tip
You can use the Ped, Zone, or both simultaneously for horde entry. Set `Ped.enabled = false` and `Zone.enabled = true` for a zone-only setup.
:::

## Round and Enemy Settings

### Enemy Spawn Cap

```lua
MaxAliveEnemies = 15,
```

Limits the number of enemies alive at once. When an enemy dies, a new one spawns if there are still enemies remaining for the round. Set to `0` or `nil` to disable (spawn all enemies at once). This can also be overridden per-difficulty in map configs.

### Dead Body Cleanup

```lua
ClearBodiesOnRoundEnd = true,
MaxDeadBodies = 10,
DeadBodyDespawnTime = 30,
```

| Key | Type | Default | Description |
|---|---|---|---|
| `ClearBodiesOnRoundEnd` | `boolean` | `true` | Clear dead bodies when a new round begins |
| `MaxDeadBodies` | `number` | `10` | Maximum dead bodies at once during a round (oldest removed first). `0` or `nil` to disable |
| `DeadBodyDespawnTime` | `number` | `30` | Seconds before a dead body is automatically cleaned up. `0` or `nil` to disable timed cleanup |

### Looting and Round Flow

```lua
LootingPhaseDuration = 240,
StartWithLootRound = true,
RerollCost = 200,
PerkVoteDuration = 15,
```

| Key | Type | Default | Description |
|---|---|---|---|
| `LootingPhaseDuration` | `number` | `240` | Duration of the looting phase in seconds |
| `StartWithLootRound` | `boolean` | `true` | Start with a looting phase instead of an enemy round after the intro |
| `RerollCost` | `number` | `200` | Cost to reroll the shop inventory |
| `PerkVoteDuration` | `number` | `15` | Seconds to vote for a perk between rounds |

::: warning
If `ConfiscateInventory` is `true` and `StartWithLootRound` is `false`, players will start the first enemy round with only whatever is in the starting loadout. Enable `StartWithLootRound` to give players a chance to buy equipment from the shop first.
:::

## Shop Items

The default shop configuration used for all maps (maps can override this with their own `shopItems` table).

```lua
ShopItems = {
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

| Key | Type | Default | Description |
|---|---|---|---|
| `guaranteeAmmoForWeapons` | `boolean` | `true` | Always include matching ammo for selected weapons in the items section |
| `ammoBoostMultiplier` | `number` | `3` | Boost ammo chance multiplier when matching weapon is in shop (used if guarantee is off) |
| `items.itemCount` | `number` | `6` | Number of items to show in the shop |
| `weapons.itemCount` | `number` | `3` | Number of weapons to show in the shop |
| `perks.itemCount` | `number` | `2` | Number of perks to show in the shop |

Each item in a list has:

| Field | Type | Description |
|---|---|---|
| `name` | `string` | Item spawn name (must match inventory item name) |
| `label` | `string` | Display name in the shop UI |
| `rarity` | `string` | `"common"`, `"uncommon"`, `"rare"`, or `"epic"` |
| `price` | `number` | Cost in horde points |
| `chance` | `number` | Weighted chance to appear (higher = more likely) |
| `quantity` | `number` | How many items received per purchase (default: 1) |
| `amount` | `number?` | How many times this item can be purchased before sold out. Omit for single purchase |

## Weapon Display Models

Maps weapon names to their prop models for the mystery box weapon display animation.

```lua
WeaponDisplayModels = {
    ["weapon_pistol"] = "w_pi_pistol",
    ["weapon_carbinerifle"] = "w_ar_carbinerifle",
    -- ... full list in config
},
WeaponDisplayFallback = "w_pi_pistol",
```

If a weapon is not listed in the table, `WeaponDisplayFallback` is used as the display model.

## Weapon Ammo Types

Maps weapons to their ammo item names. Used to link weapons to their correct ammo in shops.

```lua
WeaponAmmoTypes = {
    ["weapon_pistol"] = "ammo-9",
    ["weapon_combatpistol"] = "ammo-9",
    ["weapon_assaultrifle"] = "ammo-rifle2",
    -- ... full list in config
},
```

Weapons not listed here (like melee weapons) will not have ammo requirements.

## Carry Animation

Default carry animation for loot objects, and per-model overrides.

```lua
CarryAnimation = {
    dict = 'anim@heists@box_carry@',
    anim = 'idle',
    bone = 0xEB95,
    offset = vector3(0.075, -0.15, 0.30),
    rotation = vector3(-130.0, 105.0, 0.0),
},

CarryOffsets = {
    ['prop_box_ammo01a'] = {
        offset = vector3(0.155, -0.090, 0.130),
        rotation = vector3(-110.0, 179.0, 45.0),
    },
    -- ... per-model overrides
},
```

## Perk System (VotePerks)

The `VotePerks` table defines all available perks that can appear in voting and the shop. Each perk has:

| Field | Type | Description |
|---|---|---|
| `id` | `string` | Unique perk identifier (referenced by shop perks) |
| `icon` | `string` | Icon name from [Lucide Icons](https://lucide.dev/icons) (kebab-case) |
| `benefit` | `string` | Display text for the positive effect |
| `downside` | `string` | Display text for the negative effect (or `"NO DOWNSIDE"`) |
| `effects` | `table` | Array of effect definitions applied by the perk |

### Available Effect Types

**Player Combat Modifiers:**

| Effect Type | Value Type | Description |
|---|---|---|
| `damage` | `number` | Damage dealt modifier (e.g., `1.0` = +100%) |
| `incoming_damage` | `number` | Damage taken modifier (negative = reduction) |
| `speed` | `number` | Movement speed modifier |
| `armor` | `number` | Flat armor value |
| `heal_on_kill` | `number` | HP restored per kill |
| `ammo_on_kill` | `number` | Ammo gained per kill |
| `headshot_damage` | `number` | Headshot damage multiplier |
| `bodyshot_damage` | `number` | Body damage modifier (negative = reduction) |
| `regen_per_second` | `number` | HP regenerated per second |

**Currency/Rewards:**

| Effect Type | Value Type | Description |
|---|---|---|
| `loot_value` | `number` | Loot value multiplier |
| `points` | `number` | Points earned multiplier |
| `currency` | `number` | All currency earned multiplier |
| `headshot_currency` | `number` | Bonus currency for headshot kills |
| `kill_currency` | `number` | Flat bonus currency per kill |
| `shop_discount` | `number` | Shop price reduction (e.g., `0.25` = -25%) |

**Enemy Modifiers (debuffs):**

| Effect Type | Value Type | Description |
|---|---|---|
| `enemy_speed` | `number` | Enemy speed increase |
| `enemy_health` | `number` | Enemy health increase |
| `enemy_damage` | `number` | Enemy damage increase |
| `enemy_armor` | `number` | Enemy armor increase |
| `enemy_accuracy` | `number` | Enemy accuracy increase |

**Boolean Toggles:**

| Effect Type | Description |
|---|---|
| `infinite_ammo` | Infinite ammo |
| `no_health_regen` | Disable natural health regen |
| `one_hit_kill` | Player dies in one hit |
| `explosive_rounds` | Bullets cause explosions |
| `thermite_rounds` | Enemies burn on hit |
| `no_armor` | Cannot have armor |
| `last_stand` | Survive one fatal hit |
| `super_jump` | Super jump (very high) |
| `jump_height` | Jump height modifier (number, e.g., `0.5` = +50%) |

**Special Effects:**

| Effect Type | Description |
|---|---|
| `berserker` | Damage per kill (stacks), resets on hit. Supports `maxStacks` |
| `adrenaline` | Speed bonus below HP threshold. Supports `threshold` |
| `rage_mode` | Damage per 10% HP lost |
| `gambler` | Random bonuses/penalties |

### Default Perks

The config includes 20+ perks spanning damage, defense, mobility, utility, risk/reward, currency, and enemy modifier categories. Two additional perks (`explosive_rounds` and `thermite_rounds`) are commented out by default due to potential issues with certain weapons.

## Player Statistics

```lua
Stats = {
    enabled = true,
    showGamesPlayed = true,
    showSoloGames = true,
    showGroupGames = true,
    showPlayTime = true,
    showKills = true,
    showRoundsCleared = true,
    showHordesCompleted = true,
    showDamageDealt = true,
    showDamageTaken = true,
    showCoinsEarned = true,
    showCoinsSpent = true,
    showLootDeposited = true,
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Stats.enabled` | `boolean` | `true` | Master toggle -- if false, stats option is hidden from ped menu entirely |
| `Stats.show*` | `boolean` | `true` | Toggle individual stat categories |

## End Game Loot

End game loot is configured per-map and optionally per-difficulty. A fallback can be defined in the main config (commented out by default). Priority order:

1. **Per-difficulty** `endGameLoot` (in difficulty config)
2. **Map-level** `endGameLoot` (in map config)
3. **Main config** `EndGameLoot` (fallback, commented out by default)

Each end game loot config has:

| Key | Type | Description |
|---|---|---|
| `rerollCost` | `number` | Cost to reroll the loot shop items |
| `itemCount` | `number` | Number of items shown at once |
| `duration` | `number` | Seconds before the game fully ends (countdown) |
| `lootTable` | `table` | Array of loot items with name, label, rarity, price, chance, quantity |

## Logging Configuration

Logging is configured in `configs/logs.lua`. See the file for full documentation on all 20+ log events.

```lua
logs = {
    service = 'none',  -- 'discord', 'fivemanage', 'fivemerr', 'loki', 'grafana', or 'none'
    screenshots = false,
    discord = { ... },
    fivemanage = { ... },
    loki = { ... },
    grafana = { ... },
    events = { ... },
}
```

| Service | Description |
|---|---|
| `'discord'` | Discord webhook with rich embeds |
| `'fivemanage'` | Fivemanage dashboard |
| `'fivemerr'` | Fivemerr (fm-logs) |
| `'loki'` | Loki/Prometheus stack |
| `'grafana'` | Grafana Cloud |
| `'none'` | Disable all logging |

Each event in the `events` table can be individually enabled/disabled and customized with title, description, color, and fields using placeholders like `{player}`, `{map}`, `{gameId}`, etc.

## Map-Specific Configuration

See the individual map pages and [Creating Maps](/resources/horde/creating-maps) for details on per-map settings including:

- Difficulty tiers with round counts, enemy configuration, and boss fights
- Map-specific shop items (override the global shop)
- Map-specific end game loot tables
- Requirements (level, completed maps, items)
- Mystery box configuration
- Loot objects and spawn locations

Map pages:
- [Server Farm](/resources/horde/maps-server-farm)
- [Cayo Estate](/resources/horde/maps-cayo-estate)
- [Doomsday Bunker](/resources/horde/maps-doomsday-bunker)
- [Gunrunning Bunker](/resources/horde/maps-gunrunning-bunker)
