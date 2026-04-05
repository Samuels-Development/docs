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
Framework, target system, and inventory are all automatically detected — no configuration needed. Any required database tables are also created automatically on first start.
:::

## <span class="step-num">1</span> Add the Resource

1. Download the latest version of `sd-selling` from the [CFX Portal](https://portal.cfx.re/assets/granted-assets)
2. Extract it into your server's `resources` directory
3. Ensure the resource is started in your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before. Here's an example:

```cfg
ensure sd_lib
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure oxmysql
ensure qb-core

ensure sd-selling
```

## <span class="step-num">2</span> Add Items

If using money washing, ensure the cash items exist:

::: code-group

```lua [ox_inventory]
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
['bands'] = { name = 'bands', label = 'Band Of Notes',       weight = 100, type = 'item', image = 'bands.png', unique = false, useable = false, shouldClose = false, description = 'A band of small notes..' },
['rolls'] = { name = 'rolls', label = 'Roll Of Small Notes', weight = 100, type = 'item', image = 'rolls.png', unique = false, useable = false, shouldClose = false, description = 'A roll of small notes..' },
```

```sql [ESX]
INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('bands', 'Band Of Notes', 1),
  ('rolls', 'Roll Of Small Notes', 1);
```

:::

Also ensure all drugs configured in `Config.Zones` and `Config.Delivery.Drugs` exist in your inventory system (e.g., `cokebaggy`, `crack_baggy`, `xtcbaggy`, `oxy`, `meth`, weed variants).

## <span class="step-num">3</span> Add Item Images

Copy the item images from `sd-selling/images/` to your inventory's image folder. You can also download them directly from the container below.

<ItemImageGrid
  title="Selling Item Images"
  zipName="sd-selling-images"
  :images="[
    { src: '/items/selling/bands.png', name: 'bands.png', alt: 'Bands' },
    { src: '/items/selling/rolls.png', name: 'rolls.png', alt: 'Rolls' },
  ]"
/>

## <span class="step-num">4</span> Start the Resource

To load the resource, you can either:

- **Restart your server** entirely, or
- Run the following commands in your **server console** (F8 or txAdmin live console):

```cfg
refresh
ensure sd-selling
```

## Database Table

The `sd_cornerselling` table stores player progression and is created automatically on first start:

| Column | Type | Purpose |
|---|---|---|
| `Identifier` | VARCHAR(255) | Player identifier |
| `XP` | INT | Total reputation experience points |
| `Stats` | JSON | Per-drug sales counts |
| `Milestones` | JSON | Redeemed milestone tracking |

Manual SQL (only if the table was not auto-created):

```sql
CREATE TABLE IF NOT EXISTS `sd_cornerselling` (
  `Identifier` VARCHAR(255) NOT NULL,
  `XP` INT NOT NULL DEFAULT 0,
  `Stats` JSON DEFAULT NULL,
  `Milestones` JSON DEFAULT NULL,
  PRIMARY KEY (`Identifier`)
);
```

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
