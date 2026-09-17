# Client Exports

SCOOT E-Scooters provides client-side exports for reusing its placement tool in other scripts, plus a client event and state bags for reacting to rides and scooters.

## placeGhost

Open the placement tool - the same native editor gizmo the admin panel uses - for any model. The call **blocks** until the player places or cancels.

**Syntax**
```lua
local result, errKey = exports['sd-scooters']:placeGhost(kind, modelName, label)
```

| Parameter | Type | Description |
|---|---|---|
| `kind` | `string` | `'object'` or `'vehicle'` |
| `modelName` | `string` | The model to place |
| `label` | `string` | What the placement HUD calls it |

| Return | Type | Description |
|---|---|---|
| `result` | `table?` | `{ x, y, z, heading }` when placed, `nil` when cancelled, `false` when refused |
| `errKey` | `string?` | A locale key explaining why placement was refused |

**Example**
```lua
CreateThread(function()
    local spot = exports['sd-scooters']:placeGhost('object', 'prop_bench_01a', 'Bench')
    if spot then
        TriggerServerEvent('my-resource:server:saveBench', spot.x, spot.y, spot.z, spot.heading)
    end
end)
```

::: tip
Call `placeGhost` from inside a thread - it waits until the player confirms or cancels. See [Placement Tool](./admin-panel#placement-tool) for the controls.
:::

## adminRequest

Send a request to the admin panel's server bridge. The player must have admin access, and every change still needs the `sd_scoot.edit` ACE.

**Syntax**
```lua
local reply = exports['sd-scooters']:adminRequest(verb, data)
```

| Parameter | Type | Description |
|---|---|---|
| `verb` | `string` | The panel action to run |
| `data` | `table?` | The action's payload |

| Return | Type | Description |
|---|---|---|
| `reply` | `table` | `{ success, message?, data? }` |

::: info
This is the channel the admin panel itself uses. For most integrations, the [Server Exports](./exports-server) are simpler and don't depend on the player's permissions.
:::

## Events

### sd_scoot:client:rideUpdated

Fired on the rider's client whenever their ride starts or ends.

```lua
RegisterNetEvent('sd_scoot:client:rideUpdated', function(state, data)
    if state == 'started' then
        print('Ride started on ' .. data.plate)
    elseif state == 'ended' then
        print(('Ride ended: %d minutes, %d cost'):format(data.minutes, data.cost))
    end
end)
```

| Parameter | Type | Description |
|---|---|---|
| `state` | `string` | `'started'` or `'ended'` |
| `data` | `table` | The ride when started, the receipt when ended. See [sd_scoot:rideUpdated](./exports-server#sd-scoot-rideupdated) for the fields |

## State Bags

| State Bag | Scope | Value |
|---|---|---|
| `sd_scoot` | Entity (each fleet scooter) | `{ id, colour }` - use it to tell a fleet scooter apart from any other `sd_scoot` vehicle |
| `sd_scoot:bunkers` | `GlobalState` | Every enabled bunker |
| `sd_scoot:stations` | `GlobalState` | Every charging station and its docks |
| `sd_scoot:handling` | `GlobalState` | The live handling profile applied to every scooter |

**Example**
```lua
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
local fleet = Entity(vehicle).state.sd_scoot

if fleet then
    print('Riding fleet scooter #' .. fleet.id)
end
```
