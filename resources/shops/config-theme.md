---
title: Theme Configuration
description: Customize the visual appearance of the Shops Pro UI with presets, patterns, and color overrides.
---

# Theme Configuration

The theme configuration file (`configs/theme.lua`) controls the visual appearance of the Shops Pro React UI. Choose a preset, customize the background pattern, override individual colors, and style semantic states, tags, and scrollbars.

::: info Config File Location
All options documented on this page are in `configs/theme.lua`.
:::

## Preset

```lua
preset = 'deepVoid'
```

Sets the base color theme for the entire UI. All other customizations layer on top of the chosen preset.

| Preset | Description |
|---|---|
| `'deepVoid'` | Deep dark purple/void theme (default) |
| `'slateStorm'` | Slate gray storm theme |
| `'midnightBlue'` | Midnight blue theme |
| `'purpleHaze'` | Purple haze theme |
| `'charcoalPro'` | Professional charcoal theme |
| `'carbonBlack'` | Carbon black theme |
| `'forestNight'` | Dark forest green theme |
| `'roseGold'` | Rose gold theme |
| `'electricBlue'` | Electric blue theme |
| `'amberGlow'` | Warm amber glow theme |

## Background Pattern

```lua
pattern = 'grid'
patternOpacity = 0.15
patternSize = '14px 14px'
```

| Option | Type | Default | Description |
|---|---|---|---|
| `pattern` | `string` | `'grid'` | Background pattern style |
| `patternOpacity` | `number` | `0.15` | Pattern opacity (0 to 1) |
| `patternSize` | `string` | `'14px 14px'` | Pattern tile size (CSS value) |

**Available patterns:** `'none'`, `'grid'`, `'dots'`, `'cross'`, `'diagonal'`

## Scrollbar

Customize the scrollbar appearance. Uncomment the `scrollbar` block to override:

```lua
scrollbar = {
    track = '#1a1a2e',
    thumb = '#4a4a6a',
    thumbHover = '#6a6a8a',
}
```

| Option | Type | Description |
|---|---|---|
| `track` | `string` | Scrollbar track color (hex) |
| `thumb` | `string` | Scrollbar thumb color (hex) |
| `thumbHover` | `string` | Scrollbar thumb hover color (hex) |

## Color Overrides

Override individual preset colors by uncommenting the `overrides` block:

```lua
overrides = {
    bgPrimary = '#1a0a2e',
    bgSecondary = '#2d1b4e',
    bgTertiary = '#3d2b5e',
    bgHover = '#4d3b6e',
    bgOverlay = 'rgba(26, 10, 46, 0.85)',
    borderPrimary = '#ff00ff',
    borderHover = '#ff66ff',
    textPrimary = '#00ffff',
    textSecondary = '#ffff00',
    textMuted = '#ff8800',
    accentPrimary = '#ff0066',
    accentHover = '#cc0052',
    accentBg = 'rgba(255, 0, 102, 0.15)',
    accentBorder = 'rgba(255, 0, 102, 0.4)',
}
```

| Key | Description |
|---|---|
| `bgPrimary` | Primary background color |
| `bgSecondary` | Secondary background color |
| `bgTertiary` | Tertiary background color |
| `bgHover` | Background hover state |
| `bgOverlay` | Overlay/modal backdrop |
| `borderPrimary` | Primary border color |
| `borderHover` | Border hover state |
| `textPrimary` | Primary text color |
| `textSecondary` | Secondary text color |
| `textMuted` | Muted/dimmed text color |
| `accentPrimary` | Primary accent color (buttons, links, active states) |
| `accentHover` | Accent hover state |
| `accentBg` | Accent background (typically semi-transparent) |
| `accentBorder` | Accent border color |

## Semantic State Colors

Override colors for positive/negative values, warnings, and info badges:

```lua
colors = {
    positive = '#57F287',   -- Income, success, hired badges
    negative = '#ED4245',   -- Expenses, danger/error, removed badges
    warning = '#FFFF00',    -- Warnings, pending states
    info = '#5865F2',       -- Informational badges, today highlight
}
```

## Tag/Badge Colors

Customize the colors for all UI tags and badges. Each key needs only one hex color -- backgrounds (20% opacity) and borders (30% opacity) are auto-derived.

```lua
tags = {
    -- Transaction tags
    sale = '#...',
    expense = '#...',
    refund = '#...',
    transfer = '#...',
    deposit = '#...',
    withdrawal = '#...',

    -- Stock tags
    stockOrder = '#...',
    stockCollected = '#...',
    stockTransferIn = '#...',
    stockWithdraw = '#...',
    stockManualAdjust = '#...',

    -- Stock level indicators
    inStock = '#...',
    lowStock = '#...',
    outOfStock = '#...',

    -- Activity log tags
    actStock = '#...',
    actSociety = '#...',
    actPermission = '#...',
    actLoyalty = '#...',
    actCoupon = '#...',
    actSale = '#...',
    actProduct = '#...',
    actEmployee = '#...',
    actCustomer = '#...',
    actSettings = '#...',

    -- Payment method tags
    paymentCash = '#...',
    paymentBank = '#...',
    paymentSociety = '#...',

    -- Search category tags
    searchProduct = '#...',
    searchSale = '#...',
    searchCoupon = '#...',
    searchEmployee = '#...',
    searchCustomer = '#...',
    searchTransaction = '#...',
    searchStock = '#...',
    searchUpgrade = '#...',
    searchReward = '#...',

    -- Upgrade tier tags
    upgradePurple = '#...',
    upgradePink = '#...',
    upgradeCyan = '#...',
}
```

::: tip
All color override blocks (`scrollbar`, `overrides`, `colors`, `tags`) are commented out by default in the config file. Uncomment only the blocks you want to customize -- the preset handles everything else.
:::

## Example: Custom Theme

```lua
return {
    preset = 'carbonBlack',
    pattern = 'dots',
    patternOpacity = 0.1,
    patternSize = '20px 20px',

    overrides = {
        accentPrimary = '#22c55e',
        accentHover = '#16a34a',
        accentBg = 'rgba(34, 197, 94, 0.15)',
        accentBorder = 'rgba(34, 197, 94, 0.4)',
    },
}
```

This creates a carbon black theme with a green accent, dotted background pattern, and slightly larger pattern tiles.
