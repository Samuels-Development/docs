return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    Cooldown = 3,                                        -- Per-rack cooldown (in minutes) before the same coin tray can be cracked again.
    Items   = { 'screwdriver', 'multitool' }, -- Tools (any one is enough)

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful rack robbery.
    --
    -- ToolDrain is the DEFAULT method (durability): the used tool loses this many
    -- points each success and breaks once it hits 0. Active while
    -- ToolWear.Durability.Enable is on (the default).
    ToolDrain = 5,

    -- ToolBreakChance is the OPTIONAL alternative (random break): a flat % chance
    -- to break the used tool outright on a success, independent of durability.
    -- Active only while ToolWear.BreakChance.Enable is on (off by default).
    ToolBreakChance = 10,

    ShowTargetWithoutItem = false, -- Show the target even without a required tool (false = only show when you have one). The action still requires the tool.
    Time    = 8,                                         -- Seconds for the loot progress bar.
    BaseXP  = 6,                                         -- Base XP awarded for a successful raid.
    GiveXPForCash = true,                                -- 1 XP per $ collected on top of BaseXP.
    Logging = true,

    -- World-prop model names ox_target attaches our option to. Newspaper
    -- racks are scattered all over the GTA V map — sidewalks outside
    -- 24/7s, gas stations, transit stops, suburban corners. addModel does
    -- the rest, no spawning required.
    Models = {
        'prop_news_disp_01a',
        'prop_news_disp_02a',
        'prop_news_disp_02b',
        'prop_news_disp_02c',
        'prop_news_disp_02d',
        'prop_news_disp_02e',
        'prop_news_disp_03a',
        'prop_news_disp_03c',
        'prop_news_disp_05a',
        'prop_news_disp_06a',
        'prop_news_disp_06b',
        'prop_news_disp_06c',
        'prop_news_disp_06d',
        'prop_news_disp_06e',
    },

    Minigame = {
        Enable = true,
        Start = function()
            -- Runs a built-in minigame and returns pass/fail. Swap `dial` for
            -- any other minigame.* (see client/minigame.lua for the full list)
            -- or your own function that returns true/false. Tune below.
            return Minigames.dial({
                notches             = 4,    -- notches to crack in order
                hitWindowDeg        = 24,   -- hit tolerance in degrees
                rotationSpeedDegSec = 170,  -- hand speed (deg/sec)
                speedUpMultiplier   = 1.08, -- speed-up after each notch
                timeLimitSec        = 10,   -- seconds before caught; 0 = none
            }).success
        end,
    },

    PoliceAlert = {
        Enable = true,
        Chance = 18, -- Lower than parking meters — newsracks are tinier targets.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-15',
                title       = 'Vandalism',
                message     = 'Newsrack tampering reported',
                description = 'Newsrack tampering reported',
                blipText    = '911 - Vandalism',
                sprite      = 431,
                colour      = 3,
                scale       = 1.1,
            })
        end,
    },

    -- Per-level cash payout — small change, scaling with player level.
    Rewards = {
        [1] = { min = 2,  max = 8  }, -- Level 1
        [2] = { min = 6,  max = 14 }, -- Level 2
        [3] = { min = 10, max = 22 }, -- Level 3
    },
}
