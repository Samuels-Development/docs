# Rentals & Charging

This page explains how players rent, ride, dock, and charge scooters. Configuration is split across `configs/shared/rentals.lua`, `configs/shared/battery.lua`, and `configs/extras.json`.

## How It Works

1. **Open the SCOOT app** on the phone to see nearby scooters, bunkers, and charging stations on a live map
2. **Rent a scooter** - unlock one parked nearby, rent one from a bunker, or unlock one from a charging station's screen
3. **Pay the unlock fee** - taken when the ride starts, plus the fee of any customisation picked
4. **Ride** - the battery drains while you ride
5. **End the ride** - from the app, or by docking at a charging station
6. **Pay per minute** - the ride is billed per started minute and a receipt is shown

::: info
A player can only have **one active ride** at a time. Rides older than `MaxRideMinutes` (default 180) are ended and billed automatically.
:::

## Renting a Scooter

There are three ways to start a ride:

| Method | Where | Distance Rule |
|---|---|---|
| **Unlock nearby** | Any available scooter parked in the world, from the app | Within `RentDistance` (12 m) |
| **Rent at a bunker** | A rental bunker, from the app | Within `StationDistance` (12 m) |
| **Unlock at a station** | A docked scooter, from the charging station's screen | Within `RentDistance` (12 m) of the station |

Scooters below `Battery.MinToRent` (default 15%) show **Needs charge** and cannot be unlocked.

### Bunker Dispensing

Renting at a bunker takes one scooter from its **stock**. The bunker rises out of the pavement, opens its shutter, lowers a ramp, and pushes the scooter out. Its stem then snaps upright and the ride begins. Everyone within `DispenseRadius` (200 m) sees the same animation.

A bunker with no stock left cannot dispense. Stock is refilled when rides are docked back into it, or set directly from the **Bunkers** tab of the admin panel.

### Customisation

When renting at a bunker, players pick a paint colour and can customise the scooter. Each option adds its fee to the unlock fee:

| Category | Options | Fee |
|---|---|---|
| **Rear** | Rear carrier, Delivery bag + rack | `$2` / `$5` |
| **Trim** | Stealth black, Brushed silver, Burnt orange, Lime, Violet | `$1` |
| **Lighting** | 15 underglow colours | `$2` |
| **Bell** | Black, Electronic | `$1` |
| **Decal** | Racing stripes, Race number, Custom name | `$1` |

Three one-tap presets are included: **Commuter**, **Night Rider**, and **Courier**. Labels and fees are set in `configs/extras.json` - see [Rental Customisation](./configuration#rental-customisation).

## Riding

- Riders use a custom **standing** animation set
- Press **`E`** (rebindable) to ring the bell. Nearby players hear it
- Idle scooters are **locked** (`LockIdle`), so they can only be ridden through the app
- With `qbx_vehiclekeys` running, the renter is handed the keys for the ride

## Ending a Ride

End the ride from the app, or dock the scooter at a charging station. Where the scooter goes depends on where the ride ends:

| Ride Ends | What Happens |
|---|---|
| Within `DockDistance` of a charging station with a free dock | The scooter glides into the dock and starts charging (if paid charging allows it) |
| Within `DockDistance` of a bunker | The scooter goes back into the bunker's stock |
| Anywhere else | The scooter stays parked where it stopped, locked and available to the next renter |

### Docking at a Station

Ride up to a charging station and a prompt appears once you're within `Dock.PromptDistance` (3 m) of a free dock. Hold **`E`** to dock. Docking your own rental ends the ride. Docking an unrented fleet scooter parks it in the dock. Docking a scooter that isn't part of the fleet adds it to the fleet.

### Billing

The per-minute cost is taken when the ride ends. A scooter can't be held hostage by an empty account - if the rider can't pay, the ride still ends and is recorded as **unpaid** in the admin panel's ride history.

If a rider disconnects mid-ride, the ride is closed automatically and the scooter is freed.

## Battery

| Mechanic | Default | Setting |
|---|---|---|
| Drain while riding | `2.5%` per minute | `DrainPerMinute` |
| Minimum charge to rent | `15%` | `MinToRent` |
| Charge rate when docked | `20%` per minute | `ChargePerMinute` |
| Flat scooter recovery | `30` minutes | `FlatRecoverMinutes` |

### Running Flat

When a scooter's battery reaches **0%** mid-ride, the ride ends and is billed as normal, and the rider is notified. The scooter locks where it stands as **flat**. After `FlatRecoverMinutes` the fleet collects it.

## Charging

Every charging station has a **pay screen** on its totem. Walk up to it and use the **View charger screen** target option (or the text prompt without `ox_target`) to open a close-up view with a mouse cursor.

From the screen, players can:

- See every dock with its scooter's plate and battery level
- **Buy a charge** - pick a target percent (or a preset like 50 / 75 / 100) and pay by card or cash
- **Raise** an active charge target - only the added percent is billed
- **Stop** a charge early - the undelivered percent is refunded when `RefundOnStop` is enabled
- **Unlock** a docked scooter to start a ride

### Pricing

```lua
Paid = {
    Enabled = true,
    Account = 'bank',
    PricePerPercent = 0.1,
    MinimumFee = 1,
    Step = 5,
    Presets = { 50, 75, 100 },
    RefundOnStop = true,
},
```

The bill is the percent bought times `PricePerPercent`, rounded up, and never less than `MinimumFee`. With the defaults, charging from 20% to 100% costs **$8**.

::: tip Free charging
Set `Battery.Paid.Enabled = false` and every docked scooter charges to full for free, with no screen purchase needed.
:::

### Dock Lights

Each occupied dock shows its state on the status lens and with a matching glow:

| Colour | State |
|---|---|
| **Blue** | Docked and connected, not charging |
| **Amber** (breathing) | Charging |
| **Green** | Full |
