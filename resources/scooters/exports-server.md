# Server Exports

SCOOT E-Scooters provides server-side exports for managing bunkers, stations, and the fleet programmatically, and a rental API for phones and other scripts.

::: info Return values
Management exports that change something return `ok` (or the new row) on success, and `false, errKey` on failure. `errKey` is a locale key from `locales/en.json`, e.g. `'err.no_bunker'`.
:::

## Rental API

Every rental export takes the player's server ID and returns the same reply shape the phone app uses, so a UI can use it directly:

```lua
{ success = true, data = { ... } }
{ success = false, message = 'Localised error message' }
```

### getRentalSnapshot

Everything the app shows around a player: nearby scooters and bunkers with distances, the player's coordinates, pricing, and their active ride.

**Syntax**
```lua
local reply = exports['sd-scooters']:getRentalSnapshot(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

### rentScooter

Start a ride on a parked scooter. The scooter must be available, charged enough, and within `RentDistance` of the player. The unlock fee is charged.

**Syntax**
```lua
local reply = exports['sd-scooters']:rentScooter(source, scooterId)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `scooterId` | `number` | The scooter ID |

**Example**
```lua
local reply = exports['sd-scooters']:rentScooter(source, 12)
if reply.success then
    print(('Ride started on %s'):format(reply.data.plate))
else
    print('Could not rent: ' .. reply.message)
end
```

### rentAtBunker

Rent a scooter from a bunker. The bunker plays its dispense animation and the ride starts on the scooter it dispenses. The unlock fee plus the customisation fees are charged.

**Syntax**
```lua
local reply = exports['sd-scooters']:rentAtBunker(source, bunkerId, colour, customization)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `bunkerId` | `number` | The bunker ID |
| `colour` | `number` | Paint slot index from `Config.Scooters.Colours` |
| `customization` | `table?` | Options from `configs/extras.json`, e.g. `{ trim = 'black', rear = 'rack' }` |

### endRide

End the player's active ride. The ride is billed and the scooter docks at a nearby station or bunker, or stays parked.

**Syntax**
```lua
local reply = exports['sd-scooters']:endRide(source)
```

| Return (`reply.data`) | Type | Description |
|---|---|---|
| `plate` | `string` | The scooter's plate |
| `minutes` | `number` | Minutes ridden |
| `cost` | `number` | Per-minute cost of the ride |
| `paid` | `boolean` | Whether the rider could pay |
| `docked` | `string?` | Name of the station or bunker it docked at |
| `charging` | `boolean` | Whether it docked at a charging station |
| `battery` | `number?` | Battery level at the end of the ride |

### getCurrentRide

Get the player's active ride.

**Syntax**
```lua
local reply = exports['sd-scooters']:getCurrentRide(source)
local ride = reply.data.ride -- nil when not riding
```

| Field (`ride`) | Type | Description |
|---|---|---|
| `id` | `number` | Ride ID |
| `scooterId` | `number` | Scooter ID |
| `plate` | `string` | Scooter plate |
| `battery` | `number?` | Current battery level |
| `startedAt` | `number` | Start time (unix seconds) |
| `minutes` | `number` | Minutes ridden so far |
| `cost` | `number` | Per-minute cost so far |
| `extraFee` | `number` | Customisation fees paid at unlock |

### getRideHistory

Get the player's past rides.

**Syntax**
```lua
local reply = exports['sd-scooters']:getRideHistory(source)
local rides = reply.data.rides
```

### getRentalPricing

Get the current rental pricing. Takes no player and returns a plain table.

**Syntax**
```lua
local pricing = exports['sd-scooters']:getRentalPricing()
```

| Return | Type | Description |
|---|---|---|
| `unlock` | `number` | Unlock fee |
| `perMinute` | `number` | Price per minute |
| `currency` | `string` | Currency symbol |
| `rentDistance` | `number` | Unlock distance in metres |
| `refreshMs` | `number` | App refresh interval |
| `enabled` | `boolean` | Whether rentals are enabled |

### getActiveRentals

List every ride in progress.

**Syntax**
```lua
local rides = exports['sd-scooters']:getActiveRentals()
```

| Field | Type | Description |
|---|---|---|
| `renter` | `string` | The renter's identifier (citizenid on QBCore/Qbox, identifier on ESX) |
| `scooterId` | `number` | Scooter ID |
| `startedAt` | `number` | Start time (unix seconds) |

## Bunkers

### getBunkers

Get every bunker, sorted by ID.

**Syntax**
```lua
local bunkers = exports['sd-scooters']:getBunkers()
```

### createBunker

Create a bunker.

**Syntax**
```lua
local row, errKey = exports['sd-scooters']:createBunker(data, createdBy)
```

| Parameter | Type | Description |
|---|---|---|
| `data` | `table` | `{ name, x, y, z, heading }` |
| `createdBy` | `string?` | A tag recorded as the creator, e.g. your resource name |

**Example**
```lua
local bunker, err = exports['sd-scooters']:createBunker({
    name = 'Pillbox Hill',
    x = 298.4, y = -584.2, z = 43.26, heading = 70.0,
}, 'my-resource')

if not bunker then print('Failed: ' .. err) end
```

### renameBunker / setBunkerEnabled / deleteBunker

```lua
local ok, errKey = exports['sd-scooters']:renameBunker(id, name)
local ok, errKey = exports['sd-scooters']:setBunkerEnabled(id, enabled)
local ok, errKey = exports['sd-scooters']:deleteBunker(id)
```

### setBunkerStock / adjustBunkerStock

Set a bunker's stock to an exact count (`0`-`999`), or change it by a delta (never below zero).

```lua
local ok, errKey = exports['sd-scooters']:setBunkerStock(id, stock)
local newStock = exports['sd-scooters']:adjustBunkerStock(id, delta) -- nil when the bunker is unknown
```

## Charging Stations

### getStations

Get every station, sorted by ID. Each includes an `occupied` count of taken docks.

**Syntax**
```lua
local stations = exports['sd-scooters']:getStations()
```

### createStation

Create a charging station.

**Syntax**
```lua
local row, errKey = exports['sd-scooters']:createStation(data, createdBy)
```

| Parameter | Type | Description |
|---|---|---|
| `data` | `table` | `{ name, x, y, z, heading, count? }` - `count` is the number of docks (defaults to `Config.Stations.Slots`) |
| `createdBy` | `string?` | A tag recorded as the creator |

### moveStation

Move a station, and every scooter docked in it, to a new position.

```lua
local ok, errKey = exports['sd-scooters']:moveStation(id, { x = x, y = y, z = z, heading = heading })
```

### setStationSlots

Change a station's dock count (`1`-`MaxSlots`). A station can only be shortened past empty docks.

```lua
local ok, errKey = exports['sd-scooters']:setStationSlots(id, count)
```

### setStationColour

Repaint a station. `colour` is an index into `Config.Stations.Colours`.

```lua
local ok, errKey = exports['sd-scooters']:setStationColour(id, colour)
```

### renameStation / setStationEnabled / deleteStation

```lua
local ok, errKey = exports['sd-scooters']:renameStation(id, name)
local ok, errKey = exports['sd-scooters']:setStationEnabled(id, enabled)
local ok, errKey = exports['sd-scooters']:deleteStation(id)
```

Deleting a station leaves its docked scooters standing where they were.

## Scooters

### getScooters

Get every scooter, sorted by ID.

**Syntax**
```lua
local scooters = exports['sd-scooters']:getScooters()
```

### getScooterPositions

Live positions of every scooter, cheap enough to poll every few seconds.

**Syntax**
```lua
local positions = exports['sd-scooters']:getScooterPositions()
-- { { id, x, y, z, heading }, ... }
```

### createScooter

Create and spawn a scooter at explicit coordinates.

**Syntax**
```lua
local scooter, errKey = exports['sd-scooters']:createScooter(data, createdBy)
```

| Parameter | Type | Description |
|---|---|---|
| `data` | `table` | `{ x, y, z, heading, colour, bunkerId? }` |
| `createdBy` | `string?` | A tag recorded as the creator |

### spawnScooterAtBunker

Create and spawn a scooter in front of a bunker.

**Syntax**
```lua
local scooter, errKey = exports['sd-scooters']:spawnScooterAtBunker(bunkerId, colour, createdBy)
```

### deleteScooter / respawnScooter

Delete a scooter, or recreate its vehicle at its stored position (after it was destroyed, deleted by another script, or fell out of the world).

```lua
local ok, errKey = exports['sd-scooters']:deleteScooter(id)
local ok, errKey = exports['sd-scooters']:respawnScooter(id)
```

### setScooterColour / setScooterLocked / setScooterBattery

```lua
local ok, errKey = exports['sd-scooters']:setScooterColour(id, colour)  -- index into Config.Scooters.Colours
local ok, errKey = exports['sd-scooters']:setScooterLocked(id, locked)  -- lock or unlock for everyone
local ok, errKey = exports['sd-scooters']:setScooterBattery(id, level)  -- 0-100
```

### getScooterBattery

Get a scooter's battery level.

**Syntax**
```lua
local level = exports['sd-scooters']:getScooterBattery(id) -- nil when the scooter is unknown
```

## Events

### sd_scoot:rideUpdated

Fired on the server whenever a ride starts or ends.

```lua
AddEventHandler('sd_scoot:rideUpdated', function(source, state, data)
    if state == 'started' then
        print(('%s started a ride on %s'):format(GetPlayerName(source), data.plate))
    elseif state == 'ended' then
        print(('%s rode %d minutes and paid %d'):format(GetPlayerName(source), data.minutes, data.cost))
    end
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The rider's server ID |
| `state` | `string` | `'started'` or `'ended'` |
| `data` | `table` | The ride (same fields as [getCurrentRide](#getcurrentride)) when started, the receipt (same fields as [endRide](#endride)) when ended. A ride that ended because the battery ran out has `flat = true` |
