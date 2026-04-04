# Oxy Run <VersionBadge repo="sd-oxyrun" fallback="1.7.2" />

**Oxy Run** (`sd-oxyrun`) is a NoPixel-inspired Oxy Run drug delivery system for FiveM. Players pick up packages from suppliers and deliver them to NPC buyers in vehicles across the city. Features a 3-level reputation system, money washing, configurable routes, and a robbery minigame mechanic.

## Preview

<YouTubeEmbed id="8IYsleOU5Zc" title="Oxy Run — Full Showcase" />

## Key Features

### Mission Flow

1. **Sign in** at the Boss NPC (spawns at one of 3 random locations)
2. **Pay the fee** ($500 by default) and pass the police check
3. **Collect packages** from a supplier (4-6 packages per run)
4. **Deliver to buyers** -- NPC vehicles arrive at the delivery zone one by one
5. **Earn rewards** -- oxy, dirty money, and rare items per delivery

### 3-Level Reputation System

Progress through levels by earning XP from deliveries:

| Level | XP Required | Oxy Reward | Police Alert Chance | Money Tax |
|---|---|---|---|---|
| **1** | 0 | 3-5 | 33% | 25% |
| **2** | 150 | 5-7 | 25% | 15% |
| **3** | 300 | 7-10 | 10% | 0% |

Higher levels also unlock better money washing rates, more rare item drops, and expanded route availability.

### Money Washing

Deliveries can reward dirty money items alongside oxy:

| Item | Level 1 Chance | Level 2 Chance | Level 3 Chance | Value Range |
|---|---|---|---|---|
| **Bills** | 20% | 25% | 40% | $750-$2,000 |
| **Bands** | 15% | 20% | 45% | $750-$2,000 |
| **Rolls** | 25% | 40% | 55% | $250-$750 |

### Rare Item Drops

| Level | Chance | Possible Items |
|---|---|---|
| 1 | 5% | Advanced Lockpick, Security Card 01 |
| 2 | 8% | Advanced Lockpick, Security Card 02 |
| 3 | 12% | Security Card Oil, Security Card 02 |

### Supplier System

- **13 supplier locations** across the map
- **8 supplier ped models** for variety
- Two modes: **roaming** (new supplier per package) or **stationary** (one supplier for all)

### Route System

- **23 total routes** across all 3 levels (7 + 8 + 8)
- Each route has unique spawn, delivery, and despawn waypoints
- Routes are **occupied per player** -- no overlapping
- **14 vehicle models** and **3 driver ped models** for buyers

### Robbery Minigame

- Optional mechanic where a buyer tries to flee with your drugs
- Configurable chance per level
- Uses lib.skillCheck with configurable difficulty
- Success keeps the reward; failure loses the package

### Cooldown System

| Type | Default | Description |
|---|---|---|
| **Run Timeout** | 30 min | Max time for a single run |
| **Buyer Timeout** | 5 min | Time before buyer leaves the area |
| **Global Cooldown** | 20 min | Server-wide cooldown between runs |
| **Personal Cooldown** | 20 min | Per-player cooldown |

## File Structure

```
sd-oxyrun/
  client/
    main.lua              -- Client-side run logic, suppliers, deliveries
  server/
    main.lua              -- Server-side rewards, XP, cooldowns
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  images/
    bands.png
    oxy.png
    package.png
    rolls.png
  [SQL]/
    run_me.sql            -- Creates sd_oxyrun table
    ESX/items.sql         -- ESX item definitions
  config.lua              -- All configuration
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/oxyrun/installation) -- Get up and running
- [Configuration](/resources/oxyrun/configuration) -- Customize every aspect
