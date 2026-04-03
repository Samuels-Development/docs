# Installation

## Dependencies

Ensure the following resources are installed and running **before** sd-warehouse:

| Dependency | Options |
|---|---|
| **Library** | `sd_lib` |
| **Interaction** | `ox_target` / `qb-target` / `qtarget` (or use TextUI) |

## Step 1: Add the Resource

1. Download `sd-warehouse` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add `ensure sd-warehouse` to your `server.cfg` **after** all dependencies

```ini
ensure sd_lib
ensure ox_lib
ensure ox_target
ensure sd-warehouse
```

## Step 2: Add Items

Register the thermite item in your inventory system:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['thermite_h'] = {
    label = 'Thermite',
    weight = 2000,
    stack = true,
    close = true,
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['thermite_h'] = { name = 'thermite_h', label = 'Thermite', weight = 2000, type = 'item', image = 'thermite_h.png', unique = false, useable = true, shouldClose = true, description = 'Thermite charge' },
```

```sql [ESX]
-- Import sd-warehouse/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('thermite_h', 'Thermite', 20);
```

:::

Also ensure all loot reward items exist in your inventory system (gold bars, laptops, weapons, drugs, etc.).

## Step 3: Start and Verify

1. Start your server
2. Check the server console for any errors
3. Look for the **Secured Warehouse** blip on the map (if enabled)
4. Ensure the minimum police requirement is met before attempting the heist

::: warning
Make sure `sd_lib` is started **before** sd-warehouse in your server.cfg, or the resource will fail to load.
:::

::: tip
No database tables are required. All heist state is managed in memory and resets on server restart.
:::
