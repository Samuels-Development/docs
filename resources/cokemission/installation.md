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
Framework, target system, and inventory are all automatically detected — no configuration needed.
:::

## <span class="step-num">1</span> Add the Resource

1. Download the latest version of `sd-cokemission` from the [CFX Portal](https://portal.cfx.re/assets/granted-assets)
2. Extract it into your server's `resources` directory
3. Ensure the resource is started in your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before. Here's an example:

```cfg
ensure sd_lib
ensure ox_lib
ensure PolyZone
ensure ox_target
ensure qb-core

ensure sd-cokemission
```

## <span class="step-num">2</span> Add Items

If using the sealed cache system (`Config.UsingSealedCache = true`), register these items:

::: code-group

```lua [ox_inventory]
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
['sealed_cache'] = { name = 'sealed_cache', label = 'Sealed Cache', weight = 15000, type = 'item', image = 'sealed_cache.png', unique = true, useable = true, shouldClose = false, description = 'A heavy and resilient lockbox' },
['cache_key']    = { name = 'cache_key',    label = 'Cache Key',    weight = 500,   type = 'item', image = 'cache_key.png',    unique = true, useable = true, shouldClose = true,  description = 'Key used for lock boxes' },
```

```sql [ESX]
INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('sealed_cache', 'Sealed Cache', 150),
  ('cache_key', 'Cache Key', 5);
```

:::

Also ensure your reward items exist (default: `coke_brick`, `weed_brick`).

## <span class="step-num">3</span> Add Item Images

Copy the item images from `sd-cokemission/images/` to your inventory's image folder. You can also download them directly from the container below.

<ItemImageGrid
  title="Coke Mission Item Images"
  zipName="sd-cokemission-images"
  :images="[
    { src: '/items/cokemission/cache_key.png', name: 'cache_key.png', alt: 'Cache Key' },
    { src: '/items/cokemission/sealed_cache.png', name: 'sealed_cache.png', alt: 'Sealed Cache' },
  ]"
/>

## <span class="step-num">4</span> Start the Resource

To load the resource, you can either:

- **Restart your server** entirely, or
- Run the following commands in your **server console** (F8 or txAdmin live console):

```cfg
refresh
ensure sd-cokemission
```

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
