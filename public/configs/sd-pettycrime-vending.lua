return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    Cooldown = 5, -- Cooldown until a vending machine is robbable again. (in minutes)
    Items = { 'WEAPON_HAMMER' }, -- Tools (any one is enough)

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful vending robbery. WEAPON_* tools in Items
    -- only wear while ToolWear.IncludeWeapons is on (this crime's only tool is a
    -- weapon, so wear is off unless that flag is set).
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
    Time = 8, -- Time in seconds it takes to rob a vending machine. (progressbar time)
    BaseXP = 8, -- Base XP awarded for successful vending machine robbery
    GiveXPForItems = true, -- Whether to give additional XP based on items received
    GiveXPForCash = false, -- Whether to give 1 XP per cash received
    Models = { -- Props to create interaction points for
        'prop_vend_snak_01',
        'prop_vend_snak_01_tu',
        'prop_vend_water_01',
        'prop_vend_soda_01',
        'prop_vend_soda_02',
        'prop_vend_fags_01',
        'prop_vend_coffe_01',
        'v_serv_vend_machne1',
    },
    Logging = true, -- Enables lib.logger usage for this action.
    Minigame = {
        Enable = true, -- Enable/disable custom minigame (if false, no minigame will be used)
        Start = function()
            -- Runs a built-in minigame and returns pass/fail. Swap `holdSteady`
            -- for any other minigame.* (see client/minigame.lua for the full
            -- list) or your own function that returns true/false. Tune below.
            return Minigames.holdSteady({
                bandSize        = 0.22, -- target band size (fraction of track)
                holdDurationSec = 2.5,  -- in-band dwell needed to win
                gravity         = 1.2,  -- downward pull on the marker
                thrust          = 2.6,  -- upward push while holding E
                dwellDrainRate  = 0.6,  -- how fast dwell bleeds when off-band
                timeLimitSec    = 12,   -- seconds before caught; 0 = no limit
            }).success
        end,
    },
    PoliceAlert = {
        Enable = true, -- Enable/disable police alerts for vending machine robberies
        Chance = 30, -- Percentage chance (0-100) that police will be alerted
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-15',
                title       = 'Vending Theft',
                message     = 'Vending machine tampering reported',
                description = 'Vending machine tampering reported',
                blipText    = '911 - Vending Theft',
                sprite      = 431,
                colour      = 3,
                scale       = 1.2,
            })
        end,
    },
    -- Cash payout from the coin slot. Independent of the item roll below.
    Cash = {
        [1] = { min = 4,  max = 12 }, -- Level 1 (basic)
        [2] = { min = 8,  max = 20 }, -- Level 2 (improved)
        [3] = { min = 15, max = 35 }, -- Level 3 (advanced)
    },
    -- Per-level loot count now lives in each Rewards level bucket below (lootCount).

    -- Snack/drink loot rolled per successful break-in.
    -- Any reward row below can take `guaranteed = true` to always be granted
    -- (its `chance` is ignored); it fills one lootCount slot while the rest roll
    -- normally. Supported in every reward table routed through server/rewards.lua.
    Rewards = {
        [1] = { -- Level 1 rewards (basic)
            lootCount = { min = 1, max = 2 },
            items = {
                { item = 'water_bottle', chance = 35, min = 1, max = 2, xp = 1 },
                { item = 'fruit_candy',  chance = 30, min = 1, max = 2, xp = 1 },
            },
        },
        [2] = { -- Level 2 rewards (improved)
            lootCount = { min = 1, max = 2 },
            items = {
                { item = 'water_bottle', chance = 30, min = 2, max = 3, xp = 1 },
                { item = 'fruit_candy',  chance = 30, min = 2, max = 3, xp = 1 },
                { item = 'flour',        chance = 20, min = 1, max = 2, xp = 2 },
            },
        },
        [3] = { -- Level 3 rewards (advanced)
            lootCount = { min = 1, max = 2 },
            items = {
                { item = 'water_bottle', chance = 25, min = 3, max = 4, xp = 1 },
                { item = 'fruit_candy',  chance = 25, min = 3, max = 4, xp = 1 },
                { item = 'flour',        chance = 25, min = 2, max = 3, xp = 2 },
                { item = 'bread',        chance = 20, min = 1, max = 2, xp = 3 },
            },
        },
    },
}
