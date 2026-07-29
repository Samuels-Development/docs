---
title: Configuration
description: A walkthrough of the configs folder, one file per app plus the shared shell settings.
---

# Configuration

Configuration is split per app: everything lives in `configs/`, one annotated file per app, stitched together by `configs/config.lua`. Every option carries an explanatory comment in place, so this page maps the folder rather than duplicating each file.

::: info
Server-only secrets (`configs/server/apikeys.lua`) are deliberately excluded from the client download. Never widen the manifest's `configs/*.lua` glob to `configs/**.lua`, that would ship your API keys to every connected client.
:::

## Shell

| File | Covers |
|---|---|
| `config.lua` | The index that merges the per-app files; debug flag |
| `phone.lua` | Open/close behaviour, keybind, the phone item list and their frame colours, and the [phone number format](#phone-number-format) |
| `uniqueandsim.lua` | [Unique phones, SIM cards, built-in numbers, cloud backups](/resources/phone/unique-phones) |
| `apps.lua` | Dock, home wallpaper, and the full app catalog. Per app: `base = true` ships it uninstallable; `enabled = false` disables it server-wide — hidden from the home screen and App Store, and removed from phones that had it installed |
| `lockscreen.lua` | Lockscreen appearance |
| `statusbar.lua` | Carrier text, the battery indicator, and the fallback signal bars used when cell towers are off |
| `celltowers.lua` | [Cell service](#cell-service): mast positions and coverage, capability thresholds, map blips |
| `share.lua` | AirShare nearby-target rules |
| `migrate.lua` | The lb-phone boot importer |

## Phone number format

`Number` in `configs/phone.lua` controls how long a new phone number is and how numbers are displayed. Numbers are always **stored as bare digits**, so this is presentation and generation only: no database column, contact, message or call log is rewritten, and every lookup keeps matching on digits.

```lua
Number = {
    Length = 10,
    Formats = {
        [10] = '(XXX) XXX-XXXX',
    },
},
```

Each `X` in a format takes the next digit and every other character is printed literally, so `'+44 XXXX XXXXXX'`, `'XXX-XXXX'` and `'XX XX XX XX'` all work. A digit count with no entry is shown as bare digits.

**Formats are keyed by digit count so that changing `Length` is safe.** Existing numbers are never reissued, so a running server ends up with a mix. Add an entry for the new length and keep the old one, and both generations stay readable side by side:

```lua
Number = {
    Length = 7,
    Formats = {
        [7]  = 'XXX-XXXX',        -- issued from now on
        [10] = '(XXX) XXX-XXXX',  -- already in circulation
    },
},
```

Every length listed here, plus `Length` itself, is also accepted when an admin assigns a number by hand, so an older number can still be corrected after the change.

## Cell service

`configs/celltowers.lua` turns signal strength into something real: a list of masts, each with a
position and a flat radius, and a phone's service is the **best** reading across all of them.

```lua
Enabled = true,

Towers = {
    { tower = vec3(-75.0, -818.0, 326.0), range = 2200.0 },  -- Downtown Los Santos
    { tower = vec3(1858.3, 3694.0,  37.9), range = 1700.0 },  -- Sandy Shores
},
```

Service at a point is `1 - distance / range`, taking the highest result. So a player 200 units
from a 250-range mast (20%) who is also 750 units from a 1000-range mast (25%) gets 25%: the
further mast wins because it reaches better.

Distance is **horizontal only**. The Z in each entry is ignored by the maths, so coordinates can be
pasted straight off an antenna prop without the height eating coverage, and a pilot at altitude
keeps the service of the ground below them.

`Enabled = false` leaves every phone on full service without you having to delete the mast list. An
empty `Towers` list does the same, as does a list where every entry is malformed: a config typo
must never leave a server without phones.

### What degrades

Capabilities drop away in tiers rather than all at once, set by `Thresholds`:

| Threshold | Default | Below it |
|---|---|---|
| `Text` | `0.05` | Texts are refused; texts sent to the player are held and delivered when they return to coverage |
| `Data` | `0.05` | Data-backed apps refuse to load |
| `Call` | `0.15` | Calls cannot be placed, and the player cannot be reached |

Text and data share the first bar's cutoff, so both work anywhere the phone shows a bar at all,
while a voice call needs more. That ordering is deliberate: a call wants sustained bandwidth in
both directions, where a text or a feed request is a short burst a weak signal still carries. The
practical result is a one-bar band where you can text and browse but not call.

Calls and texts are enforced **server-side**, recomputed from the server's own view of the player,
so the gate is not something a modified client can talk its way past.

Apps listed in `Offline` keep working with no signal at all: the phone's own settings, on-device
content like Notes, Files, Photos and Contacts, reading existing message threads and the call log,
plus the radio (which is RF, not cellular) and payphones (landlines). Anything not listed needs
`Thresholds.Data`, so an app added later is covered by default.

### Dropped calls

A call already in progress ends when a participant loses call-grade signal, and both sides get a
phone notification saying so — the one who drove out of range is told they lost service, the other
that the caller did.

`DropCallsAfter` is the grace period in seconds, default `6`. It stops a call dying because
someone clipped the edge of a dead zone for a moment: the countdown resets the instant signal
returns. Set `0` to cut the moment coverage goes, or `false` to let a connected call survive
anywhere once it is up.

::: tip
A payphone leg is never dropped. A booth is a landline and has no cell signal to lose, so only the
mobile side of a payphone call is watched.
:::

Ringing calls are left alone; an unanswered ring times out on its own. Voice quality does not
degrade on the way down: a call either holds or drops.

### Map blips

`Blips` draws a marker on each mast plus a translucent circle showing what it reaches, which is how
you judge whether a layout has the dead zones you intended. It is a setup aid rather than something
to run live, so it has its own switch, independent of `Enabled` — a network can be laid out and
inspected before service gating is ever turned on.

The circle's size is read from each mast's own `range`, never a separate number, so what the map
shows cannot drift out of step with the service the maths gives you.

## Communication

| File | Covers |
|---|---|
| `messages.lua` | SMS caps, group thread limits, body length |
| `mail.lua` | Mail domain, account and message caps |
| `contacts.lua` | Phone book and recents caps |
| `groups.lua` | Player groups (crews) limits |
| `darkchat.lua` | Anonymous room rules, public room list |
| `radio.lua` | Frequency ranges carried over pma-voice, restricted bands |
| `friends.lua` | Find Friends live location sharing |

## Media and social

| File | Covers |
|---|---|
| `photos.lua` | Camera and gallery caps, upload limits |
| `voice.lua` | Voice capture for camera videos and Photogram Live (TURN setup) |
| `voicememos.lua` | Recording caps |
| `photogram.lua` | Photogram feed and live-streaming knobs |
| `birdy.lua` | Birdy post rules |
| `giphy.lua` | The Messages GIF picker |
| `streaks.lua` | Daily photo streak rules |

## World apps

| File | Covers |
|---|---|
| `banking.lua` | Wallet transaction list, framework bank bridge |
| `services.lua` | Job-to-company directory, dispatch messaging, the phone multijob |
| `garages.lua` | Garage system bridge, vehicle images, waypoint buttons |
| `housing.lua` | Housing system bridge for the Homes app |
| `maps.lua` | Pin caps and GPS behaviour |
| `weather.lua` | Weather sync source |
| `ryde.lua` | Ride-hailing destinations and fares |
| `review.lua` | The curated business directory for the Review app |
| `weazelnews.lua` | Newsroom job gating, article and ticker caps |
| `pages.lua` / `marketplace.lua` | Classifieds boards |
| `stocks.lua` | The server-simulated market |
| `notes.lua` / `cookie.lua` | Notes caps; the clicker mini-game |

Games (chess, wordle, and friends) are configured in code via the shared online-game engine and need no tuning here.
