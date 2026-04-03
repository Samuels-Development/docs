# Installation

## Dependencies

Ensure the following resources are installed and running **before** sd-cokemission:

| Dependency | Options |
|---|---|
| **Library** | `sd_lib` |
| **Zones** | `PolyZone` |
| **Interaction** | `ox_target` / `qb-target` / `qtarget` (or use TextUI) |

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
    weight = 1500,
    stack = true,
    close = true,
},
['cache_key'] = {
    label = 'Lockbox Key',
    weight = 5,
    stack = true,
    close = true,
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['sealed_cache'] = { name = 'sealed_cache', label = 'Sealed Cache', weight = 1500, type = 'item', image = 'sealed_cache.png', unique = false, useable = true, shouldClose = true, description = 'A sealed cache of contraband' },
['cache_key']    = { name = 'cache_key',    label = 'Lockbox Key',  weight = 5,    type = 'item', image = 'cache_key.png',    unique = false, useable = true, shouldClose = true, description = 'A key for lockboxes' },
```

```sql [ESX]
-- Import sd-cokemission/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('cache_key', 'Lockbox Key', 5),
  ('sealed_cache', 'Sealed Cache', 1500);
```

:::

Also ensure your reward items exist (default: `coke_brick`, `weed_brick`).

## Step 3: Start and Verify

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
