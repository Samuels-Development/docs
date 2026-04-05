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
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` |
| **ox_lib** | Yes | |
| **Inventory** | Yes | Any of the supported inventories listed above |
| **oxmysql** | Yes | |

::: tip
Framework, target system, and inventory are all automatically detected and used — you don't need to configure any of it.
:::

## Step 1: Add the Resource

1. Download `sd-selling` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add the following to your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before.

```ini
ensure sd_lib
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure oxmysql
ensure sd-selling
```

::: tip
The `sd_cornerselling` database table is created automatically on first start. No manual SQL required.
:::

## Step 2: Add Items

If using money washing, ensure the cash items exist:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua (if not already present)

['bands'] = {
    label = 'Band Of Notes',
    weight = 100,
    stack = true,
    close = false,
    description = 'A band of small notes..',
},
['rolls'] = {
    label = 'Roll Of Small Notes',
    weight = 100,
    stack = true,
    close = false,
    description = 'A roll of small notes..',
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['bands'] = { name = 'bands', label = 'Band Of Notes',       weight = 100, type = 'item', image = 'bands.png', unique = false, useable = false, shouldClose = false, description = 'A band of small notes..' },
['rolls'] = { name = 'rolls', label = 'Roll Of Small Notes', weight = 100, type = 'item', image = 'rolls.png', unique = false, useable = false, shouldClose = false, description = 'A roll of small notes..' },
```

```sql [ESX]
-- Import sd-selling/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('bands', 'Band Of Notes', 1),
  ('rolls', 'Roll Of Small Notes', 1);
```

:::

Also ensure all drugs configured in `Config.Zones` and `Config.Delivery.Drugs` exist in your inventory system (e.g., `cokebaggy`, `crack_baggy`, `xtcbaggy`, `oxy`, `meth`, weed variants).

## Step 3: Copy Item Images

Copy the item images from `sd-selling/images/` to your inventory's image folder:

| Inventory | Image Path |
|---|---|
| ox_inventory | `ox_inventory/web/images/` |
| qb-inventory / ps-inventory | `<inventory>/html/images/` |
| qs-inventory | `qs-inventory/html/images/` |
| codem-inventory | `codem-inventory/html/itemimages/` |
| origen_inventory | `origen_inventory/ui/images/` |

<ItemImageGrid
  title="Selling Item Images"
  zipName="sd-selling-images"
  :images="[
    { src: '/items/selling/bands.png', name: 'bands.png', alt: 'Bands' },
    { src: '/items/selling/rolls.png', name: 'rolls.png', alt: 'Rolls' },
  ]"
/>

::: tip
If you are using a custom inventory, place the images wherever your inventory loads item icons from.
:::

## Step 4: Start and Verify

1. Start your server
2. Check the server console for any errors
3. The Drug Lord NPC spawns at one of 3 random locations (for deliveries)
4. Approach NPCs in configured selling zones to start selling

::: warning
Make sure `sd_lib` is started **before** sd-selling in your server.cfg, or the resource will fail to load.
:::

## Database Table

The `sd_cornerselling` table stores player progression and is created automatically on first start:

| Column | Type | Purpose |
|---|---|---|
| `Identifier` | VARCHAR(255) | Player identifier |
| `XP` | INT | Total reputation experience points |
| `Stats` | JSON | Per-drug sales counts |
| `Milestones` | JSON | Redeemed milestone tracking |

::: details Manual SQL (only if the table was not auto-created)
```sql
CREATE TABLE IF NOT EXISTS `sd_cornerselling` (
  `Identifier` VARCHAR(255) NOT NULL,
  `XP` INT NOT NULL DEFAULT 0,
  `Stats` JSON DEFAULT NULL,
  `Milestones` JSON DEFAULT NULL,
  PRIMARY KEY (`Identifier`)
);
```
:::

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
