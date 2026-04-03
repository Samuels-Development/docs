# Installation

## Dependencies

Ensure the following resources are installed and running **before** sd-pacificbank:

| Dependency | Options |
|---|---|
| **Library** | `sd_lib` |
| **UI Library** | `ox_lib` |
| **Doorlock** | `ox_doorlock` / `qb-doorlock` / `nui_doorlock` |
| **Lasers** | `mka-lasers` (optional) |

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
    weight = 500,
    stack = true,
    close = true,
},
['laptop_gold'] = {
    label = 'Gold Laptop',
    weight = 500,
    stack = true,
    close = true,
},
['large_drill'] = {
    label = 'Large Drill',
    weight = 2000,
    stack = false,
    close = true,
},
['thermite'] = {
    label = 'Thermite',
    weight = 200,
    stack = true,
    close = true,
},
['c4_bomb'] = {
    label = 'C4 Explosive',
    weight = 2000,
    stack = true,
    close = true,
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['laptop_pink'] = { name = 'laptop_pink', label = 'Pink Laptop',    weight = 500,  type = 'item', image = 'laptop_pink.png', unique = false, useable = true, shouldClose = true, description = 'A pink laptop' },
['laptop_gold'] = { name = 'laptop_gold', label = 'Gold Laptop',    weight = 500,  type = 'item', image = 'laptop_gold.png', unique = false, useable = true, shouldClose = true, description = 'A gold laptop' },
['large_drill'] = { name = 'large_drill', label = 'Large Drill',    weight = 2000, type = 'item', image = 'large_drill.png', unique = true,  useable = true, shouldClose = true, description = 'A large drill' },
['thermite']    = { name = 'thermite',    label = 'Thermite',        weight = 200,  type = 'item', image = 'thermite.png',    unique = false, useable = true, shouldClose = true, description = 'Thermite charge' },
['c4_bomb']     = { name = 'c4_bomb',     label = 'C4 Explosive',    weight = 2000, type = 'item', image = 'c4_bomb.png',     unique = false, useable = true, shouldClose = true, description = 'C4 explosive charge' },
```

```sql [ESX]
-- Import sd-pacificbank/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('laptop_pink', 'Pink Laptop', 5),
  ('laptop_gold', 'Gold Laptop', 5),
  ('large_drill', 'Large Drill', 20),
  ('thermite', 'Thermite', 2),
  ('c4_bomb', 'C4 Explosive', 20);
```

:::

## Step 4: Configure Laser Resource (Optional)

If using the laser grid feature, ensure `mka-lasers` is installed and set the resource name in config:

```lua
Config.EnableLasers = true
Config.LaserResourceName = 'mka-lasers'
```

## Step 5: Start and Verify

1. Start your server
2. Check the server console for any errors
3. Ensure all 13 doorlock entries are loaded
4. Ensure the minimum police requirement is met before attempting the heist

::: warning
Make sure `sd_lib` is started **before** sd-pacificbank in your server.cfg, or the resource will fail to load.
:::
