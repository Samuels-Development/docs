# Tech Tree Configuration

Tech trees define skill progression paths that gate access to recipes. They are configured in `sd-crafting/configs/techtrees.lua`. The file returns a Lua table with global settings and a `Trees` table containing all tree definitions.

## Overview

The tech tree system lets you create branching skill trees where players spend **tech points** to unlock nodes. Each node unlocks a recipe that would otherwise be hidden from the crafting menu. Players earn tech points through crafting (via `techPointsReward` on recipes).

Tech trees are assigned to stations and workbenches independently using the `techTrees` field in `configs/config.lua`.

## Global Settings

```lua
return {
    enabled = true,
    perWorkbenchType = true,
    defaultTechPointsPerCraft = {
        enabled = false,
        amount = 1,
    },
    sharedPlacedWorkbench = {
        enabled = true,
    },
    Trees = { ... },
}
```

| Key | Default | Description |
|---|---|---|
| `enabled` | `true` | Master toggle for the entire tech tree system |
| `perWorkbenchType` | `true` | `true` = players have separate tech points and unlocks per workbench type; `false` = shared globally |

### defaultTechPointsPerCraft

| Key | Default | Description |
|---|---|---|
| `enabled` | `false` | When `false`, recipes without a `techPointsReward` field give no tech points |
| `amount` | `1` | Default tech points when a recipe does not specify `techPointsReward` |

### sharedPlacedWorkbench

| Key | Default | Description |
|---|---|---|
| `enabled` | `true` | When `true`, all players using the same **placed** workbench share tech points and unlocked nodes. Does **not** affect static stations (those are always per-player) |

## Assigning Trees to Workbenches

In `configs/config.lua`, each station or placeable workbench specifies which trees to use:

```lua
-- Static station
Stations = {
    ['workbench'] = {
        techTrees = { 'basic_survival', 'basic_exploration' },
        ...
    },
},

-- Placeable workbench
PlaceableWorkbenches = {
    ['workbench'] = {
        techTrees = { 'basic_survival', 'basic_exploration' },
        ...
    },
    ['advanced_workbench'] = {
        techTrees = { 'technology', 'exploration', 'survival', 'engineering' },
        ...
    },
},
```

You can create any tree IDs you want and mix/match them per workbench.

## Tree Structure

Each tree is defined inside the `Trees` table with a unique key:

```lua
Trees = {
    ['basic_survival'] = {
        label = 'Basic Survival',
        icon = 'heart-pulse',
        color = '#ef4444',
        nodes = { ... },
    },
},
```

| Field | Type | Description |
|---|---|---|
| `label` | `string` | Display name shown in the UI |
| `icon` | `string` | Lucide icon name (see [lucide.dev/icons](https://lucide.dev/icons)) |
| `color` | `string` | Hex color for the tree in the UI |
| `nodes` | `table` | Array of unlock nodes |

## Node Structure

Each node represents a single unlock in the tree:

```lua
{
    id = 'firstaid_node',
    recipeId = 'firstaid',
    cost = 5,
    prerequisites = {},
    position = { row = 1, col = 2 },
},
```

| Field | Type | Description |
|---|---|---|
| `id` | `string` | Unique identifier for the node within the tree |
| `recipeId` | `string` | Recipe `id` (from `configs/recipes.lua`) that this node unlocks |
| `cost` | `number` | Tech points required to unlock this node |
| `prerequisites` | `table` | Array of node `id` strings that must be unlocked first |
| `position` | `table` | Grid position in the tree UI: `{ row = <number>, col = <number> }` |

::: warning
**Important:** If a recipe is listed as a tech tree unlock via `recipeId`, it will **not** appear in the crafting menu until unlocked -- even if it is in a recipe table assigned to that workbench. The tech tree acts as a gate.
:::

## Prerequisites

Prerequisites create the branching structure of the tree:

```lua
-- Root node (no prerequisites)
{
    id = 'firstaid_node',
    recipeId = 'firstaid',
    cost = 5,
    prerequisites = {},
    position = { row = 1, col = 2 },
},

-- Single prerequisite
{
    id = 'splint_node',
    recipeId = 'splint',
    cost = 8,
    prerequisites = { 'firstaid_node' },
    position = { row = 2, col = 2 },
},

-- Multiple prerequisites (all must be unlocked)
{
    id = 'welding_torch_node',
    recipeId = 'welding_torch',
    cost = 25,
    prerequisites = { 'drill_node', 'powersaw_node' },
    position = { row = 3, col = 2 },
},
```

::: info
When a node has multiple prerequisites, **all** of them must be unlocked before the player can purchase it. This lets you create convergence points that require mastery of multiple branches.
:::

## Included Example Trees

The default configuration includes six tech trees:

| Tree ID | Label | Nodes | Used By |
|---|---|---|---|
| `basic_survival` | Basic Survival | 5 | Basic workbench |
| `basic_exploration` | Basic Exploration | 2 | Basic workbench |
| `technology` | Tools & Technology | 14 | Advanced workbench |
| `exploration` | Exploration | 13 | Advanced workbench |
| `survival` | Survival | 12 | Advanced workbench |
| `engineering` | Engineering | 11 | Advanced workbench |

## Full Example Tree

```lua
['basic_survival'] = {
    label = 'Basic Survival',
    icon = 'heart-pulse',
    color = '#ef4444',
    nodes = {
        {
            id = 'firstaid_node',
            recipeId = 'firstaid',
            cost = 5,
            prerequisites = {},
            position = { row = 1, col = 2 },
        },
        {
            id = 'hunting_bait_2_node',
            recipeId = 'hunting_bait_2',
            cost = 3,
            prerequisites = {},
            position = { row = 1, col = 4 },
        },
        {
            id = 'splint_node',
            recipeId = 'splint',
            cost = 8,
            prerequisites = { 'firstaid_node' },
            position = { row = 2, col = 2 },
        },
        {
            id = 'hunting_bait_3_node',
            recipeId = 'hunting_bait_3',
            cost = 8,
            prerequisites = { 'hunting_bait_2_node' },
            position = { row = 2, col = 4 },
        },
        {
            id = 'hunting_trap_node',
            recipeId = 'hunting_trap',
            cost = 10,
            prerequisites = { 'hunting_bait_2_node' },
            position = { row = 2, col = 5 },
        },
    },
},
```

## Tree Design Tips

- **Root nodes** (no prerequisites) should be the entry points at the top of each tree (row 1). Keep costs low.
- **Mid-tier nodes** introduce branching -- let players specialize.
- **Convergence nodes** (multiple prerequisites) create powerful capstone rewards that require investment in multiple branches.
- **Position carefully** using `row` and `col` to create a visually clear layout. The UI renders a grid-based graph.
- Every `recipeId` referenced in a node must exist in your [recipe configuration](/resources/crafting/config-recipes) with a matching `id`.

::: tip
The admin panel (`/craftadmin`) allows you to create, edit, and delete tech trees and nodes live in-game. Changes persist to the database.
:::
