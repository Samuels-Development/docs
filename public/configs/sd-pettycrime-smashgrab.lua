return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run during the grab. Enable = false to skip it. Swap
    -- `whack` for any other minigame.* (see client/minigame.lua) or your own
    -- function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.whack({
                hits          = 8,   -- targets to hit to win
                maxMisses     = 3,   -- expired targets allowed before caught
                targetLifeSec = 1.1, -- seconds each target stays
                spawnEverySec = 0.7, -- seconds between spawns
            }).success
        end,
    },

    Cooldown = 15, -- Per-location cooldown in minutes before the box respawns.
    Items = { 'WEAPON_HAMMER' }, -- Tools (any one is enough).

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful smash-grab. WEAPON_* tools in Items only
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
    SmashTime = 3, -- Seconds to smash window + grab the box.
    BaseXP = 18, -- Base XP awarded for a successful smash-and-grab.
    GiveXPForItems = true, -- Whether to give additional XP based on items received.
    Logging = true, -- Enables lib.logger usage for this action.

    BoxModel = 'hei_prop_heist_box', -- Visible box prop attached to the passenger seat.

    -- Pool of civilian car models the server randomises one from for each
    -- spawn point at resource start. Pick beat-up sedans by default — fits
    -- the "left a package on the front seat" carelessness vibe.
    VehicleModels = {
        'asea',
        'emperor',
        'fugitive',
        'premier',
        'primo',
        'stanier',
        'washington',
        'ingot',
        'asterope',
        'intruder',
    },

    PoliceAlert = {
        Enable = true,
        Chance = 65, -- Window-smash + alarm = high alert chance.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21V',
                title       = 'Vehicle Break-in',
                message     = 'Vehicle break-in reported',
                description = 'Vehicle break-in reported',
                blipText    = '911 - Vehicle Break-in',
                sprite      = 380,
                colour      = 1,
                scale       = 1.2,
            })
        end,
    },

    -- Per-level loot count now lives in each Rewards level bucket below (lootCount).

    -- Loot bucket per player level — what happened to be inside the box.
    -- Any reward row below can take `guaranteed = true` to always be granted
    -- (its `chance` is ignored); it fills one lootCount slot while the rest roll
    -- normally. Supported in every reward table routed through server/rewards.lua.
    Rewards = {
        [1] = { -- Level 1 — basic
            lootCount = { min = 1, max = 1 },
            items = {
                { item = 'phone',         chance = 30, min = 1, max = 1, xp = 6  },
                { item = 'gold_watch',    chance = 25, min = 1, max = 1, xp = 8  },
                { item = 'goldchain',     chance = 20, min = 1, max = 1, xp = 8  },
                { item = 'laptop',        chance = 12, min = 1, max = 1, xp = 12 },
                { item = 'metalscrap',    chance = 25, min = 1, max = 3, xp = 1  },
            },
        },
        [2] = { -- Level 2 — improved
            lootCount = { min = 1, max = 1 },
            items = {
                { item = 'phone',         chance = 25, min = 1, max = 2, xp = 6  },
                { item = 'gold_watch',    chance = 22, min = 1, max = 2, xp = 8  },
                { item = 'goldchain',     chance = 22, min = 1, max = 2, xp = 8  },
                { item = 'rolex',         chance = 15, min = 1, max = 1, xp = 10 },
                { item = 'laptop',        chance = 12, min = 1, max = 1, xp = 12 },
                { item = 'purse',         chance = 18, min = 1, max = 1, xp = 8  },
            },
        },
        [3] = { -- Level 3 — advanced
            lootCount = { min = 1, max = 1 },
            items = {
                { item = 'gold_watch',    chance = 22, min = 1, max = 3, xp = 8  },
                { item = 'goldchain',     chance = 20, min = 1, max = 3, xp = 8  },
                { item = 'rolex',         chance = 18, min = 1, max = 2, xp = 10 },
                { item = 'laptop',        chance = 18, min = 1, max = 2, xp = 12 },
                { item = '10kgoldchain',  chance = 12, min = 1, max = 1, xp = 20 },
                { item = 'diamond_ring',  chance = 8,  min = 1, max = 1, xp = 25 },
                { item = 'goldbar',       chance = 6,  min = 1, max = 1, xp = 30 },
            },
        },
    },

    -- Spawn points around Los Santos. Each location's vehicle model is
    -- chosen randomly from `VehicleModels` at server start.
    --
    -- `coords` + `heading` define where the parked car appears.
    -- `distance` is the streaming radius (player must enter to see the spawn).
    Locations = {
        { coords = vector3(1002.64, -2314.02, 29.1), heading = 264.96, distance = 30.0 },
        { coords = vector3(27.25, -1737.63, 27.89), heading = 48.86, distance = 30.0 },
        { coords = vector3(159.89, -1637.25, 27.88), heading = 194.29, distance = 30.0 },
        { coords = vector3(243.96, -1415.21, 29.17), heading = 146.85, distance = 30.0 },
        { coords = vector3(215.83, -776.12, 29.44), heading = 68.31, distance = 30.0 },
        { coords = vector3(53.7, -846.74, 29.43), heading = 340.31, distance = 30.0 },
        { coords = vector3(-332.7, -938.26, 29.67), heading = 250.8, distance = 30.0 },
        { coords = vector3(-444.12, -801.15, 29.13), heading = 268.53, distance = 30.0 },
        { coords = vector3(-1318.9, -1144.74, 3.09), heading = 271.27, distance = 30.0 },
        { coords = vector3(-1237.47, -1418.45, 2.91), heading = 124.03, distance = 30.0 },
        { coords = vector3(-1409.26, -636.3, 27.26), heading = 32.83, distance = 30.0 },
        { coords = vector3(-1401.0, 35.62, 51.7), heading = 59.89, distance = 30.0 },
    },
}
