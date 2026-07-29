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
| `wifi.lua` | [Wi-Fi](#wi-fi): local networks, what a connection carries, remembering and scanning |
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

## Wi-Fi

`configs/wifi.lua` is the other half of connectivity: routers placed around the world that carry
data where the masts do not reach, or will not.

```lua
Enabled = true,

Networks = {
    { id = 'legion',   ssid = 'Legion Square Free',  coords = vec3(195.0, -935.0, 30.7), range = 55.0 },
    { id = 'mazebank', ssid = 'MazeBank-Corporate',  coords = vec3(-70.0, -800.0, 44.2), range = 50.0, password = 'maze2024' },
},
```

`id` is what everything else refers to: the exports, the app gating, and a player's remembered
networks. Renaming one drops every connection to it. `ssid` is only ever the name a player reads on
screen. `password` is optional, and omitting it leaves the network open, which the phone shows
without a padlock and joins in one tap.

`Enabled = false` makes the whole system inert without you having to delete the network list:
nothing is scanned, nothing connects, and the phone falls back to cell service alone.

### Range is a sphere

Unlike cell towers, where the radius is flat and height is ignored, Wi-Fi range is a **true sphere**
and distance counts the Z. A router is a box in a room rather than a mast on a hill, so the floor
above can sit outside a network the floor below is on. That is usually what you want: a router meant
to belong to one office should not blanket the whole tower.

Twelve networks ship configured, split between public places that would plausibly hand out free
Wi-Fi and places with a reason to keep people out. One of them sits at Mount Gordo, which is a cell
dead zone, and it is the point of the whole feature: somewhere with no bars at all where a player
can still get online, if they know where to stand.

::: warning
Passwords are checked **server-side only**, against a player the server has itself placed inside the
network's radius. A password is never sent to a client and never appears in any export; `secured` is
the only thing about it that a caller ever learns.
:::

### What a connection carries

`Provides` decides what Wi-Fi is actually good for:

| Flag | Default | Covers |
|---|---|---|
| `Data` | `true` | Data-backed apps load over the connection |
| `Call` | `false` | Placing and receiving calls over Wi-Fi |
| `Text` | `false` | Sending and receiving texts over Wi-Fi |

Data is the whole point of Wi-Fi, so it is on. Calls and texts ride the cellular network and stay
refused in a dead zone unless you switch Wi-Fi calling on here, which is a real thing phones do.

Wi-Fi plugs into the same capability gate cell service uses, rather than sitting beside it, so a
connection satisfies the data threshold on its own. A router inside a cell dead zone is somewhere a
player can browse and download with no service whatsoever.

### Joining, remembering and scanning

`Remember = true` rejoins a network the player has connected to before as soon as they walk back
into it, without asking for the password again. `false` makes every join deliberate.

A character's joined networks, their radio switch, and the networks they explicitly disconnected
from all persist per character in a `phone_wifi` table, so they survive a restart, a relog and a
character swap.

Disconnect and Forget are deliberately different:

| Action | Effect |
|---|---|
| Disconnect | Stay off that network until the player joins it by hand again |
| Forget | The same, and the stored password goes too, so the next join asks for it |

`ScanSeconds` is the gap between scans while the phone is on screen, default `2`. Nothing is scanned
while it is holstered. `DropBelow` is the strength, `0` to `1` across the radius, at which the phone
gives up and drops a connection. The default `0.05` sits a little above zero so a player standing
exactly on the edge does not flap in and out.

### Wi-Fi-locked apps

An app in `configs/apps.lua` can carry `wifi = '<network id>'` to make it downloadable only while
the phone is on that network. `addCustomApp` accepts the same field.

```lua
{ id = 'darkchat', label = 'Dark Chat', icon = 'darkchat', route = '/darkchat', wifi = 'mazebank' },
```

The App Store marks a locked app with a padlock and names the network it wants. For built-in apps
the install path enforces it server-side, re-deriving the connection from the server's own view of
the player, so a client that lies about where it is still cannot reach the app. For third-party apps
the lock is UI-only: custom-app install state lives on the client, so there is nothing server-side
to gate.

::: tip
[`hasWifiAccess`](/resources/phone/exports-server#haswifiaccess) is the same check the install path
makes. Reach for it when something of your own should only work inside one building.
:::

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
