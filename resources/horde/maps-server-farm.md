# Map: Server Farm

A hidden underground server farm housing classified data. Narrow corridors lined with server racks and heavy security make this a high-risk infiltration.

## Overview

| Detail | Value |
|---|---|
| **Map ID** | `server_farm` |
| **Icon** | `fa-server` |
| **Location** | Underground data center (instanced interior) |
| **Required Level** | 1 (default) |
| **Difficulties** | Easy, Normal, Hard, Nightmare |
| **End Game Rounds** | 3, 5, 7, 10 |

## Entry and Exit

| Point | Coordinates |
|---|---|
| **Entry Location** | `vector4(3.93, -200.44, 52.89, 344.66)` |
| **Leave Location** | `vec4(3.56, -201.21, 52.74, 159.47)` |
| **Spawn Point** (inside) | `vec4(2155.38, 2921.12, -81.08, 269.83)` |
| **End Loot Crate** | `vector4(-0.11, -201.83, 51.74, 130.77)` |

The entry blip uses sprite 310, color 1, scale 0.8.

## Map Layout

The Server Farm is set in a large underground facility with interconnected rooms and corridors. The play zone is defined by a polygon zone covering a wide area underground.

Key locations inside the map:

- **Terminal (Shop)** -- `vector3(2185.78, 2928.72, -84.96)` (no spawned object, uses existing props)
- **Deposit Crate** -- `vector3(2183.47, 2925.16, -85.80)` using model `tr_prop_tr_mil_crate_02`
- **Mystery Box** -- `vector3(2185.22, 2919.94, -85.8)` with heading 269.95

## Mystery Box

| Setting | Value |
|---|---|
| **Cost** | 950 points |
| **Enabled** | Yes |
| **Box Models** | `xm3_prop_xm3_crate_01a` (closed) / `xm3_prop_xm3_crate_01b` (open) |
| **Cycle Duration** | 8000ms |
| **Particles** | Enabled |
| **Lights** | Enabled (non-pulsating) |

The weapon pool ranges from common pistols (chance 100) to epic weapons like the RPG (chance 2) and Minigun (chance 1), with 29 weapons total across all rarity tiers.

## Difficulty: Easy

| Setting | Value |
|---|---|
| **Max Rounds** | 5 |
| **Kill Points** | 25 - 75 per kill |
| **Required Level** | 1 |

**Enemies per round:** 6, 10, 14, 18, 22

**Loot per round:** 3, 4, 5, 6, 7

**Enemy Configuration:**

| Property | Value |
|---|---|
| Models | `s_m_m_security_01`, `s_m_y_doorman_01` |
| Weapons | Pistol, Combat Pistol |
| Health | 120 - 180 |
| Armor | 0 - 25 |
| Accuracy | 25 |
| Combat Ability | Poor (0) |
| Can Ragdoll | Yes |

**Boss Fights:**

| Round | Boss | Health | Armor | Weapon | Reward |
|---|---|---|---|---|---|
| 3 | CHIEF SECURITY (Facility Guardian) | 1,500 | 100 | SMG | 500 |
| 5 | SYSADMIN BRUTE (Server Protector) | 2,500 | 150 | Assault Rifle | 1,000 |

::: info
All bosses on this map have `canRagdoll = false` and `canHeadshot = false`, meaning they cannot be staggered or instantly killed by headshots.
:::

## Loot Objects

Loot crates spawn during the looting phase with values ranging from 100 to 1,000 points:

| Category | Models | Value Range |
|---|---|---|
| Small | Ammo boxes, cardboard boxes, cloth crates | 100 - 200 |
| Medium | Gun cases, heist boxes, wooden crates | 250 - 500 |
| Large | Military crates, smuggling crates | 600 - 1,000 |

The map has **45+ loot spawn locations** spread throughout the facility.

## Enemy Spawns

The map has **25 enemy spawn locations** distributed across the facility. Spawn mode is set to `"furthest"` with a minimum spawn distance of 15.0 units from players.

## End Game Loot

Each difficulty tier has its own end game loot table. Loot spans four rarity tiers:

- **Common** (chance 60-100): Silver jewelry, cash bundles, heist tools
- **Uncommon** (chance 30-55): Gold jewelry, robbery cases, crypto sticks
- **Rare** (chance 10-28): Gold bars, diamonds, premium cases
- **Epic** (chance 2-8): Diamond necklaces, presidential watches, bank heist cases

::: tip
The Server Farm is the entry-level map with a default level requirement of 1. It is the most accessible map for new players learning the horde mechanics.
:::
