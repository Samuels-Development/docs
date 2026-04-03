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

Players can purchase items using their job society funds if their job and grade are whitelisted in the configuration.

### Logging System

Full logging support with multiple backends: Discord webhooks, Fivemanage, Fivemerr, Loki, and Grafana. Every event type is individually configurable.

### Framework Job Integration

Shops can be linked to framework jobs via `frameworkJob`. When a player purchases a shop, they are automatically assigned the corresponding job. Selling or transferring removes or reassigns the job.

## Supported Frameworks

| Framework | Status |
|---|---|
| `qb-core` | Fully supported |
| `es_extended` (ESX) | Fully supported |

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

## Supported Target Systems

| Target | Status |
|---|---|
| `ox_target` | Fully supported |
| `qb-target` | Fully supported |
| `qtarget` | Fully supported |

## Dependencies

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` or `es_extended` |
| **ox_lib** | Yes | -- |
| **oxmysql** | Yes | -- |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` |
| **Inventory** | Yes | Any of the 10 supported inventories listed above |

## Locales

Shops Pro ships with full localization support:

- English (`en`)
- German (`de`)

## UI

The management and shopping interface is built with **React**, providing a modern, responsive experience for both customers and shop owners.

## File Structure

```
sd-shops/
  bridge/
    init.lua              -- Framework detection
    shared.lua            -- Locale system, shared utilities
    client.lua            -- Client bridge (notifications, target, images, labels)
    server.lua            -- Server bridge (money, inventory, player management)
  client/
    hooks.lua             -- Client hook system
    main.lua              -- Client-side shop logic
    peds.lua              -- Ped spawning/management
  server/
    datastore.lua         -- Database operations
    hooks.lua             -- Server hook system
    main.lua              -- Server-side shop logic
    management.lua        -- Shop management logic
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
      AddProductScreen.tsx
      App.tsx
      ManagementMenu.tsx
      PurchaseScreen.tsx
      components/
        AddRewardModal.tsx
        BanCustomerModal.tsx
        CategorySelector.tsx
        ColorPicker.tsx
        ConfirmDeleteModal.tsx
        CustomDropdown.tsx
        CustomerAnalyticsModal.tsx
        DateTimePicker.tsx
        EmployeeActivityModal.tsx
        EmployeeImageModal.tsx
        ImportPresetModal.tsx
        ProductSelector.tsx
        QuantityInput.tsx
        SocietyDepositWithdrawModal.tsx
      hooks/useDebounce.ts
      index.css
      locales/
        TranslationProvider.tsx
        i18n.ts
      main.tsx
      themeConfig.ts
    index.html
    package.json
    postcss.config.js
    tailwind.config.js
    tsconfig.json
    tsconfig.node.json
    vite.config.ts
  fxmanifest.lua
```

::: tip
New to Shops Pro? Head to the [Installation Guide](./installation) to get started.
:::
