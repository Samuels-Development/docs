return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run before the slash (after the server pre-flight
    -- passes). Enable = false to skip it. Swap `trace` for any other minigame.*
    -- (see client/minigame.lua) or your own function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.trace({
                tolerance    = 22, -- corridor half-width (px); smaller = harder
                segments     = 6,  -- path segments; more = twistier
                wiggle       = 45, -- path wiggle amplitude (px)
                timeLimitSec = 10, -- seconds before caught; 0 = no limit
            }).success
        end,
    },

    Items = { 'cutter' }, -- Sharp tool (any one is enough) to slash the tyre.

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful tyre slash.
    --
    -- ToolDrain is the DEFAULT method (durability): the used tool loses this many
    -- points each success and breaks once it hits 0. Active while
    -- ToolWear.Durability.Enable is on (the default).
    ToolDrain = 5,

    -- ToolBreakChance is the OPTIONAL alternative (random break): a flat % chance
    -- to break the used tool outright on a success, independent of durability.
    -- Active only while ToolWear.BreakChance.Enable is on (off by default).
    ToolBreakChance = 8,

    ShowTargetWithoutItem = false, -- Show the target even without a required tool (false = only show when you have one). The action still requires the tool.

    -- When true, the target option only appears while the knife is the
    -- player's currently active (drawn) weapon. When false, the option
    -- appears as long as the knife is anywhere in inventory.
    --
    -- Set this true for a more "you have to actually have the knife in
    -- hand" feel; leave it false for less friction (target shows up,
    -- player slashes without thinking about which weapon is drawn).
    RequireEquipped = false,

    BaseXP = 6, -- Base XP per individual tyre slashed.
    Logging = true, -- Enables lib.logger usage for this action.

    -- Vehicle classes the target option will refuse to attach to. Same
    -- exclusions as catalytic/tiretheft plus motorcycles — bikes don't
    -- have the kind of rubber tyres the burst native is designed for.
    IgnoreClasses = {
        [8]  = true, -- Motorcycles
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

    -- Pre-hashed model exemption list — civilian models you don't want eligible.
    IgnoreModels = {
        -- ['emperor'] = true,
    },

    PoliceAlert = {
        Enable = true,
        Chance = 15, -- Per-tyre roll. Quieter than smash-and-grab; mostly the visible damage tips someone off.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21V',
                title       = 'Vehicle Vandalism',
                message     = 'Vehicle vandalism reported',
                description = 'Vehicle vandalism reported',
                blipText    = '911 - Tyre Slashing',
                sprite      = 380,
                colour      = 1,
                scale       = 1.1,
            })
        end,
    },
}
