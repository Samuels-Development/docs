return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    Cooldown = 2, -- Cooldown until a shelve is robbable again. (in minutes)
    Time = 10, -- Time in Seconds to loot a shelve for loot (progressbar time)
    BaseXP = 6, -- Base XP awarded for successful shoplift
    GiveXPForItems = true, -- Whether to give additional XP based on items received
    Models = { -- Props to create interaction points for
        'v_ret_247shelves01',
        'v_ret_247shelves02',
        'v_ret_247shelves03',
        'v_ret_247shelves04',
        'v_ret_247shelves05',
    },
    Logging = true, -- Enables lib.logger usage for this action. Will log a players source, character name and identifier as well as the action they took and the items and cash they received from it.
    Minigame = {
        Enable = true, -- Enable/disable custom minigame (if false, no minigame will be used)
        Start = function()
            -- Runs a built-in minigame and returns pass/fail. Swap `stealth`
            -- for any other minigame.* (see client/minigame.lua for the full
            -- list) or your own function that returns true/false. Tune below.
            return Minigames.stealth({
                steps            = 4,    -- look-away presses needed to win
                safeDurationSec  = 1.1,  -- base length of a look-away window
                watchDurationSec = 0.9,  -- base length of a watching window
                jitterSec        = 0.35, -- random +/- applied to each window
                timeLimitSec     = 8,    -- seconds before caught; 0 = no limit
            }).success
        end,
    },
    PoliceAlert = {
        Enable = true, -- Enable/disable police alerts for shoplifting
        Chance = 75, -- Percentage chance (0-100) that police will be alerted
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-15',
                title       = 'Store Robbery',
                message     = 'Shoplifting reported',
                description = 'Shoplifting reported',
                blipText    = '911 - Store Robbery',
                sprite      = 431,
                colour      = 3,
                scale       = 1.2,
            })
        end,
    },
    -- Per-level loot count now lives in each Rewards level bucket below (lootCount).

    -- Any reward row below can take `guaranteed = true` to always be granted
    -- (its `chance` is ignored); it fills one lootCount slot while the rest roll
    -- normally. Supported in every reward table routed through server/rewards.lua.
    Rewards = { -- Level-based rewards from looting shelves
        -- HOW WEIGHTED CHANCE WORKS:
        -- The "chance" number is like putting that many tickets in a hat.
        -- Higher chance = more tickets = more likely to be picked.
        -- 
        -- Example: water_bottle=30, fruit_candy=30, flour=30 tickets
        -- Total tickets in hat = 90 tickets
        -- Each item has 30/90 = 33.3% chance to be picked
        -- Since all items have equal chance (30), they're equally likely
        --
        -- You can use any numbers you want - 1, 100, 1000, etc.
        -- What matters is the ratio between them!
        -- To make flour more rare, you could change it to chance = 10
        -- Then: water=30, candy=30, flour=10 = 70 total
        -- water=43%, candy=43%, flour=14%
        
        [1] = { -- Level 1 rewards (basic)
            lootCount = { min = 1, max = 2 },
            items = {
                {item = "water_bottle", chance = 35, min = 1, max = 2, xp = 1},
                {item = "fruit_candy", chance = 25, min = 1, max = 2, xp = 2},
            },
        },
        [2] = { -- Level 2 rewards (improved)
            lootCount = { min = 1, max = 2 },
            items = {
                {item = "water_bottle", chance = 30, min = 2, max = 3, xp = 1},
                {item = "fruit_candy", chance = 30, min = 2, max = 3, xp = 2},
                {item = "flour", chance = 20, min = 1, max = 2, xp = 3},
            },
        },
        [3] = { -- Level 3 rewards (advanced)
            lootCount = { min = 1, max = 2 },
            items = {
                {item = "water_bottle", chance = 25, min = 3, max = 4, xp = 1},
                {item = "fruit_candy", chance = 25, min = 3, max = 4, xp = 2},
                {item = "flour", chance = 30, min = 2, max = 4, xp = 3},
                {item = "bread", chance = 15, min = 1, max = 2, xp = 4},
            },
        },
    },
}
