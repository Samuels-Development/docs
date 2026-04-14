# Configuration

All tunables live in `configs/config.lua`. Logging lives in `configs/logs.lua`. Restart `sd-vehhack` after any change.

## General

| Option | Default | Description |
|---|---|---|
| `Locale` | `'en'` | Locale file in `locales/<code>.json` |
| `AccentColor` | `'4ade80'` | UI accent (hex, no `#`) |
| `DebugPrints` | `false` | Log validation steps to server console |

## Items & Currency

| Option | Default | Description |
|---|---|---|
| `HackingItem` | `'phone_plug'` | The device item — triggers the UI when used. Set to `nil` to gate entry to `/testhackui` only. |
| `ConsumeOnUse` | `false` | `true` = device deleted on every use. Keep `false` for a reusable dongle. |
| `CurrencyItem` | `'hacking_sim'` | Stackable item spent per hack. `nil` = use cash balance. |
| `CurrencyLabel` | `'SIMS'` | Short text shown in the UI next to the balance. |

## Targeting

| Option | Default | Description |
|---|---|---|
| `MaxTargetDistance` | `150.0` | Camera raycast reach. Must be ≥ the largest per-class limit below. |
| `MaxTargetDistanceCar` | `30.0` | Lock/execute range for cars, bikes, boats |
| `MaxTargetDistanceHeli` | `150.0` | Lock/execute range for helicopters |
| `OutlineColor` | `{ r=74, g=222, b=128, a=255 }` | RGBA for the selected-vehicle outline |

## Hack Execution

| Option | Default | Description |
|---|---|---|
| `HackCooldown` | `5` | Seconds between any two hacks (per player) |
| `UseProgressBar` | `true` | Show the "executing…" bar after confirming |
| `ProgressDuration` | `3000` | Progress bar length in ms |

## Emergency Vehicles

When `OWNER_SCAN` runs on an **unowned** vehicle whose model appears in one of these lists, the card shows a department label (e.g. `POLICE`) instead of a fake randomised name. Owned vehicles still show the real player's name — ownership wins.

Add your server's custom emergency spawn names here:

```lua
EmergencyVehicles = {
    POLICE = { 'police', 'police2', 'sheriff', 'fbi', ... },
    EMS    = { 'ambulance' },
    FIRE   = { 'firetruk' },
}
```

## Hacks Table

Each entry in `Hacks` is a table:

| Field | Type | Description |
|---|---|---|
| `id` | string | Unique identifier. Used in code — do not duplicate. |
| `enabled` | bool | `false` = hidden from menu and rejected server-side. |
| `label` | string | Text shown on the button. |
| `icon` | string | Lucide icon name. See `web/src/App.tsx` `iconMap`. |
| `cost` | number | SIMs (or cash) spent on success. |
| `duration` | number | Effect length in ms. `0` = instant / permanent. |
| `description` | string | Tooltip text. |
| `applies` | string | Class gate: `'car'` (cars + bikes), `'heli'`, or `nil` (any). |
| `excludes` | table | Optional list of classes to block, e.g. `{ 'bike' }`. |
| `category` | string | UI tab: `'sabotage'` / `'control'` / `'chaos'` / `'intel'`. |
| `sound` | string | One of `success` / `activate` / `select` / `target_lock` / `targeting_start` / `explode`. |

### Cost tiers (guidance only)

| Tier | Range |
|---|---|
| Trivial | 5-10 |
| Cheap | 10-20 |
| Mid | 20-40 |
| Heavy | 40-75 |
| Serious | 100+ |

### Disable a hack

Flip `enabled = false` on the entry. It stays in the file but is hidden and the server rejects attempts to fire it.

### Remove a hack permanently

Delete its entry from `Hacks`, then (optionally) its `elseif hackId == '...'` branch in `client/main.lua` inside `RegisterNetEvent('sd-hacking:client:ApplyHack', ...)`. Orphaned handlers are harmless.

### Add a new hack

1. Copy any existing entry in the `Hacks` table and give it a unique `id`.
2. Open `client/main.lua`, find `RegisterNetEvent('sd-hacking:client:ApplyHack', ...)`, and add an `elseif hackId == 'your_id' then` branch with the in-game effect (native calls on the vehicle).
3. If you need a new icon, import it in `web/src/App.tsx`, add it to `iconMap`, then run `npm run build` inside `/web`.

## Logging

See [logs.lua](./full-config-logs) for the full event-template reference. Quick Discord setup:

1. In Discord: channel → **Settings → Integrations → Webhooks → New Webhook** → copy the URL.
2. In `configs/logs.lua`:

```lua
service = 'discord',
discord = {
    webhook       = 'paste-url-here',
    botName       = 'SD-Vehhack',
    flushInterval = 5,
    tagEveryone   = false,
},
```

3. Restart the resource.

Each embed shows player + identifier + character name, the hack label / category / cost, the target plate + class, and (for owner scans) the resolved owner and scan status.

