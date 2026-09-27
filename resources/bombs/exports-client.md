# Client Exports

Bombs & Breakable Walls provides client-side exports for reading walls and bombs, previewing what a bomb would breach, reusing the placement tool, and opening the field manual, plus client events for reacting to breaches.

## Walls

### getWalls

Every wall, as the server publishes them.

**Syntax**
```lua
local walls = exports['sd-bombs']:getWalls()
```

Returns a table of walls **keyed by ID**:

| Field | Type | Description |
|---|---|---|
| `id` | `number` | Wall ID |
| `style` | `string` | The wall's style key, e.g. `'brick_red'` |
| `color` | `string?` | Paint colour |
| `state` | `string` | `'intact'` or `'broken'` |
| `length` | `number` | Metres |
| `holes` | `table[]` | `{ at, variant, flip? }` for every hole |
| `coords` | `table` | `{ x, y, z, w }` - ground position of the run's centre, and heading |
| `tag` | `string?` | Its tag |

### getWall

**Syntax**
```lua
local wall = exports['sd-bombs']:getWall(id)
```

Returns one wall, as [`getWalls`](#getwalls), or `nil`.

### getWallEntities

The props a wall is laid from for this player right now - `nil` while it is out of range.

**Syntax**
```lua
local entities = exports['sd-bombs']:getWallEntities(id)
```

**Example**
```lua
-- Outline a wall while the player is looking for somewhere to breach
for _, entity in ipairs(exports['sd-bombs']:getWallEntities(wallId) or {}) do
    SetEntityDrawOutline(entity, true)
end
```

### predictBreach

What a bomb set off at a point would do to every wall near enough to matter - the same preview a player sees while planting.

**Syntax**
```lua
local results = exports['sd-bombs']:predictBreach(coords, yield)
```

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` | Where the bomb would be |
| `yield` | `number?` | Blocks of explosive, `1`-`6`. Default: the default bomb |

| Field | Type | Description |
|---|---|---|
| `id` | `number` | Wall ID |
| `verdict` | `string` | `'breach'` (a new hole), `'widen'` (an existing hole made bigger), `'tough'` (too tough for this yield), `'full'` (no room for another hole), or `'far'` (not set against it) |
| `hole` | `table?` | For `'breach'` / `'widen'`: `{ at, variant }` - where the hole would start and its shape |
| `distance` | `number` | Metres to the wall |

**Example**
```lua
local here = GetEntityCoords(PlayerPedId())
for _, r in ipairs(exports['sd-bombs']:predictBreach(here, 2)) do
    if r.verdict == 'tough' then
        lib.notify({ description = 'Two blocks will not get through that wall.', type = 'error' })
    end
end
```

### startPlacement

Open the placement tool for one wall of a style - what `/wall_place` and the wall kits do.

**Syntax**
```lua
local placed = exports['sd-bombs']:startPlacement(style)
```

| Parameter | Type | Description |
|---|---|---|
| `style` | `string?` | The wall's **style key**, e.g. `'brick_red'` - see [Wall Styles](./walls#wall-styles) (not the wall-kit item name). Default: the last one placed |

::: warning Permission is checked on the server
The server only builds the wall if the player may run `/wall_place`, just used a wall kit, or was given a one-off licence. To let **any** player put up a wall from your script, call the [`startWallPlacement`](./exports-server#startwallplacement) **server** export instead - it opens the tool for them and grants the licence.
:::

## Bombs

### getBombs

Every planted bomb, as the server publishes them.

**Syntax**
```lua
local bombs = exports['sd-bombs']:getBombs()
```

| Field | Type | Description |
|---|---|---|
| `id` | `number` | Bomb ID |
| `coords` | `table` | `{ x, y, z, w }` |
| `status` | `string` | `'armed'`, `'defused'`, or `'dud'` |
| `seed` | `string` | Its seed |
| `modules` | `number` | How many modules |
| `needy` | `boolean` | Has a needy module |
| `strikes` | `number` | Strikes allowed |
| `surface` | `string` | `'floor'`, `'wall'`, or `'ceiling'` |
| `variant` | `string?` | Compact casing size |

### openManual

Open the Expert's field manual. It needs no bomb - the manual is the same book for every bomb.

**Syntax**
```lua
exports['sd-bombs']:openManual()
```

**Example**
```lua
-- A laptop app that opens the manual
RegisterNUICallback('openBombManual', function(_, cb)
    exports['sd-bombs']:openManual()
    cb('ok')
end)
```

### isAtBench

Whether the player is building at a workbench right now - its camera and controls belong to the bench.

**Syntax**
```lua
local busy = exports['sd-bombs']:isAtBench()
```

**Example**
```lua
-- Don't open the phone over the bench
if exports['sd-bombs']:isAtBench() then return end
```

## Placement Tool

### placeGhost

Open the placement tool - the same native editor gizmo the admin panel uses - for any model. The call **blocks** until the player places or cancels.

**Syntax**
```lua
local result, errKey = exports['sd-bombs']:placeGhost(kind, modelName, label, extra, from, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `kind` | `string` | `'object'` or `'vehicle'` |
| `modelName` | `string` | The model to place |
| `label` | `string` | What the placement HUD calls it |
| `extra` | `table[]?` | More props built with it: `{ model, offset, rot? }` in its own space |
| `from` | `table?` | Start from here: `{ x, y, z, heading }` (moving something that already stands) |
| `opts` | `table?` | `{ warn = function(transform) return { { key, value? } } end, frame = function(transform) end }` |

| Return | Type | Description |
|---|---|---|
| `result` | `table?` | `{ x, y, z, heading }` when placed, `nil` when cancelled, `false` when refused |
| `errKey` | `string?` | A locale key explaining why placement was refused |

**Example**
```lua
CreateThread(function()
    local spot = exports['sd-bombs']:placeGhost('object', 'prop_barrier_work05', 'Barrier')
    if spot then
        TriggerServerEvent('my-resource:server:placeBarrier', spot.x, spot.y, spot.z, spot.heading)
    end
end)
```

::: tip
Call `placeGhost` from inside a thread - it waits until the player confirms or cancels. Controls: drag the arrows (move) or rings (turn) with the cursor, the mouse wheel turns while the cursor is hidden, `G` shows or hides the cursor, hold right mouse to look around, `X` snap, `T` stick to the ground, `Alt` drop to the ground, `Ctrl+Z` undo, `Enter` place, `Backspace` cancel.
:::

## Events

Client events other resources can listen to with `AddEventHandler`.

### wallBroken

Fires on every client that knows the wall, once it is breached.

```lua
AddEventHandler('sd-bombs:wallBroken', function(id, wall, cause)
    -- cause: { type, coords?, power?, hole = { at, variant, flip? }, holes, widened? }
    if wall.tag == 'pacific-vault' and #(GetEntityCoords(PlayerPedId()) - vec3(wall.coords.x, wall.coords.y, wall.coords.z)) < 30.0 then
        ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 0.6)
    end
end)
```

### wallRepaired

```lua
AddEventHandler('sd-bombs:wallRepaired', function(id, wall) end)
```

### uiClosed

Fires when the player closes the defusal screen or the field manual.

```lua
AddEventHandler('sd-bombs:client:uiClosed', function() end)
```
