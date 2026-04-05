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
| **sd_lib** | Yes | |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` / TextUI fallback |
| **Doorlock** | Yes | `ox_doorlock` / `qb-nui_doorlock` / `cd_doorlock` |
| **Minigame** | Yes | Any of the supported minigames listed above |
| **Inventory** | Yes | Any of the supported inventories listed above |

::: tip
Framework, target system, doorlock, and inventory are all automatically detected and used — you don't need to configure any of it.
:::

## Step 1: Add the Resource

1. Download `sd-bobcat` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add the following to your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before.

```ini
ensure sd_lib
ensure ox_lib
ensure ox_target
ensure ox_doorlock
ensure sd-bobcat
```

## Step 2: Import Doorlock Data

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

## Step 3: Add Items

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

## Step 4: Copy Item Images

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

## Step 5: Start and Verify

1. Start your server
2. Check the server console for any errors
3. Look for the **Bobcat Security** blip on the map (if enabled)
4. Ensure the minimum police requirement is met before attempting the heist

::: warning
Make sure `sd_lib` is started **before** sd-bobcat in your server.cfg, or the resource will fail to load.
:::

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
