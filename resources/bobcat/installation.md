# Installation

## Dependencies

Ensure the following resources are installed and running **before** sd-bobcat:

| Dependency | Options |
|---|---|
| **Library** | `sd_lib` |
| **Interaction** | `ox_target` / `qb-target` / `qtarget` (or use TextUI) |
| **Doorlock** | `ox_doorlock` / `qb-nui_doorlock` / `cd_doorlock` |

## Step 1: Add the Resource

1. Download `sd-bobcat` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add `ensure sd-bobcat` to your `server.cfg` **after** all dependencies

```ini
ensure sd_lib
ensure ox_lib
ensure ox_target
ensure ox_doorlock
ensure sd-bobcat
```

## Step 2: Select Your MLO

Open `config.lua` and set `Config.MLOType` to match your installed MLO:

```lua
Config.MLOType = 'gabz'     -- Options: 'gabz', 'nopixel', 'k4mb1'
```

All coordinates, doorlocks, and guard spawns will automatically adjust to your selected map.

## Step 3: Import Doorlock Data

Choose the doorlock system you use and import the corresponding config:

::: code-group

```sql [ox_doorlock]
-- Import sd-bobcat/doorlock/ox_doorlock/*.sql into your database
-- This creates 4 door entries: bobcatfirst, bobcatsecond, bobcatthird, bobcatfourth
```

```lua [qb-nui_doorlock]
-- Copy the contents of sd-bobcat/doorlock/qb-nui_doorlock/*.lua
-- into your qb-nui_doorlock config file
```

```json [cd_doorlock]
-- Import sd-bobcat/doorlock/cd_doorlock/*.json
-- into your cd_doorlock configuration
```

:::

## Step 4: Add Items

Register the required items in your inventory system:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['thermite_h'] = {
    label = 'Thermite',
    weight = 2000,
    stack = true,
    close = true,
},
['bobcatkeycard'] = {
    label = 'Bobcat Security Card',
    weight = 100,
    stack = false,
    close = true,
},
['c4_bomb'] = {
    label = 'C4 Explosive',
    weight = 1500,
    stack = true,
    close = true,
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['thermite_h']     = { name = 'thermite_h',     label = 'Thermite',              weight = 2000, type = 'item', image = 'thermite_h.png',     unique = false, useable = true, shouldClose = true, description = 'Thermite charge' },
['bobcatkeycard']  = { name = 'bobcatkeycard',   label = 'Bobcat Security Card',  weight = 100,  type = 'item', image = 'bobcatkeycard.png',  unique = true,  useable = true, shouldClose = true, description = 'A Bobcat Security keycard' },
['c4_bomb']        = { name = 'c4_bomb',         label = 'C4 Explosive',          weight = 1500, type = 'item', image = 'c4_bomb.png',        unique = false, useable = true, shouldClose = true, description = 'C4 explosive charge' },
```

```sql [ESX]
-- Import sd-bobcat/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('bobcatkeycard', 'Bobcat Security Card', 1),
  ('c4_bomb', 'C4 Explosive', 15),
  ('thermite_h', 'Thermite', 20);
```

:::

## Step 5: Start and Verify

1. Start your server
2. Check the server console for any errors
3. Look for the **Bobcat Security** blip on the map (if enabled)
4. Ensure the minimum police requirement is met before attempting the heist

::: warning
Make sure `sd_lib` is started **before** sd-bobcat in your server.cfg, or the resource will fail to load.
:::
