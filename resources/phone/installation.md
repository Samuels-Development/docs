---
title: Installation
description: Dependencies, database, phone items, and convars for setting up the phone.
---

# Installation

## Dependencies

Hard requirements, both must start before the phone:

| Resource | Purpose |
|---|---|
| [ox_lib](https://github.com/CommunityOx/ox_lib) | require loader, callbacks, notifications |
| [oxmysql](https://github.com/CommunityOx/oxmysql) | database access |
| [sd-phone-props](https://github.com/Samuels-Development/sd-phone-props) | streams the in-hand phone models, one per frame colour |

The phone auto-detects the running framework (qb-core, qbx_core, ESX) and whichever inventory, banking, housing, garage, and voice resources are installed; there is nothing to configure for the common setups. Calls and the Radio app carry audio over pma-voice.

## Setup

1. Place `sd-phone` and [`sd-phone-props`](https://github.com/Samuels-Development/sd-phone-props) in your resources folder and ensure them after the dependencies:

```cfg
ensure ox_lib
ensure oxmysql
ensure sd-phone-props
ensure sd-phone
```

2. Database tables create themselves on first boot; there is no SQL file to import.

3. Copy the item icons from sd-phone's `images/` folder into `ox_inventory/web/images/`. The files are named after the items (`phone.png`, `phone_blue.png`, ...), so ox_inventory picks them up automatically with no `image` field needed.

4. Add the phone items to `ox_inventory/data/items.lua`. Each item maps to a frame colour and matching in-hand prop, and `consume = 0` keeps the item on use:

```lua
['phone'] = {
    label = 'Phone',
    weight = 190,
    stack = false,
    consume = 0,
    server = { export = 'sd-phone.usePhone' }
},

['phone_blue'] = {
    label = 'Blue Phone',
    weight = 190,
    stack = false,
    consume = 0,
    server = { export = 'sd-phone.usePhone_blue' }
},

['phone_green'] = {
    label = 'Green Phone',
    weight = 190,
    stack = false,
    consume = 0,
    server = { export = 'sd-phone.usePhone_green' }
},

['phone_orange'] = {
    label = 'Orange Phone',
    weight = 190,
    stack = false,
    consume = 0,
    server = { export = 'sd-phone.usePhone_orange' }
},

['phone_pink'] = {
    label = 'Pink Phone',
    weight = 190,
    stack = false,
    consume = 0,
    server = { export = 'sd-phone.usePhone_pink' }
},

['phone_purple'] = {
    label = 'Purple Phone',
    weight = 190,
    stack = false,
    consume = 0,
    server = { export = 'sd-phone.usePhone_purple' }
},

['phone_red'] = {
    label = 'Red Phone',
    weight = 190,
    stack = false,
    consume = 0,
    server = { export = 'sd-phone.usePhone_red' }
},

['phone_yellow'] = {
    label = 'Yellow Phone',
    weight = 190,
    stack = false,
    consume = 0,
    server = { export = 'sd-phone.usePhone_yellow' }
},
```

::: info
The black phone's item name is `phone`, not `phone_black`, and its icon is `phone.png`. The item-to-colour mapping lives in `configs/phone.lua` if you want different item names. Players can also press the open keybind (default F1), which is server-gated on actually owning a phone item. Other inventories register through their own usable-item APIs automatically; only the icons need copying into your inventory's image folder.
:::

## API keys

Third-party keys live in `configs/server/apikeys.lua`, which is deliberately excluded from the client download:

| Key | Purpose |
|---|---|
| `Giphy` | The Messages GIF picker. Free key from developers.giphy.com; left blank the picker shows a setup hint |
| `FivemanageMedia` | Photo, video, and voice-note uploads via fivemanage.com. Left blank, the uploader falls back to the legacy `sd_fivemanage_key` convar |

<div align="center" style="margin: 2.5rem 0; padding: 2rem 1rem; border: 1px solid var(--vp-c-divider); border-radius: 14px;">

<a href="https://refer.fivemanage.com/samuel" target="_blank" rel="noreferrer"><img src="/fivemanage-banner.png" alt="Fivemanage" width="360" style="border-radius: 10px;" /></a>

<h3 style="border: 0; margin: 0.75rem 0 0.5rem;">Media hosting for the phone</h3>

Photos, camera clips and voice memos upload to **[Fivemanage](https://refer.fivemanage.com/samuel)** and come back as fast CDN URLs, so you never run your own media server. Create a project, grab the token, and drop it into `FivemanageMedia`.

<a href="https://refer.fivemanage.com/samuel" target="_blank" rel="noreferrer"><img src="https://img.shields.io/badge/Get%20started%20with%20Fivemanage-%E2%86%92-0D0D0D?style=for-the-badge" alt="Get started with Fivemanage" /></a>

</div>

## Convars

| Convar | Default | Purpose |
|---|---|---|
| `sd_fivemanage_key` | empty | Legacy location for the Fivemanage media token; prefer `configs/server/apikeys.lua` |
| `sd_phone_lbcompat` | `true` | The [lb-phone compatibility layer](./lb-phone-compatibility); set `false` to disable |
| `sd_phone_turn_url` / `sd_phone_turn_username` / `sd_phone_turn_credential` | empty | Static TURN server for nearby-voice capture in camera videos and Photogram Live |
| `sd_cf_turn_token_id` / `sd_cf_turn_api_token` | empty | Alternatively, Cloudflare Calls TURN credentials (auto-minted short-lived keys) |

The TURN convars are optional: without them, video voice capture still records the player's own microphone, and nearby-player voices are captured whenever a direct connection succeeds.

## Migrating from lb-phone

If the server previously ran lb-phone, the built-in importer carries player data over (numbers, passcodes, contacts, call history, blocked numbers, SMS including groups, photos, notes):

```
sdphone:migrate dry   # preview, writes nothing
sdphone:migrate       # import, idempotent and marker-guarded
```

Third-party lb-phone integrations keep working through the [compatibility layer](./lb-phone-compatibility) without edits.
