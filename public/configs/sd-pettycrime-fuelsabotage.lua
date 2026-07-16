return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run during the puncture stage. Enable = false to skip
    -- it. Swap `gauge` for any other minigame.* (see client/minigame.lua) or your
    -- own function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.gauge({
                rounds            = 3,    -- hold-and-release rounds to win
                bandSize          = 0.16, -- green band size (fraction of gauge)
                fillSpeed         = 0.55, -- fill rate while held (per sec)
                speedUpMultiplier = 1.0,  -- fill-rate speed-up per round; 1.0 = constant
                timeLimitSec      = 10,   -- seconds before caught; 0 = no limit
            }).success
        end,
    },

    Cooldown = 25, -- Per-plate cooldown (minutes) before the same tank can be re-punctured.
    Items = { 'cutter' }, -- Sharp tool (any one is enough) to puncture the tank.

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful tank puncture.
    --
    -- ToolDrain is the DEFAULT method (durability): the used tool loses this many
    -- points each success and breaks once it hits 0. Active while
    -- ToolWear.Durability.Enable is on (the default).
    ToolDrain = 8,

    -- ToolBreakChance is the OPTIONAL alternative (random break): a flat % chance
    -- to break the used tool outright on a success, independent of durability.
    -- Active only while ToolWear.BreakChance.Enable is on (off by default).
    ToolBreakChance = 10,

    ShowTargetWithoutItem = false, -- Show the target even without a required tool (false = only show when you have one). The action still requires the tool.
    CheckTime = 4, -- Stage 1 — seconds spent kneeling to scope the underside.
    Time = 15, -- Stage 2 — seconds under the chassis punching the tank.
    BaseXP = 25, -- Base XP awarded for a successful tank puncture.
    Logging = true, -- Enables lib.logger usage for this action.

    -- Fuel tank health to set on successful sabotage. Range 0.0–1000.0
    -- (default vanilla tank health is 1000). GTA V renders a visible
    -- fuel trail behind the vehicle as it drives whenever this value is
    -- in the *open* range (0, 650) — anything below 650 triggers the
    -- leak visual, but EXACTLY 0 suppresses it (engine treats the tank
    -- as destroyed, "nothing to leak").
    --
    -- DANGER ZONE: values below ~100 make the vehicle intermittently
    -- inoperable — engine may stall, tank may catch fire from its own
    -- leak under a tiny bump, vehicle may explode on minor collisions.
    -- Stick to 100+ unless you want maximum chaos.
    --
    -- Recommended values:
    --     500 — light damage, slow leak, hard to spot at first
    --     200 — moderate leak, clear trail visible, safe default ← here
    --     100 — heavy leak, vehicle fragile but still drivable
    --    <100 — risky; expect occasional self-destruction from the leak
    --       0 — NO visible leak (tank "destroyed"); avoid unless you
    --           specifically want the no-trail behaviour
    FuelTankHealth = 200.0,

    -- How much fuel (0–100 scale, matches every common fuel resource) to
    -- drain per leak tick while the driver is in a sabotaged vehicle.
    -- The visible trail is from petrol tank damage; this number is what
    -- actually moves the gauge down via the fuel-resource bridge.
    --   0.1 — barely-noticeable trickle (full tank lasts ~17 min of driving)
    --   0.3 — moderate leak (full tank lasts ~5–6 min of driving) — default
    --   1.0 — aggressive leak (full tank lasts ~100 seconds of driving)
    LeakRatePerTick = 0.3,

    -- Tick frequency (ms) for the leak loop. Lower = smoother drain but
    -- higher CPU. 1000 ms is plenty for "gauge moves visibly while you
    -- drive" without being wasteful.
    LeakTickMs = 1000,

    -- Re-apply SetVehiclePetrolTankHealth every leak tick. Many fuel
    -- resources poll-and-restore tank health to 1000 each frame to keep
    -- "their" tank in shape, which would clear the leak after one frame.
    -- Re-applying our low value each tick wins that race and keeps the
    -- visible trail alive. Disable only if you've confirmed your fuel
    -- resource doesn't touch petrol tank health.
    ForceTankHealthEveryTick = true,

    -- Vehicle classes the target option will refuse to attach to. Same
    -- exclusions as catalytic — only road-vehicle tanks make sense.
    IgnoreClasses = {
        [13] = true, -- Cycles
        [14] = true, -- Boats
        [15] = true, -- Helicopters
        [16] = true, -- Planes
        [17] = true, -- Service (taxi, bus, ambulance)
        [18] = true, -- Emergency (police, fire)
        [19] = true, -- Military
        [21] = true, -- Trains
        [22] = true, -- Open Wheel (F1)
    },

    -- Pre-hashed model exemption list.
    IgnoreModels = {
        -- ['emperor'] = true,
    },

    PoliceAlert = {
        Enable = true,
        Chance = 35, -- Visible fuel trail = somebody calls it in.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21F',
                title       = 'Fuel Tank Sabotage',
                message     = 'Vehicle fuel leak reported',
                description = 'Vehicle fuel leak reported',
                blipText    = '911 - Fuel Sabotage',
                sprite      = 380,
                colour      = 1,
                scale       = 1.2,
            })
        end,
    },
}
