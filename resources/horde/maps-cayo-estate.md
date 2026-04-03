# Map: Cayo Perico Estate

El Rubio's private estate on Cayo Perico. Lush tropical grounds surround this heavily fortified compound. Expect cartel security and elite mercenaries.

## Overview

| Detail | Value |
|---|---|
| **Map ID** | `cayo_estate` |
| **Icon** | `fa-umbrella-beach` |
| **Location** | Cayo Perico island estate grounds |
| **Required Level** | 5 (default) |
| **Difficulties** | Easy, Normal, Hard, Nightmare |
| **End Game Rounds** | 2, 5, 7, 10 |

## Entry and Exit

| Point | Coordinates |
|---|---|
| **Entry Location** | `vector4(4982.56, -5710.94, 20.35, 231.66)` |
| **Leave Location** | `vec4(4981.29, -5709.47, 19.89, 47.24)` |
| **Spawn Point** (inside) | `vector4(4990.21, -5717.31, 19.88, 230.24)` |
| **End Loot Crate** | `vector4(4983.16, -5706.32, 18.89, 180.02)` |

The entry blip uses sprite 310, color 1, scale 0.8 with label "Horde Entry - Cayo Estate".

## Map Layout

The Cayo Estate uses the Cayo Perico island compound area as an outdoor map. The play zone is a large polygon covering the estate grounds, pool area, and surrounding paths. Zone thickness is 40.0 units.

Key locations inside the map:

- **Terminal (Shop)** -- `vector3(4996.31, -5724.72, 19.89)` with a spawned laptop prop (`prop_laptop_01a`) at heading 282.04
- **Deposit Crate** -- `vector3(4996.57, -5721.82, 18.91)` using model `tr_prop_tr_mil_crate_02`
- **Mystery Box** -- `vector3(4996.4, -5733.61, 18.88)` with heading 228.4

## Mystery Box

| Setting | Value |
|---|---|
| **Cost** | 950 points |
| **Enabled** | Yes |
| **Box Models** | `xm3_prop_xm3_crate_01a` (closed) / `xm3_prop_xm3_crate_01b` (open) |
| **Cycle Duration** | 8000ms |
| **Particles** | Enabled |
| **Lights** | Enabled (non-pulsating) |

The weapon pool is identical to the Server Farm, with 29 weapons spanning common through epic rarities.

## Difficulty: Easy

| Setting | Value |
|---|---|
| **Max Rounds** | 5 |
| **Kill Points** | 30 - 80 per kill |
| **Required Level** | 5 |

**Enemies per round:** 8, 12, 16, 20, 25

**Loot per round:** 3, 4, 5, 6, 7

**Enemy Configuration:**

| Property | Value |
|---|---|
| Models | `g_m_y_mexgoon_01`, `g_m_y_mexgoon_02`, `g_m_y_mexgoon_03` |
| Weapons | Pistol, Combat Pistol, Micro SMG |
| Health | 130 - 200 |
| Armor | 10 - 35 |
| Accuracy | 28 |
| Combat Ability | Poor (0) |
| Can Ragdoll | Yes |

**Boss Fights:**

| Round | Boss | Health | Armor | Weapon | Reward |
|---|---|---|---|---|---|
| 4 | CARTEL ENFORCER (El Rubio's Muscle) | 1,500 | 100 | Assault Rifle | 500 |
| 5 | GUSTAVO (Cartel Lieutenant) | 2,500 | 150 | Combat MG | 1,000 |

::: info
All bosses have `canRagdoll = false` and `canHeadshot = false`. Boss combat ability is Professional (2) with Far combat range (2).
:::

## Loot Objects

Same loot object pool as the Server Farm with values from 100 to 1,000. The map has **22 loot spawn locations** spread across the estate grounds.

## Enemy Spawns

The map has **26 enemy spawn locations** distributed throughout the compound -- from the main villa to the beach paths and peripheral areas. Spawn mode is `"furthest"` with a minimum spawn distance of 15.0 units.

## End Game Loot

Each difficulty has its own loot table. The map also defines a map-level loot table as fallback. Loot categories:

- **Common** (chance 60-100): Silver jewelry, lockpicks, thermite, cash bundles
- **Uncommon** (chance 30-55): Gold jewelry, heist cases, crypto sticks, drills
- **Rare** (chance 10-28): Gold bars, diamonds, premium robbery cases
- **Epic** (chance 2-8): Diamond necklaces, presidential watches, casino heist cases

::: tip
The Cayo Estate is an outdoor map with open sightlines. Long-range weapons like rifles and marksman rifles are more effective here than in the enclosed Server Farm. Use the estate buildings for cover during heavy waves.
:::

::: warning
The Cayo Estate requires level 5 to access. New players must level up on the Server Farm first before unlocking this map.
:::
