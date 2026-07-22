---
title: Unique Phones & SIM Cards
description: Phones as distinct items, numbers on SIM cards, and who owns the data - every mode in configs/uniqueandsim.lua explained.
---

# Unique Phones & SIM Cards

By default sd-phone works like most phone resources: every character has one phone number and one set of data, and any phone item opens it. `configs/uniqueandsim.lua` replaces that with a system where **numbers live on SIM cards** (or on the phone itself) and **you choose who owns the data** — each phone item, the SIM, or the character.

## Pick your setup

| You want | Set |
|---|---|
| Stock behaviour (shared data, automatic numbers) | `Enabled = false` |
| Unique phones, SIM cards carry the number | `Enabled = true`, `DataOwner = 'device'` |
| Unique phones, **no SIM items** (built-in numbers) | `'device'` + `BuiltInNumbers = true` |
| Stock data, SIMs **only change your number** | `Enabled = true`, `DataOwner = 'character'` |
| The SIM *is* the phone (original unique phones) | `Enabled = true`, `DataOwner = 'sim'` |

The mental model for players: **phone = your stuff, SIM = your reachability.** How literally that holds depends on the mode.

::: info Backend requirement
Reading and writing per-slot item metadata is required. Supported out of the box: **ox_inventory** (metadata mode, or the physical SIM-tray container mode) and **qb-inventory / ps-inventory / lj-inventory** (metadata via the QBCore item `info` table). Other inventories need a small adapter in `server/sim/inv.lua`; plain ESX inventory has no item metadata and cannot support the feature — the phone falls back to stock behaviour with a console warning.
:::

## The three data models

### `DataOwner = 'device'` — the phone owns the data *(default)*

Each phone item gets a persistent identity the first time it's used, and that identity keys everything: messages, call log, contacts, photos, notes, app logins, settings, installed apps, games. The SIM only lends a number.

- **Eject the SIM** and the phone drops to **No Service** — calls and texts are refused with a clear message — but it still opens and every non-number app keeps working.
- **Move a SIM to another phone** and that phone gets your *number*, never your data.
- **Steal a phone** and you hold its data behind the owner's lockscreen: the passcode still gates it, and Face Unlock never works for a thief (the phone remembers its first activator).
- Texts sent to a number whose SIM is out of service **queue and deliver** when the SIM lands in a phone again — like real SMS store-and-forward.

### `DataOwner = 'character'` — stock data, SIM numbers

**Your data always belongs to your character.** Messages, contacts, photos, app logins — every phone you pick up opens *your* profile, with or without a SIM, exactly as if the feature were off. A stolen phone shows the thief's own data, never the owner's. The only thing SIM cards do in this mode is decide your **number**:

- **Install a SIM** → your number becomes the card's number. Your data doesn't change.
- **Swap to a different SIM** → different number, same data.
- **Eject (or never own a SIM)** → you're not cut off: the phone keeps full service on a vanilla auto-assigned number. SIMs are entirely optional here — think of them as number-changers players *can* use, not something they need.
- Enabling this mode on an existing stock server changes nothing for anyone — same data, same rows, zero migration. Use `/givesim <id> bind` to put a character's existing number onto a physical card.

### `DataOwner = 'sim'` — the SIM owns everything *(legacy)*

Whichever SIM sits in a phone decides *whose* data that phone shows. Steal a phone with its SIM inside and you're reading the owner's phone; without any SIM the phone opens to a full-screen **No SIM** wall with every server action refused. This is the original unique-phones behaviour, kept byte-for-byte for servers that want maximum-stakes phone theft.

::: tip Migrating between modes
Flipping a `'sim'` server to `'device'` is safe and automatic: on first use each phone **adopts** the identity of the SIM currently in it (one-shot grandfathering, no data copied or lost); only from then on does the number float free of the data. Flipping stock to `'character'` is a no-op for data. Numbers from an lb-phone import are preserved through `migrate.lua` either way.
:::

## Built-in numbers ("eSIM")

`BuiltInNumbers = true` removes SIM items from the equation entirely: every phone mints its own **permanent number on first use**, stamped onto the item. No install, no eject — the number lives and dies with the phone, and giving someone "your number" means handing over the phone. Pairs with `DataOwner = 'device'` or `'character'` (`'sim'` has no SIM to own data and coerces to `'device'`). With it on, `SimItem`, `UseContainers`, `AllowEject`, `ActivateBlankSims`, and `/givesim` are all inert, and Settings shows the SIM as **Built-in**.

## How players experience it

- **Multiple phones**: a player can carry several phones; each is reachable on its own number, and the phone they last opened is the one they "act as". Calls ring whichever phone holds the dialed number, even in a pocket.
- **Phone-scoped notifications**: banners and lockscreen notifications belong to the phone they're for. A message to the phone in your pocket shows a transient **"Red Phone" buzz banner** (with the app's real icon), and the full notification waits on *that* phone's lockscreen for its next open — never leaking onto the phone you're using.
- **Live swaps**: ejecting or installing a SIM updates everything in place — My Card, Settings, service state — no reopen needed.
- **Getting SIMs to players needs zero integration**: sell or spawn the `sim_card` item anywhere (shop, loot table, admin give). A blank card **activates itself on first use**, minting a fresh registered number. `ActivateBlankSims = false` turns that off so every SIM comes through the [`giveSimCard` export](/resources/phone/exports-server) or `/givesim`.

## Cloud Backup

With unique phones on, Settings gains a **SIM & Backup** page. Backups are real snapshots, iCloud-style:

- **Back Up This Phone** enables a backup profile for the current phone and takes an immediate full snapshot: contacts, messages, call history, photos and albums, notes, passwords, alarms, app logins, settings, wallet ledger, game stats — everything except the phone number (numbers follow SIMs; a lost number is lost) and live room state.
- **One password per character** guards every profile; it's set on first enable, required on later ones, and a copy is saved into the phone's Passwords app. If a character deletes all their profiles, the next enable may set a fresh password (the recovery path).
- **Auto Backup** (on by default) refreshes the snapshot when the phone is holstered, throttled to once per 5 minutes — and only ever from the phone that owns the profile, so a lost or stolen phone can never overwrite a backup with an empty one.
- Up to `Backup.MaxProfiles` phones (default **3**) can be backed up per character; the Settings page lists them with last-backup times, and tapping one deletes it to free the slot.
- **Restore** copies a chosen snapshot onto the current phone (with a picker when several exist), moves group-chat membership and mail logins over from the source phone, resets the UI in place, and leaves the snapshot itself untouched — so restoring can never destroy a backup.

## Configuration reference

Every option in `configs/uniqueandsim.lua`:

| Option | Default | What it does |
|---|---|---|
| `Enabled` | `false` | Master switch. Off = stock sd-phone: numbers auto-assigned per character, phone always has service |
| `DataOwner` | `'device'` | Who owns the data: `'device'`, `'sim'`, or `'character'` (see above). The older `DeviceIdentity` boolean is still honoured when this key is absent |
| `BuiltInNumbers` | `false` | Phones mint their own permanent numbers; no SIM items at all |
| `SimItem` | `'sim_card'` | The inventory item that carries a number in its metadata |
| `ActivateBlankSims` | `true` | Blank cards self-activate with a fresh number on first use. Off = only `/givesim` and the `giveSimCard` export produce usable SIMs |
| `UseContainers` | `false` | ox_inventory only: each phone becomes a 1-slot "SIM tray" container and SIMs are physically dragged in and out. Trade-off: using the phone item opens the tray, so the phone UI itself only opens via the keybind |
| `AllowEject` | `true` | Metadata mode: allow ejecting the installed SIM from Settings → SIM & Backup (the card returns to the inventory with its number intact) |
| `Backup.Enabled` | `true` | The Cloud Backup section in Settings |
| `Backup.MaxProfiles` | `3` | How many phones one character can back up at once (each holds a full snapshot) |

## Admin & integration

- **`/givesim <playerId>`** (admin) hands out a blank SIM; **`/givesim <playerId> bind`** creates a character-bound SIM carrying that character's existing number and, in `'sim'` mode, their data.
- The **[server exports](/resources/phone/exports-server)** cover the rest: `giveSimCard` (pre-provisioned cards with specific numbers), `getSimNumber`, `hasSimInstalled`, `isSimModeActive`, `isNumberAvailable`, and `setSimNumber` (the hook for "buy a custom number" scripts).
- The SIM item setup (inventory definition + icon) is in the [installation guide](/resources/phone/installation#sim-card-item-optional). Not needed with `BuiltInNumbers`.
