return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run during the sign grab. Enable = false to skip it.
    -- Swap `pipes` for any other minigame.* (see client/minigame.lua) or your
    -- own function returning true/false.
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

    Cooldown = 60, -- Per-coords cooldown (minutes) before a stolen sign respawns. Set to 0 for permanent (until restart).
    Items = { 'screwdriver', 'WEAPON_WRENCH', 'multitool' }, -- Tools (any one is enough) — needed to unbolt the sign.

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful sign theft. WEAPON_* tools in Items only
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
    StealTime = 6, -- Seconds spent unbolting (progress bar duration).
    BaseXP = 12, -- Base XP per sign stolen.
    GiveXPForItems = true, -- Whether to give additional XP based on items received.
    Logging = true, -- Enables lib.logger usage for this action.

    -- Sign prop models. `target.addModel` attaches the steal option to
    -- every world prop matching one of these. Same list ps-signrobbery
    -- targets — standard GTA V street-sign props seeded around the map.
    --
    --   prop_sign_road_01a            — Stop sign
    --   prop_sign_road_02a            — Yield sign
    --   prop_sign_road_03e            — Don't block intersection
    --   prop_sign_road_03m            — U-Turn
    --   prop_sign_road_04a            — No parking
    --   prop_sign_road_05a            — Walking man / pedestrian crossing
    --   prop_sign_road_05e            — Left turn
    --   prop_sign_road_05f            — Right turn
    --   prop_sign_road_restriction_10 — No trespassing
    Models = {
        'prop_sign_road_01a',
        'prop_sign_road_02a',
        'prop_sign_road_03e',
        'prop_sign_road_03m',
        'prop_sign_road_04a',
        'prop_sign_road_05a',
        'prop_sign_road_05e',
        'prop_sign_road_05f',
        'prop_sign_road_restriction_10',
    },

    PoliceAlert = {
        Enable = true,
        Chance = 15, -- Quiet crime — unbolt and run. Visible result (missing sign) gets noticed slowly.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21S',
                title       = 'Stolen Street Sign',
                message     = 'Stolen street sign reported',
                description = 'Stolen street sign reported',
                blipText    = '911 - Stolen Sign',
                sprite      = 380,
                colour      = 1,
                scale       = 1.0,
            })
        end,
    },

    -- Loot bucket per player level. Steel street signs scrap into the
    -- same materials as the rooftop AC strip — `metalscrap`, `iron`,
    -- `aluminum`, `steel`, etc. — so they reuse the established scrap
    -- item ecosystem without needing per-sign-type inventory items.
    -- Per-level loot count now lives in each Rewards level bucket below (lootCount).

    -- Any reward row below can take `guaranteed = true` to always be granted
    -- (its `chance` is ignored); it fills one lootCount slot while the rest roll
    -- normally. Supported in every reward table routed through server/rewards.lua.
    Rewards = {
        [1] = { -- Level 1 — basic
            lootCount = { min = 1, max = 2 },
            items = {
                { item = 'metalscrap', chance = 60, min = 1, max = 3, xp = 1 },
                { item = 'iron',       chance = 30, min = 1, max = 2, xp = 2 },
                { item = 'aluminum',   chance = 25, min = 1, max = 2, xp = 3 },
            },
        },
        [2] = { -- Level 2 — improved
            lootCount = { min = 1, max = 2 },
            items = {
                { item = 'metalscrap', chance = 50, min = 2, max = 4, xp = 1 },
                { item = 'iron',       chance = 30, min = 1, max = 3, xp = 2 },
                { item = 'aluminum',   chance = 25, min = 1, max = 3, xp = 3 },
                { item = 'steel',      chance = 18, min = 1, max = 2, xp = 5 },
            },
        },
        [3] = { -- Level 3 — advanced
            lootCount = { min = 1, max = 2 },
            items = {
                { item = 'metalscrap', chance = 40, min = 2, max = 5, xp = 1 },
                { item = 'iron',       chance = 30, min = 2, max = 4, xp = 2 },
                { item = 'aluminum',   chance = 25, min = 2, max = 4, xp = 3 },
                { item = 'steel',      chance = 22, min = 1, max = 3, xp = 5 },
                { item = 'copper',     chance = 18, min = 1, max = 2, xp = 2 },
            },
        },
    },
}
