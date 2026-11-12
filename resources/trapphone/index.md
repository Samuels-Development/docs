---
title: Trap Phone
description: A keypad burner phone that runs a street business. Corner sales, drop-offs, plugs, turf, ten handset colours with their own props, and two-way texts with sd-phone.
---

# Trap Phone <VersionBadge repo="sd-trapphone" fallback="1.0.0" />

`sd-trapphone` is a keypad burner phone that runs a street business. Players serve corners, take drop-off orders, haggle by text, meet plugs and pay off crews, all from an early-2000s candybar handset with a colour screen, a d-pad and a full keypad. It is free and open source ([GitHub](https://github.com/Samuels-Development/sd-trapphone), GPL-3.0), and the handset runs [in your browser](https://fivem.samueldev.shop/trapphone) with sample data.

![The ten handset colours in a row](/trapphone/sd-trapphone-banner.webp)

## Highlights

- **A real handset.** Messages, Contacts, Hustle, Turf, Status, a Worm game, ringtones and wallpapers, driven by a d-pad, two soft keys and a keypad. Mouse, keyboard and on-screen keys all work, and players can still walk and drive with it out.
- **Corner sales.** Start serving and customers text an offer while they walk over, or pull up in a car at a spot you mark. Accept, name your own price, or turn them down.
- **Pitching and drop-offs.** Walk up to anyone and offer, or take orders while driving and deliver to doors across the map.
- **A name on the street.** XP and levels per product are kept on the phone itself, so a stolen phone is a stolen business. Customers remember you, and good ones become named regulars.
- **People.** Plugs, a supplier, an informant, a launderer, a fixer and each crew's shot caller reach out as your name grows.
- **Turf.** Every area has money, a product it craves and often a crew. Sell on their block without paying and they come and ask. Kill enough of them and they riot.
- **Back rooms.** A money wash and a black market that open once you know the right person.
- **Bagging up.** Battery-powered scales break bricks and ounces into smaller bags.
- **Heat.** Snitches and witnesses bring the police through your dispatch resource.

![Corner sales: the message list, an offer in a conversation, and the Hustle screen](/trapphone/01-selling.webp)

## Works with sd-phone

Running [sd-phone](/resources/phone/)? The two text each other. A burner's text lands in the smartphone's Messages under the burner's number, and a reply there comes back to the burner. Nothing to set up, and sd-phone is not required.

![Contacts, a shot caller, ordering from a plug, and the Turf screen](/trapphone/02-people-turf.webp)

## Framework support

The framework (QBox, QBCore or ESX), the inventory (ox_inventory, qb-inventory, qs-inventory, tgiann-inventory and others), the target (ox_target, qb-target, qtarget) and the dispatch resource are all detected at run time. Per-phone progress needs an inventory that stores item metadata; on one that can't, progress is kept per character instead.

## Getting started

1. [Installation](./installation): download, items, start order and the admin command.
2. [Configuration](./configuration): what each of the config files controls.
3. [Client exports](./exports-client) and [Server exports](./exports-server): working with the phone from other resources.
