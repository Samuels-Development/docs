# Coke Mission <VersionBadge repo="sd-cokemission" fallback="2.0.53" />

**Coke Mission** (`sd-cokemission`) is a NoPixel-inspired cocaine trafficking mission for FiveM. Players pay a boss NPC to initiate an underwater drug run, collect sealed caches from submerged vehicles, and optionally complete a phone number puzzle minigame before the drop locations are revealed.

## Preview

<YouTubeEmbed id="TchN_sXFbYI" title="Coke Mission — Full Showcase" />

## Key Features

### Mission Flow

1. **Meet the Boss** -- Interact with an NPC who spawns at one of 3 random locations
2. **Pay the Fee** -- Hand over $100,000 cash to initiate the run (configurable)
3. **Locate the Drops** -- Either directly or through the phone booth minigame
4. **Collect the Caches** -- Dive to 3 submerged vehicles and retrieve sealed caches
5. **Open Your Loot** -- Use a cache key to crack open sealed caches for drugs

### Two Mission Modes

| Mode | Description |
|---|---|
| **Direct** | Vehicles spawn immediately, GPS coordinates are marked, and you collect |
| **Minigame** | Receive 4 phone numbers via email, visit phone booths in the correct order, then vehicles spawn |

The phone booth minigame gives you **3 strikes** before the supplier abandons you, with an optional **30-minute timeout**.

### Sealed Cache System

- Each vehicle drop yields a `sealed_cache` item
- **10% chance** to also receive a `cache_key` per cache
- Keys are required to open caches (configurable)
- Opening a cache gives random reward items (coke bricks, weed bricks, etc.)
- **35% chance** the key breaks on use

### Police Integration

- Requires minimum **3 police** online to start (configurable)
- Automatic dispatch alert on mission start (code 10-31C)
- Blip created at drop zone for responding officers

### Environmental Effects

- **Flare particle effects** at each cache location (configurable duration, default 15 min)
- Optional **boat spawn** at Alamo Sea for easier access
- **9 underwater vehicle spawn locations** across the map coast

### Cooldown & Requirements

- **45-minute** personal cooldown between runs (configurable)
- Optional **blackout mode** -- mission only available during power outages (requires qb-weathersync)
- Minimum police check before starting

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
| **Library** | `sd_lib` (required) |
| **Zones** | `PolyZone` (required) |
| **Target System** | `ox_target` / `qb-target` / `qtarget` / TextUI fallback |

::: info
Framework, inventory, and target system are all auto-detected via sd_lib. No database tables are required -- state is managed in memory.
:::

## File Structure

```
sd-cokemission/
  client/
    main.lua              -- Client-side mission logic, zones, effects
    minigame.lua          -- Phone booth minigame logic
  server/
    main.lua              -- Server-side cooldowns, rewards, vehicle spawning
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  images/
    cache_key.png
    sealed_cache.png
  [SQL]/[ESX]/items.sql   -- ESX item definitions
  config.lua              -- All configuration
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/cokemission/installation) -- Get up and running
- [Configuration](/resources/cokemission/configuration) -- Customize every aspect
