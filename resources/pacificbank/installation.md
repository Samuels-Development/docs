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

Ensure the following resources are installed and running **before** sd-pacificbank:

| Dependency | Options |
|---|---|
| **Framework** | `qb-core` / `qbx_core` / `es_extended` |
| **Library** | `sd_lib` (required) |
| **UI Library** | `ox_lib` |
| **Doorlock** | `ox_doorlock` / `qb-doorlock` / `nui_doorlock` |
| **Lasers** | `mka-lasers` (optional, for laser grid) |
| **Minigame** | Any one of 20+ supported resources |

::: info
Framework, inventory, and target system are all auto-detected via sd_lib. No custom database tables are created -- the script uses the framework's existing inventory system.
:::

## Step 1: Add the Resource

1. Download `sd-pacificbank` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add `ensure sd-pacificbank` to your `server.cfg` **after** all dependencies

```ini
ensure sd_lib
ensure ox_lib
ensure ox_doorlock
ensure mka-lasers
ensure sd-pacificbank
```

## Step 2: Import Doorlock Data

The Pacific Bank uses **13 security doors**. Import the config for your doorlock system:

::: code-group

```sql [ox_doorlock]
-- Import sd-pacificbank/doorlock/ox_doorlock/oxDoorlock.sql into your database
-- This creates entries for securitydoor1 through securitydoor13
```

```lua [qb-nui_doorlock]
-- Copy the contents of sd-pacificbank/doorlock/qb-nui_doorlock/pacificbank.lua
-- into your qb-nui_doorlock config file
```

:::

## Step 3: Add Items

Register the required heist items in your inventory system:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['laptop_pink'] = {
    label = 'Pink Laptop',
    weight = 5000,
    close = true,
    description = 'A pink security Laptop',
},
['laptop_gold'] = {
    label = 'Gold Laptop',
    weight = 5000,
    close = true,
    description = 'A gold security Laptop',
},
['c4_bomb'] = {
    label = 'C4 Brick',
    weight = 1000,
    close = true,
    description = 'Very Dangerous! High-Yield Explosive.',
},
['large_drill'] = {
    label = 'Large Drill',
    weight = 20000,
    close = true,
    description = 'A Large Drill, good at cracking Secure Locks.',
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['laptop_pink'] = { name = 'laptop_pink', label = 'Pink Laptop',  weight = 5000,  type = 'item', image = 'laptop_pink.png', unique = true,  useable = true,  shouldClose = true, description = 'A pink security Laptop' },
['laptop_gold'] = { name = 'laptop_gold', label = 'Gold Laptop',  weight = 5000,  type = 'item', image = 'laptop_gold.png', unique = true,  useable = true,  shouldClose = true, description = 'A gold security Laptop' },
['c4_bomb']     = { name = 'c4_bomb',     label = 'C4 Brick',     weight = 1000,  type = 'item', image = 'c4_bomb.png',     unique = true,  useable = false, shouldClose = true, description = 'Very Dangerous! High-Yield Explosive.' },
['large_drill'] = { name = 'large_drill', label = 'Large Drill',  weight = 20000, type = 'item', image = 'large_drill.png', unique = false, useable = false, shouldClose = false, description = 'A Large Drill, good at cracking Secure Locks.' },
```

```sql [ESX]
-- Import sd-pacificbank/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('laptop_pink', 'Pink Laptop', 50),
  ('laptop_gold', 'Gold Laptop', 50),
  ('c4_bomb', 'C4 Brick', 10),
  ('large_drill', 'Large Drill', 200);
```

:::

## Step 4: Copy Item Images

Copy the item images from `sd-pacificbank/images/` to your inventory's image folder:

| Inventory | Image Path |
|---|---|
| ox_inventory | `ox_inventory/web/images/` |
| qb-inventory / ps-inventory | `<inventory>/html/images/` |
| qs-inventory | `qs-inventory/html/images/` |
| codem-inventory | `codem-inventory/html/itemimages/` |
| origen_inventory | `origen_inventory/ui/images/` |

<ItemImageGrid
  title="Pacific Bank Item Images"
  zipName="sd-pacificbank-images"
  :images="[
    { src: '/items/pacificbank/laptop_pink.png', name: 'laptop_pink.png', alt: 'Laptop (Pink)' },
    { src: '/items/pacificbank/laptop_gold.png', name: 'laptop_gold.png', alt: 'Laptop (Gold)' },
    { src: '/items/pacificbank/c4_bomb.png', name: 'c4_bomb.png', alt: 'C4 Bomb' },
    { src: '/items/pacificbank/large_drill.png', name: 'large_drill.png', alt: 'Large Drill' },
  ]"
/>

::: tip
If you are using a custom inventory, place the images wherever your inventory loads item icons from.
:::

## Step 5: Configure Laser Resource (Optional)

If using the laser grid feature, ensure `mka-lasers` is installed and set the resource name in config:

```lua
Config.EnableLasers = true
Config.LaserResourceName = 'mka-lasers'
```

## Step 6: Start and Verify

1. Start your server
2. Check the server console for any errors
3. Ensure all 13 doorlock entries are loaded
4. Ensure the minimum police requirement is met before attempting the heist

::: warning
Make sure `sd_lib` is started **before** sd-pacificbank in your server.cfg, or the resource will fail to load.
:::
