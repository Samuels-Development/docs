# Warehouse Heist <VersionBadge repo="sd-warehouse" fallback="1.5.0" />

**Warehouse Heist** (`sd-warehouse`) is a secured warehouse heist for FiveM. Breach the exterior with thermite, enter the interior, hack the laptop to unlock exits, and loot six crates filled with weapons, drugs, electronics, and valuables. Features optional NPC guards, cinematic explosions, and a two-exit escape system.

## Preview

<YouTubeEmbed id="REmSUwBOr-M" title="Warehouse Heist — Full Showcase" />

## Key Features

### Heist Progression

| Phase | Action | Required Item | Details |
|---|---|---|---|
| **1. Thermite Hack** | Breach exterior locks | `thermite_h` | Hacking minigame + thermite placement animation |
| **2. Enter Warehouse** | Teleport to interior | -- | Screen fade transition to warehouse interior |
| **3. Laptop Hack** | Unlock exits | -- | Secondary hacking minigame (configurable) |
| **4. Loot Crates** | Collect from 6 crates | -- | Each crate has unique loot table |
| **5. Escape** | Leave via 2 exits | -- | Teleport back to exterior |

### Six Loot Crates

Each crate contains 4-6 randomized items from its own loot table:

| Crate | Category | Contents |
|---|---|---|
| **1** | Valuables | Gold bars, 10k gold chains, Rolex watches, Trojan USBs |
| **2** | Weapons Cache 1 | SMGs, Micro SMGs, Pistol .50, Heavy Armor, Smoke Grenades |
| **3** | Mixed | Gold bars, 10k gold chains, Rolex watches, Nitrous |
| **4** | Electronics | Laptops, Tablets, Samsung Phones, Crypto Sticks |
| **5** | Weapons Cache 2 | SMGs, Micro SMGs, Pistol .50, Heavy Armor |
| **6** | Narcotics | Coke bricks, XTC bags, Weed bricks |

### NPC Guards

- **3 guards** spawn inside the warehouse (disabled by default)
- Marine ped models with **200 HP** and randomized weapons
- Lootable on death with weighted reward categories:

| Category | Chance | Examples |
|---|---|---|
| Pistols | 37% | Heavy Pistol, Pistol, Pistol Mk2 |
| Rare Weapons | 15% | Assault Rifle, Compact Rifle, MG |
| SMGs | 32% | Assault SMG, Mini SMG, Combat PDW |
| Shotguns | 25% | Sawn-off, Pump, Double Barrel |
| Ammo | 45% | Various ammo types |
| Medical | 45% | Bandages, Revive Kits |

### Interior Environment

- Teleport-based interior with dedicated warehouse space
- **6 loot crate** spawn locations
- **24 random filler object** placements for visual variety (7 model types)
- Two separate exit points for tactical escapes

### Hacking Minigames

Supports **21+ configurable minigame resources** with separate settings for the thermite breach and the laptop hack. Includes hacking-opengame (default), ps-circle, ps-thermite, sn-skillcheck, rm-safecrack, and many more.

### Additional Features

- **Configurable police requirement** (default: 0)
- **Global cooldown** (default: 60 minutes)
- **Cinematic explosion** at the entry point (configurable type)
- **Police dispatch** alert (code 10-31W)
- **Map blip** for the warehouse location
- **Target or TextUI** interaction modes

## File Structure

```
sd-warehouse/
  client/
    main.lua              -- Client-side heist logic, interior, crates
  server/
    main.lua              -- Server-side state, loot, cooldowns
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  images/
    thermite_h.png
  stream/
    _manifest.ymf
    ex_exec_warehouse_placement_interior_2_int_warehouse_2_l_dlc_milo_.ymap
  [SQL]/ESX/items.sql     -- ESX item definitions
  config.lua              -- All configuration
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/warehouse/installation) -- Get up and running
- [Configuration](/resources/warehouse/configuration) -- Customize every aspect
