# Installation

## Supported Inventories

| Inventory | Status |
|---|---|
| `ox_inventory` | Supported |
| `tgiann-inventory` | Supported |
| `jaksam_inventory` | Supported |
| `qs-inventory` | Supported |
| `qs-inventory-pro` | Supported |
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
| **sd_lib** | Yes | |
| **PolyZone** | Yes | |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` / TextUI fallback |
| **Inventory** | Yes | Any of the supported inventories listed above |

::: tip
Framework, target system, and inventory are all automatically detected and used — you don't need to configure any of it.
:::

## Step 1: Add the Resource

1. Download `sd-cokemission` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add the following to your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before.

```ini
ensure sd_lib
ensure ox_lib
ensure PolyZone
ensure ox_target
ensure sd-cokemission
```

## Step 2: Add Items

If using the sealed cache system (`Config.UsingSealedCache = true`), register these items:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['sealed_cache'] = {
    label = 'Sealed Cache',
    weight = 15000,
    stack = false,
    close = false,
    description = 'A heavy and resilient lockbox',
    server = {
        export = 'sd-cokemission.useSealed_cache',
    },
},
['cache_key'] = {
    label = 'Cache Key',
    weight = 500,
    stack = false,
    close = true,
    description = 'Key used for lock boxes',
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['sealed_cache'] = { name = 'sealed_cache', label = 'Sealed Cache', weight = 15000, type = 'item', image = 'sealed_cache.png', unique = true, useable = true, shouldClose = false, description = 'A heavy and resilient lockbox' },
['cache_key']    = { name = 'cache_key',    label = 'Cache Key',    weight = 500,   type = 'item', image = 'cache_key.png',    unique = true, useable = true, shouldClose = true,  description = 'Key used for lock boxes' },
```

```sql [ESX]
-- Import sd-cokemission/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('sealed_cache', 'Sealed Cache', 150),
  ('cache_key', 'Cache Key', 5);
```

:::

Also ensure your reward items exist (default: `coke_brick`, `weed_brick`).

## Step 3: Copy Item Images

Copy the item images from `sd-cokemission/images/` to your inventory's image folder:

| Inventory | Image Path |
|---|---|
| ox_inventory | `ox_inventory/web/images/` |
| qb-inventory / ps-inventory | `<inventory>/html/images/` |
| qs-inventory | `qs-inventory/html/images/` |
| codem-inventory | `codem-inventory/html/itemimages/` |
| origen_inventory | `origen_inventory/ui/images/` |

<ItemImageGrid
  title="Coke Mission Item Images"
  zipName="sd-cokemission-images"
  :images="[
    { src: '/items/cokemission/cache_key.png', name: 'cache_key.png', alt: 'Cache Key' },
    { src: '/items/cokemission/sealed_cache.png', name: 'sealed_cache.png', alt: 'Sealed Cache' },
  ]"
/>

::: tip
If you are using a custom inventory, place the images wherever your inventory loads item icons from.
:::

## Step 4: Start and Verify

1. Start your server
2. Check the server console for any errors
3. The Boss NPC spawns at one of 3 random locations
4. If `Config.Blip.Enable` is true, look for the blip on the map

::: warning
Make sure `sd_lib` is started **before** sd-cokemission in your server.cfg, or the resource will fail to load.
:::

::: tip
No database tables are required. All state is managed in memory.
:::

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
