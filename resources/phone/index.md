---
title: Phone
description: An iOS-themed smartphone with 45+ apps, real app accounts, a live game-view camera, online multiplayer games, and drop-in lb-phone compatibility.
---

# Phone <VersionBadge repo="sd-phone" fallback="0.1.0" />

`sd-phone` is an iOS-themed in-game smartphone: lockscreen with Face Unlock and passcode, customizable homescreen, notification banners with persistent unread badges, an app switcher, and 45+ apps backed by real server modules.

## Highlights

- **Communication**: Messages (SMS, group threads, GIFs, money and location cards), Mail with global multi-account inboxes, Calls over pma-voice (1:1, group and company rings), Contacts with AirShare, Dark Chat, and a Radio app.
- **Social with real accounts**: Photogram (posts, stories, DMs, live video streaming), Birdy, Cherry, Vibez, and Streaks all run on a shared accounts engine with registration, sign-in, and password resets delivered by in-game mail or SMS.
- **Camera and media**: the Camera app renders the live game view into the phone (photo, video with voice capture, selfie mode), a Photos gallery with editing, Music with AirShare library sharing, Voice Memos, and video-capable Photogram feeds.
- **World integration**: Services (company directory, dispatch-style messaging, phone multijob), Garages and Homes bridged across ten-plus garage and housing systems, Wallet over the framework's bank, Maps with CDN-streamed tiles, Weather synced to the in-game sky, Ryde ride-hailing between real players, and a boss-gated Weazel News newsroom.
- **Games**: online multiplayer Chess, Connect Four, Battleship, and Wordle with lobbies and stats, plus single-player arcade games with server-side leaderboards.
- **For developers**: an extensive [export surface](./exports-server), [first-party events](./events-server) on every lifecycle moment, [custom apps](./custom-apps) so any resource can ship its own phone app (with [ready-made templates](https://github.com/Samuels-Development/sd-phone-app-templates) for plain JS, React and Vue), and a [drop-in lb-phone compatibility layer](./lb-phone-compatibility) covering exports, events, dependencies and lb-phone custom apps, with a one-command data migrator.

## Framework support

The phone talks to the world through a bridge layer that auto-detects the running framework (qb-core, qbx_core, ESX) and the installed inventory, banking, housing, garage, and dispatch resources. Nothing framework-specific leaks into the apps themselves.

## Getting started

Head to [Installation](./installation) for dependencies and setup, then [Configuration](./configuration) for the per-app config walkthrough.
