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
    weight = 1000,
    stack = false,
    close = true,
    description = 'A low-yield thermite charge..',
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['thermite_h'] = { name = 'thermite_h', label = 'Thermite', weight = 1000, type = 'item', image = 'thermite_h.png', unique = true, useable = true, shouldClose = true, description = 'A low-yield thermite charge..' },
```

```sql [ESX]
-- Import sd-warehouse/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('thermite_h', 'Thermite', 20);
```

:::

Also ensure all loot reward items exist in your inventory system (gold bars, laptops, weapons, drugs, etc.).

## Step 3: Copy Item Images

Copy the item images from `sd-warehouse/images/` to your inventory's image folder:

| Inventory | Image Path |
|---|---|
| ox_inventory | `ox_inventory/web/images/` |
| qb-inventory / ps-inventory | `<inventory>/html/images/` |
| qs-inventory | `qs-inventory/html/images/` |
| codem-inventory | `codem-inventory/html/itemimages/` |
| origen_inventory | `origen_inventory/ui/images/` |

<ItemImageGrid
  title="Warehouse Item Images"
  zipName="sd-warehouse-images"
  :images="[
    { src: '/items/warehouse/thermite_h.png', name: 'thermite_h.png', alt: 'Thermite' },
  ]"
/>

::: tip
If you are using a custom inventory, place the images wherever your inventory loads item icons from.
:::

## Step 4: Start and Verify

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
