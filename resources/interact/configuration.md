# Configuration

Everything is in `configs/client/`, plus one convar for [replacing a target resource](./target-compatibility).

## interact.lua

Defaults for every point, and how the focused point is chosen. A point or an option can set its own distances.

| Option | Default | Description |
|---|---|---|
| `Distance` | `7.0` | Metres within which a point shows (as a dot) |
| `InteractDistance` | `2.6` | Metres within which its prompt can open |
| `Slack` | `0.75` | Added to every distance a prompt is allowed at. A point is measured to its middle, but a player reaches for its near side |
| `FocusRadius` | `0.22` | How far from the middle of the screen a point may be and still take the prompt, as a fraction of the screen's width |
| `Stickiness` | `0.03` | A focused point keeps the prompt until another is this much nearer the middle, so two close points don't flicker between each other |
| `LineOfSight` | `true` | A prompt behind a wall or a door doesn't open (a ray from the camera has to reach the point) |
| `LosEveryMs` | `100` | How often the focused point's line of sight is checked |
| `ScanEveryMs` | `200` | How often points in range, entities of watched models, and options (`canInteract`) are refreshed |
| `ModelScanRange` | `12.0` | Metres around the player searched for entities of `addModel` models and global points |
| `HideInVehicle` | `true` | Hide prompts while the player is in a vehicle (a point can set `allowInVehicle = true`) |
| `HideWhileAiming` | `true` | Hide prompts while the player aims |
| `HideWhenNuiFocused` | `true` | Hide prompts while a menu or inventory has the mouse |
| `HideWhenDead` | `true` | Hide prompts while the player is dead |

## controls.lua

The default keys. They are FiveM key mappings, so each player can rebind them in **Settings > Key Bindings > FiveM**; these are only what a new player starts with.

| Option | Default | Description |
|---|---|---|
| `Key` | `'E'` | Confirm, on a keyboard |
| `Next` / `Prev` | `'IOM_WHEEL_DOWN'` / `'IOM_WHEEL_UP'` | Next and previous option: the mouse wheel |
| `Pad` | `'LRIGHT_INDEX'` | Confirm on a controller: d-pad right, GTA's own button for interacting |
| `PadNext` / `PadPrev` | `'LDOWN_INDEX'` / `'LUP_INDEX'` | Next and previous option: d-pad down and up |
| `Block` | `{ 14, 15, 16, 17, 99, 100, 261, 262, 27, 172, 173, 19 }` | Game controls held off while a prompt with more than one option is open, so the wheel and the d-pad turn the drum instead of switching weapons or opening the phone |

Keyboard key names are FiveM's [keyboard mapper ids](https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/); pad buttons are `PAD_DIGITALBUTTON` names (`LUP_INDEX`, `RDOWN_INDEX` for A, and so on).

## draw.lua

How the prompt and the dots look.

| Option | Default | Description |
|---|---|---|
| `Scale` | `1.08` | Prompt size. 1.0 is its size at 1080p, and it scales with the screen's height |
| `Accent` | `nil` | Colour of the hold outline, e.g. `'#7cc4ff'`. `nil` keeps the prompt all white |
| `GlideMs` | `140` | Moving from one point to the next, the prompt glides there over this long |
| `LeaveMs` | `150` | How long the prompt takes to close |
| `Dots` | `true` | Draw dots on points in range that aren't focused |
| `DotSize` | `7` | Dot size, in pixels at 1080p |
| `DotAlpha` | `165` | Dot opacity, 0 to 255 |
| `DotMerge` | `28` | Dots closer together than this on screen (pixels at 1080p) merge into one |
| `DotClear` | `120` | No dots this close to the open prompt (pixels at 1080p) |
| `DotFade` | `10` | How fast dots fade in and out (higher is quicker) |
| `Canvas` / `Anchor` | `{ w = 760, h = 420 }` / `{ x = 48, y = 210 }` | The prompt page's size and where on it the point goes. Only change these together with `CANVAS` and `ANCHOR` in `web/src/Prompt.tsx` |

## config.lua

| Option | Default | Description |
|---|---|---|
| `Locale` | `'en'` | Which `locales/*.json` to use: the key mapping names in the settings menu and the word "Hold" |
| `Debug` | `false` | Prints focus changes and draws every point's anchor |

## The replace convar

Set in `server.cfg`, before `ensure sd-interact`, to answer another target resource's exports:

```cfg
setr sd_interact:replace "ox_target,qtarget"
```

Off unless set. The names it takes are `ox_target`, `qtarget` and `qb-target`. Read [Replacing ox_target / qb-target](./target-compatibility) before turning it on.
