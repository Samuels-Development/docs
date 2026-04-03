# Dumpster Diving <VersionBadge repo="sd-dumpsters" fallback="1.3.3" />

**Dumpster Diving** (`sd-dumpsters`) is a scavenging and survival-economy script for FiveM. Search dumpsters and trash bins for loot, encounter random events like needle pricks and hobo attacks, trade with the Hobo King, raise a rat companion, recycle scrap into useful materials, and progress through a leveling system with milestones, daily objectives, and a global leaderboard.

## Preview

<YouTubeEmbed id="jGxDbp9kWp0" title="Advanced Dumpster Diving — Full Showcase" />

## Key Features

### Dumpster and Trash Bin Looting

- Loot from **large dumpsters/skips** and **small trash bins** using GTA V world props
- **Level-scaled loot tables** (levels 1-5) with increasing item variety and quantities
- Configurable **global or per-player cooldowns** (default 10 minutes)
- Choose between **stash-based** or **direct inventory** loot delivery
- **Locked dumpsters** that require a power saw (`powersaw` item) to open
- **Trash bag** looting from loose bin bags scattered around the map
- **Hobo camp** searching from tent props with their own loot tables and cooldowns
- **Custom zone overrides** with polygon-based areas for specialized loot tables

### Chance-Based Events

Random events can trigger while looting, adding risk to every search:

| Event | Description |
|---|---|
| **Needle Prick** | Causes a drunk/drug effect for a configurable duration (default 120s) with its own cooldown (default 600s) |
| **Hobo Attack** | A hostile NPC spawns with a configurable weapon and attacks the player |

The chance of these events is **per-level** -- higher player levels reduce the probability of both needle pricks and hobo attacks.

### Hobo King NPC

A merchant NPC who spawns at a random location from a configurable list each script start:

- **Shop system** for buying and selling scavenged goods
- Accepts **bottle caps** or **cash** as currency (configurable via `Config.Payout`)
- **Buy and sell** item lists defined separately in `Config.Shop`
- **Sell All** option to sell all eligible items at once
- **Advice system** with escalating responses when pestered
- **Statistics viewer** to see personal scavenging stats
- **Milestone tracker** to view and redeem milestone rewards
- **Global leaderboard** showing top players by score
- **Daily objectives and challenges** accessible through the King's menu

### Leveling System

Players progress through **5 levels** that affect every aspect of scavenging:

| Attribute | Improves With Level |
|---|---|
| Search duration | Gets shorter |
| Lock chance | Decreases |
| Saw duration | Gets shorter |
| Bag/dumpster/camp loot chance | Increases |
| Needle prick chance | Decreases |
| Hobo attack chance | Decreases |

### Rat Companion System

Purchase and raise a loyal rat companion that assists with scavenging:

- Purchase a rat from the Hobo King (default **$1,000** or 1,000 caps depending on payout mode)
- Optional **level restriction** for purchasing (configurable, default requires level 2)
- **5 rat levels** of progression with XP-based thresholds (100, 300, 600, 1000, 1500 XP)
- Send your rat on **10 expeditions** across the city with varying risk and reward
- Risk-based **injury system** with a configurable recovery timer (default 600 seconds)
- **2 perk points** earned per rat level to customize abilities
- **Call/follow system** via export, event, or `/CallRat` command

| Perk | Effect |
|---|---|
| **Fleet Footed** | Reduces expedition duration (percentage-based) |
| **Scavenger Supreme** | Increases loot quantity (static bonus added to each item) |
| **Lucky Whiskers** | Increases rare item drop chance (additive percentage) |
| **Safety Paws** | Reduces expedition injury risk (additive percentage) |
| **Quick Recovery** | Reduces injury recovery time (percentage-based) |

### Recycler System

Convert scavenged junk into useful materials at recycler stations:

- **Multiple recycler locations** with individual interaction settings
- Three interaction modes per location: **ped target**, **prop target**, or **box zone**
- **19 recyclable items** with individual conversion recipes
- Two processing time modes: **per-item time** or **flat base time**
- **Shared or per-player** recycler state (configurable)
- Item quantity cap per recycler (configurable, default 50)
- Prop swapping when recycler is active (optional)

### Daily System

- **Daily Objectives**: Personal tasks assigned per player per server cycle (default 5 per player)
- **Daily Challenges**: Server-wide competitive challenges (default 3 per cycle)
- Reward types: items, XP, or money

### Milestones

- Track cumulative stats like dumpsters searched, hobos looted, camps searched, bags looted, and specific item counts
- Multi-stage milestones with escalating rewards (items, XP, or money)

### Stash System

- Dumpsters and trash cans can have **openable stashes** (requires `ox_inventory`)
- Separate from the loot-to-stash mode -- this adds a "Open Dumpster" / "Open Trash Can" target option

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
| `codem-inventory` | Supported |
| `tgiann-inventory` | Supported |
| `jaksam_inventory` | Supported |
| `qs-inventory-pro` | Supported |
| `origen_inventory` | Supported |

## Supported Target Systems

| Target | Status |
|---|---|
| `ox_target` | Fully supported |
| `qb-target` | Fully supported |
| `qtarget` | Fully supported |
| Built-in TextUI | Fallback (auto-detected when no target resource is found) |

## Dependencies

| Dependency | Options |
|---|---|
| **Framework** | `qb-core` or `es_extended` |
| **Library** | `ox_lib` |
| **Database** | `oxmysql` |
| **Target System** | `ox_target` / `qb-target` / `qtarget` (or built-in TextUI fallback) |
| **Inventory** | Any of the 6 supported inventories listed above (or framework default) |

::: info
The framework is auto-detected at startup. Target and inventory systems are also auto-detected from running resources. If no target resource is found, the script falls back to a built-in TextUI interaction system.
:::

### Optional Integrations

| Integration | Purpose |
|---|---|
| **ox_inventory** | Required for stash mode and loot-to-stash mode |
| **lation_ui** | Alternative notification and progress bar provider |
| **cd_drawtextui** | Alternative TextUI provider |
| **Minigame scripts** | ps-ui, memorygame, ran-minigames, hacking, howdy-hackminigame, SN-Hacking, rm_minigames, bl_ui, glitch-minigames |

## File Structure

```
sd-dumpsters/
  bridge/
    init.lua              -- Framework detection
    shared.lua            -- Locale system, shared utilities
    client.lua            -- Client bridge (notifications, target, interaction)
    server.lua            -- Server bridge (money, inventory, player data)
  client/
    main.lua              -- Client-side looting, events, leveling
    rats.lua              -- Rat companion client logic
    recyclers.lua         -- Recycler station client logic
  server/
    logs.lua              -- Logging configuration
    main.lua              -- Server-side loot tables, XP, milestones
    rats.lua              -- Rat companion server logic
    recyclers.lua         -- Recycler station server logic
  configs/
    config.lua            -- Main configuration
    rats.lua              -- Rat companion configuration
    recycler.lua          -- Recycler station configuration
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  images/
    bottle_cap.png
    powersaw.png
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/dumpsters/installation) -- Get up and running
- [Configuration](/resources/dumpsters/configuration) -- Customize every aspect
- [Rat Companions](/resources/dumpsters/rat-companions) -- Deep dive into the rat system
- [Recycler](/resources/dumpsters/recycler) -- Recycler locations and items
