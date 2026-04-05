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
| **ox_lib** | Yes | |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` / TextUI fallback |
| **Minigame** | Yes | Any of the supported minigames listed above |
| **InteractSound** | Optional | For SFX |
| **Inventory** | Yes | Any of the supported inventories listed above |

::: tip
Framework, target system, and inventory are all automatically detected and used — you don't need to configure any of it.
:::

## Step 1: Add the Resource

1. Download `sd-yacht` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add the following to your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before.

```ini
ensure sd_lib
ensure ox_lib
ensure ox_target
ensure sd-yacht
```

## Step 2: Add Items

Register the required items in your inventory system:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['yachtcodes'] = {
    label = 'Yacht Access Codes',
    weight = 200,
    stack = false,
    close = true,
    description = 'The first half of codes for the Yacht',
    consume = 0,
    server = {
        export = 'sd-yacht.useYachtcodes',
    },
},
['casinocodes'] = {
    label = 'Casino Access Codes',
    weight = 200,
    stack = false,
    close = true,
    description = 'The first half of codes for the Casino',
    consume = 0,
    server = {
        export = 'sd-yacht.useCasinocodes',
    },
},
['secured_safe'] = {
    label = 'Safe',
    weight = 200,
    stack = false,
    close = true,
    description = 'Meant to protect valuables',
    consume = 0,
},
['expensive_champagne'] = {
    label = 'Champagne',
    weight = 200,
    stack = true,
    close = true,
    description = 'A sparkling wine from France',
    consume = 0,
},
['default_gateway_override'] = {
    label = 'Gateway Override',
    weight = 200,
    stack = false,
    close = true,
    description = 'A default gateway override on a usb',
    consume = 0,
},
['revivekit'] = {
    label = 'Revival Kit',
    weight = 3000,
    stack = false,
    close = true,
    description = 'When your pal needs that pick me up',
    consume = 0,
    server = {
        export = 'sd-yacht.useRevivekit',
    },
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['yachtcodes']               = { name = 'yachtcodes',               label = 'Yacht Access Codes',  weight = 200,  type = 'item', image = 'yachtcodes.png',               unique = true,  useable = true,  shouldClose = true,  description = 'The first half of codes for the Yacht' },
['casinocodes']              = { name = 'casinocodes',              label = 'Casino Access Codes', weight = 200,  type = 'item', image = 'casinocodes.png',              unique = true,  useable = true,  shouldClose = true,  description = 'The first half of codes for the Casino' },
['secured_safe']             = { name = 'secured_safe',             label = 'Safe',                weight = 200,  type = 'item', image = 'secured_safe.png',             unique = true,  useable = true,  shouldClose = true,  description = 'Meant to protect valuables' },
['expensive_champagne']      = { name = 'expensive_champagne',      label = 'Champagne',           weight = 200,  type = 'item', image = 'expensive_champagne.png',      unique = false, useable = true,  shouldClose = true,  description = 'A sparkling wine from France' },
['default_gateway_override'] = { name = 'default_gateway_override', label = 'Gateway Override',    weight = 200,  type = 'item', image = 'default_gateway_override.png', unique = true,  useable = true,  shouldClose = true,  description = 'A default gateway override on a usb' },
['revivekit']                = { name = 'revivekit',                label = 'Revival Kit',         weight = 3000, type = 'item', image = 'revivekit.png',                unique = true,  useable = true,  shouldClose = false, description = 'When your pal needs that pick me up' },
```

```sql [ESX]
-- Import sd-yacht/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('yachtcodes', 'Yacht Access Codes', 2),
  ('casinocodes', 'Casino Access Codes', 2),
  ('secured_safe', 'Safe', 2),
  ('expensive_champagne', 'Champagne', 2),
  ('default_gateway_override', 'Gateway Override', 2),
  ('revivekit', 'Revival Kit', 30);
```

:::

## Step 3: Copy Item Images

Copy the item images from `sd-yacht/images/` to your inventory's image folder:

| Inventory | Image Path |
|---|---|
| ox_inventory | `ox_inventory/web/images/` |
| qb-inventory / ps-inventory | `<inventory>/html/images/` |
| qs-inventory | `qs-inventory/html/images/` |
| codem-inventory | `codem-inventory/html/itemimages/` |
| origen_inventory | `origen_inventory/ui/images/` |

<ItemImageGrid
  title="Yacht Item Images"
  zipName="sd-yacht-images"
  :images="[
    { src: '/items/yacht/casinocodes.png', name: 'casinocodes.png', alt: 'Casino Codes' },
    { src: '/items/yacht/default_gateway_override.png', name: 'default_gateway_override.png', alt: 'Gateway Override' },
    { src: '/items/yacht/expensive_champagne.png', name: 'expensive_champagne.png', alt: 'Expensive Champagne' },
    { src: '/items/yacht/revivekit.png', name: 'revivekit.png', alt: 'Revive Kit' },
    { src: '/items/yacht/secured_safe.png', name: 'secured_safe.png', alt: 'Secured Safe' },
    { src: '/items/yacht/yachtcodes.png', name: 'yachtcodes.png', alt: 'Yacht Codes' },
  ]"
/>

::: tip
If you are using a custom inventory, place the images wherever your inventory loads item icons from.
:::

## Step 4: Start and Verify

1. Start your server
2. Check the server console for any errors
3. Look for the **Secured Yacht** blip on the map (if enabled)
4. Ensure the minimum police requirement is met (default: 4 cops)
5. You need `yachtcodes` item to start the heist

::: warning
Make sure `sd_lib` is started **before** sd-yacht in your server.cfg, or the resource will fail to load.
:::

::: tip
No database tables are required. All heist state is managed in memory and resets on server restart.
:::

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
