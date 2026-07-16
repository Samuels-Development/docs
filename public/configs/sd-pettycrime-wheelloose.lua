return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run during the loosen. Enable = false to skip it.
    -- Swap `safeDial` for any other minigame.* (see client/minigame.lua) or your
    -- own function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.safeDial({
                numbers      = 12, -- marks around the dial
                steps        = 3,  -- marks to land in sequence to crack it
                toleranceDeg = 10, -- angular tolerance per mark (deg)
                timeLimitSec = 18, -- seconds before caught; 0 = no limit
            }).success
        end,
    },

    Items = { 'WEAPON_WRENCH' }, -- Leverage tool used to back the lugs off the studs.

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful wheel loosen. WEAPON_* tools in Items only
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
    LooseTime = 6, -- Seconds spent crouched at the wheel backing the lugs off (progress bar duration).
    BaseXP = 20, -- Base XP per wheel loosened.
    Logging = true, -- Enables lib.logger usage for this action.

    -- Vehicle speed (m/s) at which a loosened wheel will detach mid-drive.
    -- GetEntitySpeed returns m/s natively, so this matches without conversion.
    -- Reference points:
    --   13.41 m/s ≈ 30 mph ≈ 48 km/h  — early-trigger, urban speeds
    --   22.35 m/s ≈ 50 mph ≈ 80 km/h  — default, freeway-onramp speeds
    --   27.78 m/s ≈ 62 mph ≈ 100 km/h — late-trigger, highway speeds
    --   33.53 m/s ≈ 75 mph ≈ 120 km/h — only-on-the-highway sabotage
    TriggerSpeed = 22.35,

    -- Vehicle classes the target option will refuse to attach to. Same default
    -- shape as tireslash/tiretheft.
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
        Chance = 20, -- Quieter than visible tyre theft — the wheel only comes off later.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21L',
                title       = 'Wheel Tampering',
                message     = 'Vehicle tampering reported',
                description = 'Vehicle tampering reported',
                blipText    = '911 - Wheel Tampering',
                sprite      = 380,
                colour      = 1,
                scale       = 1.1,
            })
        end,
    },
}
