# Pacific Bank Heist <VersionBadge repo="sd-pacificbank" fallback="1.2.4" />

**Pacific Bank Heist** (`sd-pacificbank`) is a comprehensive Pacific Bank heist for FiveM featuring computer hacking, door consoles, laser grids, thermite breaching, vault bombing, cash tray looting, and deposit box drilling. A multi-phase robbery with full multiplayer synchronization.

## Preview

<YouTubeEmbed id="HqiqszlTTJE" title="Pacific Bank Heist — Full Showcase" />

## Key Features

### Multi-Phase Heist Progression

| Phase | Action | Required Item | Details |
|---|---|---|---|
| **1. Hack Computers** | Hack 4 office computers | `laptop_pink` | Each yields a 3-digit code |
| **2. Enter Password** | Combine codes into a 12-digit master password | -- | 3 attempts before lockout |
| **3. Hack Consoles** | Hack 5 door consoles to unlock security doors | `laptop_gold` | Progressive door unlocking |
| **4. Laser Grid** | Navigate 11 laser grids | -- | Rooms lock if lasers are tripped |
| **5. Thermite Doors** | Breach 2 security doors | `thermite` | Particle effects and animations |
| **6. Vault Bomb** | Place C4 on vault door | `c4_bomb` | Timed detonation (player-set) |
| **7. Loot Trays** | Grab cash and gold trays | -- | 9-10 trays with random gold chance |
| **8. Drill Boxes** | Drill open deposit boxes | `large_drill` | 2-5 drills per box, jewelry loot |

### Cash Tray System

- **9-10 trays** spawn randomly in the vault
- Each tray awards **$20,000-$30,000** (configurable)
- **35% chance** for a gold tray (yields **3-6 gold bars** instead)
- Synchronized grab animations across all players

### Deposit Box Drilling

- **6 deposit boxes** throughout the vault
- Each box can be drilled **2-5 times**
- Drilling minigame with temperature/position/speed mechanics
- Random jewelry rewards per successful drill:

| Item | Chance | Amount |
|---|---|---|
| Diamond | 20% | 2-3 |
| Diamond Ring | 25% | 2-5 |
| 10k Gold Chain | 25% | 3-5 |

### Laser Grid System

- **11 laser grids** protect the vault room
- Activate after the master password is entered
- Tripping lasers locks down rooms and disables panels
- Can be **bypassed during a blackout** (optional qb-weathersync integration)

### NPC Guards

- Up to **10 guards** spawn during the heist cooldown phase
- **200 HP** with randomized armor and weapons
- Lootable with weighted reward system (pistols, rifles, SMGs, shotguns, ammo, medical)

### Cash Payout Modes

| Mode | Description |
|---|---|
| **Clean** | Unmarked cash added to player's bank |
| **Dirty** | Marked bills (QB) or black_money account (ESX) |
| **Custom** | Any custom item as currency |

### Hacking Minigames

Supports **20+ minigame resources** with independent difficulty settings per stage (computers, consoles, thermite, vault).

### Doorlock Integration

Includes pre-made configs for:
- **ox_doorlock** -- 13 doors with SQL inserts
- **qb-nui_doorlock** -- Lua config provided

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
| **Doorlock** | `ox_doorlock` / `qb-doorlock` / `nui_doorlock` |
| **Lasers** | `mka-lasers` (optional, for laser grid) |
| **Minigame** | Any one of 20+ supported resources |

::: info
Framework, inventory, and target system are all auto-detected via sd_lib. No custom database tables are created -- the script uses the framework's existing inventory system.
:::

## File Structure

```
sd-pacificbank/
  client/
    drilling.lua          -- Deposit box drilling minigame
    main.lua              -- Client-side heist logic, computers, doors, vault
    trolley.lua           -- Cash tray looting system
  server/
    logs.lua              -- Logging configuration
    main.lua              -- Server-side state, loot, cooldowns
  doorlock/
    ox_doorlock/
      oxDoorlock.sql      -- SQL inserts for 13 security doors
    qb-nui_doorlock/
      pacificbank.lua     -- Door config for qb-nui_doorlock
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  images/
    c4_bomb.png
    laptop_gold.png
    laptop_pink.png
    large_drill.png
    thermite.png
  [SQL]/ESX/items.sql     -- ESX item definitions
  config.lua              -- All configuration
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/pacificbank/installation) -- Get up and running
- [Configuration](/resources/pacificbank/configuration) -- Customize every aspect
