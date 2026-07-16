# Configuration

Configuration is split across the `configs/` directory:

- **`configs/config.lua`** - global settings: locale, the contact ped, the black-market shop, statistics, and per-crime level thresholds.
- **`configs/<crime>.lua`** - one file per crime (22 of them), each holding that crime's on/off toggle, cooldown, tools, rewards, police alert, and minigame.

Every value can also be edited live from the in-game [admin panel](#admin-panel) - those edits are stored as overrides and take precedence over the file defaults.

## Global Config (`config.lua`)

### Locale

```lua
Locale = 'en', -- Loads locales/<Locale>.json. Falls back to 'en' if missing.
```

### Logging & Menus

```lua
ShopLogging = true, -- Log shop buy/sell + ped actions to the history ledger.
IconColors  = false, -- Allow per-item icon colors in the menus.
```

### Notifications & Cancelling

```lua
ShowRequiredItemsInNotify = true, -- When a robbery fails because you lack the tool, name the
                                  -- required item(s) in the notification, e.g. "(Requires: Lockpick)".
                                  -- Most useful alongside a crime's ShowTargetWithoutItem (below).
AllowCancel = true,               -- Whether players can cancel a crime's progress bar by pressing X.
                                  -- true = cancellable (good if cops show up); false = locked in.
```

| Field | Meaning |
|---|---|
| `ShowRequiredItemsInNotify` | If a crime is attempted without the needed tool, the "you don't have the tool" notification names the actual item(s) (resolved through your inventory's labels) |
| `AllowCancel` | Global toggle for whether the **X** key cancels an in-progress crime. Applies to every crime's progress bar |

### Contact Ped

The black-market contact is a ped that spawns at one random location from the list each restart.

```lua
Ped = {
    Location = {
        {x = 366.44, y = -1250.83, z = 31.51, w = 321.98},
        -- Add more {x,y,z,w} tables; one is chosen at random each start.
    },
    Model = "a_m_m_mlcrisis_01",
    Interaction = { Icon = "fas fa-circle", Distance = 3.0 },
    Scenario = "WORLD_HUMAN_STAND_IMPATIENT", -- Ambient animation. Scenario list: https://pastebin.com/6mrYTdQv
}
```

### Black-Market Shop

The contact buys and sells. Each `BuyItems` / `SellItems` row is a self-contained card.

```lua
Shop = {
    Enable = { Buying = true, Selling = true },
    BuyItems = {
        {
            Product = "lockpick",    -- inventory item name
            Price = 50,              -- cost per unit
            Label = "Lockpick",      -- display title
            Description = "Essential tool for breaking into mailboxes...",
            IconName = "fas fa-key", -- FontAwesome icon
            IconColor = "#FFD700"    -- optional; omit for no color (needs IconColors = true)
        },
        -- screwdriver, crowbar, gloves, ...
    },
    SellItems = {
        { Product = "stolen_goods", Price = 100, Label = "Stolen Goods", Description = "...", IconName = "fas fa-box", IconColor = "#e56969" },
        -- jewelry, electronics, ...
    },
}
```

::: tip
This is where you sell the **tool items** from the [installation page](./installation#add-items). Add `screwdriver`, `multitool`, `powersaw`, etc. as `BuyItems` rows so players can purchase the gear each crime needs (the vanilla `WEAPON_*` tools don't need selling).
:::

### Statistics

```lua
Stats = { Enable = true }, -- Track per-crime attempts, successes, cash, items.
```

::: info Openable packages moved out of `config.lua`
There is **no longer** a shared `Config.Package`. Parcel theft and mailbox each define their own openable item (`porch_package` / `mail_package`) - with their own loot pool, booby-trap, and carry animation - inside their own crime file. See [Openable Packages](#openable-packages) below.
:::

### Level Thresholds

Every crime has its own 3-level curve. `xpRequired` is the **cumulative** XP needed to reach that level. Higher levels unlock the richer reward tiers defined in each crime's config.

```lua
Levels = {
    mailbox = {
        [1] = { xpRequired = 0 },   -- starting level
        [2] = { xpRequired = 150 },
        [3] = { xpRequired = 300 },
    },
    pickpocket = {
        [1] = { xpRequired = 0 },
        [2] = { xpRequired = 100 },
        [3] = { xpRequired = 200 },
    },
    -- ...one block per crime (payphone, parkingmeter, robaped, shoplift,
    -- parceltheft, vending, catalytic, smashgrab, tiretheft, acstrip,
    -- newsrack, atmskimmer, tireslash, brakecut, wheelloose, fuelsabotage,
    -- signrob, brickgas)
}
```

### Tool Wear

Tools degrade as they're used: the tool a player actually used to commit a crime loses durability and eventually breaks. Durability is the **default** method; an optional flat break-chance can be enabled as well. Per-crime amounts live in each crime file as `ToolDrain` (durability lost per success) and `ToolBreakChance` (% chance to break per success).

```lua
ToolWear = {
    Durability = {
        Enable         = true,  -- Drain the used tool's durability on a successful crime (the default method).
        Max            = 100,   -- Durability a fresh tool (no metadata yet) is treated as starting at.
        NotifyOnLow    = true,  -- Warn the player when a tool drops to/below LowThreshold.
        LowThreshold   = 20,    -- The "getting low" warning fires at or below this value.
        IncludeWeapons = true,  -- Also wear/break WEAPON_* tools (WEAPON_HATCHET, etc.). false = leave weapons alone.
    },
    BreakChance = {
        Enable = false,         -- Optional: flat % chance (per crime's ToolBreakChance) to break the tool outright on success.
    },
}
```

| Field | Meaning |
|---|---|
| `Durability.Enable` | Master switch for the durability drain (the default wear method) |
| `Durability.Max` | Value a tool with no durability metadata is treated as starting at |
| `Durability.NotifyOnLow` / `LowThreshold` | Warn the player when a tool's durability hits or drops below the threshold |
| `Durability.IncludeWeapons` | Whether vanilla `WEAPON_*` tools also wear/break |
| `BreakChance.Enable` | Optional alternative: a flat per-success % (each crime's `ToolBreakChance`) to break the tool instantly, independent of durability |

::: info Inventory support
Durability uses per-slot metadata, so it works on `ox` / `qb` / `qs` / `origen` / `codem` / `tgiann` / `jaksam`. On inventories without per-slot metadata, durability is skipped automatically but break-chance still works.
:::

### Personal Cooldowns

A **per-player** anti-spam cooldown that sits on top of each crime's per-target cooldown, so one player can't repeat the same crime back-to-back no matter which target they pick. Keyed by player identifier (reconnecting doesn't reset it; it clears on resource restart). `Time` is in **seconds**; a player who retries too soon is told how long is left (minutes, or seconds when under a minute).

```lua
PersonalCooldowns = {
    -- Destructive / dangerous crimes -- ON by default.
    catalytic    = { Enable = true,  Time = 180 }, -- 3 min
    brakecut     = { Enable = true,  Time = 240 }, -- 4 min
    speedbomb    = { Enable = true,  Time = 300 }, -- 5 min
    -- ...tiretheft, wheelloose, fuelsabotage, brickgas...

    -- Pettier crimes -- wired but OFF by default (flip Enable to use).
    shoplift     = { Enable = false, Time = 120 },
    mailbox      = { Enable = false, Time = 120 },
    -- ...acstrip, cardoor, tireslash, parkingmeter, payphone, newsrack,
    --    vending, parceltheft, smashgrab, signrob, robaped, pickpocket...
}
```

| Field | Meaning |
|---|---|
| `Enable` | Whether this crime has a personal cooldown at all |
| `Time` | Seconds before the same player can attempt that crime again |

::: tip
Destructive crimes (catalytic, brake cutting, the speed bomb, wheel/tyre theft, fuel sabotage, brick-on-the-gas) ship **on**; the pettier ones ship **off** but pre-filled, so enabling one is a single-word flip. `atmskimmer` has none by design. This replaced the old per-config `Cooldown` block that pickpocket and armed robbery used to carry.
:::

## Per-Crime Config Anatomy

All crime configs share a common shape. Below is the **prop-crime** layout (mailbox, payphone, parking meter, news rack, vending, shoplift) - the others add a few fields on top, covered after.

```lua
return {
    Enable = true,                 -- Master on/off switch. false = fully disables this crime
                                   -- (no targets, no events). Takes effect on resource restart.
    Cooldown = 2,                  -- Minutes before the same target is robbable again.
    Items = { 'WEAPON_HAMMER' },   -- Tools - ANY ONE is enough. (see installation tool mapping)
    ShowTargetWithoutItem = false, -- Show the ox_target option even without a required tool.
                                   -- false = only show when you carry one. The action still
                                   -- needs the tool (the server enforces it).
    Time = 15,                     -- Progress-bar duration in seconds.
    BaseXP = 15,                   -- XP for a successful attempt.
    GiveXPForItems = true,         -- Add each rolled item's own xp on top of BaseXP.
    Models = {                     -- World props the target option attaches to.
        'prop_letterbox_01', 'prop_letterbox_02', 'prop_letterbox_03', 'prop_letterbox_04',
    },
    Logging = true,                -- Write success/items/cash to the history ledger.

    Minigame  = { ... },           -- Skill check (see Minigames below).
    PoliceAlert = { ... },         -- Dispatch hook (see Police Alerts below).
    Rewards   = { ... },           -- Weighted loot, keyed by player level (see below).
}
```

::: tip Enabling / disabling a crime
`Enable` is the first field in **every** crime config. Set it to `false` and that crime disables itself completely on the next resource restart - it registers no targets, threads, events or callbacks on either the client or server side - which is handy when another resource already handles that activity (e.g. you run a dedicated parking-meter script). It defaults to `true`, so leaving it alone changes nothing.
:::

### Crime Flow

Every crime now runs in the same order, and the **action animation plays continuously** the whole time (it's no longer tied to the progress bar):

1. **Animation starts** (saw, prying, kneeling, etc.).
2. **Minigame** runs - the animation keeps playing during it. Fail/cancel -> the animation stops and nothing is awarded.
3. **Progress bar** runs - same animation continues. The player can press **X** to cancel it (when `AllowCancel = true`).
4. **Rewards** are granted only **after** the progress bar completes.

::: tip Under-vehicle crimes
Catalytic converter, fuel-tank sabotage, and the speed bomb are the exception: there the **minigame runs first** (on your feet), then you slide under the vehicle for the animation + progress bar. Everything else animates through the minigame as above.
:::

### Rewards & Weighted Chance

Reward tables are keyed by player level (`[1]`, `[2]`, `[3]`). Each level bucket holds its **own** `lootCount` (how many distinct items that level hands out) and an `items` pool. Each row's `chance` is a **weight**, not a percentage - think of it as the number of raffle tickets in the hat.

```lua
Rewards = {
    [1] = { -- Level 1
        lootCount = { min = 1, max = 1 }, -- distinct items rolled at this level
        items = {
            { item = "cash",       chance = 15, min = 3, max = 8, xp = 0 },
            { item = "metalscrap", chance = 25, min = 1, max = 2, xp = 2 },
        },
    },
    [2] = { lootCount = { min = 1, max = 2 }, items = { ... } }, -- richer pool, unlocked at level 2
    [3] = { lootCount = { min = 2, max = 3 }, items = { ... } },
}
```

| Field | Meaning |
|---|---|
| `lootCount` | How many **distinct** items this level hands out (`{ min, max }` range, rolled per success). **Per-level** - replaces the old single `RewardPicks` |
| `items` | The weighted pool for this level |
| `item` | Inventory item name (`cash` pays out money) |
| `chance` | Relative weight - higher = more likely within its level bucket |
| `min` / `max` | Quantity range of that item when it's picked |
| `xp` | Bonus XP if this item is rolled (added when `GiveXPForItems = true`) |
| `guaranteed` | `true` = this row is **always** granted (its `chance` is ignored). It fills one of the level's `lootCount` slots; the remaining slots roll normally from the other rows. See the tip below |

::: warning Changed in this version
The old top-level `RewardPicks` is gone. Each level bucket now carries its own `lootCount`, so you can give higher levels more items per success. Buckets are wrapped as `[N] = { lootCount = {...}, items = { ...rows } }` rather than a flat array of rows.
:::

::: tip Guaranteed drops
Add `guaranteed = true` to any reward row to make that item **always** drop, ignoring its `chance`. It still counts as one of the level's `lootCount` picks, so the remaining slots roll from the other (non-guaranteed) rows as usual; if a level has more guaranteed rows than its `lootCount`, every guaranteed row is still granted.

```lua
items = {
    { item = 'catalytic_converter', chance = 60, min = 1, max = 1, xp = 8, guaranteed = true }, -- always dropped
    { item = 'oxygen_sensor',       chance = 18, min = 1, max = 1, xp = 12 },                   -- rolls for remaining slots
    { item = 'platinum_chunk',      chance = 8,  min = 1, max = 1, xp = 20 },
},
```

Catalytic converter theft uses this so you always walk away with a `catalytic_converter` while bonus parts still roll on top. The flag is supported in **every** reward table that runs through the shared rewards roller, including the openable-package loot grids (mailbox / parcel), so it works for any crime.
:::

### Openable Packages

Parcel theft (`porch_package`) and mailbox break-ins (`mail_package`) each hand out an **openable** item, configured **per crime** in a `Package` block inside that crime's file (`configs/parceltheft.lua` / `configs/mailbox.lua`). There is no shared `config.lua` package anymore, and each crime rolls its own loot.

```lua
Package = {
    Item      = 'porch_package',      -- The openable item this crime gives.
    LootCount = { min = 1, max = 3 }, -- Distinct items rolled into the grid per open.
    Rewards = {                       -- Flat weighted pool (chance = relative weight).
        { item = 'laptop', chance = 20, min = 1, max = 1 },
        { item = 'rolex',  chance = 18, min = 1, max = 1 },
        -- ...
    },

    -- Booby trap: a chance the package is rigged. On a trapped open the player
    -- gets no loot - instead a reaction fires. Each element is independently toggleable.
    Trap = {
        Enable   = true,
        Chance   = 20,   -- % chance (0-100) an opened package is trapped.
        Particle = true, -- firework/glitter burst on the player.
        Ragdoll  = true, -- briefly knock the player down.
        Sound    = true, -- audible (invisible) explosion bang.
        Damage   = true, -- if true the explosion hurts + flings (real blast); false = harmless bang only.
    },

    -- Carry animation while holding this package. Enable = false to skip the forced carry.
    Carry = {
        Enable   = true,
        Prop     = 'hei_prop_heist_box', -- prop attached while carrying.
        Controls = { 21, 22, 23, 24, 25, 36, 47, 58, 140, 141, 142, 143, 257, 263, 264 }, -- optional; omit for the default set.
    },
}
```

**Using** the item opens an **interactive 3x3 loot grid**: the player reveals cells one at a time and grabs items individually (each grab is granted immediately and validated server-side); anything left when the grid closes is forfeited. The crime that *gives* the package (the pickup/rob) awards its own XP via the normal level `Rewards` table - `porch_package`/`mail_package` are simply one of those rewards.

| Block | Purpose |
|---|---|
| `Item` / `LootCount` / `Rewards` | The openable item and the flat pool the 3x3 grid rolls from |
| `Trap` | Per-package booby-trap chance and which reactions fire (particle / ragdoll / sound / damage) |
| `Carry` | The carry animation + prop while the package is in the inventory; per-package opt-in |

### Person Crimes (pickpocket, armed robbery)

Pickpocketing and armed ped robbery roll loot by **map zone tier** instead of a flat per-level table:

```lua
Chance = 80, -- Overall % the target has anything on them. Personal anti-spam
             -- cooldowns for these (and every crime) are set globally in
             -- config.lua's PersonalCooldowns -- see Personal Cooldowns above.

Tiers = {
    low = {
        cash = { min = 8, max = 25 },
        [1] = { lootCount = { min = 1, max = 1 }, items = { ... } }, -- per-level count + pool
        [2] = { lootCount = { min = 1, max = 1 }, items = { ... } },
        [3] = { lootCount = { min = 1, max = 1 }, items = { ... } },
    },
    medium = { cash = { min = 20, max = 50 }, [1] = { lootCount = {...}, items = {...} }, ... },
    high   = { cash = { min = 40, max = 100 }, ... },
},
ZoneTiers = {
    high   = { 'AIRP', 'PBOX', 'DOWNT', ... }, -- GetNameOfZone() short codes
    medium = { 'CHIL', 'ROCKF', 'BEACH', ... },
    -- anything not listed falls through to the `low` tier
},
```

Just like the per-level reward tables, each tier's `[1]`/`[2]`/`[3]` bucket carries its own `lootCount` and `items` pool.

::: tip Pickpocket extras
The pickpocket minigame has its own knobs in its `Minigame.Start` - grab-zone width scales on item rarity (`grabZoneDeg`), you can add empty decoy slots (`emptySlots`), and toggle the per-grab speed-up (`speedUp`). See the [Minigames](./minigames#pickpocket) page.
:::

Armed robbery (`robaped.lua`) adds a few control fields:

| Field | Default | Purpose |
|---|---|---|
| `RunawayChance` | `10` | Per-second % a held-up ped breaks free if you stop aiming |
| `Key` | `38` | Control input that commits the rob (38 = `E`) |
| `IgnoreWeapons` | table | Weapons/groups that won't trigger the hold-up (unarmed, fire extinguisher, ...) |
| `IgnoreModels` | table | Ped models the option won't attach to (cops, medics, gang bosses, military) |

### Vehicle Crimes

Vehicle crimes (catalytic, tiretheft, wheelloose, tireslash, brakecut, fuelsabotage, brickgas, smashgrab) follow the same skeleton with a few extras:

| Field | Purpose |
|---|---|
| `Cooldown` | Per-plate or per-coords cooldown (minutes) before the same target can be hit again |
| `IgnoreClasses` | Vehicle classes the option refuses (bikes, boats, aircraft, emergency) |
| `Locations` / `VehicleModels` | For spawn-based crimes (e.g. smash & grab parks cars at fixed points) |
| Multi-stage times | Some crimes have a scope/setup stage and a commit stage with separate durations |

Catalytic converter theft (`catalytic.lua`) adds two extras of its own:

```lua
-- Where along the car the under-vehicle saw pose sits: 0 = middle, 1 = front
-- bumper. Converters sit forward near the engine, so the thief lies toward the
-- front. 0.45 lands roughly under the front footwell.
UnderVehicleForwardBias = 0.45,

-- What a stolen converter leaves the victim's car with. The first person to
-- drive it is warned (engine light, loud exhaust, the smell), and the engine is
-- left damaged so it runs a little rough until repaired.
VictimEffect = {
    Enable              = true,
    EngineDamagePercent = 20, -- Caps the engine to (100 - this)% health on theft. 0 = no damage.
},
```

| Field | Purpose |
|---|---|
| `UnderVehicleForwardBias` | `0`-`1` position along the car for the slide-under pose (`0` = middle, `1` = front bumper). Converters sit forward, so the default `0.45` puts the thief near the engine |
| `VictimEffect.Enable` | Master toggle for the post-theft consequences on the victim's car |
| `VictimEffect.EngineDamagePercent` | Caps the victim car's engine health to `(100 - this)%` on a successful theft (`20` = engine left at 80%, so it runs a little rough). The first person to drive it is also notified the converter was stolen. `0` disables the engine damage |

ATM skimming (`atmskimmer.lua`) is a multi-step, USB-based crime - install a skimmer, insert a USB stick to capture cards over time, then withdraw the loaded USB:

```lua
MaxPerPlayer = 5,                  -- Max simultaneously-installed skimmers per character.
InstallItem  = 'skimmer',          -- Consumed at install; returned (with durability) on manual detach.
UsbItem      = 'atm_skimmer_usb',  -- USB stick; blank vs loaded is told apart by metadata.
InstallTime   = 3,                 -- Seconds for the install progress bar.
InsertUsbTime = 2,                 -- Insert-USB bar.
WithdrawTime  = 3,                 -- Withdraw-USB bar.
DetachTime    = 3,                 -- Detach-skimmer bar.
```

Parcel theft (`parceltheft.lua`) defines porch spawn `Locations` - append a row and it's picked up on next restart:

```lua
{ coords = vector3(123.45, 678.90, 12.34), heading = 90.0, distance = 25.0, prop = 'hei_prop_heist_box' },
```

## Minigames

::: tip
For the complete reference - every minigame's parameters with defaults, how to swap them per crime, and using external minigame resources - see the dedicated [Minigames](./minigames) page.
:::

Every crime runs a skill-check as part of the [crime flow](#crime-flow) - the animation starts, the minigame runs (animation playing), then the progress bar, then rewards. The minigame lives in a `Minigame` block in the crime's config, and built-ins are called via the global **`Minigames.<name>`**:

```lua
Minigame = {
    Enable = true,           -- false = skip the minigame (auto-success).
    Start = function()
        -- Calls a built-in minigame and returns its pass/fail boolean.
        return Minigames.mash({
            fillPerTap   = 0.08, -- bar gained per E tap (0..1)
            decayPerSec  = 0.4,  -- bar lost per second (0..1)
            timeLimitSec = 6,    -- seconds to fill it; 0 = no limit
        }).success
    end,
}
```

`Start` can be **any function that returns `true`/`false`** - swap the built-in for a different one, change its tuning, or drop in `ps-ui` / `lib.skillCheck` / your own NUI minigame without touching the crime's code.

### Built-In Library

Call any of these via `Minigames.<name>({ ...params })`:

| Minigame | What it is | Key params |
|---|---|---|
| `pickpocket` | Moving marker over item "safe zones"; grab each | `grabZoneDeg` (rarity-scaled), `emptySlots`, `rotationSpeedDegSec`, `speedUp`, `speedUpMultiplier`, `mysteryChance`, `timeLimitSec` |
| `lockpick` | Rotating ring; press as the orb crosses each node | `nodeCount`, `hitWindowDeg`, `rotationSpeedDegSec`, `speedUpMultiplier`, `timeLimitSec` |
| `lockpickbar` | Bar variant of lockpick | same as `lockpick` |
| `holdsteady` | Hold E to keep a marker inside a drifting band | `bandSize`, `holdDurationSec`, `gravity`, `thrust`, `timeLimitSec` |
| `mash` | Mash E to fill a bar before it decays | `fillPerTap`, `decayPerSec`, `timeLimitSec` |
| `stealth` | Press E only while the NPC looks away | `steps`, `safeDurationSec`, `watchDurationSec`, `jitterSec`, `timeLimitSec` |
| `dial` | Press E at each notch of a sweeping pointer | `notches`, `hitWindowDeg`, `rotationSpeedDegSec`, `timeLimitSec` |
| `wires` | Cut the correct coloured wire(s) | `wireCount`, `cutsNeeded`, `timeLimitSec` |
| `sequence` | Growing Simon - repeat the lengthening pattern | `padCount`, `startLength`, `maxLength`, `growBy`, `timeLimitSec` |
| `reaction` | Hit key prompts in a row, window tightening | `rounds`, `startWindowSec`, `windowShrink` |
| `rhythm` | Hit falling notes on the hit line (A S D F) | `lanes`, `noteCount`, `fallSec`, `maxMisses`, `hitWindow` |
| `tracking` | Keep the cursor on a wandering target | `catchRadius`, `holdDurationSec`, `targetSpeed`, `timeLimitSec` |
| `tumbler` | Set each pin as its marker crosses the sweet spot | `pins`, `bandSize`, `speedSec`, `timeLimitSec` |
| `trace` | Trace a path without straying off it | `tolerance`, `segments`, `wiggle`, `timeLimitSec` |
| `code` | Type the shown code in time | `length`, `timeLimitSec` |
| `safedial` | Rotate a safe dial onto each mark in sequence | `numbers`, `steps`, `toleranceDeg`, `timeLimitSec` |
| `tuning` | Drag sliders onto their target marks | `sliders`, `tolerance`, `timeLimitSec` |
| `spot` | Find the matching icon in a grid | `gridCount`, `rounds`, `timeLimitSec` |
| `whack` | Click targets before they expire | `hits`, `maxMisses`, `targetLifeSec`, `spawnEverySec` |
| `gauge` | Hold to fill, release inside the green band | `rounds`, `bandSize`, `fillSpeed`, `timeLimitSec` |
| `pipes` | Rotate pipe tiles to connect the flow | `cols`, `rows`, `timeLimitSec` |

::: tip Test any minigame
With the `command.pettycrime_admin` ACE, run `/testminigame <name>` to preview any minigame, `/testminigame all` to cycle through every one, or `/testminigame` with no argument to list them.
:::

## Police Alerts

Every crime has a `PoliceAlert` block. By default `Send` routes through this resource's dispatch bridge (`bridge/client/alert.lua`) via the global **`Alert.send`**, which auto-detects your installed dispatch system and maps one generic payload onto it - no configuration needed. Swap the `Send` body for a direct call to your own dispatch whenever you like.

```lua
PoliceAlert = {
    Enable = true,
    Chance = 25, -- 0-100 chance an alert fires on success.
    Send = function()
        -- Routes through bridge/client/alert.lua, which auto-detects your
        -- dispatch system. Replace with your own dispatch call if you prefer.
        Alert.send({
            displayCode = '10-15',                  -- radio / dispatch code
            title       = 'Mail Theft',             -- alert title
            message     = 'Mailbox tampering reported',
            description = 'Mailbox tampering reported',
            blipText    = '911 - Mail Theft',       -- map blip label
            sprite      = 431,                      -- blip sprite
            colour      = 3,                        -- blip colour
            scale       = 1.2,                      -- blip scale
        })
    end,
}
```

`Alert.send` probes, in order, `linden_outlawalert`, `cd_dispatch`, `fd_dispatch`, `ps-dispatch`, `qs-dispatch`, `core_dispatch`, `origen_police`, `codem-dispatch` and `tk_dispatch`, maps the payload to whichever is installed (auto-filling the player's coords, nearest street and gender), and no-ops gracefully if none is found.

| Field | Meaning |
|---|---|
| `Enable` | Whether this crime can fire a police alert at all |
| `Chance` | `0`-`100` chance an alert fires on a successful crime |
| `Send` | Builds the alert payload. Routes through `Alert.send` by default; replace it with your own dispatch call freely |

## Localisation

`locales/en.json` ships by default. To add a language:

1. Copy `locales/en.json` to `locales/<code>.json` (e.g. `de.json`).
2. Translate the values, keep the keys.
3. Set `Locale = '<code>'` in `configs/config.lua`.

Missing keys fall back to the raw key name in the UI, so untranslated entries are immediately visible.

## Admin Panel

Players with the `command.pettycrime_admin` ACE can run `/pettycrimeadmin` (alias `/pcadmin`) to open the React NUI admin panel.

| Tab | What it does |
|---|---|
| **Players** | Paged, searchable list of every record. Inspect per-crime XP/level/attempts/cash/items; adjust XP inline; reset a single crime or wipe a record |
| **History** | Append-only ledger of every shop buy/sell, crime success (one row per item awarded), and admin override |
| **Configuration** | Every value in `configs/*.lua` as an editable field (simple mode) or the raw Lua itself (code mode). Save persists an override; reset reverts to the file default |

### How overrides work

Saved edits live in `sd_pettycrime_admin` and are applied to the live config tables **in place** - at boot (before the crime modules load) and again the instant you Save, so the server and connected clients pick up the change. Reset removes the override and restores the file default.

The Configuration tab saves in one of two ways:

- **Simple mode** records each field you change as a **per-field overlay** - only the exact values you touched.
- **Code mode** records your edited Lua as a **full-source override** - a snapshot of the whole file.

#### New options survive updates

Overrides are layered on top of the **shipped config file**, so options added in a future update reach your server even when you've customised that file - no resetting or hand-merging required:

- **Simple-mode (overlay) edits** re-read the current file on every start and only re-apply the fields you changed, so any newly-shipped option is already there.
- **Code-mode (full-source) overrides** are a snapshot and would normally miss new options, so the resource **forward-merges** them: any top-level key the shipped file has that your saved override lacks is added automatically (your own values always win). In the code editor the new option appears in its original position with its comment, and saving folds it into your override for good.

::: tip
The one thing the merge can't do is re-change a value you already overrode - that stays yours by design. So new options arrive automatically while your customisations are never clobbered.
:::

Grant the ACE in `server.cfg`:

```cfg
add_ace group.admin command.pettycrime_admin allow
```

## Full Config Files

Prefer reading the raw files? Every config is mirrored under [Full Config Files](./full-config) - the global `config.lua` plus one page per crime.
