return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- ============================================================================
    -- Speedbomb — a "Speed (1994)" style sabotage. The player slides under a
    -- parked vehicle (same approach as the catalytic theft) and wires a
    -- `speed_bomb` to it. Nothing happens until someone drives it: the moment the
    -- vehicle crosses `ThresholdKmh`, the bomb ARMS, and from then on the driver
    -- must KEEP it above the threshold for `Duration` seconds. Dropping below
    -- (or stopping / bailing out) detonates the vehicle. Survive the full timer
    -- and the bomb safely deactivates.
    --
    -- The bomb lives in a replicated entity state bag (`sdpc_speedbomb`) so
    -- whoever drives the car later — not the installer — runs the trigger logic.
    -- ============================================================================

    -- Skill-check minigame run while wiring the bomb (played under the vehicle).
    -- `pipes` = route the circuit to connect the flow, which reads as wiring the
    -- device up. Enable = false to skip it.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.pipes({
                cols         = 5,  -- grid columns
                rows         = 3,  -- grid rows
                timeLimitSec = 25, -- seconds before caught; 0 = no limit
            }).success
        end,
    },

    Item        = 'speed_bomb', -- Inventory item required and consumed to plant a bomb.
    ShowTargetWithoutItem = false, -- Show the target even without the item (false = only show when you have it). The action still requires the item.
    InstallTime = 8,            -- Seconds spent under the vehicle wiring it (progress bar duration).
    BaseXP      = 40,           -- XP awarded to the installer when a planted bomb detonates.
    Logging     = true,

    -- Trigger tuning.
    SpeedUnit = 'mph',  -- 'kmh' or 'mph' — the unit Threshold is given in, and the unit shown to the driver.
    Threshold = 80,     -- Speed (in SpeedUnit) the vehicle must exceed to arm the bomb, and stay above once armed.
    Duration  = 5,    -- Seconds the driver must hold above the threshold after arming to survive (300 = 5 min).
    Leeway        = 8,  -- Grace margin (in SpeedUnit) the speed may dip below Threshold without detonating,
                        -- so hovering right at the threshold the moment it arms doesn't instantly blow it.
    LeewaySeconds = 15, -- ...but only for this many seconds after arming (a "get up to speed" window). After
                        -- that the full Threshold is enforced. Set to 0 to disable the leeway entirely.

    -- Sound played for the driver the instant the bomb arms — any GTA frontend
    -- sound name + soundset. Set Name = nil (or ArmSound = false) to disable.
    ArmSound = {
        Name = 'Beep_Red',
        Set  = 'DLC_HEIST_HACKING_SNAKE_SOUNDS',
    },

    -- Vehicle classes the install option refuses to attach to.
    IgnoreClasses = {
        [8]  = true, -- Motorcycles
        [13] = true, -- Cycles
        [14] = true, -- Boats
        [15] = true, -- Helicopters
        [16] = true, -- Planes
        [21] = true, -- Trains
    },

    -- Pre-hashed model exemption list — civilian models you don't want eligible.
    IgnoreModels = {
        -- ['emperor'] = true,
    },

    PoliceAlert = {
        Enable = true,
        Chance = 30, -- Rolled when the bomb is planted (the quiet part). The detonation is its own loud event.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21V',
                title       = 'Vehicle Tampering',
                message     = 'Suspicious activity under a parked vehicle',
                description = 'Suspicious activity under a parked vehicle',
                blipText    = '911 - Vehicle Tampering',
                sprite      = 380,
                colour      = 1,
                scale       = 1.1,
            })
        end,
    },
}
