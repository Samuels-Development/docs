---
title: Shops Pro
description: A comprehensive shop system for FiveM with ownership, employees, stock management, loyalty programs, and more.
---

# Shops Pro <VersionBadge repo="sd-shops" fallback="1.1.0" />

**Shops Pro** (`sd-shops`) is a comprehensive shop system for FiveM featuring full shop ownership, employee management, stock ordering, loyalty programs, coupons, sales, and a modern React-based management UI. It supports multiple shop types, frameworks, inventories, and extensive configuration options.

## Preview

<YouTubeEmbed id="l0G50Ppoz_U" title="Shops Pro — Full Showcase" />

## Shop Types

| Type | Description | Currency |
|---|---|---|
| **Regular** (`247store`, `liquorstore`, `hardware`, `pharmacy`, etc.) | Standard shops where players buy items | Cash or Bank |
| **Gun Store** (`gunstore`) | Weapon shops with license requirements and automatic serial number generation | Cash or Bank |
| **Pawn Shop** (`pawn`) | Special shops that **buy items from** players and pay them cash | Cash (or Dirty Money via `payoutType`) |
| **Illegal** (`illegal = true`) | Underground shops that exclusively use dirty/black money | Black Money |
| **Item Currency** (`currencyItem`) | Shops where players pay with a specific inventory item instead of cash | Inventory Item |
| **Restricted** (`jobRestrictions` / `gangRestrictions`) | Job or gang-locked shops with access control | Cash or Bank |
| **Police Armory** (`police_armory`) | Job-restricted armory with per-grade item access and weapon serials | Cash or Bank (or Society) |

## Key Features

### Shop Ownership

Players can purchase and sell shops, gaining full control over their business. Owners have access to a comprehensive management interface where they can:

- Hire and manage employees with granular permissions (50+ individual permissions)
- Track financial history (income, expenses, profit)
- Set custom opening hours
- Transfer ownership to other players
- Manage product pricing and stock levels
- Create and manage discount coupons and sales
- Configure loyalty rewards programs
- Purchase shop upgrades (stock capacity, product slots, employee slots, reputation, express logistics)

### Product System

- **Base Products** (`BaseProducts`) defined centrally per shop type, with per-shop overrides
- **Stock management** with ordering, delivery timers, and capacity limits
- **Product Whitelist** per shop type controlling what items owners can stock and order
- **Job/gang restrictions** on individual items (with grade requirements)
- **License requirements** on items (e.g., weapon license)
- **Per-item currency override** (`currencyItem`) for mixed payment shops
- **Custom labels, descriptions, and images** per item
- **Metadata support** including durability, quality, and custom fields
- **Display metadata** for ox_inventory tooltips

### Weapon Serial Numbers

Weapons sold through shops are automatically assigned unique serial numbers in the configurable format:

```
[digits][letters][digits]
```

Default: `[6 digits][3 letters][6 digits]` -- Example: `482917ABK637201`

Each shop type can have its own prefix (e.g., `POL` for police armories), and specific letter combinations can be excluded from generation. Weapons can be registered to the buyer's character name.

### Loyalty System

Reward repeat customers with a built-in loyalty points program. Players earn points on purchases and can redeem them for coupon rewards. The loyalty system can require a shop upgrade purchase to unlock.

### Coupon System

Create discount coupons with configurable percentage discounts. Default coupons like `WELCOME10` and `SUMMER20` come pre-configured. Shop owners can create additional coupons through the management interface.

### Sales System

Shop owners can create time-limited sale promotions with percentage discounts on specific products.

### Society Payments

Players can purchase items using their job society funds if their job and grade are whitelisted in the configuration. Payments can be restricted per shop: limit a society to specific shops with `allowedShops`, or block society payments at a shop entirely with `disableSocietyPayment`.

### Admin Overview Menu

Server admins get a "god view" over every shop with `/shopsadmin` (ACE-restricted to `group.admin`):

- **Dashboard** with server-wide statistics: shop counts, society balances, revenue/expenses/profit, employees, customers, pending orders, and top shops
- **Shop list** with search/filters and a full per-shop drill-down: finances, products, stock, employees, customers, sales, loyalty, coupons, upgrades, and settings
- **Interactive map** of Los Santos plotting every shop with type icons and ownership filtering
- **Admin controls** per shop: teleport, adjust society funds, rename, force open/closed, restock or set stock, fire employees, unban customers, grant upgrades, assign/transfer/remove owners, and reset shops -- all validated and logged

### Server-Authoritative Security

Every purchase is validated server-side against the shop's real catalog: items must actually be sold there, quantities must be sane, and prices are clamped -- tampered carts sent by executors are rejected and logged before any money or items move. Owner-set product prices can also be bounded via configurable [price limits](./config-management#price-limits).

### Logging System

Full logging support with multiple backends: Discord webhooks, Fivemanage, Fivemerr, Loki, and Grafana. Every event type is individually configurable.

### Framework Job Integration

Shops can be linked to framework jobs via `frameworkJob`. When a player purchases a shop, they are automatically assigned the corresponding job. Selling or transferring removes or reassigns the job.

## File Structure

```
sd-shops/
  bridge/
    shared/               -- Framework/inventory detection, locale system
    client/               -- Client bridge (notifications, target, inventory/images)
    server/               -- Server bridge (money, inventory, job, gang, society, player, logging)
  client/
    admin.lua             -- Admin overview menu (client)
    hooks.lua             -- Client hook system
    main.lua              -- Client-side shop logic
    peds.lua              -- Ped spawning/management
  server/
    admin.lua             -- Admin overview menu (ACE-gated server callbacks)
    datastore.lua         -- Database operations (in-memory store + column-level saving)
    hooks.lua             -- Server hook system
    lib/                  -- Shared helpers (shop/employee/customer data, stock, pricing, permissions, ...)
    management/           -- Shop management callbacks (ownership, employees, products, stock, society, ...)
    purchase/             -- Storefront/transaction callbacks (buy, currency, pawn, coupons, rewards, ...)
  configs/
    config.lua            -- Main configuration
    fallbacks.lua         -- Item name/description fallbacks
    logs.lua              -- Logging configuration
    management.lua        -- Management/ownership settings
    shops.lua             -- Shop definitions
    theme.lua             -- UI theme configuration
  locales/
    de.json               -- German
    en.json               -- English
  web/
    build/                -- React UI build files
    src/
      features/
        shop/             -- Storefront UI (shopping panel, cart, modals)
        management/       -- Management UI (per-tab files, modals)
        admin/            -- Admin overview UI (dashboard, shop list, map, controls)
      components/         -- Shared components
      hooks/              -- Shared hooks
      locales/            -- UI translation system
  fxmanifest.lua
```

::: tip
New to Shops Pro? Head to the [Installation Guide](./installation) to get started.
:::
