# Advanced Crafting <VersionBadge repo="sd-crafting" fallback="1.1.5" />

**sd-crafting** v1.1.5 -- A fully featured crafting system for FiveM with static and placeable workbenches, recipe tables, blueprints, tech trees, tool requirements, leveling, an admin panel, and a persistent crafting queue.

## Preview

<YouTubeEmbed id="X7yAq5xOlm0" title="Advanced Crafting — Full Showcase" />

<YouTubeEmbed id="uQH7qxRcoOk" title="Advanced Crafting — Admin Menu Showcase" />

## Features

### Workbench Types
Multiple workbench types (e.g. **basic**, **advanced**) can be configured independently. Each type has its own set of recipe tables, leveling progression, and tech trees. **Static stations** are placed by server owners at fixed map coordinates, while **placeable workbenches** allow players to deploy their own crafting stations anywhere in the world.

### Recipe Tables
Recipes are organized into named **tables** (e.g. `all`, `basic`, `advanced`). Each station or placeable workbench specifies which tables to use, allowing mix-and-match recipe availability. Recipes support ingredients, output amounts, fail chance, XP rewards, tech point rewards, level requirements, money costs, tool requirements, blueprints, and item metadata.

### Blueprint System
Blueprints are items that unlock specific recipes. Blueprints degrade through a **durability system** -- each craft consumes a portion of the blueprint's durability until it breaks. A legacy random-destruction system is also available as an alternative.

::: info
The blueprint durability system requires **ox_inventory** for metadata support. The legacy `destroyOnCraft` system works with any inventory.
:::

### Tool System
Recipes can require tools that must be present in the crafting inventory. Tools support four consumption types:

| Type | Behavior |
|---|---|
| `none` | Never consumed, just needs to be present |
| `durability` | Loses durability per craft (ox_inventory only) |
| `chance` | Percentage chance to break per craft |
| `consume` | Always consumed like an ingredient |

### Inventory Panel with Staging
The crafting UI includes a built-in inventory panel where players drag items into a **crafting inventory** (staging area) before crafting. The staging area is configurable with slot limits and weight limits, and can be set to per-player or per-workbench storage.

### Crafting Queue
All active crafts are placed into a queue. The queue is **persistent across server restarts** and supports both player-specific and shared modes. Queue behavior (what happens on UI close, player disconnect, etc.) is highly configurable at global, per-station, and per-workbench levels.

### Fail Chance
Two fail chance modes are available:

| Mode | Behavior |
|---|---|
| **All-or-nothing** (`treatQuantityAsWhole = true`) | A single roll determines if the entire batch succeeds or fails |
| **Per-item rolls** (`treatQuantityAsWhole = false`) | Each item is rolled individually -- partial successes are possible |

### Leveling System
Players gain XP per craft and level up. Leveling can be configured **per workbench type** with independent level tables and max levels, or as a single global progression. Each workbench type can define its own XP thresholds and max level.

### Tech Trees
A skill progression system lets you gate recipes behind prerequisite unlocks. Players earn **tech points** through crafting and spend them to unlock nodes in visual tech trees. Tech trees are assigned to stations and workbenches independently, and can optionally be shared across all users of a placed workbench.

### Shops
Configurable NPC shop peds that sell workbench items and crafting materials to players, with blip support and customizable inventories.

### Permissions System
Placed workbenches support an **access control system** where only the owner and explicitly added players can use the workbench.

### Crafting History
Placed workbenches track a **crafting history** showing who crafted what, with configurable visibility and owner-only deletion.

### Admin Panel
A full in-game admin panel accessible via command, allowing management of players, queues, stations, recipes, and tech trees. Admins can create/edit/delete recipes, tech trees, and stations live -- changes persist to the database.

### Logging
Comprehensive logging system supporting **Discord webhooks**, **Fivemanage**, **Fivemerr**, **Loki**, and **Grafana Cloud**. Every crafting event is configurable with custom messages, fields, and colors.

### Locales
Built-in locale support with translations for:
- English (`en`)
- German (`de`)

## Supported Frameworks

| Framework | Status |
|---|---|
| `qb-core` | Fully supported |
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

| Dependency | Options | Required |
|---|---|---|
| **Framework** | `qb-core` or `es_extended` | Yes |
| **Library** | `ox_lib` | Yes |
| **Database** | `oxmysql` | Yes |
| **Target System** | `ox_target` / `qb-target` / `qtarget` | Yes |
| **Inventory** | Any of the 10 supported inventories listed above | Yes |
| **Placement** | `object_gizmo` (optional) | No |

::: tip
The framework and inventory system are auto-detected at startup. Database tables are created automatically on first boot -- no manual SQL imports are required.
:::

## File Structure

```
sd-crafting/
  bridge/
    init.lua              -- Framework detection
    shared.lua            -- Locale system, shared utilities
    client.lua            -- Client bridge (notifications, target, interaction)
    server.lua            -- Server bridge (money, inventory, player data)
  client/
    admin.lua             -- In-game admin panel
    main.lua              -- Client-side crafting logic, workbenches, UI
  server/
    admin.lua             -- Server admin logic
    main.lua              -- Server-side crafting queue, recipes, tech trees
    migrations.lua        -- Database migration system
  configs/
    config.lua            -- Main configuration
    logs.lua              -- Logging configuration
    recipes.lua           -- Recipe definitions
    techtrees.lua         -- Tech tree/skill progression
  locales/
    de.json               -- German
    en.json               -- English
  images/
    advanced_workbench.png
    workbench.png
  tools/
    create-blueprint.js   -- Single blueprint generator
    batch-create.js       -- Batch blueprint generator
    blueprints/           -- Blueprint templates (3 PNG templates)
    output/               -- Generated blueprint images
    package.json
  web/
    build/                -- NUI build files
    src/
      AdminPanel.tsx
      App.tsx
      index.scss
      locales/
        TranslationProvider.tsx
        i18n.ts
      main.tsx
    index.html
    package.json
    postcss.config.js
    tailwind.config.js
    tsconfig.json
    tsconfig.node.json
    vite.config.ts
  [ESX]/items.sql         -- ESX item definitions
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/crafting/installation) -- Get up and running
- [Main Config](/resources/crafting/config-main) -- Crafting behavior, queues, durability, shops, stations
- [Recipes](/resources/crafting/config-recipes) -- Define recipes, ingredients, tools, metadata
- [Tech Trees](/resources/crafting/config-techtrees) -- Skill progression trees
- [Blueprint Image Creator](/resources/crafting/blueprint-creator) -- Generate blueprint item images
- [Placeable Workbenches](/resources/crafting/placeable-workbenches) -- Deploy portable crafting stations
