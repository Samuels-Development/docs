# Server Exports

Other resources are trusted callers, but every argument is still checked, so a typo returns `false` instead of corrupting a phone.

A phone is named by its id or by its burner number. Ids look like `tp_...` for a phone item with its own id, or `cid_<citizenid>` for a character's shared phone (when `UniqueMetadataPhones` is off, or an item has no id yet).

## sendMessageToPhone

Text a phone.

**Syntax**
```lua
local sent = exports['sd-trapphone']:sendMessageToPhone(from, to, text)
```

| Parameter | Type | Description |
|---|---|---|
| `from` | `string` | The number or name the message shows under (up to 24 characters). A burner's own number makes it a text from that player |
| `to` | `string` | The receiving phone's number or id |
| `text` | `string` | Up to 160 characters |

| Return | Type | Description |
|---|---|---|
| `sent` | `boolean` | `false` if there is no such phone or the text was empty |

**Example**
```lua
exports['sd-trapphone']:sendMessageToPhone('Dispatch', '555-0142', 'heat is on your block. lay low')
```

## addContactToPhone

Save a contact on a phone.

**Syntax**
```lua
local added = exports['sd-trapphone']:addContactToPhone(phoneId, contact)
```

| Parameter | Type | Description |
|---|---|---|
| `phoneId` | `string` | The phone's id or number |
| `contact` | `table` | `{ number, name, type? }`. `type` is a contact type from `configs/shared/contacts.lua`; anything else saves as `'custom'` |

| Return | Type | Description |
|---|---|---|
| `added` | `boolean` | `false` if refused |

## getContact / getAllContacts

**Syntax**
```lua
local contact = exports['sd-trapphone']:getContact(phoneId, number)
local contacts = exports['sd-trapphone']:getAllContacts(phoneId)
```

| Return | Type | Description |
|---|---|---|
| `contact` | `table?` | `{ number, name, type, key?, gang? }`, or `nil` |
| `contacts` | `table[]` | Every saved contact, or an empty list |

Both return copies: changing them changes nothing on the phone.

## verifyPhoneOwnership

Whether a player is carrying the phone with this id right now.

**Syntax**
```lua
local carries = exports['sd-trapphone']:verifyPhoneOwnership(source, phoneId)
```

| Return | Type | Description |
|---|---|---|
| `carries` | `boolean` | |

## addXP / removeXP

Move XP in a product family on the phone a player carries.

**Syntax**
```lua
local level = exports['sd-trapphone']:addXP(source, family, amount)
local level = exports['sd-trapphone']:removeXP(source, family, amount)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `integer` | The player's server id |
| `family` | `string` | A key of `Families` in `configs/shared/drugs.lua`: `'weed'`, `'coke'`, `'meth'` |
| `amount` | `integer` | A whole, positive number |

| Return | Type | Description |
|---|---|---|
| `level` | `integer \| false` | The level afterwards, or `false` (no phone, unknown family, bad amount) |

**Example**
```lua
-- a weed farming resource rewarding a harvest
exports['sd-trapphone']:addXP(source, 'weed', 25)
```

## increaseGangRep / decreaseGangRep

Move a player's standing with a crew. A player whose job shares one standing (`SharedJobRep`, e.g. police) moves their job's.

**Syntax**
```lua
local rep = exports['sd-trapphone']:increaseGangRep(source, gang, amount)
local rep = exports['sd-trapphone']:decreaseGangRep(source, gang, amount)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `integer` | The player's server id |
| `gang` | `string` | A key of `List` in `configs/shared/gangs.lua` |
| `amount` | `integer` | A whole, positive number |

| Return | Type | Description |
|---|---|---|
| `rep` | `integer \| false` | The standing afterwards, or `false` |

## increaseJobGangRep / decreaseJobGangRep

Move a shared-rep job's standing with a crew directly.

**Syntax**
```lua
local rep = exports['sd-trapphone']:increaseJobGangRep(job, gang, amount)
local rep = exports['sd-trapphone']:decreaseJobGangRep(job, gang, amount)
```

| Parameter | Type | Description |
|---|---|---|
| `job` | `string` | A job listed in `SharedJobRep` in `configs/server/gangs.lua` |
| `gang` | `string` | A key of `List` in `configs/shared/gangs.lua` |
| `amount` | `integer` | A whole, positive number |

| Return | Type | Description |
|---|---|---|
| `rep` | `integer \| false` | The standing afterwards, or `false` when the job doesn't share a standing |
