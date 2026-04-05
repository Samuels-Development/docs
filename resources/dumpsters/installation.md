# Installation

Follow these steps to install sd-dumpsters on your FiveM server.

## Supported Inventories

| Inventory | Status |
|---|---|
| `ox_inventory` | Supported |
| `codem-inventory` | Supported |
| `tgiann-inventory` | Supported |
| `jaksam_inventory` | Supported |
| `qs-inventory-pro` | Supported |
| `origen_inventory` | Supported |

::: tip Recommendation
We heavily recommend using `ox_inventory` — it's the best inventory system available and more importantly, it's completely free and open source! You won't be missing out on any features in our scripts if you use a different inventory, this is simply a recommendation.
:::

## Supported Minigames

You only need **one** of the following minigame resources installed. Pick whichever you prefer.

| Resource | Minigames |
|---|---|
| `ps-ui` | ps-circle, ps-maze, ps-varhack, ps-thermite, ps-scrambler |
| `memorygame` | memorygame-thermite |
| `ran-minigames` | ran-memorycard, ran-openterminal |
| `hacking` | hacking-opengame |
| `howdy-hackminigame` | howdy-begin |
| `SN-Hacking` | sn-memorygame, sn-skillcheck, sn-thermite, sn-keypad, sn-colorpicker |
| `rm_minigames` | rm-typinggame, rm-timedlockpick, rm-timedaction, rm-quicktimeevent, rm-combinationlock, rm-buttonmashing, rm-angledlockpick, rm-fingerprint, rm-hotwirehack, rm-hackerminigame, rm-safecrack |
| `ox_lib` | lib.skillCheck |
| `bl_ui` | bl-circlesum, bl-digitdazzle, bl-lightsout, bl-minesweeper, bl-pathfind, bl-printlock, bl-untangle, bl-wavematch, bl-wordwiz |
| `glitch-minigames` | gl-firewall-pulse, gl-backdoor-sequence, gl-circuit-rhythm, gl-surge-override, gl-circuit-breaker, gl-data-crack, gl-brute-force, gl-var-hack |

## Dependencies

Ensure the following dependencies are installed and running on your server before starting:

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` / `qbx_core` / `es_extended` |
| **ox_lib** | Yes | |
| **oxmysql** | Yes | |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` (or built-in TextUI fallback) |
| **Inventory** | Yes | Any of the supported inventories listed above |

::: tip
Framework, target system, and inventory are all automatically detected and used — you don't need to configure any of it.
:::

### Optional Integrations

| Integration | Purpose |
|---|---|
| **ox_inventory** | Required for stash mode and loot-to-stash mode |
| **lation_ui** | Alternative notification and progress bar provider |
| **cd_drawtextui** | Alternative TextUI provider |
| **Minigame scripts** | Any of the supported minigames listed above |

## Step 1: Drag and Drop

1. Download the latest release of `sd-dumpsters`
2. Extract the folder into your server's `resources` directory
3. Add the following to your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before.

::: tip
The script runs auto-setup on first start. The database tables will be created automatically via oxmysql.
:::

## Step 2: Add Items

You must register two core items in your inventory system: **powersaw** and **bottle_cap**. These correspond to the config keys `Config.Items.Grinder` (`'powersaw'`) and `Config.Items.BottleCap` (`'bottle_cap'`).

The power saw is used to open locked dumpsters. Bottle caps are the alternative currency for the Hobo King shop.

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['powersaw'] = {
    label = 'Power Saw',
    weight = 2500,
    stack = true,
    close = true,
    description = 'A powerful tool designed for cutting wood, metal, and other materials with precision and ease.',
},

['bottle_cap'] = {
    label = 'Bottle Cap',
    weight = 1,
    stack = true,
    close = false,
    description = 'A small metallic cap from a bottle. Seems insignificant, but collectors might find it valuable.',
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['powersaw'] = {
    name = 'powersaw',
    label = 'Power Saw',
    weight = 2500,
    type = 'item',
    image = 'powersaw.png',
    unique = false,
    useable = false,
    shouldClose = true,
    description = 'A powerful tool designed for cutting wood, metal, and other materials with precision and ease.',
},

['bottle_cap'] = {
    name = 'bottle_cap',
    label = 'Bottle Cap',
    weight = 1,
    type = 'item',
    image = 'bottle_cap.png',
    unique = false,
    useable = false,
    shouldClose = false,
    description = 'A small metallic cap from a bottle. Seems insignificant, but collectors might find it valuable.',
},
```

```sql [ESX]
-- Register items in your ESX items table

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    ('powersaw', 'Powersaw', 2500, 0, 1),
    ('bottle_cap', 'Bottle Cap', 1, 0, 1);
```

:::

::: warning
You also need to register **all loot table items** that appear in `Config.DumpsterLoot`, `Config.Bags.Loot`, `Config.HoboCamps.Loot`, `Config.HoboLoot`, `Config.Shop`, and `Config.Recycling.Items` in your inventory system. The default config uses items like `metalscrap`, `plastic`, `glass`, `rubber`, `steel`, `garbage`, `paperbag`, `cleaningkit`, `walkstick`, `lighter`, `toaster`, `lockpick`, `10kgoldchain`, `ruby_earring_silver`, `goldearring`, `antique_coin`, `rims`, `md_silverearings`, `weapon_bottle`, `low_quality_meth`, `weapon_knuckle`, `weapon_switchblade`, and all recycled output items. Refer to `Config.ItemsMetadata` in `configs/config.lua` for the full list with labels.
:::

## Step 3: Copy Item Images

Copy the provided item images from the `sd-dumpsters/images/` folder into your inventory resource's image directory:

- **ox_inventory:** `ox_inventory/web/images/`
- **qb-inventory:** `qb-inventory/html/images/`
- **qs-inventory:** `qs-inventory/html/images/`

The script includes images for `bottle_cap.png` and `powersaw.png`. Click any image to download it, or use **Download All** to grab them all at once.

<ItemImageGrid
  title="Dumpster Diving Item Images"
  zipName="sd-dumpsters-images"
  :images="[
    { src: '/items/dumpsters/powersaw.png', name: 'powersaw.png', alt: 'Powersaw' },
    { src: '/items/dumpsters/bottle_cap.png', name: 'bottle_cap.png', alt: 'Bottle Cap' },
  ]"
/>

::: warning
If the images are not copied, items will display without icons in the player's inventory. Make sure to restart your inventory resource after adding images.
:::

## Step 4: Start the Server

1. Ensure all dependencies start **before** sd-dumpsters in your `server.cfg`
2. Start or restart your server
3. The script will auto-detect your framework and create the required database tables on first boot

```
ensure oxmysql
ensure ox_lib
ensure qb-core
ensure ox_target
ensure ox_inventory
ensure sd-dumpsters
```

::: info
The ensure order matters. sd-dumpsters must load after all of its dependencies. The framework and target system are auto-detected -- no manual configuration is needed for basic setup.
:::

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
