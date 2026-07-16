return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run during the wheel detach. Enable = false to skip
    -- it. Swap `tumbler` for any other minigame.* (see client/minigame.lua) or
    -- your own function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.tumbler({
                pins              = 5,   -- lug nuts to set in order
                bandSize          = 0.2, -- sweet-spot size (fraction of track)
                speedSec          = 1.0, -- marker traverse time (sec)
                speedUpMultiplier = 1.0, -- speed-up after each pin
                timeLimitSec      = 12,  -- seconds before caught; 0 = no limit
            }).success
        end,
    },

    Items = { 'WEAPON_WRENCH' }, -- Leverage tool used to pry the wheel off the hub.

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful wheel theft. WEAPON_* tools in Items only
    -- wear while ToolWear.IncludeWeapons is on (this crime's only tool is a
    -- weapon, so wear is off unless that flag is set).
    --
    -- ToolDrain is the DEFAULT method (durability): the used tool loses this many
    -- points each success and breaks once it hits 0. Active while
    -- ToolWear.Durability.Enable is on (the default).
    ToolDrain = 6,

    -- ToolBreakChance is the OPTIONAL alternative (random break): a flat % chance
    -- to break the used tool outright on a success, independent of durability.
    -- Active only while ToolWear.BreakChance.Enable is on (off by default).
    ToolBreakChance = 10,

    ShowTargetWithoutItem = false, -- Show the target even without a required tool (false = only show when you have one). The action still requires the tool.
    DetachTime = 8, -- Seconds spent crouched at the wheel before it pops off (progress bar duration).
    BaseXP = 22, -- Base XP awarded per wheel detached.
    Logging = true, -- Enables lib.logger usage for this action.

    -- Vehicle classes the target option will refuse to attach to. Same default
    -- shape as catalytic/tireslash plus motorcycles — bike wheels don't detach
    -- through the same mechanism as car wheels, and the animation reads wrong
    -- on a bike-height frame.
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
        Chance = 30, -- Visible damage on a parked car gets noticed at moderate rates.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21W',
                title       = 'Wheel Sabotage',
                message     = 'Wheel sabotage reported',
                description = 'Wheel sabotage reported',
                blipText    = '911 - Wheel Sabotage',
                sprite      = 380,
                colour      = 1,
                scale       = 1.2,
            })
        end,
    },
}
