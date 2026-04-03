# Traphouse Robbery <VersionBadge repo="sd-traphouse" fallback="1.0.7" />

**Version:** 1.0.7 | **Author:** Samuel#0008 | **Locales:** English, German, Spanish, French, Arabic

A Vagos gang traphouse robbery for FiveM. Break into the front door, collect cash, drugs, weapons, and valuables from 22 interactive props scattered throughout the property, crack open a vault, and fight off NPC guards. Features hacking minigames, weighted loot tables, and doorlock integration.

## Preview

<YouTubeEmbed id="YzP5onVjBEg" title="Traphouse Robbery — Full Showcase" />

## Key Features

### Multi-Stage Robbery

| Stage | Method | Required Item | Action |
|---|---|---|---|
| **Front Door** | Hacking | `gang-keychain` | Pick the lock to enter the traphouse |
| **Prop Collection** | Hacking per object | -- | Collect 22 lootable props throughout |
| **Vault** | Safe cracking | `safecracker` | Crack the vault safe for high-value loot |

### 22 Lootable Props

The traphouse is filled with interactive objects, each with its own hacking minigame and loot:

| Category | Props | Example Loot |
|---|---|---|
| **Cash** | Money piles, cash stacks, wrapped money | $400-$3,000 per prop |
| **Drugs** | Coke packages, coke baggies, cutting blocks | 1-6 coke items per prop |
| **Weapons** | Micro SMG, Pistol .50, Baseball Bat | 1 weapon per prop |
| **Valuables** | Rolex watches, gold bars, statue box | 1-5 items per prop |
| **Documents** | Yacht codes | 1 per prop |

### NPC Guards

- **4 guards** spawn at predefined locations
- Randomized Ballas gang ped models
- **300 HP**, armed with pistols or SMGs
- Combat AI with 60% accuracy
- Lootable on death with weighted reward system:

| Category | Chance | Examples |
|---|---|---|
| Pistols | 37% | Heavy Pistol, Pistol, Pistol Mk2 |
| Rare Weapons | 15% | Assault Rifle, Compact Rifle, MG |
| SMGs | 32% | Assault SMG, Mini SMG, Combat PDW |
| Shotguns | 25% | Sawn-off, Pump, Double Barrel |
| Ammo | 45% | Various ammo types |
| Medical | 45% | Bandages, Revive Kits |

### Vault System

- Located inside the traphouse
- Requires `safecracker` item
- Safe cracking animation (5-10 seconds)
- Separate hacking minigame from other objects
- Spawns opened safe model on success

### Model Hiding

The script hides 13 default GTA models in the traphouse area and replaces them with lootable prop variants, creating a seamless looting experience.

### Hacking Minigames

Supports **30+ configurable minigame resources** with separate settings for the front door, objects, and vault. Includes ps-circle, hacking-opengame, lib.skillCheck, bl_ui games, glitch minigames, and many more.

### Additional Features

- **Minimum police requirement** (default: 3)
- **Global cooldown** (default: 60 minutes)
- **Police dispatch** alert on entry (code 10-31H)
- **Doorlock integration** (ox_doorlock SQL + qb-nui_doorlock config)
- **Comprehensive logging** (Discord, Fivemanage, Fivemerr, Loki, Grafana)

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
| **Target System** | `ox_target` / `qb-target` / `qtarget` |
| **Doorlock** | `ox_doorlock` / `qb-nui_doorlock` |
| **Minigame** | Any one of 30+ supported resources |

::: info
Framework, inventory, and target system are all auto-detected via sd_lib. No custom database tables are created -- all state is managed in memory during active robberies.
:::

## File Structure

```
sd-traphouse/
  client/
    main.lua              -- Client-side robbery logic, props, guards
  server/
    logs.lua              -- Logging configuration
    main.lua              -- Server-side state, loot, cooldowns
  doorlock/
    ox_doorlock/
      traphouse.sql       -- SQL insert for front door
    qb-nui_doorlock/
      traphouse.lua       -- Door config for qb-nui_doorlock
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  images/
    gang-keychain.png
    safecracker.png
  [SQL]/ESX/items.sql     -- ESX item definitions
  config.lua              -- All configuration
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/traphouse/installation) -- Get up and running
- [Configuration](/resources/traphouse/configuration) -- Customize every aspect
