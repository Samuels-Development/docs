# Horde Mission <VersionBadge repo="sd-horde" fallback="1.1.4" />

**Horde Mission** (`sd-horde`) is a wave-based survival game mode for FiveM. Assemble a group of up to four players, select a map and difficulty, and fight through increasingly difficult rounds of enemies. Earn points from kills, loot crates between rounds, spend currency in the shop, vote on team perks, and cash out your rewards at the end.

## Preview

<YouTubeEmbed id="oBLhs4KyRTE" title="Horde Missions — Full Showcase" />

## Key Features

### Group-Based Gameplay

- Form groups of up to **4 players** (configurable, or set to 0 for unlimited)
- Solo play is fully supported
- Friendly fire can be toggled on or off globally

### Multiple Maps with Difficulty Tiers

Choose from four distinct environments, each with multiple difficulty levels (Easy, Normal, Hard, Nightmare):

| Map | Description |
|---|---|
| [Server Farm](/resources/horde/maps-server-farm) | An underground data center with tight corridors and server rooms |
| [Cayo Estate](/resources/horde/maps-cayo-estate) | El Rubio's tropical compound with open grounds and cartel security |
| [Doomsday Bunker](/resources/horde/maps-doomsday-bunker) | A classified government facility using the Doomsday Heist interior |
| [Gunrunning Bunker](/resources/horde/maps-gunrunning-bunker) | An underground weapons manufacturing facility |

### Wave/Round System

- Enemies spawn in rounds that grow in difficulty
- Each difficulty tier defines its own round count, enemy count per round, and enemy configuration
- Boss fights appear on specific rounds with health bar UI, increased stats, and kill rewards
- Players can vote to end the game early on designated rounds

### Looting Phase

- Between enemy rounds, a **looting phase** spawns collectible crate objects throughout the map
- Players pick up crates and carry them to a **deposit crate** to earn currency
- Loot values range from 100 to 1,000 depending on the crate model
- The looting phase has a configurable duration (default: 240 seconds)

### Perk Voting System

- After the looting phase each round, players **vote on a team perk** from a randomized selection
- Perks apply to all players and can include buffs (damage, speed, healing) and debuffs (increased damage taken, enemy buffs)
- Over 25 configurable perks with a modular effect system
- Perk vote duration is configurable (default: 15 seconds)

### Inventory Management

- Player inventory is **confiscated on entry** and stored safely in the database
- Players receive a configurable **starting loadout** (default: pistol, ammo, bandages, oxy, food, water, radio)
- Original inventory is **returned on exit**, mission completion, or via a manual ped interaction (fallback for crashes)
- Inventory restrictions prevent dropping/giving items during a match (ox_inventory only)

### Revive System

- Downed teammates can be revived through the **in-game shop** for a configurable cost (default: **5,000 points**)
- Players are revived automatically when the mission ends if `ReviveOnExit` is enabled

### Shop System

- Spend points earned from kills at a **terminal** placed in the map
- Shop has three sections: **Items**, **Weapons**, and **Perks**
- Items and weapons are selected from a weighted random pool each time the shop refreshes
- The shop guarantees ammo for any weapons currently in the weapon section
- Items can have limited purchase amounts before becoming sold out
- Shop inventory can be overridden per-map

### Mystery Box

- A COD-style random weapon box placed on each map
- Costs points (default: 950) for a chance at weapons from common pistols to epic heavy weapons
- Features animated weapon cycling with visual effects, lighting, and sound
- Weapon pool is configurable per-map with rarity tiers and ammo amounts

### End Game Loot

- When the game ends (victory, defeat, or early exit), players enter an **end game loot shop**
- Spend remaining points on real inventory items (jewelry, heist tools, cases, contraband)
- Loot tables support per-difficulty and per-map overrides with weighted chance system
- Items span four rarity tiers: common, uncommon, rare, and epic

### Radio Sync

- Integrated with **pma-voice** for radio communication
- Players in a game are automatically assigned a shared radio channel
- Three channel assignment modes: channel pool, random range, or offset-based

### Level and XP System

- **20-level progression system** with configurable XP thresholds per level
- XP earned from kills, round completions, horde completions, and loot deposits

| Action | Default XP |
|---|---|
| Kill an enemy | 10 XP |
| Complete a round | 50 XP |
| Complete all rounds | 200 XP |
| Deposit a loot crate | 5 XP |

### Player Statistics

- Tracks games played, solo/group games, play time, kills, rounds cleared, hordes completed, damage dealt/taken, coins earned/spent, and loot deposited
- Stats viewable from the ped interaction menu
- Individual stat categories can be toggled on or off

### Requirements System

- Maps and individual difficulties can require a **minimum level**, **completed maps**, or **specific inventory items** to access
- Items can optionally be **consumed** on entry (for ticket/key systems)

### Rejoin System

- If a player disconnects, they have a configurable window (default: **5 minutes**) to rejoin the active session
- If the group becomes empty, the game **pauses** and waits for reconnection
- Configurable countdown timer before the game resumes after a rejoin

### txAdmin Restart Integration

- Detects scheduled txAdmin restarts
- **Blocks new games** a configurable time before restart (default: 30 minutes)
- **Ends active games** a configurable time before restart (default: 10 minutes)

### Cooldown System

- After completing a mission, players are put on a configurable cooldown (default: **60 minutes**)
- Cooldown is tracked per player identifier

### Logging System

- Comprehensive logging with support for **Discord**, **Fivemanage**, **Fivemerr**, **Loki**, and **Grafana**
- Over 20 configurable log events covering game lifecycle, player actions, shop purchases, and more
- Discord logs support rich embeds with color coding and inline fields
- All log messages support placeholders for player info, game state, and event-specific data

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
| `origen_inventory` | Supported |
| `qb-inventory` | Supported |
| `codem-inventory` | Supported |

## Supported Target Systems

| Target | Status |
|---|---|
| `ox_target` | Fully supported (via `ox_lib`) |

## Dependencies

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` or `es_extended` |
| **Library** | Yes | `ox_lib` |
| **Database** | Yes | `oxmysql` |
| **Voice** | Optional | `pma-voice` (required for radio sync) |
| **Inventory** | Recommended | `ox_inventory` (required for inventory restrictions) |

::: info
The framework is auto-detected on startup. Target interactions use `ox_target` via `ox_lib`.
:::

## File Structure

```
sd-horde/
  bridge/
    init.lua              -- Framework detection
    shared.lua            -- Locale system, shared utilities
    client.lua            -- Client bridge (notifications, target, interaction)
    server.lua            -- Server bridge (money, inventory, player data)
  client/
    main.lua              -- Client-side game logic, rounds, enemies, looting
    mysterybox.lua        -- Mystery box client logic
    perks.lua             -- Perk voting and effects
  server/
    main.lua              -- Server-side game management, scoring, shops
    mysterybox.lua        -- Mystery box server logic
    perks.lua             -- Perk application server logic
  configs/
    config.lua            -- Main configuration
    logs.lua              -- Logging configuration
    maps/
      cayo_estate.lua
      doomsday_bunker.lua
      gunrunning_bunker.lua
      server_farm.lua
  modules/
    iplLoader.lua         -- Interior loading system
    mapLoader.lua         -- Map configuration loader
  locales/
    de.json               -- German
    en.json               -- English
  web/
    build/                -- NUI build files
    src/
      App.css
      App.tsx
      components/
        BossHealthBar.tsx
        EndGameLoot.tsx
        HordeHUD.tsx
        MapIntro.tsx
        PerkSelection.tsx
        ShopItem.tsx
        ShopSection.tsx
      locales/
        TranslationProvider.tsx
        i18n.ts
      main.tsx
      types/window.d.ts
      utils/icons.tsx
    index.html
    package.json
    tsconfig.json
    tsconfig.node.json
    vite.config.ts
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/horde/installation) -- Get up and running
- [Configuration](/resources/horde/configuration) -- Customize every aspect
- [Client Exports](/resources/horde/exports-client) -- Client-side integration
- [Server Exports](/resources/horde/exports-server) -- Server-side integration
- [Creating Maps](/resources/horde/creating-maps) -- Build your own maps
