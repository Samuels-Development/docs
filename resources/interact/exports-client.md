# Client Exports

Every export is client side. The `data` table the `add*` exports take, and the option fields inside it, are explained on [Adding Prompts](./adding-prompts).

## addCoords

A point at fixed coordinates.

**Syntax**
```lua
local id = exports['sd-interact']:addCoords(coords, data)
```

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` \| `{ x, y, z }` | Where the prompt opens. A `vector4`'s heading is ignored |
| `data` | `table` | `{ options, distance?, interactDistance?, offset?, lineOfSight?, allowInVehicle?, groups?, name? }` |

| Return | Type | Description |
|---|---|---|
| `id` | `integer?` | The point's id, or `nil` if `coords` was unusable |

**Example**
```lua
local id = exports['sd-interact']:addCoords(vec3(441.0, -978.0, 30.7), {
    options = { { label = 'Open the locker', icon = 'fa-solid fa-box-open', onSelect = openLocker } },
})
```

## addLocalEntity

A point on an entity handle on this client: a ped or prop you spawned, a vehicle.

**Syntax**
```lua
local id = exports['sd-interact']:addLocalEntity(entity, data)
```

| Parameter | Type | Description |
|---|---|---|
| `entity` | `integer` | The entity handle |
| `data` | `table` | As `addCoords`, plus `offset` (in the entity's own space) or `bone` (a bone name, or a ped bone id) |

| Return | Type | Description |
|---|---|---|
| `id` | `integer?` | The point's id, or `nil` if `entity` was 0 or not a number |

**Example**
```lua
exports['sd-interact']:addLocalEntity(ped, {
    offset = vec3(0.0, 0.0, 0.3),
    options = { { label = 'Talk', icon = 'message-circle', onSelect = talk } },
})
```

## addEntity

A point on a networked entity, by its network id. It follows the entity as it streams in and out.

**Syntax**
```lua
local id = exports['sd-interact']:addEntity(netId, data)
```

| Parameter | Type | Description |
|---|---|---|
| `netId` | `integer` | The entity's network id |
| `data` | `table` | As `addLocalEntity` |

| Return | Type | Description |
|---|---|---|
| `id` | `integer?` | The point's id |

## addModel

A point on every entity of these models near the player.

**Syntax**
```lua
local id = exports['sd-interact']:addModel(models, data)
```

| Parameter | Type | Description |
|---|---|---|
| `models` | `string` \| `integer` \| `(string \| integer)[]` | Model names or hashes |
| `data` | `table` | As `addLocalEntity` |

| Return | Type | Description |
|---|---|---|
| `id` | `integer` | The point's id |

**Example**
```lua
exports['sd-interact']:addModel({ 'prop_atm_01', 'prop_atm_02', 'prop_atm_03', 'prop_fleeca_atm' }, {
    options = { { label = 'Use the ATM', icon = 'fa-solid fa-credit-card', event = 'mybank:openAtm' } },
})
```

## addGlobalVehicle / addGlobalPed / addGlobalObject / addGlobalPlayer

A point on every vehicle, ped, object or other player near the player.

**Syntax**
```lua
local id = exports['sd-interact']:addGlobalVehicle(data)
local id = exports['sd-interact']:addGlobalPed(data)
local id = exports['sd-interact']:addGlobalObject(data)
local id = exports['sd-interact']:addGlobalPlayer(data)
```

| Parameter | Type | Description |
|---|---|---|
| `data` | `table` | As `addLocalEntity`. Give it a `name` so `removeGlobal*` can remove it |

| Return | Type | Description |
|---|---|---|
| `id` | `integer` | The point's id |

## update

Change a point without removing it.

**Syntax**
```lua
local updated = exports['sd-interact']:update(id, data)
```

| Parameter | Type | Description |
|---|---|---|
| `id` | `integer` | The point's id |
| `data` | `table` | Any of `options`, `distance`, `interactDistance`, `lineOfSight`, `groups`; `coords` (coords points); `entity` (local entity points) |

| Return | Type | Description |
|---|---|---|
| `updated` | `boolean` | `false` if there is no such point |

## remove

**Syntax**
```lua
local removed = exports['sd-interact']:remove(id)
```

| Return | Type | Description |
|---|---|---|
| `removed` | `boolean` | `false` if there was no such point |

## removeLocalEntity / removeEntity / removeModel

Remove the points on an entity or model. With a `name`, only the points registered under that name.

**Syntax**
```lua
exports['sd-interact']:removeLocalEntity(entity, name)
exports['sd-interact']:removeEntity(netId, name)
exports['sd-interact']:removeModel(models, name)
```

| Parameter | Type | Description |
|---|---|---|
| `entity` / `netId` / `models` | | As the matching `add*` |
| `name` | `string?` | Only points with this `name` |

| Return | Type | Description |
|---|---|---|
| `count` | `integer` | How many points went |

## removeGlobalVehicle / removeGlobalPed / removeGlobalObject / removeGlobalPlayer

**Syntax**
```lua
exports['sd-interact']:removeGlobalVehicle(name)
```

| Parameter | Type | Description |
|---|---|---|
| `name` | `string?` | Only global points with this `name`; without it, every global point of that kind |

## disable

Switch every prompt off for as long as your resource needs (a minigame, a cutscene, your own menu). Prompts come back when no resource has them switched off, and a resource's switch is cleared when it stops.

**Syntax**
```lua
exports['sd-interact']:disable(off)
```

| Parameter | Type | Description |
|---|---|---|
| `off` | `boolean` | `true` hides them, `false` gives them back |

## getFocus

The prompt that is open right now.

**Syntax**
```lua
local focus = exports['sd-interact']:getFocus()
```

| Return | Type | Description |
|---|---|---|
| `focus` | `table?` | `{ id, entity, coords, option }`, or `nil` when no prompt is open. `option` is the selected option's index (1 is the first) |

**Example**
```lua
local focus = exports['sd-interact']:getFocus()
if focus and focus.entity then
    print(('looking at entity %d, option %d'):format(focus.entity, focus.option))
end
```
