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
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` |
| **Doorlock** | Yes | `ox_doorlock` / `qb-nui_doorlock` |
| **Minigame** | Yes | Any of the supported minigames listed above |
| **Inventory** | Yes | Any of the supported inventories listed above |

::: tip
Framework, target system, doorlock, and inventory are all automatically detected and used — you don't need to configure any of it.
:::

## Step 1: Add the Resource

1. Download `sd-traphouse` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add the following to your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before.

```ini
ensure sd_lib
ensure ox_lib
ensure ox_target
ensure ox_doorlock
ensure sd-traphouse
```

## Step 2: Import Doorlock Data

Import the front door entry for your doorlock system:

::: code-group

```sql [ox_doorlock]
-- Import sd-traphouse/doorlock/ox_doorlock/traphouse.sql into your database
-- This creates 1 door entry: traphouse-front
```

```lua [qb-nui_doorlock]
-- Copy the contents of sd-traphouse/doorlock/qb-nui_doorlock/traphouse.lua
-- into your qb-nui_doorlock config file
```

:::

## Step 3: Add Items

Register the required items in your inventory system:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['gang-keychain'] = {
    label = 'Keychain',
    weight = 50,
    stack = true,
    close = true,
    description = 'A keychain with a load of oddly labelled keys',
},
['safecracker'] = {
    label = 'Safe Cracker',
    weight = 500,
    stack = true,
    close = true,
    description = 'A specialized tool used for breaking into safes.',
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['gang-keychain'] = { name = 'gang-keychain', label = 'Gang Keychain', weight = 20,  type = 'item', image = 'gang-keychain.png', unique = true,  useable = false, shouldClose = true, description = 'A keychain with a load of oddly labelled keys' },
['safecracker']   = { name = 'safecracker',   label = 'Safe Cracker',  weight = 500, type = 'item', image = 'safecracker.png',   unique = true,  useable = false, shouldClose = true, description = 'A specialized tool used for breaking into safes.' },
```

:::

## Step 4: Copy Item Images

Copy the item images from `sd-traphouse/images/` to your inventory's image folder:

| Inventory | Image Path |
|---|---|
| ox_inventory | `ox_inventory/web/images/` |
| qb-inventory / ps-inventory | `<inventory>/html/images/` |
| qs-inventory | `qs-inventory/html/images/` |
| codem-inventory | `codem-inventory/html/itemimages/` |
| origen_inventory | `origen_inventory/ui/images/` |

<ItemImageGrid
  title="Traphouse Item Images"
  zipName="sd-traphouse-images"
  :images="[
    { src: '/items/traphouse/gang-keychain.png', name: 'gang-keychain.png', alt: 'Gang Keychain' },
    { src: '/items/traphouse/safecracker.png', name: 'safecracker.png', alt: 'Safecracker' },
  ]"
/>

::: tip
If you are using a custom inventory, place the images wherever your inventory loads item icons from.
:::

## Step 5: Start and Verify

1. Start your server
2. Check the server console for any errors
3. If `Config.Blip.Enable` is true, look for the **Vagos Traphouse** blip on the map
4. Ensure the minimum police requirement is met before attempting the robbery

::: warning
Make sure `sd_lib` is started **before** sd-traphouse in your server.cfg, or the resource will fail to load.
:::

::: tip
No database tables are required. All robbery state is managed in memory and resets on server restart.
:::

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
