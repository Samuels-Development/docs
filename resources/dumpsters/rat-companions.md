# Rat Companions

The Rat Companion system is a progression feature in sd-dumpsters. Players can purchase, name, level up, and send their rat on scavenging expeditions across Los Santos for loot, XP, and rare items. Configuration is in `configs/rats.lua`.

## Purchasing a Rat

Rats are purchased from the **Hobo King** NPC. The price is controlled by:

```lua
Config.PriceForRat = 1000 -- Price in caps or cash (depends on Config.Payout)
```

The currency used depends on `Config.Payout` in the main config -- if set to `'caps'`, the player pays 1,000 bottle caps. If set to `'cash'`, the player pays $1,000 in-game money.

### Level Restriction

You can restrict rat purchases to players who have reached a certain scavenging level:

```lua
Config.LevelRestrict = { Enable = true, Level = 2 }
```

When enabled (default), players must be at least **level 2** before they can adopt a rat.

### Naming

When purchasing, a dialog prompts the player to name their rat. The name persists across sessions and is shown in menus and notifications. If the player cancels the naming dialog, the purchase is aborted.

### Releasing a Rat

Players can release their rat through the rat management menu. This action is permanent and cannot be undone. A rat that is on an expedition or injured cannot be released.

## Rat Leveling System

Rats have their own leveling system separate from the player's scavenging level. Rats progress through **5 levels** by earning XP from expeditions.

### XP Thresholds

```lua
Config.RatLevels = {
    { XPThreshold = 100 },   -- Level 1: XP < 100
    { XPThreshold = 300 },   -- Level 2: XP < 300
    { XPThreshold = 600 },   -- Level 3: XP < 600
    { XPThreshold = 1000 },  -- Level 4: XP < 1000
    { XPThreshold = 1500 }   -- Level 5: XP < 1500
}
```

| Level | XP Cap (below this = current level) |
|---|---|
| 1 | 100 |
| 2 | 300 |
| 3 | 600 |
| 4 | 1,000 |
| 5 | 1,500 |

A rat with 0-99 XP is level 1, 100-299 XP is level 2, and so on. Additional levels can be added by extending the table.

### How XP is Earned

- Each expedition has a **base XP reward** (`xpReward`)
- Each loot item rolled also awards **bonus XP** (defined per item in the expedition's loot table)
- XP is awarded on expedition completion regardless of whether the rat is injured -- the rat still returns with loot even when injured

## Injury and Recovery

Rats can be injured during expeditions based on each expedition's **risk** percentage.

```lua
Config.InjuryRecoveryTime = 600 -- Recovery time in seconds (default: 10 minutes)
```

### How Injury Works

- Each expedition defines a `risk` value (e.g., `10` = 10% base chance of injury)
- If injured, the rat enters a recovery period of `Config.InjuryRecoveryTime` seconds
- During recovery:
  - The rat **cannot** be sent on new expeditions
  - Perks **cannot** be upgraded
  - The rat **cannot** be released
- The rat still returns with loot from the expedition that caused the injury

### Recovery Timer

| State | Can Explore | Can Upgrade Perks | Can Release |
|---|---|---|---|
| Healthy | Yes | Yes | Yes |
| On Expedition | No | No | No |
| Injured (Recovering) | No | No | No |

::: tip
The **Quick Recovery** perk reduces recovery time by a percentage. The **Safety Paws** perk reduces the chance of getting injured in the first place.
:::

## Perks

Every rat level grants perk points to customize abilities:

```lua
Config.PerkPointPerLevel = 2 -- Perk points awarded per rat level
```

With 5 levels and 2 points per level, a max-level rat earns **10 total perk points**. Each perk has **3 levels** of investment.

### Available Perks

```lua
Config.RatPerks = {
    fleetFooted = {
        title = "rat.perk_fleet_footed",
        shortDesc = "rat.perk_fleet_footed_desc",
        icon = "fas fa-running",
        levels = {
            { bonus = 10 }, -- 10% expedition speed increase
            { bonus = 20 }, -- 20% expedition speed increase
            { bonus = 30 }  -- 30% expedition speed increase
        }
    },
    scavengerSupreme = {
        title = "rat.perk_scavenger_supreme",
        shortDesc = "rat.perk_scavenger_supreme_desc",
        icon = "fas fa-box-open",
        levels = {
            { bonus = 1 }, -- +1 to each loot item quantity
            { bonus = 2 }, -- +2 to each loot item quantity
            { bonus = 3 }  -- +3 to each loot item quantity
        }
    },
    luckyWhiskers = {
        title = "rat.perk_lucky_whiskers",
        shortDesc = "rat.perk_lucky_whiskers_desc",
        icon = "fas fa-clover",
        levels = {
            { bonus = 3 },  -- +3% to rare item drop chance
            { bonus = 5 },  -- +5% to rare item drop chance
            { bonus = 10 }  -- +10% to rare item drop chance
        }
    },
    safetyPaws = {
        title = "rat.perk_safety_paws",
        shortDesc = "rat.perk_safety_paws_desc",
        icon = "fas fa-shield-alt",
        levels = {
            { bonus = 10 }, -- -10% injury risk
            { bonus = 20 }, -- -20% injury risk
            { bonus = 30 }  -- -30% injury risk
        }
    },
    quickRecovery = {
        title = "rat.perk_quick_recovery",
        shortDesc = "rat.perk_quick_recovery_desc",
        icon = "fas fa-hourglass-half",
        levels = {
            { bonus = 10 }, -- 10% faster recovery
            { bonus = 20 }, -- 20% faster recovery
            { bonus = 30 }  -- 30% faster recovery
        }
    }
}
```

### Perk Details

#### Fleet Footed
- **Effect:** Reduces expedition duration by a percentage
- **Bonus type:** Percentage reduction applied to the expedition's `duration`
- **Levels:** 10% / 20% / 30%

#### Scavenger Supreme
- **Effect:** Increases the quantity of every loot item retrieved from expeditions
- **Bonus type:** Static amount added to each item's `quantity` value
- **Levels:** +1 / +2 / +3
- **Example:** If an expedition gives 2x metalscrap and this perk is level 1, the rat brings back 3x metalscrap instead

#### Lucky Whiskers
- **Effect:** Increases the chance of receiving rare items from expeditions
- **Bonus type:** Additive percentage added to the expedition's `RareItem.Chance`
- **Levels:** +3% / +5% / +10%
- **Example:** If the rare item chance is 10% and this perk is level 1, the effective chance becomes 13%

#### Safety Paws
- **Effect:** Reduces the risk of injury during expeditions
- **Bonus type:** Subtractive percentage removed from the expedition's `risk` value
- **Levels:** -10% / -20% / -30%
- **Example:** If an expedition has 30% risk and this perk is level 2, the effective risk becomes 10%

#### Quick Recovery
- **Effect:** Reduces the injury recovery time
- **Bonus type:** Percentage reduction applied to `Config.InjuryRecoveryTime`
- **Levels:** 10% / 20% / 30%

## Expeditions

Expeditions are timed scavenging missions where the rat ventures out into the city. The script comes with **10 default expeditions** of escalating difficulty.

### Available Expeditions

| Expedition | ID | Min Level | Duration | Risk | Base XP |
|---|---|---|---|---|---|
| Downtown Dash | `downtown` | 1 | 30 min | 10% | 75 |
| Vinewood Venture | `vinewood` | 1 | 45 min | 15% | 125 |
| East Los Santos Expedition | `east_ls` | 1 | 60 min | 20% | 130 |
| West LS Wander | `west_ls` | 1 | 50 min | 25% | 140 |
| Rockford Rich Run | `rich_run` | 1 | 75 min | 30% | 165 |
| South LS Scavenge | `south_ls` | 1 | 90 min | 35% | 200 |
| Little Seoul Loop | `littleseoul` | 2 | 100 min | 40% | 225 |
| La Mesa Mission | `lamesa` | 3 | 120 min | 45% | 250 |
| Del Perro Drive | `delperro` | 4 | 135 min | 50% | 280 |
| Port of Los Santos Probe | `port_ls` | 5 | 150 min | 60% | 300 |

### Expedition Configuration Structure

```lua
Config.RatExpeditions = {
    {
        id = "downtown",
        name = "Downtown Dash",
        xpReward = 75,            -- Base XP for completing this expedition
        duration = 1800,          -- Duration in seconds (30 minutes)
        risk = 10,                -- 10% chance of injury
        minLevel = 1,             -- Minimum rat level required
        Loot = {
            Amount = {min = 2, max = 3}, -- How many items are rolled
            Items = {
                { name = 'metalscrap', quantity = {min = 5, max = 9}, chance = 50, xp = 5 },
                { name = 'plastic', quantity = {min = 4, max = 10}, chance = 30, xp = 10 },
                { name = 'glass', quantity = {min = 4, max = 10}, chance = 20, xp = 15 }
            },
            RareItem = {
                Enable = true,
                Quantity = {min = 1, max = 1},
                Chance = 2,       -- 2% chance of rare drop
                Items = {
                    { name = 'lockpick', quantity = {min = 1, max = 1}, xp = 50 }
                },
            }
        }
    },
    -- ... more expeditions
}
```

### How Expeditions Work

1. **Select an expedition** from the rat companion menu (accessed via Hobo King or the export/command)
2. The rat must meet the **minimum level** requirement for that expedition
3. The rat departs and a **real-time timer** counts down the duration
4. Progress can be checked by reopening the rat menu (shows percentage and time remaining)
5. When the timer completes:
   - **Loot is generated** from the expedition's loot table
   - **XP is awarded** (base reward + per-item XP bonuses)
   - **Injury check** is rolled against the expedition's risk value
6. The player can then **claim or discard** individual items or all items at once

### Expedition Rewards Menu

When an expedition completes, a rewards menu appears allowing the player to:
- **Claim All** -- collect everything
- **Discard All** -- throw everything away
- **Claim/Discard individually** -- manage each item and specify quantities

## Calling Your Rat

The rat companion can follow the player around the world. There are three ways to activate this:

### Command

```lua
Config.RegisterCommandForFollow = true -- Registers the /CallRat command
```

When enabled, players can use `/CallRat` to toggle their rat following them.

### Export

```lua
Config.CreateExportForRatFollow = {
    Enable = true,
}
```

When enabled, other scripts can call:

```lua
exports['sd-dumpsters']:callRat()
```

Or trigger the event:

```lua
TriggerEvent('sd-dumpsters:client:callRat')
```

### Rat Menu Export

```lua
Config.CreateExportForMenu = {
    Enable = true,
    OnlyAllowPurchaseAtKing = false,
}
```

When enabled, other scripts can open the rat management menu:

```lua
exports['sd-dumpsters']:openRatMenu()
```

Or trigger the event:

```lua
TriggerEvent('sd-dumpsters:client:openRatMenu')
```

| Setting | Default | Description |
|---|---|---|
| `Enable` | `true` | Enable the export |
| `OnlyAllowPurchaseAtKing` | `false` | If `false`, players can also purchase a rat through this export. If `true`, only existing rat owners can access the menu remotely -- non-owners get a notification to visit the Hobo King |

::: tip
Use the rat menu export with a radial menu script to let players access their rat companion from anywhere without visiting the Hobo King.
:::

## Rat Behavior

- When following, the rat scampers along beside the player
- If the rat gets too far from the player, it automatically returns home
- The rat displays a "Squeak!" interaction target showing its name
- Toggle follow off to send the rat home
