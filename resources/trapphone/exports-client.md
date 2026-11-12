# Client Exports

Exports that change anything go to the server, which checks and paces them like any other request from a client. They wait for its answer, so call them from a thread (an event handler or `CreateThread`).

## isOpen

Whether the trap phone is out.

**Syntax**
```lua
local open = exports['sd-trapphone']:isOpen()
```

| Return | Type | Description |
|---|---|---|
| `open` | `boolean` | `true` while the handset is open |

## getActivePhone

The phone the player last had out.

**Syntax**
```lua
local phone = exports['sd-trapphone']:getActivePhone()
```

| Return | Type | Description |
|---|---|---|
| `phone` | `table?` | `{ id, number }`, or `nil` if they haven't opened one |

## usePhone

Open or close the phone, as using the item does. ox_inventory calls it through the item's `client.export` (see `items.md`).

**Syntax**
```lua
exports['sd-trapphone']:usePhone()
```

## isCornerSelling / isDoingDropOffs

What the player is doing on the street.

**Syntax**
```lua
local selling = exports['sd-trapphone']:isCornerSelling()
local running = exports['sd-trapphone']:isDoingDropOffs()
```

| Return | Type | Description |
|---|---|---|
| `selling` / `running` | `boolean` | Serving a corner / on a drop-off run |

## isBusy

Whether the player is in the middle of a sale, a meeting, bagging up, or anything else the trap phone runs. Useful before starting something of your own that would clash.

**Syntax**
```lua
local busy = exports['sd-trapphone']:isBusy()
```

**Example**
```lua
if exports['sd-trapphone']:isBusy() then
    return lib.notify({ description = 'Finish what you are doing first.', type = 'error' })
end
```

## sendMessage

Put a text on the player's own trap phone.

**Syntax**
```lua
local sent = exports['sd-trapphone']:sendMessage(text, sender)
```

| Parameter | Type | Description |
|---|---|---|
| `text` | `string` | Up to 160 characters |
| `sender` | `string?` | Who it shows as coming from. It can't be a real number (a saved contact or another player's phone), so a client can't fake a text from someone real |

| Return | Type | Description |
|---|---|---|
| `sent` | `boolean` | `false` if refused (no phone, empty text, a real number as sender, or too soon after the last one) |

**Example**
```lua
exports['sd-trapphone']:sendMessage('package is at the docks. come alone', 'Unknown')
```

## addContact

Save a plain contact on the player's own trap phone.

**Syntax**
```lua
local added = exports['sd-trapphone']:addContact({ number = '555-0199', name = 'Tony' })
```

| Return | Type | Description |
|---|---|---|
| `added` | `boolean` | `false` if refused |

## meetNewContact

Point the map at an introduction that is waiting, or ask for one. Asking has the same odds and unlock rules as a level-up, and the server only listens now and then.

**Syntax**
```lua
local meeting = exports['sd-trapphone']:meetNewContact()
```

| Return | Type | Description |
|---|---|---|
| `meeting` | `boolean` | `true` when there is (now) an introduction to go to |

## getPedRelationship

The player's relationship with a ped's look, from -100 to 100. A look is the ped's model, head and texture, so the same person is recognised on the street again.

**Syntax**
```lua
local relationship = exports['sd-trapphone']:getPedRelationship(pedKey)
```

| Return | Type | Description |
|---|---|---|
| `relationship` | `integer` | -100 to 100, 0 for someone new |

## updatePedRelationship

Move the player's relationship with a ped's look. Souring one is free; sweetening one is capped at a sale's worth and allowed about once a minute, because a good relationship is worth money.

**Syntax**
```lua
local value = exports['sd-trapphone']:updatePedRelationship(pedKey, amount)
```

| Return | Type | Description |
|---|---|---|
| `value` | `integer \| false` | The relationship afterwards, or `false` when the server refused |
