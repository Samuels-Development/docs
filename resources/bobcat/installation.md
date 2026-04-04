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

Ensure the following resources are installed and running **before** sd-bobcat:

| Dependency | Options |
|---|---|
| **Framework** | `qb-core` / `qbx_core` / `es_extended` |
| **Library** | `sd_lib` (required) |
| **Target System** | `ox_target` / `qb-target` / `qtarget` / TextUI fallback |
| **Doorlock** | `ox_doorlock` / `qb-nui_doorlock` / `cd_doorlock` |
| **Minigame** | Any one of 20+ supported minigame resources |

::: info
Framework, inventory, and target system are all auto-detected via sd_lib.
:::

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

['bobcatkeycard'] = {
    label = 'Bobcat Security Card',
    weight = 1000,
    stack = false,
    close = true,
    description = 'A keycard used at the Bobcat Security Deposit.',
},
['c4_bomb'] = {
    label = 'C4 Brick',
    weight = 1000,
    stack = false,
    close = true,
    description = 'Very Dangerous! High Yield Explosive.',
},
['thermite_h'] = {
    label = 'Thermite',
    weight = 1000,
    stack = false,
    close = true,
    description = 'A low-yield thermite charge.',
    server = {
        export = 'sd-bobcat.useThermite_h',
    },
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['bobcatkeycard']  = { name = 'bobcatkeycard',  label = 'Bobcat Security Card', weight = 1000, type = 'item', image = 'bobcatkeycard.png', unique = false, useable = true,  shouldClose = true, description = 'A keycard used at the Bobcat Security Deposit.' },
['c4_bomb']        = { name = 'c4_bomb',        label = 'C4 Brick',            weight = 1000, type = 'item', image = 'c4_bomb.png',       unique = true,  useable = false, shouldClose = true, description = 'Very Dangerous! High Yield Explosive.' },
['thermite_h']     = { name = 'thermite_h',     label = 'Thermite',            weight = 1000, type = 'item', image = 'thermite_h.png',    unique = true,  useable = true,  shouldClose = true, description = 'A low-yield thermite charge.' },
```

```sql [ESX]
-- Import sd-bobcat/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('bobcatkeycard', 'Bobcat Security Card', 1),
  ('c4_bomb', 'C4 Brick', 10),
  ('thermite_h', 'Thermite', 10);
```

:::

## Step 5: Copy Item Images

Copy the item images from `sd-bobcat/images/` to your inventory's image folder:

| Inventory | Image Path |
|---|---|
| ox_inventory | `ox_inventory/web/images/` |
| qb-inventory / ps-inventory | `<inventory>/html/images/` |
| qs-inventory | `qs-inventory/html/images/` |
| codem-inventory | `codem-inventory/html/itemimages/` |
| origen_inventory | `origen_inventory/ui/images/` |

<ItemImageGrid
  title="Bobcat Item Images"
  zipName="sd-bobcat-images"
  :images="[
    { src: '/items/bobcat/bobcatkeycard.png', name: 'bobcatkeycard.png', alt: 'Bobcat Keycard' },
    { src: '/items/bobcat/c4_bomb.png', name: 'c4_bomb.png', alt: 'C4 Bomb' },
    { src: '/items/bobcat/thermite_h.png', name: 'thermite_h.png', alt: 'Thermite' },
  ]"
/>

::: tip
If you are using a custom inventory, place the images wherever your inventory loads item icons from.
:::

## Step 6: Start and Verify

1. Start your server
2. Check the server console for any errors
3. Look for the **Bobcat Security** blip on the map (if enabled)
4. Ensure the minimum police requirement is met before attempting the heist

::: warning
Make sure `sd_lib` is started **before** sd-bobcat in your server.cfg, or the resource will fail to load.
:::
