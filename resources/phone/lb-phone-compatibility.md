---
title: lb-phone Compatibility
description: Drop-in compatibility with lb-phone exports, events, and dependencies, so third-party integrations keep working without edits.
---

# lb-phone Compatibility

The phone ships a compatibility layer so third-party scripts written against lb-phone keep working after a server switches phones, without editing them. Three surfaces are covered: exports, events, and the resource name itself.

## How it works

FiveM's `exports()` helper is sugar over an event: registering export `X` binds a handler on `__cfx_export_<resource>_X`, and a caller's `exports['<resource>']:X(...)` resolves through that event. The compatibility layer registers handlers on `__cfx_export_lb-phone_<Name>` events directly, so other resources calling `exports['lb-phone']:SendMessage(...)` land on the phone's own modules and walk the same validation as the first-party exports.

- Server half: `server/compat/lbphone/` (a domain file per surface plus the event mirror).
- Client half: `client/compat/lbphone.lua`.
- Supported names map onto the equivalent behaviour. Unsupported names are registered as stubs: the first call prints one console breadcrumb naming the calling resource, then every call returns a fixed type-safe default, so no caller ever hits a hard "No such export" error.

The manifest also declares `provide 'lb-phone'`, which satisfies other resources' hard `dependency 'lb-phone'` lines and `GetResourceState('lb-phone')` checks.

## Enabling and disabling

The layer is on by default and guards itself:

```cfg
set sd_phone_lbcompat "false"   # disables the whole layer
```

If a real resource named `lb-phone` exists and is started, the layer does not register and a warning explains why; if the real lb-phone starts mid-session after registration, the layer deregisters its handlers and warns. `provide 'lb-phone'` must be commented out of the manifest if a real, runnable lb-phone is kept on the server.

::: info Restart caveat
FXServer caches a consumer's resolved export functions under the addressed name and clears them only when a resource with that exact name stops. Restarting the phone therefore strands consumers that already called an `exports['lb-phone']:...` export until those consumers restart too. Practical rule: after restarting the phone on a live server, restart the resources that integrate through lb-phone names.
:::

## Event mirror

Third-party scripts listening for lb-phone events keep working: the layer re-fires the phone's first-party events under lb-phone's names with translated payloads. Nothing fires when the layer is disabled or stood down.

### Server events

| lb event | Fired when | Fidelity notes |
|---|---|---|
| `lb-phone:phoneNumberGenerated` | A character's number is first minted | Skipped when the owner is offline (lb fires it for online players) |
| `lb-phone:messages:messageSent` | A 1:1 or system SMS is sent | `channelId` is a synthetic `0`; `attachments` is a JSON-encoded string per lb's contract; group sends have no lb analog |
| `lb-phone:mail:mailSent` | A mail is sent | Fired once per recipient, matching lb's single-recipient shape |
| `lb-phone:newCall` | A call starts ringing | `callId` is the voice channel; `videoCall`/`hideCallerId` always `false` |
| `lb-phone:callAnswered` | A call is answered | Same CallData shape, `answered = true` |
| `lb-phone:callEnded` | A call ends | Second argument is the ending player's source, `nil` on disconnects |
| `lb-phone:newCompanyMessage` | A citizen messages a company | `sentByEmployee` always `false`, `coords` omitted, `anonymous` always `false` |
| `lb-phone:onAddTransaction` | An external Wallet row is logged | Signed amount with `'received'`/`'paid'` derived from the sign, matching lb's source; skipped for citizens without a number |
| `lb-phone:deletedFromGallery` | A player deletes gallery media | Positional `(source, phoneNumber, link)` |
| `lb-phone:birdy:newPost` | A Birdy post is created | `attachments` JSON-encoded; `verified` always `false` |
| `lb-phone:instapic:newPost` | A Photogram post is created | Photogram stands in for InstaPic |
| `lb-phone:pages:newPost` | A Pages listing is posted | `description` maps from the listing body |
| `lb-phone:marketplace:newPost` | A Marketplace listing is posted | Same mapping as Pages |

Not mirrored, with reasons: `lb-phone:numberChanged` (numbers never change after minting), `lb-phone:factoryReset`, `lb-phone:toggleVerified` (no verified system), `lb-phone:trendy:newPost` (no server-backed Trendy analog), `lb-phone:darkchat:newMessage` (no external DarkChat surface).

### Client events

| lb event | Fired when | Fidelity notes |
|---|---|---|
| `lb-phone:phoneToggled` | The phone opens or closes | |
| `lb-phone:setOnScreen` | Alongside `phoneToggled` | The phone has a single open state, the closest equivalent |
| `lb-phone:toggleHud` | Camera mode enters (`true`) or exits (`false`) | |
| `lb-phone:jobUpdated` | The framework reports a job change | `{ job, grade }`, matching lb's qb/esx bridges |

Not mirrored: `lb-phone:settingsUpdated`, `lb-phone:phoneDied` (no battery system), `lb-phone:numberChanged`.

### Inbound events

Events other scripts fire AT lb-phone are handled too:

| lb event | Behaviour |
|---|---|
| `lb-phone:usePhoneItem` | Opens the phone through the normal guarded path. The per-number `lbPhoneNumber` metadata is ignored: there are no per-number unique phones, every character has exactly one number |
| `lb-phone:itemAdded` / `lb-phone:itemRemoved` | Acknowledged no-ops: phone ownership is resolved server-side on every open, nothing needs equipping |

## Export coverage

Every export lb-phone documents is registered, as a full mapping, a partial one, or a warn-once stub with a type-safe default. The heavily-used surfaces are full or partial: `GetEquippedPhoneNumber`, `GetSourceFromNumber`, `SendMessage`, `SendMail`, `GetEmailAddress`, `SendNotification`, `NotifyEveryone`, `AddContact`, `AddTransaction`, `CreateCall`/`EndCall`/`IsInCall`, `HasPhoneItem`, `HasAirplaneMode`, `ResetSecurity`, and on the client `IsOpen`, `ToggleOpen`, `OpenApp`, `SendNotification`, `GetEquippedPhoneNumber`, `GetFlashlight`, `ToggleDisabled`.

Stubbed families (safe defaults, one console breadcrumb naming the caller): crypto, DarkChat, custom apps and trays, battery, camera components, the check hooks, and lb-phone's callback wire (`RegisterCallback` and friends).

The complete per-export table with per-name notes ships with the resource in `docs/exports.md`.

::: tip
lb-phone's per-player data (numbers, contacts, messages, photos, notes) can also be imported at boot by the built-in migrator: run `sdphone:migrate dry` from the server console for a non-destructive preview, then `sdphone:migrate` to import. The import is idempotent and marker-guarded, so it runs once.
:::
