# Minigames

Petty Crimes ships a **built-in library of 21 skill-check minigames**. Every crime runs one as part of its action, and you can swap it, retune it, disable it, or replace it with an entirely external minigame - all from the crime's config file. **No external minigame resource is required**, but you can use one if you prefer.

## Where the minigame sits in a crime

Crimes run in a fixed order, and the **action animation plays continuously** through the whole thing (it is no longer attached to the progress bar):

1. **Animation starts** (saw, prying, kneeling, ...).
2. **Minigame** runs - the animation keeps playing during it. Fail/cancel -> the animation stops and nothing is awarded.
3. **Progress bar** runs - same animation continues; the player can press **X** to cancel it (when `Config.AllowCancel` is true).
4. **Rewards** are granted only **after** the progress bar completes.

::: tip Under-vehicle crimes
Catalytic converter, fuel-tank sabotage, and the speed bomb are the exception: the **minigame runs first** (on your feet), then the player slides under the vehicle for the animation + progress bar.
:::

## How It Works

Each crime config has a `Minigame` block. Built-ins are called via the global **`Minigames`** table:

```lua
Minigame = {
    Enable = true,                       -- false = skip the minigame (auto-success).
    Start = function()
        -- Runs a built-in minigame and returns its pass/fail boolean.
        return Minigames.lockpick({
            nodeCount    = 5,
            hitWindowDeg = 32,
        }).success
    end,
}
```

- **`Enable`** - set `false` to skip the skill check entirely (the crime auto-succeeds the skill step).
- **`Start`** - a function that returns `true` (passed) or `false` (failed/caught). This is the only contract. It can call a built-in minigame, an external resource, or your own logic.

Every built-in is called as `Minigames.<name>(params)` and returns a result table:

```lua
{
    success = true,   -- did the player win?
    caught  = false,  -- did they fail/get caught (e.g. ran out of time)?
    data    = { },    -- game-specific payload (pickpocket reports looted slots here)
}
```

Crimes use `.success`, so almost every `Start` ends in `).success`.

::: warning Wrapper names are camelCase
Three wrappers are camelCase: `lockpickBar`, `holdSteady`, and `safeDial`. The rest are lowercase. Calling the wrong case is a runtime error.
:::

## Changing a Crime's Minigame

Open `configs/<crime>.lua`, find the `Minigame` block, and edit the `Start` function - change the wrapper name and/or its params.

**Example** - swap mailbox from `mash` to a `lockpick` ring:

```lua
-- configs/mailbox.lua  (before)
Start = function()
    return Minigames.mash({
        fillPerTap   = 0.08,
        decayPerSec  = 0.4,
        timeLimitSec = 6,
    }).success
end,
```

```lua
-- configs/mailbox.lua  (after)
Start = function()
    return Minigames.lockpick({
        nodeCount    = 6,
        hitWindowDeg = 28,
        timeLimitSec = 12,
    }).success
end,
```

To **disable** a crime's minigame, set `Enable = false`.

::: tip Pickpocket is special
The pickpocket minigame is the only one that carries loot. Its `Start` receives the rolled items (`ctx.items`) and returns the **full result** so partial loot resolves per slot. Keep `pickpocket` for that crime unless you understand that other minigames are pass/fail (all-or-nothing loot). See its entry below.
:::

## Default Minigame per Crime

| Crime | Config file | Default minigame |
|---|---|---|
| Mailbox | `mailbox.lua` | `mash` |
| Payphone | `payphone.lua` | `sequence` |
| Parking meter | `parkingmeter.lua` | `wires` |
| News rack | `newsrack.lua` | `dial` |
| Vending machine | `vending.lua` | `holdSteady` |
| Shoplifting | `shoplift.lua` | `stealth` |
| Pickpocketing | `pickpocket.lua` | `pickpocket` |
| Armed ped robbery | `robaped.lua` | `reaction` |
| Parcel theft | `parceltheft.lua` | `spot` |
| Smash & grab | `smashgrab.lua` | `whack` |
| Catalytic converter | `catalytic.lua` | `tracking` |
| AC unit strip | `acstrip.lua` | `lockpick` |
| Street sign theft | `signrob.lua` | `pipes` |
| Wheel theft | `tiretheft.lua` | `tumbler` |
| Wheel loosening | `wheelloose.lua` | `safeDial` |
| Tyre slashing | `tireslash.lua` | `trace` |
| Brake-line cutting | `brakecut.lua` | `lockpickBar` |
| Fuel-tank sabotage | `fuelsabotage.lua` | `gauge` |
| Brick on the gas | `brickgas.lua` | `rhythm` |
| Car door theft | `cardoor.lua` | `tracking` |
| Speed bomb | `speedbomb.lua` | `pipes` |
| ATM skimming | `atmskimmer.lua` | `code` |

## Available Minigames

Every minigame supports an optional `timeLimitSec` where noted - running out of time counts as **caught**. Each block below shows the wrapper call with **every parameter and its default**, so you can copy it straight into a `Start` function and tune from there.

### `pickpocket`

A marker sweeps a bottom bar lined with "safe zones," one per slot. Press to grab while the marker is inside a zone. **This is the loot minigame** - `items` is supplied by the crime, not hand-set, and how many real items appear (plus their rarity) comes from the crime's tier/level `lootCount` + `items` pool.

```lua
Minigames.pickpocket({
    -- items           = ctx.items,    -- supplied by the crime; do not hardcode
    grabZoneDeg         = { min = 12, max = 34 }, -- grab-zone width scaled by rarity: the rarest rolled
                                                  -- item gets `min` (hardest), the most common gets `max`.
                                                  -- A plain number gives every zone the same width.
    emptySlots          = { min = 1, max = 3 },   -- extra empty "???" decoy slots shuffled in; grabbing one
                                                  -- gives nothing (time-sink). { min = 0, max = 0 } disables.
    rotationSpeedDegSec = 180,  -- starting marker speed (deg/sec); 360 = one full pass
    speedUp             = true, -- speed up (and flip) after each grab; false = constant speed
    speedUpMultiplier   = 1.35, -- speed multiplier per grab (only used when speedUp = true)
    timeLimitSec        = 15,   -- seconds before caught; 0 = no limit
    mysteryChance       = 0.5,  -- per-item chance (0..1) a real card starts hidden as "???"
})
```

::: tip How many items?
Pickpocket's slot count is **not** set here. Each tier's `[1]`/`[2]`/`[3]` bucket in `configs/pickpocket.lua` has its own `lootCount = { min, max }` (real items) - `emptySlots` then pads the wheel with decoys.
:::

### `lockpick`

A green orb orbits a ring of dark nodes. Press while the orb is inside an un-opened node to open it; open them all to win. Pressing off a node = caught.

```lua
Minigames.lockpick({
    nodeCount           = 5,    -- target nodes around the ring
    hitWindowDeg        = 32,   -- angular tolerance per node (deg); wider = easier
    rotationSpeedDegSec = 150,  -- orb orbit speed (deg/sec)
    speedUpMultiplier   = 1.12, -- speed-up applied after each node opens
    timeLimitSec        = 0,    -- seconds before caught; 0 = no limit
})
```

### `lockpickBar`

The bar-shaped variant of `lockpick` - same rules, same params, laid out as a horizontal track instead of a ring.

```lua
Minigames.lockpickBar({
    nodeCount           = 5,    -- target boxes along the bar
    hitWindowDeg        = 32,   -- hit tolerance per box
    rotationSpeedDegSec = 150,  -- marker sweep speed
    speedUpMultiplier   = 1.12, -- speed-up applied after each box opens
    timeLimitSec        = 0,    -- seconds before caught; 0 = no limit
})
```

### `holdSteady`

Hold the key to thrust a marker upward against gravity and keep it inside a target band long enough.

```lua
Minigames.holdSteady({
    bandSize        = 0.22, -- target band width as a fraction of the track
    holdDurationSec = 2.5,  -- cumulative in-band time required to win
    gravity         = 1.2,  -- downward pull (track-fractions/sec²)
    thrust          = 2.6,  -- upward thrust while held (track-fractions/sec²)
    dwellDrainRate  = 0.6,  -- how fast banked time drains while out of band (x dt)
    timeLimitSec    = 12,   -- seconds before caught; 0 = no limit
})
```

### `mash`

Mash the key to fill a bar before it decays away.

```lua
Minigames.mash({
    fillPerTap   = 0.08, -- bar gained per tap (0..1)
    decayPerSec  = 0.4,  -- bar lost per second (0..1)
    timeLimitSec = 6,    -- seconds to fill it; 0 = no limit
})
```

### `stealth`

The NPC cycles between watching and looking away. Press only during look-away windows.

```lua
Minigames.stealth({
    steps            = 4,    -- successful presses needed to win
    safeDurationSec  = 1.1,  -- base length of a look-away window (sec)
    watchDurationSec = 0.9,  -- base length of a watching window (sec)
    jitterSec        = 0.35, -- random ± applied to each window (sec)
    timeLimitSec     = 8,    -- seconds before caught; 0 = no limit
})
```

### `dial`

A pointer sweeps a notched ring. Press as it crosses each notch, in order.

```lua
Minigames.dial({
    notches             = 4,   -- notches to crack in order
    hitWindowDeg        = 24,  -- angular hit tolerance (deg)
    rotationSpeedDegSec = 170, -- pointer speed (deg/sec)
    speedUpMultiplier   = 1.08,-- speed-up after each notch
    timeLimitSec        = 10,  -- seconds before caught; 0 = no limit
})
```

### `wires`

Cut the correct coloured wire(s) called out by the prompt.

```lua
Minigames.wires({
    wireCount    = 5, -- total wires shown
    cutsNeeded   = 3, -- correct cuts required to win
    timeLimitSec = 8, -- seconds before caught; 0 = no limit
})
```

### `sequence`

A growing "Simon" - watch the pattern, then repeat it. Each round adds pads until it reaches `maxLength`.

```lua
Minigames.sequence({
    padCount     = 4,   -- number of pads
    startLength  = 3,   -- starting sequence length
    maxLength    = 6,   -- completing this length wins
    growBy       = 1,   -- pads added each round
    flashOnMs    = 440, -- how long each pad lights during playback (ms)
    flashGapMs   = 220, -- gap between pad flashes (ms)
    timeLimitSec = 7,   -- per-repeat time limit; 0 = no limit
})
```

### `reaction`

Hit a run of key prompts; the window tightens each round.

```lua
Minigames.reaction({
    rounds         = 5,    -- key prompts to hit in a row
    startWindowSec = 1.2,  -- time allowed for the first prompt (sec)
    windowShrink   = 0.88, -- window multiplier each round (smaller = harder)
})
```

### `rhythm`

Notes fall down lanes (keys A S D F); hit each as it crosses the line.

```lua
Minigames.rhythm({
    lanes     = 4,    -- number of lanes (2-4)
    noteCount = 12,   -- total notes to clear
    fallSec   = 1.6,  -- seconds a note takes to reach the hit line
    maxMisses = 3,    -- misses allowed before caught
    hitWindow = 0.11, -- clean-hit timing window (fraction of the fall)
})
```

### `tracking`

Keep the cursor on a wandering target long enough to fill the focus meter.

```lua
Minigames.tracking({
    catchRadius     = 46,  -- on-target radius (px)
    holdDurationSec = 2.5, -- on-target focus needed to win (sec)
    targetSpeed     = 140, -- target wander speed (px/sec)
    focusDrainRate  = 0.6, -- focus drain while off-target (x dt)
    timeLimitSec    = 12,  -- seconds before caught; 0 = no limit
})
```

### `tumbler`

Set each pin as its marker crosses the sweet-spot band, in order.

```lua
Minigames.tumbler({
    pins              = 5,   -- pins to set in order
    bandSize          = 0.2, -- sweet-spot size as a fraction of a pin track
    speedSec          = 1.0, -- seconds for a marker to cross its track one way
    speedUpMultiplier = 1.0, -- marker speed-up after each pin (1.0 = constant)
    timeLimitSec      = 12,  -- seconds before caught; 0 = no limit
})
```

### `trace`

Move onto the start dot, then trace the path to the end without straying outside the corridor.

```lua
Minigames.trace({
    tolerance    = 22, -- corridor half-width (px); smaller = harder
    segments     = 6,  -- path segments; more = twistier
    wiggle       = 45, -- path wiggle amplitude (px)
    timeLimitSec = 10, -- seconds before caught; 0 = no limit
})
```

### `code`

Type the shown code before time runs out.

```lua
Minigames.code({
    length       = 5, -- characters in the code
    timeLimitSec = 7, -- seconds before caught; 0 = no limit
})
```

### `safeDial`

Rotate a safe dial and set it on each mark in sequence.

```lua
Minigames.safeDial({
    numbers      = 12, -- marks around the dial
    steps        = 3,  -- marks to land in sequence to crack it
    toleranceDeg = 10, -- angular tolerance per mark (deg)
    timeLimitSec = 18, -- seconds before caught; 0 = no limit
})
```

### `tuning`

Drag each slider onto its target mark within tolerance.

```lua
Minigames.tuning({
    sliders      = 4,    -- sliders to set
    tolerance    = 0.05, -- match tolerance as a fraction of a slider's range
    timeLimitSec = 12,   -- seconds before caught; 0 = no limit
})
```

### `spot`

Find and click the icon that matches the target, across several rounds.

```lua
Minigames.spot({
    gridCount    = 12, -- icons shown in the grid
    rounds       = 3,  -- correct picks needed to win
    timeLimitSec = 8,  -- overall time limit; 0 = no limit
})
```

### `whack`

Click targets as they pop up, before they expire.

```lua
Minigames.whack({
    hits          = 8,   -- targets to hit to win
    maxMisses     = 3,   -- expired targets allowed before caught
    targetLifeSec = 1.1, -- seconds each target stays
    spawnEverySec = 0.7, -- seconds between spawns
})
```

### `gauge`

Hold to fill a pressure gauge and release while the fill is inside the green band, across several rounds.

```lua
Minigames.gauge({
    rounds            = 3,    -- hold-and-release rounds to win
    bandSize          = 0.16, -- green band size as a fraction of the gauge
    fillSpeed         = 0.55, -- fill rate while held (per second)
    speedUpMultiplier = 1.0,  -- fill-rate speed-up after each round (1.0 = constant)
    timeLimitSec      = 10,   -- seconds before caught; 0 = no limit
})
```

### `pipes`

Rotate pipe tiles on a grid to connect the flow from source to target.

```lua
Minigames.pipes({
    cols         = 5,  -- grid columns
    rows         = 3,  -- grid rows
    timeLimitSec = 25, -- seconds before caught; 0 = no limit
})
```

## Using External Minigame Resources

Because `Start` only needs to return a boolean, you can drop in **any** minigame resource - `ox_lib`, `ps-ui`, `SN-Hacking`, `rm_minigames`, your own NUI, anything. Just return whatever that resource gives you as `true`/`false`.

::: code-group

```lua [ox_lib skillCheck]
Start = function()
    return lib.skillCheck({ 'easy', 'easy', 'medium' }, { 'w', 'a', 's', 'd' })
end,
```

```lua [ps-ui Circle]
Start = function()
    local p = promise.new()
    exports['ps-ui']:Circle(function(success)
        p:resolve(success)
    end, 3, 5) -- 3 circles, 5s
    return Citizen.Await(p)
end,
```

```lua [Custom logic]
Start = function()
    -- Any boolean-returning logic works - combine checks, roll a chance, etc.
    return exports['my-minigame']:Run() == true
end,
```

:::

You can mix and match per crime - keep the built-ins on some crimes and external minigames on others.

## Testing Minigames

With the `command.pettycrime_admin` ACE you can preview any minigame in-game without committing a crime:

| Command | Effect |
|---|---|
| `/testminigame <name>` | Run a single minigame (e.g. `/testminigame lockpick`) |
| `/testminigame all` | Cycle through every minigame back-to-back |
| `/testminigame` | List all available minigame names |

The result (success / caught / cancelled) is shown as a notification.
