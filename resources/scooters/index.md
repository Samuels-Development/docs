# Scooters <VersionBadge repo="sd-scooters" fallback="0.9.9" />

**Scooters** (`sd-scooters`) is a complete e-scooter rental network for FiveM. It ships a custom standing-rider scooter, rental bunkers that rise out of the pavement and dispense a scooter, charging stations with live pay screens, a battery economy, a phone app for renting and ending rides, and a full in-game admin panel with a live map, ride analytics, and a live handling editor.

Everything is placed and managed in-game through `/scootadmin` - no coordinates to copy into config files.

## Key Features

### Custom Scooter Vehicle

- Custom `sd_scoot` bike-class vehicle with a **standing-rider animation set** and folding stem
- **15 paint slots** plus rental customisation: trims, underglow lighting, bells, decals, and rear carriers
- Riders ring a **working bell** (default `E`) heard by players nearby
- Hinged kickstand that lowers when parked and folds away when ridden

### Rental Bunkers

- Bunker props sit **flush with the pavement** and only rise when someone rents from them
- Renting at a bunker plays a full **dispense animation** - shutter opens, ramp drops, the scooter rolls out and its stem snaps upright
- Each bunker holds a configurable **stock** of scooters; docking a ride back puts one into stock

### Charging Stations

- Modular charging rails with **1 to 4 docks** and **10 paint colours**
- Scooters glide into the dock, and a clamp locks onto the stem
- Per-dock status lens and glow: **blue** connected, **amber** charging, **green** full
- A **live pay screen** on the station totem - players walk up, pick a target charge, and pay by card or cash
- Stopping a charge early can **refund** the unused charge

### Battery Economy

| Mechanic | Default |
|---|---|
| Drain while riding | `2.5%` per minute (about 40 minutes from full) |
| Minimum charge to rent | `15%` |
| Charge rate when docked | `20%` per minute |
| Charge price | `$0.10` per percent, `$1` minimum |
| Flat scooter recovery | Collected by the fleet after `30` minutes |

### Phone App

- The **SCOOT** app registers itself with **sd-phone** and **lb-phone** - no phone edits needed
- Live map of nearby scooters, bunkers, and stations
- Unlock a nearby scooter, or rent one from a bunker with your choice of **colour and customisation**
- **Per-minute billing** with an unlock fee, and a receipt when the ride ends
- Full ride history

### Admin Panel

A React admin panel opened with `/scootadmin`:

| Tab | What it does |
|---|---|
| **Overview** | Revenue and rides today, active riders, stock, a 24-hour ride chart, and the fleet's battery spread |
| **Rides** | Live rides, revenue totals, per-bunker revenue, searchable history, and refunds |
| **Bunkers** | Place, rename, enable/disable, set stock, teleport, delete |
| **Stations** | Place, move, repaint, change dock count, release docked scooters |
| **Scooters** | Search, filter, sort, bulk actions, a 3D preview, repaint, send home, respawn |
| **Map** | Every bunker, station, scooter, and live rider, plus a ride activity layer |
| **Handling** | Live handling editor with profiles, quick-tune dials, and test rides |
| **Settings** | Pricing, ride limits, battery, and charging rules - changed live for the whole server |
| **Log** | Every change made through the panel, with who and when |

Deletions can be **undone** from the toast, and staff can be given a **view-only** panel.

### Built-in Placement Tool

- Uses the game's **native editor gizmo** - move and rotate the whole assembly as one
- Snapping, drop-to-ground, stick-to-ground, keyboard nudging, and undo/redo
- Warns when a placement floats or sits too close to another station

## File Structure

```
sd-scooters/
  bridge/
    shared/framework.lua  -- Framework detection
    server/player.lua     -- Player identifiers and names
    server/money.lua      -- Money handling
    server/keys.lua       -- Vehicle locks and keys
  client/                 -- Client logic (riding, bunkers, stations, placement, admin, app)
  server/                 -- Server logic (fleet, rentals, battery, handling, admin, database)
  shared/                 -- Shared helpers and live settings
  configs/
    config.lua            -- Config root (locale, debug)
    extras.json           -- Rental customisation options and fees
    shared/
      admin.lua           -- Admin panel, permissions, placement tool
      battery.lua         -- Drain, charging, and paid charging
      bunkers.lua         -- Bunker prop, stock, and dispense animation
      handling.lua        -- Live handling editor
      rentals.lua         -- Fees, distances, and the phone app
      scooters.lua        -- Vehicle model, plates, and paint slots
      stations.lua        -- Charging stations, docks, and the pay screen
  data/                   -- Vehicle meta files and clip sets
  locales/
    en.json               -- English
  stream/                 -- Scooter, bunker, and charging station models
  web/build/              -- Admin panel, phone app, and charger screen
  fxmanifest.lua
```

## Quick Links

- [Installation](/resources/scooters/installation) -- Get up and running
- [Configuration](/resources/scooters/configuration) -- Customize every aspect
- [Admin Panel](/resources/scooters/admin-panel) -- Placing bunkers and stations, managing the fleet
- [Rentals & Charging](/resources/scooters/rentals) -- How renting, battery, and charging work
- [Server Exports](/resources/scooters/exports-server) -- Integrate with other scripts
