return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    Cooldown = 2, -- Cooldown till a payphone is robbable again. (in minutes)
    Items = { 'screwdriver', 'multitool' }, -- Tools (any one is enough) — used to pry the coin box.

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful payphone robbery.
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
    Time = 10, -- Time in seconds to loot the payphone (progressbar time)
    BaseXP = 12, -- Base XP awarded for successful payphone robbery
    GiveXPForCash = true, -- Whether to give 1 XP per cash received
    Models = { -- Models to add the target to.
        "p_phonebox_02_s",
        "prop_phonebox_03",
        "prop_phonebox_02",
        "prop_phonebox_04",
        "prop_phonebox_01c", 
        "prop_phonebox_01a",
        "prop_phonebox_01b",
        "p_phonebox_01b_s",
    },
    Logging = true, -- Enables lib.logger usage for this action. Will log a players source, character name and identifier as well as the action they took and the items and cash they received from it.
    Minigame = {
        Enable = true, -- Enable/disable custom minigame (if false, no minigame will be used)
        Start = function()
            -- Runs a built-in minigame and returns pass/fail. Swap `sequence`
            -- for any other minigame.* (see client/minigame.lua for the full
            -- list) or your own function that returns true/false. Tune below.
            return Minigames.sequence({
                padCount     = 4,   -- number of pads
                startLength  = 3,   -- sequence length to start at
                maxLength    = 6,   -- grows to this; clearing it wins
                growBy       = 1,   -- pads added each round
                flashOnMs    = 440, -- how long each pad lights (ms)
                flashGapMs   = 220, -- gap between pad flashes (ms)
                timeLimitSec = 7,   -- seconds per round; 0 = no limit
            }).success
        end,
    },
    PoliceAlert = {
        Enable = true, -- Enable/disable police alerts for payphone robberies
        Chance = 30, -- Percentage chance (0-100) that police will be alerted
        --- @param coords, the coordinates of the player thats triggered the alert.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-15',
                title       = 'Vandalism',
                message     = 'Payphone tampering reported',
                description = 'Payphone tampering reported',
                blipText    = '911 - Vandalism',
                sprite      = 431,
                colour      = 3,
                scale       = 1.2,
            })
        end,
    },
    Rewards = { -- Level-based cash rewards from payphones
        [1] = { -- Level 1 rewards (basic)
            min = 4,
            max = 15
        },
        [2] = { -- Level 2 rewards (improved)
            min = 10,
            max = 25
        },
        [3] = { -- Level 3 rewards (advanced)
            min = 20,
            max = 40
        },
    },
}
