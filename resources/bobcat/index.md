# Bobcat Security Heist <VersionBadge repo="sd-bobcat" fallback="1.5.71" />

**Version:** 1.5.71 | **Author:** Samuel#0008 | **Locales:** English, German, Spanish, French, Arabic

A fully-featured Bobcat Security weapons depot heist for FiveM. Breach three progressively secure doors, hack security systems, eliminate guards, loot weapon caches, and detonate C4 to access the vault. Supports three MLO variants: Gabz, NoPixel/Tobii, and K4MB1.

## Preview

<YouTubeEmbed id="F6EW7fwMvqc" title="Bobcat Security Heist — Full Showcase" />

## Key Features

### Multi-Stage Heist Progression

The heist unfolds through four sequential stages, each requiring specific items and skill checks:

| Stage | Method | Required Item | Action |
|---|---|---|---|
| **First Door** | Thermite | `thermite_h` | Burn through the first security door |
| **Second Door** | Thermite | `thermite_h` | Breach the second door, spawns guards and triggers police alert |
| **Third Door** | Keycard | `bobcatkeycard` | Swipe a Bobcat Security Card (optional hacking) |
| **Vault** | C4 Bomb | `c4_bomb` | Set a timed detonation (1-90 seconds) to blow the vault door |

### Weapon Crate Loot

Four separate weapon caches inside the vault:

| Crate | Contents | Amount |
|---|---|---|
| **SMGs** | SMG, Micro SMG, Machine Pistol, Mini SMG, Pistol .50 | 5-8 weapons |
| **Rifles** | Assault Rifle, Compact Rifle, MG, Pump Shotgun | 3-6 weapons |
| **Explosives** | Grenades, Molotovs, Sticky Bombs | 2-4 items |
| **Ammo** | MG, Shotgun, SMG, Rifle, Pistol ammo | 6-8 items |

### NPC Guard System

- **6 guards** spawn at heist-specific locations when the second door is breached
- Guards have **200 HP**, randomized armor (50-100), and combat-ready AI
- Armed with pistols, SMGs, or assault rifles (randomized)
- Lootable on death with weighted reward categories:

| Category | Chance | Examples |
|---|---|---|
| Pistols | 37% | Heavy Pistol, Pistol, Pistol Mk2 |
| Rare Weapons | 15% | Assault Rifle, Compact Rifle, MG |
| SMGs | 32% | Assault SMG, Mini SMG, Combat PDW |
| Shotguns | 25% | Sawn-off, Pump, Double Barrel |
| Ammo | 45% | Various ammo types (1-2 per drop) |
| Medical | 45% | Bandages, Revive Kits (1-2 per drop) |

### Three MLO Map Variants

Select your map in the config and all coordinates, doorlocks, and guard spawns adjust automatically:

| MLO | Creator |
|---|---|
| **Gabz** | Gabz Development |
| **NoPixel / Tobii** | NoPixel / Tobii |
| **K4MB1** | K4MB1 |

### Hacking Minigames

Supports **20+ configurable minigame resources**, including ps-circle, ps-thermite, hacking-opengame, sn-skillcheck, rm-safecrack, and many more. Each door/vault stage can use a different minigame with independent difficulty settings.

### Doorlock Integration

Includes ready-made configs for three doorlock systems:

- **ox_doorlock** (SQL inserts provided)
- **qb-nui_doorlock** (Lua config provided)
- **cd_doorlock** (JSON config provided)

### Additional Features

- **Minimum police requirement** before the heist can start (default: 3)
- **Global cooldown** between heists (default: 60 minutes)
- **Alarm system** with configurable audio
- **Police dispatch** integration (code 10-31B)
- **Map blip** for the Bobcat location
- **Target or TextUI** interaction modes
- **Item removal** configurable on success/failure per item
- **Cinematic explosion** sequence for the vault breach

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
| **Target System** | `ox_target` / `qb-target` / `qtarget` / TextUI fallback |
| **Doorlock** | `ox_doorlock` / `qb-nui_doorlock` / `cd_doorlock` |
| **Minigame** | Any one of 20+ supported minigame resources |

::: info
Framework, inventory, and target system are all auto-detected via sd_lib.
:::

## File Structure

```
sd-bobcat/
  client/
    main.lua              -- Client-side heist logic, animations, UI
  server/
    main.lua              -- Server-side state, cooldowns, loot distribution
  doorlock/
    cd_doorlock/
      gabz_bobcat.json
      k4mb1_bobcat.json
      nopixel_bobcat.json
    ox_doorlock/
      gabz_doorlock.sql
      k4mb1_doorlock.sql
      nopixel_doorlock.sql
    qb-nui_doorlock/
      gabz_bobcat.lua
      k4mb1_bobcat.lua
      nopixel_bobcat.lua
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  images/
    bobcatkeycard.png
    c4_bomb.png
    thermite_h.png
  [SQL]/ESX/items.sql     -- ESX item definitions
  config.lua              -- All configuration
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/bobcat/installation) -- Get up and running
- [Configuration](/resources/bobcat/configuration) -- Customize every aspect
