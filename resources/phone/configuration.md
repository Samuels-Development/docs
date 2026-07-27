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
| `statusbar.lua` | Carrier text and the signal/battery indicators |
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
