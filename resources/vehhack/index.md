# Vehicle Hacking Device <VersionBadge repo="sd-vehhack" fallback="1.0.0" />

**Vehicle Hacking Device** (`sd-vehhack`) is a Watch Dogs–style hacking tool for FiveM. Plug a dongle into your phone, load a hacking SIM, aim at a nearby vehicle, and run one of **16 exploits** — from honking a taxi's horn to detonating a rival's supercar. Clean UI, secure server-side validation, and config-driven hacks.

## Key Features

### 16 Hacks Across 4 Categories

| Category | Focus | Example Hacks |
|---|---|---|
| **Sabotage** | Permanent/damaging | `POP_TIRES`, `FUEL_LEAK`, `DISABLE_ENGINE`, `DISABLE_ROTOR` |
| **Control** | Hijack inputs | `STEER_LEFT/RIGHT`, `LOCK_STEERING`, `DEPLOY_BRAKES`, `PULL_UP` |
| **Chaos** | Loud / destructive | `HONK_HORN`, `TRIGGER_ALARM`, `SMOKE_SCREEN`, `EXPLODE_VEHICLE` |
| **Intel** | Recon | `OWNER_SCAN` (pulls owner name from DB) |

### Vehicle Class Targeting

Each hack declares which class it applies to — cars, bikes, helicopters, or any. Range is enforced per class:

| Class | Default Range | Notes |
|---|---|---|
| Cars / bikes / boats | 30m | `MaxTargetDistanceCar` |
| Helicopters | 150m | `MaxTargetDistanceHeli` |

Server-side re-validates distance with a 5m lag tolerance.

### Owner Scan

`OWNER_SCAN` pulls the registered owner's first and last name from `player_vehicles` / `owned_vehicles`. Unowned emergency vehicles (police / EMS / fire models) show a **GOVERNMENT FLEET** label instead of a random name — configured per department in `EmergencyVehicles`.

### Items & Currency

Two items by default:

| Item | Role |
|---|---|
| `phone_plug` | The device — reusable, triggers the UI on use |
| `hacking_sim` | The consumable currency spent per hack |

Set `CurrencyItem = nil` in config to use **cash** instead of an item.

### Favourites

Players can pin their most-used hacks — saved per-player, persists between sessions.

### Security

Every action is validated server-side:

- Target entity resolved from netId and verified to be a vehicle
- Vehicle class matched against the hack's `applies` field
- Distance re-checked server-side
- Cooldown enforced server-side, not only in the UI
- Cost deducted atomically before the effect fires
- SQL uses parameterised queries

### Logging

Every hack and owner scan can be logged to **Discord**, **Fivemanage**, **Fivemerr**, **Loki**, or **Grafana**. Event templates are per-event (title, description, colour, fields), each with an `enabled` toggle.

## File Structure

```
sd-vehhack/
  client/              -- Client-side targeting + hack effect natives
  server/              -- Server-side validation, cooldowns, DB queries
  bridge/              -- Framework / inventory auto-detection
  configs/
    config.lua         -- Items, ranges, cooldown, hacks table
    logs.lua           -- Logging service + event templates
  locales/
    en.json
  web/                 -- React UI (source + built bundle)
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/vehhack/installation) -- Get up and running
- [Configuration](/resources/vehhack/configuration) -- Customize every aspect
