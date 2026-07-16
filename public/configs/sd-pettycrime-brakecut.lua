return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run during the cut. Enable = false to skip it. Swap
    -- `lockpickBar` for any other minigame.* (see client/minigame.lua) or your
    -- own function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.lockpickBar({
                nodeCount           = 5,    -- target nodes along the bar
                hitWindowDeg        = 32,   -- hit tolerance per node (deg)
                rotationSpeedDegSec = 150,  -- marker sweep speed (deg/sec)
                speedUpMultiplier   = 1.12, -- speed-up applied after each node opens
                timeLimitSec        = 0,    -- seconds before caught; 0 = no limit
            }).success
        end,
    },

    Items = { 'wirecutter', 'cutter' }, -- Wire cutters (any one is enough) to sever the brake line.

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful brake-cut.
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
    CutTime = 6, -- Seconds spent under the hood (progress bar duration).
    BaseXP = 24, -- Base XP awarded for a successful brake-line cut.
    Logging = true, -- Enables lib.logger usage for this action.

    -- Vehicle classes the target option will refuse to attach to. Brake-cut
    -- only makes sense for road vehicles — bikes have cable-actuated brakes
    -- with no engine-bay lines, boats/aircraft don't have car-style brakes,
    -- and emergency/military are skipped to keep the scope to civilian fare.
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

    -- GTA V control IDs to disable while the player is inside a brake-cut
    -- vehicle. 72 (INPUT_VEH_BRAKE) covers S/brake-pedal; 76 (INPUT_VEH_HANDBRAKE)
    -- covers Space/handbrake. Add more if you want to disable downshifts or
    -- other deceleration inputs — see https://docs.fivem.net/docs/game-references/controls/
    DisabledControls = { 72, 76 },

    PoliceAlert = {
        Enable = true,
        Chance = 35, -- Hood-up sabotage is more visible than tyre slashing — moderate alert chance.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21B',
                title       = 'Vehicle Tampering',
                message     = 'Vehicle tampering reported',
                description = 'Vehicle tampering reported',
                blipText    = '911 - Vehicle Tampering',
                sprite      = 380,
                colour      = 1,
                scale       = 1.1,
            })
        end,
    },
}
