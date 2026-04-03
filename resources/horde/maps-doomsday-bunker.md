# Map: Doomsday Bunker

A covert government black site buried deep underground. This sprawling complex houses classified operations, weapons research, and intelligence archives. Uses the Doomsday Heist Facility interior.

## Overview

| Detail | Value |
|---|---|
| **Map ID** | `doomsday_bunker` |
| **Icon** | `fa-building-shield` |
| **Location** | Doomsday Heist Facility interior (Interior ID: 269313) |
| **Required Level** | 5 (default) |
| **Difficulties** | Easy, Normal, Hard, Nightmare |
| **End Game Rounds** | 3, 5, 7, 10, 15 |
| **Uses IPLs** | Yes |

## IPLs and Interior

This map loads the Doomsday Heist Facility interior via IPL:

```
xm_x17dlc_int_placement_interior_33_x17dlc_int_02_milo_
```

Interior props are configured at `vector3(345.0, 4842.0, -60.0)` with the following prop sets enabled:

- `set_int_02_decal_01` (decal style)
- `set_int_02_lounge1` (lounge furniture)
- `set_int_02_security` (security room)
- `set_int_02_sleep` (sleeping quarters)
- `set_int_02_cannon` (orbital cannon area)
- `set_int_02_clutter1` (clutter/details)

The interior uses prop color scheme 2 (expertise).

### Frozen Doors

Two doors are frozen to prevent players from opening them:

| Coordinates | Model Hash |
|---|---|
| `vector4(336.51, 4832.96, -60.00, 125.00)` | `1877137660` |
| `vector4(335.10, 4834.98, -60.00, 305.00)` | `1877137660` |

## Entry and Exit

| Point | Coordinates |
|---|---|
| **Entry Location** | `vector4(-263.65, 4729.01, 138.67, 129.29)` |
| **Leave Location** | `vec4(-262.79, 4729.86, 138.35, 318.08)` |
| **Spawn Point** (inside) | `vector4(336.50, 4834.40, -59.00, 305.23)` |
| **End Loot Crate** | `vector4(-259.40, 4729.72, 135.78, 230.79)` |

The entry blip uses sprite 590, color 1, scale 0.8 with label "Facility Entry".

## Map Layout

The Doomsday Bunker uses a multi-level facility interior with corridors, security rooms, a lounge area, and an orbital cannon room. Zone thickness is 20.0 units.

Key locations inside the map:

- **Terminal (Shop)** -- `vector3(344.58, 4845.64, -59.54)` with a spawned laptop prop at heading 300.98
- **Deposit Crate** -- `vector3(346.44, 4842.69, -60.00)` using model `tr_prop_tr_mil_crate_02`
- **Mystery Box** -- `vector3(349.24, 4842.04, -60.0)` with heading 63.58

## Mystery Box

| Setting | Value |
|---|---|
| **Cost** | 950 points |
| **Enabled** | Yes |
| **Box Models** | `xm3_prop_xm3_crate_01a` (closed) / `xm3_prop_xm3_crate_01b` (open) |
| **Cycle Duration** | 8000ms |
| **Particles** | Enabled |
| **Lights** | Enabled (non-pulsating) |

Standard 29-weapon pool from common pistols to epic heavy weapons.

## Difficulty: Easy

| Setting | Value |
|---|---|
| **Max Rounds** | 5 |
| **Kill Points** | 30 - 80 per kill |
| **Required Level** | 5 |

::: info
The Doomsday Bunker's Easy difficulty does not explicitly define `enemiesPerRound` or `lootPerRound` in the source code, which means these values are determined by the game's default scaling logic.
:::

**Boss Fights:**

| Round | Boss | Health | Armor | Weapon | Reward |
|---|---|---|---|---|---|
| 3 | FACILITY WARDEN (Head of Security) | 800 | 100 | Combat Pistol | 500 |
| 5 | AGENT MASON (Classified Operative) | 1,200 | 150 | SMG | 750 |

## Loot Objects

Same loot object pool as other maps with values from 100 to 1,000. The map has **18 loot spawn locations** distributed throughout the facility rooms and corridors.

## Enemy Spawns

The map has **27 enemy spawn locations** spread across the facility's multiple levels and rooms. Spawn mode is `"minDistance"` (different from other maps) with a minimum spawn distance of **20.0** units.

::: tip
The Doomsday Bunker uses `"minDistance"` spawn mode instead of `"furthest"`, meaning enemies spawn randomly as long as they are at least 20 units from any player. This creates less predictable enemy approach patterns compared to other maps.
:::

## End Game Loot

Each difficulty has its own end game loot table with the same four rarity tiers as other maps. Easy difficulty has slightly higher prices (+5-10%) and lower chances for rare/epic items (-20-25%) compared to the map-level defaults.

::: warning
The Doomsday Bunker requires level 5 and uses the Doomsday Heist Facility IPL. If the IPL fails to load, the interior will not render correctly. Check server console for IPL loading messages on startup.
:::
