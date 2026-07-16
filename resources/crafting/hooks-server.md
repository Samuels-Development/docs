---
title: Server Hooks
description: Server-side hook events for extending Advanced Crafting functionality.
---

# Server Hooks

Server hooks allow you to react to events on the server side. Use these to integrate with external systems (MDT, Discord, dashboards), log activity, trigger custom server logic, or extend Advanced Crafting functionality.

## How to Use Hooks

Hooks in sd-crafting use a **callback registration system**, not standard FiveM events. Register handlers using either:

**From within the sd-crafting resource** (in `server/hooks.lua`):

```lua
ServerHooks.Register('onCraftCompleted', function(data)
    print(('[SD-CRAFTING] %s crafted %dx %s'):format(
        data.identifier, data.totalOutputCount, data.outputItem))
end)
```

**From another resource** (via export):

```lua
exports['sd-crafting']:registerServerHook('onCraftCompleted', function(data)
    print(('[SD-CRAFTING] %s crafted %dx %s'):format(
        data.identifier, data.totalOutputCount, data.outputItem))
end)
```

Both methods return a `handlerId` that can be used to unregister the hook later:

```lua
local id = exports['sd-crafting']:registerServerHook('onCraftCompleted', function(data) ... end)
exports['sd-crafting']:unregisterServerHook('onCraftCompleted', id)
```

All hook callbacks receive a single `data` table with event-specific fields. Hooks are **fire-and-forget** — returning a value from a callback or throwing an error from it does not cancel the underlying action, and every callback is wrapped in `pcall` so a buggy handler from one integration cannot break others.

---

## Crafting Lifecycle Events

### onCraftStarted

Triggered after ingredients have been successfully consumed (and any required cost deducted) at the start of a craft. A unique `craftToken` is included that the server uses to validate the matching `onCraftCompleted` / `onCraftRefunded` event later.

```lua
ServerHooks.Register('onCraftStarted', function(data)
    print(('[SD-CRAFTING] %s started crafting %dx %s at %s'):format(
        data.identifier, data.quantity, data.recipeLabel, data.stationId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier (citizenid / license) |
| `recipeId` | `string` | Recipe identifier |
| `recipeLabel` | `string` | Recipe display name |
| `quantity` | `number` | Number of items being crafted |
| `stationId` | `string` | Station identifier (e.g. `'workbench'`, `'placed_42'`) |
| `ingredients` | `table` | Array of `{ item, amount, label }` consumed |
| `cost` | `number` | Total cash deducted for this craft (0 if free) |
| `craftTime` | `number` | Total craft duration in seconds (`recipe.craftTime * quantity`) |
| `craftToken` | `string` | Unique token tying this craft to its completion/refund |
| `timestamp` | `number` | Unix timestamp |

---

### onCraftCompleted

Triggered after a craft has successfully completed and output items have been granted (either to the player's inventory or to the crafting stash). Fires for both fully-successful and partially-successful crafts; pure failures fire `onCraftFailed` instead.

```lua
ServerHooks.Register('onCraftCompleted', function(data)
    print(('[SD-CRAFTING] %s crafted %dx %s (%d successful, %d failed)'):format(
        data.identifier, data.totalOutputCount, data.outputItem,
        data.successfulCrafts, data.failedCrafts))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `recipeId` | `string` | Recipe identifier |
| `recipeLabel` | `string` | Recipe display name |
| `quantity` | `number` | Number of items the player requested |
| `successfulCrafts` | `number` | Number of items that passed the quality roll |
| `failedCrafts` | `number` | Number of items that failed (partial-failure mode only) |
| `outputItem` | `string` | Item name that was granted |
| `outputAmount` | `number` | Output amount per craft (`recipe.outputAmount`, defaults to 1) |
| `totalOutputCount` | `number` | Total items granted (`successfulCrafts * outputAmount`) |
| `addedToStash` | `boolean` | Whether output went to the crafting stash instead of player inventory |
| `stationId` | `string` | Station identifier |
| `workbenchType` | `string\|nil` | Workbench type (e.g. `'basic'`, `'advanced'`) |
| `blueprintDestroyed` | `boolean` | Whether the recipe's blueprint was destroyed by this craft |
| `blueprintItem` | `string\|nil` | Blueprint item name if destroyed |
| `timestamp` | `number` | Unix timestamp |

---

### onCraftFailed

Triggered when a craft fails the quality roll (controlled by `recipe.failChance`). Ingredients have already been consumed at this point — they are **not** refunded.

```lua
ServerHooks.Register('onCraftFailed', function(data)
    print(('[SD-CRAFTING] %s failed %dx %s (%s)'):format(
        data.identifier, data.failedCrafts, data.recipeLabel, data.reason))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `recipeId` | `string` | Recipe identifier |
| `recipeLabel` | `string` | Recipe display name |
| `quantity` | `number` | Number of items the player requested |
| `failedCrafts` | `number` | Number of items that failed |
| `failChance` | `number` | The recipe's configured fail chance percentage |
| `stationId` | `string` | Station identifier |
| `workbenchType` | `string\|nil` | Workbench type |
| `reason` | `string` | `'quality_check_whole_batch'` or `'quality_check_all_items_failed'` |
| `timestamp` | `number` | Unix timestamp |

---

### onCraftRefunded

Triggered when a queued craft is cancelled and its ingredients/cost are returned to the player or to the staging inventory.

```lua
ServerHooks.Register('onCraftRefunded', function(data)
    print(('[SD-CRAFTING] %s cancelled %dx %s'):format(
        data.identifier, data.quantity, data.recipeLabel))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `recipeId` | `string` | Recipe identifier |
| `recipeLabel` | `string` | Recipe display name |
| `quantity` | `number` | Number of items refunded |
| `stationId` | `string` | Station identifier |
| `refundedIngredients` | `table` | Array of `{ item, amount, label }` returned |
| `refundedCost` | `number` | Cash returned (0 if recipe had no cost) |
| `timestamp` | `number` | Unix timestamp |

---

## Staging Inventory Events

### onItemStaged

Triggered when a player moves an item from their personal inventory into the crafting staging area.

```lua
ServerHooks.Register('onItemStaged', function(data)
    print(('[SD-CRAFTING] %s staged %dx %s at %s'):format(
        data.identifier, data.count, data.item, data.stationId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `stationId` | `string` | Station identifier |
| `item` | `string` | Item name |
| `label` | `string` | Item display label |
| `count` | `number` | Quantity staged |
| `slot` | `number\|nil` | Target staging slot |
| `durability` | `number\|nil` | Item durability if applicable (ox_inventory only) |
| `metadata` | `table\|nil` | Full item metadata table if non-empty |
| `timestamp` | `number` | Unix timestamp |

---

### onItemUnstaged

Triggered when a player moves an item out of the crafting staging area back into their personal inventory.

```lua
ServerHooks.Register('onItemUnstaged', function(data)
    print(('[SD-CRAFTING] %s unstaged %dx %s from %s'):format(
        data.identifier, data.count, data.item, data.stationId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `stationId` | `string` | Station identifier |
| `item` | `string` | Item name |
| `count` | `number` | Quantity unstaged |
| `slot` | `number\|nil` | Source staging slot |
| `timestamp` | `number` | Unix timestamp |

---

## Shared Queue Events

### onQueueItemAdded

Triggered when a craft is added to the shared queue of a station (only fires for stations with `CraftingBehavior.sharedCrafting` enabled).

```lua
ServerHooks.Register('onQueueItemAdded', function(data)
    print(('[SD-CRAFTING] %s queued a craft at %s (queue length: %d)'):format(
        data.identifier, data.stationId, data.queueLength))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID that added the item |
| `identifier` | `string` | Owner character identifier |
| `stationId` | `string` | Station identifier |
| `queueItem` | `table` | The full queue item (id, recipe, quantity, totalTime, owner, ownerName, etc.) |
| `queueLength` | `number` | New queue length after the addition |
| `timestamp` | `number` | Unix timestamp |

---

### onQueueItemRemoved

Triggered when an item is removed from a shared queue, either via cancellation by its owner or by a privileged player removing the currently-processing item.

```lua
ServerHooks.Register('onQueueItemRemoved', function(data)
    print(('[SD-CRAFTING] Queue item %s removed at %s'):format(
        data.queueItemId, data.stationId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID that removed the item |
| `identifier` | `string` | Character identifier of the remover |
| `stationId` | `string` | Station identifier |
| `queueItemId` | `string` | The queue item ID that was removed |
| `removedByOwner` | `boolean` | Whether the remover was the item's original owner |
| `timestamp` | `number` | Unix timestamp |

---

### onQueueItemCompleted

Triggered when the first item in a shared queue is completed and removed by the server. Fires regardless of who owns the completed item.

```lua
ServerHooks.Register('onQueueItemCompleted', function(data)
    print(('[SD-CRAFTING] Queue item completed at %s (remaining: %d)'):format(
        data.stationId, data.queueLength))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID that triggered the completion |
| `identifier` | `string` | Character identifier of the triggering player |
| `stationId` | `string` | Station identifier |
| `queueLength` | `number` | Queue length **after** the completion |
| `timestamp` | `number` | Unix timestamp |

---

## Blueprint Events

### onBlueprintAttached

Triggered when a player attaches a blueprint to a station, unlocking the recipes it gates.

```lua
ServerHooks.Register('onBlueprintAttached', function(data)
    print(('[SD-CRAFTING] %s attached blueprint %s to %s (durability: %s)'):format(
        data.identifier, data.blueprintItem, data.stationId,
        tostring(data.durability or 'n/a')))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `stationId` | `string` | Station identifier |
| `blueprintItem` | `string` | Blueprint item name |
| `durability` | `number\|nil` | Blueprint durability at the time of attachment (ox_inventory only) |
| `slot` | `number\|nil` | Source inventory slot the blueprint was taken from |
| `timestamp` | `number` | Unix timestamp |

---

### onBlueprintDetached

Triggered when a player detaches a blueprint from a station and returns it to their inventory.

```lua
ServerHooks.Register('onBlueprintDetached', function(data)
    print(('[SD-CRAFTING] %s detached blueprint %s from %s (via %s)'):format(
        data.identifier, data.blueprintItem, data.stationId, data.sourceLocation))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `stationId` | `string` | Station identifier |
| `blueprintItem` | `string` | Blueprint item name |
| `durability` | `number\|nil` | Remaining durability when detached |
| `sourceLocation` | `string` | `'station'` (attached natively) or `'staging'` (held in staging inventory) |
| `timestamp` | `number` | Unix timestamp |

---

## Tech Tree Events

### onTechNodeUnlocked

Triggered when a player spends tech points to unlock a node in a tech tree. Fires for both player-based progression and shared-workbench progression.

```lua
ServerHooks.Register('onTechNodeUnlocked', function(data)
    print(('[SD-CRAFTING] %s unlocked %s (%s) for %d points'):format(
        data.identifier, data.nodeLabel, data.treeLabel, data.cost))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `treeId` | `string` | Tech tree identifier |
| `nodeId` | `string` | Tech node identifier |
| `nodeLabel` | `string` | Node display label |
| `treeLabel` | `string` | Tree display label |
| `cost` | `number` | Tech points spent |
| `remainingPoints` | `number` | Tech points the unlocker has left |
| `stationId` | `string` | Station identifier where the unlock happened |
| `workbenchType` | `string\|nil` | Workbench type (when per-workbench tech is enabled) |
| `isShared` | `boolean` | `true` if this unlock applied to a shared-workbench tech pool, `false` if to player progression |
| `workbenchId` | `number\|nil` | Numeric placed-workbench ID (shared unlocks only) |
| `timestamp` | `number` | Unix timestamp |

---

## Workbench Placement Events

### onWorkbenchPlaced

Triggered after a player successfully places a portable workbench in the world and the database row has been created.

```lua
ServerHooks.Register('onWorkbenchPlaced', function(data)
    print(('[SD-CRAFTING] %s placed workbench %d (%s) at %.2f, %.2f, %.2f'):format(
        data.identifier, data.workbenchId, data.item,
        data.coords.x, data.coords.y, data.coords.z))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Owner character identifier |
| `workbenchId` | `number` | Database ID of the new workbench |
| `item` | `string` | Workbench item name |
| `workbenchType` | `string` | Workbench type |
| `prop` | `string` | Prop model name |
| `coords` | `vector3` | Placement coordinates |
| `heading` | `number` | Placement heading |
| `techId` | `string\|nil` | Persistent tech ID for shared tech data (reused across pickup/placement) |
| `timestamp` | `number` | Unix timestamp |

---

### onWorkbenchPickedUp

Triggered when the owner of a placed workbench picks it up. Fires before the workbench database row is deleted, but data fields reflect the workbench as it existed.

```lua
ServerHooks.Register('onWorkbenchPickedUp', function(data)
    print(('[SD-CRAFTING] %s picked up workbench %d (%s)'):format(
        data.identifier, data.workbenchId, data.item))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Owner character identifier |
| `workbenchId` | `number` | Database ID of the workbench |
| `item` | `string` | Workbench item name |
| `workbenchType` | `string` | Workbench type |
| `coords` | `vector3\|nil` | Last known coordinates |
| `timestamp` | `number` | Unix timestamp |

---

## Station Session Events

### onStationOpened

Triggered when a player opens a station (the server-side session is registered in `OpenStations`).

```lua
ServerHooks.Register('onStationOpened', function(data)
    print(('[SD-CRAFTING] %s opened station %s'):format(data.identifier, data.stationId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `stationId` | `string` | Station identifier |
| `timestamp` | `number` | Unix timestamp |

---

### onStationClosed

Triggered when a player closes a station and the server-side session is cleared.

```lua
ServerHooks.Register('onStationClosed', function(data)
    print(('[SD-CRAFTING] %s closed station %s'):format(data.identifier, data.stationId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `stationId` | `string` | Station identifier |
| `timestamp` | `number` | Unix timestamp |

---

### onShopOpened

Triggered when a player opens a crafting shop (the in-resource NPC shops, not sd-shops). The proximity check passes before this fires.

```lua
ServerHooks.Register('onShopOpened', function(data)
    print(('[SD-CRAFTING] %s opened shop %s'):format(data.identifier, data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `shopId` | `string` | Shop identifier |
| `timestamp` | `number` | Unix timestamp |

---

### onShopClosed

Triggered when a player closes a crafting shop and the server-side session is cleared.

```lua
ServerHooks.Register('onShopClosed', function(data)
    print(('[SD-CRAFTING] %s closed shop %s'):format(data.identifier, data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `shopId` | `string` | Shop identifier |
| `timestamp` | `number` | Unix timestamp |

---

## Shop Purchase Events

### onShopItemPurchased

Triggered when a player successfully purchases an item from a crafting shop and the item has been added to their inventory.

```lua
ServerHooks.Register('onShopItemPurchased', function(data)
    print(('[SD-CRAFTING] %s bought %dx %s for %d %s'):format(
        data.identifier, data.quantity, data.label,
        data.totalPrice, data.currency))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `shopId` | `string` | Shop identifier |
| `itemId` | `string` | Shop item identifier |
| `item` | `string` | Inventory item name granted |
| `label` | `string` | Item display label |
| `quantity` | `number` | Quantity purchased |
| `price` | `number` | Price per unit |
| `totalPrice` | `number` | Total price paid |
| `currency` | `string` | `'cash'`, `'bank'`, `'money'`, or an inventory item name |
| `newBalance` | `number` | Player's resulting balance (cash + bank, or item count) |
| `timestamp` | `number` | Unix timestamp |

---

### onShopPurchaseFailed

Triggered every time a shop purchase is rejected. Fires from multiple code paths — access denied, invalid shop, item not found, insufficient funds (cash/bank), insufficient items (item-currency shop), and inventory-full refund. The `reason` field distinguishes them.

```lua
ServerHooks.Register('onShopPurchaseFailed', function(data)
    print(('[SD-CRAFTING] %s failed to buy at %s: %s'):format(
        data.identifier, data.shopId, data.reason))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `identifier` | `string` | Player character identifier |
| `shopId` | `string` | Shop identifier |
| `itemId` | `string` | Shop item identifier |
| `label` | `string\|nil` | Item display label (only present once the item is resolved) |
| `quantity` | `number` | Quantity attempted |
| `totalPrice` | `number\|nil` | Total price (only present once the item is resolved) |
| `currency` | `string\|nil` | Currency type (only present once the item is resolved) |
| `reason` | `string` | Failure reason (`'Access denied'`, `'Invalid shop'`, `'Item not found'`, `'Not enough money'`, `'Not enough <currency>'`, `'Inventory full'`) |
| `timestamp` | `number` | Unix timestamp |

---

## Admin Events — Recipes

### onAdminRecipeCreated

Triggered when an admin creates a new recipe through the admin panel.

```lua
ServerHooks.Register('onAdminRecipeCreated', function(data)
    print(('[SD-CRAFTING] Admin %s created recipe %s in table %s'):format(
        data.identifier, data.recipeId, data.tableName))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `tableName` | `string` | Recipe table the recipe was added to |
| `recipeId` | `string` | Newly created recipe ID |
| `recipe` | `table` | Full recipe object |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminRecipeUpdated

Triggered when an admin edits an existing recipe through the admin panel.

```lua
ServerHooks.Register('onAdminRecipeUpdated', function(data)
    print(('[SD-CRAFTING] Admin %s updated recipe %s'):format(
        data.identifier, data.recipeId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `tableName` | `string` | Recipe table the recipe belongs to |
| `recipeId` | `string` | Recipe ID that was updated |
| `recipe` | `table` | Updated recipe object |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminRecipeDeleted

Triggered when an admin deletes a recipe through the admin panel. Config-defined recipes get a tombstone row; admin-created recipes are fully removed from the database.

```lua
ServerHooks.Register('onAdminRecipeDeleted', function(data)
    print(('[SD-CRAFTING] Admin %s deleted recipe %s from %s'):format(
        data.identifier, data.recipeId, data.tableName))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `tableName` | `string` | Recipe table the recipe was in |
| `recipeId` | `string` | Recipe ID that was deleted |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminRecipeMoved

Triggered when an admin moves a recipe from one recipe table to another.

```lua
ServerHooks.Register('onAdminRecipeMoved', function(data)
    print(('[SD-CRAFTING] Admin %s moved recipe %s: %s -> %s'):format(
        data.identifier, data.recipeId, data.fromTable, data.toTable))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `fromTable` | `string` | Source recipe table |
| `toTable` | `string` | Destination recipe table |
| `recipeId` | `string` | Recipe ID that was moved |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminRecipesReordered

Triggered when an admin reorders the recipes inside a table via drag-and-drop.

```lua
ServerHooks.Register('onAdminRecipesReordered', function(data)
    print(('[SD-CRAFTING] Admin %s reordered %d recipes in %s'):format(
        data.identifier, #data.orderedIds, data.tableName))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `tableName` | `string` | Recipe table that was reordered |
| `orderedIds` | `table` | Array of recipe IDs in the new display order |
| `timestamp` | `number` | Unix timestamp |

---

## Admin Events — Recipe Tables

### onAdminTableCreated

Triggered when an admin creates a new (empty) recipe table.

```lua
ServerHooks.Register('onAdminTableCreated', function(data)
    print(('[SD-CRAFTING] Admin %s created table %s'):format(
        data.identifier, data.tableName))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `tableName` | `string` | New table name |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminTableDeleted

Triggered when an admin deletes a recipe table along with all of its recipes. Only admin-created tables can be deleted — config-defined tables are protected and this hook will not fire for them.

```lua
ServerHooks.Register('onAdminTableDeleted', function(data)
    print(('[SD-CRAFTING] Admin %s deleted table %s'):format(
        data.identifier, data.tableName))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `tableName` | `string` | Table name that was deleted |
| `timestamp` | `number` | Unix timestamp |

---

## Admin Events — Stations & Types

### onAdminStationCreated

Triggered when an admin creates a new station through the admin panel.

```lua
ServerHooks.Register('onAdminStationCreated', function(data)
    print(('[SD-CRAFTING] Admin %s created station %s'):format(
        data.identifier, data.stationKey))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `stationKey` | `string` | Generated station key |
| `station` | `table` | Full station config |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminStationUpdated

Triggered when an admin edits an existing station. Fires for static stations (via override), placed workbenches (via override), and admin-created stations.

```lua
ServerHooks.Register('onAdminStationUpdated', function(data)
    print(('[SD-CRAFTING] Admin %s updated station %s'):format(
        data.identifier, data.stationKey))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `stationKey` | `string` | Station key that was updated |
| `station` | `table` | Updated station config |
| `timestamp` | `number` | Unix timestamp |

::: info
For static stations and placed workbenches, the update flows through the override system. This hook fires only for the admin-created station path — the static and placed-workbench update paths return early from helper functions and do not currently fire `onAdminStationUpdated`.
:::

---

### onAdminStationDeleted

Triggered when an admin deletes an admin-created station.

```lua
ServerHooks.Register('onAdminStationDeleted', function(data)
    print(('[SD-CRAFTING] Admin %s deleted station %s'):format(
        data.identifier, data.stationKey))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `stationKey` | `string` | Station key that was deleted |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminWorkbenchTypeDeleted

Triggered when an admin deletes an admin-created workbench type. The deletion is rejected (and the hook does **not** fire) if any station or placed workbench still uses the type.

```lua
ServerHooks.Register('onAdminWorkbenchTypeDeleted', function(data)
    print(('[SD-CRAFTING] Admin %s deleted workbench type %s'):format(
        data.identifier, data.typeId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `typeId` | `string` | Workbench type that was deleted |
| `timestamp` | `number` | Unix timestamp |

---

## Admin Events — Tech Trees

### onAdminTechTreeCreated

Triggered when an admin creates a new tech tree.

```lua
ServerHooks.Register('onAdminTechTreeCreated', function(data)
    print(('[SD-CRAFTING] Admin %s created tech tree %s'):format(
        data.identifier, data.treeId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `treeId` | `string` | New tree identifier |
| `tree` | `table` | Full tree object (label, icon, color, nodes) |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminTechTreeUpdated

Triggered when an admin edits a tech tree's metadata or its node list.

```lua
ServerHooks.Register('onAdminTechTreeUpdated', function(data)
    print(('[SD-CRAFTING] Admin %s updated tech tree %s'):format(
        data.identifier, data.treeId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `treeId` | `string` | Tree identifier |
| `tree` | `table` | Updated tree object |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminTechTreeDeleted

Triggered when an admin deletes a tech tree. Config-defined trees get a tombstone row; admin-created trees are fully removed.

```lua
ServerHooks.Register('onAdminTechTreeDeleted', function(data)
    print(('[SD-CRAFTING] Admin %s deleted tech tree %s'):format(
        data.identifier, data.treeId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `treeId` | `string` | Tree identifier that was deleted |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminTechNodeCreated

Triggered when an admin creates a new node inside an existing tech tree.

```lua
ServerHooks.Register('onAdminTechNodeCreated', function(data)
    print(('[SD-CRAFTING] Admin %s created node %s in tree %s'):format(
        data.identifier, data.nodeId, data.treeId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `treeId` | `string` | Parent tree identifier |
| `nodeId` | `string` | New node identifier |
| `node` | `table` | Full node object (id, recipeId, cost, prerequisites, position) |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminTechNodeUpdated

Triggered when an admin edits an existing tech tree node.

```lua
ServerHooks.Register('onAdminTechNodeUpdated', function(data)
    print(('[SD-CRAFTING] Admin %s updated node %s'):format(
        data.identifier, data.nodeId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `treeId` | `string` | Parent tree identifier |
| `nodeId` | `string` | Node identifier |
| `node` | `table` | Updated node object |
| `timestamp` | `number` | Unix timestamp |

---

### onAdminTechNodeDeleted

Triggered when an admin deletes a tech tree node. References to the deleted node in other nodes' prerequisites are also cleaned up.

```lua
ServerHooks.Register('onAdminTechNodeDeleted', function(data)
    print(('[SD-CRAFTING] Admin %s deleted node %s from %s'):format(
        data.identifier, data.nodeId, data.treeId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Admin server ID |
| `identifier` | `string` | Admin character identifier |
| `treeId` | `string` | Parent tree identifier |
| `nodeId` | `string` | Node identifier that was deleted |
| `timestamp` | `number` | Unix timestamp |

---

## Integration Examples

### Discord Webhook for Crafting

```lua
local webhookUrl = 'https://discord.com/api/webhooks/...'

ServerHooks.Register('onCraftCompleted', function(data)
    PerformHttpRequest(webhookUrl, function() end, 'POST', json.encode({
        embeds = {{
            title = 'Item Crafted',
            description = ('**%s** crafted **%dx %s** at `%s`'):format(
                data.identifier, data.totalOutputCount, data.outputItem, data.stationId),
            color = 3066993,
            timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ', data.timestamp)
        }}
    }), { ['Content-Type'] = 'application/json' })
end)
```

### MDT Weapon Registration

```lua
ServerHooks.Register('onCraftCompleted', function(data)
    -- Only register crafted weapons in the MDT
    if not data.outputItem:find('^weapon_') then return end

    exports['your-mdt']:RegisterWeapon({
        weapon = data.outputItem,
        owner = data.identifier,
        craftedAt = os.date('%Y-%m-%d %H:%M:%S', data.timestamp),
        station = data.stationId,
    })
end)
```

### Admin Audit Trail

```lua
local function logAdminAction(action, data)
    MySQL.insert('INSERT INTO admin_audit (identifier, action, payload, created_at) VALUES (?, ?, ?, NOW())', {
        data.identifier, action, json.encode(data)
    })
end

ServerHooks.Register('onAdminRecipeCreated',  function(d) logAdminAction('recipe_created',  d) end)
ServerHooks.Register('onAdminRecipeUpdated',  function(d) logAdminAction('recipe_updated',  d) end)
ServerHooks.Register('onAdminRecipeDeleted',  function(d) logAdminAction('recipe_deleted',  d) end)
ServerHooks.Register('onAdminStationCreated', function(d) logAdminAction('station_created', d) end)
ServerHooks.Register('onAdminStationDeleted', function(d) logAdminAction('station_deleted', d) end)
```

---

::: tip Integration Ideas
Use server hooks to:
- Stream crafting activity to a Discord webhook or analytics dashboard
- Register crafted weapons / items in a police MDT or item-tracking system
- Build a full audit log of admin recipe and station changes
- Reward players via external systems on milestone crafts
- Track shared-workbench usage for ownership analytics
- Implement custom anti-exploit logic on craft completion patterns
- Notify Discord on tech-tree progression milestones
:::
