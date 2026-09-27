# Server Exports

Bombs & Breakable Walls provides server-side exports for placing, breaching, and repairing walls, planting and handing out bombs, and managing workbenches, plus server events to react to explosions, breaches, and defusals.

::: info Return values
Exports that change something return `true` (or the new ID) on success, and `false` - often with a reason - on failure. A reason is either a short code (`breachWall`) or a locale key from `locales/en.json`, e.g. `'bench.holds_parts'`.
:::

## Walls

A wall is a **run** - one straight stretch of one style, 3 m tall, any length in steps of 0.25 m. Coordinates are the **ground** position of the run's centre, and the heading the wall faces. See the [Walls Reference](./walls) for every style and hole shape.

::: info Style keys
Every wall export takes a wall's **style key** - `'brick_red'`, `'concrete_reinforced'`, `'steel_plate'` - listed under [Wall Styles](./walls#wall-styles) and returned by [`getWallStyles`](#getwallstyles). It is **not** the wall-kit item name: pass `'brick_red'`, not `'wallkit_brick_red'`.
:::

### placeWall

Place a wall.

**Syntax**
```lua
local id = exports['sd-bombs']:placeWall(style, coords, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `style` | `string` | The wall's **style key**, e.g. `'brick_red'` - see [Wall Styles](./walls#wall-styles). Not the wall-kit item name |
| `coords` | `vector4` | Ground position of the run's centre, and its heading |
| `opts` | `table?` | Options (below) |

| Option | Type | Default | Description |
|---|---|---|---|
| `length` | `number` | `2` | Metres, rounded **up** to 0.25 (max 40) |
| `color` | `string?` | - | A paint colour the style comes in, e.g. `'navy'` |
| `persistent` | `boolean` | `false` | Save it, so it comes back after a restart |
| `tag` | `string?` | - | Your own label - remove every wall with it at once with [`removeWallsByTag`](#removewallsbytag) |

Returns the new wall's `id`, or `nil` for an unknown style.

**Example**
```lua
-- A 6 m reinforced concrete wall across a vault corridor, rebuilt by the heist every time
local id = exports['sd-bombs']:placeWall('concrete_reinforced', vec4(255.1, 225.4, 101.9, 160.0), {
    length = 6.0,
    tag = 'pacific-vault',
})
```

::: tip Scripted walls
A heist that puts its walls up itself should leave `persistent` off and give them a `tag`: it rebuilds its own set each time and clears it with `removeWallsByTag`, and nothing is left behind in `data/walls.json`.
:::

### placeWallBetween

Place a wall that closes the gap between two points - its length and heading are worked out for you.

**Syntax**
```lua
local id = exports['sd-bombs']:placeWallBetween(style, a, b, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `style` | `string` | The wall's **style key**, e.g. `'brick_red'` - see [Wall Styles](./walls#wall-styles). Not the wall-kit item name |
| `a` | `vector3` | One side of the gap |
| `b` | `vector3` | The other side |
| `opts` | `table?` | As [`placeWall`](#placewall), without `length`. `z` sets the height of the wall's foot - by default the lower of the two points' heights, so give ground-level points (a player's `GetEntityCoords` is about 1 m above the ground) |

Returns `nil` when the points are less than 5 cm apart.

### removeWall

**Syntax**
```lua
local removed = exports['sd-bombs']:removeWall(id)
```

Returns `true` when the wall was there.

### removeWallsByTag

Remove every wall carrying a tag.

**Syntax**
```lua
local count = exports['sd-bombs']:removeWallsByTag(tag)
```

Returns how many walls were removed.

### moveWall

**Syntax**
```lua
local moved = exports['sd-bombs']:moveWall(id, coords)
```

| Parameter | Type | Description |
|---|---|---|
| `id` | `number` | The wall ID |
| `coords` | `vector4` | New ground position of the run's centre, and heading |

The wall keeps its holes.

### resizeWall

**Syntax**
```lua
local resized = exports['sd-bombs']:resizeWall(id, length, anchor)
```

| Parameter | Type | Description |
|---|---|---|
| `id` | `number` | The wall ID |
| `length` | `number` | New length in metres, rounded up to 0.25 |
| `anchor` | `number?` | Which end stays put: `-1` its start, `1` its end, `0` (default) grow or shrink from the middle |

Holes that no longer fit are closed.

### extendWall

Add a 2 m section at one end.

**Syntax**
```lua
local extended = exports['sd-bombs']:extendWall(id, side)
```

| Parameter | Type | Description |
|---|---|---|
| `id` | `number` | The wall ID |
| `side` | `number` | `1` at its end, `-1` at its start |

### setWallStyle

Rebuild a wall in another style where it stands. Its holes stay; so does its colour if the new style comes in it.

**Syntax**
```lua
local changed = exports['sd-bombs']:setWallStyle(id, style, color)
```

| Parameter | Type | Description |
|---|---|---|
| `id` | `number` | The wall ID |
| `style` | `string` | The wall's **style key**, e.g. `'brick_red'` - see [Wall Styles](./walls#wall-styles). Not the wall-kit item name |
| `color` | `string?` | A colour to repaint it in at the same time |

### setWallColor

**Syntax**
```lua
local changed = exports['sd-bombs']:setWallColor(id, color)
```

| Parameter | Type | Description |
|---|---|---|
| `id` | `number` | The wall ID |
| `color` | `string?` | A colour the style comes in, or `nil` for the style as it comes |

### startWallPlacement

Let a player put up **one** wall of a style with the placement tool - no item and no admin permission needed. A job that builds barricades, a shop that sells the service, a heist crew fortifying a door. The licence lasts 5 minutes, or until the wall stands or the tool is cancelled.

**Syntax**
```lua
local started = exports['sd-bombs']:startWallPlacement(source, style, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `style` | `string` | The wall's **style key**, e.g. `'brick_red'` - see [Wall Styles](./walls#wall-styles). Not the wall-kit item name |
| `opts` | `table?` | `{ persistent = boolean (default true), tag = string? }` |

Returns `false` for an unknown style or player. Listen for [`wallPlaced`](#wallplaced-wallremoved-wallrepaired) to get the wall's ID once it stands.

**Example**
```lua
RegisterNetEvent('my-job:server:buildBarricade', function()
    local src = source
    if exports.ox_inventory:RemoveItem(src, 'plywood', 4) then
        exports['sd-bombs']:startWallPlacement(src, 'wood_planks', { persistent = false, tag = 'barricade' })
    end
end)
```

### breachWall

Blow a hole in a wall - **the shape you want, where you want it**.

::: tip Not needed for bombs and explosions
Planted bombs and game explosions breach walls **by themselves** - you do not call anything for that. Use `breachWall` when a wall should open **without** an explosion (a thermite or torch minigame, a scripted scene) or exactly the way your script chooses.
:::

**Syntax**
```lua
local ok, hole = exports['sd-bombs']:breachWall(id, shape, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `id` | `number` | The wall ID |
| `shape` | `string \| number \| nil` | `'doorway'` (or `'breach'`), `'split'`, `'wide'`, `'low'`, `'vehicle'`, `'collapse'`, `'window'`, `'top'`, `'end'`, `'corner'` - or `1`-`10`. `nil` picks one the way an explosion does (by `opts.power`) |
| `opts` | `table?` | Where and why (below) |

| Option | Type | Description |
|---|---|---|
| `along` | `number?` | Metres from the run's start where the hole is centred |
| `coords` | `vector3?` | Instead of `along`: centred as close to this point as the run allows |
| `side` | `string?` | For `'end'` and `'corner'`: `'start'` or `'end'` of the run. Default: the end nearer `along` / `coords` |
| `power` | `number?` | With no `shape`: the blast's power - the more it has to spare over the wall's toughness, the bigger the hole |
| `type` | `string?` | What caused it, passed to the [`wallBreaking`](#wallbreaking) / [`wallBroken`](#wallbroken) events. Default `'script'` |
| `source` | `number?` | A player to credit, passed to the events |

| Return | Type | Description |
|---|---|---|
| `ok` | `boolean` | Whether the wall was breached |
| `hole` | `table \| string` | On success `{ at, variant, shape, flip?, widened }`, else a reason: `'unknown_wall'`, `'unknown_shape'`, `'no_room'`, or `'cancelled'` (a `wallBreaking` handler said no) |

`hole.at` is where the hole **starts** along the run, in metres. `widened` is `true` when the blast went into a hole that was already there and made it bigger instead.

**Example**
```lua
-- A thermite charge opens a doorway right where the player set it
local ok, hole = exports['sd-bombs']:breachWall(wallId, 'doorway', { coords = GetEntityCoords(GetPlayerPed(source)), type = 'thermite', source = source })
if not ok then
    print('Wall still standing: ' .. hole)
end

-- Knock the end off a wall, or bring a 4 m section down in the middle
exports['sd-bombs']:breachWall(wallId, 'end', { side = 'end' })
exports['sd-bombs']:breachWall(wallId, 'collapse', { along = 4.0 })
```

::: tip When a shape does not fit
A 4 m shape (`vehicle`, `collapse`) with no 4 m of wall free falls back to the biggest 2 m one. A shape asked for where a hole already is makes **that** hole bigger (`hole.widened`). `end` and `corner` need the end of the run free. `'no_room'` means nothing could be done anywhere near.
:::

### breakWall

The lower-level form of [`breachWall`](#breachwall): breach a wall from a **cause** table - the same one the [events](#events) carry.

**Syntax**
```lua
local broken = exports['sd-bombs']:breakWall(id, cause)
```

| Field (`cause`) | Type | Description |
|---|---|---|
| `type` | `string` | What caused it, e.g. `'explosion'`, `'script'` |
| `coords` | `vector3?` | Where the blast was - the hole is centred on it |
| `along` | `number?` | Instead of `coords`: metres from the run's start |
| `power` | `number?` | The blast's power |
| `variant` | `number?` | A hole shape, `1`-`10` |
| `source` | `number?` | A player to credit |

Returns `true` when the wall was breached.

### breakWallsNear

Breach every intact wall around a point, as an explosion there would.

**Syntax**
```lua
local ids = exports['sd-bombs']:breakWallsNear(coords, radius, power, cause)
```

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` | Where the blast is |
| `radius` | `number` | Metres, to the nearest point of each wall |
| `power` | `number` | Breaches every wall whose toughness it meets |
| `cause` | `table?` | As [`breakWall`](#breakwall); `coords` and `power` are filled in |

Returns the IDs of the walls that were breached.

### repairWall / repairAllWalls

Rebuild a breached wall - every hole is closed - or every breached wall.

**Syntax**
```lua
local repaired = exports['sd-bombs']:repairWall(id)
local count = exports['sd-bombs']:repairAllWalls()
```

### getWall

**Syntax**
```lua
local wall = exports['sd-bombs']:getWall(id)
```

| Field | Type | Description |
|---|---|---|
| `id` | `number` | Wall ID |
| `style` | `string` | The wall's style key, e.g. `'brick_red'` |
| `color` | `string?` | Paint colour |
| `state` | `string` | `'intact'` or `'broken'` |
| `length` | `number` | Metres |
| `holes` | `table[]` | `{ at, variant, flip? }` for every hole |
| `coords` | `vector4` | Ground position of the run's centre, and heading |
| `persistent` | `boolean` | Saved across restarts |
| `tag` | `string?` | Its tag |
| `brokenAt` | `number?` | When it was last breached (unix seconds) |

### getWalls

**Syntax**
```lua
local walls = exports['sd-bombs']:getWalls(tag)
```

| Parameter | Type | Description |
|---|---|---|
| `tag` | `string?` | Only walls carrying this tag |

Returns a list of walls, as [`getWall`](#getwall).

### getNearestWall

**Syntax**
```lua
local id, distance = exports['sd-bombs']:getNearestWall(coords, maxDist, state)
```

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` | Where to look from |
| `maxDist` | `number` | Metres |
| `state` | `string?` | Only `'intact'` or `'broken'` walls |

### isWallBroken

**Syntax**
```lua
local broken = exports['sd-bombs']:isWallBroken(id)
```

### getWallStyles

Every wall style.

**Syntax**
```lua
local styles = exports['sd-bombs']:getWallStyles()
```

| Field | Type | Description |
|---|---|---|
| `key` | `string` | The style key - what the wall exports take, e.g. `'brick_red'` |
| `label` | `string` | Display name |
| `toughness` | `number` | `1`-`4` |
| `fx` | `string` | Breach effect: `'plaster'`, `'wood'`, `'metal'`, or `'masonry'` |
| `colors` | `string[]?` | The paint colours it comes in |

### getHoleShapes

The ten hole shapes [`breachWall`](#breachwall) takes.

**Syntax**
```lua
local shapes = exports['sd-bombs']:getHoleShapes()
```

| Field | Type | Description |
|---|---|---|
| `id` | `number` | `1`-`10` |
| `name` | `string` | e.g. `'breach'`, `'window'` |
| `width` | `number` | Metres of wall it takes: `2`, or `4` for `vehicle` / `collapse` |
| `edge` | `boolean` | Only opens at a run's end (`end`, `corner`) |

## Bombs

### plantBomb

Plant an armed bomb. Its clock starts at once.

**Syntax**
```lua
local id = exports['sd-bombs']:plantBomb(coords, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector4` | Ground position and heading - the bomb's front faces back along the heading |
| `opts` | `table?` | Options (below) |

| Option | Type | Default | Description |
|---|---|---|---|
| `seconds` | `number` | `300` | The countdown |
| `strikes` | `number` | `3` | Strikes allowed, `1`-`5` |
| `modules` | `number` | `5` | How many modules are dealt, `1`-`11` - more than 5 spill onto the back face |
| `needy` | `boolean` | `false` | Also deal 1-2 needy modules - they can never be solved, only kept quiet |
| `seed` | `string?` | random | Six characters - the same seed always deals the same bomb |
| `yield` | `number` | `3` | Blocks of explosive, `1`-`6`: how hard it hits walls |
| `variant` | `string?` | - | `'small'`, `'medium'`, or `'large'` - a compact casing instead of the Extra Large |
| `layout` | `string?` | - | Exactly which module sits in which bay, e.g. `'f1:timer,f0:wires,f2:button'` |
| `edge` | `string?` | dealt | The edgework, as the bench fits it |
| `rot` | `vector3?` | - | Pitch, roll, yaw: stick the casing exactly at `coords`, turned so - on a wall or a ceiling |
| `surface` | `string?` | - | `'floor'`, `'wall'`, or `'ceiling'` |
| `dud` | `boolean` | `false` | Its clock runs, but at zero it only clicks |

**Example**
```lua
-- A two-minute bomb on the vault door, packed to bring the wall down
local id = exports['sd-bombs']:plantBomb(vec4(255.2, 223.8, 101.7, 160.0), {
    seconds = 120,
    strikes = 2,
    modules = 7,
    yield = 6,
})
```

### plantBombInFrontOf

Plant a bomb on the ground in front of a player.

**Syntax**
```lua
local id = exports['sd-bombs']:plantBombInFrontOf(source, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `opts` | `table?` | As [`plantBomb`](#plantbomb) |

### removeBomb

Take a bomb away without a bang.

**Syntax**
```lua
local removed = exports['sd-bombs']:removeBomb(id)
```

### detonateBomb

Set an armed bomb off now.

**Syntax**
```lua
local detonated = exports['sd-bombs']:detonateBomb(id, reason)
```

| Parameter | Type | Description |
|---|---|---|
| `id` | `number` | The bomb ID |
| `reason` | `string?` | Logged, and passed to the [`exploded`](#exploded) event |

### getBombs / getBomb

**Syntax**
```lua
local bombs = exports['sd-bombs']:getBombs()
local bomb = exports['sd-bombs']:getBomb(id)
```

| Field | Type | Description |
|---|---|---|
| `id` | `number` | Bomb ID |
| `x`, `y`, `z`, `heading` | `number` | Where it is |
| `status` | `string` | `'armed'`, `'defused'`, or `'dud'` (a bomb that went off is gone) |
| `secondsLeft` | `number` | Seconds on the clock while armed |
| `seed` | `string` | Its seed |
| `modules` | `number` | How many modules |
| `needy` | `boolean` | Has a needy module |
| `strikes` | `number` | Strikes allowed |
| `yield` | `number` | Blocks of explosive |
| `variant` | `string?` | Compact casing size |
| `built` | `boolean` | Built at a workbench (has a `layout`) |
| `dud` | `boolean` | Signed off with its arming pin in |
| `defuser` | `number?` | Server ID of whoever is defusing it right now |
| `defuserName` | `string?` | Their name |

### giveBomb

Hand a player a finished bomb as an item - exactly as a workbench turns one out. Planted, **that** bomb is the one that gets defused.

**Syntax**
```lua
local ok, why = exports['sd-bombs']:giveBomb(source, build)
```

| Field (`build`) | Type | Description |
|---|---|---|
| `variant` | `string?` | `'small'`, `'medium'`, `'large'`, or `nil` for the Extra Large |
| `layout` | `string` | Which module sits in which bay, e.g. `'f1:timer,f0:wires'` |
| `seed` | `string` | Six characters |
| `seconds` | `number` | The countdown |
| `strikes` | `number` | Strikes allowed |
| `charge` | `number` | Blocks of explosive - no more than the size holds |
| `edge` | `string?` | The edgework |
| `dud` | `boolean?` | Signed off with its arming pin in |

Returns `false` and a locale key when the build is not one a bench could have made.

::: tip
The admin panel's **Bombs** tab builds bombs bay by bay and has a **Give** button - the easiest way to find a valid `layout` and `edge` to copy.
:::

## Workbenches

Workbenches are where bombs are built. Coordinates are the **ground** position and heading; the builder stands on the bench's front side.

### placeBench

Stand a workbench. It is saved and comes back after a restart.

**Syntax**
```lua
local id = exports['sd-bombs']:placeBench(coords, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector4` | Ground position and heading |
| `opts` | `table?` | `{ owner = source \| identifier }` - that character can pack it up again with the workbench item |

### removeBench

**Syntax**
```lua
local ok, why = exports['sd-bombs']:removeBench(id, force)
```

| Parameter | Type | Description |
|---|---|---|
| `id` | `number` | The bench ID |
| `force` | `boolean?` | Remove it even if parts still lie on it - they are lost |

Fails with `'bench.from_config'` for a bench from the config, `'bench.holds_parts'` for one that still holds parts (without `force`), and `'admin.bench_in_use'` while somebody works at it.

### moveBench

Stand a bench somewhere else. What lies on it goes with it.

**Syntax**
```lua
local ok, why = exports['sd-bombs']:moveBench(id, coords)
```

### setBenchOwner

Hand a bench to a character, or to nobody (then only staff can take it away).

**Syntax**
```lua
local ok, why = exports['sd-bombs']:setBenchOwner(id, owner)
```

| Parameter | Type | Description |
|---|---|---|
| `id` | `number` | The bench ID |
| `owner` | `number \| string \| nil` | A player's server ID, a framework identifier (citizenid / license), or `nil` |

### getBench / getBenches

**Syntax**
```lua
local bench = exports['sd-bombs']:getBench(id)
local benches = exports['sd-bombs']:getBenches()
```

| Field | Type | Description |
|---|---|---|
| `id` | `number` | Bench ID |
| `coords` | `vector4` | Where it stands |
| `placed` | `boolean` | Placed in-game (saved); `false` for one from the config |
| `owner` | `string?` | The identifier of the character who owns it |
| `user` | `number?` | Server ID of whoever is building at it right now |
| `holds` | `table` | What lies on it: `{ tools, book, brackets, reel, cup, casing, loose, empty }` |

### stockBench

Kit a bench out.

**Syntax**
```lua
local done, why = exports['sd-bombs']:stockBench(id, loadout)
```

| Field (`loadout`) | Type | Description |
|---|---|---|
| `tools` | `string[]?` | Tools to hang on its pegboard, e.g. `{ 'driver', 'hexkey', 'knife' }` |
| `handbook` | `boolean?` | The handbook on its lectern |
| `brackets` | `boolean?` | A set of charge brackets |
| `reel` | `boolean?` | A stocked wire rack |
| `cup` | `boolean?` | A cup of screws |

Returns what went onto it.

### clearBench

Sweep a bench clean: everything on it - a build in progress included - is gone.

**Syntax**
```lua
local ok, why = exports['sd-bombs']:clearBench(id)
```

## Events

Server events other resources can listen to with `AddEventHandler`.

### explosion

Fires for **every** explosion in the world, before any wall is touched. `CancelEvent()` spares the walls from that explosion (it does not stop the explosion itself).

```lua
AddEventHandler('sd-bombs:server:explosion', function(data)
    -- data: { coords, explosionType, power, reach, source, damageScale, invisible, bombId? }
    if data.explosionType == 2 and IsInSafeZone(data.coords) then
        CancelEvent() -- sticky bombs never breach walls here
    end
end)
```

### wallBreaking

Fires before a wall is breached. `CancelEvent()` keeps the wall standing.

```lua
AddEventHandler('sd-bombs:server:wallBreaking', function(wall, cause)
    if wall.tag == 'pacific-vault' and not HeistIsActive() then
        CancelEvent()
    end
end)
```

### wallBroken

Fires once a wall has been breached.

```lua
AddEventHandler('sd-bombs:server:wallBroken', function(wall, cause)
    -- cause: { type, coords?, power?, source?, hole = { at, variant, flip? }, holes, widened? }
    if wall.tag == 'pacific-vault' then
        TriggerEvent('my-heist:server:vaultOpen')
    end
end)
```

### wallPlaced / wallRemoved / wallRepaired

```lua
AddEventHandler('sd-bombs:server:wallPlaced', function(wall) end)
AddEventHandler('sd-bombs:server:wallRemoved', function(wall) end)
AddEventHandler('sd-bombs:server:wallRepaired', function(wall) end)
```

### exploded

Fires when a bomb goes off - its clock ran out, it took its last strike, or it was detonated.

```lua
AddEventHandler('sd-bombs:server:exploded', function(data)
    -- data: { id, coords, seed, reason, defuser?, yield }
end)
```

### defused

```lua
AddEventHandler('sd-bombs:server:defused', function(data)
    -- data: { id, coords, seed, defuser }
    if data.defuser then
        exports['my-rewards']:give(data.defuser, 'bomb_defused')
    end
end)
```

### fizzled

Fires when a **dud** - a bomb signed off with its arming pin in - reaches zero: it only clicks.

```lua
AddEventHandler('sd-bombs:server:fizzled', function(data)
    -- data: { id, coords, seed, reason, defuser? }
end)
```
