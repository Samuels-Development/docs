# Installation

## Dependencies

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qbx_core` / `qb-core` / `es_extended` |
| **Library** | Yes | `ox_lib` |
| **Database** | Yes | `oxmysql` |
| **Inventory** | Yes | `ox_inventory`, `qb-inventory`, `qs-inventory`, `tgiann-inventory` and others, detected at run time |
| **Target** | Yes | `ox_target` / `qb-target` / `qtarget`, for pitching to peds and meeting contacts |
| **Dispatch** | Optional | `linden_outlawalert`, `cd_dispatch`, `fd_dispatch`, `ps-dispatch`, `qs-dispatch`, `core_dispatch`, `origen_police`, `codem-dispatch`, `tk_dispatch` |
| **sd-phone** | Optional | Two-way texts between burners and smartphones |

::: tip
Framework, inventory, target and dispatch are all detected automatically. The database tables are created on first start.
:::

## Step-by-Step Installation

### 1. Download

Download **`sd-trapphone.zip`** from the [latest release](https://github.com/Samuels-Development/sd-trapphone/releases/latest) and unzip it into your resources folder. It is the resource with its handset page already built.

::: warning Download the zip, not the source
**Source code (zip)** and the green **Code** button on GitHub give you the source without the built handset page: the phone would open to nothing. To run from source, see [Building from source](#building-from-source).
:::

### 2. Add the items

Add the items from `items.md` (in the resource) to your inventory, and copy the pictures in `images/` into its image folder. `items.md` has the block for `ox_inventory/data/items.lua` and the entries for qb-style inventories.

| Items | |
|---|---|
| `trap_phone_graphite`, `trap_phone_chrome`, `trap_phone_pearl`, `trap_phone_bling`, `trap_phone_ice`, `trap_phone_bubblegum`, `trap_phone_lime`, `trap_phone_cherry`, `trap_phone_grape`, `trap_phone_tangerine` | The ten phones. The item decides the faceplate on screen and the model in the hand |
| `scales`, `batteries` | Bagging up, and the scales' battery |
| `baggies`, `large_baggies` | Only used when `UseBaggies` is on in `configs/shared/scales.lua` |
| `weedbaggy`, `weed_7g`, `weed_1oz`, `weed_brick` | Weed, by size |
| `cokebaggy`, `coke_7g`, `coke_1oz`, `coke_brick` | Coke, by size |
| `meth`, `meth_7g`, `meth_1oz`, `meth_brick` | Meth, by size |

The products are only what ships in `configs/shared/drugs.lua`: point it at the item names your server already uses.

### 3. Start it

Start it after its dependencies:

```cfg
ensure ox_lib
ensure oxmysql
ensure sd-trapphone
```

### 4. Configure

Prices, XP, stock and locations are in `configs/server/`, which never reaches a client. See [Configuration](./configuration).

## Admin commands

Allowed from the server console, or for anyone holding the `command.trapphone` ace (`AdminAce` in `configs/config.lua`).

| Command | |
|---|---|
| `/trapadmin give <id>` | Give a player a phone |
| `/trapadmin xp <id> <family> <set\|add> <amount>` | Set or add XP in a product family (`weed`, `coke`, `meth`) |
| `/trapadmin intro <id> [contact]` | Make a contact reach out to a player |
| `/trapadmin gangrep <id> <gang> <value>` | Set a player's standing with a crew |
| `/trapadmin reset <id>` | Reset the phone a player carries |

## Building from source

The repository is the source: the built handset page (`web/build`) is not committed, and each [release](https://github.com/Samuels-Development/sd-trapphone/releases) builds it into its zip. To run a clone, or after changing the page, build it with Node.js (LTS):

```bash
cd web
npm ci
npm run build
```

A source zip unpacks to `sd-trapphone-main`: rename the folder to `sd-trapphone`, the name its exports are called by.
