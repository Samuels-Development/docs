---
title: Client Hooks
description: Client-side hook events for extending Advanced Crafting functionality.
---

# Client Hooks

Client hooks allow you to react to events on the client side. Use these to trigger custom UI effects, notifications, animations, sounds, particle FX, or any client-side logic when specific crafting events occur.

## How to Use Hooks

Hooks in sd-crafting use a **callback registration system**, not standard FiveM events. Register handlers using either:

**From within the sd-crafting resource** (in `client/hooks.lua`):

```lua
ClientHooks.Register('onCraftingUIOpened', function(data)
    print(('Opened crafting UI at: %s'):format(data.stationId))
end)
```

**From another resource** (via export):

```lua
exports['sd-crafting']:registerClientHook('onCraftingUIOpened', function(data)
    print(('Opened crafting UI at: %s'):format(data.stationId))
end)
```

Both methods return a `handlerId` that can be used to unregister the hook later:

```lua
local id = exports['sd-crafting']:registerClientHook('onCraftingUIOpened', function(data) ... end)
exports['sd-crafting']:unregisterClientHook('onCraftingUIOpened', id)
```

All hook callbacks receive a single `data` table with event-specific fields. Hooks are **fire-and-forget** — they cannot cancel actions, and every callback is wrapped in `pcall` so a buggy handler from one resource cannot break others.

::: warning Timestamps on client
The `timestamp` field on every client hook is the value of `GetGameTimer()` (milliseconds since the game/resource started), **not** a unix timestamp. The `os` library is server-only in FiveM, so a real wall-clock timestamp is unavailable on the client. Use this value for ordering and relative timing of local events. [Server hooks](./hooks-server) use real unix timestamps from `os.time()`.
:::

---

## UI Lifecycle Events

### onCraftingUIOpened

Triggered after the crafting UI has been opened and focus has been transferred to the NUI.

```lua
ClientHooks.Register('onCraftingUIOpened', function(data)
    print(('Opened crafting UI at: %s (type: %s)'):format(
        data.stationId, data.workbenchType or 'unknown'))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string` | Station identifier |
| `workbenchType` | `string\|nil` | Workbench type (e.g. `'basic'`, `'advanced'`) |
| `timestamp` | `number` | Unix timestamp |

---

### onCraftingUIClosed

Triggered after the crafting UI has been closed and focus has been returned to the game. Fires both for clean closes and force-closes.

```lua
ClientHooks.Register('onCraftingUIClosed', function(data)
    print(('Closed crafting UI at: %s'):format(data.stationId or 'unknown'))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string\|nil` | Station identifier that was being viewed |
| `timestamp` | `number` | Unix timestamp |

---

### onForceClose

Triggered when the server sends a force-close (typically from the `craftsimrelog` admin command or a simulated reconnect). Local processing state has already been cleared at this point.

```lua
ClientHooks.Register('onForceClose', function(data)
    print(('Crafting UI force-closed: %s'):format(data.reason))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `reason` | `string` | Force-close reason (currently `'server_force_close'`) |
| `timestamp` | `number` | Unix timestamp |

---

## Local Crafting Events

### onCraftQueued

Triggered when the player adds a recipe to the queue (either the local queue or the shared queue, depending on the station).

```lua
ClientHooks.Register('onCraftQueued', function(data)
    print(('Queued %dx recipe %s (queue item %s)'):format(
        data.quantity, data.recipeId, data.queueItemId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string` | Station identifier |
| `recipeId` | `string` | Recipe identifier |
| `quantity` | `number` | Quantity queued |
| `queueItemId` | `string` | Generated queue item ID |
| `craftTime` | `number` | Total craft duration (`recipe.craftTime * quantity`) |
| `timestamp` | `number` | Unix timestamp |

---

### onCraftCancelled

Triggered when the player cancels a queued (or actively-crafting) item before it completes. Refund has already been requested from the server at this point.

```lua
ClientHooks.Register('onCraftCancelled', function(data)
    print(('Cancelled craft of recipe %s'):format(data.recipeId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string` | Station identifier |
| `recipeId` | `string` | Recipe identifier |
| `queueItemId` | `string` | Queue item ID that was cancelled |
| `timestamp` | `number` | Unix timestamp |

---

### onCraftCompleted

Triggered locally after a craft finishes successfully (including partial successes) and the server has granted the output items. This is **separate** from the server-side `onCraftCompleted` — register on this one for sound/screen effects that should fire on the crafter's screen.

```lua
ClientHooks.Register('onCraftCompleted', function(data)
    PlaySoundFrontend(-1, 'PURCHASE', 'HUD_LIQUOR_STORE_SOUNDSET', true)
    print(('Crafted %dx %s (%d/%d successful)'):format(
        data.quantity, data.outputItem,
        data.successfulCrafts, data.quantity))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string` | Station identifier |
| `recipeId` | `string` | Recipe identifier |
| `quantity` | `number` | Quantity originally queued |
| `successfulCrafts` | `number` | Number of items that passed the quality roll |
| `failedCrafts` | `number` | Number of items that failed (partial-failure mode only) |
| `outputItem` | `string` | Item name granted |
| `levelData` | `table\|nil` | Level progression data if XP was awarded (xp, level, leveledUp, etc.) |
| `techPointsData` | `table\|nil` | Tech points data if tech points were awarded |
| `blueprintDestroyed` | `boolean` | Whether the blueprint was destroyed by this craft |
| `timestamp` | `number` | Unix timestamp |

---

### onCraftFailed

Triggered locally when a craft fails the quality check entirely (no items granted, ingredients consumed).

```lua
ClientHooks.Register('onCraftFailed', function(data)
    PlaySoundFrontend(-1, 'ERROR', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
    print(('Craft failed: %s'):format(data.recipeId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string` | Station identifier |
| `recipeId` | `string` | Recipe identifier |
| `quantity` | `number` | Quantity attempted |
| `reason` | `string` | Failure reason (currently `'quality_check'`) |
| `timestamp` | `number` | Unix timestamp |

---

## Staging Inventory Events

### onItemStaged

Triggered after the player successfully stages an item from inventory into the crafting staging area via the UI.

```lua
ClientHooks.Register('onItemStaged', function(data)
    print(('Staged %dx %s at %s'):format(data.count, data.item, data.stationId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string` | Station identifier |
| `item` | `string` | Item name |
| `count` | `number` | Quantity staged |
| `slot` | `number\|nil` | Target staging slot |
| `timestamp` | `number` | Unix timestamp |

---

### onItemUnstaged

Triggered after the player successfully unstages an item from the crafting staging area back into inventory.

```lua
ClientHooks.Register('onItemUnstaged', function(data)
    print(('Unstaged %dx %s from %s'):format(data.count, data.item, data.stationId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string` | Station identifier |
| `item` | `string` | Item name |
| `count` | `number` | Quantity unstaged |
| `slot` | `number\|nil` | Source staging slot |
| `timestamp` | `number` | Unix timestamp |

---

## Blueprint Events

### onBlueprintAttached

Triggered locally after a blueprint has been successfully attached to the current station.

```lua
ClientHooks.Register('onBlueprintAttached', function(data)
    print(('Attached blueprint: %s'):format(data.blueprintItem))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string` | Station identifier |
| `blueprintItem` | `string` | Blueprint item name |
| `timestamp` | `number` | Unix timestamp |

---

### onBlueprintDetached

Triggered locally after a blueprint has been successfully detached from the current station and returned to inventory.

```lua
ClientHooks.Register('onBlueprintDetached', function(data)
    print(('Detached blueprint: %s'):format(data.blueprintItem))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string` | Station identifier |
| `blueprintItem` | `string` | Blueprint item name |
| `timestamp` | `number` | Unix timestamp |

---

## Tech Tree Events

### onTechNodeUnlockRequested

Triggered immediately before the server is asked to unlock a tech node. Useful for optimistic UI effects.

```lua
ClientHooks.Register('onTechNodeUnlockRequested', function(data)
    print(('Requesting unlock: %s in tree %s'):format(data.nodeId, data.treeId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `treeId` | `string` | Tech tree identifier |
| `nodeId` | `string` | Tech node identifier |
| `workbenchType` | `string\|nil` | Workbench type |
| `stationId` | `string` | Station identifier |
| `timestamp` | `number` | Unix timestamp |

---

### onTechNodeUnlocked

Triggered locally after the server confirms a successful tech node unlock.

```lua
ClientHooks.Register('onTechNodeUnlocked', function(data)
    PlaySoundFrontend(-1, 'CHALLENGE_UNLOCKED', 'HUD_AWARDS', true)
    print(('Unlocked %s (%d points remaining)'):format(data.nodeId, data.newPoints))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `treeId` | `string` | Tech tree identifier |
| `nodeId` | `string` | Tech node identifier |
| `workbenchType` | `string\|nil` | Workbench type |
| `stationId` | `string` | Station identifier |
| `newPoints` | `number` | Tech points the player has left |
| `isShared` | `boolean` | Whether the unlock was applied to a shared-workbench pool |
| `timestamp` | `number` | Unix timestamp |

---

## Workbench Placement Events

### onWorkbenchPlaced

Triggered on **every** client when a placed workbench is spawned in the world — this is broadcast to all clients, not just the placer. Useful for ambient effects, blip-spawn animations, or audit logs.

```lua
ClientHooks.Register('onWorkbenchPlaced', function(data)
    print(('Workbench %d placed at %.2f, %.2f, %.2f'):format(
        data.workbenchId, data.coords.x, data.coords.y, data.coords.z))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `workbenchId` | `number` | Database ID of the workbench |
| `item` | `string` | Workbench item name |
| `workbenchType` | `string` | Workbench type |
| `coords` | `vector3` | Placement coordinates |
| `heading` | `number` | Placement heading |
| `timestamp` | `number` | Unix timestamp |

---

### onWorkbenchPickedUp

Triggered locally on the owner's client after they successfully pick up their placed workbench.

```lua
ClientHooks.Register('onWorkbenchPickedUp', function(data)
    print(('Picked up workbench %d'):format(data.workbenchId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `workbenchId` | `number` | Database ID of the workbench that was picked up |
| `timestamp` | `number` | Unix timestamp |

---

## Notifications & Sync Events

### onNotificationReceived

Triggered when the server pushes a notification to this player via `sd-crafting:client:notify`. Useful for routing crafting notifications through a custom notification system.

```lua
ClientHooks.Register('onNotificationReceived', function(data)
    print(('[%s] %s: %s'):format(data.type, data.title, data.description))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `title` | `string\|nil` | Notification title |
| `description` | `string\|nil` | Notification body |
| `type` | `string\|nil` | Notification type (`'success'`, `'error'`, `'inform'`, etc.) |
| `timestamp` | `number` | Unix timestamp |

---

### onSharedQueueSynced

Triggered when the server pushes a shared queue update for the station the player is currently viewing.

```lua
ClientHooks.Register('onSharedQueueSynced', function(data)
    print(('Shared queue at %s now has %d items'):format(
        data.stationId, data.queueLength))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string` | Station identifier |
| `queue` | `table` | Updated queue array (with interpolated remainingTime) |
| `queueLength` | `number` | Queue length |
| `timestamp` | `number` | Unix timestamp |

---

### onStagedItemsSynced

Triggered when the server pushes a staged-items update for the station the player is currently viewing (typically because another player modified the shared staging inventory).

```lua
ClientHooks.Register('onStagedItemsSynced', function(data)
    print(('Staged items at %s updated: %d items, %dg'):format(
        data.stationId, #data.items, data.totalWeight))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `stationId` | `string` | Station identifier |
| `items` | `table` | Updated staged items array |
| `totalWeight` | `number` | Total weight of staged items |
| `timestamp` | `number` | Unix timestamp |

---

### onTechTreeSynced

Triggered when the server pushes a tech tree update — typically because another player on a shared workbench unlocked a node.

```lua
ClientHooks.Register('onTechTreeSynced', function(data)
    print(('Tech tree synced: %d points'):format(data.techPoints))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `techPoints` | `number` | New tech points value |
| `unlockedNodes` | `table` | Map of unlocked nodes |
| `workbenchType` | `string\|nil` | Workbench type the sync applies to |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminRecipeSynced

Triggered when the server pushes a recipe change (admin-driven create/update, delete, or reorder) to the client recipe cache. The `action` field distinguishes the three cases.

```lua
ClientHooks.Register('onAdminRecipeSynced', function(data)
    if data.action == 'upsert' then
        print(('Recipe synced in %s: %s'):format(data.tableName, data.recipe.id))
    elseif data.action == 'remove' then
        print(('Recipe removed from %s: %s'):format(data.tableName, data.recipe.id))
    elseif data.action == 'reorder' then
        print(('Recipes reordered in %s'):format(data.tableName))
    end
end)
```

| Parameter | Type | Description |
|---|---|---|
| `tableName` | `string` | Recipe table the change applies to |
| `recipe` | `table` | Recipe object (full recipe for `upsert`, `{ id }` for `remove`, `{ orderedIds }` for `reorder`) |
| `action` | `string` | `'upsert'`, `'remove'`, or `'reorder'` |
| `timestamp` | `number` | Unix timestamp |

---

## Integration Examples

### Custom Sound Design

```lua
ClientHooks.Register('onCraftingUIOpened', function()
    PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
end)

ClientHooks.Register('onCraftCompleted', function()
    PlaySoundFrontend(-1, 'PURCHASE', 'HUD_LIQUOR_STORE_SOUNDSET', true)
end)

ClientHooks.Register('onCraftFailed', function()
    PlaySoundFrontend(-1, 'ERROR', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
end)

ClientHooks.Register('onTechNodeUnlocked', function()
    PlaySoundFrontend(-1, 'CHALLENGE_UNLOCKED', 'HUD_AWARDS', true)
end)
```

### Particle FX on Workbench Placement

```lua
ClientHooks.Register('onWorkbenchPlaced', function(data)
    RequestNamedPtfxAsset('core')
    while not HasNamedPtfxAssetLoaded('core') do Wait(0) end
    UseParticleFxAssetNextCall('core')
    StartParticleFxNonLoopedAtCoord(
        'ent_dst_dust',
        data.coords.x, data.coords.y, data.coords.z,
        0.0, 0.0, 0.0,
        1.0, false, false, false
    )
end)
```

### Route Notifications to a Custom System

```lua
ClientHooks.Register('onNotificationReceived', function(data)
    exports['your-notify']:Show(data.title, data.description, data.type or 'info')
end)
```

---

::: tip Integration Ideas
Use client hooks to:
- Play custom sounds on craft completion, failure, or tech tree unlock
- Trigger camera effects when opening or closing the crafting UI
- Show custom notifications using your preferred notification system
- Spawn particle FX or props when workbenches are placed
- Apply screen shake or vignette effects on craft failure
- Log client-side events for debugging or analytics
- Animate the player ped on craft completion
:::
