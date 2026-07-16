# Installation

Follow these steps to install sd-pettycrime on your FiveM server.

## Supported Inventories

| Inventory | Status |
|---|---|
| `ox_inventory` | Supported |
| `qb-inventory` | Supported |
| `qs-inventory` / `qs-inventory-pro` | Supported |
| `origen_inventory` | Supported |
| `codem-inventory` | Supported |
| `jaksam_inventory` | Supported |
| `ps-inventory` | Supported |
| `lj-inventory` | Supported |
| `tgiann-inventory` | Supported |

::: tip Recommendation
We heavily recommend using `ox_inventory` - it's the best inventory system available and more importantly, it's completely free and open source! You won't be missing out on any features in our scripts if you use a different inventory, this is simply a recommendation.
:::

## Minigames

::: info No external minigame resource required
Petty Crimes ships its own **built-in library of 21 minigames**. You do **not** need `ps-ui`, `SN-Hacking`, or any other minigame resource. Every crime has one enabled by default, and you can swap it per-crime for any other built-in (or your own function that returns `true`/`false`) right in the config. See the [Configuration](./configuration#minigames) page for the full list and tuning options.
:::

## Dependencies

Ensure the following dependencies are installed and running on your server before starting:

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` / `qbx_core` / `es_extended` |
| **ox_lib** | Yes | |
| **oxmysql** | Yes | |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` |
| **Inventory** | Yes | Any of the supported inventories listed above |

::: tip
Framework, target system, and inventory are all automatically detected - no configuration needed. The required database tables are also created automatically on first start.
:::

## <span class="step-num">1</span> Add the Resource

1. Download the latest version of `sd-pettycrime` from the [CFX Portal](https://portal.cfx.re/assets/granted-assets)
2. Extract it into your server's `resources` directory
3. Ensure the resource is started in your `server.cfg` (or `resources.cfg`). Ensuring the sub-folder (i.e. `ensure [sd]`) works too, provided dependencies start first. Example:

```cfg
ensure ox_lib
ensure oxmysql
ensure qb-core

ensure sd-pettycrime
```

## <span class="step-num">2</span> Add Items

Petty Crimes uses a set of **tool items** that players need to commit each crime, plus a couple of **loot items**. Register the ones you intend to use in your inventory system.

### Tool & Loot Items

::: code-group

```lua [ox_inventory]
['screwdriver'] = {
    label = 'Screwdriver',
    weight = 300,
    stack = true,
    close = true,
    description = 'A flathead screwdriver for prying coin boxes and unbolting fixtures.',
},
['wirecutter'] = {
    label = 'Wire Cutters',
    weight = 600,
    stack = true,
    close = true,
    description = 'Sharp wire cutters that slice through brake lines and wiring.',
},
['cutter'] = {
    label = 'Box Cutter',
    weight = 200,
    stack = true,
    close = true,
    description = 'A retractable box cutter - sharp enough to slash tyres and puncture tanks.',
},
['multitool'] = {
    label = 'Multitool',
    weight = 400,
    stack = true,
    close = true,
    description = 'A folding multitool that handles meters, news racks, and signs.',
},
['powersaw'] = {
    label = 'Power Saw',
    weight = 4000,
    stack = true,
    close = true,
    description = 'A cordless reciprocating saw for cutting through metal.',
},
['anglegrinder'] = {
    label = 'Angle Grinder',
    weight = 3500,
    stack = true,
    close = true,
    description = 'A battery angle grinder that chews through converters and AC units.',
},
['bolt_cutter'] = {
    label = 'Bolt Cutters',
    weight = 2500,
    stack = true,
    close = true,
    description = 'Long-handled bolt cutters for chains, bolts, and converter mounts.',
},
['oxycutter'] = {
    label = 'Oxy Cutter',
    weight = 4000,
    stack = true,
    close = true,
    description = 'An oxy-acetylene cutting torch that slices through catalytic converters and AC units in seconds.',
},
['brick'] = {
    label = 'Brick',
    weight = 2000,
    stack = true,
    close = true,
    description = 'A heavy clay brick. Wedge it on a gas pedal to send a car running.',
},
['porch_package'] = {
    label = 'Porch Package',
    weight = 1000,
    stack = false,
    close = true,
    consume = 0,
    description = 'A swiped porch delivery. Use it to open it up and see what was inside.',
    server = { export = 'sd-pettycrime.usePorch_package' },
},
['mail_package'] = {
    label = 'Mail Bundle',
    weight = 300,
    stack = false,
    close = true,
    consume = 0,
    description = 'A bundle of stolen mail. Use it to open it up and see what was inside.',
    server = { export = 'sd-pettycrime.useMail_package' },
},
['skimmer'] = {
    label = 'Card Skimmer',
    weight = 250,
    stack = true,
    close = true,
    description = 'Install on an ATM, then slot in a USB to record card data. Wears out the longer it runs.',
},
['atm_skimmer_usb'] = {
    label = 'Card Data USB',
    weight = 50,
    stack = true,
    close = true,
    description = 'A USB stick for an ATM card skimmer. Stores stolen card data when slotted into an installed skimmer.',
},
['speed_bomb'] = {
    label = 'Speedbomb',
    weight = 1500,
    stack = true,
    close = true,
    description = 'Wire it under a parked vehicle. Arms when driven fast and blows if the speed drops.',
},
['catalytic_converter'] = {
    label = 'Catalytic Converter',
    weight = 2500,
    stack = true,
    close = true,
    description = 'A sawn-off catalytic converter, packed with precious metals and worth a fortune to the right buyer.',
},
```

```lua [qb-core]
['screwdriver'] = { name = 'screwdriver', label = 'Screwdriver', weight = 300, type = 'item', image = 'screwdriver.png', unique = false, useable = false, shouldClose = true, description = 'A flathead screwdriver for prying coin boxes and unbolting fixtures.' },
['wirecutter'] = { name = 'wirecutter', label = 'Wire Cutters', weight = 600, type = 'item', image = 'wirecutter.png', unique = false, useable = false, shouldClose = true, description = 'Sharp wire cutters that slice through brake lines and wiring.' },
['cutter'] = { name = 'cutter', label = 'Box Cutter', weight = 200, type = 'item', image = 'cutter.png', unique = false, useable = false, shouldClose = true, description = 'A retractable box cutter - sharp enough to slash tyres and puncture tanks.' },
['multitool'] = { name = 'multitool', label = 'Multitool', weight = 400, type = 'item', image = 'multitool.png', unique = false, useable = false, shouldClose = true, description = 'A folding multitool that handles meters, news racks, and signs.' },
['powersaw'] = { name = 'powersaw', label = 'Power Saw', weight = 4000, type = 'item', image = 'powersaw.png', unique = false, useable = false, shouldClose = true, description = 'A cordless reciprocating saw for cutting through metal.' },
['anglegrinder'] = { name = 'anglegrinder', label = 'Angle Grinder', weight = 3500, type = 'item', image = 'anglegrinder.png', unique = false, useable = false, shouldClose = true, description = 'A battery angle grinder that chews through converters and AC units.' },
['bolt_cutter'] = { name = 'bolt_cutter', label = 'Bolt Cutters', weight = 2500, type = 'item', image = 'bolt_cutter.png', unique = false, useable = false, shouldClose = true, description = 'Long-handled bolt cutters for chains, bolts, and converter mounts.' },
['oxycutter'] = { name = 'oxycutter', label = 'Oxy Cutter', weight = 4000, type = 'item', image = 'oxycutter.png', unique = false, useable = false, shouldClose = true, description = 'An oxy-acetylene cutting torch that slices through catalytic converters and AC units in seconds.' },
['brick'] = { name = 'brick', label = 'Brick', weight = 2000, type = 'item', image = 'brick.png', unique = false, useable = false, shouldClose = true, description = 'A heavy clay brick. Wedge it on a gas pedal to send a car running.' },
['porch_package'] = { name = 'porch_package', label = 'Porch Package', weight = 1000, type = 'item', image = 'porch_package.png', unique = false, useable = true, shouldClose = true, description = 'A swiped porch delivery. Use it to open it up and see what was inside.' },
['mail_package'] = { name = 'mail_package', label = 'Mail Bundle', weight = 300, type = 'item', image = 'mail_package.png', unique = false, useable = true, shouldClose = true, description = 'A bundle of stolen mail. Use it to open it up and see what was inside.' },
['skimmer'] = { name = 'skimmer', label = 'Card Skimmer', weight = 250, type = 'item', image = 'skimmer.png', unique = false, useable = false, shouldClose = true, description = 'Install on an ATM, then slot in a USB to record card data. Wears out the longer it runs.' },
['atm_skimmer_usb'] = { name = 'atm_skimmer_usb', label = 'Card Data USB', weight = 50, type = 'item', image = 'atm_skimmer_usb.png', unique = false, useable = false, shouldClose = true, description = 'A USB stick for an ATM card skimmer. Stores stolen card data when slotted into an installed skimmer.' },
['speed_bomb'] = { name = 'speed_bomb', label = 'Speedbomb', weight = 1500, type = 'item', image = 'speed_bomb.png', unique = false, useable = false, shouldClose = true, description = 'Wire it under a parked vehicle. Arms when driven fast and blows if the speed drops.' },
['catalytic_converter'] = { name = 'catalytic_converter', label = 'Catalytic Converter', weight = 2500, type = 'item', image = 'catalytic_converter.png', unique = false, useable = false, shouldClose = true, description = 'A sawn-off catalytic converter, packed with precious metals and worth a fortune to the right buyer.' },
```

```sql [ESX]
-- Register the items in your ESX `items` table
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    ('screwdriver',   'Screwdriver',    300, 0, 1),
    ('wirecutter',    'Wire Cutters',   600, 0, 1),
    ('cutter',        'Box Cutter',     200, 0, 1),
    ('multitool',     'Multitool',      400, 0, 1),
    ('powersaw',      'Power Saw',     4000, 0, 1),
    ('anglegrinder',  'Angle Grinder', 3500, 0, 1),
    ('bolt_cutter',    'Bolt Cutters',  2500, 0, 1),
    ('brick',          'Brick',         2000, 0, 1),
    ('porch_package',  'Porch Package', 1000, 0, 1),
    ('mail_package',   'Mail Bundle',    300, 0, 1),
    ('skimmer',        'Card Skimmer',   250, 0, 1),
    ('atm_skimmer_usb','Card Data USB',   50, 0, 1),
    ('speed_bomb',     'Speedbomb',     1500, 0, 1),
    ('oxycutter',      'Oxy Cutter',    4000, 0, 1),
    ('catalytic_converter','Catalytic Converter', 2500, 0, 1);
```

:::

### Tool-to-Crime Mapping

Each crime accepts one tool from its `Items` array (**any one is enough**). These are the defaults each crime ships with - change a crime's `Items` in `configs/<crime>.lua` to require different tools. Entries prefixed `WEAPON_` are vanilla GTA weapons that ship with the game (no item setup needed).

| Crime | Config | Default tool(s) |
|---|---|---|
| Mailbox | `mailbox.lua` | `WEAPON_HAMMER` |
| Payphone | `payphone.lua` | `screwdriver`, `multitool` |
| Parking meter | `parkingmeter.lua` | `screwdriver`, `multitool` |
| News rack | `newsrack.lua` | `screwdriver`, `multitool` |
| Vending machine | `vending.lua` | `WEAPON_HAMMER` |
| Smash & grab | `smashgrab.lua` | `WEAPON_HAMMER` |
| Street sign theft | `signrob.lua` | `screwdriver`, `WEAPON_WRENCH`, `multitool` |
| Catalytic converter | `catalytic.lua` | `powersaw`, `anglegrinder`, `oxycutter`, `bolt_cutter`, `WEAPON_HATCHET` |
| AC unit strip | `acstrip.lua` | `powersaw`, `anglegrinder`, `bolt_cutter`, `WEAPON_HATCHET` |
| Wheel theft | `tiretheft.lua` | `WEAPON_WRENCH` |
| Wheel loosening | `wheelloose.lua` | `WEAPON_WRENCH` |
| Tyre slashing | `tireslash.lua` | `cutter` |
| Brake-line cutting | `brakecut.lua` | `wirecutter`, `cutter` |
| Fuel-tank sabotage | `fuelsabotage.lua` | `cutter` |

Crimes not listed - **pickpocketing**, **armed ped robbery**, **shoplifting**, **brick on the gas** (`brick`), **ATM skimming** (`skimmer` + `atm_skimmer_usb`), **speed bomb** (`speed_bomb`) and **parcel theft** - use no tool or a dedicated item set in their own config.

::: tip
Example - make catalytic theft require any cutting tool:
```lua
-- configs/catalytic.lua
Items = { 'powersaw', 'anglegrinder', 'oxycutter', 'bolt_cutter', 'WEAPON_HATCHET' },
```
:::

## <span class="step-num">3</span> Add Item Images

Copy the item images from `sd-pettycrime/images/` into your inventory's image folder (e.g. `ox_inventory/web/images/`). You can also download them directly from the container below.

<ItemImageGrid
  title="Petty Crimes Item Images"
  zipName="sd-pettycrime-images"
  :images="[
    { src: '/items/pettycrime/screwdriver.png', name: 'screwdriver.png', alt: 'Screwdriver' },
    { src: '/items/pettycrime/wirecutter.png', name: 'wirecutter.png', alt: 'Wire Cutters' },
    { src: '/items/pettycrime/cutter.png', name: 'cutter.png', alt: 'Box Cutter' },
    { src: '/items/pettycrime/multitool.png', name: 'multitool.png', alt: 'Multitool' },
    { src: '/items/pettycrime/powersaw.png', name: 'powersaw.png', alt: 'Power Saw' },
    { src: '/items/pettycrime/anglegrinder.png', name: 'anglegrinder.png', alt: 'Angle Grinder' },
    { src: '/items/pettycrime/bolt_cutter.png', name: 'bolt_cutter.png', alt: 'Bolt Cutters' },
    { src: '/items/pettycrime/oxycutter.png', name: 'oxycutter.png', alt: 'Oxy Cutter' },
    { src: '/items/pettycrime/brick.png', name: 'brick.png', alt: 'Brick' },
    { src: '/items/pettycrime/porch_package.png', name: 'porch_package.png', alt: 'Porch Package' },
    { src: '/items/pettycrime/mail_package.png', name: 'mail_package.png', alt: 'Mail Bundle' },
    { src: '/items/pettycrime/skimmer.png', name: 'skimmer.png', alt: 'Card Skimmer' },
    { src: '/items/pettycrime/atm_skimmer_usb.png', name: 'atm_skimmer_usb.png', alt: 'Card Data USB' },
    { src: '/items/pettycrime/speed_bomb.png', name: 'speed_bomb.png', alt: 'Speedbomb' },
    { src: '/items/pettycrime/catalytic_converter.png', name: 'catalytic_converter.png', alt: 'Catalytic Converter' },
  ]"
/>

## <span class="step-num">4</span> Start the Resource

To load the resource, you can either:

- **Restart your server** entirely, or
- Run the following in your **server console** (F8 or txAdmin live console):

```cfg
refresh
ensure sd-pettycrime
```

The required database tables (`pettycrimes`, `sd_pettycrime_admin`, `sd_pettycrime_history`) are created automatically on first start.

## Configuration

Configure the resource to fit your server. See the [Configuration](./configuration) page for detailed explanations of every setting, or edit the files directly in the resource's `configs/` folder.
