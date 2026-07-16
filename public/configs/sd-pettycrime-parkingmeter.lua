return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    Cooldown = 2, -- Cooldown until a parking meteris robbable again. (in minutes)
    Items = { 'screwdriver', 'multitool', 'WEAPON_CROWBAR' }, -- Tools (any one is enough) — used to jimmy the meter.

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful meter robbery. WEAPON_* tools in Items only
    -- wear while ToolWear.IncludeWeapons is on.
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
    Time = 10, -- Time in seconds to loot the parking meter (progressbar time)
    BaseXP = 20, -- Base XP awarded for successful parking meter robbery
    GiveXPForItems = false, -- Whether to give additional XP based on items received (cash only, no items)
    GiveXPForCash = true, -- Whether to give 1 XP per cash received
    Models = { -- Props to create interaction points for
        "prop_parknmeter_01",
        "prop_parknmeter_02"
    },
    Logging = true, -- Enables lib.logger usage for this action. Will log a players source, character name and identifier as well as the action they took and the items and cash they received from it.
    Minigame = {
        Enable = true, -- Enable/disable custom minigame (if false, no minigame will be used)
        Start = function()
            -- Runs a built-in minigame and returns pass/fail. Swap `wires` for
            -- any other minigame.* (see client/minigame.lua for the full list)
            -- or your own function that returns true/false. Tune below.
            return Minigames.wires({
                wireCount    = 5, -- total wires shown (max 7)
                cutsNeeded   = 3, -- correct cuts required to win
                timeLimitSec = 8, -- seconds before caught; 0 = no limit
            }).success
        end,
    },
    PoliceAlert = {
        Enable = true, -- Enable/disable police alerts for parking meter robberies
        Chance = 20, -- Percentage chance (0-100) that police will be alerted
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-15',
                title       = 'Vandalism',
                message     = 'Parking meter tampering reported',
                description = 'Parking meter tampering reported',
                blipText    = '911 - Vandalism',
                sprite      = 431,
                colour      = 3,
                scale       = 1.2,
            })
        end,
    },
    Rewards = { -- Level-based cash rewards from parking meters
        [1] = { -- Level 1 rewards (basic)
            min = 3,
            max = 12
        },
        [2] = { -- Level 2 rewards (improved)
            min = 8,
            max = 20
        },
        [3] = { -- Level 3 rewards (advanced)
            min = 15,
            max = 35
        },
    },
}
