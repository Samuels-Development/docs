---
title: Installation
description: How to install and set up Shops Pro for your FiveM server.
---

# Installation

Follow these steps to install Shops Pro on your FiveM server.

## Supported Inventories

| Inventory | Status |
|---|---|
| `ox_inventory` | Fully supported (metadata, display metadata, images) |
| `tgiann-inventory` | Supported |
| `jaksam_inventory` | Supported |
| `qs-inventory` | Supported |
| `qs-inventory-pro` | Supported |
| `origen_inventory` | Supported |
| `qb-inventory` | Supported |
| `ps-inventory` | Supported |
| `lj-inventory` | Supported |
| `codem-inventory` | Supported |

## Dependencies

Ensure the following dependencies are installed and running on your server before starting:

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` / `qbx_core` / `es_extended` |
| **ox_lib** | Yes | Must be started before `sd-shops` |
| **oxmysql** | Yes | Must be started before `sd-shops` |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` |
| **Inventory** | Yes | Any of the 10 supported inventories listed above |

## Step 1 -- Add the Resource

Drag and drop the `sd-shops` folder into your server's `resources` directory.

```
resources/
  [standalone]/
  [qb]/
  sd-shops/        <-- place here
```

::: tip Automatic Setup
Shops Pro **automatically creates** all required database tables on first start. There is no need to manually import any SQL files.

The script also **auto-detects** your framework and inventory system -- no manual framework configuration is needed.
:::

Ensure `sd-shops` starts **after** all of its dependencies in your `server.cfg`:

```ini
ensure oxmysql
ensure ox_lib
ensure qb-core       # or es_extended
ensure ox_target      # or qb-target / qtarget
ensure ox_inventory   # or any other supported inventory

ensure sd-shops
```

## Step 2 -- Configure Shops

All configuration is done through Lua files inside the `configs/` directory of the `sd-shops` resource:

| File | Purpose |
|---|---|
| `configs/config.lua` | [Main Configuration](./config-main) -- locale, serial numbers, metadata, base products, categories, loyalty, coupons, society payments |
| `configs/shops.lua` | [Shop Definitions](./config-shops) -- individual shop locations, types, items, restrictions, and ownership |
| `configs/management.lua` | [Management Settings](./config-management) -- ownership limits, upgrades, product whitelists, employee permissions, stock delivery |
| `configs/fallbacks.lua` | [Fallback Configuration](./config-fallbacks) -- item name and description fallbacks |
| `configs/theme.lua` | [Theme Configuration](./config-theme) -- UI preset, background pattern, color overrides |
| `configs/logs.lua` | Logging configuration -- service selection, Discord/Fivemanage/Loki/Grafana settings, per-event config |

Start by reviewing the [Main Configuration](./config-main) and [Shop Definitions](./config-shops) pages.

## Step 3 -- Start Your Server

Start your server. On the first boot, Shops Pro will:

1. Detect your framework automatically (QBCore or ESX)
2. Detect your inventory system automatically
3. Detect your target system automatically
4. Create all required database tables
5. Spawn shop peds and blips at configured locations
6. Initialize the shop system

Check your server console for startup messages. You should see:
```
[SD-SHOPS] Framework detected: qb
[SD-SHOPS] Loaded locale: en
[SD-SHOPS] Server hooks system loaded
[SD-SHOPS] Client hooks system loaded
```

::: warning Metadata Features Require ox_inventory
If you want to use item metadata features such as **durability**, **quality**, **display metadata**, or **custom fields**, you must have `ox_inventory` installed. The `displayMetadata` configuration is only functional with ox_inventory.
:::

## File Structure

```
sd-shops/
  bridge/
    init.lua          -- Framework detection
    shared.lua        -- Locale system, shared utilities
    client.lua        -- Client bridge (notifications, target, images, labels)
    server.lua        -- Server bridge (money, inventory, player management)
  client/
    hooks.lua         -- Client hook system
    main.lua          -- Client-side shop logic
    peds.lua          -- Ped spawning/management
  configs/
    config.lua        -- Main configuration
    shops.lua         -- Shop definitions
    management.lua    -- Management/ownership settings
    fallbacks.lua     -- Item name/description fallbacks
    theme.lua         -- UI theme configuration
    logs.lua          -- Logging configuration
  locales/
    en.json           -- English locale
    de.json           -- German locale
  server/
    hooks.lua         -- Server hook system
    datastore.lua     -- Database operations
    management.lua    -- Shop management logic
    main.lua          -- Server-side shop logic
  web/
    build/            -- React UI build files
  fxmanifest.lua
```

