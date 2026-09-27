# Configuration

All configuration for sd-bombs lives in the `configs/` directory:

- **`configs/config.lua`** -- Config root (debug)
- **`configs/shared/admin.lua`** -- Admin panel, permissions, placement tool
- **`configs/shared/bomb.lua`** -- Bomb defaults, the clock, the explosion, staff commands
- **`configs/shared/items.lua`** -- Items, planting, the bomb builder and workbenches
- **`configs/shared/walls.lua`** -- Wall styles, toughness, and paint colours
- **`configs/shared/breaking.lua`** -- What breaches a wall, hole shapes, auto-repair, effects
- **`configs/shared/placement.lua`** -- Wall persistence, wall commands, wall-kit items
- **`configs/shared/props.lua`** -- Prop models and where each piece sits on the casing

The full default files are on the **Full Config Files** pages in the sidebar. The sections below cover the settings you are most likely to change.

## General

```lua
local config = {
    Debug = false,       -- dev logging ([sd-bombs:*] lines); leave off in production
    DebugPrints = false, -- very verbose framework/inventory bridge prints
    -- ...
}
```

| Setting | Default | Description |
|---|---|---|
| `Debug` | `false` | Prints debug lines to the server and client console |
| `DebugPrints` | `false` | Prints every framework and inventory bridge call - only for tracking down an integration problem |

## Admin Panel

`configs/shared/admin.lua`

```lua
return {
    Command = 'bombadmin',
    Group = 'group.admin',
    ViewGroup = false,
    EditAce = 'sd_bombs.edit',
    PlaceReach = 25.0,
    Placement = {
        SnapMove = 0.25,
        SnapTurn = 15.0,
        Nudge = 0.05,
        TurnStep = 5.0,
    },
    RefreshMs = 2500,
}
```

| Setting | Default | Description |
|---|---|---|
| `Command` | `'bombadmin'` | Opens the panel. The ACE it grants is `command.bombadmin` |
| `Group` | `'group.admin'` | ACE principal with full access |
| `ViewGroup` | `false` | An ACE principal (e.g. `'group.mod'`) that can open the panel and look, but not change anything |
| `EditAce` | `'sd_bombs.edit'` | The ACE every change needs - granted to `Group` automatically |
| `PlaceReach` | `25.0` | Metres ahead of the camera a new placement starts |
| `Placement.SnapMove` / `SnapTurn` | `0.25` / `15.0` | Metres and degrees per step while snapping is on |
| `Placement.Nudge` | `0.05` | Metres per frame the arrow keys move a placement (`Shift` x5) |
| `Placement.TurnStep` | `5.0` | Degrees per mouse-wheel notch (`Shift`: 15, `Ctrl`: 1) |
| `RefreshMs` | `2500` | How often the open panel refreshes (bomb clocks, breaches by players) |

## Bombs

`configs/shared/bomb.lua`

```lua
Defaults = {
    Modules = 5,
    Seconds = 300,
    Strikes = 3,
    Needy = false,
    Yield = 3,
},
MinSeconds = 30,
Persist = true,
Explosion = {
    Enabled = true,
    Type = 2,
    Damage = 1.0,
    Shake = 1.0,
    ByYield = { 0.5, 0.75, 1.0, 1.3, 1.6, 2.0 },
},
DefusedLinger = 60,
```

| Setting | Default | Description |
|---|---|---|
| `Defaults.Modules` | `5` | Modules on a bomb that is not hand-built (1-11) |
| `Defaults.Seconds` | `300` | Seconds on the clock when it is planted |
| `Defaults.Strikes` | `3` | Strikes allowed (1-5); the last strike is the explosion |
| `Defaults.Needy` | `false` | Also deal 1-2 needy modules |
| `Defaults.Yield` | `3` | Blocks of explosive a bomb that is not hand-built carries |
| `MinSeconds` | `30` | The least time a Defuser ever gets when they open a bomb |
| `Persist` | `true` | Armed bombs survive a restart, their clocks still running |
| `Explosion.Enabled` | `true` | `false` = the prop just vanishes when it goes off |
| `Explosion.Type` | `2` | [Explosion type](https://docs.fivem.net/docs/game-references/explosions) of the blast |
| `Explosion.ByYield` | | Damage and shake multiplier for each yield (1-6 blocks) |
| `DefusedLinger` | `60` | Seconds a defused bomb stays in the world |
| `LiveTimer` | | The clock drawn live on the casing, and its ticking |

::: tip Staff commands
`Commands` renames or turns off (`false`) every staff command: `/bomb_plant`, `/bomb_clear`, `/bomb_detonate`, `/bomb_give_set`. Set `ManualCommand` to a name (e.g. `'bomb_manual'`) to also open the field manual with a command.
:::

## Items

`configs/shared/items.lua`

```lua
Bomb = 'sd_bomb',
BombImages = { small = 'sd_bomb_small', medium = 'sd_bomb_medium', large = 'sd_bomb_large' },
Manual = 'sd_bomb_manual',
```

| Setting | Description |
|---|---|
| `Bomb` | The bomb item. Using it: aim at a floor, wall, or ceiling and arm it there |
| `BombImages` | The image a bomb of each compact size shows (item metadata). `false` = every bomb shows `sd_bomb` |
| `Manual` | The field manual item - never consumed |
| `Plant` | How planting works: `Aim` (`false` = set down in front of you, no aiming), `Reach`, which `Surfaces` are allowed, the carry and planting animations |

Renaming an item here renames what the resource looks for - update your inventory to match. On `ox_inventory` the export is named after the item (`sd_bomb` → `sd-bombs.useSd_bomb`).

## Bomb Builder

`configs/shared/items.lua` > `Builder`

```lua
Builder = {
    Kit = 'sd_bomb_kit',
    MaxModules = 11,
    Charge = { Item = 'sd_explosive', Min = 1, Max = 6 },
    Steps = { Cut = true, Crimp = true, Bolts = true, Wire = true, Route = true, Test = true, Strap = true, Prep = true, Sign = true, Edge = true, Pin = false },
    GiveCommand = 'bomb_toolkit',
    Strikes = 3,
    Timer = { Min = 60, Max = 900, Step = 30, Default = 300 },
    -- ...
}
```

| Setting | Default | Description |
|---|---|---|
| `Kit` | `'sd_bomb_kit'` | The Extra Large casing kit |
| `MaxModules` | `11` | Bays a build may fill (the twelfth is the timer) |
| `Charge.Item` | `'sd_explosive'` | One item = one block = one point of yield |
| `Charge.Min` / `Max` | `1` / `6` | Blocks a bomb needs at least / holds at most |
| `Supplies` | | The handbook, screws, wire, brackets, and straps - an item each. Set one to `false` to not ask for it |
| `GiveCommand` | `'bomb_toolkit'` | Staff command that hands out what a build takes. `false` = none |
| `Strikes` | `3` | What the work order starts on - the builder picks 1-5 |
| `Timer` | | Seconds the builder may put on the clock |

### Steps

Every part of the build beyond packing and screwing can be switched off. A step that is off is never asked for, and its tool is never needed.

| Step | What it asks for |
|---|---|
| `Cut` | Slitting the carton's tape with the knife |
| `Crimp` | A detonator cap crimped into every packed block, its lead clamped under a terminal of the firing unit |
| `Bolts` | The front's four corner bolts are hex bolts - the hex key, not the driver |
| `Wire` | Every fitted module wired in with the strippers |
| `Route` | ...by hand: each lead run along the gutters to the timer's hub. `false` = one click wires it |
| `Test` | Proving the circuit with the multimeter |
| `Strap` | Every block strapped down with the band tensioner |
| `Prep` | Every length of wire cut to length and stripped before it goes on |
| `Sign` | QC signs the work order off before the bomb is assembled |
| `Edge` | The builder fits the edgework by hand. `false` = the lot deals it |
| `Pin` | An arming pin in the firing unit - signed off with it still in, the bomb is a dud |

### Workbench

`Builder.Bench`

| Setting | Default | Description |
|---|---|---|
| `Model` | `'sd_bomb_bench'` | The bench prop |
| `World` | `true` | Build in the world, on the bench. `false` = a 3D builder page instead (any bench prop) |
| `Required` | `true` | A kit can only be opened at a bench (while the server has any bench at all) |
| `Reach` | `3.0` | Metres from a bench it can be used from |
| `Locations` | `{}` | Fixed benches for your map: `{ vec4(x, y, z, heading), ... }` - `z` is the ground |
| `Command` | `'bomb_bench'` | Staff command to stand a bench (and `remove` one) |
| `Item` | | The workbench item - see [The Workbench Item](./building#the-workbench-item) |
| `Light` | | The bench lamp: colour, reach, brightness |
| `Radio` | | The shelf radio's stations and knobs |
| `Camera` | | Where the bench camera sits, and how it follows your work |

## Walls

`configs/shared/walls.lua`

```lua
return {
    Height = 3.0,
    MaxLength = 40.0,
    Styles = {
        drywall = { label = 'Stud wall (plasterboard)', toughness = 1, fx = 'plaster', debris = 10, stock = '#B0A8A6', colors = { ... } },
        brick_red = { label = 'Red brick wall', toughness = 2, fx = 'masonry', debris = 16 },
        -- ...
    },
    Colors = {
        white = { label = 'White', hex = '#CCCAC4' },
        -- ...
    },
}
```

| Setting | Description |
|---|---|
| `MaxLength` | The longest single run, in metres |
| `Styles.<key>` | The **style key** (e.g. `brick_red`) - the name every wall export and `/wall_place` use |
| `Styles.<key>.label` | The display name |
| `Styles.<key>.toughness` | `1`-`4`: what an explosion's power has to reach to breach it |
| `Styles.<key>.fx` | Breach particles: `'plaster'`, `'wood'`, `'metal'`, or `'masonry'` |
| `Styles.<key>.debris` | How many chunks fly |
| `Styles.<key>.colors` | The paint colours it was built in |

::: warning
The styles and colours are **models**: a colour only exists if it was built into the streamed files. Renaming or adding a key here is not enough - change labels and toughness freely, but leave the keys as they are.
:::

See the [Walls Reference](./walls) for every style and colour.

## Breaking

`configs/shared/breaking.lua`

| Setting | Default | Description |
|---|---|---|
| `Explosions.Enabled` | `true` | Game explosions breach walls. `false` = only bombs and the exports do |
| `Explosions.Power` | | Power for each [explosion type](https://docs.fivem.net/docs/game-references/explosions) - `0` never breaches |
| `Explosions.DefaultPower` | `1` | Any type not listed |
| `Explosions.Reach` | `{ Base = 2.0, PerPower = 0.9 }` | Metres a blast reaches: `Base + PerPower x Power` |
| `Explosions.IgnoreInvisible` | `false` | Ignore explosions flagged invisible (some scripts use them for damage only) |
| `Bomb.Enabled` | `true` | A planted bomb going off breaches walls |
| `Bomb.Contact` | `0.75` | A bomb breaches only a wall it is set against - within this many metres. `false` = every wall within its radius |
| `Bomb.Yield` | | Power, radius, and hole shape for each yield (1-6 blocks) |
| `HolePosition` | `'blast'` | `'blast'` = the hole opens where the explosion was; `'centre'` = always the middle of the run |
| `Holes.BySurplus` | | Which hole shapes a blast leaves, by how much power it has to spare |
| `Holes.Widen` | `true` | A blast into a hole that is already there makes it bigger |
| `RepairAfter` | `900` | Seconds before a breached wall rebuilds itself. `0` = it stays breached |
| `Effects` | | Debris, particles, and camera shake |

See [Toughness](./walls#toughness) and [Hole Shapes](./walls#hole-shapes).

## Placement & Wall Kits

`configs/shared/placement.lua`

```lua
return {
    Persist = true,
    Commands = {
        Restricted = 'group.admin',
        Place = 'wall_place',
        Remove = 'wall_remove',
        Break = 'wall_break',
        Repair = 'wall_repair',
        Clear = 'wall_clear',
        Styles = 'wall_styles',
        Reach = 6.0,
    },
    Items = {
        wallkit_drywall = 'drywall',
        wallkit_brick_red = 'brick_red',
        -- ...
    },
}
```

| Setting | Default | Description |
|---|---|---|
| `Persist` | `true` | Walls placed in-game are saved to `data/walls.json` |
| `Commands.Restricted` | `'group.admin'` | Who may use the wall commands |
| `Commands.*` | | Rename a command, or `false` to not register it |
| `Commands.Reach` | `6.0` | Metres the "nearest wall" commands look around you |
| `Items` | | Wall-kit item name → the style key it places, e.g. `wallkit_brick_red = 'brick_red'`. Remove an entry to drop that kit |
