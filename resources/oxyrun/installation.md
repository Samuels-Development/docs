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

Ensure the following resources are installed and running **before** sd-oxyrun:

| Dependency | Options |
|---|---|
| **Framework** | `qb-core` / `qbx_core` / `es_extended` |
| **Library** | `sd_lib` (required) |
| **Zones** | `PolyZone` (required) |
| **Database** | `oxmysql` |
| **Target System** | `ox_target` / `qb-target` / `qtarget` / TextUI fallback |

::: info
Framework, inventory, and target system are all auto-detected via sd_lib. The `sd_oxyrun` database table is created automatically on first start and stores player XP.
:::

## Step 1: Add the Resource

1. Download `sd-oxyrun` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add `ensure sd-oxyrun` to your `server.cfg` **after** all dependencies

```ini
ensure sd_lib
ensure ox_lib
ensure PolyZone
ensure oxmysql
ensure ox_target
ensure sd-oxyrun
```

::: tip
The `sd_oxyrun` database table is created automatically on first start. No manual SQL required.
:::

## Step 2: Add Items

Register the package item and reward items in your inventory system:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['bands'] = {
    label = 'Band Of Notes',
    weight = 100,
    stack = true,
    close = false,
    description = 'A band of small notes..',
    consume = 0,
},
['rolls'] = {
    label = 'Roll Of Small Notes',
    weight = 100,
    stack = true,
    close = false,
    description = 'A roll of small notes..',
    consume = 0,
},
['package'] = {
    label = 'Suspicious Package',
    weight = 10000,
    stack = false,
    close = false,
    description = 'A mysterious package.. Scary!',
    consume = 0,
},
['oxy'] = {
    label = 'Prescription Oxy',
    weight = 0,
    stack = true,
    close = true,
    description = 'The Label Has Been Ripped Off',
    consume = 0,
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['bands']   = { name = 'bands',   label = 'Band Of Notes',       weight = 100,   type = 'item', image = 'bands.png',   unique = false, useable = false, shouldClose = false, description = 'A band of small notes..' },
['rolls']   = { name = 'rolls',   label = 'Roll Of Small Notes', weight = 100,   type = 'item', image = 'rolls.png',   unique = false, useable = false, shouldClose = false, description = 'A roll of small notes..' },
['package'] = { name = 'package', label = 'Suspicious Package',  weight = 10000, type = 'item', image = 'package.png', unique = true,  useable = true,  shouldClose = false, description = 'A mysterious package.. Scary!' },
['oxy']     = { name = 'oxy',     label = 'Prescription Oxy',    weight = 0,     type = 'item', image = 'oxy.png',     unique = false, useable = true,  shouldClose = true, description = 'The Label Has Been Ripped Off' },
```

```sql [ESX]
-- Import sd-oxyrun/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('bands', 'Band Of Notes', 1),
  ('rolls', 'Roll Of Small Notes', 1),
  ('package', 'Suspicious Package', 100),
  ('oxy', 'Prescription Oxy', 0);
```

:::

Also ensure any rare items configured in the level rewards exist in your inventory system.

## Step 3: Copy Item Images

Copy the item images from `sd-oxyrun/images/` to your inventory's image folder:

| Inventory | Image Path |
|---|---|
| ox_inventory | `ox_inventory/web/images/` |
| qb-inventory / ps-inventory | `<inventory>/html/images/` |
| qs-inventory | `qs-inventory/html/images/` |
| codem-inventory | `codem-inventory/html/itemimages/` |
| origen_inventory | `origen_inventory/ui/images/` |

<ItemImageGrid
  title="Oxy Run Item Images"
  zipName="sd-oxyrun-images"
  :images="[
    { src: '/items/oxyrun/bands.png', name: 'bands.png', alt: 'Bands' },
    { src: '/items/oxyrun/oxy.png', name: 'oxy.png', alt: 'Oxy' },
    { src: '/items/oxyrun/package.png', name: 'package.png', alt: 'Package' },
    { src: '/items/oxyrun/rolls.png', name: 'rolls.png', alt: 'Rolls' },
  ]"
/>

::: tip
If you are using a custom inventory, place the images wherever your inventory loads item icons from.
:::

## Step 4: Start and Verify

1. Start your server
2. Check the server console for any errors
3. The Boss NPC spawns at one of 3 random locations
4. Ensure the minimum police requirement is met before starting a run

::: warning
Make sure `sd_lib` is started **before** sd-oxyrun in your server.cfg, or the resource will fail to load.
:::

## Database Table

The `sd_oxyrun` table stores player reputation and is created automatically on first start:

| Column | Type | Purpose |
|---|---|---|
| `Identifier` | VARCHAR(255) | Player identifier (license, steam, etc.) |
| `XP` | INT | Total reputation experience points |

::: details Manual SQL (only if the table was not auto-created)
```sql
CREATE TABLE IF NOT EXISTS `sd_oxyrun` (
  `Identifier` VARCHAR(255) NOT NULL,
  `XP` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`Identifier`)
);
```
:::
