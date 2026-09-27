# Bombs & Breakable Walls <VersionBadge repo="sd-bombs" fallback="1.0.0" />

**Bombs & Breakable Walls** (`sd-bombs`) is three systems in one resource: a **co-op bomb defusal** game played on a real 3D bomb, a **bomb builder** where players assemble bombs part by part on a workbench in the world, and **breakable walls** that any explosion can blow a hole through. An in-game admin panel runs all three.

Built on an in-house compatibility bridge, the same resource runs on **QBCore, QBox, and ESX** with any major inventory - no external bridge resource to install.

## Key Features

### Co-op Bomb Defusal

- One player - the **Defuser** - works a 3D briefcase bomb up close; everyone else - the **Experts** - reads the paper **field manual**. Nobody sees both
- **14 modules**: wires, the button, keypads, Simon says, who's on first, memory, Morse code, complicated wires, wire sequences, mazes, passwords, and three **needy** modules (venting gas, capacitor discharge, knobs)
- Every bomb is dealt from a **seed** - edgework, serial number, batteries, indicators, and ports all change the rules, exactly as the manual says
- A strike clock, a real countdown on the casing, and a bang that breaches walls if the Defuser runs out of luck
- Bombs are **real props in the world**, built from modular pieces so each one shows the modules it actually has

### Four Bomb Sizes

| Size | Name | Modules | Explosive |
|---|---|---|---|
| Small | **Wren** | 2 front bays | 1 block |
| Medium | **Kestrel** | 4 front bays | up to 2 blocks |
| Large | **Osprey** | 6 front bays | up to 4 blocks |
| Extra Large | **HIC-4410** | 12 bays, front and back | up to 6 blocks |

The amount of explosive packed into a bomb is its **yield** - it decides how big a hole the bomb blows and how tough a wall it gets through.

### Bomb Builder

- Players build bombs **on a workbench in the world**, with real props moved under a bench camera - no menu
- Slit the carton open, unpack the insert, lift the case out, undo the front's bolts, pack the charges, crimp detonator caps, run and clamp leads, screw down modules, fit the edgework, test the circuit with a multimeter, and sign the work order off
- **12 bench tools** hang on the pegboard - each job needs its tool, and the bench remembers what is on it for everyone, across restarts
- A **shelf radio**, a lamp that stays on when you walk away, a handbook on its lectern, and a work order on its clipboard
- Players can buy a **flat-pack workbench** item and set up their own bench wherever they like - and pack it up again

### Breakable Walls

- **20 wall styles** - from plasterboard stud walls to reinforced concrete and riveted steel plate - and **21 paint colours** for the painted ones
- A wall is a **run**: one straight stretch of any length up to 40 m, laid seamlessly from modular pieces
- **Any explosion** breaches it - grenades, rockets, vehicle explosions, another script's `AddExplosion`, or a planted bomb
- Each style has a **toughness** - a pipe bomb gets through a stud wall, only the heavy stuff through reinforced concrete
- **Ten hole shapes**: a doorway, a narrow split, a crawl hole, a window, a vehicle-sized gap, a full collapse, the top edge blown out, and an end or upper corner knocked off
- Flying debris, dust, and camera shake - and walls **rebuild themselves** after a configurable time
- Placed walls are saved and come back after a restart

See the [Walls Reference](./walls) for every style and hole shape.

### Admin Panel

A React admin panel opened with `/bombadmin`:

| Tab | What it does |
|---|---|
| **Overview** | Live counts, walls by style and toughness, and the breach rules in force |
| **Walls** | Place walls with a live 3D preview, move, resize, extend, restyle, repaint, breach, repair, delete |
| **Bombs** | Plant bombs you build in the panel - size, modules bay by bay, edgework, charge, clock - or hand them over as items |
| **Benches** | Place, move, kit out, clear, and delete workbenches, change their owner, and see what is on them in 3D |
| **Styles** | Browse every wall style in 3D, intact and breached, in every colour |

Walls and benches can be opened as **read-only JSON**, and staff can be given a **view-only** panel.

### Built-in Placement Tool

- Uses the game's **native editor gizmo** - the same one Scooters uses
- Snapping, drop-to-ground, stick-to-ground, keyboard nudging, and undo/redo
- Used for walls, bombs, benches, the wall-kit items, and the workbench item

## File Structure

```
sd-bombs/
  bridge/                 -- Framework, inventory, and notification bridge
  client/
    admin/                -- Admin panel, placement tool
    bomb/                 -- Bombs in the world, defusal UI, the workbench and bomb builder
    walls/                -- Walls in the world, breaches, debris, wall-kit placement
    api.lua               -- Client exports
  server/
    admin/                -- Admin panel verbs
    bomb/                 -- Bomb registry, builder, workbenches, what lies on them
    walls/                -- Wall registry, breaking, commands
    api.lua               -- Server exports
  shared/                 -- Rules shared by both sides (modules, layouts, breaches, the bench)
  configs/
    config.lua            -- Config root (debug)
    shared/
      admin.lua           -- Admin panel, permissions, placement tool
      bomb.lua            -- Bomb defaults, explosion, commands
      breaking.lua        -- What breaches a wall, hole shapes, auto-repair, effects
      items.lua           -- Items, planting, the bomb builder and workbench
      placement.lua       -- Wall persistence, wall commands, wall-kit items
      props.lua           -- Prop models and where each piece sits on the casing
      walls.lua           -- Wall styles, toughness, and paint colours
  data/                   -- Saved walls, bombs, benches, and what lies on them (JSON)
  locales/
    en.json               -- English
  stream/                 -- Bombs, modules, workbench, tools, and every wall style
  web/build/              -- Admin panel, defusal UI, and field manual
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/bombs/installation) -- Get up and running
- [Configuration](/resources/bombs/configuration) -- Customize every aspect
- [Building Bombs](/resources/bombs/building) -- The workbench, its tools, and the build
- [Walls Reference](/resources/bombs/walls) -- Every wall style and hole shape
- [Server Exports](/resources/bombs/exports-server) -- Integrate with other scripts
- [Client Exports](/resources/bombs/exports-client) -- Client-side integration
