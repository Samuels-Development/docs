# Installation

## Supported Inventories

| Inventory | Status |
|---|---|
| `ox_inventory` | Fully supported |
| `tgiann-inventory` | Supported |
| `jaksam_inventory` | Supported |
| `qs-inventory` | Supported |
| `qs-inventory-pro` | Supported |
| `qb-inventory` | Supported |
| `ps-inventory` | Supported |
| `lj-inventory` | Supported |
| `codem-inventory` | Supported |

## Dependencies

Ensure the following resources are installed and running **before** sd-traphouse:

| Dependency | Options |
|---|---|
| **Framework** | `qb-core` / `qbx_core` / `es_extended` |
| **Library** | `sd_lib` (required) |
| **Target System** | `ox_target` / `qb-target` / `qtarget` |
| **Doorlock** | `ox_doorlock` / `qb-nui_doorlock` |
| **Minigame** | Any one of 30+ supported resources |

::: info
Framework, inventory, and target system are all auto-detected via sd_lib. No custom database tables are created -- all state is managed in memory during active robberies.
:::

## Step 1: Add the Resource

1. Download `sd-traphouse` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add `ensure sd-traphouse` to your `server.cfg` **after** all dependencies

```ini
ensure sd_lib
ensure ox_lib
ensure ox_target
ensure ox_doorlock
ensure sd-traphouse
```

## Step 2: Import Doorlock Data

Import the front door entry for your doorlock system:

::: code-group

```sql [ox_doorlock]
-- Import sd-traphouse/doorlock/ox_doorlock/traphouse.sql into your database
-- This creates 1 door entry: traphouse-front
```

```lua [qb-nui_doorlock]
-- Copy the contents of sd-traphouse/doorlock/qb-nui_doorlock/traphouse.lua
-- into your qb-nui_doorlock config file
```

:::

## Step 3: Add Items

Register the required items in your inventory system:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['gang-keychain'] = {
    label = 'Keychain',
    weight = 50,
    stack = true,
    close = true,
    description = 'A keychain with a load of oddly labelled keys',
},
['safecracker'] = {
    label = 'Safe Cracker',
    weight = 500,
    stack = true,
    close = true,
    description = 'A specialized tool used for breaking into safes.',
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['gang-keychain'] = { name = 'gang-keychain', label = 'Gang Keychain', weight = 20,  type = 'item', image = 'gang-keychain.png', unique = true,  useable = false, shouldClose = true, description = 'A keychain with a load of oddly labelled keys' },
['safecracker']   = { name = 'safecracker',   label = 'Safe Cracker',  weight = 500, type = 'item', image = 'safecracker.png',   unique = true,  useable = false, shouldClose = true, description = 'A specialized tool used for breaking into safes.' },
```

:::

## Step 4: Copy Item Images

Copy the item images from `sd-traphouse/images/` to your inventory's image folder:

| Inventory | Image Path |
|---|---|
| ox_inventory | `ox_inventory/web/images/` |
| qb-inventory / ps-inventory | `<inventory>/html/images/` |
| qs-inventory | `qs-inventory/html/images/` |
| codem-inventory | `codem-inventory/html/itemimages/` |
| origen_inventory | `origen_inventory/ui/images/` |

<ItemImageGrid
  title="Traphouse Item Images"
  zipName="sd-traphouse-images"
  :images="[
    { src: '/items/traphouse/gang-keychain.png', name: 'gang-keychain.png', alt: 'Gang Keychain' },
    { src: '/items/traphouse/safecracker.png', name: 'safecracker.png', alt: 'Safecracker' },
  ]"
/>

::: tip
If you are using a custom inventory, place the images wherever your inventory loads item icons from.
:::

## Step 5: Start and Verify

1. Start your server
2. Check the server console for any errors
3. If `Config.Blip.Enable` is true, look for the **Vagos Traphouse** blip on the map
4. Ensure the minimum police requirement is met before attempting the robbery

::: warning
Make sure `sd_lib` is started **before** sd-traphouse in your server.cfg, or the resource will fail to load.
:::

::: tip
No database tables are required. All robbery state is managed in memory and resets on server restart.
:::
