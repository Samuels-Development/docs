# Configuration

All configuration for sd-scooters lives in the `configs/` directory:

- **`configs/config.lua`** -- Config root (locale, debug)
- **`configs/shared/admin.lua`** -- Admin panel, permissions, commands, placement tool
- **`configs/shared/rentals.lua`** -- Rental fees, distances, and the phone app
- **`configs/shared/battery.lua`** -- Battery drain, charging, and paid charging
- **`configs/shared/bunkers.lua`** -- Bunker prop, stock, and dispense animation
- **`configs/shared/stations.lua`** -- Charging stations, docks, and the charger screen
- **`configs/shared/scooters.lua`** -- Vehicle model, plates, and paint slots
- **`configs/shared/handling.lua`** -- Live handling editor
- **`configs/extras.json`** -- Rental customisation options and their fees

::: tip Live settings
Values marked **Live** in the tables below can also be changed from the **Settings** tab of the admin panel. Those changes apply to the whole server instantly and are stored in the database, overriding the config file. Setting a value back to its config file default removes the override.
:::

## General

```lua
local config = {
    Locale = 'en', -- lib.locale loads locales/<Locale>.json, falling back to en per-key
    Debug = true, -- log.debug lines in the console; leave off in production
    -- ...
}
```

| Setting | Default | Description |
|---|---|---|
| `Locale` | `'en'` | The locale file loaded from `locales/`. Missing keys fall back to English |
| `Debug` | `true` | Prints debug lines to the server and client console. Set to `false` on a live server |

To add a language, copy `locales/en.json` to `locales/<code>.json`, translate it, and set `Locale` to that code.

## Admin Panel

`configs/shared/admin.lua`

```lua
return {
    Command = 'scootadmin',
    Group = 'group.admin',
    ViewGroup = false,
    EditAce = 'sd_scoot.edit',
    UndoSeconds = 30,
    ActivityPoints = 400,
    FlushCommand = 'scootflush',
    FlushWaitMs = 8000,
    LiftCommand = 'scootlift',
    FlushRespawnMs = 12000,
    PlaceReach = 25.0,
    Placement = {
        SnapMove = 0.25,
        SnapTurn = 15.0,
        Nudge = 0.05,
        TurnStep = 5.0,
    },
    MapStyle = 'atlas',
    PositionsInterval = 3000,
}
```

### Permissions

| Setting | Default | Description |
|---|---|---|
| `Command` | `'scootadmin'` | Chat command that opens the panel. Grants the `command.scootadmin` ACE |
| `Group` | `'group.admin'` | ACE principal with full access - the command, every read, and every change |
| `ViewGroup` | `false` | Optional ACE principal (e.g. `'group.mod'`) that can open the panel and look, but not change anything |
| `EditAce` | `'sd_scoot.edit'` | The ACE every change requires. Granted to `Group` automatically - add it to other principals to let them edit |

### Panel and Commands

| Setting | Default | Description |
|---|---|---|
| `UndoSeconds` | `30` | How long a deleted bunker, station, or scooter can be restored from its toast |
| `ActivityPoints` | `400` | Recent ride start and end points drawn on the Map tab's activity layer |
| `MapStyle` | `'atlas'` | Map tiles the Map tab opens with: `'atlas'` or `'satellite'` |
| `PositionsInterval` | `3000` | Milliseconds between live scooter position updates while the Map tab is open |
| `FlushCommand` | `'scootflush'` | Rebuilds station props and respawns idle scooters on every client |
| `FlushWaitMs` | `8000` | Milliseconds a client waits for models to unload during a flush |
| `FlushRespawnMs` | `12000` | Milliseconds before the idle fleet respawns after a flush. Must be higher than `FlushWaitMs` |
| `LiftCommand` | `'scootlift'` | Debug command: `/scootlift [metres]` holds the nearest bunker above ground on your client |

### Placement Tool

| Setting | Default | Description |
|---|---|---|
| `PlaceReach` | `25.0` | Metres ahead of the camera a new placement starts when nothing closer is in view |
| `Placement.SnapMove` | `0.25` | Metres per step while snapping is on |
| `Placement.SnapTurn` | `15.0` | Degrees per step while snapping is on |
| `Placement.Nudge` | `0.05` | Metres per frame the arrow keys and Page Up/Down move the placement (`Shift` x5) |
| `Placement.TurnStep` | `5.0` | Degrees per mouse-wheel notch (`Shift` + wheel: 15, `Ctrl` + wheel: 1) |

## Rentals

`configs/shared/rentals.lua`

```lua
return {
    Enabled = true,
    UnlockFee = 5,
    PerMinute = 1,
    Account = 'bank',
    Currency = '$',
    RentDistance = 12.0,
    StationDistance = 12.0,
    DockDistance = 12.0,
    NearbyRadius = 600.0,
    LockIdle = true,
    MaxRideMinutes = 180,
    RefreshMs = 2500,

    App = {
        identifier = 'scoot_external',
        name = 'SCOOT',
        description = 'Rent an e-scooter near you',
        developer = 'SCOOT Mobility',
        size = 4096,
        defaultApp = true,
        wifi = false,
        ForceCustom = true,
    },
}
```

### Pricing and Rides

| Setting | Default | Live | Description |
|---|---|---|---|
| `Enabled` | `true` | | Registers the phone app and the rental system. Requires a framework for payments |
| `UnlockFee` | `5` | Yes | Charged when a ride starts, plus the fee of any customisation picked |
| `PerMinute` | `1` | Yes | Charged per started minute when the ride ends |
| `Account` | `'bank'` | Yes | Where rental fees are taken from: `'bank'` or `'cash'` |
| `Currency` | `'$'` | | Symbol the app shows in front of prices |
| `MaxRideMinutes` | `180` | Yes | Rides older than this are ended and billed automatically |
| `LockIdle` | `true` | Yes | Locks scooters nobody is renting, so they can only be ridden through the app |
| `RefreshMs` | `2500` | | Milliseconds between the app's live map refreshes |

### Distances

| Setting | Default | Live | Description |
|---|---|---|---|
| `RentDistance` | `12.0` | Yes | Metres the player must be from a scooter to unlock it |
| `StationDistance` | `12.0` | Yes | Metres the player must be from a bunker to have it dispense a scooter |
| `DockDistance` | `12.0` | Yes | Ending a ride this close to a bunker docks the scooter back into it |
| `NearbyRadius` | `600.0` | Yes | Metres around the player the app lists scooters and bunkers in |

### Phone App

| Setting | Default | Description |
|---|---|---|
| `App.identifier` | `'scoot_external'` | Unique app identifier registered with the phone |
| `App.name` | `'SCOOT'` | App name shown on the phone |
| `App.description` | `'Rent an e-scooter near you'` | App Store description |
| `App.developer` | `'SCOOT Mobility'` | App Store developer name |
| `App.size` | `4096` | App size in KB shown in the App Store |
| `App.defaultApp` | `true` | Pre-install the app on every phone |
| `App.wifi` | `false` | When `false`, the app works without signal so a ride can always be ended |

## Battery

`configs/shared/battery.lua`

```lua
return {
    Enabled = true,
    DrainPerMinute = 2.5,
    MinToRent = 15,
    ChargePerMinute = 20,
    FullAt = 100,
    FlatRecoverMinutes = 30,
    AdoptedLevel = 55,
    TickSeconds = 60,

    Paid = {
        Enabled = true,
        Account = 'bank',
        PricePerPercent = 0.1,
        MinimumFee = 1,
        Step = 5,
        Presets = { 50, 75, 100 },
        RefundOnStop = true,
    },
}
```

### Battery

| Setting | Default | Live | Description |
|---|---|---|---|
| `Enabled` | `true` | | When `false`, every scooter stays at 100% and the battery is hidden from the app |
| `DrainPerMinute` | `2.5` | Yes | Percent drained per ride minute (`2.5` is about 40 minutes from full) |
| `MinToRent` | `15` | Yes | Scooters below this percent show "Needs charge" and cannot be unlocked |
| `ChargePerMinute` | `20` | Yes | Percent gained per minute while docked (`20` is 5 minutes to full) |
| `FullAt` | `100` | | Percent at which the dock lens turns green |
| `FlatRecoverMinutes` | `30` | Yes | Minutes a flat scooter waits in the street before the fleet collects it |
| `AdoptedLevel` | `55` | Yes | Battery a scooter that was not part of the fleet starts with when someone docks it |
| `TickSeconds` | `60` | | Seconds between battery updates (`10`-`300`) |

### Paid Charging

Charging is a paid service chosen on the station screen. A docked scooter only charges once someone picks a target percent and pays for it, and charging stops at that target.

| Setting | Default | Live | Description |
|---|---|---|---|
| `Paid.Enabled` | `true` | Yes | When `false`, every docked scooter charges to full for free |
| `Paid.Account` | `'bank'` | Yes | Where charging is paid from: `'bank'` or `'cash'` |
| `Paid.PricePerPercent` | `0.1` | Yes | Price per percent of charge bought. The bill is rounded up to whole currency |
| `Paid.MinimumFee` | `1` | Yes | The smallest bill for any charge |
| `Paid.Step` | `5` | Yes | The target percent moves in steps of this size on the screen |
| `Paid.Presets` | `{ 50, 75, 100 }` | | One-tap targets offered on the screen (only those above the current level show) |
| `Paid.RefundOnStop` | `true` | Yes | Stopping a charge early refunds the undelivered percent, rounded down |

## Bunkers

`configs/shared/bunkers.lua`

```lua
return {
    Model = 'sd_scoot_bunker2',
    StreamDistance = 250.0,
    RiseDepth = 1.05,
    Stock = 5,
    DispenseRadius = 200.0,

    Dispense = { ... },
    Lights = { ... },

    Seed = {
        { name = 'Legion Square', x = 195.2, y = -933.8, z = 30.69, heading = 0.0 },
    },
}
```

| Setting | Default | Live | Description |
|---|---|---|---|
| `Model` | `'sd_scoot_bunker2'` | | The bunker prop model |
| `StreamDistance` | `250.0` | | Metres from a bunker at which its prop is created and removed |
| `RiseDepth` | `1.05` | | Metres the bunker sits below ground when parked |
| `Stock` | `5` | Yes | Scooters a newly created bunker holds. Docking a ride puts one back |
| `DispenseRadius` | `200.0` | | Metres around a bunker in which players see the dispense animation |
| `Seed` | Legion Square | | Bunkers inserted on first start when the table is empty. Not re-read afterwards |

::: warning
The `Dispense` and `Lights` blocks are timed and positioned to match the bunker model and its animation. Changing them will misalign the animation - leave them at their defaults unless you are replacing the model.
:::

## Charging Stations

`configs/shared/stations.lua`

Most of this file describes the charging station model - dock geometry, animation timings, and lens offsets. These values are matched to the models and should be left alone. The settings below are the ones you are likely to change.

```lua
return {
    Colours = { ... },
    DefaultColour = 1,
    StreamDistance = 250.0,
    Slots = 4,
    MaxSlots = 4,

    Glow = {
        idle = { 60, 120, 255 },
        charging = { 255, 150, 20 },
        full = { 60, 255, 120 },
        range = 1.2,
        intensity = 0.8,
        PulseMs = 1800,
        PulseMin = 0.35,
    },

    Dock = {
        Key = 38,
        PromptDistance = 3.0,
    },

    Screen = {
        Range = 12.0,
        Payment = {
            Methods = { 'bank', 'cash' },
        },
        WakeMs = 120000,
        Brightness = 1.0,
        RefreshMs = 500,
        View = {
            Label = 'View charger screen',
            Icon = 'fa-solid fa-charging-station',
            Distance = 2.5,
            CloseAfterUnlockMs = 1500,
            -- ...
        },
    },

    Seed = {},
}
```

### Stations

| Setting | Default | Description |
|---|---|---|
| `Colours` | 10 colours | Paint options for a station, picked when placing it |
| `DefaultColour` | `1` | The colour a station gets when none is picked (Teal) |
| `StreamDistance` | `250.0` | Metres from a station at which its props are created and removed |
| `Slots` | `4` | Docks a newly placed station gets unless the admin picks another count |
| `MaxSlots` | `4` | The most docks a station can have |
| `Seed` | `{}` | Stations inserted on first start when the table is empty |

### Dock Glow

| Setting | Default | Description |
|---|---|---|
| `Glow.idle` | `{ 60, 120, 255 }` | RGB glow for a docked scooter that is not charging |
| `Glow.charging` | `{ 255, 150, 20 }` | RGB glow while charging (breathing) |
| `Glow.full` | `{ 60, 255, 120 }` | RGB glow when fully charged |
| `Glow.range` | `1.2` | Light range in metres |
| `Glow.intensity` | `0.8` | Light intensity |
| `Glow.PulseMs` | `1800` | Length of one breath of the charging glow |

Set `Glow = nil` to disable the dock lights entirely.

### Docking

| Setting | Default | Description |
|---|---|---|
| `Dock.Key` | `38` | Control held to dock a scooter when the prompt shows (`38` = `E`) |
| `Dock.PromptDistance` | `3.0` | Metres between the scooter and the nearest free dock at which the prompt appears (`1.5`-`6`) |

### Charger Screen

| Setting | Default | Description |
|---|---|---|
| `Screen.Range` | `12.0` | Metres within which a screen shows the nearest station. Beyond this it shows the idle logo |
| `Screen.Payment.Methods` | `{ 'bank', 'cash' }` | Payment options on the screen. `'bank'` shows as Card. The first is preselected |
| `Screen.WakeMs` | `120000` | Milliseconds the dock list stays up after the screen is used, before the idle loop returns |
| `Screen.Brightness` | `1.0` | `0`-`1`, dims the screen page. Lower it if the screen glows too brightly at night |
| `Screen.RefreshMs` | `500` | How often the screen re-picks the nearest station |
| `Screen.View.Label` | `'View charger screen'` | Target option label on the station totem |
| `Screen.View.Distance` | `2.5` | Metres the target option is usable from |
| `Screen.View.CloseAfterUnlockMs` | `1500` | How long the screen view stays open after a successful unlock |

::: info
Every charger screen shares one page that shows the station nearest the player. Keep stations **at least 25 m apart** so they don't show each other's docks.
:::

## Scooters

`configs/shared/scooters.lua`

```lua
return {
    Model = 'sd_scoot',
    PlatePrefix = 'SCOOT',
    SaveInterval = 60,
    HealInterval = 30,
    KeepOnRestart = false,
    GroundClearance = 0.379,
    BunkerOffset = vec3(0.0, -1.6, 0.0),
    SpeedUnit = 'mph',
    Colours = {
        { name = 'Black', primary = 0, hex = '#0d1116' },
        { name = 'White', primary = 134, hex = '#f4f4f4' },
        -- ... 15 colours total
    },
}
```

| Setting | Default | Description |
|---|---|---|
| `Model` | `'sd_scoot'` | The scooter vehicle model |
| `PlatePrefix` | `'SCOOT'` | Plates are the prefix plus a 3-digit number: `SCOOT001`, `SCOOT002`, ... |
| `SaveInterval` | `60` | Seconds between position saves for scooters that moved |
| `HealInterval` | `30` | Seconds between checks for missing scooters, which are respawned |
| `KeepOnRestart` | `false` | When `false`, scooters left in the world are removed on resource start and dispensed ones return to their bunker's stock. Only scooters docked at a station survive. `true` keeps every scooter where it was |
| `SpeedUnit` | `'mph'` | `'mph'` or `'kmh'` - the unit the handling editor's test ride reports |
| `Colours` | 15 colours | Paint slots. `primary` is the GTA colour index, `hex` is the swatch shown in the panel. Must stay in the same order as `data/carvariations.meta` |

## Handling Editor

`configs/shared/handling.lua`

```lua
return {
    Enabled = true,
    ReturnKey = 'F7',
    TelemetryMs = 100,
    ApplyEveryMs = 1000,
    HistoryLimit = 60,

    Presets = { ... },
    Templates = {
        { name = 'Relaxed (25 mph)', values = { ... } },
        { name = 'Rental (40 mph)', values = { ... } },
        { name = 'Sport (55 mph)', values = { ... } },
    },
    Groups = { ... },
}
```

| Setting | Default | Description |
|---|---|---|
| `Enabled` | `true` | When `false`, hides the Handling tab and stops clients applying saved profiles |
| `ReturnKey` | `'F7'` | Key that brings the panel back from a test ride (players can rebind it) |
| `TelemetryMs` | `100` | Milliseconds between speed readouts on the test-ride HUD |
| `ApplyEveryMs` | `1000` | Milliseconds between client checks that apply the live handling to newly streamed scooters |
| `HistoryLimit` | `60` | Change log entries kept per handling profile |
| `Presets` | 5 dials | The Quick Tune dials - top speed, acceleration, grip, braking, and lean - and the raw value ranges they map to |
| `Templates` | 3 templates | Starting points offered when creating a new profile |
| `Groups` | 7 groups | Every editable handling field with its slider range. The server clamps saved values to these ranges |

See [Handling Editor](./admin-panel#handling-editor) for how profiles work.

## Rental Customisation

`configs/extras.json`

Players can customise the scooter they rent from a bunker. Each option carries a `fee` that is added to the unlock fee.

| Category | Options |
|---|---|
| `rear` | None, Rear carrier (`$2`), Delivery bag + rack (`$5`) |
| `trim` | Original teal, Stealth black, Brushed silver, Burnt orange, Lime, Violet (`$1` each) |
| `lighting` | Off, plus 15 underglow colours (`$2` each) |
| `bell` | Classic, Black (`$1`), Electronic (`$1`) |
| `decal` | None, Racing stripes, Race number, Custom name (`$1` each) |

```json
"rear": [
  { "id": "none", "label": "None", "fee": 0 },
  { "id": "rack", "label": "Rear carrier", "fee": 2 },
  { "id": "delivery", "label": "Delivery bag + rack", "fee": 5 }
]
```

The file also holds `defaults` (the options pre-selected for a new rental) and `presets` - one-tap looks such as **Commuter**, **Night Rider**, and **Courier**.

::: warning
You can change an option's `label` and `fee` freely. Don't rename an `id` or add new options - each one maps to a streamed model on the scooter.
:::
