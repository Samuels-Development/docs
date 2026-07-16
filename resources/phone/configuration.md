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
| `phone.lua` | Open/close behaviour, keybind, the phone item list and their frame colours |
| `homescreen.lua` | Dock, wallpaper, and the full app list |
| `lockscreen.lua` | Lockscreen appearance |
| `statusbar.lua` | Carrier text and the signal/battery indicators |
| `share.lua` | AirShare nearby-target rules |
| `migrate.lua` | The lb-phone boot importer |

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
