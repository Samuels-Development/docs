---
title: Interact
description: Floating interaction prompts drawn on the thing you look at, with keyboard and controller support and a drop-in stand-in for ox_target, qtarget and qb-target.
---

# Interact <VersionBadge repo="sd-interact" fallback="1.0.0" />

`sd-interact` puts the interaction on the thing itself. Look at something you can use and a small prompt opens on it: an icon tile on the spot, what it does, and the key that does it. It is free and open source ([GitHub](https://github.com/Samuels-Development/sd-interact), GPL-3.0).

![A prompt opening on a pistol, scrolling to Inspect, holding Seize while its outline fills, and closing](/interact/prompt-demo.gif)

## How it works

- **Points.** A resource registers a point: fixed coordinates, an entity (local or networked, on an offset or a bone), every entity of some models, or every vehicle, ped, object or player nearby. A point carries its options and two distances.
- **Focus.** Of the points within reach, the one nearest the middle of the screen gets the prompt. A prompt behind a wall doesn't open. Other points in range show as small dots, a ring once you are close enough to use them, and dots that crowd together merge into one.
- **The prompt.** Options stack on a drum, and the one on the point is the one the key uses. The mouse wheel or the d-pad turns the drum. An option can be held instead of pressed: an outline runs round its tile as you hold and runs back if you let go.
- **Drawn into the world.** The prompt is a web page rendered off screen and painted into the game's own frame at the point, so it stays pinned to the world with no lag and renders at the screen's own resolution.

![Crack the safe: a hold prompt on a safe, with a dot on the workbench beside it](/interact/01-on-anything.webp)

## Highlights

- **A small API.** `addCoords`, `addLocalEntity`, `addEntity`, `addModel` and the global adders, each returning an id you can `update` or `remove`. Points go away by themselves when the resource that made them stops.
- **The option fields you already know.** Options take ox_target's handler fields (`onSelect`, `export`, `event`, `serverEvent`, `command`) and `groups`, so option tables move over as they are.
- **Live labels.** `canInteract` can return a second value: the label to show right now ("Lock" or "Unlock"), without re-registering the point.
- **Keyboard and controller.** Confirm, next and previous are FiveM key mappings, so every player can rebind them. On a pad the prompt shows the button's glyph.
- **A stand-in for your target.** Turned on, it answers `exports.ox_target`, `exports.qtarget` and `exports['qb-target']` with prompts, so the scripts you already run use it without a line changed. See [Replacing ox_target / qb-target](./target-compatibility).

![The prompt's states: three options, scrolled with a second line, held, and on a controller](/interact/02-states.webp)

## Getting started

1. [Installation](./installation): download, start order, and a first prompt to check it works.
2. [Adding prompts](./adding-prompts): points, distances, options, who sees them and what they do.
3. [Examples](./examples): a shopkeeper, every ATM, a car's boot, a door that says Lock or Unlock, and more.
4. [Client exports](./exports-client): every export with its parameters.
5. [Configuration](./configuration): distances, keys, prompt size and dots.
