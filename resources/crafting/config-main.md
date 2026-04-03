# Main Config

The main configuration file is located at `sd-crafting/configs/config.lua`. It controls locale, commands, crafting behavior, queue persistence, blueprints, tools, inventory staging, leveling, shops, placeable workbenches, and static stations.

The file returns a single Lua table. All settings are accessed as properties of this table (e.g. `Config.Debug`).

## Locale

```lua
Locale = 'en',
```

Defines which language file to load from the `locales/` folder. Available options: `'en'` (English), `'de'` (German).

## Commands

```lua
Commands = {
    placeWorkbench = 'placeworkbench',
    craftAdmin = 'craftadmin',
},
```

| Key | Default | Description |
|---|---|---|
| `placeWorkbench` | `'placeworkbench'` | Chat command to place a workbench prop and print coordinates to the F8 console |
| `craftAdmin` | `'craftadmin'` | Chat command to open the crafting admin panel |

## Debug

```lua
Debug = false,
DebugVerbose = false,
```

| Setting | Default | Description |
|---|---|---|
| `Debug` | `false` | Enable debug prints in the server console |
| `DebugVerbose` | `false` | Enable verbose debug prints that log every queue tick per second -- very noisy, only use for troubleshooting |

## Max Inventory Weight

```lua
MaxInventoryWeight = 120000,
```

Fallback value (in grams) used when the script cannot automatically detect the player's max inventory weight from the inventory system. The script attempts auto-detection from ox_inventory, qb-inventory, qs-inventory, codem-inventory, and origen_inventory.

**Default:** `120000` (120 kg)

## Crafting Behavior

These are the **global defaults** for crafting behavior. They can be overridden per-station (in `Stations`) or per-placeable workbench (in `PlaceableWorkbenches`) by adding a `CraftingBehavior` table. Partial overrides are supported -- any missing settings fall back to these global defaults.

```lua
CraftingBehavior = {
    preventCloseWhileCrafting = true,
    cancelCraftOnClose = false,
    allowCraftingNearby = {
        enabled = false,
        distance = 5.0,
    },
    allowCraftingAnywhere = {
        enabled = false,
        notifyPlayer = false,
    },
    sharedCrafting = {
        placed = true,
        static = false,
    },
},
```

### preventCloseWhileCrafting

| Value | Behavior |
|---|---|
| `true` (default) | Player cannot close the UI while crafting -- they must cancel or wait for completion |
| `false` | Player can close the UI freely while crafting |

### cancelCraftOnClose

Only applies when `preventCloseWhileCrafting` is `false`.

| Value | Behavior |
|---|---|
| `true` | Closing the UI cancels the craft and refunds materials |
| `false` (default) | Closing the UI does not cancel the craft |

### allowCraftingNearby

Only applies when both `preventCloseWhileCrafting` and `cancelCraftOnClose` are `false`.

| Key | Default | Description |
|---|---|---|
| `enabled` | `false` | When `true`, crafting continues while the player stays within `distance` meters of the workbench |
| `distance` | `5.0` | Maximum distance from the workbench to continue crafting |

### allowCraftingAnywhere

| Key | Default | Description |
|---|---|---|
| `enabled` | `false` | When `true`, the player can start a craft, close the menu, and go anywhere while it completes |
| `notifyPlayer` | `false` | When `true`, the player is notified when crafting completes even if far away |

::: info
When the UI is closed and crafting completes via `allowCraftingAnywhere`, items go to the **crafting stash** (since the player may not be near the workbench). If the player has the UI open when crafting completes, items follow the `AddOutputToStash` setting instead.
:::

### sharedCrafting

| Key | Default | Description |
|---|---|---|
| `placed` | `true` | When `true`, all users of a placed workbench share the same crafting queue |
| `static` | `false` | When `true`, all users of a static station share the same crafting queue |

## Output Destination

```lua
AddOutputToStash = true,
```

| Value | Behavior |
|---|---|
| `true` (default) | Crafted items are added to the crafting inventory/stash instead of the player's inventory |
| `false` | Crafted items go directly into the player's inventory |

## Fail Chance

```lua
FailChance = {
    treatQuantityAsWhole = false,
},
```

| Value | Behavior |
|---|---|
| `true` | One roll for the entire batch -- all items succeed or all fail together |
| `false` (default) | Each item is rolled individually -- some may succeed, some may fail |

**Example with 25% fail chance crafting 10 items:**
- `treatQuantityAsWhole = true` -- Either all 10 succeed or all 10 fail (one 25% roll)
- `treatQuantityAsWhole = false` -- Each item rolls separately, average ~7-8 succeed, ~2-3 fail

## Queue Persistence

### Tick Down When Offline

```lua
TickDownQueueWhenOffline = false,
```

| Value | Behavior |
|---|---|
| `true` | Crafting time continues to tick down even when the server/script is offline. If a craft completes while offline, items are added to the crafting stash on next start |
| `false` (default) | The queue resumes from where it left off -- remaining time stays the same |

::: info
This only affects server/script restarts. For player disconnects, the server always continues ticking down craft timers while a player is away (unless `CancelCraftOnLeave` is `true`).
:::

### Cancel Craft on Leave

```lua
CancelCraftOnLeave = true,
```

| Value | Behavior |
|---|---|
| `true` (default) | If a player disconnects or crashes while crafting, their entire queue is cancelled and ingredients are refunded to the station's staging inventory |
| `false` | The server continues counting down the craft timer while the player is away. Completed items go to the staging inventory. On reconnect the player is notified how many items completed |

::: warning
**It is highly recommended to leave this as `true`.** Offline crafting can cause erratic behavior and is considered non-functioning by the developer.
:::

::: info
Recipe costs (money) are **not** refunded when a queue is cancelled due to player disconnect, since the player is offline at the time of cancellation.
:::

### Periodic Queue Save

```lua
PeriodicQueueSave = {
    enabled = false,
    interval = 10,
},
```

Queues are **always** saved on player disconnect, server shutdown (txAdmin), and queue completion. This setting controls whether to also save periodically during gameplay.

| Key | Default | Description |
|---|---|---|
| `enabled` | `false` | Enable periodic saves. Only needed if you frequently restart the resource (not the server) during testing |
| `interval` | `10` | Save interval in seconds |

::: tip
The txAdmin shutdown handler reliably saves all data. You only need periodic saves if you are hot-restarting the resource on a live server. Keep this `false` for production.
:::

## Blueprints

```lua
Blueprints = {
    enabled = true,
    destroyOnCraft = {
        enabled = false,
        chance = 15,
    },
    durability = {
        enabled = true,
        defaultDurability = 100,
        defaultLoss = 10,
    },
},
```

### Top-Level

| Key | Default | Description |
|---|---|---|
| `enabled` | `true` | Master toggle for the entire blueprint system |

### destroyOnCraft (Legacy System)

A simple random-destruction system. **Disabled when durability is enabled.**

| Key | Default | Description |
|---|---|---|
| `enabled` | `false` | Enable random blueprint destruction on craft |
| `chance` | `15` | Percentage chance (0-100) to destroy the blueprint each craft |

### durability (ox_inventory only)

Uses item metadata to track blueprint wear. **Overrides `destroyOnCraft` when active.**

| Key | Default | Description |
|---|---|---|
| `enabled` | `true` | Enable the durability system (requires ox_inventory) |
| `defaultDurability` | `100` | Default max durability for new blueprints |
| `defaultLoss` | `10` | Default durability loss per craft, used when a recipe does not specify `blueprintDurabilityLoss` |

## Tools

```lua
Tools = {
    enabled = true,
    durability = {
        enabled = true,
        defaultDurability = 100,
        defaultLoss = 10,
    },
},
```

| Key | Default | Description |
|---|---|---|
| `enabled` | `true` | Master toggle for the tool requirement system |

### durability (ox_inventory only)

| Key | Default | Description |
|---|---|---|
| `enabled` | `true` | Enable durability consumption for tools (requires ox_inventory) |
| `defaultDurability` | `100` | Default max durability for tools |
| `defaultLoss` | `10` | Default durability loss per craft, used when a tool does not specify `durabilityLoss` |

## Inventory Panel

```lua
InventoryPanel = {
    enabled = true,
    showAllItems = true,
    maxSlots = 20,
    maxWeight = 500000,
    perWorkbench = {
        placed = true,
        static = false,
    },
    returnOnClose = false,
},
```

| Key | Default | Description |
|---|---|---|
| `enabled` | `true` | Show the inventory panel with staging functionality |
| `showAllItems` | `true` | Show all items in the player's inventory (`true`) or only items used in recipes (`false`) |
| `maxSlots` | `20` | Maximum number of slots in the crafting inventory |
| `maxWeight` | `500000` | Maximum weight in the crafting inventory (in grams). `0` = unlimited |
| `returnOnClose` | `false` | Return staged items to the player's inventory when closing the UI |

### perWorkbench

Controls whether staged items are stored per-workbench (shared between all players) or per-player.

| Key | Default | Description |
|---|---|---|
| `placed` | `true` | `true` = shared per-workbench for placed workbenches; `false` = per-player |
| `static` | `false` | `true` = shared per-workbench for static stations; `false` = per-player |

## Leveling

```lua
Leveling = {
    enabled = true,
    perWorkbenchType = true,
    defaultXpReward = {
        enabled = true,
        amount = 5,
    },
    levels = {
        [1] = 0, [2] = 100, [3] = 250, [4] = 500, [5] = 850,
        [6] = 1300, [7] = 1900, [8] = 2650, [9] = 3550, [10] = 4600,
    },
    maxLevel = 10,
    workbenchTypes = { ... },
},
```

| Key | Default | Description |
|---|---|---|
| `enabled` | `true` | Master toggle for the leveling system |
| `perWorkbenchType` | `true` | `true` = separate levels per workbench type; `false` = single global crafting level |

### defaultXpReward

| Key | Default | Description |
|---|---|---|
| `enabled` | `true` | When `false`, recipes without an `xpReward` field give no XP |
| `amount` | `5` | Default XP amount when a recipe does not specify `xpReward` |

### levels

The default level-up XP thresholds. Each key is the level number, each value is the cumulative XP required to reach that level. Used as a fallback when `perWorkbenchType` is `false`, or when a workbench type does not define its own levels.

**Default max level:** `10`

### workbenchTypes

Per-workbench-type level configurations (only used when `perWorkbenchType = true`). Each entry can define its own `levels` table and `maxLevel`. If a type is not defined here, the default levels above are used.

```lua
workbenchTypes = {
    ['basic'] = {
        levels = { [1] = 0, [2] = 100, ... [10] = 4600 },
        maxLevel = 10,
    },
    ['advanced'] = {
        levels = { [1] = 0, [2] = 200, ... [15] = 24200 },
        maxLevel = 15,
    },
},
```

## Shops

```lua
Shops = {
    ['workbench_vendor'] = {
        label = 'Workbench Vendor',
        coords = vector3(342.95, -1298.04, 32.51),
        heading = 159.2,
        model = 's_m_m_autoshop_02',
        spawnRadius = 50.0,
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        useItemImages = false,
        blip = {
            enabled = true,
            sprite = 566,
            color = 2,
            scale = 0.7,
            label = 'Workbench Vendor',
        },
        items = {
            {
                id = 'workbench',
                label = 'Basic Workbench',
                description = 'A small portable workbench for crafting on the go',
                icon = 'fa-solid fa-toolbox',
                price = 5000,
            },
        },
    },
},
```

### Shop Configuration

| Key | Type | Description |
|---|---|---|
| `label` | `string` | Display name of the shop |
| `coords` | `vector3` | Position of the ped in the world |
| `heading` | `number` | Direction the ped faces (0-360) |
| `model` | `string` | GTA V ped model name |
| `spawnRadius` | `number` | Distance at which the ped spawns |
| `scenario` | `string` | Ped animation/scenario while idle |
| `useItemImages` | `boolean` | `true` = use item images from inventory; `false` = use the `icon` defined per item |
| `blip` | `table` | Map blip configuration (see below) |
| `items` | `table` | Array of items this shop sells |

### Blip Configuration

| Key | Type | Description |
|---|---|---|
| `enabled` | `boolean` | Show a map blip for this shop |
| `sprite` | `number` | Blip sprite ID |
| `color` | `number` | Blip color ID |
| `scale` | `number` | Blip scale |
| `label` | `string` | Blip label on the map |

### Shop Item Configuration

| Key | Type | Description |
|---|---|---|
| `id` | `string` | The inventory item name given on purchase |
| `label` | `string` | Display name in the shop UI |
| `description` | `string` | Description text in the shop UI |
| `icon` | `string` | FontAwesome icon class (used when `useItemImages = false`) |
| `price` | `number` | Price in dollars |
| `currency` | `string` | *(Optional)* Payment type: `'cash'`, `'bank'`, etc. |

## Placement Settings

```lua
useGizmo = false,
raycastDistance = 10.0,
raycastFlags = -1,
```

| Key | Default | Description |
|---|---|---|
| `useGizmo` | `false` | `true` = use `object_gizmo` for placement; `false` = use raycast placement |
| `raycastDistance` | `10.0` | Max distance for raycast placement (only used when `useGizmo = false`) |
| `raycastFlags` | `-1` | Raycast collision flags. `-1` = everything (works with housing shells). Default `339` may not detect shell interiors |

## Permissions

```lua
Permissions = {
    enabled = true,
},
```

When enabled, only the owner and players they explicitly add can use placed workbenches. A permissions tab appears in the UI for placed workbenches.

## History

```lua
History = {
    enabled = true,
    maxEntries = 100,
    ownerOnlyDelete = true,
    dateFormat = 'DMY',
},
```

| Key | Default | Description |
|---|---|---|
| `enabled` | `true` | Show the history tab in the UI. History is **always** saved to the database regardless of this setting |
| `maxEntries` | `100` | Maximum history entries per workbench. Oldest entries are removed when the limit is exceeded |
| `ownerOnlyDelete` | `true` | `true` = only the workbench owner can delete history entries; `false` = anyone with access can delete |
| `dateFormat` | `'DMY'` | Date display format: `'DMY'` for DD/MM/YYYY or `'MDY'` for MM/DD/YYYY |

## Placeable Workbenches

See the dedicated [Placeable Workbenches](/resources/crafting/placeable-workbenches) page for full details.

## Static Stations

```lua
Stations = {
    ['workbench'] = {
        label = 'Workbench',
        type = 'basic',
        coords = vector3(-1.89, -200.97, 52.74),
        heading = 340.7,
        radius = 2.0,
        recipes = { 'all', 'basic' },
        techTrees = { 'basic_survival', 'basic_exploration' },
        -- job = { name = 'mechanic', minGrade = 0 },
        -- gang = 'ballas',
        -- CraftingBehavior = { ... },
        prop = {
            enabled = true,
            model = 'prop_tool_bench02',
            spawnRadius = 50.0,
            offset = vector3(0.0, 0.0, -1.0),
        },
        blip = {
            enabled = true,
            sprite = 566,
            color = 2,
            scale = 0.7,
            label = 'Workbench',
        },
    },
},
```

### Station Configuration

| Key | Type | Required | Description |
|---|---|---|---|
| `label` | `string` | Yes | Display name in the UI and target prompt |
| `type` | `string` | Yes | Workbench type for per-workbench leveling (e.g. `'basic'`, `'advanced'`) |
| `coords` | `vector3` | Yes | World position of the station |
| `heading` | `number` | Yes | Heading for the prop (0-360) |
| `radius` | `number` | Yes | Interaction radius around the station |
| `recipes` | `table` | Yes | Array of recipe table names from `configs/recipes.lua` (e.g. `{ 'all', 'basic' }`) |
| `techTrees` | `table` | No | Array of tech tree IDs from `configs/techtrees.lua` |
| `job` | `table` | No | Job lock: `{ name = 'mechanic', minGrade = 0 }` |
| `gang` | `string` | No | Gang lock (QBCore only): `'ballas'` |
| `CraftingBehavior` | `table` | No | Override global crafting behavior for this station (partial overrides supported) |
| `prop` | `table` | No | Prop configuration (see below) |
| `blip` | `table` | No | Map blip configuration |

### Station Prop

| Key | Type | Description |
|---|---|---|
| `enabled` | `boolean` | Whether to spawn a prop at this station |
| `model` | `string` | GTA V prop model name |
| `spawnRadius` | `number` | Distance at which the prop spawns |
| `offset` | `vector3` | Offset from `coords` (use Z offset for ground level adjustment) |

## Logging

Logging is configured in a separate file: `sd-crafting/configs/logs.lua`. See the source file for the full list of configurable events, placeholders, and service options.

### Supported Services

| Service | Description |
|---|---|
| `'discord'` | Send logs to Discord via webhook |
| `'fivemanage'` | Send logs to Fivemanage dashboard |
| `'fivemerr'` | Send logs to Fivemerr (fm-logs) |
| `'loki'` | Send logs to Loki/Prometheus stack |
| `'grafana'` | Send logs to Grafana Cloud |
| `'none'` | Disable all logging |

### Logged Events

`craft_started`, `craft_completed`, `craft_failed`, `craft_cancelled`, `station_opened`, `station_closed`, `shop_purchase`, `shop_purchase_failed`, `blueprint_used`, `blueprint_broken`, `techtree_unlocked`, `xp_gained`, `level_up`, `error_occurred`

Each event can be individually enabled/disabled and customized with title, description, color (Discord only), and structured fields.
