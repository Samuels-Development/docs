# Placeable Workbenches

Placeable workbenches allow players to deploy their own crafting stations in the world. This is ideal for player-owned bases, gang hideouts, or any scenario where fixed workbench locations are not sufficient.

## Overview

Players use a workbench item from their inventory to place a prop in the world. The placed workbench functions identically to a static station of the same type -- it supports all the same recipes, leveling, tech trees, and queue features. Placed workbenches persist across server restarts and can be picked up by the owner.

## Default Workbench Types

sd-crafting ships with two placeable workbench types:

| Item Key | Label | Type | Prop Model | Recipe Tables | Tech Trees |
|---|---|---|---|---|---|
| `workbench` | Basic Workbench | `basic` | `prop_tool_bench02` | `all`, `basic` | `basic_survival`, `basic_exploration` |
| `advanced_workbench` | Advanced Workbench | `advanced` | `gr_prop_gr_bench_04b` | `all`, `basic`, `advanced` | `technology`, `exploration`, `survival`, `engineering` |

## Configuration

Placeable workbenches are defined in the `PlaceableWorkbenches` table in `configs/config.lua`:

```lua
PlaceableWorkbenches = {
    ['workbench'] = {
        label = 'Basic Workbench',
        type = 'basic',
        prop = 'prop_tool_bench02',
        recipes = { 'all', 'basic' },
        techTrees = { 'basic_survival', 'basic_exploration' },
        -- job = { name = 'mechanic', minGrade = 0 },
        -- gang = 'ballas',
        -- CraftingBehavior = { ... },
    },
},
```

### Field Reference

| Field | Type | Required | Description |
|---|---|---|---|
| `label` | `string` | Yes | Display name shown in the UI and target prompt |
| `type` | `string` | Yes | Workbench type for per-workbench leveling (e.g. `'basic'`, `'advanced'`). Matches types in `Leveling.workbenchTypes` |
| `prop` | `string` | Yes | GTA V prop model name for the placed object |
| `recipes` | `table` | Yes | Array of recipe table names from `configs/recipes.lua` (e.g. `{ 'all', 'basic' }`) |
| `techTrees` | `table` | No | Array of tech tree IDs from `configs/techtrees.lua` |
| `job` | `table` | No | Job restriction: `{ name = 'mechanic', minGrade = 0 }`. `minGrade` is optional and defaults to `0` |
| `gang` | `string` | No | Gang restriction (QBCore only): `'ballas'` |
| `CraftingBehavior` | `table` | No | Override global `CraftingBehavior` for this workbench type. Only include settings you want to change -- missing settings use global defaults |

### CraftingBehavior Override Example

```lua
['workbench'] = {
    label = 'Basic Workbench',
    type = 'basic',
    prop = 'prop_tool_bench02',
    recipes = { 'all', 'basic' },
    CraftingBehavior = {
        preventCloseWhileCrafting = false,
        allowCraftingAnywhere = { enabled = true, notifyPlayer = true },
        sharedCrafting = { placed = true },
    },
},
```

Only the settings you include are overridden. Everything else falls back to the global `CraftingBehavior` in `configs/config.lua`.

## Creating a New Workbench Type

### Step 1: Define the Workbench

Add a new entry to `PlaceableWorkbenches` in `configs/config.lua`:

```lua
PlaceableWorkbenches = {
    -- Existing workbenches...

    ['medical_workbench'] = {
        label = 'Medical Station',
        type = 'medical',
        prop = 'prop_med_bag_01b',
        recipes = { 'all', 'medical' },
        techTrees = { 'medical_tree' },
        job = { name = 'ambulance', minGrade = 0 },  -- Optional: restrict to EMS
    },
},
```

### Step 2: Create the Recipe Table

Add a `'medical'` table to `configs/recipes.lua`:

```lua
['medical'] = {
    {
        id = 'medkit',
        name = 'firstaid',
        craftTime = 15,
        category = 'healing',
        xpReward = 40,
        levelRequired = 1,
        ingredients = {
            { item = 'bandage', amount = 3 },
            { item = 'painkillers', amount = 2 },
        },
    },
},
```

### Step 3: Register the Inventory Item

Add the item to your inventory system following the same format shown in the [installation guide](/resources/crafting/installation#step-2-add-workbench-items-to-your-inventory).

::: tip ox_inventory export naming
For `ox_inventory`, the `server.export` value must follow the pattern:

```
sd-crafting.use<ItemKey>
```

The item key is used **verbatim** with **only the first letter capitalized** — underscores and remaining casing are preserved. The resource auto-generates one export per entry in `PlaceableWorkbenches`, so as long as the export name matches the item key, no extra code is required on your side.

| Item key (in `PlaceableWorkbenches`) | `server.export` value |
|---|---|
| `workbench` | `sd-crafting.useWorkbench` |
| `advanced_workbench` | `sd-crafting.useAdvanced_workbench` |
| `medical_workbench` | `sd-crafting.useMedical_workbench` |
| `workbenchtest1` | `sd-crafting.useWorkbenchtest1` |
:::

#### Example (ox_inventory)

For a new workbench keyed as `workbenchtest1`, add the following to your `ox_inventory/data/items.lua`:

```lua
['workbenchtest1'] = {
    label = 'Workbench Test 1',
    weight = 10000,
    stack = false,
    close = true,
    description = 'A portable workbench for testing.',
    consume = 0,
    client = {
        image = 'workbenchtest1.png',
    },
    server = {
        export = 'sd-crafting.useWorkbenchtest1',
    },
},
```

### Step 4: (Optional) Add Leveling Config

If you want custom leveling for the new type, add it to `Leveling.workbenchTypes`:

```lua
workbenchTypes = {
    ['medical'] = {
        levels = {
            [1] = 0, [2] = 150, [3] = 400, [4] = 800, [5] = 1500,
        },
        maxLevel = 5,
    },
},
```

### Step 5: (Optional) Add a Shop Entry

To let players buy the workbench from an NPC, add it to a shop in `Shops`:

```lua
items = {
    {
        id = 'medical_workbench',
        label = 'Medical Station',
        description = 'A portable medical crafting station',
        icon = 'fa-solid fa-kit-medical',
        price = 10000,
    },
},
```

## Shared vs Per-Player Behavior

Placed workbenches support both shared and per-player modes for crafting queues and staged items. These are controlled by the `CraftingBehavior.sharedCrafting` and `InventoryPanel.perWorkbench` settings in the main config.

### Crafting Queue

| Setting | Behavior |
|---|---|
| `sharedCrafting.placed = true` (default) | All players using a placed workbench share the same crafting queue |
| `sharedCrafting.placed = false` | Each player has their own independent queue per placed workbench |

### Staged Items

| Setting | Behavior |
|---|---|
| `InventoryPanel.perWorkbench.placed = true` (default) | Staged items are shared per-workbench -- all users see the same items |
| `InventoryPanel.perWorkbench.placed = false` | Each player has their own staged items per workbench |

### Tech Tree

| Setting | Behavior |
|---|---|
| `sharedPlacedWorkbench.enabled = true` (default) | All players using the same placed workbench share tech points and unlocked nodes |
| `sharedPlacedWorkbench.enabled = false` | Each player has their own tech progress (still per workbench type if `perWorkbenchType` is true) |

## Permissions System

When `Permissions.enabled = true` (default), placed workbenches have an access control system:

- Only the **owner** (the player who placed it) can use the workbench initially.
- The owner can add other players by their server source ID via the **Permissions** tab in the UI.
- Added players can use the workbench for crafting but cannot manage permissions.
- The owner can remove players from the access list at any time.

## Crafting History

When `History.enabled = true` (default), placed workbenches display a **History** tab showing:

- Who crafted what item
- Timestamps of crafting events
- Configurable date format (`DMY` or `MDY`)

History is **always saved** to the database regardless of the UI setting. The `enabled` flag only controls whether the tab is visible.

| Setting | Default | Description |
|---|---|---|
| `History.maxEntries` | `100` | Maximum entries per workbench (oldest removed when exceeded) |
| `History.ownerOnlyDelete` | `true` | Only the owner can delete history entries |
| `History.dateFormat` | `'DMY'` | `'DMY'` for DD/MM/YYYY or `'MDY'` for MM/DD/YYYY |

## Placement Behavior

### Raycast Placement (default)

When `useGizmo = false`, the player enters a point-and-place mode:

1. The item is removed from the player's inventory.
2. A ghost preview of the prop follows the player's aim.
3. The player can rotate the prop and confirm placement.
4. The workbench is saved to the database and persists across restarts.

Configuration:

```lua
useGizmo = false,
raycastDistance = 10.0,  -- Max placement distance
raycastFlags = -1,       -- -1 = detect everything (including housing shells)
```

### Gizmo Placement

When `useGizmo = true`, the `object_gizmo` resource is used for full 3D positioning and rotation:

1. The item is removed from the player's inventory.
2. The gizmo tool activates, allowing free positioning and rotation.
3. Press **ENTER** to confirm, **BACKSPACE** to cancel.
4. The workbench is saved to the database.

::: warning
Gizmo placement requires the `object_gizmo` resource to be installed and started.
:::

### Picking Up a Workbench

The owner can pick up a placed workbench via the target interaction. A confirmation dialog will appear warning that items in the crafting inventory may be lost. On confirmation:

1. The workbench prop is removed from the world.
2. The workbench item is returned to the player's inventory.
3. The database record is deleted.

::: warning
Make sure to remove all items from the crafting inventory before picking up a workbench, as staged items will be lost.
:::

## Choosing a Prop Model

The `prop` field accepts any valid GTA V prop model name. When selecting a prop:

- Choose a model that visually represents a workstation or crafting surface.
- Ensure the prop has reasonable collision so it sits naturally on the ground.
- Test placement indoors and outdoors -- some props clip through floors or walls.

You can browse GTA V prop models on community sites or use a prop spawner in-game to preview models before committing to one. The admin command `/placeworkbench` can also be used to test prop placement and get coordinates for static stations.
