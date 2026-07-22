---
title: Server Exports
description: Server-side exports for phone numbers, notifications, messages, calls, mail, banking, and app data from other scripts.
---

# Server Exports

The phone provides server-side exports for other resources: resolving phone numbers, pushing notifications, sending messages and mail, starting calls, and reading contacts, groups, and app data. Exports that act on a player's behalf take the acting player's `source` and walk the exact same validation as the phone's own UI, so a sloppy caller cannot corrupt a mailbox, mint a payment card, or plant an invalid contact.

::: info
Several mutating exports return the phone's standard envelope shape: `{ success = boolean, message = string?, data = table? }`. Where a return below says `envelope`, this is that shape.
:::

The first group of exports resolves phone numbers, owners, and connectivity. Every character has exactly one number.

## getPhoneNumber

Get a player's phone number by server ID, assigning one on first access.

**Syntax**
```lua
local number = exports['sd-phone']:getPhoneNumber(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `number` | `string?` | The raw-digit phone number, or `nil` when the source does not resolve to a loaded character |

**Example**
```lua
RegisterCommand('mynumber', function(source)
    local number = exports['sd-phone']:getPhoneNumber(source)
    if number then
        TriggerClientEvent('chat:addMessage', source, { args = { 'Phone', 'Your number is ' .. number } })
    end
end)
```

## getPhoneNumberByIdentifier

Get a character's phone number straight from a citizenid, for resources that hold identifiers rather than server IDs. Works for offline characters.

**Syntax**
```lua
local number = exports['sd-phone']:getPhoneNumberByIdentifier(citizenid, ensure)
```

| Parameter | Type | Description |
|---|---|---|
| `citizenid` | `string` | The character's framework identifier |
| `ensure` | `boolean?` | Pass `true` to assign a number on first access, the way `getPhoneNumber` does. Otherwise a never-assigned character yields `nil` |

| Return | Type | Description |
|---|---|---|
| `number` | `string?` | The raw-digit phone number, or `nil` for a malformed citizenid or a never-assigned character without `ensure` |

**Example**
```lua
-- Look up an offline employee's number before texting them
local number = exports['sd-phone']:getPhoneNumberByIdentifier(citizenid)
```

## getIdentifierByNumber

Get the citizenid that owns a phone number. Both sides are digit-normalized, so any formatting matches.

**Syntax**
```lua
local citizenid = exports['sd-phone']:getIdentifierByNumber(number)
```

| Parameter | Type | Description |
|---|---|---|
| `number` | `string` | A phone number in any formatting |

| Return | Type | Description |
|---|---|---|
| `citizenid` | `string?` | The owning character's citizenid, or `nil` when the number is unassigned |

**Example**
```lua
local citizenid = exports['sd-phone']:getIdentifierByNumber('555-0142')
if citizenid then
    -- pay the number's owner even while they are offline
end
```

## getSourceByNumber

Get the connected server ID of the player that owns a phone number.

**Syntax**
```lua
local playerId = exports['sd-phone']:getSourceByNumber(number)
```

| Parameter | Type | Description |
|---|---|---|
| `number` | `string` | A phone number in any formatting |

| Return | Type | Description |
|---|---|---|
| `playerId` | `number?` | The owner's server ID, or `nil` when the number is unassigned or its owner is offline |

**Example**
```lua
local playerId = exports['sd-phone']:getSourceByNumber(customerNumber)
if playerId then
    -- the customer is online, deliver the order in person
end
```

## isNumberInService

Check whether a phone number is assigned to any character. Useful for validating user-supplied numbers before sending anything at them.

**Syntax**
```lua
local inService = exports['sd-phone']:isNumberInService(number)
```

| Parameter | Type | Description |
|---|---|---|
| `number` | `string` | A phone number in any formatting |

| Return | Type | Description |
|---|---|---|
| `inService` | `boolean` | `true` when the number is assigned to a character. Empty or digitless input is `false` |

**Example**
```lua
if not exports['sd-phone']:isNumberInService(input) then
    return notifyPlayer(source, 'That number is not in service.')
end
```

## isAirplaneMode

Check whether a player currently has airplane mode switched on.

**Syntax**
```lua
local on = exports['sd-phone']:isAirplaneMode(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `on` | `boolean` | `true` when airplane mode is on. An unresolvable source reads as `false` |

::: info
The value is served from an in-memory cache after the first read, so it is cheap enough to call once per routed message or call.
:::

**Example**
```lua
if not exports['sd-phone']:isAirplaneMode(target) then
    -- safe to ring them
end
```

The notification exports push iOS-style banners onto a player's phone.

## notify

Send a phone notification banner to a player by server ID.

**Syntax**
```lua
local sent = exports['sd-phone']:notify(source, data)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `data` | `table` | Notification payload (see below) |

| Field | Type | Description |
|---|---|---|
| `title` | `string` | Required banner title |
| `app` | `string?` | App-icon ID (e.g. `"messages"`) |
| `image` | `string?` | Custom icon URL, overrides `app` |
| `body` | `string?` | Banner body text |
| `time` | `string?` | Display time string (e.g. `"now"`) |
| `appId` | `string?` | The app opened when the banner is tapped |

| Return | Type | Description |
|---|---|---|
| `sent` | `boolean` | `false` on a non-number source or a payload without a string `title` |

**Example**
```lua
exports['sd-phone']:notify(source, {
    app   = 'mail',
    title = 'City Hall',
    body  = 'Your business licence has been approved.',
    time  = 'now',
    appId = 'mail',
})
```

## notifyNumber

Send the same notification banner addressed by phone number instead of server ID. The number is digit-normalized before lookup, so any formatting matches.

**Syntax**
```lua
local sent = exports['sd-phone']:notifyNumber(number, data)
```

| Parameter | Type | Description |
|---|---|---|
| `number` | `string` | The recipient's phone number in any formatting |
| `data` | `table` | Notification payload, same contract as [notify](#notify) |

| Return | Type | Description |
|---|---|---|
| `sent` | `boolean` | `false` for a digitless number, an unassigned number, or an offline owner |

**Example**
```lua
-- A dispatch script updating the caller that reported the incident
exports['sd-phone']:notifyNumber(reporterNumber, {
    app   = 'phone',
    title = 'Dispatch',
    body  = 'Officers have been dispatched to your location.',
    appId = 'phone',
})
```

The message exports send SMS on a player's behalf or as a service.

## sendMessage

Send a message on a player's behalf. Mirrors the phone's own composer payload and walks the full composer validation (kind whitelist, length caps, banking-validated money), so a caller cannot move unchecked funds.

**Syntax**
```lua
local result = exports['sd-phone']:sendMessage(source, payload)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The acting player's server ID; the sender's identity resolves from it |
| `payload` | `table` | Composer payload (see below) |

| Field | Type | Description |
|---|---|---|
| `conversation` | `string` | A phone number, or `"g-<groupId>"` for a group thread |
| `body` | `string` | Message body |
| `kind` | `string?` | Optional bubble kind, same whitelist as the composer |
| `gifUrl` | `string?` | Media URL for image and gif kinds |
| `amount` | `number?` | Amount for money kinds, banking-validated |
| `duration` | `number?` | Duration for voice-note kinds |
| `wpCode` | `string?` | Waypoint code for the location kind |
| `wpSub` | `string?` | Location label for the location kind |

| Return | Type | Description |
|---|---|---|
| `result` | `table` | The standard envelope |

**Example**
```lua
exports['sd-phone']:sendMessage(source, {
    conversation = targetNumber,
    body         = 'Package delivered to the drop-off.',
})
```

## sendSystemMessage

Deliver a one-way service-to-player SMS from a short code, without any player acting as the sender. No sender mailbox copy is stored and the recipient's block list is bypassed. A recipient in airplane mode has the message withheld until they switch it off.

**Syntax**
```lua
local delivered = exports['sd-phone']:sendSystemMessage(senderNumber, senderName, targetNumber, body, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `senderNumber` | `string` | Service short code the recipient's thread files under, capped at 32 characters |
| `senderName` | `string` | Display name for the banner and thread header, capped at 64 characters |
| `targetNumber` | `string` | The recipient's phone number in any formatting |
| `body` | `string` | Message body, capped at the configured maximum length |
| `opts` | `table?` | Optional presentation kind (see below) |

| Field | Type | Description |
|---|---|---|
| `kind` | `string?` | `"image"`, `"gif"`, or `"location"`. Anything outside the whitelist is delivered as plain text |
| `gifUrl` | `string?` | Media URL for the `image` and `gif` kinds |
| `wpCode` | `string?` | Waypoint code for the `location` kind |
| `wpSub` | `string?` | Location label for the `location` kind |

| Return | Type | Description |
|---|---|---|
| `delivered` | `boolean` | `false` on blank numbers, missing content for the kind, or a target number not in service |

::: info
Money kinds are never accepted on this path, so a service message can never mint a payment card.
:::

**Example**
```lua
-- A taxi script letting the customer know their ride is outside
exports['sd-phone']:sendSystemMessage('8294', 'Downtown Cab Co.', customerNumber,
    'Your taxi has arrived. Look for the yellow Washington.')
```

The call exports start, inspect, and end phone calls on a player's behalf.

## startCall

Start a 1:1 call on a player's behalf. The full player-originated validation applies: already-on-a-call and airplane checks, digit normalization, self-call guard, number-in-service, callee reachability and busy.

**Syntax**
```lua
local result = exports['sd-phone']:startCall(source, number)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The acting caller's server ID |
| `number` | `string` | The number to dial, any formatting |

| Return | Type | Description |
|---|---|---|
| `result` | `table` | `{ success = true, data = { channel } }` on success, `{ success = false, message }` otherwise. `channel` is the voice call channel |

**Example**
```lua
local result = exports['sd-phone']:startCall(source, '555-0142')
if not result.success then
    print('Call failed: ' .. (result.message or 'unknown'))
end
```

## startGroupCall

Ring several players at once on a caller's behalf, for example a dispatch line ringing every on-duty unit.

**Syntax**
```lua
local result = exports['sd-phone']:startGroupCall(source, targetSources, displayName, displayNumber)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The acting caller's server ID |
| `targetSources` | `table` | Array of recipient server IDs. Unresolvable entries are dropped and the scan is bounded at 64 |
| `displayName` | `string` | What the caller sees they are calling (e.g. `"Police"`). Required non-empty, capped at 40 characters |
| `displayNumber` | `string?` | Optional display number shown to recipients |

| Return | Type | Description |
|---|---|---|
| `result` | `table` | Same envelope as [startCall](#startcall). Recipients who are the caller, busy, or in airplane mode are filtered out |

**Example**
```lua
local onDuty = getOnDutyOfficers() -- your own list of server IDs
exports['sd-phone']:startGroupCall(source, onDuty, 'Dispatch', '911')
```

## getCurrentCall

Read a player's live call from their own perspective. Read-only.

**Syntax**
```lua
local call = exports['sd-phone']:getCurrentCall(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `call` | `table?` | `{ channel, phase, number, name, elapsed }` where `phase` is `"outgoing"`, `"incoming"`, or `"active"`. `nil` when the player is not in a call or pending ring |

**Example**
```lua
local call = exports['sd-phone']:getCurrentCall(source)
if call and call.phase == 'active' then
    print(('On a call with %s for %ds'):format(call.name or call.number, call.elapsed))
end
```

## isInCall

Check whether a player is currently in a call or pending ring. Boolean shorthand over [getCurrentCall](#getcurrentcall).

**Syntax**
```lua
local inCall = exports['sd-phone']:isInCall(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `inCall` | `boolean` | `true` while the player is in a call or being rung |

**Example**
```lua
if exports['sd-phone']:isInCall(source) then
    return notifyPlayer(source, 'Finish your call first.')
end
```

## endCallFor

End whatever call a player is in, on their behalf. The player's own channel is resolved internally, no raw channel argument is accepted, so a caller can never end someone else's call.

**Syntax**
```lua
local result = exports['sd-phone']:endCallFor(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `result` | `table` | `{ success = boolean, message = string? }`. Idempotent: a player not in any call returns success |

**Example**
```lua
-- Cut the line when the player is downed
exports['sd-phone']:endCallFor(source)
```

The contact exports read and mutate a player's contacts, recents, and block list.

## logCall

Log a call into a player's recents, for external calling systems. Every field is re-validated regardless of caller.

**Syntax**
```lua
local result = exports['sd-phone']:logCall(source, payload)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `payload` | `table` | `{ number, name?, direction?, duration? }` |

| Return | Type | Description |
|---|---|---|
| `result` | `table` | The standard envelope |

**Example**
```lua
exports['sd-phone']:logCall(source, {
    number    = '911',
    name      = 'Emergency Services',
    direction = 'outgoing',
    duration  = 45,
})
```

## getContacts

Read a player's contacts, already serialized to the shape the app renders. Read-only.

**Syntax**
```lua
local contacts = exports['sd-phone']:getContacts(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `contacts` | `table?` | Array of contact tables, or `nil` when the player cannot be resolved |

**Example**
```lua
local contacts = exports['sd-phone']:getContacts(source)
print(('Player has %d contacts'):format(contacts and #contacts or 0))
```

## addContact

Create a contact for a player. Walks the exact same validation as the app's own add flow: the number must be in service, not the player's own, not a duplicate, and under the per-player cap. On success the new card is pushed live to the player's open phone.

**Syntax**
```lua
local result = exports['sd-phone']:addContact(source, fields)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The acting player's server ID |
| `fields` | `table` | Contact fields (see below) |

| Field | Type | Description |
|---|---|---|
| `phone` | `string` | The contact's phone number, any formatting |
| `name` | `string?` | Display name |
| `email` | `string?` | Email address |
| `address` | `string?` | Street address |
| `avatar` | `string?` | Avatar image URL |

| Return | Type | Description |
|---|---|---|
| `result` | `table` | The standard envelope |

**Example**
```lua
-- Hand the player a quest giver's number
exports['sd-phone']:addContact(source, {
    name  = 'Lester',
    phone = '5550187',
})
```

## removeContactByNumber

Remove every contact matching a number from a player's list. The number is accepted in any format and digit-normalized before matching.

**Syntax**
```lua
local result = exports['sd-phone']:removeContactByNumber(source, number)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The acting player's server ID |
| `number` | `string` | The number to remove, any formatting |

| Return | Type | Description |
|---|---|---|
| `result` | `table` | `{ success, data = { removed = n } }`. A number matching nothing still succeeds with `removed = 0` |

**Example**
```lua
exports['sd-phone']:removeContactByNumber(source, '5550187')
```

## getContactByNumber

Look up one of a player's own contacts by number, serialized to the shape the app renders. Read-only.

**Syntax**
```lua
local contact = exports['sd-phone']:getContactByNumber(source, number)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The acting player's server ID |
| `number` | `string` | The number to look up, any formatting |

| Return | Type | Description |
|---|---|---|
| `contact` | `table?` | The contact table, or `nil` when the player, the digits, or a matching contact cannot be resolved |

**Example**
```lua
local contact = exports['sd-phone']:getContactByNumber(source, callerNumber)
local display = contact and contact.name or callerNumber
```

## isNumberBlocked

Check whether a player has a number on their block list, for example a calling system deciding whether to ring them. Read-only; garbage input answers `false`.

**Syntax**
```lua
local blocked = exports['sd-phone']:isNumberBlocked(source, number)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player whose block list is checked |
| `number` | `string` | The number to check, any formatting |

| Return | Type | Description |
|---|---|---|
| `blocked` | `boolean` | `true` when the number is on the player's block list |

**Example**
```lua
-- A taxi script skipping customers who blocked the taxi line
local customer = exports['sd-phone']:getSourceByNumber(customerNumber)
if customer and not exports['sd-phone']:isNumberBlocked(customer, TAXI_NUMBER) then
    exports['sd-phone']:startCall(driverSource, customerNumber)
end
```

The mail exports deliver and read mailbox data.

## sendMail

Send mail as the system sender, for automated senders like payroll, city hall, or a job script.

**Syntax**
```lua
local result = exports['sd-phone']:sendMail(mail)
```

| Parameter | Type | Description |
|---|---|---|
| `mail` | `table` | Mail payload (see below) |

| Field | Type | Description |
|---|---|---|
| `to` | `string\|string[]` | One address or a list. Deduped and capped at 20 recipients |
| `subject` | `string?` | Truncated to the compose cap |
| `body` | `string?` | Truncated to the compose cap |
| `from` | `table?` | `{ name?, email? }`. Display-only, never resolved to an account; defaults to the System sender |
| `attachments` | `(string\|table)[]?` | Up to 5 attachments (see below); extras and malformed entries are dropped server-side |

Each attachment is either a plain URL string, shorthand for a photo, or a tagged table:

| Shape | Renders as |
|---|---|
| `'https://...'` | Photo (same as the tagged photo shape) |
| `{ kind = 'photo', url }` | Tappable image with a fullscreen viewer; the recipient can save it to their Photos |
| `{ kind = 'audio', url, name?, duration? }` | Inline audio player; savable to Voice Memos. `duration` is seconds |
| `{ kind = 'note', title?, body? }` | Readable note card; savable to Notes. At least one of `title`/`body` required |

| Return | Type | Description |
|---|---|---|
| `result` | `table` | `{ success = boolean, delivered = number }`. Unregistered addresses are silently skipped; `delivered` counts the ones that existed |

**Example**
```lua
-- A job script mailing a payslip at the end of a shift
local addresses = exports['sd-phone']:getMailAddresses(citizenid)
if addresses[1] then
    exports['sd-phone']:sendMail({
        to      = addresses[1].email,
        subject = 'Payslip - Week 32',
        body    = ('Hours worked: %d\nTotal pay: $%d'):format(hours, pay),
        from    = { name = 'Los Santos Customs', email = 'payroll@lscustoms.com' },
        attachments = {
            'https://cdn.example.com/payslips/week32.png',
            { kind = 'note', title = 'Overtime policy', body = 'Overtime pays 1.5x after 40 hours.' },
        },
    })
end
```

## sendMailFromPlayer

Send mail on a player's behalf, as if they composed it themselves. The player must be signed into `fromEmail`, the From header is rebuilt from the account row, and the full compose validation applies.

**Syntax**
```lua
local result = exports['sd-phone']:sendMailFromPlayer(source, payload)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The acting player's server ID; the sender's identity resolves from it |
| `payload` | `table` | `{ fromEmail, to = string[], subject?, body?, attachments? }`. Attachments use the tagged-table shapes documented under [sendMail](#sendmail) (the plain-string photo shorthand applies to `sendMail` only) |

| Return | Type | Description |
|---|---|---|
| `result` | `table` | The standard envelope; `data.sent` is the serialized sent copy on success |

**Example**
```lua
exports['sd-phone']:sendMailFromPlayer(source, {
    fromEmail = playerEmail,
    to        = { 'applications@lspd.gov' },
    subject   = 'Job application',
    body      = 'I would like to apply for the open position.',
})
```

## getMailAccounts

Get every mail account a player is signed into, in creation order. Never carries password hashes.

**Syntax**
```lua
local accounts = exports['sd-phone']:getMailAccounts(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `accounts` | `table[]` | `{ id, name, email }` per account. Empty when the source is offline or signed into nothing |

**Example**
```lua
local accounts = exports['sd-phone']:getMailAccounts(source)
for _, acc in ipairs(accounts) do
    print(acc.email)
end
```

## getMailAddresses

Get the same account shape keyed by citizenid instead of a live source. Works for offline players.

**Syntax**
```lua
local accounts = exports['sd-phone']:getMailAddresses(citizenid)
```

| Parameter | Type | Description |
|---|---|---|
| `citizenid` | `string` | The character's framework identifier |

| Return | Type | Description |
|---|---|---|
| `accounts` | `table[]` | `{ id, name, email }` per account, `{}` when none exist |

::: info
The citizenid must be a non-empty string without `%` or `_` characters; the session lookup treats both as wildcards, so patterned input returns `{}` instead of matching other citizens.
:::

**Example**
```lua
local addresses = exports['sd-phone']:getMailAddresses(citizenid)
```

## mailAddressExists

Check whether a mail address resolves to a registered account. The address is trimmed and lowercased before the lookup.

**Syntax**
```lua
local exists = exports['sd-phone']:mailAddressExists(email)
```

| Parameter | Type | Description |
|---|---|---|
| `email` | `string` | The address to check |

| Return | Type | Description |
|---|---|---|
| `exists` | `boolean` | `true` when a registered account owns the address. Non-string or empty input is `false` |

**Example**
```lua
if exports['sd-phone']:mailAddressExists('payroll@lscustoms.com') then
    -- safe to reference in a reply
end
```

## getMailbox

Read a mailbox's messages, in the same serialized shape the app renders.

**Syntax**
```lua
local messages = exports['sd-phone']:getMailbox(email, folder)
```

| Parameter | Type | Description |
|---|---|---|
| `email` | `string` | The account address |
| `folder` | `string?` | One of `inbox`, `drafts`, `sent`, `spam`, `bin`. Omit for every message in the account |

| Return | Type | Description |
|---|---|---|
| `messages` | `table[]?` | Serialized mail messages, or `nil` when the account does not exist or the folder is invalid |

::: info
`flagged` is a virtual view in the app, not a real folder, so it is not a valid `folder` argument here.
:::

**Example**
```lua
local inbox = exports['sd-phone']:getMailbox('payroll@lscustoms.com', 'inbox')
```

The banking exports write and read the Wallet app's transaction log.

## addBankTransaction

Append a transaction row to a character's Wallet list. Log-only: it does NOT move money; the calling resource owns the actual credit or debit. Works for offline characters.

**Syntax**
```lua
local ok = exports['sd-phone']:addBankTransaction(identifier, data)
```

| Parameter | Type | Description |
|---|---|---|
| `identifier` | `string` | The recipient character's citizenid |
| `data` | `table` | Transaction fields (see below) |

| Field | Type | Description |
|---|---|---|
| `label` | `string` | Transaction label shown in the Wallet list |
| `amount` | `number` | Signed amount: positive = money in, negative = money out |
| `category` | `string?` | Optional category |
| `counterparty` | `string?` | Who the money came from or went to |
| `notify` | `boolean\|string?` | Set only for incoming payments the player did not initiate. `true` pops a default "You received $X" banner, a string pops that exact line |

| Return | Type | Description |
|---|---|---|
| `ok` | `boolean` | `true` when the row was accepted |

::: info
A server-side event alternative exists for resources that prefer `TriggerEvent`: `TriggerEvent('sd-phone:bank:addTransaction', citizenid, data)`. It is a plain event handler, so only server code can raise it.
:::

**Example**
```lua
-- Log a paycheck after the framework pays it out
exports['sd-phone']:addBankTransaction(citizenid, {
    label        = 'Paycheck',
    amount       = 500,
    category     = 'income',
    counterparty = 'LSPD',
    notify       = true,
})
```

## getBankTransactions

Read a character's Wallet transaction log, newest first. Read-only.

**Syntax**
```lua
local rows = exports['sd-phone']:getBankTransactions(citizenid, limit)
```

| Parameter | Type | Description |
|---|---|---|
| `citizenid` | `string` | The owning character's citizenid |
| `limit` | `number?` | Row cap, defaults to the configured transaction limit, floored and clamped to 1..100 |

| Return | Type | Description |
|---|---|---|
| `rows` | `table[]?` | Raw rows (`id`, `citizenid`, `label`, `amount` signed, `category`, `counterparty`, `created_at` unix seconds), `{}` when none. `nil` on a malformed call (empty citizenid, non-finite limit) |

**Example**
```lua
local rows = exports['sd-phone']:getBankTransactions(citizenid, 10)
for _, row in ipairs(rows or {}) do
    print(row.label, row.amount)
end
```

The badge exports drive the home-screen unread counters.

## pushBadges

Recompute and push a player's home-screen badge counts. Call after mutating anything the counts derive from.

**Syntax**
```lua
exports['sd-phone']:pushBadges(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID. A non-number source is a silent no-op |

**Example**
```lua
-- After marking custom rows read outside the phone's own flows
exports['sd-phone']:pushBadges(source)
```

## getBadgeCounts

Read a player's current per-app unread counts without pushing them.

**Syntax**
```lua
local counts = exports['sd-phone']:getBadgeCounts(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `counts` | `table?` | `{ messages, phone, mail, groups, photogram }`, or `nil` when the source does not resolve to a loaded character, so "no player" is distinguishable from all-zero counts |

**Example**
```lua
local counts = exports['sd-phone']:getBadgeCounts(source)
if counts and counts.messages > 0 then
    -- they have unread texts
end
```

The photo exports save and host media for the Photos app.

## addPhoto

Save an already-hosted http(s) media URL into a player's gallery. The URL walks the same validation as the app's own save path; on success the photo is pushed live so an open Photos app updates.

**Syntax**
```lua
local result = exports['sd-phone']:addPhoto(source, url)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The acting player's server ID; the gallery owner resolves from it |
| `url` | `string` | An http(s) URL of the hosted media, capped at 512 bytes |

| Return | Type | Description |
|---|---|---|
| `result` | `table` | `{ success = boolean, photo = table? }` |

**Example**
```lua
exports['sd-phone']:addPhoto(source, 'https://cdn.example.com/photos/race-finish.jpg')
```

## uploadMedia

Asynchronously upload a base64 `data:` URL to the configured media host and hand the hosted CDN URL to a callback.

**Syntax**
```lua
local accepted = exports['sd-phone']:uploadMedia(dataUrl, filename, cb)
```

| Parameter | Type | Description |
|---|---|---|
| `dataUrl` | `string` | The media as a base64 data-URL (`data:image/...` or `data:video/...`) |
| `filename` | `string?` | Suggested filename stored alongside the upload |
| `cb` | `function` | `function(url, err)` called exactly once: `url` is the hosted URL on success, `err` a reason string on failure |

| Return | Type | Description |
|---|---|---|
| `accepted` | `boolean` | `false` when the callback or payload shape is unusable, before any quota is spent |

::: info
Every accepted call spends the server's Fivemanage quota, so the payload must be a `data:` URL and fit the per-kind byte cap before the upload starts. Upload only: nothing lands in a gallery; pair with [addPhoto](#addphoto) when it should.
:::

**Example**
```lua
exports['sd-phone']:uploadMedia(screenshotDataUrl, 'mugshot.jpg', function(url, err)
    if url then
        exports['sd-phone']:addPhoto(source, url)
    else
        print('Upload failed: ' .. tostring(err))
    end
end)
```

The account exports query the shared login engine behind the social apps. The account apps are `photogram`, `cherry`, `vibez`, `birdy`, `mail`, and `ryde`.

## accountExists

Check whether an account exists for an app. The username is trimmed and lowercased before the lookup, matching how accounts register.

**Syntax**
```lua
local exists = exports['sd-phone']:accountExists(app, username)
```

| Parameter | Type | Description |
|---|---|---|
| `app` | `string` | One of the account app keys |
| `username` | `string` | The account username |

| Return | Type | Description |
|---|---|---|
| `exists` | `boolean` | `true` when the account exists. Non-string or blank arguments return `false` |

**Example**
```lua
if exports['sd-phone']:accountExists('birdy', 'weazelnews') then
    -- the handle is taken
end
```

## getAppAccount

Get one account in its public shape. Never returns the password hash. Read-only.

**Syntax**
```lua
local account = exports['sd-phone']:getAppAccount(app, username)
```

| Parameter | Type | Description |
|---|---|---|
| `app` | `string` | One of the account app keys |
| `username` | `string` | The account username |

| Return | Type | Description |
|---|---|---|
| `account` | `table?` | `{ username, name, email, phone }`, or `nil` on an unknown app, malformed arguments, or no such account |

**Example**
```lua
local account = exports['sd-phone']:getAppAccount('photogram', 'lifeinvader')
```

## getSessionAccount

Get the account a citizen is currently signed into for an app. Read-only.

**Syntax**
```lua
local account = exports['sd-phone']:getSessionAccount(app, citizenid)
```

| Parameter | Type | Description |
|---|---|---|
| `app` | `string` | One of the account app keys |
| `citizenid` | `string` | The character's framework identifier |

| Return | Type | Description |
|---|---|---|
| `account` | `table?` | Same public shape as [getAppAccount](#getappaccount). `nil` means "not signed in", not an error |

**Example**
```lua
local account = exports['sd-phone']:getSessionAccount('ryde', citizenid)
if account then
    print('Signed into Ryde as ' .. account.username)
end
```

The group exports read the Groups app's membership state. The export view shape is `{ id, name, color, avatar, leaderCitizenid, members }` where each member is `{ citizenid, name, source? }` (`source` present only while that member is online).

::: info
These exports return real citizenids, so they are for trusted server callers only.
:::

## getActiveGroup

Get a player's active group as the full export view.

**Syntax**
```lua
local group = exports['sd-phone']:getActiveGroup(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `group` | `table?` | The export view, or `nil` when the player is not connected, has no active group, or the group has been disbanded |

**Example**
```lua
-- Gate a heist start on group size
local group = exports['sd-phone']:getActiveGroup(source)
if not group or #group.members < 2 then
    return notifyPlayer(source, 'You need a group of at least 2.')
end
```

## getActiveGroupId

Get just a player's active group ID. A cheap one-row read, useful as a precheck before pulling the full view.

**Syntax**
```lua
local groupId = exports['sd-phone']:getActiveGroupId(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `groupId` | `string?` | The active group's ID, or `nil` when no active group is set |

**Example**
```lua
local groupId = exports['sd-phone']:getActiveGroupId(source)
```

## getGroup

Get the export view of a specific group by ID.

**Syntax**
```lua
local group = exports['sd-phone']:getGroup(groupId)
```

| Parameter | Type | Description |
|---|---|---|
| `groupId` | `string` | The group's ID |

| Return | Type | Description |
|---|---|---|
| `group` | `table?` | The export view, or `nil` when the group does not exist |

**Example**
```lua
local group = exports['sd-phone']:getGroup(heist.groupId)
for _, member in ipairs(group and group.members or {}) do
    if member.source then
        -- the member is online
    end
end
```

The services exports integrate with the Services app's company directory.

## getCompanyDirectory

Get the configured company directory, the same rows the app's Companies tab lists. Pure config read; a fresh array each call, safe for the caller to mutate.

**Syntax**
```lua
local companies = exports['sd-phone']:getCompanyDirectory()
```

| Return | Type | Description |
|---|---|---|
| `companies` | `table[]` | `{ id, name, location, color, emoji, canCall, callNumber, coords }` per company, in config order |

**Example**
```lua
for _, company in ipairs(exports['sd-phone']:getCompanyDirectory()) do
    print(company.name, company.callNumber)
end
```

## messageCompany

Send a customer message to a configured company on a player's behalf. The payload walks the full validation (directory whitelist, kind whitelist, length caps); on-duty staff get the same banner and live inbox push as the app's own path.

**Syntax**
```lua
local result = exports['sd-phone']:messageCompany(source, payload)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The acting player's server ID; the sender's identity resolves from it |
| `payload` | `table` | `{ job, kind?, body, mediaUrl?, wpCode?, wpSub? }` |

| Return | Type | Description |
|---|---|---|
| `result` | `table` | `{ success = boolean, message = string? }` |

**Example**
```lua
exports['sd-phone']:messageCompany(source, {
    job  = 'mechanic',
    body = 'My car broke down on Route 68, can someone come take a look?',
})
```

The Weazel News exports publish to the news app as a trusted caller.

## postArticle

Publish an article from another resource. Only the staff boss-gate is skipped; every clamp still applies (category whitelist, required headline, length caps). Timestamps are server-stamped and a featured article demotes every other hero.

**Syntax**
```lua
local articleId, reason = exports['sd-phone']:postArticle(article)
```

| Parameter | Type | Description |
|---|---|---|
| `article` | `table` | Article draft (see below) |

| Field | Type | Description |
|---|---|---|
| `category` | `string` | Must be one of the configured categories |
| `headline` | `string` | Required |
| `dek` | `string?` | Subheadline |
| `body` | `string\|string[]` | A single string or a paragraph array |
| `image` | `string?` | Header image URL |
| `featured` | `boolean?` | `true` makes this the hero article |
| `author` | `string?` | Byline, defaults to `Weazel News` |

| Return | Type | Description |
|---|---|---|
| `articleId` | `integer?` | The new article's ID, or `nil` on a validation failure |
| `reason` | `string?` | Failure reason, only present when `articleId` is `nil` |

::: info
There is no live push: the article appears the next time a player opens the app.
:::

**Example**
```lua
-- Automated coverage when the vault is hit
local id, reason = exports['sd-phone']:postArticle({
    category = 'crime',
    headline = 'Pacific Standard hit in broad daylight',
    body     = { 'Masked suspects fled the scene minutes before police arrived.' },
    featured = true,
})
if not id then print('Article rejected: ' .. reason) end
```

## setBreakingTicker

Replace the breaking-news ticker. Lines are trimmed, non-strings and empties dropped, each line capped and at most the configured number of lines kept, in order.

**Syntax**
```lua
local replaced = exports['sd-phone']:setBreakingTicker(lines)
```

| Parameter | Type | Description |
|---|---|---|
| `lines` | `string[]` | Ticker lines in display order. An empty array clears the ticker |

| Return | Type | Description |
|---|---|---|
| `replaced` | `boolean` | `false` for a non-table argument, which leaves the ticker untouched |

**Example**
```lua
exports['sd-phone']:setBreakingTicker({
    'BREAKING: Pacific Standard bank robbed',
    'Police pursuit ongoing on the Del Perro Freeway',
})
```

The music export delivers tracks into a player's library.

## giveTrack

Give a track straight to a player's music library, skipping the AirShare nearby-consent handshake entirely: the caller vouches for the delivery (a quest reward, a purchased song). The track merges into the recipient's library even while the Music app is closed.

**Syntax**
```lua
local delivered = exports['sd-phone']:giveTrack(source, track)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The recipient's server ID, must be an online player |
| `track` | `table` | Track fields (see below). Extra fields ride along untouched |

| Field | Type | Description |
|---|---|---|
| `title` | `string` | Required, non-empty |
| `url` | `string` | Required, non-empty audio URL |
| `artist` | `string?` | Artist name |
| `artwork` | `string?` | Cover art URL |
| `duration` | `number?` | Track length in seconds |

| Return | Type | Description |
|---|---|---|
| `delivered` | `boolean` | `false` for an offline source or a malformed track |

**Example**
```lua
-- Reward a record-store quest with a song
exports['sd-phone']:giveTrack(source, {
    title  = 'Sleepwalking',
    artist = 'The Chain Gang of 1974',
    url    = 'https://cdn.example.com/music/sleepwalking.mp3',
})
```

The item exports tie the phone to its inventory items.

## hasPhone

Check whether a player owns any configured phone item, answered by the same authoritative inventory check the keybind gate uses.

**Syntax**
```lua
local color = exports['sd-phone']:hasPhone(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `color` | `string?` | The frame colour of the first owned variant in config order (`black`, `blue`, `green`, `orange`, `pink`, `purple`, `red`, `yellow` by default), or `nil` when no phone item is owned |

**Example**
```lua
if not exports['sd-phone']:hasPhone(source) then
    return notifyPlayer(source, 'You need a phone for this job.')
end
```

## usePhone

The usable-item export family behind the phone items. ox_inventory dispatches item use to a per-item export on the owning resource, and the export name is auto-derived from the item key (`use` plus the item name with its first letter uppercased). With the default items that registers `usePhone` for `phone`, plus `usePhone_blue`, `usePhone_green`, `usePhone_orange`, `usePhone_pink`, `usePhone_purple`, `usePhone_red`, and `usePhone_yellow` for the coloured variants. Only the `usingItem` phase acts, opening the phone in that variant's frame colour.

**Syntax**
```lua
exports['sd-phone']:usePhone(event, item, inv, slot, data)
```

| Parameter | Type | Description |
|---|---|---|
| `event` | `string` | ox_inventory dispatch phase; only `usingItem` acts |
| `item` | `table` | Item data from ox_inventory |
| `inv` | `table` | The holder's inventory; `inv.id` is the acting player |
| `slot` | `number` | The item's slot |
| `data` | `table` | Extra dispatch data |

::: info
These exports are registered only when ox_inventory is the active inventory, and they exist for ox_inventory's item-use dispatcher, not for manual calls. Other inventories register the phone items through their own `CreateUsableItem` style APIs and expose no export.
:::

The SIM exports manage the unique-phones SIM system: creating SIM card items, reading a player's active number, and assigning custom numbers. Numbers are bare digit strings; formatting in inputs is stripped.

## giveSimCard

Create a **pre-provisioned** SIM card and put it in a player's inventory. With `opts.citizenid` the SIM is character-bound and carries that character's existing number and data; with `opts.number` it carries a specific hardcoded number; with neither it is simply a pre-activated SIM with a fresh number.

:::: info You usually don't need this
Blank `sim_card` items **activate themselves on first use** — a fresh number is minted and registered on the spot — so shops, loot tables and admin spawns can hand out the raw item with zero integration. Reach for this export only when the SIM must carry a *specific* identity (character-bound, or a hardcoded number). Setting `ActivateBlankSims = false` in `configs/uniqueandsim.lua` disables self-activation for servers that want every SIM created through this export.
::::

**Syntax**
```lua
local number = exports['sd-phone']:giveSimCard(source, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The receiving player's server ID |
| `opts` | `table?` | `{ number?, citizenid? }`. `number` requests a specific number and fails if it is taken |

| Return | Type | Description |
|---|---|---|
| `number` | `string?` | The SIM's bare-digit number, or `nil` when creation or the inventory give failed |

**Example**
```lua
-- Onboarding: hand a new character a SIM bound to them (their number and data carry over)
local number = exports['sd-phone']:giveSimCard(source, { citizenid = cid })

-- A quest reward carrying a memorable hardcoded number (nil if the number is taken)
local number = exports['sd-phone']:giveSimCard(source, { number = '2085550777' })
if number then
    TriggerClientEvent('shop:notify', source, ('Your new number is %s'):format(number))
end
```

## getSimNumber

Get the SIM number installed in a player's active phone.

**Syntax**
```lua
local number = exports['sd-phone']:getSimNumber(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `number` | `string?` | Bare-digit SIM number, or `nil` without an active SIM |

## hasSim

Whether the player's active phone has a SIM installed.

**Syntax**
```lua
local installed = exports['sd-phone']:hasSim(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `installed` | `boolean` | `true` when a SIM is installed |

## isSimModeActive

Whether unique phones / SIM mode is live, meaning the config is on and the active inventory backend supports it.

**Syntax**
```lua
local active = exports['sd-phone']:isSimModeActive()
```

| Return | Type | Description |
|---|---|---|
| `active` | `boolean` | `true` while SIM mode is running |

## isNumberAvailable

Whether a phone number is free to assign: not on any SIM and not held by a legacy character assignment.

**Syntax**
```lua
local free = exports['sd-phone']:isNumberAvailable(number)
```

| Parameter | Type | Description |
|---|---|---|
| `number` | `string` | Phone number in any formatting |

| Return | Type | Description |
|---|---|---|
| `free` | `boolean` | `true` when the number can be assigned |

## setSimNumber

Assign a specific number to the SIM in a player's active phone, keeping its identity and data. This is the hook for server-owned "buy a custom number" implementations.

**Syntax**
```lua
local ok, err = exports['sd-phone']:setSimNumber(source, number)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `number` | `string` | Requested number; digits are kept, 3 to 15 of them |

| Return | Type | Description |
|---|---|---|
| `ok` | `boolean` | `true` on success |
| `err` | `string?` | On failure: `'invalid'` (bad input or SIM mode off), `'no_sim'`, or `'taken'` |

**Example**
```lua
-- A custom-number storefront
local free = exports['sd-phone']:isNumberAvailable(wanted)
if free and chargePlayer(source, price) then
    local ok, err = exports['sd-phone']:setSimNumber(source, wanted)
    if not ok then refundPlayer(source, price) end
end
```

## Documents

The Documents exports put files on players' phones from any resource — the paperwork layer of the city. Citations from an MDT, contracts from a dealership, licenses from city hall: one call creates the document, files it into a named folder (auto-created), updates the owner's open phone live, and shows a notification banner. Documents marked `locked` are read-only for the player — no editing, renaming, moving, deleting, or sharing — but the issuing resource can still revoke them.

Everything resolves through the phone's identity layer, so the same call works untouched on stock servers and under every [unique-phones mode](./unique-phones); documents ride cloud backups and admin wipes automatically.

## createDocument

Create a document on an online player's phone. Validates every field and applies the same caps as the app (`configs/documents.lua`).

**Syntax**
```lua
local docId, err = exports['sd-phone']:createDocument(source, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The receiving player's server ID |
| `opts` | `table` | See fields below; `name` is required |

| `opts` field | Type | Description |
|---|---|---|
| `name` | `string` | Display name (max length per config) |
| `kind` | `string?` | `'text'` (default), `'image'`, or `'file'` |
| `content` | `string?` | Body for `text` documents |
| `url` | `string?` | `http(s)` URL for `image`/`file` documents |
| `folder` | `string?` | Root folder **name** — resolved case-insensitively, created if absent |
| `locked` | `boolean?` | Read-only for the player; only your resource can remove it |
| `notify` | `boolean?` | Notification banner on delivery (default `true`) |

| Return | Type | Description |
|---|---|---|
| `docId` | `string?` | The new document's id, or `nil` on refusal |
| `err` | `string?` | Refusal message when `docId` is `nil` (caps hit, bad input, …) |

**Example**
```lua
-- An MDT files a citation the player can read but never delete
local docId = exports['sd-phone']:createDocument(source, {
    name    = ('Citation #%d'):format(citationId),
    folder  = 'LSPD',
    content = citationText,
    locked  = true,
})

-- Paying the fine revokes it
if paid and docId then
    exports['sd-phone']:deleteDocumentById(source, docId)
end
```

## createDocumentForNumber

The same as `createDocument`, addressed by phone number instead of server ID. The number is resolved to its owner; when they are online, delivery is pushed live.

**Syntax**
```lua
local docId, err = exports['sd-phone']:createDocumentForNumber(number, opts)
```

| Parameter | Type | Description |
|---|---|---|
| `number` | `string` | Phone number in any formatting |
| `opts` | `table` | Identical to `createDocument` |

| Return | Type | Description |
|---|---|---|
| `docId` | `string?` | The new document's id, or `nil` (`'Number not in service'`, …) |
| `err` | `string?` | Refusal message when `docId` is `nil` |

## getPlayerDocuments

Read a player's documents, optionally scoped to one root folder by name. Read-only; content is deliberately excluded — fetch it per document with `getDocumentContent`.

**Syntax**
```lua
local docs = exports['sd-phone']:getPlayerDocuments(source, folderName)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `folderName` | `string?` | Optional root folder name filter (case-insensitive) |

| Return | Type | Description |
|---|---|---|
| `docs` | `table[]` | Document rows `{ id, name, kind, folderId, size, locked, createdAt, updatedAt, url? }`; always an array, empty when nothing resolves |

## getDocumentContent

Read one document's raw text content.

**Syntax**
```lua
local content = exports['sd-phone']:getDocumentContent(source, docId)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `docId` | `string` | The document id |

| Return | Type | Description |
|---|---|---|
| `content` | `string?` | The document body, or `nil` when it doesn't exist or isn't theirs |

**Example**
```lua
-- A court script pulls the statement the player wrote in their Files app
local statement = exports['sd-phone']:getDocumentContent(source, docId)
if statement then fileEvidence(caseId, statement) end
```

## deleteDocumentById

Delete one of a player's documents. Deliberately bypasses the `locked` guard, so the resource that issued a read-only document can revoke it.

**Syntax**
```lua
local removed = exports['sd-phone']:deleteDocumentById(source, docId)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |
| `docId` | `string` | The document id |

| Return | Type | Description |
|---|---|---|
| `removed` | `boolean` | `true` when a document was removed |

::: info
Every export-created document fires the [`sd-phone:server:documents:created`](./events-server) event, carrying the creating resource's name.
:::

::: tip
Client-side exports for opening the phone, launching apps, and showing local notifications are documented on the [Client Exports](./exports-client) page.
:::
