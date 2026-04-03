# Blueprint Image Creator

sd-crafting includes a Node.js tool for generating blueprint-style inventory images. It overlays an existing item image onto a blueprint template, producing a ready-to-use icon for blueprint items.

## Overview

The tool lives in the `sd-crafting/tools/` directory and provides two scripts:

| Script | Purpose |
|---|---|
| `create-blueprint.js` | Create a single blueprint image |
| `batch-create.js` | Create multiple blueprint images from a folder or file list |

Both use [sharp](https://sharp.pixelplumbing.com/) for image processing and auto-detect your inventory system to find item images.

## Setup

Navigate to the `tools/` folder inside your sd-crafting resource and install dependencies:

```bash
cd resources/sd-crafting/tools
npm install
```

This installs `sharp`, the only dependency.

::: tip
You only need to run `npm install` once. After that you can run the scripts as many times as you like.
:::

## Templates

Three blueprint templates are included in `tools/blueprints/`:

| Template | File | Item Scale | Item Offset Y |
|---|---|---|---|
| **Default** | `template.png` | 0.45 | +3px |
| **Template 2** | `template_2.png` | 0.6 | 0 |
| **Template 3** | `template_3.png` | *(default: 0.6)* | 0 |

If no templates exist when you first run the tool, a default blueprint template is auto-generated from a built-in SVG (dark blue background with a grid pattern, corner accents, and "BLUEPRINT" text).

You can add your own templates by placing `.png` files in the `blueprints/` folder.

List all available templates:

```bash
node create-blueprint.js --list-templates
```

## Single Blueprint

### Basic Usage

```bash
node create-blueprint.js <item-name> [output-name] [options]
```

The tool auto-detects your inventory system by scanning up the directory tree for a `resources/` folder, then searching for known inventory resources (`ox_inventory`, `qb-inventory`, `qs-inventory`, etc.) and their image directories.

### Examples

Create a blueprint for `lockpick` using the default template:

```bash
node create-blueprint.js lockpick
```

This finds `lockpick.png` in your inventory's image folder, overlays it onto the default template, and saves `blueprint_lockpick.png` to the `output/` folder.

Use a different template:

```bash
node create-blueprint.js lockpick --bg 2
```

The `--bg` flag accepts template names flexibly — `2`, `template_2`, or `template_2.png` all resolve to `blueprints/template_2.png`.

Custom output name and tint:

```bash
node create-blueprint.js thermite blueprint_thermite --bg template_2 --tint #3b82f6
```

Override the auto-detected inventory images path:

```bash
node create-blueprint.js pistol --inventory "C:/server/resources/ox_inventory/web/images"
```

### All Options

| Option | Description | Default |
|---|---|---|
| `--bg <name>`, `-b <name>` | Select a template from the `blueprints/` folder | `template.png` |
| `--template <path>` | Use a custom template by full file path | `template.png` |
| `--size <WxH>` | Output image dimensions | `128x128` |
| `--item-scale <0-1>` | Scale of the item relative to the template | Per-template (0.45 or 0.6) |
| `--tint <hex>` | Apply a color tint to the item (e.g., `#3b82f6`) | None |
| `--inventory <path>` | Override auto-detected inventory images path | Auto-detected |
| `--list-templates`, `-l` | List all available templates and exit | -- |

::: info
When `--item-scale` is not specified, the tool uses per-template scale settings defined in the script. Template 1 uses 0.45 (smaller item), Template 2 uses 0.6 (larger item). If you pass `--item-scale`, it overrides the template setting.
:::

### Image Search Order

When you provide an item name like `lockpick`, the tool searches for the image in this order:

1. Your inventory's auto-detected image folder (e.g., `ox_inventory/web/images/lockpick.png`)
2. The `tools/` directory itself
3. A `tools/items/` subdirectory
4. The raw path as provided

### Supported Inventories (Auto-Detection)

| Inventory | Image Path |
|---|---|
| `ox_inventory` | `web/images/` |
| `qs-inventory` | `html/images/` |
| `qs-inventory-pro` | `html/images/` |
| `qb-inventory` | `html/images/` |
| `ps-inventory` | `html/images/` |
| `lj-inventory` | `html/images/` |
| `codem-inventory` | `html/itemimages/` |

The tool walks up from the `tools/` directory looking for a `resources/` folder, then searches within it for any of these inventory resources.

## Batch Blueprint Creation

Process an entire folder of item images or a specific list of files at once.

### From a Folder

```bash
node batch-create.js <items-folder> [options]
```

Examples:

```bash
# Process all images in your ox_inventory images folder
node batch-create.js C:/server/resources/ox_inventory/web/images

# Only process weapon images
node batch-create.js C:/server/resources/ox_inventory/web/images --filter "weapon_"

# Process a local items folder
node batch-create.js ./items
```

### From a File List

```bash
node batch-create.js --list <file1> <file2> ...
```

Example:

```bash
node batch-create.js --list lockpick.png thermite.png armour.png
```

### Batch Options

| Option | Description | Default |
|---|---|---|
| `--list` | Process a list of specific files instead of a folder | -- |
| `--filter <pattern>` | Regex filter — only process matching filenames | None |
| `--template <path>` | Custom blueprint template | `template.png` |
| `--size <WxH>` | Output image dimensions | `128x128` |
| `--item-scale <0-1>` | Scale of the item relative to the template | `0.6` |

All output files are saved to `tools/output/` with a `blueprint_` prefix (e.g., `lockpick.png` → `blueprint_lockpick.png`).

Supported input formats: `.png`, `.jpg`, `.jpeg`, `.webp`.

## Output

Both scripts save generated images to `sd-crafting/tools/output/`. After generating:

1. Copy the blueprint images from `tools/output/` to your inventory's image folder
2. Register the blueprint items in your inventory system
3. Reference them in your recipe config via the `blueprint` field

## Adding Blueprint Items to Your Inventory

::: code-group

```lua [ox_inventory]
['blueprint_lockpick'] = {
    label = 'Lockpick Blueprint',
    weight = 100,
    stack = false,
    close = false,
    description = 'A technical blueprint for crafting lockpicks.',
},
```

```lua [qb-core]
['blueprint_lockpick'] = {
    name = 'blueprint_lockpick',
    label = 'Lockpick Blueprint',
    weight = 100,
    type = 'item',
    image = 'blueprint_lockpick.png',
    unique = true,
    useable = false,
    shouldClose = false,
    description = 'A technical blueprint for crafting lockpicks.',
},
```

:::

## Linking Blueprints to Recipes

Reference the blueprint item in your recipe configuration (`configs/recipes.lua`):

```lua
{
    id = 'advancedlockpick',
    name = 'advancedlockpick',
    craftTime = 10,
    category = 'tools',
    blueprint = 'blueprint_advancedlockpick',  -- Player must attach this to the workbench
    blueprintDurabilityLoss = 5,               -- Optional: override default durability loss per craft
    ingredients = {
        { item = 'lockpick', amount = 1 },
        { item = 'steel', amount = 2 },
    },
},
```

### How Blueprints Work In-Game

1. The player places the blueprint item into the crafting inventory (staging area).
2. In the **Blueprints** tab of the crafting UI, the player attaches the blueprint to the workbench.
3. The recipe gated by that blueprint becomes visible and craftable.
4. Each craft degrades the blueprint's durability (if the durability system is enabled).
5. When durability reaches zero, the blueprint breaks and must be replaced.

### Blueprint Durability vs Legacy Destruction

There are two systems for blueprint consumption, configured in `configs/config.lua` under `Blueprints`:

| System | Key | Behavior |
|---|---|---|
| **Durability** | `durability.enabled = true` | Blueprint loses durability per craft (ox_inventory only). Overrides legacy system |
| **Legacy** | `destroyOnCraft.enabled = true` | Random chance to destroy the blueprint each craft. Works with any inventory |

See the [main config](/resources/crafting/config-main#blueprints) for full configuration details.

::: warning
Generated images overwrite existing files with the same name in the output directory. Double-check your output names to avoid accidentally replacing images.
:::
