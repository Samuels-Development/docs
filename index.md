---
layout: doc
title: Getting Started
---

<div class="welcome-hero">
  <img src="/logo.png" alt="Samuel's Development" class="welcome-logo" />
  <h1 class="welcome-title">Samuel's Development</h1>
  <p class="welcome-tagline">Documentation for installing and maintaining our premium FiveM scripts.</p>
  <div class="welcome-actions">
    <a href="https://fivem.samueldev.shop" target="_blank" class="action-btn brand">Visit Store</a>
    <a href="https://discord.gg/Tu94MCDDEa" target="_blank" class="action-btn alt">Join Discord</a>
  </div>
</div>

## Our Scripts

Use the **sidebar** to navigate to any resource. Each script includes an overview, installation guide, and configuration reference.

| Script | Description |
|--------|-------------|
| [**Shops Pro**](/resources/shops/) | Full economy system — shop ownership, employees, stock, loyalty, coupons, 5 shop types |
| [**Horde Mission**](/resources/horde/) | Wave-based survival — 4 maps, group play, 20-level progression, mystery box |
| [**Advanced Crafting**](/resources/crafting/) | Workbenches, recipes, blueprints, tech trees, tool durability, persistent queues |
| [**Dumpster Diving**](/resources/dumpsters/) | Loot dumpsters, rat companions with perks, expeditions, Hobo King, recycler |
| [**Beekeeping**](/resources/beekeeping/) | Hive management, 3 honey types, infections, aggression, collaborators |

## Quick Start

Every script follows the same installation process:

1. **Download** — Purchase from [our store](https://fivem.samueldev.shop) and download via Keymaster
2. **Drop in** — Extract into your `resources` folder. Database and framework are detected automatically
3. **Add items** — Copy item definitions to your inventory system (`ox_inventory`, `qb-core`, or ESX)
4. **Configure** — Tweak `config.lua` to your liking. All options are documented here

::: tip Supported Frameworks
All scripts support **QBCore**, **QBox**, and **ESX** with auto-detection. Common dependencies: `ox_lib`, `oxmysql`, and a targeting system (`ox_target` / `qb-target`).
:::

## Support

We offer support for all of our scripts. Join our [Discord server](https://discord.gg/Tu94MCDDEa) and open a support ticket.

::: warning
Our scripts are sold **exclusively** on [fivem.samueldev.shop](https://fivem.samueldev.shop). Do not purchase from unauthorized resellers.
:::

<style>
.welcome-hero {
  text-align: center;
  padding: 32px 0 40px;
  border-bottom: 1px solid var(--vp-c-divider);
  margin-bottom: 32px;
}

.welcome-logo {
  width: 88px;
  height: 88px;
  object-fit: contain;
  margin-bottom: 16px;
}

.welcome-title {
  font-size: 36px !important;
  font-weight: 800 !important;
  letter-spacing: -0.03em;
  background: linear-gradient(120deg, #94DD0C 30%, #d4f77a);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 0 0 8px !important;
  border: none !important;
  padding: 0 !important;
}

.welcome-tagline {
  font-size: 17px;
  color: var(--vp-c-text-2);
  margin: 0 0 24px;
  line-height: 1.5;
}

.welcome-actions {
  display: flex;
  gap: 12px;
  justify-content: center;
  flex-wrap: wrap;
}

.action-btn {
  display: inline-block;
  padding: 10px 24px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.2s ease;
}

.action-btn.brand {
  background: #94DD0C;
  color: #0f1014;
}

.action-btn.brand:hover {
  background: #a4e82e;
}

.action-btn.alt {
  background: var(--vp-c-default-soft);
  color: var(--vp-c-text-1);
  border: 1px solid var(--vp-c-divider);
}

.action-btn.alt:hover {
  border-color: var(--vp-c-brand-1);
}
</style>
