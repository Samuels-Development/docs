# Vehicle Hacking Device <VersionBadge repo="sd-vehhack" fallback="1.0.0" />

**Vehicle Hacking Device** (`sd-vehhack`) is a Watch Dogs–style hacking tool for FiveM. Plug a dongle into your phone, load a hacking SIM, aim at a nearby vehicle, and run one of **28 exploits** — from honking a taxi's horn to arming a speed bomb on a rival's supercar. Clean NUI, server-authoritative validation, and a fully config-driven hack table.

## Key Features

### 28 Hacks Across 4 Categories

| Category | Focus | Example Hacks |
|---|---|---|
| **Sabotage** | Permanent / damaging | `POP_TIRES`, `FUEL_LEAK`, `FUEL_PURGE`, `DISABLE_ENGINE`, `DISABLE_ROTOR`, `SPEED_BOMB` |
| **Control** | Hijack inputs / movement | `STEER_LEFT/RIGHT`, `LOCK_STEERING`, `LOCK_DOORS`, `UNLOCK_DOORS`, `DEPLOY_BRAKES`, `DRIFT_MODE`, `SPEED_LIMITER`, `PULL_UP`, `OPEN_HOOD`, `OPEN_DOORS` |
| **Chaos** | Loud / destructive | `HONK_HORN`, `TRIGGER_ALARM`, `SMOKE_SCREEN`, `EJECT_OCCUPANT`, `FLASHBANG`, `REVERSE_CAMERA`, `LOCAL_CHAOS`, `EXPLODE_VEHICLE` |
| **Intel** | Recon | `OWNER_SCAN`, `GPS_PING` |

### Progress-Bar Rendering

Confirming a hack runs a progress bar before it fires. Choose the look:

| `ProgressBarStyle` | What you get |
|---|---|
| `'custom'` | In-house NUI progress card with a live distance sub-bar and countdown |
| `'native'` | `ox_lib` / framework-native progress bar (bridge handles it) |

Both paths re-validate distance every tick — stepping out of range aborts the hack and **no SIMs are deducted**.

### Per-Hack Modals

Some hacks open a secondary picker after you click:

| Hack | Modal | Behavior |
|---|---|---|
| `EJECT_OCCUPANT` | Seat picker | Choose driver / passenger / rear-left / rear-right, or **ALL** (cost × `allMultiplier`). |
| `SPEED_LIMITER` | Speed slider | Pick a top speed between `speedMin`–`speedMax` mph. Cost slides linearly: `costAtMin` at the bottom, `cost` at the top (harder to escape = more expensive). |
| `SPEED_BOMB` | — | Arms only once the driver hits `speedThreshold` mph; dropping back below it detonates. |
| `FUEL_PURGE` | — | Drains the tank down to `fuelLevel` (%). 10% leaves a splash for a short limp. |

### Vehicle Class Targeting

Each hack declares which class it applies to — cars, bikes, helicopters, or any. Range is enforced per class:

| Class | Default Range | Config Key |
|---|---|---|
| Cars / bikes / boats | 30m | `MaxTargetDistanceCar` |
| Helicopters | 150m | `MaxTargetDistanceHeli` |

Server-side re-validates distance with a small lag tolerance.

### Targeting HUD

- **Brackets** — subtle white corner brackets around the vehicle bounding box
- **Outline** — screen-space coloured outline shader on the vehicle mesh
- **Arrow** — 3D arrow marker floating above the target
- **Label** — plate text (e.g. `12ABC345`) or display name (e.g. `KURUMA`), toggled by `Config.ShowPlate`

Each highlight can be toggled individually in `Config.Highlights`.

### Hacked-Screen Effects

Occupants of a hacked vehicle get a screen effect chosen per hack via `hackedFx`:

| Effect | Look |
|---|---|
| `static` (default) | RGB chromatic split + scan-line static + horizontal tear bars — chaotic analog-TV interference |
| `nosignal` | SMPTE colour-bar "no signal" flash with grain and occasional white strobes |
| `blackout` | Stuttering black flashes ending with a thin white line that horizontally collapses to centre (CRT power-off) |

### Owner Scan

`OWNER_SCAN` pulls the registered owner's first and last name from `player_vehicles` / `owned_vehicles`. Unowned emergency vehicles (police / EMS / fire models) show a **GOVERNMENT FLEET** label instead of a random name — configured per department in `Config.EmergencyVehicles`.

### GPS Ping

`GPS_PING` tags a vehicle on the hacker's map and streams its live coords for the configured duration (default 2 minutes). Scope is per-player; re-running on a different vehicle swaps the ping, re-running on the same one refreshes the timer.

### Items & Currency

Two items by default:

| Item | Role |
|---|---|
| `phone_plug` | The device — reusable, triggers the UI on use |
| `hacking_sim` | The consumable currency spent per hack |

Set `Config.CurrencyItem = nil` to use **cash** instead of an item.

### Per-Player UI Settings

Each player can reposition the main panel and pick an accent colour — or the server can force everyone to a single default. Gated by three toggles under `Config.Settings`:

| Toggle | Effect when `false` |
|---|---|
| `enabled` | Hides the settings gear entirely |
| `allowPosition` | Panel is forced to `defaultPosition` |
| `allowAccent` | Accent is forced to `defaultAccent` |

When `OutlineColor.followAccent = true`, the selected-vehicle outline inherits the player's chosen accent too.

### Cooldowns

Two independent, server-authoritative cooldowns:

| Cooldown | Scope | Default | Use |
|---|---|---|---|
| `HackCooldown` | Per-user | 5s | Stops spam-clicking hacks |
| `VehicleCooldown` | Per-plate | 600s | Protects a recently-hacked vehicle regardless of who attacks it |

Set either to `0` to disable.

### Exempt Vehicles

`Config.ExemptVehicles` is an allowlist-bypass — models listed here are rejected server-side before any cost is deducted. Useful for money trucks, tanks, or mission-critical vehicles.

### Favourites

Players can pin their most-used hacks — saved per-player, persists between sessions.

### Security

Every action is validated server-side:

- Target entity resolved from netId and verified to be a vehicle
- Vehicle class matched against the hack's `applies` field and `excludes` list
- Distance re-checked server-side (with lag tolerance)
- Model checked against `ExemptVehicles` before deduction
- Per-user and per-plate cooldowns enforced server-side, not only in the UI
- Cost deducted atomically before the effect fires
- `requiresSeat` / `requiresSpeed` payloads are sanitized before reaching the ApplyHack handler
- SQL uses parameterised queries

### Logging

Every hack and owner scan can be logged to **Discord**, **Fivemanage**, **Fivemerr**, **Loki**, or **Grafana**. Two event templates (`hack_executed`, `owner_scan_performed`) ship out of the box — each with a toggle, title, description, colour, and fully editable fields.

## File Structure

```
sd-vehhack/
  client/              -- Client-side targeting, effects, and NUI bridge
    main.lua
  server/              -- Validation, cooldowns, DB queries, ApplyHack dispatch
    main.lua
  bridge/              -- Framework / inventory auto-detection
    init.lua / shared.lua / client.lua / server.lua
  configs/
    config.lua         -- Items, ranges, cooldowns, settings, ExemptVehicles
    hacks.lua          -- The hack table (27 hacks, fully tunable)
    logs.lua           -- Logging service + per-event templates
  data/
    names.lua          -- Name pools for unowned/NPC vehicle owner-scans
  locales/
    en.json / de.json
  web/                 -- React NUI (source + built bundle)
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/vehhack/installation) — Get up and running
- [Configuration](/resources/vehhack/configuration) — Every option explained
- [Full config.lua](/resources/vehhack/full-config) — Reference copy
- [Full logs.lua](/resources/vehhack/full-config-logs) — Logging reference
