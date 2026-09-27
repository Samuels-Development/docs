# Walls Reference

Breakable walls are placed in-game - from the **Walls** tab of `/bombadmin`, with `/wall_place`, with a **wall-kit item**, or from another script with the [`placeWall`](./exports-server#placewall) export - and **any explosion** can blow a hole through them.

## How a Wall Works

- A wall is a **run**: one straight stretch of one style, **3 m tall** and as long as the gap it closes - any length in steps of **0.25 m**, up to **40 m**
- The run is laid seamlessly from modular pieces (2 m, 1 m, 0.5 m, and 0.25 m wide), so to players it is one wall, not a row of blocks
- When a run is breached it is re-laid around the hole, **wherever along it the blast was** - a charge at one end opens that end
- A run can be breached again further along, and a blast **into** an existing hole makes it **bigger**
- Walls placed through the panel, the commands, or the wall kits are **saved** (`data/walls.json`) and come back after a restart
- A breached wall **rebuilds itself** after 15 minutes by default (`RepairAfter`), and the clock survives a restart

## Toughness

Every style has a **toughness** from 1 to 4. An explosion has a **power**: a blast breaches every intact wall within its reach whose toughness its power meets. Reach is measured to the nearest point of the wall - `2 m + 0.9 m per point of power` (a sticky bomb: 4.7 m).

| Explosion | Power | Explosion | Power |
|---|---|---|---|
| Pipe bomb | 2 | Car | 2 |
| Grenade / grenade launcher | 2 | Truck / tanker / train | 3 |
| Sticky bomb | 3 | Petrol pump / gas tank / barrel / propane | 2 |
| Proximity mine | 3 | Plane / ship / blimp | 3 |
| Rocket | 3 | Bike / hi-octane / explosive rounds / firework | 1 |
| Tank shell / plane rocket / Valkyrie cannon | 4 | Molotov, fire, smoke, flares | 0 (never) |

A planted **bomb** hits with the power of its [yield](#bombs-and-walls). Every value is in `configs/shared/breaking.lua` - see [Configuration](./configuration#breaking).

## Wall Styles

Each style below is shown as a 2 m piece, intact and breached with a doorway. Under each one:

- **Style** - the style's key. This is what you pass to the exports (`placeWall`, `placeWallBetween`, `setWallStyle`, ...) and to `/wall_place`
- **Item** - its **wall kit**: the inventory item that lets a player put up one 2 m module of this style (see [Add Items](./installation#_2-add-items)). You only need it if players place walls themselves

### Toughness 1 - light

Anything that goes bang gets through: a pipe bomb, a car going up, a hi-octane blast, explosive rounds.

<div class="render-grid wide">
  <figure>
    <div class="render-pair"><img src="/bombs/walls/corrugated_metal.jpg" alt="Corrugated iron sheeting" loading="lazy" /><img src="/bombs/walls/corrugated_metal-breached.jpg" alt="Corrugated iron sheeting, breached" loading="lazy" /></div>
    <figcaption><b>Corrugated iron sheeting</b>Style <code>corrugated_metal</code><br />Item <code>wallkit_corrugated_metal</code><br />Breaks into metal fragments and sparks.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/stucco_old.jpg" alt="Old rendered wall" loading="lazy" /><img src="/bombs/walls/stucco_old-breached.jpg" alt="Old rendered wall, breached" loading="lazy" /></div>
    <figcaption><b>Old rendered wall</b>Style <code>stucco_old</code><br />Item <code>wallkit_stucco_old</code><br />Breaks into plaster dust. Paintable: <b style="display:inline">19</b> colours.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/wood_painted.jpg" alt="Painted plank wall" loading="lazy" /><img src="/bombs/walls/wood_painted-breached.jpg" alt="Painted plank wall, breached" loading="lazy" /></div>
    <figcaption><b>Painted plank wall</b>Style <code>wood_painted</code><br />Item <code>wallkit_wood_painted</code><br />Breaks into splinters. Paintable: <b style="display:inline">21</b> colours.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/roller_shutter.jpg" alt="Steel roller shutter" loading="lazy" /><img src="/bombs/walls/roller_shutter-breached.jpg" alt="Steel roller shutter, breached" loading="lazy" /></div>
    <figcaption><b>Steel roller shutter</b>Style <code>roller_shutter</code><br />Item <code>wallkit_roller_shutter</code><br />Breaks into metal fragments and sparks. Paintable: <b style="display:inline">20</b> colours.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/drywall.jpg" alt="Stud wall (plasterboard)" loading="lazy" /><img src="/bombs/walls/drywall-breached.jpg" alt="Stud wall (plasterboard), breached" loading="lazy" /></div>
    <figcaption><b>Stud wall (plasterboard)</b>Style <code>drywall</code><br />Item <code>wallkit_drywall</code><br />Breaks into plaster dust. Paintable: <b style="display:inline">20</b> colours.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/wood_planks.jpg" alt="Timber plank wall" loading="lazy" /><img src="/bombs/walls/wood_planks-breached.jpg" alt="Timber plank wall, breached" loading="lazy" /></div>
    <figcaption><b>Timber plank wall</b>Style <code>wood_planks</code><br />Item <code>wallkit_wood_planks</code><br />Breaks into splinters.</figcaption>
  </figure>
</div>

### Toughness 2 - masonry

Takes a grenade, a car, a barrel, or propane - not a bike or a firework.

<div class="render-grid wide">
  <figure>
    <div class="render-pair"><img src="/bombs/walls/cinder_block.jpg" alt="Cinder block wall" loading="lazy" /><img src="/bombs/walls/cinder_block-breached.jpg" alt="Cinder block wall, breached" loading="lazy" /></div>
    <figcaption><b>Cinder block wall</b>Style <code>cinder_block</code><br />Item <code>wallkit_cinder_block</code><br />Breaks into masonry and rock. Paintable: <b style="display:inline">20</b> colours.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/ledgestone.jpg" alt="Dry-stacked stone wall" loading="lazy" /><img src="/bombs/walls/ledgestone-breached.jpg" alt="Dry-stacked stone wall, breached" loading="lazy" /></div>
    <figcaption><b>Dry-stacked stone wall</b>Style <code>ledgestone</code><br />Item <code>wallkit_ledgestone</code><br />Breaks into masonry and rock.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/brick_painted.jpg" alt="Painted brick wall" loading="lazy" /><img src="/bombs/walls/brick_painted-breached.jpg" alt="Painted brick wall, breached" loading="lazy" /></div>
    <figcaption><b>Painted brick wall</b>Style <code>brick_painted</code><br />Item <code>wallkit_brick_painted</code><br />Breaks into masonry and rock. Paintable: <b style="display:inline">21</b> colours.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/brick_red.jpg" alt="Red brick wall" loading="lazy" /><img src="/bombs/walls/brick_red-breached.jpg" alt="Red brick wall, breached" loading="lazy" /></div>
    <figcaption><b>Red brick wall</b>Style <code>brick_red</code><br />Item <code>wallkit_brick_red</code><br />Breaks into masonry and rock.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/rusted_sheet.jpg" alt="Rusted sheet-steel wall" loading="lazy" /><img src="/bombs/walls/rusted_sheet-breached.jpg" alt="Rusted sheet-steel wall, breached" loading="lazy" /></div>
    <figcaption><b>Rusted sheet-steel wall</b>Style <code>rusted_sheet</code><br />Item <code>wallkit_rusted_sheet</code><br />Breaks into metal fragments and sparks.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/tile_white.jpg" alt="White tiled wall" loading="lazy" /><img src="/bombs/walls/tile_white-breached.jpg" alt="White tiled wall, breached" loading="lazy" /></div>
    <figcaption><b>White tiled wall</b>Style <code>tile_white</code><br />Item <code>wallkit_tile_white</code><br />Breaks into plaster dust. Paintable: <b style="display:inline">20</b> colours.</figcaption>
  </figure>
</div>

### Toughness 3 - heavy

Takes a sticky bomb, a rocket, a truck, a proximity mine, or the railgun.

<div class="render-grid wide">
  <figure>
    <div class="render-pair"><img src="/bombs/walls/basalt_stone.jpg" alt="Fitted basalt wall" loading="lazy" /><img src="/bombs/walls/basalt_stone-breached.jpg" alt="Fitted basalt wall, breached" loading="lazy" /></div>
    <figcaption><b>Fitted basalt wall</b>Style <code>basalt_stone</code><br />Item <code>wallkit_basalt_stone</code><br />Breaks into masonry and rock.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/concrete_painted.jpg" alt="Painted concrete wall" loading="lazy" /><img src="/bombs/walls/concrete_painted-breached.jpg" alt="Painted concrete wall, breached" loading="lazy" /></div>
    <figcaption><b>Painted concrete wall</b>Style <code>concrete_painted</code><br />Item <code>wallkit_concrete_painted</code><br />Breaks into masonry and rock. Paintable: <b style="display:inline">20</b> colours.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/concrete.jpg" alt="Poured concrete wall" loading="lazy" /><img src="/bombs/walls/concrete-breached.jpg" alt="Poured concrete wall, breached" loading="lazy" /></div>
    <figcaption><b>Poured concrete wall</b>Style <code>concrete</code><br />Item <code>wallkit_concrete</code><br />Breaks into masonry and rock.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/stone_block.jpg" alt="Rough stone block wall" loading="lazy" /><img src="/bombs/walls/stone_block-breached.jpg" alt="Rough stone block wall, breached" loading="lazy" /></div>
    <figcaption><b>Rough stone block wall</b>Style <code>stone_block</code><br />Item <code>wallkit_stone_block</code><br />Breaks into masonry and rock.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/sandstone.jpg" alt="Sandstone block wall" loading="lazy" /><img src="/bombs/walls/sandstone-breached.jpg" alt="Sandstone block wall, breached" loading="lazy" /></div>
    <figcaption><b>Sandstone block wall</b>Style <code>sandstone</code><br />Item <code>wallkit_sandstone</code><br />Breaks into masonry and rock.</figcaption>
  </figure>
</div>

### Toughness 4 - fortified

Only a tank shell, a plane rocket, the Valkyrie cannon - or a well-packed bomb.

<div class="render-grid wide">
  <figure>
    <div class="render-pair"><img src="/bombs/walls/castle_stone.jpg" alt="Castle ashlar wall" loading="lazy" /><img src="/bombs/walls/castle_stone-breached.jpg" alt="Castle ashlar wall, breached" loading="lazy" /></div>
    <figcaption><b>Castle ashlar wall</b>Style <code>castle_stone</code><br />Item <code>wallkit_castle_stone</code><br />Breaks into masonry and rock.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/concrete_reinforced.jpg" alt="Reinforced concrete wall" loading="lazy" /><img src="/bombs/walls/concrete_reinforced-breached.jpg" alt="Reinforced concrete wall, breached" loading="lazy" /></div>
    <figcaption><b>Reinforced concrete wall</b>Style <code>concrete_reinforced</code><br />Item <code>wallkit_concrete_reinforced</code><br />Breaks into masonry and rock.</figcaption>
  </figure>
  <figure>
    <div class="render-pair"><img src="/bombs/walls/steel_plate.jpg" alt="Riveted steel plate wall" loading="lazy" /><img src="/bombs/walls/steel_plate-breached.jpg" alt="Riveted steel plate wall, breached" loading="lazy" /></div>
    <figcaption><b>Riveted steel plate wall</b>Style <code>steel_plate</code><br />Item <code>wallkit_steel_plate</code><br />Breaks into metal fragments and sparks.</figcaption>
  </figure>
</div>

## Paint Colours

Painted styles come in any of these colours, picked when the wall is placed (the panel shows a swatch for each) or later with **Repaint**. A style lists the colours it was built in - see `Colors` in `configs/shared/walls.lua`.

<div style="display:flex;flex-wrap:wrap;gap:8px;margin:14px 0 22px">
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#CCCAC4;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>White <code style="font-size:11px">white</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#D4C6A4;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Cream <code style="font-size:11px">cream</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#C4B08C;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Sand <code style="font-size:11px">sand</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#D0AE54;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Mustard yellow <code style="font-size:11px">yellow</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#D6A080;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Peach <code style="font-size:11px">peach</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#BE785E;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Terracotta <code style="font-size:11px">terracotta</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#8E342C;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Barn red <code style="font-size:11px">red</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#682830;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Burgundy <code style="font-size:11px">burgundy</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#C8969A;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Dusty pink <code style="font-size:11px">pink</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#A092B6;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Lilac <code style="font-size:11px">lilac</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#2C3E5C;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Navy <code style="font-size:11px">navy</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#809CB6;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Dusty blue <code style="font-size:11px">blue</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#387A7C;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Teal <code style="font-size:11px">teal</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#AAD0BE;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Mint <code style="font-size:11px">mint</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#96A88A;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Sage green <code style="font-size:11px">sage</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#3E6E52;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Bottle green <code style="font-size:11px">green</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#6E7042;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Olive <code style="font-size:11px">olive</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#929496;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Grey <code style="font-size:11px">grey</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#3E4044;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Charcoal <code style="font-size:11px">charcoal</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#222224;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Black <code style="font-size:11px">black</code></span>
  <span style="display:inline-flex;align-items:center;gap:7px;padding:4px 10px 4px 5px;border:1px solid var(--vp-c-divider);border-radius:999px;font-size:13px"><span style="width:18px;height:18px;border-radius:50%;background:#684C38;box-shadow:inset 0 0 0 1px rgba(0,0,0,.25)"></span>Brown <code style="font-size:11px">brown</code></span>
</div>

## Hole Shapes

Every style ships **ten hole shapes**. Below they are shown on the red brick wall. Numbers 5 and 6 are **4 m** units; 9 and 10 only ever open at a run's **end**.

<div class="render-grid">
  <figure>
    <img src="/bombs/walls/holes/1.jpg" alt="Hole shape 1: breach" loading="lazy" />
    <figcaption><b>1 · breach</b>(also <code>doorway</code>) Doorway-sized - walk through it.</figcaption>
  </figure>
  <figure>
    <img src="/bombs/walls/holes/2.jpg" alt="Hole shape 2: split" loading="lazy" />
    <figcaption><b>2 · split</b>Tall and narrow - squeeze through sideways.</figcaption>
  </figure>
  <figure>
    <img src="/bombs/walls/holes/3.jpg" alt="Hole shape 3: wide" loading="lazy" />
    <figcaption><b>3 · wide</b>Most of a 2 m unit gone.</figcaption>
  </figure>
  <figure>
    <img src="/bombs/walls/holes/4.jpg" alt="Hole shape 4: low" loading="lazy" />
    <figcaption><b>4 · low</b>Knee- to waist-high - crawl or shoot through.</figcaption>
  </figure>
  <figure>
    <img src="/bombs/walls/holes/5.jpg" alt="Hole shape 5: vehicle" loading="lazy" />
    <figcaption><b>5 · vehicle</b>A 4 m unit: a car drives through, the wall still spans above it.</figcaption>
  </figure>
  <figure>
    <img src="/bombs/walls/holes/6.jpg" alt="Hole shape 6: collapse" loading="lazy" />
    <figcaption><b>6 · collapse</b>A 4 m unit, open to the sky: a van or a truck fits.</figcaption>
  </figure>
  <figure>
    <img src="/bombs/walls/holes/7.jpg" alt="Hole shape 7: window" loading="lazy" />
    <figcaption><b>7 · window</b>Does not reach the ground: see and shoot through, not walk.</figcaption>
  </figure>
  <figure>
    <img src="/bombs/walls/holes/8.jpg" alt="Hole shape 8: top" loading="lazy" />
    <figcaption><b>8 · top</b>The top edge blown out, the wall below still standing: climb, see, and shoot over.</figcaption>
  </figure>
  <figure>
    <img src="/bombs/walls/holes/9.jpg" alt="Hole shape 9: end" loading="lazy" />
    <figcaption><b>9 · end</b>The end of the run knocked off, top to bottom - open to the side.</figcaption>
  </figure>
  <figure>
    <img src="/bombs/walls/holes/10.jpg" alt="Hole shape 10: corner" loading="lazy" />
    <figcaption><b>10 · corner</b>The upper corner at an end come away on a diagonal.</figcaption>
  </figure>
</div>

### Which Hole a Blast Leaves

A game explosion picks its shape by how much **power it has to spare** over the wall's toughness:

| Power to spare | Hole |
|---|---|
| 0 - only just through | a split, a low hole, or a window (one at random) |
| 1 | a doorway |
| 2 | blown wide |
| 3 or more | vehicle-sized, or the whole section comes down |

A 4 m shape that does not fit the run - or the gap between two holes - falls back to the biggest 2 m one. A blast into a hole that is already there makes it the shape the blast would have left, or one size up from what is there, whichever is more.

### Bombs and Walls

A planted bomb breaches only a wall it is **set against** - stuck on it, or standing right at its foot - and the hole opens where the bomb is. How much explosive the builder packed into it (its **yield**) decides how hard it hits and which hole it leaves - and where on the wall it sits matters too:

| Yield | Power | At the foot | Higher up | At the top | Near an end | Upper corner |
|---|---|---|---|---|---|---|
| 1 block | 2 | crawl hole | window | top edge | as at its height | as at its height |
| 2 blocks | 3 | doorway | window | top edge | as at its height | as at its height |
| 3 blocks | 4 | blown wide | blown wide | top edge | end knocked off | corner |
| 4 blocks | 4 | vehicle-sized | vehicle-sized | top edge | end knocked off | corner |
| 5 blocks | 5 | vehicle-sized | vehicle-sized | top edge | end knocked off | corner |
| 6 blocks | 5 | whole section down | whole section down | whole section down | whole section down | whole section down |

While a player aims a bomb, the walls it would breach - and the hole each would get - are previewed on the wall.

## Placing from a Script

Put walls up from your own resource with the [server exports](./exports-server#walls). Pass the **style** key from the list above.

### Between two points

[`placeWallBetween`](./exports-server#placewallbetween) closes the gap between two points: the wall runs from the first to the second, and its length and heading are worked out for you.

```lua
-- Brick up a doorway: two points on the ground, one at each side of it
local wallId = exports['sd-bombs']:placeWallBetween('brick_red',
    vec3(253.2, 225.4, 101.8), -- one side of the gap
    vec3(256.9, 224.1, 101.8), -- the other side
    { tag = 'my-heist' }
)
print(('Wall %d placed'):format(wallId))
```

The length is rounded **up** to the next 0.25 m, so the wall always closes the gap. The wall's foot goes at the **lower** of the two points' heights - give ground-level points, or pass `z` in the options.

::: warning Ground height
A player's position (`GetEntityCoords(ped)`) is about **1 m above the ground**. Copying it straight in leaves the wall floating - take 1 m off its `z`, or pass the ground height as `z`.
:::

### At a position

[`placeWall`](./exports-server#placewall) puts a wall of a given length centred on a point, facing a heading:

```lua
-- A 6 m painted brick wall, navy, centred on this spot and facing 90 degrees
local wallId = exports['sd-bombs']:placeWall('brick_painted', vec4(-1182.4, -884.2, 13.8, 90.0), {
    length = 6.0,
    color = 'navy',       -- a colour the style comes in (see Paint Colours)
    persistent = true,      -- saved in data/walls.json, back after a restart
})
```

### Options

| Option | Default | Description |
|---|---|---|
| `length` | `2` | `placeWall` only: metres, rounded up to 0.25 (max 40) |
| `color` | - | A paint colour the style comes in |
| `persistent` | `false` | Save it so it comes back after a restart |
| `tag` | - | Your own label - remove all your walls at once with `removeWallsByTag('my-heist')` |
| `z` | the lower point | `placeWallBetween` only: the height of the wall's foot |

::: tip Walls a script rebuilds every time
Leave `persistent` off and give your walls a `tag`: put them up when your heist starts, and tear them down with `removeWallsByTag` when it resets. Nothing is left behind in `data/walls.json`.
:::

## Breaching from a Script

Break a wall exactly the way you want with the [`breachWall`](./exports-server#breachwall) export - pick the shape by name and where along the wall it goes:

```lua
-- A doorway 3 m along wall 12
exports['sd-bombs']:breachWall(12, 'doorway', { along = 3.0 })

-- Knock the far end off
exports['sd-bombs']:breachWall(12, 'end', { side = 'end' })

-- Let the wall pick, the way a rocket would
exports['sd-bombs']:breachWall(12, nil, { power = 3 })
```

## Staff Commands

| Command | What it does |
|---|---|
| `/wall_place [style]` | Place one 2 m wall module with the placement tool (no style: the last one used) |
| `/wall_remove` | Remove the wall nearest to you |
| `/wall_break` | Breach the wall nearest to you |
| `/wall_repair [all]` | Rebuild the nearest breached wall, or every one |
| `/wall_clear` | Remove **every** wall, saved ones included |
| `/wall_styles` | List the style names |

All wall commands are restricted to `group.admin` by default (`Commands.Restricted` in `configs/shared/placement.lua`). The admin panel's **Walls** tab does all of this and more - place runs of any length with a live 3D preview, resize, extend, restyle, repaint, and move them.
