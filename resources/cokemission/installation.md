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

Ensure the following resources are installed and running **before** sd-cokemission:

| Dependency | Options |
|---|---|
| **Framework** | `qb-core` / `qbx_core` / `es_extended` |
| **Library** | `sd_lib` (required) |
| **Zones** | `PolyZone` (required) |
| **Target System** | `ox_target` / `qb-target` / `qtarget` / TextUI fallback |

::: info
Framework, inventory, and target system are all auto-detected via sd_lib. No database tables are required -- state is managed in memory.
:::

## Step 1: Add the Resource

1. Download `sd-cokemission` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add `ensure sd-cokemission` to your `server.cfg` **after** all dependencies

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
