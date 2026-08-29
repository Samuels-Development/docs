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

The phone auto-detects the running framework (qb-core, qbx_core, ESX, ox_core, ND) and whichever inventory, banking, housing, garage, and voice resources are installed; there is nothing to configure for the common setups, ND included. Only ox_core needs a step: map your group types to jobs and gangs in `configs/framework.lua`. Calls and the Radio app carry audio over pma-voice.

## <span class="step-num">1</span> Add the Resource

Place `sd-phone` and [`sd-phone-props`](https://github.com/Samuels-Development/sd-phone-props) in your resources folder and ensure them after the dependencies:

```cfg
ensure ox_lib
ensure oxmysql
ensure sd-phone-props
ensure sd-phone
```

::: tip No SQL to import
Database tables create themselves on first boot. The only SQL on this page is the ESX item list below, and that is for your inventory, not the phone.
:::

## <span class="step-num">2</span> Add Items

Register **8 items**, one per frame colour. Each item maps to a frame colour and its matching in-hand prop.

::: code-group

```lua [ox_inventory]
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

```lua [qb-core / qbx_core]
['phone_black']  = { name = 'phone_black',  label = 'Phone',        weight = 190, type = 'item', image = 'phone_black.png',  unique = true, useable = true, shouldClose = true, description = 'A smartphone.' },
['phone_blue']   = { name = 'phone_blue',   label = 'Blue Phone',   weight = 190, type = 'item', image = 'phone_blue.png',   unique = true, useable = true, shouldClose = true, description = 'A smartphone.' },
['phone_green']  = { name = 'phone_green',  label = 'Green Phone',  weight = 190, type = 'item', image = 'phone_green.png',  unique = true, useable = true, shouldClose = true, description = 'A smartphone.' },
['phone_orange'] = { name = 'phone_orange', label = 'Orange Phone', weight = 190, type = 'item', image = 'phone_orange.png', unique = true, useable = true, shouldClose = true, description = 'A smartphone.' },
['phone_pink']   = { name = 'phone_pink',   label = 'Pink Phone',   weight = 190, type = 'item', image = 'phone_pink.png',   unique = true, useable = true, shouldClose = true, description = 'A smartphone.' },
['phone_purple'] = { name = 'phone_purple', label = 'Purple Phone', weight = 190, type = 'item', image = 'phone_purple.png', unique = true, useable = true, shouldClose = true, description = 'A smartphone.' },
['phone_red']    = { name = 'phone_red',    label = 'Red Phone',    weight = 190, type = 'item', image = 'phone_red.png',    unique = true, useable = true, shouldClose = true, description = 'A smartphone.' },
['phone_yellow'] = { name = 'phone_yellow', label = 'Yellow Phone', weight = 190, type = 'item', image = 'phone_yellow.png', unique = true, useable = true, shouldClose = true, description = 'A smartphone.' },
```

```sql [ESX]
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
  ('phone_black',  'Phone',        190, 0, 1),
  ('phone_blue',   'Blue Phone',   190, 0, 1),
  ('phone_green',  'Green Phone',  190, 0, 1),
  ('phone_orange', 'Orange Phone', 190, 0, 1),
  ('phone_pink',   'Pink Phone',   190, 0, 1),
  ('phone_purple', 'Purple Phone', 190, 0, 1),
  ('phone_red',    'Red Phone',    190, 0, 1),
  ('phone_yellow', 'Yellow Phone', 190, 0, 1);
```

:::

## <span class="step-num">3</span> Add Item Images

Copy the item icons from sd-phone's `images/` folder into your inventory's image folder (`ox_inventory/web/images/`, `qb-inventory/html/images/`, and so on). You can also download them directly from the container below.

<ItemImageGrid
  title="Phone Item Images"
  zipName="sd-phone-images"
  :images="[
    { src: '/items/phone/phone_black.png', name: 'phone_black.png', alt: 'Phone' },
    { src: '/items/phone/phone_blue.png', name: 'phone_blue.png', alt: 'Blue Phone' },
    { src: '/items/phone/phone_green.png', name: 'phone_green.png', alt: 'Green Phone' },
    { src: '/items/phone/phone_orange.png', name: 'phone_orange.png', alt: 'Orange Phone' },
    { src: '/items/phone/phone_pink.png', name: 'phone_pink.png', alt: 'Pink Phone' },
    { src: '/items/phone/phone_purple.png', name: 'phone_purple.png', alt: 'Purple Phone' },
    { src: '/items/phone/phone_red.png', name: 'phone_red.png', alt: 'Red Phone' },
    { src: '/items/phone/phone_yellow.png', name: 'phone_yellow.png', alt: 'Yellow Phone' },
    { src: '/items/phone/sim_card.png', name: 'sim_card.png', alt: 'SIM Card' },
  ]"
/>

The files are named after the items, so ox_inventory picks them up automatically with no `image` field needed. `sim_card.png` is only needed if you turn on [unique phones](/resources/phone/unique-phones); see below.

## <span class="step-num">4</span> Add Your API Keys

Third-party keys live in `configs/server/apikeys.lua`, which is deliberately excluded from the client download. Set them before you start the phone for the first time:

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

## <span class="step-num">5</span> Turn On Video Calls (TURN)

Video calls, Photogram Live and bodycams send their picture **directly between the two players**.
That works out of the box when both are on the same network, which is why it usually looks fine
while you test. Two players on **different home connections** need a relay server in the middle,
called TURN.

Skip this step and the failure is easy to mistake for a bug: the call connects, the timer runs, the
audio works, each player sees their own camera perfectly, and the other person's half of the screen
stays black.

One setup covers video calls, nearby-voice capture in camera clips, Photogram Live and bodycams.

### The easy way: Cloudflare (free)

sd-phone talks to Cloudflare's TURN service directly, so you only paste two values and it handles
the rest, including refreshing credentials before they expire.

1. Sign in at [dash.cloudflare.com](https://dash.cloudflare.com) (a free account is fine).
2. In the sidebar open **Realtime**, then the **TURN** tab.
3. Click **Create TURN key** and give it any name, for example `sd-phone`.
4. Cloudflare shows a **Turn Token ID** and a **API Token**. Copy both now; the API token is only
   shown once.
5. Put them in your `server.cfg` and restart:

```cfg
set sd_cf_turn_token_id  "paste-the-turn-token-id"
set sd_cf_turn_api_token "paste-the-api-token"
```

That's it. The free tier covers a normal roleplay server, and `configs/voice.lua` already has
`Turn.Provider = 'cloudflare'` switched on.

::: tip How do I know it worked?
While no relay is configured, sd-phone prints a reminder in your server console at boot. Once the
convars are set, that line disappears. To test properly you need two players on **different**
internet connections, not two clients on one PC.
:::

### The alternative: your own TURN server

If you already run [coturn](https://github.com/coturn/coturn), or use a provider that gives you a
**fixed** username and password such as [Metered](https://www.metered.ca/stun-turn), use these
instead. They can also sit alongside the Cloudflare pair as an extra relay:

```cfg
set sd_phone_turn_url        "turn:turn.example.com:3478"
set sd_phone_turn_username   "your-username"
set sd_phone_turn_credential "your-password"
```

::: warning Cloudflare and Twilio credentials do not go here
Both issue **short-lived** credentials through an API rather than a fixed password, so a value
pasted into `sd_phone_turn_credential` stops working within a day. For Cloudflare use the
`sd_cf_turn_*` convars above, which refresh themselves.
:::

## <span class="step-num">6</span> Start the Resource

To load the resource, either restart your server entirely, or run the following in your **server console** (F8 or txAdmin live console):

```cfg
refresh
ensure sd-phone
```

## Optional item setup

### SIM tray button (only for `SimTray`)

Skip this unless you are running [unique phones](/resources/phone/unique-phones) with `SimTray = true`, where the SIM is a physical card dragged into the phone. In every other mode the phone item above is complete as-is.

In tray mode, using the phone opens the phone, so the tray needs its own right-click entry. Add a `buttons` field to **each** phone item:

```lua
buttons = {
    { label = 'SIM Tray', action = function(slot) exports['sd-phone']:openSimTray(slot) end },
},
```

Which gives you, for example:

```lua
['phone_black'] = {
    label = 'Phone',
    weight = 190,
    stack = false,
    consume = 0,
    server = { export = 'sd-phone.usePhone_black' },
    buttons = {
        { label = 'SIM Tray', action = function(slot) exports['sd-phone']:openSimTray(slot) end },
    }
},
```

Note the comma added after `server = { ... }` once a field follows it. Repeat for every phone item you added; an item without the entry simply has no way to reach its tray.

`buttons` is an ox_inventory feature, which is why SIM trays are ox-only. Leaving the entry in place on a server that later switches away from tray mode is harmless, since [`openSimTray`](/resources/phone/exports-client#opensimtray) is a no-op outside it.

### SIM card item (optional)

Only needed if you turn on [unique phones](/resources/phone/unique-phones) in `configs/uniqueandsim.lua` (off by default), where phone numbers live on SIM items instead of characters. Not needed in the `BuiltInNumbers` variant, where phones mint their own numbers. Copy `sim_card.png` from sd-phone's `images/` folder into `ox_inventory/web/images/` like the phone icons, then add the item:

::: code-group

```lua [ox_inventory]
['sim_card'] = {
    label = 'SIM Card',
    weight = 5,
    stack = false,
    close = true,
    consume = 0, -- required: sd-phone consumes the item itself on install
    server = { export = 'sd-phone.useSim_card' }
},
```

```lua [qb-core / qbx_core]
['sim_card'] = { name = 'sim_card', label = 'SIM Card', weight = 5, type = 'item', image = 'sim_card.png', unique = true, useable = true, shouldClose = true, description = 'A SIM card. Install it in a phone to get a number.' },
```

```sql [ESX]
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
  ('sim_card', 'SIM Card', 5, 0, 1);
```

:::

That's the whole integration. Sell or spawn `sim_card` anywhere you like — an ox_inventory shop, a loot table, an admin give — and a blank card **activates itself on first use**, minting a fresh registered number on the spot. The `giveSimCard` export exists only for special cases (character-bound SIMs or hardcoded numbers), and `ActivateBlankSims = false` in `configs/uniqueandsim.lua` disables self-activation if you want every SIM to come through it.

## Convars

| Convar | Default | Purpose |
|---|---|---|
| `sd_fivemanage_key` | empty | Legacy location for the Fivemanage media token; prefer `configs/server/apikeys.lua` |
| `sd_phone_lbcompat` | `true` | The [lb-phone compatibility layer](./lb-phone-compatibility); set `false` to disable |
| `sd_cf_turn_token_id`<br>`sd_cf_turn_api_token` | empty | Cloudflare TURN, used by **every** WebRTC feature: video calls, nearby-voice capture, Photogram Live and bodycams. See [step 5](#_5-turn-on-video-calls-turn) |
| `sd_phone_turn_url`<br>`sd_phone_turn_username`<br>`sd_phone_turn_credential` | empty | A fixed TURN server of your own (coturn, Metered), used in addition to the above |

Both are optional, and either one alone is enough. With neither, the phone falls back to public
STUN: recordings still capture the player's own microphone, and video and nearby voices work only
between players who can reach each other directly, which in practice means the same network.

## Migrating from lb-phone

If the server previously ran lb-phone, the built-in importer carries player data over (numbers, passcodes, contacts, call history, blocked numbers, SMS including groups, photos, notes):

```
sdphone:migrate dry   # preview, writes nothing
sdphone:migrate       # import, idempotent and marker-guarded
```

Third-party lb-phone integrations keep working through the [compatibility layer](./lb-phone-compatibility) without edits.
