# Petty Crimes <VersionBadge repo="sd-pettycrime" fallback="1.0.0" />

**Petty Crimes** (`sd-pettycrime`) is a modular low-level crime suite for FiveM - **22 self-contained criminal activities** ranging from mailbox break-ins and pickpocketing to catalytic-converter theft, brake-line sabotage, and ATM skimming. Every crime has its own XP/level progression, weighted loot tables, optional police alerts, and a minigame drawn from a **built-in library of 21 minigames** (no external minigame resource required). A contact ped runs a black-market shop for tools and fencing, and an in-game **admin panel** (React NUI) lets staff inspect players, audit a full history ledger, and live-edit every config value.

Built on an in-house compatibility bridge, the same resource runs on **QBCore, QBox, and ESX** with any major inventory and target system - no external bridge resource to install.

## Preview

<!-- Add your showcase video ID and uncomment:
<YouTubeEmbed id="VIDEO_ID" title="Petty Crimes - Full Showcase" />
-->

_Showcase video coming soon._

## Key Features

### 22 Crimes

**Street fixtures & coin-ops**

| Crime | Summary |
|---|---|
| **Mailbox break-in** | Force open residential mailboxes for loot and `mail_package` items you can open later |
| **Payphone robbery** | Pry the coin box out of street payphones for cash |
| **Parking meter robbery** | Jimmy parking meters for coins |
| **News rack robbery** | Crack honor-box newspaper racks |
| **Vending machine** | Smash a vending machine for snacks, drinks, and change |
| **Street sign theft** | Unbolt and carry off street/traffic signs to fence |

**Person crimes**

| Crime | Summary |
|---|---|
| **Pickpocketing** | Lift items + cash from unaware civilians, gated by facing/movement checks |
| **Armed ped robbery** | Aim a real weapon at a civilian, hold them up, and press a key to rob them |
| **Shoplifting** | Palm goods off store shelves |

**Vehicle crimes**

| Crime | Summary |
|---|---|
| **Catalytic converter theft** | Saw the cat off the underside of parked cars |
| **Wheel theft** | Pry a wheel off the hub and walk away with it |
| **Wheel loosening** | Back the lug nuts off so the wheel detaches mid-drive later |
| **Tyre slashing** | Knife a tyre flat |
| **Brake-line cutting** | Sever the brake line so the brakes fail on the road |
| **Fuel-tank sabotage** | Puncture the tank for a trailing fuel leak |
| **Brick on the gas** | Wedge a brick on the pedal and send an empty car careening off |
| **Car door theft** | Saw a door off a parked car and haul it away to fence |
| **Speed bomb** | Wire a bomb under a parked car that arms at speed and detonates if it slows |
| **Smash & grab** | Break a car window and grab the valuables left on the seat |

**Specialist**

| Crime | Summary |
|---|---|
| **AC unit stripping** | Cut the copper out of HVAC/AC units around the map |
| **ATM skimming** | Install a skimmer on an ATM, then return later to harvest card data |
| **Porch parcel theft** | Snatch delivery parcels off porches, carry them home, and open them |

### Systems on Top

- **Levels & XP** - every crime has its own 3-tier progression curve (configurable XP thresholds and per-item XP). Higher level unlocks better loot tables.
- **Statistics** - per-crime counters for attempts, successes, failures, cash earned, items received, and a per-item tally. Visible in the contact menu and the admin panel.
- **Black-market shop** - a contact ped spawns at a random configured location each restart. Buy criminal tools, fence stolen goods, and view your progression and stats.
- **Minigame library** - 21 built-in minigames (lockpick rings/bars, pickpocket bar, wire-cut, Simon, reaction, rhythm, pipes, safe dial, and more). Every crime ships with one enabled by default; swap it per-crime for any other built-in or your own function.
- **Police alerts** - every crime has a `PoliceAlert.Send` function. Drop in any dispatch system (cd_dispatch, ps-dispatch, your own). Some crimes add day/night chance variance.
- **Admin panel** - React/TypeScript NUI with Players, History, and Configuration tabs. Live-edit any config value, inspect/adjust player progression, and audit an append-only ledger.
- **Localisation** - every player-facing string lives in `locales/<lang>.json`. Add a file, point `Locale` at it, done.

## Compatibility

| Layer | Supported |
|---|---|
| **Frameworks** | QBCore, QBox, ESX |
| **Inventories** | ox_inventory, qb-inventory, qs-inventory, qs-inventory-pro, origen_inventory, codem-inventory, jaksam_inventory, ps-inventory, lj-inventory, tgiann-inventory |
| **Targets** | ox_target, qb-target, qtarget |
| **Notifications** | ox_lib (preferred), lation_ui, framework-native fallback |

The bridge auto-detects which framework, inventory, and target system are running - you don't configure anything for compatibility.

## Commands

Both commands are gated behind the `command.pettycrime_admin` ACE - typically already covered by `group.admin`, which most servers grant to staff. If your admins use a different group, add `add_ace group.admin command.pettycrime_admin allow` to your `server.cfg`.

| Command | Alias | Description |
|---|---|---|
| `/pettycrimeadmin` | `/pcadmin` | Open the in-game admin panel (Players, History, Configuration tabs) |
| `/testminigame [name]` | - | Preview a minigame - pass a name (e.g. `lockpick`), `all` to cycle through every one, or no argument to list them |

There are no player-facing commands - every crime is triggered by walking up to a target (a prop, ped, or vehicle) and using your target system.

## File Structure

```
sd-pettycrime/
  bridge/              -- multi-framework / inventory / target / notify abstraction
    shared/            -- framework + inventory + locale detection
    client/            -- notify, target, inventory (count, has, label, image)
    server/            -- player, money, inventory, job, gang, notify
  configs/             -- one config table per crime + config.lua (global)
  client/
    crimes/            -- one file per crime, each exposes register()
    menus/             -- main / shop / stats / progress menus
    minigame.lua       -- minigame dispatcher + named wrappers
    minigame_test.lua  -- /testminigame dev command handler
    ped.lua            -- contact ped streaming
  server/
    crimes/            -- one file per crime (callbacks + events)
    admin/             -- admin panel callbacks, history, config overrides
    stats.lua          -- XP + level + per-stat counters (DB-backed)
    rewards.lua        -- weighted-chance reward dispatch
  locales/             -- flattened-on-load JSON dictionaries
  images/              -- tool item images for your inventory
  web/                 -- React + Vite admin panel (built into web/build)
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/pettycrime/installation) - dependencies, items, and setup
- [Configuration](/resources/pettycrime/configuration) - every setting explained, plus the minigame library
- [Full Config Files](/resources/pettycrime/full-config) - raw, unedited config references
