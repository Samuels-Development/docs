# Installation

Follow these steps to install sd-bombs on your FiveM server.

## Supported Inventories

| Inventory | Status |
|---|---|
| `ox_inventory` | Supported |
| `qb-inventory` | Supported |
| `qs-inventory` / `qs-inventory-pro` | Supported |
| `origen_inventory` | Supported |
| `codem-inventory` | Supported |
| `jaksam_inventory` | Supported |
| `tgiann-inventory` | Supported |
| `one_inventory` | Supported |

::: tip Recommendation
We heavily recommend using `ox_inventory` - it's the best inventory system available and more importantly, it's completely free and open source! You won't be missing out on any features in our scripts if you use a different inventory, this is simply a recommendation.
:::

::: info Item metadata
A bomb built at a workbench is handed over as an `sd_bomb` item that carries its build - its size, modules, edgework, charge, and clock - in the item's **metadata**. Every inventory above supports metadata. The item also shows a different image for each bomb size.
:::

## Dependencies

Ensure the following dependencies are installed and running on your server before starting:

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` / `qbx_core` / `es_extended` |
| **ox_lib** | Yes | |
| **Inventory** | Yes | Any of the supported inventories listed above |
| **Target System** | Optional | `ox_target` for benches and planted bombs - falls back to an `[E]` prompt without it |

::: tip
Framework, inventory, and target system are all automatically detected - no configuration needed. There is **no database**: walls, bombs, workbenches, and what lies on them are saved to JSON files in the resource's `data/` folder.
:::

## <span class="step-num">1</span> Add the Resource

1. Download the latest version of `sd-bombs` from the [CFX Portal](https://portal.cfx.re/assets/granted-assets)
2. Extract it into your server's `resources` directory
3. Ensure the resource is started in your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before. Here's an example:

```cfg
ensure ox_lib
ensure qbx_core
ensure ox_inventory

ensure sd-bombs
```

## <span class="step-num">2</span> Add Items

Register every item in your inventory system. The **bomb**, **manual**, **casing kits**, **workbench**, and **wall kits** are usable; the modules, tools, explosive, and supplies are parts - players drag them onto a workbench from the kit bag.

::: code-group

```lua [ox_inventory]
-- Bombs & manual
['sd_bomb'] = {
    label = 'Briefcase Bomb',
    weight = 6500,
    stack = false,
    close = true,
    consume = 0,
    description = 'A reinforced case packed with wiring, a keypad, and a very loud clock. Use it to set it down and arm it. Whoever opens it had better have someone reading the manual.',
    server = { export = 'sd-bombs.useSd_bomb' },
},
['sd_bomb_manual'] = {
    label = 'Bomb Defusal Field Manual',
    weight = 450,
    stack = false,
    close = true,
    consume = 0,
    description = 'EYES ONLY - EXPERTS. A dog-eared binder from the Department of Things That Tick. Use it to read it - and talk the Defuser through whatever is ticking in front of them.',
    server = { export = 'sd-bombs.useSd_bomb_manual' },
},
-- Casing kits & explosive
['sd_bomb_kit'] = {
    label = 'Bomb Casing Kit',
    weight = 3000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A bomb casing in its carton, taped shut: the case, its countdown timer and wiring loom, no modules fitted. Stand it on a workbench\'s mat, slit the tape with a knife and lift the casing out.',
    server = { export = 'sd-bombs.useSd_bomb_kit' },
},
['sd_bomb_kit_small'] = {
    label = 'Wren Casing Kit (Small)',
    weight = 1100,
    stack = true,
    close = true,
    consume = 0,
    description = 'Harlow Instrument Co. Wren compact casing in its carton: two front bays - one of them the timer - and a cell for one block of explosive. Unpack it at a bomb workbench.',
    server = { export = 'sd-bombs.useSd_bomb_kit_small' },
},
['sd_bomb_kit_medium'] = {
    label = 'Kestrel Casing Kit (Medium)',
    weight = 2200,
    stack = true,
    close = true,
    consume = 0,
    description = 'Harlow Instrument Co. Kestrel compact casing in its carton: four front bays and two cells for explosive. Unpack it at a bomb workbench.',
    server = { export = 'sd-bombs.useSd_bomb_kit_medium' },
},
['sd_bomb_kit_large'] = {
    label = 'Osprey Casing Kit (Large)',
    weight = 3400,
    stack = true,
    close = true,
    consume = 0,
    description = 'Harlow Instrument Co. Osprey compact casing in its carton: six front bays and four cells for explosive. Unpack it at a bomb workbench.',
    server = { export = 'sd-bombs.useSd_bomb_kit_large' },
},
['sd_explosive'] = {
    label = 'Plastic Explosive',
    weight = 570,
    stack = true,
    close = true,
    description = 'A demolition block in its olive wrapper. Step one of any bomb: pack blocks into the open casing at a workbench - the more you pack (up to six), the bigger the blast and the hole it leaves in a wall.',
},
-- Workbench & supplies
['sd_workbench'] = {
    label = 'Bomb Workbench',
    weight = 25000,
    stack = false,
    close = true,
    consume = 0,
    description = 'Harlow Instrument Co. field assembly bench, flat-packed: frame, top, pegboard and lamp. Use it to set the bench up where you stand it. Empty, it packs back down.',
    server = { export = 'sd-bombs.useSd_workbench' },
},
['sd_assembly_book'] = {
    label = 'Field Assembly Handbook',
    weight = 650,
    stack = true,
    close = true,
    description = 'Harlow Instrument Co. Field Assembly Handbook, HIC-44. Place on the workbench lectern for reference procedures, component specifications and inspection notes. Laboratory use only.',
},
['sd_screw_box'] = {
    label = 'Instrument Screws (box)',
    weight = 350,
    stack = true,
    close = true,
    description = 'Harlow Instrument Co. Pattern 6 machine screws, 48 to the box. Put it down on a workbench and tip it out: every module plate takes three, every charge bracket two.',
},
['sd_wire_box'] = {
    label = 'Wire Spool Kit',
    weight = 600,
    stack = true,
    close = true,
    description = 'Six reels of insulated electrical wire, four lengths per colour. Drag the kit onto the workbench wire rack to stock its empty slots, or cut wire directly from the kit.',
},
['sd_charge_bracket'] = {
    label = 'Charge Bracket',
    weight = 150,
    stack = true,
    close = true,
    description = 'Harlow Instrument Co. Pattern 3 cell saddle. Drop it into a cell of an open casing and drive its two screws: only then does that cell take a block of charge.',
},
['sd_retaining_strap'] = {
    label = 'Retaining Strap',
    weight = 45,
    stack = true,
    close = true,
    description = 'Harlow Instrument Co. Pattern 7 retaining band. Fit to either saddle anchor, then draw tight with the band tensioner. Replace after cutting.',
},
-- Modules
['sd_mod_wires'] = {
    label = 'Module: Wires',
    weight = 350,
    stack = true,
    close = true,
    description = 'Bomb module. A row of coloured wires; one of them is the right one to cut. Fit it to a casing kit.',
},
['sd_mod_button'] = {
    label = 'Module: The Button',
    weight = 400,
    stack = true,
    close = true,
    description = 'Bomb module. One big button - press it, or hold it and wait for the right moment. Fit it to a casing kit.',
},
['sd_mod_keypads'] = {
    label = 'Module: Keypads',
    weight = 400,
    stack = true,
    close = true,
    description = 'Bomb module. Four strange symbols to press in the right order. Fit it to a casing kit.',
},
['sd_mod_simon'] = {
    label = 'Module: Simon Says',
    weight = 400,
    stack = true,
    close = true,
    description = 'Bomb module. Four coloured pads that flash a sequence to answer - differently with every strike. Fit it to a casing kit.',
},
['sd_mod_whos_on_first'] = {
    label = 'Module: Who\'s on First',
    weight = 450,
    stack = true,
    close = true,
    description = 'Bomb module. A display, six words, and a manual page built to make you argue. Fit it to a casing kit.',
},
['sd_mod_memory'] = {
    label = 'Module: Memory',
    weight = 450,
    stack = true,
    close = true,
    description = 'Bomb module. Five stages, each asking what you pressed before. Fit it to a casing kit.',
},
['sd_mod_morse'] = {
    label = 'Module: Morse Code',
    weight = 450,
    stack = true,
    close = true,
    description = 'Bomb module. A lamp blinking a word in Morse; tune the radio to its frequency. Fit it to a casing kit.',
},
['sd_mod_complicated_wires'] = {
    label = 'Module: Complicated Wires',
    weight = 450,
    stack = true,
    close = true,
    description = 'Bomb module. Wires with stripes, stars and LEDs, and a Venn diagram to settle each one. Fit it to a casing kit.',
},
['sd_mod_wire_sequences'] = {
    label = 'Module: Wire Sequences',
    weight = 450,
    stack = true,
    close = true,
    description = 'Bomb module. Panel after panel of wires, counted by colour as you go. Fit it to a casing kit.',
},
['sd_mod_mazes'] = {
    label = 'Module: Mazes',
    weight = 450,
    stack = true,
    close = true,
    description = 'Bomb module. A maze whose walls only the Expert can see. Fit it to a casing kit.',
},
['sd_mod_passwords'] = {
    label = 'Module: Passwords',
    weight = 450,
    stack = true,
    close = true,
    description = 'Bomb module. Five letter wheels that spell exactly one word. Fit it to a casing kit.',
},
['sd_mod_venting_gas'] = {
    label = 'Needy Module: Venting Gas',
    weight = 500,
    stack = true,
    close = true,
    description = 'Needy bomb module. It cannot be disarmed: it wakes up and asks questions until the bomb is done. Fit it to a casing kit.',
},
['sd_mod_capacitor'] = {
    label = 'Needy Module: Capacitor Discharge',
    weight = 500,
    stack = true,
    close = true,
    description = 'Needy bomb module. It cannot be disarmed: keep pulling the lever or it blows. Fit it to a casing kit.',
},
['sd_mod_knobs'] = {
    label = 'Needy Module: Knobs',
    weight = 500,
    stack = true,
    close = true,
    description = 'Needy bomb module. It cannot be disarmed: turn the dial the way the lamps say, again and again. Fit it to a casing kit.',
},
-- Bench tools
['sd_tool_driver'] = {
    label = 'Cordless Driver',
    weight = 1600,
    stack = true,
    close = true,
    description = 'An 18 V drill-driver. Stand it on a bomb workbench\'s shelf and it drives (and backs out) the screws that hold modules down, fast. It stays on that bench until somebody takes it.',
},
['sd_tool_screwdriver'] = {
    label = 'Screwdriver',
    weight = 120,
    stack = true,
    close = true,
    description = 'A plain cross-head screwdriver. Hang it on a bomb workbench: it does what the cordless driver does, by hand - slowly.',
},
['sd_tool_hexkey'] = {
    label = 'T-Handle Hex Key',
    weight = 110,
    stack = true,
    close = true,
    description = 'The front of a bomb casing is held by four hex bolts. Hang this on a workbench\'s pegboard to drive them - a screwdriver will not.',
},
['sd_tool_knife'] = {
    label = 'Utility Knife',
    weight = 140,
    stack = true,
    close = true,
    description = 'A casing kit comes taped shut. Hang this on a workbench\'s pegboard and slit the kit open with it.',
},
['sd_tool_pliers'] = {
    label = 'Combination Pliers',
    weight = 260,
    stack = true,
    close = true,
    description = 'Every block of explosive packed into a casing gets a detonator cap crimped into it. Hang these on a workbench\'s pegboard to do it.',
},
['sd_tool_cutters'] = {
    label = 'Side Cutters',
    weight = 220,
    stack = true,
    close = true,
    description = 'Harlow Instrument Co. side cutters. Cut wire from a stocked spool to length before stripping its ends.',
},
['sd_tool_strippers'] = {
    label = 'Wire Strippers',
    weight = 180,
    stack = true,
    close = true,
    description = 'A module is only part of the bomb once it is wired in. Hang these on a workbench\'s pegboard to wire in every module you fit.',
},
['sd_tool_tensioner'] = {
    label = 'Band Tensioner',
    weight = 900,
    stack = true,
    close = true,
    description = 'Harlow Instrument Co. Model 7 strapping ratchet. Hang it on a workbench pegboard: every block of charge is strapped down in its bracket with a steel band, pumped tight and sealed.',
},
['sd_tool_multimeter'] = {
    label = 'Multimeter',
    weight = 420,
    stack = true,
    close = true,
    description = 'The last job before a bomb is assembled: prove the circuit. Hang it on a workbench\'s pegboard; test again after any change.',
},
['sd_tool_camkey'] = {
    label = 'Cam Key',
    weight = 140,
    stack = true,
    close = true,
    description = 'Harlow Instrument Co. indexing key. Hang it on a bomb workbench: it turns the cartridge collar of a compact casing into register.',
},
['sd_tool_trimgauge'] = {
    label = 'Trim Gauge',
    weight = 360,
    stack = true,
    close = true,
    description = 'Harlow Instrument Co. trim gauge. Hang it on a bomb workbench: it centres the floating cradle of a compact casing and trims its carrier stops.',
},
['sd_tool_signalprobe'] = {
    label = 'Signal Probe',
    weight = 170,
    stack = true,
    close = true,
    description = 'Harlow Instrument Co. signal probe. Hang it on a bomb workbench: it traces the contacts of a compact casing and captures its diagnostic pulses.',
},
-- Wall kits
['wallkit_drywall'] = {
    label = 'Stud Wall Kit',
    weight = 6000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Plasterboard on timber studs. Anything that goes bang gets through it. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_wood_planks'] = {
    label = 'Plank Wall Kit',
    weight = 7000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Weathered planking on a frame. Anything that goes bang gets through it. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_corrugated_metal'] = {
    label = 'Corrugated Iron Wall Kit',
    weight = 7000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Corrugated sheeting on a steel frame. Anything that goes bang gets through it. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_stucco_old'] = {
    label = 'Rendered Wall Kit',
    weight = 9000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. An old rendered wall, stains included. Anything that goes bang gets through it. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_wood_painted'] = {
    label = 'Painted Plank Wall Kit',
    weight = 9000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Painted timber planks on a frame. Anything that goes bang gets through. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_roller_shutter'] = {
    label = 'Roller Shutter Wall Kit',
    weight = 8000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. A steel roller shutter on a frame. Anything that goes bang gets through. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_brick_red'] = {
    label = 'Red Brick Wall Kit',
    weight = 12000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Proper red brick. Takes a grenade or better to breach. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_brick_painted'] = {
    label = 'Painted Brick Wall Kit',
    weight = 12000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Brick under a coat of blue paint. Takes a grenade or better to breach. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_cinder_block'] = {
    label = 'Cinder Block Wall Kit',
    weight = 12000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Dark cinder block. Takes a grenade or better to breach. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_ledgestone'] = {
    label = 'Stacked Stone Wall Kit',
    weight = 14000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Dry-stacked stone. Takes a grenade or better to breach. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_tile_white'] = {
    label = 'White Tile Wall Kit',
    weight = 14000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. White ceramic tiles over blockwork. A grenade or better gets through. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_rusted_sheet'] = {
    label = 'Rusted Sheet-Steel Wall Kit',
    weight = 12000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Rust-streaked painted sheet steel. A grenade or better gets through. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_stone_block'] = {
    label = 'Stone Block Wall Kit',
    weight = 16000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Rough-cut stone blocks. Takes a sticky bomb or a rocket to breach. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_concrete'] = {
    label = 'Concrete Wall Kit',
    weight = 16000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Board-formed poured concrete. Takes a sticky bomb or a rocket to breach. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_concrete_painted'] = {
    label = 'Painted Concrete Wall Kit',
    weight = 18000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Poured concrete under flaking green paint. Takes a sticky bomb, a rocket or better. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_sandstone'] = {
    label = 'Sandstone Wall Kit',
    weight = 19000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Rock-faced sandstone blocks. Takes a sticky bomb, a rocket or better. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_basalt_stone'] = {
    label = 'Basalt Wall Kit',
    weight = 19000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Tightly fitted basalt stones. Takes a sticky bomb, a rocket or better. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_castle_stone'] = {
    label = 'Castle Stone Wall Kit',
    weight = 22000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Massive dressed ashlar blocks. Only a tank shell or a briefcase bomb gets through. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_concrete_reinforced'] = {
    label = 'Reinforced Concrete Wall Kit',
    weight = 20000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Concrete with a steel mesh inside. Only a tank shell or a briefcase bomb gets through. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
['wallkit_steel_plate'] = {
    label = 'Steel Plate Wall Kit',
    weight = 20000,
    stack = true,
    close = true,
    consume = 0,
    description = 'A flat-packed 2 m x 3 m breakable wall module. Riveted steel plate. Only a tank shell or a briefcase bomb gets through. Use it to set it up; aim next to a standing wall to join onto it.',
    server = { export = 'sd-bombs.useWallKit' },
},
```

```lua [qb-core / qbx_core]
-- Bombs & manual
['sd_bomb']                     = { name = 'sd_bomb',                      label = 'Briefcase Bomb',                    weight = 6500,  type = 'item', image = 'sd_bomb.png',                      unique = true , useable = true , shouldClose = true, description = 'A reinforced case packed with wiring, a keypad, and a very loud clock. Use it to set it down and arm it. Whoever opens it had better have someone reading the manual.' },
['sd_bomb_manual']              = { name = 'sd_bomb_manual',               label = 'Bomb Defusal Field Manual',         weight = 450,   type = 'item', image = 'sd_bomb_manual.png',               unique = true , useable = true , shouldClose = true, description = 'EYES ONLY - EXPERTS. A dog-eared binder from the Department of Things That Tick. Use it to read it - and talk the Defuser through whatever is ticking in front of them.' },
-- Casing kits & explosive
['sd_bomb_kit']                 = { name = 'sd_bomb_kit',                  label = 'Bomb Casing Kit',                   weight = 3000,  type = 'item', image = 'sd_bomb_kit.png',                  unique = false, useable = true , shouldClose = true, description = 'A bomb casing in its carton, taped shut: the case, its countdown timer and wiring loom, no modules fitted. Stand it on a workbench\'s mat, slit the tape with a knife and lift the casing out.' },
['sd_bomb_kit_small']           = { name = 'sd_bomb_kit_small',            label = 'Wren Casing Kit (Small)',           weight = 1100,  type = 'item', image = 'sd_bomb_kit_small.png',            unique = false, useable = true , shouldClose = true, description = 'Harlow Instrument Co. Wren compact casing in its carton: two front bays - one of them the timer - and a cell for one block of explosive. Unpack it at a bomb workbench.' },
['sd_bomb_kit_medium']          = { name = 'sd_bomb_kit_medium',           label = 'Kestrel Casing Kit (Medium)',       weight = 2200,  type = 'item', image = 'sd_bomb_kit_medium.png',           unique = false, useable = true , shouldClose = true, description = 'Harlow Instrument Co. Kestrel compact casing in its carton: four front bays and two cells for explosive. Unpack it at a bomb workbench.' },
['sd_bomb_kit_large']           = { name = 'sd_bomb_kit_large',            label = 'Osprey Casing Kit (Large)',         weight = 3400,  type = 'item', image = 'sd_bomb_kit_large.png',            unique = false, useable = true , shouldClose = true, description = 'Harlow Instrument Co. Osprey compact casing in its carton: six front bays and four cells for explosive. Unpack it at a bomb workbench.' },
['sd_explosive']                = { name = 'sd_explosive',                 label = 'Plastic Explosive',                 weight = 570,   type = 'item', image = 'sd_explosive.png',                 unique = false, useable = false, shouldClose = true, description = 'A demolition block in its olive wrapper. Step one of any bomb: pack blocks into the open casing at a workbench - the more you pack (up to six), the bigger the blast and the hole it leaves in a wall.' },
-- Workbench & supplies
['sd_workbench']                = { name = 'sd_workbench',                 label = 'Bomb Workbench',                    weight = 25000, type = 'item', image = 'sd_workbench.png',                 unique = true , useable = true , shouldClose = true, description = 'Harlow Instrument Co. field assembly bench, flat-packed: frame, top, pegboard and lamp. Use it to set the bench up where you stand it. Empty, it packs back down.' },
['sd_assembly_book']            = { name = 'sd_assembly_book',             label = 'Field Assembly Handbook',           weight = 650,   type = 'item', image = 'sd_assembly_book.png',             unique = false, useable = false, shouldClose = true, description = 'Harlow Instrument Co. Field Assembly Handbook, HIC-44. Place on the workbench lectern for reference procedures, component specifications and inspection notes. Laboratory use only.' },
['sd_screw_box']                = { name = 'sd_screw_box',                 label = 'Instrument Screws (box)',           weight = 350,   type = 'item', image = 'sd_screw_box.png',                 unique = false, useable = false, shouldClose = true, description = 'Harlow Instrument Co. Pattern 6 machine screws, 48 to the box. Put it down on a workbench and tip it out: every module plate takes three, every charge bracket two.' },
['sd_wire_box']                 = { name = 'sd_wire_box',                  label = 'Wire Spool Kit',                    weight = 600,   type = 'item', image = 'sd_wire_box.png',                  unique = false, useable = false, shouldClose = true, description = 'Six reels of insulated electrical wire, four lengths per colour. Drag the kit onto the workbench wire rack to stock its empty slots, or cut wire directly from the kit.' },
['sd_charge_bracket']           = { name = 'sd_charge_bracket',            label = 'Charge Bracket',                    weight = 150,   type = 'item', image = 'sd_charge_bracket.png',            unique = false, useable = false, shouldClose = true, description = 'Harlow Instrument Co. Pattern 3 cell saddle. Drop it into a cell of an open casing and drive its two screws: only then does that cell take a block of charge.' },
['sd_retaining_strap']          = { name = 'sd_retaining_strap',           label = 'Retaining Strap',                   weight = 45,    type = 'item', image = 'sd_retaining_strap.png',           unique = false, useable = false, shouldClose = true, description = 'Harlow Instrument Co. Pattern 7 retaining band. Fit to either saddle anchor, then draw tight with the band tensioner. Replace after cutting.' },
-- Modules
['sd_mod_wires']                = { name = 'sd_mod_wires',                 label = 'Module: Wires',                     weight = 350,   type = 'item', image = 'sd_mod_wires.png',                 unique = false, useable = false, shouldClose = true, description = 'Bomb module. A row of coloured wires; one of them is the right one to cut. Fit it to a casing kit.' },
['sd_mod_button']               = { name = 'sd_mod_button',                label = 'Module: The Button',                weight = 400,   type = 'item', image = 'sd_mod_button.png',                unique = false, useable = false, shouldClose = true, description = 'Bomb module. One big button - press it, or hold it and wait for the right moment. Fit it to a casing kit.' },
['sd_mod_keypads']              = { name = 'sd_mod_keypads',               label = 'Module: Keypads',                   weight = 400,   type = 'item', image = 'sd_mod_keypads.png',               unique = false, useable = false, shouldClose = true, description = 'Bomb module. Four strange symbols to press in the right order. Fit it to a casing kit.' },
['sd_mod_simon']                = { name = 'sd_mod_simon',                 label = 'Module: Simon Says',                weight = 400,   type = 'item', image = 'sd_mod_simon.png',                 unique = false, useable = false, shouldClose = true, description = 'Bomb module. Four coloured pads that flash a sequence to answer - differently with every strike. Fit it to a casing kit.' },
['sd_mod_whos_on_first']        = { name = 'sd_mod_whos_on_first',         label = 'Module: Who\'s on First',           weight = 450,   type = 'item', image = 'sd_mod_whos_on_first.png',         unique = false, useable = false, shouldClose = true, description = 'Bomb module. A display, six words, and a manual page built to make you argue. Fit it to a casing kit.' },
['sd_mod_memory']               = { name = 'sd_mod_memory',                label = 'Module: Memory',                    weight = 450,   type = 'item', image = 'sd_mod_memory.png',                unique = false, useable = false, shouldClose = true, description = 'Bomb module. Five stages, each asking what you pressed before. Fit it to a casing kit.' },
['sd_mod_morse']                = { name = 'sd_mod_morse',                 label = 'Module: Morse Code',                weight = 450,   type = 'item', image = 'sd_mod_morse.png',                 unique = false, useable = false, shouldClose = true, description = 'Bomb module. A lamp blinking a word in Morse; tune the radio to its frequency. Fit it to a casing kit.' },
['sd_mod_complicated_wires']    = { name = 'sd_mod_complicated_wires',     label = 'Module: Complicated Wires',         weight = 450,   type = 'item', image = 'sd_mod_complicated_wires.png',     unique = false, useable = false, shouldClose = true, description = 'Bomb module. Wires with stripes, stars and LEDs, and a Venn diagram to settle each one. Fit it to a casing kit.' },
['sd_mod_wire_sequences']       = { name = 'sd_mod_wire_sequences',        label = 'Module: Wire Sequences',            weight = 450,   type = 'item', image = 'sd_mod_wire_sequences.png',        unique = false, useable = false, shouldClose = true, description = 'Bomb module. Panel after panel of wires, counted by colour as you go. Fit it to a casing kit.' },
['sd_mod_mazes']                = { name = 'sd_mod_mazes',                 label = 'Module: Mazes',                     weight = 450,   type = 'item', image = 'sd_mod_mazes.png',                 unique = false, useable = false, shouldClose = true, description = 'Bomb module. A maze whose walls only the Expert can see. Fit it to a casing kit.' },
['sd_mod_passwords']            = { name = 'sd_mod_passwords',             label = 'Module: Passwords',                 weight = 450,   type = 'item', image = 'sd_mod_passwords.png',             unique = false, useable = false, shouldClose = true, description = 'Bomb module. Five letter wheels that spell exactly one word. Fit it to a casing kit.' },
['sd_mod_venting_gas']          = { name = 'sd_mod_venting_gas',           label = 'Needy Module: Venting Gas',         weight = 500,   type = 'item', image = 'sd_mod_venting_gas.png',           unique = false, useable = false, shouldClose = true, description = 'Needy bomb module. It cannot be disarmed: it wakes up and asks questions until the bomb is done. Fit it to a casing kit.' },
['sd_mod_capacitor']            = { name = 'sd_mod_capacitor',             label = 'Needy Module: Capacitor Discharge', weight = 500,   type = 'item', image = 'sd_mod_capacitor.png',             unique = false, useable = false, shouldClose = true, description = 'Needy bomb module. It cannot be disarmed: keep pulling the lever or it blows. Fit it to a casing kit.' },
['sd_mod_knobs']                = { name = 'sd_mod_knobs',                 label = 'Needy Module: Knobs',               weight = 500,   type = 'item', image = 'sd_mod_knobs.png',                 unique = false, useable = false, shouldClose = true, description = 'Needy bomb module. It cannot be disarmed: turn the dial the way the lamps say, again and again. Fit it to a casing kit.' },
-- Bench tools
['sd_tool_driver']              = { name = 'sd_tool_driver',               label = 'Cordless Driver',                   weight = 1600,  type = 'item', image = 'sd_tool_driver.png',               unique = false, useable = false, shouldClose = true, description = 'An 18 V drill-driver. Stand it on a bomb workbench\'s shelf and it drives (and backs out) the screws that hold modules down, fast. It stays on that bench until somebody takes it.' },
['sd_tool_screwdriver']         = { name = 'sd_tool_screwdriver',          label = 'Screwdriver',                       weight = 120,   type = 'item', image = 'sd_tool_screwdriver.png',          unique = false, useable = false, shouldClose = true, description = 'A plain cross-head screwdriver. Hang it on a bomb workbench: it does what the cordless driver does, by hand - slowly.' },
['sd_tool_hexkey']              = { name = 'sd_tool_hexkey',               label = 'T-Handle Hex Key',                  weight = 110,   type = 'item', image = 'sd_tool_hexkey.png',               unique = false, useable = false, shouldClose = true, description = 'The front of a bomb casing is held by four hex bolts. Hang this on a workbench\'s pegboard to drive them - a screwdriver will not.' },
['sd_tool_knife']               = { name = 'sd_tool_knife',                label = 'Utility Knife',                     weight = 140,   type = 'item', image = 'sd_tool_knife.png',                unique = false, useable = false, shouldClose = true, description = 'A casing kit comes taped shut. Hang this on a workbench\'s pegboard and slit the kit open with it.' },
['sd_tool_pliers']              = { name = 'sd_tool_pliers',               label = 'Combination Pliers',                weight = 260,   type = 'item', image = 'sd_tool_pliers.png',               unique = false, useable = false, shouldClose = true, description = 'Every block of explosive packed into a casing gets a detonator cap crimped into it. Hang these on a workbench\'s pegboard to do it.' },
['sd_tool_cutters']             = { name = 'sd_tool_cutters',              label = 'Side Cutters',                      weight = 220,   type = 'item', image = 'sd_tool_cutters.png',              unique = false, useable = false, shouldClose = true, description = 'Harlow Instrument Co. side cutters. Cut wire from a stocked spool to length before stripping its ends.' },
['sd_tool_strippers']           = { name = 'sd_tool_strippers',            label = 'Wire Strippers',                    weight = 180,   type = 'item', image = 'sd_tool_strippers.png',            unique = false, useable = false, shouldClose = true, description = 'A module is only part of the bomb once it is wired in. Hang these on a workbench\'s pegboard to wire in every module you fit.' },
['sd_tool_tensioner']           = { name = 'sd_tool_tensioner',            label = 'Band Tensioner',                    weight = 900,   type = 'item', image = 'sd_tool_tensioner.png',            unique = false, useable = false, shouldClose = true, description = 'Harlow Instrument Co. Model 7 strapping ratchet. Hang it on a workbench pegboard: every block of charge is strapped down in its bracket with a steel band, pumped tight and sealed.' },
['sd_tool_multimeter']          = { name = 'sd_tool_multimeter',           label = 'Multimeter',                        weight = 420,   type = 'item', image = 'sd_tool_multimeter.png',           unique = false, useable = false, shouldClose = true, description = 'The last job before a bomb is assembled: prove the circuit. Hang it on a workbench\'s pegboard; test again after any change.' },
['sd_tool_camkey']              = { name = 'sd_tool_camkey',               label = 'Cam Key',                           weight = 140,   type = 'item', image = 'sd_tool_camkey.png',               unique = false, useable = false, shouldClose = true, description = 'Harlow Instrument Co. indexing key. Hang it on a bomb workbench: it turns the cartridge collar of a compact casing into register.' },
['sd_tool_trimgauge']           = { name = 'sd_tool_trimgauge',            label = 'Trim Gauge',                        weight = 360,   type = 'item', image = 'sd_tool_trimgauge.png',            unique = false, useable = false, shouldClose = true, description = 'Harlow Instrument Co. trim gauge. Hang it on a bomb workbench: it centres the floating cradle of a compact casing and trims its carrier stops.' },
['sd_tool_signalprobe']         = { name = 'sd_tool_signalprobe',          label = 'Signal Probe',                      weight = 170,   type = 'item', image = 'sd_tool_signalprobe.png',          unique = false, useable = false, shouldClose = true, description = 'Harlow Instrument Co. signal probe. Hang it on a bomb workbench: it traces the contacts of a compact casing and captures its diagnostic pulses.' },
-- Wall kits
['wallkit_drywall']             = { name = 'wallkit_drywall',              label = 'Stud Wall Kit',                     weight = 6000,  type = 'item', image = 'wallkit_drywall.png',              unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Plasterboard on timber studs. Anything that goes bang gets through it. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_wood_planks']         = { name = 'wallkit_wood_planks',          label = 'Plank Wall Kit',                    weight = 7000,  type = 'item', image = 'wallkit_wood_planks.png',          unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Weathered planking on a frame. Anything that goes bang gets through it. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_corrugated_metal']    = { name = 'wallkit_corrugated_metal',     label = 'Corrugated Iron Wall Kit',          weight = 7000,  type = 'item', image = 'wallkit_corrugated_metal.png',     unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Corrugated sheeting on a steel frame. Anything that goes bang gets through it. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_stucco_old']          = { name = 'wallkit_stucco_old',           label = 'Rendered Wall Kit',                 weight = 9000,  type = 'item', image = 'wallkit_stucco_old.png',           unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. An old rendered wall, stains included. Anything that goes bang gets through it. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_wood_painted']        = { name = 'wallkit_wood_painted',         label = 'Painted Plank Wall Kit',            weight = 9000,  type = 'item', image = 'wallkit_wood_painted.png',         unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Painted timber planks on a frame. Anything that goes bang gets through. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_roller_shutter']      = { name = 'wallkit_roller_shutter',       label = 'Roller Shutter Wall Kit',           weight = 8000,  type = 'item', image = 'wallkit_roller_shutter.png',       unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. A steel roller shutter on a frame. Anything that goes bang gets through. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_brick_red']           = { name = 'wallkit_brick_red',            label = 'Red Brick Wall Kit',                weight = 12000, type = 'item', image = 'wallkit_brick_red.png',            unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Proper red brick. Takes a grenade or better to breach. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_brick_painted']       = { name = 'wallkit_brick_painted',        label = 'Painted Brick Wall Kit',            weight = 12000, type = 'item', image = 'wallkit_brick_painted.png',        unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Brick under a coat of blue paint. Takes a grenade or better to breach. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_cinder_block']        = { name = 'wallkit_cinder_block',         label = 'Cinder Block Wall Kit',             weight = 12000, type = 'item', image = 'wallkit_cinder_block.png',         unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Dark cinder block. Takes a grenade or better to breach. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_ledgestone']          = { name = 'wallkit_ledgestone',           label = 'Stacked Stone Wall Kit',            weight = 14000, type = 'item', image = 'wallkit_ledgestone.png',           unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Dry-stacked stone. Takes a grenade or better to breach. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_tile_white']          = { name = 'wallkit_tile_white',           label = 'White Tile Wall Kit',               weight = 14000, type = 'item', image = 'wallkit_tile_white.png',           unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. White ceramic tiles over blockwork. A grenade or better gets through. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_rusted_sheet']        = { name = 'wallkit_rusted_sheet',         label = 'Rusted Sheet-Steel Wall Kit',       weight = 12000, type = 'item', image = 'wallkit_rusted_sheet.png',         unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Rust-streaked painted sheet steel. A grenade or better gets through. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_stone_block']         = { name = 'wallkit_stone_block',          label = 'Stone Block Wall Kit',              weight = 16000, type = 'item', image = 'wallkit_stone_block.png',          unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Rough-cut stone blocks. Takes a sticky bomb or a rocket to breach. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_concrete']            = { name = 'wallkit_concrete',             label = 'Concrete Wall Kit',                 weight = 16000, type = 'item', image = 'wallkit_concrete.png',             unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Board-formed poured concrete. Takes a sticky bomb or a rocket to breach. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_concrete_painted']    = { name = 'wallkit_concrete_painted',     label = 'Painted Concrete Wall Kit',         weight = 18000, type = 'item', image = 'wallkit_concrete_painted.png',     unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Poured concrete under flaking green paint. Takes a sticky bomb, a rocket or better. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_sandstone']           = { name = 'wallkit_sandstone',            label = 'Sandstone Wall Kit',                weight = 19000, type = 'item', image = 'wallkit_sandstone.png',            unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Rock-faced sandstone blocks. Takes a sticky bomb, a rocket or better. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_basalt_stone']        = { name = 'wallkit_basalt_stone',         label = 'Basalt Wall Kit',                   weight = 19000, type = 'item', image = 'wallkit_basalt_stone.png',         unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Tightly fitted basalt stones. Takes a sticky bomb, a rocket or better. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_castle_stone']        = { name = 'wallkit_castle_stone',         label = 'Castle Stone Wall Kit',             weight = 22000, type = 'item', image = 'wallkit_castle_stone.png',         unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Massive dressed ashlar blocks. Only a tank shell or a briefcase bomb gets through. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_concrete_reinforced'] = { name = 'wallkit_concrete_reinforced',  label = 'Reinforced Concrete Wall Kit',      weight = 20000, type = 'item', image = 'wallkit_concrete_reinforced.png',  unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Concrete with a steel mesh inside. Only a tank shell or a briefcase bomb gets through. Use it to set it up; aim next to a standing wall to join onto it.' },
['wallkit_steel_plate']         = { name = 'wallkit_steel_plate',          label = 'Steel Plate Wall Kit',              weight = 20000, type = 'item', image = 'wallkit_steel_plate.png',          unique = false, useable = true , shouldClose = true, description = 'A flat-packed 2 m x 3 m breakable wall module. Riveted steel plate. Only a tank shell or a briefcase bomb gets through. Use it to set it up; aim next to a standing wall to join onto it.' },
```

```sql [ESX]
INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('sd_bomb', 'Briefcase Bomb', 6500),
  ('sd_bomb_manual', 'Bomb Defusal Field Manual', 450),
  ('sd_bomb_kit', 'Bomb Casing Kit', 3000),
  ('sd_bomb_kit_small', 'Wren Casing Kit (Small)', 1100),
  ('sd_bomb_kit_medium', 'Kestrel Casing Kit (Medium)', 2200),
  ('sd_bomb_kit_large', 'Osprey Casing Kit (Large)', 3400),
  ('sd_explosive', 'Plastic Explosive', 570),
  ('sd_workbench', 'Bomb Workbench', 25000),
  ('sd_assembly_book', 'Field Assembly Handbook', 650),
  ('sd_screw_box', 'Instrument Screws (box)', 350),
  ('sd_wire_box', 'Wire Spool Kit', 600),
  ('sd_charge_bracket', 'Charge Bracket', 150),
  ('sd_retaining_strap', 'Retaining Strap', 45),
  ('sd_mod_wires', 'Module: Wires', 350),
  ('sd_mod_button', 'Module: The Button', 400),
  ('sd_mod_keypads', 'Module: Keypads', 400),
  ('sd_mod_simon', 'Module: Simon Says', 400),
  ('sd_mod_whos_on_first', 'Module: Who''s on First', 450),
  ('sd_mod_memory', 'Module: Memory', 450),
  ('sd_mod_morse', 'Module: Morse Code', 450),
  ('sd_mod_complicated_wires', 'Module: Complicated Wires', 450),
  ('sd_mod_wire_sequences', 'Module: Wire Sequences', 450),
  ('sd_mod_mazes', 'Module: Mazes', 450),
  ('sd_mod_passwords', 'Module: Passwords', 450),
  ('sd_mod_venting_gas', 'Needy Module: Venting Gas', 500),
  ('sd_mod_capacitor', 'Needy Module: Capacitor Discharge', 500),
  ('sd_mod_knobs', 'Needy Module: Knobs', 500),
  ('sd_tool_driver', 'Cordless Driver', 1600),
  ('sd_tool_screwdriver', 'Screwdriver', 120),
  ('sd_tool_hexkey', 'T-Handle Hex Key', 110),
  ('sd_tool_knife', 'Utility Knife', 140),
  ('sd_tool_pliers', 'Combination Pliers', 260),
  ('sd_tool_cutters', 'Side Cutters', 220),
  ('sd_tool_strippers', 'Wire Strippers', 180),
  ('sd_tool_tensioner', 'Band Tensioner', 900),
  ('sd_tool_multimeter', 'Multimeter', 420),
  ('sd_tool_camkey', 'Cam Key', 140),
  ('sd_tool_trimgauge', 'Trim Gauge', 360),
  ('sd_tool_signalprobe', 'Signal Probe', 170),
  ('wallkit_drywall', 'Stud Wall Kit', 6000),
  ('wallkit_wood_planks', 'Plank Wall Kit', 7000),
  ('wallkit_corrugated_metal', 'Corrugated Iron Wall Kit', 7000),
  ('wallkit_stucco_old', 'Rendered Wall Kit', 9000),
  ('wallkit_wood_painted', 'Painted Plank Wall Kit', 9000),
  ('wallkit_roller_shutter', 'Roller Shutter Wall Kit', 8000),
  ('wallkit_brick_red', 'Red Brick Wall Kit', 12000),
  ('wallkit_brick_painted', 'Painted Brick Wall Kit', 12000),
  ('wallkit_cinder_block', 'Cinder Block Wall Kit', 12000),
  ('wallkit_ledgestone', 'Stacked Stone Wall Kit', 14000),
  ('wallkit_tile_white', 'White Tile Wall Kit', 14000),
  ('wallkit_rusted_sheet', 'Rusted Sheet-Steel Wall Kit', 12000),
  ('wallkit_stone_block', 'Stone Block Wall Kit', 16000),
  ('wallkit_concrete', 'Concrete Wall Kit', 16000),
  ('wallkit_concrete_painted', 'Painted Concrete Wall Kit', 18000),
  ('wallkit_sandstone', 'Sandstone Wall Kit', 19000),
  ('wallkit_basalt_stone', 'Basalt Wall Kit', 19000),
  ('wallkit_castle_stone', 'Castle Stone Wall Kit', 22000),
  ('wallkit_concrete_reinforced', 'Reinforced Concrete Wall Kit', 20000),
  ('wallkit_steel_plate', 'Steel Plate Wall Kit', 20000);
```

:::

::: warning Wall kits on ox_inventory
Every wall kit points at the **same** export, `sd-bombs.useWallKit`, with `consume = 0`: the kit is only taken once the wall is actually built. On every other inventory the kits are registered usable automatically - nothing to add.
:::

::: tip
Only running part of the resource? Leave out what you do not use. The bomb builder's items (kits, explosive, modules, tools, supplies, workbench) are only needed for building bombs, and the wall kits only for letting players put up walls themselves - staff can place walls and bombs from the admin panel without any items.
:::

## <span class="step-num">3</span> Add Item Images

Copy the item images from `sd-bombs/images/` into your inventory's image folder (e.g. `ox_inventory/web/images/`). You can also download them directly from the container below.

<ItemImageGrid
  title="Bombs & Breakable Walls Item Images"
  zipName="sd-bombs-images"
  :images="[
    { src: '/items/bombs/sd_bomb.png', name: 'sd_bomb.png', alt: 'Briefcase Bomb' },
    { src: '/items/bombs/sd_bomb_small.png', name: 'sd_bomb_small.png', alt: 'Briefcase Bomb (Small)' },
    { src: '/items/bombs/sd_bomb_medium.png', name: 'sd_bomb_medium.png', alt: 'Briefcase Bomb (Medium)' },
    { src: '/items/bombs/sd_bomb_large.png', name: 'sd_bomb_large.png', alt: 'Briefcase Bomb (Large)' },
    { src: '/items/bombs/sd_bomb_manual.png', name: 'sd_bomb_manual.png', alt: 'Bomb Defusal Field Manual' },
    { src: '/items/bombs/sd_bomb_kit.png', name: 'sd_bomb_kit.png', alt: 'Bomb Casing Kit' },
    { src: '/items/bombs/sd_bomb_kit_small.png', name: 'sd_bomb_kit_small.png', alt: 'Wren Casing Kit (Small)' },
    { src: '/items/bombs/sd_bomb_kit_medium.png', name: 'sd_bomb_kit_medium.png', alt: 'Kestrel Casing Kit (Medium)' },
    { src: '/items/bombs/sd_bomb_kit_large.png', name: 'sd_bomb_kit_large.png', alt: 'Osprey Casing Kit (Large)' },
    { src: '/items/bombs/sd_explosive.png', name: 'sd_explosive.png', alt: 'Plastic Explosive' },
    { src: '/items/bombs/sd_workbench.png', name: 'sd_workbench.png', alt: 'Bomb Workbench' },
    { src: '/items/bombs/sd_assembly_book.png', name: 'sd_assembly_book.png', alt: 'Field Assembly Handbook' },
    { src: '/items/bombs/sd_screw_box.png', name: 'sd_screw_box.png', alt: 'Instrument Screws (box)' },
    { src: '/items/bombs/sd_wire_box.png', name: 'sd_wire_box.png', alt: 'Wire Spool Kit' },
    { src: '/items/bombs/sd_charge_bracket.png', name: 'sd_charge_bracket.png', alt: 'Charge Bracket' },
    { src: '/items/bombs/sd_retaining_strap.png', name: 'sd_retaining_strap.png', alt: 'Retaining Strap' },
    { src: '/items/bombs/sd_mod_wires.png', name: 'sd_mod_wires.png', alt: 'Module: Wires' },
    { src: '/items/bombs/sd_mod_button.png', name: 'sd_mod_button.png', alt: 'Module: The Button' },
    { src: '/items/bombs/sd_mod_keypads.png', name: 'sd_mod_keypads.png', alt: 'Module: Keypads' },
    { src: '/items/bombs/sd_mod_simon.png', name: 'sd_mod_simon.png', alt: 'Module: Simon Says' },
    { src: '/items/bombs/sd_mod_whos_on_first.png', name: 'sd_mod_whos_on_first.png', alt: 'Module: Whos on First' },
    { src: '/items/bombs/sd_mod_memory.png', name: 'sd_mod_memory.png', alt: 'Module: Memory' },
    { src: '/items/bombs/sd_mod_morse.png', name: 'sd_mod_morse.png', alt: 'Module: Morse Code' },
    { src: '/items/bombs/sd_mod_complicated_wires.png', name: 'sd_mod_complicated_wires.png', alt: 'Module: Complicated Wires' },
    { src: '/items/bombs/sd_mod_wire_sequences.png', name: 'sd_mod_wire_sequences.png', alt: 'Module: Wire Sequences' },
    { src: '/items/bombs/sd_mod_mazes.png', name: 'sd_mod_mazes.png', alt: 'Module: Mazes' },
    { src: '/items/bombs/sd_mod_passwords.png', name: 'sd_mod_passwords.png', alt: 'Module: Passwords' },
    { src: '/items/bombs/sd_mod_venting_gas.png', name: 'sd_mod_venting_gas.png', alt: 'Needy Module: Venting Gas' },
    { src: '/items/bombs/sd_mod_capacitor.png', name: 'sd_mod_capacitor.png', alt: 'Needy Module: Capacitor Discharge' },
    { src: '/items/bombs/sd_mod_knobs.png', name: 'sd_mod_knobs.png', alt: 'Needy Module: Knobs' },
    { src: '/items/bombs/sd_tool_driver.png', name: 'sd_tool_driver.png', alt: 'Cordless Driver' },
    { src: '/items/bombs/sd_tool_screwdriver.png', name: 'sd_tool_screwdriver.png', alt: 'Screwdriver' },
    { src: '/items/bombs/sd_tool_hexkey.png', name: 'sd_tool_hexkey.png', alt: 'T-Handle Hex Key' },
    { src: '/items/bombs/sd_tool_knife.png', name: 'sd_tool_knife.png', alt: 'Utility Knife' },
    { src: '/items/bombs/sd_tool_pliers.png', name: 'sd_tool_pliers.png', alt: 'Combination Pliers' },
    { src: '/items/bombs/sd_tool_cutters.png', name: 'sd_tool_cutters.png', alt: 'Side Cutters' },
    { src: '/items/bombs/sd_tool_strippers.png', name: 'sd_tool_strippers.png', alt: 'Wire Strippers' },
    { src: '/items/bombs/sd_tool_tensioner.png', name: 'sd_tool_tensioner.png', alt: 'Band Tensioner' },
    { src: '/items/bombs/sd_tool_multimeter.png', name: 'sd_tool_multimeter.png', alt: 'Multimeter' },
    { src: '/items/bombs/sd_tool_camkey.png', name: 'sd_tool_camkey.png', alt: 'Cam Key' },
    { src: '/items/bombs/sd_tool_trimgauge.png', name: 'sd_tool_trimgauge.png', alt: 'Trim Gauge' },
    { src: '/items/bombs/sd_tool_signalprobe.png', name: 'sd_tool_signalprobe.png', alt: 'Signal Probe' },
    { src: '/items/bombs/wallkit_drywall.png', name: 'wallkit_drywall.png', alt: 'Stud Wall Kit' },
    { src: '/items/bombs/wallkit_wood_planks.png', name: 'wallkit_wood_planks.png', alt: 'Plank Wall Kit' },
    { src: '/items/bombs/wallkit_corrugated_metal.png', name: 'wallkit_corrugated_metal.png', alt: 'Corrugated Iron Wall Kit' },
    { src: '/items/bombs/wallkit_stucco_old.png', name: 'wallkit_stucco_old.png', alt: 'Rendered Wall Kit' },
    { src: '/items/bombs/wallkit_wood_painted.png', name: 'wallkit_wood_painted.png', alt: 'Painted Plank Wall Kit' },
    { src: '/items/bombs/wallkit_roller_shutter.png', name: 'wallkit_roller_shutter.png', alt: 'Roller Shutter Wall Kit' },
    { src: '/items/bombs/wallkit_brick_red.png', name: 'wallkit_brick_red.png', alt: 'Red Brick Wall Kit' },
    { src: '/items/bombs/wallkit_brick_painted.png', name: 'wallkit_brick_painted.png', alt: 'Painted Brick Wall Kit' },
    { src: '/items/bombs/wallkit_cinder_block.png', name: 'wallkit_cinder_block.png', alt: 'Cinder Block Wall Kit' },
    { src: '/items/bombs/wallkit_ledgestone.png', name: 'wallkit_ledgestone.png', alt: 'Stacked Stone Wall Kit' },
    { src: '/items/bombs/wallkit_tile_white.png', name: 'wallkit_tile_white.png', alt: 'White Tile Wall Kit' },
    { src: '/items/bombs/wallkit_rusted_sheet.png', name: 'wallkit_rusted_sheet.png', alt: 'Rusted Sheet-Steel Wall Kit' },
    { src: '/items/bombs/wallkit_stone_block.png', name: 'wallkit_stone_block.png', alt: 'Stone Block Wall Kit' },
    { src: '/items/bombs/wallkit_concrete.png', name: 'wallkit_concrete.png', alt: 'Concrete Wall Kit' },
    { src: '/items/bombs/wallkit_concrete_painted.png', name: 'wallkit_concrete_painted.png', alt: 'Painted Concrete Wall Kit' },
    { src: '/items/bombs/wallkit_sandstone.png', name: 'wallkit_sandstone.png', alt: 'Sandstone Wall Kit' },
    { src: '/items/bombs/wallkit_basalt_stone.png', name: 'wallkit_basalt_stone.png', alt: 'Basalt Wall Kit' },
    { src: '/items/bombs/wallkit_castle_stone.png', name: 'wallkit_castle_stone.png', alt: 'Castle Stone Wall Kit' },
    { src: '/items/bombs/wallkit_concrete_reinforced.png', name: 'wallkit_concrete_reinforced.png', alt: 'Reinforced Concrete Wall Kit' },
    { src: '/items/bombs/wallkit_steel_plate.png', name: 'wallkit_steel_plate.png', alt: 'Steel Plate Wall Kit' },
  ]"
/>

::: info Bomb images per size
A bomb carries the image of its size in its metadata (`sd_bomb_small`, `sd_bomb_medium`, `sd_bomb_large`; the Extra Large uses `sd_bomb`). Copy those three images too - they are in the same folder. See `BombImages` in [Configuration](./configuration#items).
:::

## <span class="step-num">4</span> Grant Admin Access

The admin panel and the staff commands use ACE permissions. By default, everyone in `group.admin` gets full access - `command.bombadmin` to open the panel and `sd_bombs.edit` to change things. If your admins are already in `group.admin`, there is nothing to do.

To give another group **full** access, add this to your `server.cfg`:

```cfg
add_ace group.mod command.bombadmin allow
add_ace group.mod sd_bombs.edit allow
```

To give staff a **view-only** panel instead (they can look and teleport, but every change is refused), set `ViewGroup` in `configs/shared/admin.lua`:

```lua
ViewGroup = 'group.mod',
```

## <span class="step-num">5</span> Start the Resource

To load the resource, you can either:

- **Restart your server** entirely, or
- Run the following in your **server console** (F8 or txAdmin live console):

```cfg
refresh
ensure sd-bombs
```

::: tip Updating
Keep the `data/` folder when you update the resource - it holds every placed wall, workbench, planted bomb, and what lies on the benches.
:::

## <span class="step-num">6</span> Set Up

Everything is placed in-game:

1. Run `/bombadmin` to open the admin panel
2. Open the **Walls** tab and place breakable walls where your heists, raids, and hideouts need them
3. Open the **Benches** tab and place workbenches where players build bombs - or sell players the `sd_workbench` item so they set up their own
4. Open the **Bombs** tab to plant a test bomb and try defusing it

See [Building Bombs](./building) for how the workbench works, and the [Walls Reference](./walls) for every wall style.

## Configuration

Configure the resource to fit your server. See the [Configuration](./configuration) page for detailed explanations of every setting, or edit the files directly in the resource's `configs/` folder.
