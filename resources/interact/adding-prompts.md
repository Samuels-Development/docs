# Adding Prompts

Everything a resource does with `sd-interact` is two things: register **points**, and give each point **options**. This page walks through both. Every export is listed with its parameters on [Client Exports](./exports-client), and [Examples](./examples) has complete snippets.

All of it is client side: call the exports from a client script.

## Points

A point is where a prompt opens. There are five kinds:

| Export | The prompt opens on |
|---|---|
| `addCoords(coords, data)` | Fixed coordinates |
| `addLocalEntity(entity, data)` | An entity handle on this client: a ped or prop you spawned, a vehicle |
| `addEntity(netId, data)` | A networked entity by its network id, wherever it streams in |
| `addModel(models, data)` | Every entity of these models near the player |
| `addGlobalVehicle(data)`, `addGlobalPed`, `addGlobalObject`, `addGlobalPlayer` | Every vehicle, ped, object or other player near the player |

Each one returns the point's id (or `nil` when its coordinates or entity were unusable). A point belongs to the resource that added it, and goes away when that resource stops: there is nothing to clean up on restart.

```lua
local id = exports['sd-interact']:addCoords(vec3(441.0, -978.0, 30.7), {
    options = {
        { label = 'Open the locker', icon = 'fa-solid fa-box-open', onSelect = openLocker },
    },
})
```

### Distances

Two distances decide when a point shows up:

| Field | Default | |
|---|---|---|
| `distance` | `7.0` | Within this many metres the point shows as a dot |
| `interactDistance` | `2.6` | Within this many metres its prompt can open |

A point is measured to its middle, but players reach for its near side: a shopkeeper behind a counter, the door of a car. So a little slack (`Slack`, 0.75 m by default) is added to every distance a prompt is allowed at. The defaults and the slack are in [Configuration](./configuration).

### Where the prompt sits

| Field | |
|---|---|
| `offset` | `vec3` from the entity, in the entity's own space (x right, y forward, z up). For a coords point, it is added to the coords |
| `bone` | A bone name (`'boot'`, `'door_dside_f'`, `'wheel_lf'`) or a ped bone id (`31086` for the head). The prompt rides the bone as it moves |

With neither, an entity point sits in the middle of the entity's model.

### Other point fields

| Field | Default | |
|---|---|---|
| `lineOfSight` | `true` | `false` lets the prompt open through walls (a point inside a counter, say) |
| `allowInVehicle` | `false` | `true` keeps the point while the player sits in a vehicle |
| `groups` | | Jobs or gangs allowed to see the whole point; see [Who sees an option](#who-sees-an-option) |
| `name` | | A name, for removing points by name later |

## Options

`options` is a list, in the order the drum shows them. The first option opens on the point.

```lua
options = {
    { label = 'Take Pump Shotgun', icon = 'fa-solid fa-hand', onSelect = take },
    { label = 'Inspect', icon = 'search', description = 'Serial, ammo, attachments', onSelect = inspect },
    { label = 'Seize', icon = 'fa-solid fa-handcuffs', hold = 1500, groups = 'police', onSelect = seize },
}
```

| Field | |
|---|---|
| `label` | What it does, in sentence case: "Take Pump Shotgun". Required: an option without one (or with an empty one) is dropped, with a warning in the F8 console. A point left with no options isn't made, and its `add*` export returns `nil` |
| `icon` | Font Awesome classes (`'fa-solid fa-gun'`, `'fas fa-box'`), or a [Lucide](https://lucide.dev/icons) icon name (`'phone'`, `'hand-coins'`) |
| `description` | A second, smaller line under the label |
| `hold` | Milliseconds to hold the key instead of pressing it. An outline runs round the tile as the player holds |
| `distance` | This option needs the player closer than the point's `interactDistance` |
| `name` | An id for the option |
| `args` | Anything: handed to `canInteract` and to the handler |

### Who sees an option

`groups` (on an option, or on the whole point) limits it to jobs or gangs. It takes the same shapes ox_target does, and is read from `qbx_core`, `qb-core` or `es_extended`:

```lua
groups = 'police'                          -- one job or gang, any grade
groups = { 'police', 'ambulance' }         -- any of these
groups = { police = 2, sheriff = 0 }       -- each from a lowest grade
```

With no framework running, an option with `groups` is never shown.

For anything else, `canInteract` decides. It is called while the point is in range, with the entity (or `nil`), the point's position, the option's `args` and the player's distance. Return `false` to hide the option:

```lua
canInteract = function(entity, coords, args, distance)
    return not IsPedDeadOrDying(entity, true)
end
```

Return a second value to change the label while it shows, without re-registering anything:

```lua
canInteract = function(entity)
    local locked = GetVehicleDoorLockStatus(entity) == 2
    return true, locked and 'Unlock' or 'Lock'
end
```

Keep `canInteract` cheap: it runs a few times a second for every option in range.

### What an option does

The first of these an option has is the one used, the same handler fields ox_target options take:

| Field | Called with |
|---|---|
| `onSelect` | `onSelect(data)` |
| `export` | `'resource.exportName'`: `exports[resource][exportName](data)` |
| `event` | `TriggerEvent(event, data)` |
| `serverEvent` | `TriggerServerEvent(serverEvent, data)`, with `data.entity` as the entity's network id (0 for a local entity) |
| `command` | `ExecuteCommand(command)` |

`data` is:

| Key | |
|---|---|
| `id` | The point's id |
| `name` | The option's `name` |
| `entity` | The entity the prompt was on, or `nil` for a coords point |
| `coords` | Where the prompt was |
| `distance` | How far the player was |
| `args` | The option's `args` |

An error in a handler is printed to the F8 console and doesn't stop the prompts.

::: warning The server decides
A `serverEvent` is a request from a client, which can send anything. Check on the server that the player may do it: their distance to the entity, their job, the item they need. A prompt only ever shows what the client was told it may do.
:::

## Changing and removing points

```lua
exports['sd-interact']:update(id, { options = newOptions })         -- also distance, interactDistance,
                                                                     -- lineOfSight, groups, coords, entity
exports['sd-interact']:remove(id)
exports['sd-interact']:removeLocalEntity(entity)                     -- every point on it you added
exports['sd-interact']:removeLocalEntity(entity, 'locker')           -- only those named 'locker'
exports['sd-interact']:removeModel({ 'prop_atm_01' })
exports['sd-interact']:removeGlobalVehicle('my_vehicle_options')
```

## Hiding every prompt

While your resource runs a minigame, a cutscene or its own menu, switch prompts off:

```lua
exports['sd-interact']:disable(true)
-- ...
exports['sd-interact']:disable(false)
```

Prompts come back once no resource has them switched off, and a resource that stops switches its own off-state back with it. Prompts also hide by themselves while the player is dead, aiming, in a vehicle, or has a menu or inventory open (each is a switch in [Configuration](./configuration)).
