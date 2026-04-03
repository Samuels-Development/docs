# Recipe Configuration

Recipes are defined in `sd-crafting/configs/recipes.lua`. The file returns a Lua table where each key is a **table name** (e.g. `'all'`, `'basic'`, `'advanced'`) and each value is an array of recipe definitions. Stations and placeable workbenches specify which recipe tables to use, allowing flexible mix-and-match.

## Recipe Tables

Recipes are organized into named tables:

```lua
return {
    ['all'] = {
        -- Recipes available at every workbench that includes 'all'
    },
    ['basic'] = {
        -- Recipes for basic workbenches
    },
    ['advanced'] = {
        -- Recipes for advanced workbenches
    },
}
```

In `configs/config.lua`, each station or placeable workbench specifies which tables to include:

```lua
-- Static station
['my_station'] = { recipes = { 'all', 'basic' }, ... }

-- Placeable workbench
['workbench'] = { recipes = { 'all', 'basic' }, ... }
```

You can create any table names you want and mix/match them per workbench.

## Recipe Structure

```lua
{
    id = 'lockpick',                    -- Unique recipe identifier
    name = 'lockpick',                  -- Item name in your inventory system
    craftTime = 5,                      -- Craft time in seconds
    ingredients = {                     -- Required input items
        { item = 'metalscrap', amount = 2 },
        { item = 'iron', amount = 1 },
    },

    -- All fields below are OPTIONAL --
    label = 'Custom Name',             -- Override auto-fetched label
    category = 'tools',                -- Category for filtering in the UI
    xpReward = 10,                     -- XP reward on successful craft
    techPointsReward = 1,              -- Tech points reward on successful craft
    levelRequired = 1,                 -- Minimum level required
    cost = 500,                        -- Money cost to craft
    failChance = 25,                   -- Percentage chance (0-100) to fail
    blueprint = 'blueprint_lockpick',  -- Required blueprint item name
    blueprintDurabilityLoss = 5,       -- Blueprint durability lost per craft
    outputAmount = 1,                  -- Items produced per craft (default: 1)
    tools = { ... },                   -- Required tools (see below)
    image = 'nui://ox_inventory/web/images/custom.png', -- Override recipe image
    metadata = { ... },                -- Metadata applied to crafted item
    showMetadata = { ... },            -- ox_inventory tooltip display
},
```

## Field Reference

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| `id` | `string` | Yes | -- | Unique identifier for the recipe (also used by tech trees) |
| `name` | `string` | Yes | -- | The item name in your inventory system (what gets given to the player) |
| `craftTime` | `number` | Yes | -- | Crafting time in seconds |
| `ingredients` | `table` | Yes | -- | Array of required input items |
| `label` | `string` | No | Auto-fetched | Override the label auto-fetched from the inventory system |
| `category` | `string` | No | -- | Category name for filtering in the UI |
| `xpReward` | `number` | No | Config default | XP awarded on success. Uses the global `defaultXpReward` if not specified |
| `techPointsReward` | `number` | No | Config default | Tech points awarded on success. Uses `defaultTechPointsPerCraft` if not specified |
| `levelRequired` | `number` | No | -- | Minimum crafting level required |
| `cost` | `number` | No | -- | Money cost deducted when crafting |
| `failChance` | `number` | No | `0` | Percentage chance of failure (0-100) |
| `blueprint` | `string` | No | -- | Item name of the required blueprint |
| `blueprintDurabilityLoss` | `number` | No | Config default | Durability lost from the blueprint per craft (uses `Blueprints.durability.defaultLoss` if not set) |
| `outputAmount` | `number` | No | `1` | Number of items produced per craft |
| `tools` | `table` | No | -- | Array of required tools |
| `image` | `string` | No | Auto-detected | Override the recipe image shown in the crafting UI |
| `metadata` | `table` | No | -- | Key-value pairs applied to the crafted item |
| `showMetadata` | `table` | No | -- | ox_inventory only: key-value pairs for tooltip display |

::: tip
**Labels are auto-fetched.** Recipe and ingredient labels are automatically retrieved from your inventory system. You only need to set `label` if you want to override the default name.
:::

## Ingredients

Each ingredient is a table with an `item` name and `amount`:

```lua
ingredients = {
    { item = 'metalscrap', amount = 2 },
    { item = 'iron', amount = 1 },
    -- { item = 'special', amount = 1, label = 'Custom Label' },  -- label is optional
},
```

All ingredient items must be present in the player's crafting inventory (staging area) before the craft can begin. They are consumed when the craft starts.

## Tools

Tools are items that must be present in the crafting inventory to craft. Unlike ingredients, tools have configurable consumption behavior.

```lua
tools = {
    { item = 'hammer', amount = 1, consumptionType = 'none' },
    { item = 'drill', amount = 1, consumptionType = 'durability', durabilityLoss = 5 },
    { item = 'sandpaper', amount = 1, consumptionType = 'chance', consumeChance = 25 },
    { item = 'glue', amount = 1, consumptionType = 'consume' },
},
```

### Consumption Types

| Type | Description |
|---|---|
| `'none'` | Never consumed -- just needs to be present in the crafting inventory |
| `'durability'` | Loses durability each craft (ox_inventory only). Uses `durabilityLoss` per craft, or the global `Tools.durability.defaultLoss` if not specified |
| `'chance'` | Percentage chance to break per craft. Set via `consumeChance` (0-100) |
| `'consume'` | Always consumed like an ingredient |

### Tool Field Reference

| Field | Type | Required | Description |
|---|---|---|---|
| `item` | `string` | Yes | Tool item name in your inventory |
| `amount` | `number` | Yes | Quantity required |
| `consumptionType` | `string` | Yes | One of `'none'`, `'durability'`, `'chance'`, `'consume'` |
| `durabilityLoss` | `number` | No | Durability lost per craft (only for `'durability'` type) |
| `consumeChance` | `number` | No | Percentage chance to break (only for `'chance'` type) |

::: info
The tool system must be enabled globally via `Tools.enabled = true` in `configs/config.lua`. Tool durability requires `Tools.durability.enabled = true` and **ox_inventory**.
:::

## Blueprints

When a recipe has a `blueprint` set, the player must have the blueprint item attached to the workbench to see and craft the recipe:

```lua
{
    id = 'advancedlockpick',
    name = 'advancedlockpick',
    blueprint = 'blueprint_advancedlockpick',
    blueprintDurabilityLoss = 5,  -- Optional: override default durability loss
    ...
},
```

The blueprint degrades with use (if durability is enabled). Once durability reaches zero, the blueprint breaks and must be replaced.

## Metadata

Metadata is a key-value table applied to the crafted item. It works with ox_inventory, qb-inventory, qs-inventory, codem-inventory, and origen_inventory.

```lua
{
    id = 'premium_wood_planks',
    name = 'wood_planks',
    label = 'Premium Wood Planks',
    metadata = {
        description = 'Master-crafted premium wooden planks',
        quality = 'Master',
        crafted = 'Yes',
    },
    showMetadata = {  -- ox_inventory only
        quality = 'Quality',
        crafted = 'Handmade',
    },
    ...
},
```

### Special Metadata Keys (ox_inventory)

These metadata keys have special behavior:

| Key | Effect |
|---|---|
| `label` | Overrides the display name of the item |
| `description` | Description shown in item tooltip |
| `weight` | Overrides item weight |
| `image` | Image path for the item (also used for recipe display in crafting UI) |
| `imageurl` | URL to image for the item (also used for recipe display in crafting UI) |

### Image Priority

When determining which image to display for a recipe:

1. `recipe.image` (explicit override)
2. `metadata.image` (from metadata)
3. `metadata.imageurl` (from metadata URL)
4. Auto-detected from inventory system

## Tech Tree Gating

If a recipe is listed as a tech tree unlock (via `recipeId` in `configs/techtrees.lua`), it will **not** appear in the crafting menu until unlocked -- even if it is in a recipe table assigned to that workbench/station. The tech tree acts as a gate for those recipes.

## Categories

Categories are defined implicitly by the `category` field on recipes. Any unique category name will automatically create a filter in the crafting UI.

Common category examples: `'materials'`, `'tools'`, `'medical'`, `'hunting'`, `'protection'`, `'exploration'`, `'consumables'`, `'misc'`

## Full Example

```lua
return {
    ['all'] = {
        {
            id = 'wood_planks',
            name = 'wood_planks',
            craftTime = 3,
            category = 'materials',
            outputAmount = 25,
            levelRequired = 1,
            ingredients = {
                { item = 'wood', amount = 2 },
            },
        },
    },

    ['basic'] = {
        {
            id = 'lockpick',
            name = 'lockpick',
            craftTime = 5,
            category = 'tools',
            xpReward = 10,
            techPointsReward = 1,
            cost = 500,
            ingredients = {
                { item = 'metalscrap', amount = 2 },
                { item = 'iron', amount = 1 },
            },
        },
        {
            id = 'bandage',
            name = 'bandage',
            craftTime = 3,
            category = 'medical',
            xpReward = 5,
            ingredients = {
                { item = 'deerhide', amount = 1 },
            },
        },
    },

    ['advanced'] = {
        {
            id = 'advancedlockpick',
            name = 'advancedlockpick',
            craftTime = 10,
            category = 'tools',
            xpReward = 35,
            techPointsReward = 3,
            levelRequired = 4,
            blueprint = 'blueprint_advancedlockpick',
            ingredients = {
                { item = 'lockpick', amount = 1 },
                { item = 'steel', amount = 2 },
            },
        },
    },
}
```

::: tip
Keep recipe `id` values unique across **all** tables. The ID is used internally for queue persistence, tech tree references, and leveling.
:::
