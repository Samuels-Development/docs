# Installation

`sd-interact` is client only: no server script, no database, no items.

## Dependencies

| Dependency | Required | Notes |
|---|---|---|
| **Library** | Yes | `ox_lib` |
| **Framework** | No | `qbx_core` / `qb-core` / `es_extended`, read for `groups` (job and gang) checks when one is running |
| **Inventory** | No | `ox_inventory`, read for the `items` checks of ox_target options when sd-interact stands in for it |

## Step-by-Step Installation

### 1. Download

Download **`sd-interact.zip`** from the [latest release](https://github.com/Samuels-Development/sd-interact/releases/latest) and unzip it into your resources folder. It is the resource with its prompt page already built.

::: warning Download the zip, not the source
**Source code (zip)** and the green **Code** button on GitHub give you the source without the built page: the resource would start, but no prompt would ever draw. To run from source, see [Building from source](#building-from-source).
:::

### 2. Start it

Start it after `ox_lib`, and before the resources that add prompts at their own start:

```cfg
ensure ox_lib
ensure sd-interact
```

If you are using it in place of ox_target, start it before `[ox]` as well: ox_inventory registers its shop targets as it starts. The rest of that setup is on [Replacing ox_target / qb-target](./target-compatibility).

### 3. Check it works

Drop this in any client script of a resource you are working on, stand near the coordinates and look at them:

```lua
exports['sd-interact']:addCoords(GetEntityCoords(PlayerPedId()) + vec3(0.0, 2.0, 0.0), {
    options = {
        { label = 'Say hello', icon = 'fa-solid fa-hand', onSelect = function() print('hello') end },
        { label = 'Hold to wave', icon = 'sparkles', hold = 1500, onSelect = function() print('waved') end },
    },
})
```

A prompt should open on the spot two metres ahead of where you stood: E says hello, the wheel scrolls to the second option, and holding E fills its outline.

### 4. Configure

Distances, the default keys, the prompt's size and the dots are in `configs/client/`. See [Configuration](./configuration).

## Rebinding keys

The keys are FiveM key mappings, so each player can change them in **Settings > Key Bindings > FiveM** (look for *Interact*). The defaults in `configs/client/controls.lua` only apply to players who haven't bound them yet.

## Building from source

The repository is the source: the built page (`web/build`) is not committed, and each [release](https://github.com/Samuels-Development/sd-interact/releases) builds it into its zip. To run a clone, or after changing the page, build it with Node.js (LTS):

```bash
cd web
npm ci
npm run build
```

A source zip unpacks to `sd-interact-main`: rename the folder to `sd-interact`, the name its exports are called by.
