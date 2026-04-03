# Yacht Heist <VersionBadge repo="sd-yacht" fallback="1.1.1" />

**Yacht Heist** (`sd-yacht`) is a sophisticated multi-stage yacht heist for FiveM. Override security systems, manage engine pressure, solve symbol puzzles, hack laptops, crack the final password, and access the vault for the ultimate briefcase. Features 10 NPC guards, lootable valuables, cabin searching, cash trays, and a cinematic beach washup ending.

## Preview

<YouTubeEmbed id="Us2NdVBUd60" title="Yacht Heist — Full Showcase" />

## Key Features

### Puzzle-Based Heist Stages

| Stage | Action | Details |
|---|---|---|
| **1. Enter Codes** | Input yacht access codes at the terminal | Requires `yachtcodes` item |
| **2. Screen Sequence** | Tap 3 bridge screens in the correct randomized order | Each screen requires a terminal hacking minigame |
| **3. Pressure Management** | Regulate engine pressure via two valves | Prevent explosion (threshold: 15 psi) |
| **4. Laptop Hacking** | Hack 4 scattered laptops | Requires `default_gateway_override` USB item |
| **5. Password Puzzle** | Determine and enter the final vault password | Letters revealed during laptop hacking |
| **6. Vault Access** | Enter the vault and retrieve the briefcase | Awards `casinocodes` and other final items |

### Pressure Management

- Starting pressure: **100 psi**
- Auto-decreases at **1 psi every 5 seconds**
- Two valve locations with increase/decrease controls
- **Explosion** if pressure drops below threshold (default: 15 psi)
- Optional: disable explosion for yacht seizure instead

### Lootable Items

**Scattered Valuables (8 locations):**
- Expensive Champagne x4
- Rolex Watches x2
- Secured Safe (special carry animation)

**5 Searchable Cabins:**
- Rolex watches, gold chains, gold bars, tablets

**3 Cash Tray Locations:**
- $5,000-$10,000 per tray with animated pickup

### NPC Guards

- **10 guards** spawn on yacht entry
- `mp_m_bogdangoon` model with **200 HP**
- Randomized weapons: pistols, SMGs, assault rifles
- Lootable with weighted reward system:

| Category | Chance | Examples |
|---|---|---|
| Pistols | 37% | Heavy Pistol, Pistol, Pistol Mk2 |
| Rare Weapons | 15% | Assault Rifle, Compact Rifle, MG |
| SMGs | 32% | Assault SMG, Mini SMG, Combat PDW |
| Shotguns | 25% | Sawn-off, Pump, Double Barrel |
| Ammo | 45% | Various ammo types |
| Medical | 45% | Bandages, Revive Kits |

### Password Puzzle

- **4 possible words**: DRUM, GLOW, LEAF, GRIM (randomly selected)
- Letters are revealed on screens during laptop hacking
- **2 password attempts** before lockout (configurable)
- Case-sensitive input

### Forced Item Animations

When `Config.ForceAnimation = true`:
- **Safe**: Carried on the player's back
- **Yacht Codes / Casino Codes**: Held like a cellphone

### Cash Payout Modes

| Mode | Description |
|---|---|
| **Clean** | Unmarked cash to bank |
| **Dirty** | Marked bills (QB) or black_money (ESX) |
| **Custom** | Any custom item as currency |

### Additional Features

- **Minimum 4 police** required to start (configurable)
- **3-hour cooldown** between heists (configurable)
- **Police dispatch** alert on yacht entry
- **Map blip** with optional radius indicator
- **Beach washup** cinematic ending after heist completion
- **Revive kit** support for downed teammates
- **20+ hacking minigame** options per stage
- **Yacht code randomization** or fixed codes
- **Hint system** for guidance throughout the heist

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
| **UI Library** | `ox_lib` |
| **Target System** | `ox_target` / `qb-target` / `qtarget` / TextUI fallback |
| **Minigame** | Any one of 20+ supported resources |
| **Sound** | `InteractSound` (optional, for SFX) |

::: info
Framework, inventory, and target system are all auto-detected via sd_lib. No custom database tables are created -- all state is managed in memory.
:::

## File Structure

```
sd-yacht/
  client/
    client.lua            -- Client-side heist logic, puzzles, pressure, guards
  server/
    server.lua            -- Server-side state, loot, cooldowns
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  images/
    casinocodes.png
    default_gateway_override.png
    expensive_champagne.png
    revivekit.png
    secured_safe.png
    yachtcodes.png
    screens/              -- 30 puzzle symbol/letter images (JPG)
  stream/
    bkr_prop_clubhouse_blackboard_01a.ydr
    bkr_prop_clubhouse_blackboard_01a+hidr.ytd
    hei_mpheist_yacht.ytyp
    saferoom_yacht.ymap
    screen1.ydr           -- Screen models (screen1-8)
    screen2.ydr
    screen3.ydr
    screen4.ydr
    screen5.ydr
    screen6.ydr
    screen7.ydr
    screen8.ydr
    yacht_screens.ytyp
    yachtheist_manifest.ymf
  [SQL]/ESX/items.sql     -- ESX item definitions
  config.lua              -- All configuration
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/yacht/installation) -- Get up and running
- [Configuration](/resources/yacht/configuration) -- Customize every aspect
