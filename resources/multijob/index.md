# Multi-Job <VersionBadge repo="sd-multijob" fallback="1.2.1" />

**Version:** 1.2.1 | **Author:** Samuel#0008 | **Locales:** English, German, Spanish, French, Arabic

An advanced multi-job management system for FiveM. Players can hold multiple jobs simultaneously, switch between them, toggle duty status, and interact with boss menus for hiring, firing, bonuses, applications, society accounting, and more. Features a custom NUI or ox_lib-based interface.

## Preview

<YouTubeEmbed id="DBZSaE61GS8" title="Multi-Job & Boss Menu — Full Showcase" />

## Key Features

### Multi-Job Roster

- Players can hold up to **5 jobs** simultaneously (configurable)
- Switch active job at any time via the `/multijob` command or **F5** keybind
- Each job tracks its own grade, salary display, stats, and duty state
- Jobs persist across sessions in the database

### Duty System

- Toggle on/off duty at configurable locations per job
- Three interaction types: **marker**, **textui**, or **target**
- Optional **duty zones** -- polygon areas that enforce on-duty status
  - Auto off-duty when leaving the zone (with configurable 30-second timeout)
  - Boss immunity option

### Boss Menu

Available to players with boss-grade jobs:

| Feature | Description |
|---|---|
| **Employee Management** | Search, view stats, promote, demote, fire, give bonuses |
| **Society Accounting** | Deposit/withdraw funds, view transaction history |
| **Applications** | Create custom forms (up to 20 questions), review submissions, schedule interviews |
| **Messages** | Send notifications to employees, view employee messages |
| **Leaderboard** | Top 5 employees by weighted score |
| **Weekly Goals** | Set hours target with optional bonus reward |
| **Boss Stash** | Secure inventory (requires ox_inventory) |

### Application System

- Boss-created forms with custom questions
- Application statuses: Pending, Accepted, Denied
- **Interview scheduling** with date/time/location and Confirm/Decline responses
- **Discord webhook** integration (optional, can bypass database storage)
- Auto-cleanup of old applications (configurable TTL)

### Bonus & Message System

- Bosses send **money bonuses** deducted from society balance
- Employees redeem bonuses to their bank account
- Bi-directional **message system** (boss-to-employee, employee-to-boss)
- All notifications expire after **72 hours** (configurable)

### Statistics & Leaderboard

- Per-job stat tracking: minutes worked, arrests, tickets, and custom stats
- Stats incremented via the `updateStats` export
- **Weekly stats** auto-reset every Monday at 00:00
- Leaderboard scoring with configurable weights per stat

### Society Accounting

- Built-in society balance tracking
- Deposit/withdraw from personal bank or cash
- Full transaction log with timestamps
- Support for custom banking integrations (e.g., Renewed-Banking)

### Admin Commands

| Command | Description |
|---|---|
| `/addjob` | Add a job to a player |
| `/removejob` | Remove a job from a player |
| `/viewjobs` | View all jobs for a player |

## Server Exports

```lua
exports['sd-multijob']:addJob(src, jobName, grade)
exports['sd-multijob']:removeJob(src, jobName)
exports['sd-multijob']:getSavedJobs(srcOrIdent)
exports['sd-multijob']:updateStats(src, jobName, statName, increment, doLog)
exports['sd-multijob']:logTransaction(src, action, amount, jobName)
exports['sd-multijob']:addSocietyDeposit(source, jobName, amount, moneyType)
exports['sd-multijob']:withdrawSocietyFunds(source, jobName, amount, moneyType)
exports['sd-multijob']:getSocietyBalance(source)
```

## Supported Frameworks

| Framework | Status |
|---|---|
| `qb-core` | Fully supported |
| `qbx_core` | Fully supported |
| `es_extended` (ESX) | Fully supported |

## Supported Target Systems

| Target | Status |
|---|---|
| `ox_target` | Fully supported |
| `qb-target` | Fully supported |
| `qtarget` | Fully supported |

## Dependencies

| Dependency | Options |
|---|---|
| **Framework** | `qb-core` / `qbx_core` / `es_extended` |
| **Library** | `ox_lib` |
| **Database** | `oxmysql` |
| **Inventory** | `ox_inventory` (optional, for boss stash) |

::: info
The framework is auto-detected at startup. Three database tables (`saved_jobs`, `boss_menus`, `sd_multijob_settings`) are created automatically on first start.
:::

## File Structure

```
sd-multijob/
  bridge/
    init.lua              -- Framework detection
    shared.lua            -- Locale system, shared utilities
    client.lua            -- Client bridge (notifications, target, interaction)
    server.lua            -- Server bridge (money, inventory, player data)
  client/
    main.lua              -- Client-side job menu, duty, boss menu logic
  server/
    logs.lua              -- Logging configuration
    main.lua              -- Server-side job management, society, applications
    webhooks.lua          -- Discord webhook integration for applications
  locales/
    ar.json               -- Arabic
    de.json               -- German
    en.json               -- English
    es.json               -- Spanish
    fr.json               -- French
  web/
    dist/                 -- NUI build files (+ FontAwesome font assets)
    src/
      App.tsx
      components/
        ConfirmDialog.tsx
        JobCard.tsx
        JobDetail.tsx
        JobPanel.tsx
        NotificationsView.tsx
        SendMessageView.tsx
      hooks/useNuiEvent.ts
      index.scss
      main.tsx
      types.ts
      utils/fetchNui.ts
    index.html
    package.json
    postcss.config.js
    tailwind.config.js
    tsconfig.json
    vite.config.ts
  config.lua              -- All configuration
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/multijob/installation) -- Get up and running
- [Configuration](/resources/multijob/configuration) -- Customize every aspect
