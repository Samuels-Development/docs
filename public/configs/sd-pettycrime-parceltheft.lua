return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run while opening the parcel. Enable = false to skip
    -- it. Swap `spot` for any other minigame.* (see client/minigame.lua) or your
    -- own function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.spot({
                gridCount    = 12, -- icons shown in the grid
                rounds       = 3,  -- correct picks required to win
                timeLimitSec = 8,  -- overall time limit; 0 = no limit
            }).success
        end,
    },

    Cooldown = 12,                       -- Minutes before a stolen parcel respawns.
    BaseXP = 10,                         -- XP awarded on successful pickup.
    OpenTime = 2,                        -- Seconds for the open-package progress bar.
    BoxModel = 'hei_prop_heist_box',     -- Prop attached while carrying a package (also the porch box fallback).
    Logging = true,                      -- Whether to emit lib.logger entries for pickups/opens.
    GiveXPForItems = true,               -- Add each rolled item's `xp` on a successful pickup.

    -- The openable item this crime hands out, and the loot pool it rolls into.
    -- Self-contained here (no longer shared with mailbox). The item is made
    -- usable on the server via the inventory bridge; its ox_inventory entry
    -- points `server.export` at `sd-pettycrime.usePorch_package`.
    --   LootCount : distinct items rolled per open (no repeats). Every open yields loot.
    --   Rewards   : weighted pool — `chance` is a relative weight.
    Package = {
        Item         = 'porch_package',
        LootCount    = { min = 1, max = 3 },
        -- Any reward row below can take `guaranteed = true` to always be granted
        -- (its `chance` is ignored); it fills one LootCount slot while the rest
        -- roll normally. (Handled by the package loot roller in server/packages.lua.)
        Rewards = {
            { item = 'laptop',             chance = 20, min = 1, max = 1 },
            { item = 'rolex',              chance = 18, min = 1, max = 1 },
            { item = 'goldbar',            chance = 18, min = 1, max = 1 },
            { item = 'diamond_ring',       chance = 18, min = 1, max = 1 },
            { item = 'phone',              chance = 16, min = 1, max = 1 },
            { item = 'lockpick',           chance = 16, min = 1, max = 2 },
            { item = 'gold_watch',         chance = 12, min = 1, max = 1 },
            { item = 'goldchain',          chance = 10, min = 1, max = 1 },
            { item = 'thermite',           chance = 4,  min = 1, max = 1 },
        },

        -- Booby trap: chance an opened package is rigged. On a trapped open the
        -- player gets no loot (the grid never opens). Pick which reactions fire.
        --   Enable   : master switch for the trap.
        --   Chance   : percentage (0-100) an opened package is trapped.
        --   Particle : play the firework/glitter burst on the player.
        --   Ragdoll  : briefly knock the player down.
        --   Sound    : audible (invisible) explosion for the bang, like xt-porchpirate.
        --   Damage   : if true, the explosion is real (hurts + flings the player,
        --              the xt-porchpirate behaviour). If false it's harmless — only
        --              the bang plays, so use Ragdoll for the knockdown. Needs Sound.
        Trap = {
            Enable   = true,
            Chance   = 10,
            Particle = true,
            Ragdoll  = true,
            Sound    = true,
            Damage   = true,
        },

        -- Carry animation: while holding this package the player carries a box
        -- prop with movement controls locked. Enable = false to skip the forced
        -- carry entirely. `Controls` is optional (omit to use the shared default).
        Carry = {
            Enable   = true,
            Prop     = 'hei_prop_heist_box',
            Controls = { 21, 22, 23, 24, 25, 36, 47, 58, 140, 141, 142, 143, 257, 263, 264 },
        },
    },

    -- Level-based rewards granted on a successful parcel pickup (same system as
    -- the mailbox robbery). The bucket matching the player's parceltheft level
    -- is rolled; missing levels fall back to [1]. `porch_package` is one of the
    -- entries, so the openable box is itself a chance-based reward.
    --   lootCount : how many DIFFERENT items THIS level hands out ({min,max});
    --               each picked item then rolls its own min/max quantity.
    --
    -- HOW WEIGHTED CHANCE WORKS
    -- `chance` is a relative weight, not a percentage — `chance=30` is twice as
    -- likely as `chance=15` within the same bucket.
    -- Any reward row below can take `guaranteed = true` to always be granted
    -- (its `chance` is ignored); it fills one lootCount slot while the rest roll
    -- normally. Supported in every reward table routed through server/rewards.lua.
    Rewards = {
        [1] = { -- Level 1 (basic)
            lootCount = { min = 1, max = 1 },
            items = {
                { item = 'cash',          chance = 15, min = 3,  max = 8,  xp = 0 },
                { item = 'porch_package', chance = 30, min = 1,  max = 1,  xp = 5 },
                { item = 'metalscrap',    chance = 25, min = 1,  max = 2,  xp = 2 },
            },
        },
        [2] = { -- Level 2 (improved)
            lootCount = { min = 1, max = 1 },
            items = {
                { item = 'cash',          chance = 12, min = 8,  max = 15, xp = 0  },
                { item = 'laptop',        chance = 20, min = 1,  max = 1,  xp = 12 },
                { item = 'rolex',         chance = 15, min = 1,  max = 1,  xp = 8  },
                { item = 'porch_package', chance = 25, min = 1,  max = 2,  xp = 5  },
            },
        },
        [3] = { -- Level 3 (advanced)
            lootCount = { min = 1, max = 1 },
            items = {
                { item = 'cash',          chance = 10, min = 15, max = 25, xp = 0  },
                { item = 'laptop',        chance = 25, min = 1,  max = 2,  xp = 12 },
                { item = 'rolex',         chance = 20, min = 1,  max = 2,  xp = 8  },
                { item = 'goldchain',     chance = 15, min = 1,  max = 1,  xp = 15 },
                { item = 'porch_package', chance = 20, min = 2,  max = 3,  xp = 5  },
            },
        },
    },

    PoliceAlert = {
        Enable      = true,
        Chance      = 35,                -- Daytime alert chance (0-100).
        NightChance = 17,                -- Reduced chance during night-time hours.
        NightStart  = 22,                -- Hour at which "night" begins (24h clock).
        NightEnd    = 5,                 -- Hour at which "night" ends.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21C',
                title       = 'Parcel Theft',
                message     = 'Parcel theft reported',
                description = 'Parcel theft reported',
                blipText    = '911 - Parcel Theft',
                sprite      = 310,
                colour      = 1,
                scale       = 1.0,
            })
        end,
    },

    -- Spawn points. Each is streamed in/out around the player based on `distance`
    -- so we don't pay for 49 always-on world entities.
    Locations = {
        { coords = vector3(1060.63, -378.30,  67.24), heading = 50.0,    distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1010.23, -423.59,  64.35), heading = -52.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1028.81, -409.67,  64.95), heading = -50.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1056.19, -449.07,  65.26), heading = -10.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3( 893.20, -540.62,  57.51), heading = -63.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3( 850.28, -532.66,  56.93), heading = -94.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3( 861.73, -583.54,  57.16), heading = 2.00,    distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3( 980.31, -627.75,  58.24), heading = 37.00,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3( 959.95, -669.93,  57.45), heading = -61.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3( 996.79, -729.64,  56.82), heading = -50.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1201.07, -575.49,  68.14), heading = -46.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1265.15, -704.05,  63.54), heading = -30.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1303.17, -527.39,  70.47), heading = -20.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1373.14, -555.82,  73.69), heading = 70.00,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1341.33, -597.35,  73.71), heading = 55.00,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1301.04, -574.35,  70.74), heading = -13.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1250.80, -515.48,  68.35), heading = -105.00, distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1262.60, -429.84,  69.02), heading = -66.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1100.93, -411.39,  66.56), heading = -100.00, distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1009.71, -572.51,  59.60), heading = -99.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3( 965.08, -543.30,  58.36), heading = -60.00,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1045.53, -497.57,  63.08), heading = -103.00, distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3( 993.62, -620.83,  58.05), heading = -57.00,  distance = 25.0, prop = 'hei_prop_heist_box' },

        -- Paleto Bay
        { coords = vector3(-374.62, 6190.97,  31.73), heading = 226.54,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(-356.98, 6207.49,  31.84), heading = 226.31,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(-347.54, 6225.34,  31.88), heading = 226.98,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(-379.95, 6252.66,  31.85), heading = 317.37,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(-360.19, 6260.57,  31.90), heading = 136.28,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(-449.92, 6261.68,  30.04), heading = 67.62,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(-442.47, 6197.88,  29.55), heading = 94.57,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(-302.12, 6326.95,  32.89), heading = 42.01,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(-227.23, 6377.42,  31.76), heading = 47.65,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(-105.58, 6528.65,  30.17), heading = 305.62,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(  -8.41, 6653.31,  31.11), heading = 291.92,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(  35.45, 6663.22,  32.19), heading = 166.79,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(-272.57, 6401.05,  31.50), heading = 210.52,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(-213.60, 6396.30,  33.09), heading = 40.42,   distance = 25.0, prop = 'hei_prop_heist_box' },

        -- Sandy Shores
        { coords = vector3(1371.92, 3647.19,  34.34), heading = 15.12,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1392.07, 3659.32,  34.29), heading = 16.49,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1631.71, 3720.50,  34.39), heading = 127.86,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1735.13, 3809.95,  34.84), heading = 33.46,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1925.16, 3824.65,  32.44), heading = 31.29,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1898.85, 3781.72,  32.88), heading = 298.80,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1824.66, 3743.32,  34.72), heading = 16.94,   distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1797.48, 3721.86,  34.64), heading = 306.19,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1639.21, 3731.31,  35.07), heading = 325.65,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1437.14, 3605.43,  35.07), heading = 207.48,  distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1437.14, 3639.62,  36.17), heading = 7.91,    distance = 25.0, prop = 'hei_prop_heist_box' },
        { coords = vector3(1382.57, 3605.43,  35.07), heading = 207.48,  distance = 25.0, prop = 'hei_prop_heist_box' },
    },
}
