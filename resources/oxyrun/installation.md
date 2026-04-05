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
| **PolyZone** | Yes | |
| **oxmysql** | Yes | |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` / TextUI fallback |
| **Inventory** | Yes | Any of the supported inventories listed above |

::: tip
Framework, target system, and inventory are all automatically detected — no configuration needed. Any required database tables are also created automatically on first start.
:::

## <span class="step-num">1</span> Add the Resource

1. Download the latest version of `sd-oxyrun` from the [CFX Portal](https://portal.cfx.re/assets/granted-assets)
2. Extract it into your server's `resources` directory
3. Ensure the resource is started in your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before. Here's an example:

```cfg
ensure sd_lib
ensure ox_lib
ensure PolyZone
ensure oxmysql
ensure ox_target
ensure qb-core

ensure sd-oxyrun
```

## <span class="step-num">2</span> Add Items

Register the package item and reward items in your inventory system:

::: code-group

```lua [ox_inventory]
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
['bands']   = { name = 'bands',   label = 'Band Of Notes',       weight = 100,   type = 'item', image = 'bands.png',   unique = false, useable = false, shouldClose = false, description = 'A band of small notes..' },
['rolls']   = { name = 'rolls',   label = 'Roll Of Small Notes', weight = 100,   type = 'item', image = 'rolls.png',   unique = false, useable = false, shouldClose = false, description = 'A roll of small notes..' },
['package'] = { name = 'package', label = 'Suspicious Package',  weight = 10000, type = 'item', image = 'package.png', unique = true,  useable = true,  shouldClose = false, description = 'A mysterious package.. Scary!' },
['oxy']     = { name = 'oxy',     label = 'Prescription Oxy',    weight = 0,     type = 'item', image = 'oxy.png',     unique = false, useable = true,  shouldClose = true, description = 'The Label Has Been Ripped Off' },
```

```sql [ESX]
INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('bands', 'Band Of Notes', 1),
  ('rolls', 'Roll Of Small Notes', 1),
  ('package', 'Suspicious Package', 100),
  ('oxy', 'Prescription Oxy', 0);
```

:::

Also ensure any rare items configured in the level rewards exist in your inventory system.

## <span class="step-num">3</span> Add Item Images

Copy the item images from `sd-oxyrun/images/` to your inventory's image folder. You can also download them directly from the container below.

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

## <span class="step-num">4</span> Start the Resource

To load the resource, you can either:

- **Restart your server** entirely, or
- Run the following commands in your **server console** (F8 or txAdmin live console):

```cfg
refresh
ensure sd-oxyrun
```

## Database Table

The `sd_oxyrun` table stores player reputation and is created automatically on first start:

| Column | Type | Purpose |
|---|---|---|
| `Identifier` | VARCHAR(255) | Player identifier (license, steam, etc.) |
| `XP` | INT | Total reputation experience points |

Manual SQL (only if the table was not auto-created):

```sql
CREATE TABLE IF NOT EXISTS `sd_oxyrun` (
  `Identifier` VARCHAR(255) NOT NULL,
  `XP` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`Identifier`)
);
```

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
