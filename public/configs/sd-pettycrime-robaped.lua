return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run when committing the rob. Enable = false to skip
    -- it. Swap `reaction` for any other minigame.* (see client/minigame.lua) or
    -- your own function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.reaction({
                rounds         = 5,    -- key prompts to hit in a row
                startWindowSec = 1.2,  -- time for the first prompt (sec)
                windowShrink   = 0.88, -- window multiplier each round (tighter)
            }).success
        end,
    },

    Time = 10,             -- Time in seconds for the rob progress bar.
    Chance = 90,           -- Overall % chance the ped has anything on them.
    RunawayChance = 10,    -- Per-second % chance a held-up ped breaks free if you stop aiming.
    Key = 38,              -- Control input that commits the rob (38 = E by default).
    BaseXP = 25,           -- Base XP awarded on every successful rob.
    GiveXPForItems = true, -- Adds the per-item XP value when an item drops.
    GiveXPForCash = true,  -- Adds 1 XP per $ stolen (set false for flat per-rob XP).
    Logging = true,        -- lib.logger entries on success.

    PoliceAlert = {
        Enable = true,
        Chance = 35, -- 0-100 chance an alert fires on a successful rob.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-31',
                title       = 'Armed Robbery',
                message     = 'Armed robbery reported',
                description = 'Armed robbery reported',
                blipText    = '911 - Armed Robbery',
                sprite      = 431,
                colour      = 1,
                scale       = 1.2,
            })
        end,
    },

    -- Weapons (or weapon groups) that won't trigger the detection loop. Keep
    -- harmless ones here so the option doesn't fire on someone holding a
    -- fire extinguisher and sneezing at a passer-by.
    IgnoreWeapons = {
        WEAPON_UNARMED         = true,
        WEAPON_BEANBAG         = true,
        GROUP_FIREEXTINGUISHER = true,
    },

    -- Ped models the option won't attach to. Cops, paramedics, named gang
    -- bosses, military, etc. — anyone where "armed robbery" should escalate
    -- to combat instead of a held-up animation.
    IgnoreModels = {
        ['s_m_y_cop_01']       = true,
        ['s_m_m_paramedic_01'] = true,
        ['s_f_y_shop_mid']     = true,
        ['csb_ballasog']       = true,
        ['g_m_y_ballasout_01'] = true,
        ['g_f_y_ballas_01']    = true,
        ['ig_ballasog']        = true,
        ['s_m_y_marine_01']    = true,
        ['s_m_m_armoured_02']  = true,
    },

    -- Per-level loot count now lives in each tier's level bucket below (lootCount).

    -- Tiered loot tables. Same shape as pickpocket — a cash range plus a
    -- level-keyed bucket on each tier. Each level bucket has its own:
    --   lootCount : how many DIFFERENT items that level rolls ({min,max}); each
    --               picked item then rolls its own min/max quantity.
    --   items     : the weighted pool (chance = relative weight) to draw from.
    -- Cash bands are higher than pickpocket because armed robbery carries more
    -- risk (police chance, visible weapon, witness reactions).
    -- Any reward row below can take `guaranteed = true` to always be granted
    -- (its `chance` is ignored); it fills one lootCount slot while the rest roll
    -- normally. Supported in every reward table routed through server/rewards.lua.
    Tiers = {
        low = {
            cash = { min = 8, max = 25 },
            [1] = {
                lootCount = { min = 1, max = 1 },
                items = {
                    { item = 'metalscrap', chance = 25, min = 1, max = 2, xp = 1 },
                    { item = 'copper',     chance = 15, min = 1, max = 1, xp = 2 },
                },
            },
            [2] = {
                lootCount = { min = 1, max = 1 },
                items = {
                    { item = 'metalscrap', chance = 20, min = 2, max = 3, xp = 1 },
                    { item = 'copper',     chance = 15, min = 1, max = 2, xp = 2 },
                    { item = 'aluminum',   chance = 10, min = 1, max = 1, xp = 3 },
                },
            },
            [3] = {
                lootCount = { min = 1, max = 1 },
                items = {
                    { item = 'metalscrap', chance = 18, min = 3, max = 4, xp = 1 },
                    { item = 'copper',     chance = 15, min = 2, max = 3, xp = 2 },
                    { item = 'aluminum',   chance = 12, min = 1, max = 2, xp = 3 },
                    { item = 'steel',      chance = 8,  min = 1, max = 1, xp = 5 },
                },
            },
        },
        medium = {
            cash = { min = 20, max = 50 },
            [1] = {
                lootCount = { min = 1, max = 1 },
                items = {
                    { item = 'rolex', chance = 15, min = 1, max = 1, xp = 8 },
                    { item = 'phone', chance = 20, min = 1, max = 1, xp = 6 },
                },
            },
            [2] = {
                lootCount = { min = 1, max = 1 },
                items = {
                    { item = 'rolex',     chance = 18, min = 1, max = 2, xp = 8  },
                    { item = 'phone',     chance = 15, min = 1, max = 1, xp = 6  },
                    { item = 'goldchain', chance = 12, min = 1, max = 1, xp = 10 },
                },
            },
            [3] = {
                lootCount = { min = 1, max = 1 },
                items = {
                    { item = 'rolex',     chance = 20, min = 1, max = 3, xp = 8  },
                    { item = 'phone',     chance = 15, min = 1, max = 2, xp = 6  },
                    { item = 'goldchain', chance = 15, min = 1, max = 2, xp = 10 },
                    { item = 'laptop',    chance = 10, min = 1, max = 1, xp = 12 },
                },
            },
        },
        high = {
            cash = { min = 40, max = 100 },
            [1] = {
                lootCount = { min = 1, max = 1 },
                items = {
                    { item = 'diamond_ring', chance = 12, min = 1, max = 1, xp = 15 },
                    { item = 'goldchain',    chance = 18, min = 1, max = 1, xp = 10 },
                },
            },
            [2] = {
                lootCount = { min = 1, max = 1 },
                items = {
                    { item = 'diamond_ring', chance = 15, min = 1, max = 1, xp = 15 },
                    { item = 'goldchain',    chance = 15, min = 1, max = 2, xp = 10 },
                    { item = '10kgoldchain', chance = 10, min = 1, max = 1, xp = 20 },
                },
            },
            [3] = {
                lootCount = { min = 1, max = 1 },
                items = {
                    { item = 'diamond_ring', chance = 18, min = 1, max = 2, xp = 15 },
                    { item = 'goldchain',    chance = 15, min = 2, max = 3, xp = 10 },
                    { item = '10kgoldchain', chance = 12, min = 1, max = 2, xp = 20 },
                    { item = 'diamond',      chance = 8,  min = 1, max = 1, xp = 25 },
                },
            },
        },
    },

    -- Zones grouped by tier. Robbery's tier model leans toward
    -- *high-traffic* areas where wealthy peds are likely to be on foot
    -- carrying cash + valuables — slightly different from pickpocket's
    -- "wealth at home" residential focus.
    --
    -- Anything not listed defaults to the `low` tier.
    ZoneTiers = {
        high = {
            'AIRP',    -- Los Santos International Airport (travelers with cash + valuables)
            'PBOX',    -- Pillbox Hill (downtown business)
            'DOWNT',   -- Downtown
            'DTVINE',  -- Downtown Vinewood
            'STAD',    -- Maze Bank Arena (event crowds)
            'MOVIE',   -- Richards Majestic
            'LEGSQU',  -- Legion Square
            'KOREAT',  -- Little Seoul
        },
        medium = {
            'CHIL',    -- Vinewood Hills
            'ROCKF',   -- Rockford Hills
            'HAWICK',  -- Hawick
            'PBLUFF',  -- Pacific Bluffs
            'TONGVAH', -- Tongva Hills
            'RGLEN',   -- Richman Glen
            'RICHM',   -- Richman
            'BEACH',   -- Vespucci Beach
            'DELBE',   -- Del Perro Beach
            'DELPE',   -- Del Perro
            'MIRR',    -- Mirror Park
            'MORN',    -- Morningwood
            'VINE',    -- Vinewood
            'WVINE',   -- West Vinewood
            'EAST_V',  -- East Vinewood
            'BURTON',  -- Burton
            'ALTA',    -- Alta
            'HORS',    -- Vinewood Racetrack
            'BHAMCA',  -- Banham Canyon
            'GOLF',    -- GWC and Golfing Society
            'TEXTI',   -- Textile City
        },
        -- Everything else (Davis, Strawberry, Chamberlain, El Burro, Stab
        -- City, Sandy Shores, Grapeseed, Paleto, the wilds) falls through
        -- to the `low` tier.
    },
}
