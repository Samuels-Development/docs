# Installation

## Supported Inventories

| Inventory | Status |
|---|---|
| `ox_inventory` | Supported |
| `tgiann-inventory` | Supported |
| `jaksam_inventory` | Supported |
| `qs-inventory` | Supported |
| `qs-inventory-pro` | Supported |
| `origen_inventory` | Supported |
| `qb-inventory` | Supported |
| `ps-inventory` | Supported |
| `lj-inventory` | Supported |
| `codem-inventory` | Supported |

::: tip Recommendation
We heavily recommend using `ox_inventory` — it's the best inventory system available and more importantly, it's completely free and open source! You won't be missing out on any features in our scripts if you use a different inventory, this is simply a recommendation.
:::

## Dependencies

Ensure the following dependencies are installed and running on your server before starting:

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` / `qbx_core` / `es_extended` |
| **ox_lib** | Yes | |
| **oxmysql** | Yes | |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` |
| **Inventory** | Yes | Any of the supported inventories listed above |
| **object_gizmo** | Optional | For gizmo-based placement with full rotation control |

::: tip
Framework, target system, and inventory are all automatically detected and used — you don't need to configure any of it.
:::

## Step 1: Add the Resource

1. Download **sd-crafting** from your purchase and extract it into your server's `resources` folder.
2. Add the following to your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before.

```ini
ensure sd-crafting
```

::: tip
The database tables and framework detection are fully automatic. On first start the script will create all required tables via **oxmysql** and detect whether you are running `qb-core` or `es_extended`.
:::

## Step 2: Add Workbench Items to Your Inventory

Placeable workbenches are inventory items that players use to deploy a crafting station. The default items defined in `configs/config.lua` under `PlaceableWorkbenches` are `workbench` and `advanced_workbench`.

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['workbench'] = {
    label = 'Workbench',
    weight = 10000,
    stack = false,
    close = true,
    description = 'A portable workbench for basic crafting.',
    consume = 0,
    client = {
        image = 'workbench.png',
    },
    server = {
        export = 'sd-crafting.useWorkbench',
    },
},

['advanced_workbench'] = {
    label = 'Advanced Workbench',
    weight = 15000,
    stack = false,
    close = true,
    description = 'A high-tech workbench with advanced crafting capabilities.',
    consume = 0,
    client = {
        image = 'advanced_workbench.png',
    },
    server = {
        export = 'sd-crafting.useAdvanced_workbench',
    },
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['workbench'] = {
    name = 'workbench',
    label = 'Workbench',
    weight = 10000,
    type = 'item',
    image = 'workbench.png',
    unique = true,
    useable = true,
    shouldClose = true,
    description = 'A portable basic workbench for crafting.',
},

['advanced_workbench'] = {
    name = 'advanced_workbench',
    label = 'Advanced Workbench',
    weight = 15000,
    type = 'item',
    image = 'advanced_workbench.png',
    unique = true,
    useable = true,
    shouldClose = true,
    description = 'A portable advanced workbench for complex crafting.',
},
```

```sql [ESX]
-- Run in your database or import from [SQL] folder

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`)
VALUES
    ('workbench', 'Workbench', 10, 0, 1),
    ('advanced_workbench', 'Advanced Workbench', 15, 0, 1);
```

:::

::: warning
ESX stores weight in different units depending on your setup. Adjust the weight values to match your server's weight system.
:::

## Step 3: Copy Workbench Images

Copy the workbench images from `sd-crafting/images/` to your inventory's image folder. You can also download them directly below.

| Inventory | Image Path |
|---|---|
| ox_inventory | `ox_inventory/web/images/` |
| qb-inventory / ps-inventory | `<inventory>/html/images/` |
| qs-inventory | `qs-inventory/html/images/` |
| codem-inventory | `codem-inventory/html/itemimages/` |
| origen_inventory | `origen_inventory/ui/images/` |

<ItemImageGrid
  title="Crafting Item Images"
  zipName="sd-crafting-images"
  :images="[
    { src: '/items/crafting/workbench.png', name: 'workbench.png', alt: 'Workbench' },
    { src: '/items/crafting/advanced_workbench.png', name: 'advanced_workbench.png', alt: 'Advanced Workbench' },
  ]"
/>

::: tip
If you are using a custom inventory, place the images wherever your inventory loads item icons from.
:::

## Step 4: Restart

Restart your server or start the resource. On first boot you will see log output confirming:

1. Framework detected (QB / ESX)
2. Inventory system detected
3. Target system detected
4. Database tables created
5. Locale loaded

If anything is missing, check your server console for error messages. Enable `Debug = true` in `configs/config.lua` for verbose logging.

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./config-main) pages for detailed explanations of each setting, or edit the files directly in the `configs/` folder.
