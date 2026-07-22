---
title: Installation
description: Dependencies, database, phone items, and convars for setting up the phone.
---

# Installation

## Download

There are two ways to get the phone. Pick **one**. If you are not sure, use the Release.

### Recommended: the Release (already built, ready to drop in)

This is what almost everyone should use. It is the phone fully built, with nothing left to compile. Just download, unzip, and drop it in.

1. Go to the [Releases page](https://github.com/Samuels-Development/sd-phone/releases).
2. Open the latest release, expand **Assets**, and download the file named `sd-phone-<version>.zip` (for example `sd-phone-v1.0.0.zip`).
3. Unzip it. You get a folder called `sd-phone`. Drop that folder into your server's `resources`.
4. Skip the rest of this section and continue with [Dependencies](#dependencies) below.

::: danger Download the `sd-phone-...zip`, NOT "Source code (zip)"
Every release also shows a **Source code (zip)** / **Source code (tar.gz)** link. That one is **not built** and the phone will open to a blank black screen if you use it. Only download the asset named `sd-phone-<version>.zip`. If you genuinely want to edit the code, read the next part.
:::

### Building from source (only if you want to edit the code)

The **Source code** download and `git clone` give you the raw project. They do **not** include the built phone screen (the `web/build` folder), so if you drop them in as-is the phone opens to a blank screen. You have to build it once yourself. It is easy, just follow these steps exactly.

**First, install Node.js.** Download it from [nodejs.org](https://nodejs.org) and install the **LTS** version (the big green button). This gives you the `npm` command used below. After installing, close and reopen any terminal you had open.

**Then build the phone:**

1. Get the source: either download the ZIP from the [repo](https://github.com/Samuels-Development/sd-phone) (green **Code** button > **Download ZIP**) and unzip it, or run `git clone https://github.com/Samuels-Development/sd-phone.git`.
2. If you downloaded the ZIP, the folder is named `sd-phone-main`. **Rename it to `sd-phone`**, or the resource will not start in-game.
3. Open a terminal **inside the `web` folder** of the resource. On Windows, any of these works, pick whatever is easiest:
   - **Copy the path and `cd` to it (easiest):** find the `web` folder inside `sd-phone`, right-click it and choose **Copy as path** (this copies the path with quotes already added). Open **Command Prompt** or **PowerShell**, type `cd ` (with a space after it), paste the path, and press Enter. Example: `cd "C:\FiveM\resources\sd-phone\web"`.
   - Or open the `web` folder in File Explorer, click the address bar, type `cmd`, and press Enter.
   - Or right-click inside the `web` folder and choose **Open in Terminal**.

   You are in the right place when the terminal line ends with `...\sd-phone\web>`.
4. Run these two commands, one at a time, waiting for each to finish:

```sh
npm install
npm run build
```

5. When the second command prints something like `built in 6.07s`, you are done. A new `web/build` folder has appeared. That is the compiled phone.
6. Drop the whole `sd-phone` folder into your server's `resources` and continue with [Dependencies](#dependencies).

::: tip Edited the code later? Rebuild.
Every time you change the phone's files, run `npm run build` again inside the `web` folder. The server loads the compiled `web/build` folder, not your raw source edits, so nothing changes in-game until you rebuild.
:::

::: warning Phone screen is blank or black?
This almost always means the `web/build` folder is missing, because the build was skipped or the "Source code" zip was used. Build it with the steps above, or just download the Release zip instead.
:::

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

3. Copy the item icons from sd-phone's `images/` folder into `ox_inventory/web/images/`. The files are named after the items (`phone_black.png`, `phone_blue.png`, ...), so ox_inventory picks them up automatically with no `image` field needed.

4. Add the phone items to `ox_inventory/data/items.lua`. Each item maps to a frame colour and matching in-hand prop, and `consume = 0` keeps the item on use:

```lua
['phone_black'] = {
    label = 'Phone',
    weight = 190,
    stack = false,
    consume = 0,
    server = { export = 'sd-phone.usePhone_black' }
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
The black phone's item name is `phone_black` and its icon is `phone_black.png`. The item-to-colour mapping lives in `configs/phone.lua` if you want different item names. Players can also press the open keybind (default F1), which is server-gated on actually owning a phone item. Other inventories register through their own usable-item APIs automatically; only the icons need copying into your inventory's image folder.
:::

### SIM card item (optional)

Only needed if you turn on [unique phones](/resources/phone/unique-phones) in `configs/uniqueandsim.lua` (off by default), where phone numbers live on SIM items instead of characters. Not needed in the `BuiltInNumbers` variant, where phones mint their own numbers. Copy `sim_card.png` from sd-phone's `images/` folder into `ox_inventory/web/images/` like the phone icons, then add the item:

```lua
['sim_card'] = {
    label = 'SIM Card',
    weight = 5,
    stack = false,
    close = true,
    consume = 0, -- required: sd-phone consumes the item itself on install
    server = { export = 'sd-phone.useSim_card' }
},
```

That's the whole integration. Sell or spawn `sim_card` anywhere you like — an ox_inventory shop, a loot table, an admin give — and a blank card **activates itself on first use**, minting a fresh registered number on the spot. The `giveSimCard` export exists only for special cases (character-bound SIMs or hardcoded numbers), and `ActivateBlankSims = false` in `configs/uniqueandsim.lua` disables self-activation if you want every SIM to come through it.

## API keys

Third-party keys live in `configs/server/apikeys.lua`, which is deliberately excluded from the client download:

| Key | Purpose |
|---|---|
| `Giphy` | The Messages GIF picker. Free key from developers.giphy.com; left blank the picker shows a setup hint |
| `FivemanageMedia` | **Required** for the Camera, Photos and Voice Memos apps. Photo, video, and voice-note uploads go through fivemanage.com. Use a Fivemanage token of type **Media**. Left blank, the uploader falls back to the legacy `sd_fivemanage_key` convar; with neither set, capture UI still opens but nothing uploads or saves |

::: warning The media apps need a Fivemanage key
Camera photos and videos, Photos uploads, and Voice Memos all store their files on Fivemanage. Without a `FivemanageMedia` token, those apps open but captures never upload or save. Create a free token in the [Fivemanage](https://refer.fivemanage.com/samuel) dashboard: open the **Tokens** tab, click Create Token, and pick token type **Media**. The rest of the phone works fine without it.
:::

<div align="center" style="margin: 2.5rem 0; padding: 2rem 1rem; border: 1px solid var(--vp-c-divider); border-radius: 14px;">

<a href="https://refer.fivemanage.com/samuel" target="_blank" rel="noreferrer"><img src="/fivemanage-banner.png" alt="Fivemanage" width="360" style="border-radius: 10px;" /></a>

<h3 style="border: 0; margin: 0.75rem 0 0.5rem;">Media hosting for the phone</h3>

Photos, camera clips and voice memos upload to **[Fivemanage](https://refer.fivemanage.com/samuel)** and come back as fast CDN URLs, so you never run your own media server. Required for those apps: in the dashboard, open the **Tokens** tab, create a token of type **Media**, and drop it into `FivemanageMedia`.

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
