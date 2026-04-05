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
| **Doorlock** | Yes | `ox_doorlock` / `qb-doorlock` / `nui_doorlock` |
| **mka-lasers** | Optional | For laser grid |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` |
| **Minigame** | Yes | Any of the supported minigames listed above |
| **Inventory** | Yes | Any of the supported inventories listed above |

::: tip
Framework, target system, doorlock, and inventory are all automatically detected — no configuration needed.
:::

## <span class="step-num">1</span> Add the Resource

1. Download the latest version of `sd-pacificbank` from the [CFX Portal](https://portal.cfx.re/assets/granted-assets)
2. Extract it into your server's `resources` directory
3. Ensure the resource is started in your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before. Here's an example:

```cfg
ensure sd_lib
ensure ox_lib
ensure ox_doorlock
ensure mka-lasers
ensure qb-core

ensure sd-pacificbank
```

## <span class="step-num">2</span> Import Doorlock Data

The Pacific Bank uses **13 security doors**. Import the doorlock config that matches your doorlock system from the `sd-pacificbank/doorlock/` folder:

| Doorlock System | What to do |
|---|---|
| `ox_doorlock` | Import `doorlock/ox_doorlock/oxDoorlock.sql` into your database |
| `qb-doorlock` / `nui_doorlock` | Place `doorlock/qb-nui_doorlock/pacificbank.lua` into your doorlock resource's configs folder, or copy its contents into your main doorlock config |

## <span class="step-num">3</span> Add Items

Register the required heist items in your inventory system:

::: code-group

```lua [ox_inventory]
['laptop_pink'] = {
    label = 'Pink Laptop',
    weight = 5000,
    close = true,
    description = 'A pink security Laptop',
},
['laptop_gold'] = {
    label = 'Gold Laptop',
    weight = 5000,
    close = true,
    description = 'A gold security Laptop',
},
['c4_bomb'] = {
    label = 'C4 Brick',
    weight = 1000,
    close = true,
    description = 'Very Dangerous! High-Yield Explosive.',
},
['large_drill'] = {
    label = 'Large Drill',
    weight = 20000,
    close = true,
    description = 'A Large Drill, good at cracking Secure Locks.',
},
```

```lua [qb-core]
['laptop_pink'] = { name = 'laptop_pink', label = 'Pink Laptop',  weight = 5000,  type = 'item', image = 'laptop_pink.png', unique = true,  useable = true,  shouldClose = true, description = 'A pink security Laptop' },
['laptop_gold'] = { name = 'laptop_gold', label = 'Gold Laptop',  weight = 5000,  type = 'item', image = 'laptop_gold.png', unique = true,  useable = true,  shouldClose = true, description = 'A gold security Laptop' },
['c4_bomb']     = { name = 'c4_bomb',     label = 'C4 Brick',     weight = 1000,  type = 'item', image = 'c4_bomb.png',     unique = true,  useable = false, shouldClose = true, description = 'Very Dangerous! High-Yield Explosive.' },
['large_drill'] = { name = 'large_drill', label = 'Large Drill',  weight = 20000, type = 'item', image = 'large_drill.png', unique = false, useable = false, shouldClose = false, description = 'A Large Drill, good at cracking Secure Locks.' },
```

```sql [ESX]
INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('laptop_pink', 'Pink Laptop', 50),
  ('laptop_gold', 'Gold Laptop', 50),
  ('c4_bomb', 'C4 Brick', 10),
  ('large_drill', 'Large Drill', 200);
```

:::

## <span class="step-num">4</span> Add Item Images

Copy the item images from `sd-pacificbank/images/` to your inventory's image folder. You can also download them directly from the container below.

<ItemImageGrid
  title="Pacific Bank Item Images"
  zipName="sd-pacificbank-images"
  :images="[
    { src: '/items/pacificbank/laptop_pink.png', name: 'laptop_pink.png', alt: 'Laptop (Pink)' },
    { src: '/items/pacificbank/laptop_gold.png', name: 'laptop_gold.png', alt: 'Laptop (Gold)' },
    { src: '/items/pacificbank/c4_bomb.png', name: 'c4_bomb.png', alt: 'C4 Bomb' },
    { src: '/items/pacificbank/large_drill.png', name: 'large_drill.png', alt: 'Large Drill' },
  ]"
/>

## <span class="step-num">5</span> Start the Resource

To load the resource, you can either:

- **Restart your server** entirely, or
- Run the following commands in your **server console** (F8 or txAdmin live console):

```cfg
refresh
ensure sd-pacificbank
```

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
