---
title: Tablet
description: A companion tablet for sd-phone. Same apps, same accounts, same data, on a bigger screen, plus a police MDT.
---

# Tablet <VersionBadge repo="sd-tablet" fallback="0.1.0" />

`sd-tablet` is a second device for the same character. Pick up the tablet and you are looking at the phone you already had, on a bigger screen: the same Messages threads, the same Photogram account, the same wallet, the same installed apps, the same wallpaper and passcode.

There is no pairing step, no sync and no "tablet account". There is one set of player data on sd-phone's server and two devices that read it, so anything you do on one is already true on the other.

::: danger sd-tablet is a companion script. It does not work on its own.
It is not a standalone phone, a fork, or a second copy of anything. It ships no apps, no database tables and no server logic of its own; it renders sd-phone's UI and forwards every action into sd-phone's client and server. A running [sd-phone](/resources/phone/) is a hard dependency, declared in `fxmanifest.lua`, so the resource refuses to start without it.
:::

## What it shares, and what it does not

| | |
|---|---|
| **Shared with the phone** | Messages, contacts, mail, notes, photos, app accounts and logins, wallet, settings, passcode and Face Unlock, installed apps, notifications, badges |
| **The tablet's own** | Home screen arrangement, and the device itself: item, keybind, hold pose and prop |
| **Not available** | Voice calls, the payphone UI, the admin panel, the first-run setup wizard, the flashlight |
| **Tablet only** | The **MDT**, a police terminal laid out for this screen. sd-phone ships it hidden with its backend switched off, so a phone-only server pays nothing for it |

## Why there are no calls

The one thing the tablet cannot do is place or answer a voice call: no dialler, no FaceTime, no payphones. The Phone app is not merely hidden, it is rejected by app id, so no notification, deep link, Control Center entry or custom-app SDK call can open it.

That refusal lives inside sd-phone, on the far side of the companion seam, which means it holds even for a modified tablet build.

## One UI, two devices

The tablet does not copy sd-phone's interface. It compiles sd-phone's own `web/src` against a tablet device profile (screen geometry, home grid, `calls: false`), so there is exactly one copy of the interface and it cannot drift between the two devices.

Only one device is ever on screen: opening the tablet closes the phone, and opening the phone closes the tablet.

## Framework support

The tablet reuses sd-phone's framework and inventory detection, so it supports the same list with no configuration: qb-core, qbx_core and ESX, across ox_inventory, tgiann, jaksam, qs and qs-pro, origen, codem, qb-inventory, ps-inventory and lj-inventory.

## Getting started

Head to [Installation](./installation) for dependencies, items and setup. Everything else the tablet shows is configured in [sd-phone's own config](/resources/phone/configuration), because the data is the phone's.
