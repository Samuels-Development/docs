---
title: Live Video
description: How MDT bodycams, dashcams and live broadcasts travel, what it costs your server, and the one thing you have to set up yourself.
---

# Live Video

Four features in the phone move live video: MDT bodycams and dashcams, Photogram Live and Vibez Live. All of them work on a fresh install with nothing configured. This page is about what they cost your server, and what you can do about it.

## The three ways a picture travels

**Direct, between the two clients.** The watching terminal opens a connection straight to the broadcasting officer's game client and the picture never touches your server. This needs no port, no certificate and no configuration, and it is what MDT bodycams try first.

**Through the game server.** The broadcaster encodes, the picture crosses to your server and your server sends a copy to each viewer. This always works and needs nothing set up, which is why it is the fallback. It is also the expensive one: a copy per viewer, at the bitrate you configured.

**Through the media relay.** A small WebSocket server carries the bytes instead of the game server. One upload from the broadcaster no matter how many watch, and nothing on the game thread. This one needs a hostname and a certificate, which is why it is opt-in.

Nothing chooses between these by hand. A terminal takes the best one available to it and falls back on its own, and the only sign of which one it landed on is a small label on the picture: **Direct**, **Server** or **Relay**.

## What a fresh install does

Nothing to configure. Bodycams go direct where the two clients can reach each other, and through your server where they cannot.

Direct connections use the same STUN and TURN settings as the phone's voice mesh, in `configs/voice.lua`. Public STUN is enough for most pairs of players. Adding TURN (`sd_cf_turn_token_id` and `sd_cf_turn_api_token`) covers the rest, and the same setting serves voice, video calls and bodycams together.

::: tip
A direct connection reveals each player's IP address to the other, exactly as voice does. With TURN configured you can force everything through the relay instead by setting the transport policy in `configs/voice.lua`.
:::

## What it costs, and the two knobs that matter

Every viewer on the server path costs your server one copy of the stream. At the shipped full-screen profile that is around 1 Mbit/s per viewer; at a profile tuned up to 8 Mbit/s it is eight times that, per viewer.

Two settings in `configs/bodycam.lua` bound it:

| Setting | Default | What it does |
| --- | --- | --- |
| `MaxViewers` | `6` | Terminals allowed on one camera at once. |
| `PeerMaxViewers` | `3` | How many of those may hold a direct connection. Each one is an upload from the officer's own connection, so this sits below `MaxViewers` on purpose. |

Set `PeerToPeer = false` to switch direct connections off entirely and put everything through the server.

### Bitrate has a ceiling you can cross

A chunk of video is roughly `Bitrate / 8 × TimesliceMs / 1000 × 1.37` bytes, and anything past 600 KB is refused. The server checks your profile at boot and says so plainly if it cannot fit:

```
[sd-phone:cameras] Fullscreen: Bitrate 8000000 over KeyframeMs 20000 makes a run of
about 27400000 bytes, past the 1048576 byte replay cache. Terminals joining will wait
for a fresh header rather than starting instantly.
```

Read that as: it still works, joins are just slower. Lower `Bitrate`, or lower `TimesliceMs`, to get instant joins back.

## The relay

Worth turning on when live broadcasts have real audiences, or when many terminals watch one camera. Set `Enabled = true` in `configs/media.lua` and it runs inside the resource: no Node to install, no second process, no signing key to generate and no port to choose. The console tells you the port it took.

```
[sd-phone:media] relay ready at ws://127.0.0.1:30567 · 45s tokens
```

That address is the machine it is running on, which is your server, not your players. **This is the part nothing can do for you:** the phone's browser refuses an insecure connection to anything but the machine it is running on, and rejects a self-signed certificate, so real players need TLS in front of the relay and its public address in a convar:

```cfg
set sd_phone_relay_url "wss://media.example.com/ws"
```

The simplest way to get there is a reverse proxy that handles certificates for you, pointed at the port the console printed:

```caddyfile
media.example.com {
    reverse_proxy 127.0.0.1:30567
}
```

Until that is set, the console says so rather than leaving you guessing:

```
[sd-phone:media] the relay is up on port 30567, but no address is set for it. Put TLS
in front and `set sd_phone_relay_url "wss://your.host/ws"`, or `set sd_phone_relay_loopback 1`
to test it on this machine.
```

To run the relay on its own box instead, set `SelfHost = false` in `configs/media.lua` and follow `media-server/README.md`.

## When something looks wrong

**The picture flickers or keeps restarting.** Check the console for a line naming your bitrate. A profile that produces chunks past the ceiling loses them, and lost chunks cut the stream until the next header.

**A terminal says Server when you expected Direct.** The two clients could not reach each other, or the camera already has as many direct connections as `PeerMaxViewers` allows. Both are working as intended.

**The relay never connects.** The address in `sd_phone_relay_url` has to be reachable by your players and it has to be `wss://`. A self-signed certificate does not work, and neither does a plain `ws://` address to anything but the player's own machine.
