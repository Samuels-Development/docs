# Beekeeping <VersionBadge repo="sd-beekeeping" fallback="1.3.2" />

**Beekeeping** (`sd-beekeeping`) is an advanced beekeeping system for FiveM. Place hives and bee houses in the world, capture wild bees, produce regional honey types, manage infections and aggression, collaborate with other players, and sell your products to the Beekeeper NPC.

## Preview

<YouTubeEmbed id="5rdMkm7YAo4" title="Beekeeping — Full Showcase" />

## Features

### Bee Houses
Capture wild bees from the world using placeable bee houses.

- Up to **5 houses** per player
- Each capture takes **300 seconds** (5 minutes)
- Yields **2–3 worker bees** per capture
- **10% chance** to capture a queen bee
- Houses can hold up to **50 workers** and **5 queens**

### Bee Hives
The core of the operation — hives produce honey and wax over time.

- Up to **5 hives** per player
- Requires at least **1 queen** and **5 workers** to start production
- Produces **1–2 honey** every **600 seconds** (10 minutes)
- **10% chance** to also produce wax alongside honey
- Max capacity: **100 honey**, **20 wax** per hive
- Up to **50 workers** per hive

### Regional Honey Types

Hives produce different honey depending on where they're placed. Three geographic honey zones are defined:

| Honey Type | Zone | Item |
|---|---|---|
| **Chiliad Honey** | Mount Chiliad meadow | `chiliad-honey` |
| **Green Hills Honey** | Vinewood Hills / countryside | `green-hills-honey` |
| **Alamo Honey** | Alamo Sea / desert | `alamo-honey` |
| **Basic Honey** | Anywhere outside zones | `bee-honey` |

### Production Multipliers

More worker bees = faster production. Every **10 workers** unlocks a higher multiplier:

| Workers | Multiplier |
|---|---|
| 10–19 | 1.2x |
| 20–29 | 1.3x |
| 30–39 | 1.4x |
| 40–49 | 1.5x |
| 50+ | 2.0x |

### Durability & Decay

All facilities degrade over time and must be repaired:

- **Hives** lose 1 durability every 60 minutes
- **Houses** lose 2 durability every 120 minutes
- Repairs cost **$100 per durability point**
- Hives can only be **picked up at 95%+ durability**

### Infection System

Hives can become infected with 3 severity tiers. Untreated infections get worse over time:

| Severity | Worker Death Chance | Worker Deaths | Queen Death Chance | Production Delay |
|---|---|---|---|---|
| **1** | 20% | 1–3 per check | 0% | 2.0x slower |
| **2** | 30% | 2–4 per check | 5% | 2.5x slower |
| **3** | 50% | 3–6 per check | 10% | 3.0x slower |

- Treat infections with **thymol** items
- Purchase **infection shields** (3 tiers) for time-limited protection

### Aggression System

Bees have 4 aggression levels that affect sting chance:

| Level | Name | Sting Chance | Damage |
|---|---|---|---|
| 1 | Calm | 0% | 0 |
| 2 | Alert | 20% | 5 |
| 3 | Defensive | 50% | 10 |
| 4 | Aggressive | 80% | 20 |

- **Smoker tool** reduces aggression (by all levels by default, 25% chance the smoker breaks)
- **Protective clothing** (configurable components/props per gender) reduces sting risk
- Aggression rolls every **120 minutes**, influenced by worker count, infection severity, and hive fullness

### Beekeeper NPC & Shop

A beekeeper NPC spawns at configured locations. Players can buy equipment and sell products:

**Buy:** Bee Houses, Bee Hives, Thymol Treatment, Bee Smokers
**Sell:** Beeswax, all 4 honey types

### Collaborator System

Share your facilities with other players:

- Invite nearby players (configurable distance, default 10m)
- Collaborators can harvest, repair, and treat — but cannot pick up or destroy
- Optional collaborator limit per player
- Display options: server ID, citizen ID, character name

### Prop Types

Choose from 4 prop styles for hives and houses:

| Type | Description |
|---|---|
| `native` | Default GTA props |
| `bzzz` | Bzzz mod props |
| `nopixel` | NoPixel-style props |
| `custom` | Define your own prop names |

### Logging

Comprehensive server-side logging for all major actions (purchases, placements, harvests, repairs, etc.) with support for:
- Discord webhooks
- Fivemanage
- Fivemerr (fm-logs)
- Loki
- Grafana

## Supported Frameworks

| Framework | Status |
|---|---|
| `qb-core` | Fully supported |
| `qbx_core` | Fully supported |
| `es_extended` (ESX) | Fully supported |

## Supported Inventories

| Inventory | Status |
|---|---|
| `ox_inventory` | Fully supported |
| `tgiann-inventory` | Supported |
| `jaksam_inventory` | Supported |
| `qs-inventory` | Supported |
| `qs-inventory-pro` | Supported |
| `qb-inventory` | Supported |
| `ps-inventory` | Supported |
| `lj-inventory` | Supported |
| `codem-inventory` | Supported |

## Supported Target Systems

| Target | Status |
|---|---|
| `ox_target` | Fully supported |
| `qb-target` | Fully supported |
| `qtarget` | Fully supported |

## Dependencies

| Dependency | Options |
|---|---|
| **Framework** | `qb-core` / `qbx_core` / `es_extended` |
| **Library** | `ox_lib` |
| **Database** | `oxmysql` |
| **Target System** | `ox_target` / `qb-target` / `qtarget` |
| **Inventory** | Any of the 9 supported inventories listed above |

::: tip
Framework, inventory, and target system are all auto-detected. The database table `sd_beekeeping` is created automatically on first start.
:::

## File Structure

```
sd-beekeeping/
  bridge/
    init.lua              -- Framework detection
    shared.lua            -- Locale system, shared utilities
    client.lua            -- Client bridge (notifications, target, interaction)
    server.lua            -- Server bridge (money, inventory, player data)
  client/
    admin.lua             -- Admin commands
    main.lua              -- Client-side hive/house placement, harvesting, UI
    object.lua            -- Object spawning and management
  server/
    admin.lua             -- Server admin logic
    logs.lua              -- Logging configuration
    main.lua              -- Server-side production, durability, collaborators
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  images/
    alamo-honey.png
    bee-hive.png
    bee-honey.png
    bee-house.png
    bee-queen.png
    bee-smoker.png
    bee-wax.png
    bee-worker.png
    chiliad-honey.png
    green-hills-honey.png
    thymol.png
  stream/
    hp3d_beehive.ytyp     -- Prop type definition
    hp3d_beehive1.ydr     -- Bee house model
    hp3d_beehive2.ydr     -- Bee hive model
  web/
    build/                -- NUI build files
    src/
      App.tsx
      index.scss
      main.tsx
    index.html
    package.json
    postcss.config.js
    tailwind.config.js
    tsconfig.json
    tsconfig.node.json
    vite.config.ts
  [SQL]/
    run_me.sql            -- Creates sd_beekeeping table
    ESX/items.sql         -- ESX item definitions
  config.lua              -- All configuration
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/beekeeping/installation) — Get up and running
- [Configuration](/resources/beekeeping/configuration) — Every config option explained
- [Common Issues](/resources/beekeeping/common-issues) — Troubleshooting guide
