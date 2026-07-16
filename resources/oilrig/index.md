# Oil Rig Heist <VersionBadge repo="sd-oilrig" fallback="1.3.61" />

**Oil Rig Heist** (`sd-oilrig`) is a multi-stage offshore heist for FiveM. Breach security, deactivate pressure regulators, hack encrypted terminals to decode a 4-letter password, and escape with oil barrels to sell across the map. Features NPC guards, a real-time pressure system, and support for both K4MB1 and NoPixel oil rig MLOs.

## Preview

<YouTubeEmbed id="nbP03IP3Opk" title="Oil Rig Heist — Full Showcase" />

::: info
Previews aren't regularly updated, so you'll probably receive a more polished version than viewable.
:::

## Key Features

### Heist Stages

| Stage | Action | Details |
|---|---|---|
| **1. Enter Zone** | Approach the oil rig | Requires minimum police on duty and triggers the cooldown |
| **2. Override Security** | Insert Pink USB Dongle | Starts the security system override and begins the robbery |
| **3. Deactivate Regulators** | Pull 3 levers in correct sequence | Deactivates the automatic pressure regulation system |
| **4. Regulate Pressure** | Adjust valves to ~55% | Use increase/lower pressure valves; pressure above 80 explodes the rig |
| **5. Hack Laptops** | Hack 4 laptop terminals | Requires Pink Laptop item; each hack reveals a letter of the password |
| **6. Enter Password** | Input the 4-letter password | Determined from letters revealed during laptop hacking |
| **7. Collect Barrels** | Pick up oil barrels | 7 barrels (K4MB1) or 8 barrels (NoPixel) scattered around the rig |
| **8. Sell Barrels** | Sell at gas stations | 9 gas station locations with randomized prices across the map |

### Pressure Management

- Pressure must be regulated to **~55%** after pulling the levers
- If pressure exceeds the threshold (**80 by default**), the oil rig **explodes**
- If pressure drops too low, the rig **seizes up**
- Two valve interaction points — increase or lower pressure to find the sweet spot

### Dual MLO Support

Two popular oil rig MLOs are supported out of the box. Switch between them with a single config line:

| MLO | Config Value | Notes |
|---|---|---|
| **K4MB1's Oil Rig** | `'k4mb1'` | Default. Pre-configured coordinates included |
| **NoPixel's Oil Rig** | `'nopixel'` | Pre-configured coordinates included |

### Password Puzzle

- A random 4-letter word is selected each robbery from a configurable list (default: 10 options)
- Each laptop hack reveals one letter of the word
- **2 password attempts** before lockout (configurable)
- Letters can be reviewed again after hacking if `Config.ViewLetters = true`

### NPC Guards

- Guards spawn on heist start (when USB is inserted)
- `s_m_y_marine_01` model with **200 HP** by default
- Randomized weapons: pistols, SMGs, assault rifles
- Lootable with a weighted reward system

| Category | Chance | Examples |
|---|---|---|
| Pistols | 37% | Heavy Pistol, Pistol, Pistol Mk2 |
| Rare Weapons | 15% | Assault Rifle, Compact Rifle, MG |
| SMGs | 32% | Assault SMG, Mini SMG, Combat PDW |
| Shotguns | 25% | Sawn-off, Pump, Double Barrel |
| Ammo | 45% | Various ammo types |
| Medical | 45% | Bandages, Revive Kits |

### Oil Barrel Selling

- Players pick up oil barrels from the rig and carry them off
- **9 gas station sell points** around the map, each with a randomized price
- Prices range from **$9,000 – $12,299** depending on the station

### Additional Features

- **Minimum 3 police** required to start (configurable)
- **3-hour cooldown** between heists (configurable)
- **Police dispatch** alert on entry or on USB insertion (configurable)
- **Map blip** showing the rig location
- **Beach washup** cinematic ending after heist completion
- **Revive kit** support for downed teammates
- **20+ hacking minigame** options for laptop terminals
- **Hint system** for guided gameplay (configurable)
- **Spawn protection** — players who log in on the rig are sent to the beach
- **Reset on leave** option to prevent griefing the cooldown

## File Structure

```
sd-oilrig/
  client/
    main.lua              -- Client-side heist logic, zones, pressure, guards
  server/
    main.lua              -- Server-side state, loot, cooldowns, barrels
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  images/
    laptop_pink.png
    oilbarrel.png
    revivekit.png
    security_card_oil.png
    token.png
  [SQL]/ESX/items.sql     -- ESX item definitions
  config.lua              -- All configuration
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/oilrig/installation) — Get up and running
- [Configuration](/resources/oilrig/configuration) — Customize every aspect
