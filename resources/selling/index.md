# Corner Selling <VersionBadge repo="sd-selling" fallback="2.2.4" />

**Corner Selling** (`sd-selling`) is an advanced drug dealing and corner selling system for FiveM. Sell drugs to NPCs in designated zones, progress through a 5-level reputation system, complete delivery missions, encounter bulk buyers, and track your milestones. Features dynamic pricing, robbery mechanics, money laundering, and a full statistics system.

## Preview

<YouTubeEmbed id="vhfmv4Wj1_Y" title="Corner Selling — Full Showcase" />

## Key Features

### Zone-Based Selling

- Multiple configurable selling zones (radius or polygon-based)
- Each zone has its own drug selection, pricing, cooldowns, and level restrictions
- Some zones require minimum police online
- Optional map blips per zone

### 5-Level Reputation System

| Level | Name | XP Required | Selling Hours | Price Multiplier | Police Alert | Robbery Risk |
|---|---|---|---|---|---|---|
| **1** | Pusher | 0 | 21:00-02:00 | 1.0x | 30% | 0% |
| **2** | Runner | 250 | 20:00-04:00 | 1.1x | 25% | 15% |
| **3** | Hustler | 1,000 | 19:00-05:00 | 1.2x | 20% | 13% |
| **4** | Kingpin | 2,000 | 18:00-06:00 | 1.3x | 15% | 20% |
| **5** | Legend | 3,500 | 17:00-07:00 | 1.4x | 10% | 3% |

### Drug Sale Mechanics

- **Randomized buyer behavior** -- price and quantity vary per NPC
- **Smart quantity logic** -- adapts based on player's current inventory
- **Custom animations** -- per-drug handshake animations (configurable)
- **Rejection system** -- buyers can refuse with separate police alert chance
- **Metadata support** -- sell different variants of the same drug (e.g., weed strains) via ox_inventory

### Robbery System

- Buyers can **steal your drugs and flee**
- Chase and incapacitate the NPC to retrieve your product
- Drugs are destroyed if the buyer escapes beyond **100m**
- **5-minute global cooldown** between robberies

### Delivery Missions

Three delivery tiers available from the Drug Lord NPC:

| Tier | Units | Stops | XP per Stop | Processing Time |
|---|---|---|---|---|
| **Small** | 50 | 3-8 | 20 XP | 5 minutes |
| **Medium** | 125 | 5-12 | 25 XP | 5 minutes |
| **Large** | 250 | 8-13 | 30 XP | 5 minutes |

Each tier has multiple randomized routes with varying payout boosts (0-20% bonus per stop).

### Bulk Sale Encounters

- **Random encounters** trigger based on level (2-6% chance)
- Bulk purchases of **25-40 units** at **1.5x market price**
- Meeting at one of **17 random locations** across the map
- **100 XP bonus** per completed encounter
- **30-minute cooldown** between encounters

### Milestone System

Track your progress and earn rewards:

- **General milestones** based on total units sold
- **Drug-specific milestones** for individual drugs
- Rewards: items, XP, or money
- Multi-stage milestones with escalating rewards

### Money Laundering

- Level-based tax on dirty money (Level 1: 25%, Level 5: 5%)
- Support for marked bills, bands, and rolls
- Optional item-based washing system

### Statistics

- Track units sold per drug, total XP, and more
- View stats from the NPC interaction menu
- Persistent database storage

## File Structure

```
sd-selling/
  client/
    main.lua              -- Client-side selling, deliveries, encounters, robbery
  server/
    logs.lua              -- Logging configuration
    main.lua              -- Server-side rewards, XP, milestones, encounters
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  images/
    bands.png
    rolls.png
  [SQL]/ESX/items.sql     -- ESX item definitions
  config.lua              -- All configuration
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/selling/installation) -- Get up and running
- [Configuration](/resources/selling/configuration) -- Customize every aspect
