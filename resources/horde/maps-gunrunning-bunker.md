# Map: Gunrunning Bunker

An underground weapons manufacturing facility. This bunker houses illegal arms operations, research labs, and a full vehicle bay. Uses the Gunrunning DLC Bunker interior.

## Overview

| Detail | Value |
|---|---|
| **Map ID** | `gunrunning_bunker` |
| **Icon** | `fa-warehouse` |
| **Location** | Route 68 Bunker (Gunrunning DLC interior) |
| **Required Level** | 5 (default) |
| **Difficulties** | Easy, Normal, Hard, Nightmare |
| **End Game Rounds** | 3, 5, 7, 10, 15 |

## Entry and Exit

| Point | Coordinates |
|---|---|
| **Entry Location** | `vector4(147.26, 6366.82, 31.90, 303.15)` |
| **Leave Location** | `vec4(146.68, 6366.8, 31.53, 118.82)` |
| **Spawn Point** (inside) | `vector4(895.51, -3245.67, -98.25, 83.84)` |
| **End Loot Crate** | `vector4(143.76, 6369.93, 30.53, 210.28)` |

The entry blip uses sprite 557, color 1, scale 0.8 with label "Bunker Entry". The entry radius is 4.0 (larger than other maps' default of 2.0).

## Map Layout

The Gunrunning Bunker uses the standard Gunrunning DLC bunker interior. All bunkers share the same interior layout. The play zone covers the main production area, storage rooms, and vehicle bay with a zone thickness of 30.0 units.

Key locations inside the map:

- **Terminal (Shop)** -- `vector3(881.38, -3248.51, -98.08)` with a spawned laptop prop at heading 210.09
- **Deposit Crate** -- `vector3(879.07, -3248.20, -99.29)` using model `tr_prop_tr_mil_crate_02`
- **Mystery Box** -- `vector3(881.7, -3237.55, -99.29)` with heading 359.49

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

**Enemies per round:** 8, 12, 16, 20, 24

**Loot per round:** 3, 4, 5, 6, 7

**Enemy Configuration:**

| Property | Value |
|---|---|
| Models | `g_m_m_armboss_01`, `g_m_m_armgoon_01`, `g_m_y_armgoon_02` |
| Weapons | Pistol, Combat Pistol, Micro SMG |
| Health | 130 - 190 |
| Armor | 15 - 40 |
| Accuracy | 30 |
| Combat Ability | Average (1) |
| Can Ragdoll | Yes |

**Boss Fights:**

| Round | Boss | Health | Armor | Weapon | Reward |
|---|---|---|---|---|---|
| 3 | QUARTERMASTER (Arms Dealer) | 1,500 | 100 | Assault Rifle | 500 |
| 5 | HEAVY GUNNER (Bunker Security Chief) | 2,500 | 150 | MG | 1,000 |

::: info
The Gunrunning Bunker Easy enemies have a base combat ability of Average (1), making them slightly more competent than the Server Farm Easy enemies which use Poor (0).
:::

## Loot Objects

Same loot object pool as other maps with values from 100 to 1,000. The map has **18 loot spawn locations** spread throughout the bunker.

## Enemy Spawns

The map has **23+ enemy spawn locations** throughout the bunker facility. Spawn mode is `"furthest"` with a minimum spawn distance of 15.0 units.

## End Game Loot

Each difficulty has its own end game loot table. Easy difficulty features slightly higher prices (+5-10%) and lower drop chances for rare/epic items compared to the map-level defaults.

- **Common** (chance 60-100): Silver jewelry, lockpicks, cash bundles
- **Uncommon** (chance 30-55): Gold jewelry, heist cases, drills
- **Rare** (chance 10-28): Gold bars, diamonds, premium cases
- **Epic** (chance 2-8): Diamond necklaces, bank heist cases, contraband

::: tip
The Gunrunning Bunker is a long, narrow facility. Enemies can approach from both ends of the main corridor. Position your team to cover both directions and use the branching rooms for cover.
:::

::: warning
The Gunrunning Bunker requires level 5 to access. It shares the same level requirement as the Cayo Estate and Doomsday Bunker.
:::
