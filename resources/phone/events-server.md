---
title: Server Events
description: Server-side events the phone fires on message, mail, call, banking, photo, social, and contact activity, for other resources to listen to.
---

# Server Events

The phone announces its lifecycle moments as plain server-local events. Listen with a standard handler:

```lua
AddEventHandler('sd-phone:server:messages:sent', function(message)
    -- react to the send
end)
```

All events fire via `TriggerEvent`, which is synchronous: handlers run inline inside the phone's own action, so keep them cheap and never let them error. Payloads carry citizenids where noted; they are for trusted server resources and must not be forwarded to clients unfiltered.

## Phone Numbers

### sd-phone:server:number:assigned

Fires exactly once per character, when their phone number is first minted.

```lua
AddEventHandler('sd-phone:server:number:assigned', function(citizenid, number)
    print(citizenid .. ' was assigned ' .. number)
end)
```

| Parameter | Type | Description |
|---|---|---|
| `citizenid` | `string` | The character the number was minted for |
| `number` | `string` | The raw-digit number |

::: info
No source argument: minting can happen with the owner offline (the `getPhoneNumberByIdentifier` export with `ensure = true`). Resolve a server id yourself when you need one, and expect `nil`.
:::

---

## Messages

### sd-phone:server:messages:sent

Fires once per logical SMS send, on all three delivery paths: a player's 1:1 send, a player's group send, and a system text.

```lua
AddEventHandler('sd-phone:server:messages:sent', function(m)
    if not m.system and not m.group then
        print(m.senderNumber .. ' texted ' .. m.targetNumber)
    end
end)
```

| Parameter | Type | Description |
|---|---|---|
| `system` | `boolean` | `true` for `sendSystemMessage`-style service texts |
| `group` | `boolean` | `true` for group-thread sends |
| `source` | `number\|nil` | Sending player's server id (absent on system texts) |
| `citizenid` | `string\|nil` | Sending character (absent on system texts) |
| `senderNumber` | `string` | Sending number |
| `senderName` | `string\|nil` | Display name (system texts only) |
| `targetNumber` | `string\|nil` | Recipient number (1:1 and system) |
| `targetCitizenid` | `string\|nil` | Recipient character, `nil` when the number is not in service |
| `targetSource` | `number\|nil` | Recipient's server id when online and delivered live |
| `groupId` | `number\|nil` | Group thread id (group sends) |
| `members` | `table\|nil` | Group roster of `{ citizenid, number, name }` (group sends); treat as read-only |
| `kind` | `string` | Message kind (`text`, `image`, `gif`, `location`, ...) |
| `body` | `string` | Message text |
| `meta` | `table\|nil` | Sanitized kind metadata |
| `mid` | `string` | Shared logical id correlating the per-mailbox copies |
| `messageId` | `number` | Stored row id (sender copy for player sends, recipient copy for system texts) |
| `recipientId` | `number\|nil` | Recipient copy row id, `nil` when no copy was stored |
| `withheld` | `boolean\|nil` | `true` when airplane mode is holding the delivery |
| `timestamp` | `number` | Unix seconds |

::: info
On a 1:1 send, `targetCitizenid` can be set while `recipientId` and `targetSource` are `nil`: the number is in service but the sender is blocked, and the block is deliberately indistinguishable from offline.
:::

---

## Mail

### sd-phone:server:mail:sent

Fires once per mail send, both player composes and system mail.

```lua
AddEventHandler('sd-phone:server:mail:sent', function(mail)
    print(('%s mailed %d recipient(s): %s'):format(mail.from.email, #mail.to, mail.subject))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `system` | `boolean` | `true` for `sendMail`-style system senders |
| `id` | `string\|nil` | Stored message id (absent on a system send that reached nobody) |
| `citizenid` | `string\|nil` | Sending character (player composes only) |
| `from` | `table` | `{ name, email }` |
| `to` | `string[]` | Normalized recipient addresses |
| `subject` | `string` | Subject line |
| `body` | `string` | Body text |
| `sentAt` | `number` | Unix seconds |
| `delivered` | `number\|nil` | Recipient accounts that existed (system sends only) |

---

## Calls

All call events share one call table:

| Field | Type | Description |
|---|---|---|
| `channel` | `number` | The pma-voice call channel, doubling as the call id |
| `company` | `string\|nil` | Display name for company/group rings, `nil` for 1:1 calls |
| `caller` | `table` | `{ source, citizenid, name, number }` |
| `callee` | `table\|nil` | Same shape; `nil` on group rings before an answer |
| `targets` | `table\|nil` | Group rings only: everyone rung, same party shape |

### sd-phone:server:call:started

Fires when a 1:1 call starts ringing, and once per company/group ring (with `targets` populated and `callee` nil).

```lua
AddEventHandler('sd-phone:server:call:started', function(call)
    print(call.caller.number .. ' is calling ' .. (call.callee and call.callee.number or call.company))
end)
```

### sd-phone:server:call:answered

Fires when a call is answered, including a group ring being promoted to a live call (the answering employee becomes `callee`; `company` keeps the display name). The payload adds `startedAt` (unix seconds at answer).

### sd-phone:server:call:ended

Fires on every teardown, answered or not, with `endedBy` as a second argument.

```lua
AddEventHandler('sd-phone:server:call:ended', function(call, endedBy)
    if call.answered then
        print(('call on channel %d lasted %ds'):format(call.channel, call.duration))
    end
end)
```

Extra payload fields on this event:

| Field | Type | Description |
|---|---|---|
| `answered` | `boolean` | Whether the call was ever active |
| `duration` | `number` | Seconds, `0` when never answered |
| `reason` | `string` | `'declined'`, `'hangup'`, `'disconnected'`, or `'unavailable'` |

| Parameter | Type | Description |
|---|---|---|
| `call` | `table` | The call table above |
| `endedBy` | `number\|nil` | Server id that caused the teardown, `nil` on disconnects |

::: info
Cancelled group rings that nobody answered also fire this event (`answered = false`, `callee = nil`), so a dispatch script can observe missed company calls. Payloads are built from stored session state, so a disconnecting player still appears with the data they rang with.
:::

---

## Services

### sd-phone:server:services:message

Fires when a citizen messages a company through the Services app (or the `messageCompany` export).

```lua
AddEventHandler('sd-phone:server:services:message', function(e)
    if e.job == 'police' then
        print(('911 text from %s (%s): %s'):format(e.name, e.number, e.body))
    end
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Sending player's server id |
| `citizenid` | `string` | Sending character |
| `job` | `string` | Company job name |
| `label` | `string` | Company display label |
| `number` | `string` | Sender's phone number |
| `name` | `string` | Sender's display name |
| `kind` | `string` | Composer kind |
| `body` | `string` | Message text |
| `meta` | `table\|nil` | Kind metadata |

---

## Banking

### sd-phone:server:banking:transaction

Fires when an externally-logged Wallet row is appended (the `addBankTransaction` export or the internal event that backs it).

| Parameter | Type | Description |
|---|---|---|
| `citizenid` | `string` | Row owner |
| `source` | `number\|nil` | Owner's server id when online |
| `amount` | `number` | Signed amount, positive = money in |
| `label` | `string` | Row label |
| `category` | `string\|nil` | Category tag |
| `counterparty` | `string\|nil` | Who the money moved to or from |
| `timestamp` | `number` | Unix seconds |

### sd-phone:server:banking:transfer

Fires once per player-to-player Wallet transfer made in the phone.

| Parameter | Type | Description |
|---|---|---|
| `fromCitizenid` | `string` | Sender |
| `fromNumber` | `string` | Sender's number |
| `fromSource` | `number` | Sender's server id |
| `toCitizenid` | `string` | Recipient |
| `toNumber` | `string` | Recipient's number |
| `toSource` | `number\|nil` | Recipient's server id when online |
| `amount` | `number` | Amount moved |
| `note` | `string\|nil` | Transfer note |
| `timestamp` | `number` | Unix seconds |

---

## Photos

### sd-phone:server:photos:added

Fires when a photo lands in a gallery, on every add path: camera captures, saved URLs, and the `addPhoto` export.

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Owner's server id |
| `citizenid` | `string` | Owner |
| `id` | `number` | Gallery row id |
| `url` | `string` | Hosted media URL |

### sd-phone:server:photos:deleted

Fires when a player deletes media from their own gallery. Retention pruning and admin wipes bypass it deliberately.

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Owner's server id |
| `citizenid` | `string` | Owner |
| `id` | `number` | Deleted row id |
| `url` | `string` | The deleted media URL |

---

## Social

### sd-phone:server:birdy:post

Fires when a new Birdy post is created.

| Parameter | Type | Description |
|---|---|---|
| `id` | `number` | Post id |
| `source` | `number` | Author's server id |
| `citizenid` | `string` | Author |
| `username` | `string` | Author's handle |
| `displayName` | `string` | Author's display name |
| `body` | `string` | Post text |
| `images` | `string[]\|nil` | Attached image URLs, `nil` for text-only posts |

### sd-phone:server:photogram:post

Fires when a new Photogram post is created.

| Parameter | Type | Description |
|---|---|---|
| `id` | `number` | Post id |
| `source` | `number` | Author's server id |
| `citizenid` | `string` | Author |
| `username` | `string` | Author's handle |
| `images` | `string[]` | Post media URLs |
| `caption` | `string` | Caption (may be empty) |
| `location` | `string\|nil` | Location tag |
| `private` | `boolean` | Whether the author's account is private |

::: info
Private authors' posts are scoped to approved followers inside the app. This payload is server-local and trusted; never forward it to clients unfiltered.
:::

---

## Classifieds

### sd-phone:server:pages:post

Fires when a new Pages listing is posted. Payload fields come from the stored row: `{ id, source, citizenid, number, title, body, price, image, images }` (`images` is the stored JSON string).

### sd-phone:server:marketplace:post

Fires when a new Marketplace listing is posted. Same shape as the Pages event.

---

## Contacts

### sd-phone:server:contacts:added

Fires when a contact lands in a player's phone book, from the app, the `addContact` export, or an accepted AirShare.

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Owner's server id |
| `citizenid` | `string` | Owner |
| `id` | `number` | Contact row id |
| `name` | `string` | Contact name |
| `phone` | `string` | Contact number, digit-normalized |
| `shared` | `boolean` | `true` when it arrived via AirShare |

### sd-phone:server:contacts:removed

Fires when contacts are removed, from the app delete or the `removeContactByNumber` export.

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Owner's server id |
| `citizenid` | `string` | Owner |
| `id` | `number\|nil` | Row id (app deletes) |
| `phone` | `string` | Removed number, digit-normalized |
| `removed` | `number` | Rows removed |

---

## Settings

### sd-phone:server:airplane:released

Fires when a player switches airplane mode off, releasing withheld messages.

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server id |

### sd-phone:server:documents:created

Fires once per document created through the [Documents exports](./exports-server#documents) — player-created documents do not fire it.

```lua
AddEventHandler('sd-phone:server:documents:created', function(data)
    print(('%s issued "%s" (%s) as %s'):format(data.resource or '?', data.name, data.kind, data.docId))
end)
```

| Field | Type | Description |
|---|---|---|
| `citizenid` | `string` | The owning identity (the acting phone profile under unique phones) |
| `docId` | `string` | The new document's id |
| `name` | `string` | Document display name |
| `kind` | `string` | `'text'`, `'image'`, or `'file'` |
| `resource` | `string?` | The resource that invoked the export |

---

::: tip
Client-local events (phone opened, camera mode, flashlight) live on the [Client Events](./events-client) page. Third-party scripts written against lb-phone's events keep working through the [lb-phone compatibility layer](./lb-phone-compatibility).
:::
