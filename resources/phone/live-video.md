---
title: Live Broadcasts
description: How Photogram Live and Vibez Live travel, what they cost your server, and the optional relay that takes the load off it.
---

# Live Broadcasts

Two features in the phone move live video across the network: **Photogram Live** and **Vibez Live**. Both are off by default, both work with nothing configured once you switch them on, and both cost your server bandwidth on every viewer. This page is about that cost and what you can do about it.

MDT bodycams and dashcams are on this page too, but only to say that they are not part of the problem. See [Bodycams cost nothing](#bodycams-cost-nothing) below.

## The two ways a broadcast travels

**Through the game server.** The broadcaster encodes, the picture crosses to your server, and your server sends a copy to each viewer. This always works and needs nothing set up, which is why it is the default. It is also the expensive one: one copy per viewer, at the bitrate you configured.

**Through the media relay.** A small WebSocket server carries the bytes instead of the game server. One upload from the broadcaster no matter how many watch, and nothing on the game thread. This one needs a hostname and a certificate, which is why it is opt-in.

Nobody chooses between these by hand. A viewer takes the relay when one is available and falls back on its own, and the only sign of which it landed on is a small label on the picture: **Server** or **Relay**.

## Bodycams cost nothing

It is worth being clear about this, because it is the opposite of what most people expect.

An MDT bodycam or dashcam sends **no video anywhere**. The watching terminal renders the officer's viewpoint in its own game engine, attaching a scripted camera to the officer's ped and drawing the HUD over the top. The officer's client does no encoding and uploads nothing.

That means bodycams need no relay, no TURN server and no bandwidth budget. The only setting that matters is how many terminals may watch one officer at once, in `configs/bodycam.lua`:

| Setting | Default | What it does |
| --- | --- | --- |
| `MaxViewers` | `6` | Terminals allowed on one officer's camera at once (`0` = unlimited) |
| `IdleSeconds` | `15` | How long a viewer may go quiet before the server stops counting them |

Bodycam **recordings** are a separate thing and do move bytes: the watching terminal encodes what it is already rendering and uploads it to the server for storage. Those are governed by the `Recording` block in the same file.

## What Live costs, and the knobs that bound it

Every viewer on the server path costs your server one copy of the stream. At the shipped defaults that is roughly 900 kbit/s per viewer, so a stream with 20 viewers is about 18 Mbit/s of server uplink.

The settings live in `configs/photogram.lua` under `Live` (Vibez Live has an equivalent block):

| Setting | Default | What it does |
| --- | --- | --- |
| `Enabled` | `false` | Whether players can broadcast at all. Off by default precisely because of the bandwidth cost |
| `MaxViewers` | `50` | Concurrent viewers on one stream (`0` = unlimited). The main protection knob on a large server |
| `Bitrate` | `900000` | Encode bitrate in bits/s. Higher is sharper and costs proportionally more per viewer |
| `Fps` | `25` | Broadcaster capture and encode frame rate |
| `TimesliceMs` | `250` | How often the encoder emits a chunk. Lower is lower latency, slightly more overhead |
| `KeyframeMs` | `4000` | How often the stream re-anchors, so people joining mid-stream get a clean picture quickly |

`MaxViewers` multiplied by `Bitrate` is your worst case for a single stream. If that number worries you, the relay below removes it.

## The relay

Worth turning on when live broadcasts have real audiences. Set `Enabled = true` in `configs/media.lua` and it runs inside the resource: no Node to install, no second process, no signing key to generate and no port to choose. The console tells you the port it took.

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

**A viewer says Server when you expected Relay.** The relay is not configured, or its address is not reachable from the player's machine. The stream still works, it is just going through your game server. The console line above tells you which of the two it is.

**The relay never connects.** The address in `sd_phone_relay_url` has to be reachable by your players and it has to be `wss://`. A self-signed certificate does not work, and neither does a plain `ws://` address to anything but the player's own machine.

**Live is missing from the app entirely.** `Live.Enabled` is `false` in `configs/photogram.lua`, which is the default. The Go Live action is hidden and the server refuses to start a broadcast until you switch it on.

**A bodycam looks wrong.** Nothing on this page applies. Bodycams do not stream, so relay and bandwidth settings cannot affect them.
