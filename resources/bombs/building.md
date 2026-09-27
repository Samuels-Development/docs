# Building Bombs

Bombs are built **by hand on a workbench in the world**. The camera comes down over the bench, parts come out of the kit bag and are put down on it as real props, and every job needs its tool. A bomb built this way is handed over as an `sd_bomb` item that carries its build - planted, **that** bomb is the one that gets defused.

## Workbenches

A workbench can come from four places:

| Source | How |
|---|---|
| **Admin panel** | The **Benches** tab: place a bench with the placement tool, kitted out with the tools you pick |
| **Command** | `/bomb_bench` stands one in front of you; `/bomb_bench remove` takes the nearest away |
| **Config** | Fixed benches for your map in `Items.Builder.Bench.Locations` |
| **Item** | Players use the `sd_workbench` item to set up their own - see [The Workbench Item](#the-workbench-item) |

What is put down on a bench **stays on it** - for everyone, across restarts. A half-built bomb waits for whoever comes back to it; tools hung on the pegboard stay there for the next builder. The bench's lamp and shelf radio stay as they were left too.

With `Required = true` (the default), a casing kit can only be opened **at** a bench.

## At the Bench

Walk up to a bench with a casing kit and use it (`ox_target`, or `[E]`). The camera comes down over the bench top.

| Key | What it does |
|---|---|
| `Q` | Open and close the **kit bag** - drag parts, tools, and supplies out of it onto the bench |
| `T` | The **tools** on the pegboard - click one to take it down |
| `G` | Look **under the bench** - the storage shelf |
| `H` | Up to the shelf **radio** |
| `B` | The **handbook** on its lectern (`A` / `D` turn the pages) |
| `V` | **Inspect** the case up close |
| `R` / `F` / `U` | Turn the case round / flip it / stand it up |
| `L` | The **lamp** on and off - the mouse wheel over its shade dims it |
| `X` | Guides on and off |
| `Enter` | The work order's main button |
| `Esc` | Back out |
| Right-click | Hang the tool in your hand back up |

The **work order** on its clipboard tracks the build - which step it is on, the firing plan, and the sign-off.

## Bomb Sizes

| Size | Kit item | Front bays | Explosive | Edge fittings |
|---|---|---|---|---|
| Small - **Wren** | `sd_bomb_kit_small` | 2 (one is the timer) | 1 block | 3 |
| Medium - **Kestrel** | `sd_bomb_kit_medium` | 4 | 2 blocks | 4 |
| Large - **Osprey** | `sd_bomb_kit_large` | 6 | 4 blocks | 5 |
| Extra Large - **HIC-4410** | `sd_bomb_kit` | 12, front and back (one is the timer) | up to 6 blocks | 5 |

The blocks of explosive packed into a bomb are its **yield** - how hard it hits and which hole it blows in a wall. See [Bombs and Walls](./walls#bombs-and-walls).

## The Build

Every kit arrives **taped shut in its carton**. A full Extra Large build:

1. **Open the carton** - slit its three tape seams with the **utility knife**, fold the flaps back
2. **Unpack** - take the charge brackets and edge fittings out of the packing insert, lift the insert out, then lift the case out
3. **Open the case** - undo the front's four corner bolts with the **hex key** and set the front in its stand
4. **Pack the charges** - drop a **charge bracket** into each cell and screw it down, lay a block of **plastic explosive** in it, then put a **retaining strap** over it and pump it tight with the **band tensioner**
5. **Wire the charges** - crimp a detonator cap into each block with the **pliers**, then run its lead to the terminal of its colour on the firing unit and clamp it. Leads are cut to length with the **side cutters** and stripped with the **wire strippers** from the **wire spool kit** on the rack
6. **Close the case** - put the front back and do its bolts up
7. **Fit the modules** - screw each module into a bay with the **cordless driver** or **screwdriver** (screws come from the **box of screws**, tipped out onto the bench), then wire it in with the **wire strippers** and run its lead along the gutters to the timer's hub
8. **Test the circuit** with the **multimeter**
9. **Fit the edgework** - clip the serial plate, batteries, indicators, and port plates into the case's edges. The edgework is what the Defuser's rules read
10. **Sign the work order off** - the bomb is assembled and handed over as an `sd_bomb` item

The compact cases (Wren, Kestrel, Osprey) skip the heavy wiring but add **inspection steps** - indexing the cartridge collar with the **cam key**, centring the cradle with the **trim gauge**, and tracing contacts with the **signal probe** - each a short timing check.

Every step can be switched off in `Items.Builder.Steps` - see [Configuration](./configuration#bomb-builder).

## Tools

Tools hang on the bench's pegboard. A bench has no tools of its own: drag one out of the kit bag and hang it up - it stays on that bench.

| Tool | Item | Used for |
|---|---|---|
| Utility knife | `sd_tool_knife` | Slitting the carton's tape |
| T-handle hex key | `sd_tool_hexkey` | The case front's four corner bolts |
| Cordless driver | `sd_tool_driver` | Driving screws - stands on its own shelf |
| Screwdriver | `sd_tool_screwdriver` | Driving screws by hand, and terminal clamps |
| Combination pliers | `sd_tool_pliers` | Crimping detonator caps into blocks |
| Side cutters | `sd_tool_cutters` | Cutting wire to length |
| Wire strippers | `sd_tool_strippers` | Stripping leads and wiring modules in |
| Band tensioner | `sd_tool_tensioner` | Pumping retaining straps tight |
| Multimeter | `sd_tool_multimeter` | Proving the circuit |
| Cam key | `sd_tool_camkey` | Compact cases: indexing the cartridge collar |
| Trim gauge | `sd_tool_trimgauge` | Compact cases: centring the cradle, trimming the carrier stops |
| Signal probe | `sd_tool_signalprobe` | Compact cases: tracing contacts, capturing diagnostic pulses |

## Supplies

What a build **uses up**. Each goes onto the bench from the kit bag and is the bench's from then on - whoever works there next finds what is left.

| Supply | Item | |
|---|---|---|
| Plastic explosive | `sd_explosive` | One block per charge |
| Charge bracket | `sd_charge_bracket` | One per packed cell - six come in every Extra Large kit |
| Retaining strap | `sd_retaining_strap` | One per packed block |
| Instrument screws | `sd_screw_box` | 48 to the box - tip it out onto the bench |
| Wire spool kit | `sd_wire_box` | Six reels, one per channel colour, four lengths each |
| Field assembly handbook | `sd_assembly_book` | The builder's reference, on its lectern |

## The Workbench Item

The `sd_workbench` item lets players set up their **own** bench. Using it opens the placement tool; the item is taken once the bench stands, and the bench stays across restarts.

- Whoever set it up can **pack it up** again - `ox_target`, or `G` at the prompt - and gets the item back, as long as nothing lies on it and nobody is working at it
- Staff can move it, change its owner, or remove it from the **Benches** tab

```lua
-- configs/shared/items.lua > Builder.Bench
Item = { Name = 'sd_workbench', Limit = 2, Reach = 8.0, PackUp = true },
```

| Option | Default | Description |
|---|---|---|
| `Name` | `'sd_workbench'` | The item. `Item = false` turns the item off |
| `Limit` | `2` | Benches one character may have standing at once (`0` = no limit) |
| `Reach` | `8.0` | Metres from the player the bench may be set up |
| `PackUp` | `true` | `false` = a bench stays where it was set up - only staff take it away |

## Staff Commands

| Command | What it does |
|---|---|
| `/bomb_toolkit [tools\|parts\|all] [player]` | Hand out what a build takes: one of every tool (default), the parts for a build, or both |
| `/bomb_bench [remove] [force]` | Stand a bench in front of you, or remove the nearest one (`force`: even if parts lie on it) |
| `/bomb_plant [modules] [seconds] [strikes] [needy] [seed]` | Plant a random bomb in front of you |
| `/bomb_detonate [id]` | Set an armed bomb off now - that one, or the nearest |
| `/bomb_clear` | Remove every planted bomb |
| `/bomb_give_set [player]` | One bomb of every size, each packed as full as it holds |

All staff commands are restricted to `group.admin` by default.
