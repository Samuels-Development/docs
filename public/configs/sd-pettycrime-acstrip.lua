return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run after the strip. Enable = false to skip it. Swap
    -- `lockpick` for any other minigame.* (see client/minigame.lua) or your own
    -- function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.lockpick({
                nodeCount           = 5,    -- target nodes around the ring
                hitWindowDeg        = 32,   -- angular tolerance per node (deg)
                rotationSpeedDegSec = 150,  -- orb orbit speed (deg/sec)
                speedUpMultiplier   = 1.12, -- speed-up applied after each node opens
                timeLimitSec        = 0,    -- seconds before caught; 0 = no limit
            }).success
        end,
    },

    Cooldown = 25,                                            -- Per-unit cooldown in minutes (keyed by world coords).
    Items = { 'powersaw', 'anglegrinder', 'bolt_cutter', 'WEAPON_HATCHET' }, -- Cutting tools (any one is enough).

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful AC strip. WEAPON_* tools in Items only wear
    -- while ToolWear.IncludeWeapons is on.
    --
    -- ToolDrain is the DEFAULT method (durability): the used tool loses this many
    -- points each success and breaks once it hits 0. Active while
    -- ToolWear.Durability.Enable is on (the default).
    ToolDrain = 8,

    -- ToolBreakChance is the OPTIONAL alternative (random break): a flat % chance
    -- to break the used tool outright on a success, independent of durability.
    -- Active only while ToolWear.BreakChance.Enable is on (off by default).
    ToolBreakChance = 10,

    ShowTargetWithoutItem = false, -- Show the target even without a required tool (false = only show when you have one). The action still requires the tool.
    StripTime = 18,                                           -- Seconds to strip a unit (progress bar duration).
    BaseXP = 22,
    GiveXPForItems = true,
    Logging = true,

    -- All HVAC / AC unit prop hashes scattered around the GTA V map. ox_target's
    -- `addModel` attaches our strip option to every existing world prop matching
    -- one of these — no spawning needed, the props are already part of the map.
    -- Players have to find them: rooftops, alley walls, the back of stores.
    --
    -- Two size groups:
    --   l_* — large floor-mount commercial condensers (rooftops, parking lots)
    --   m_* — medium wall-mount residential condensers (alleys, side walls)
    --
    -- The reward tables don't differentiate by size right now; you can split
    -- them in the admin panel if you want larger units to drop more copper.
    Models = {
        'prop_aircon_l_01',
        'prop_aircon_l_02',
        'prop_aircon_l_03',
        'prop_aircon_l_03_dam',
        'prop_aircon_l_04',
        'prop_aircon_m_01',
        'prop_aircon_m_02',
        'prop_aircon_m_03',
        'prop_aircon_m_04',
        'prop_aircon_m_05',
        'prop_aircon_m_06',
    },

    PoliceAlert = {
        Enable = true,
        Chance = 30,
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21R',
                title       = 'Rooftop Theft',
                message     = 'Rooftop AC unit theft reported',
                description = 'Rooftop AC unit theft reported',
                blipText    = '911 - Rooftop Theft',
                sprite      = 380,
                colour      = 1,
                scale       = 1.1,
            })
        end,
    },

    -- Loot table per player level. Heavy on copper/aluminum/scrap since that's
    -- the real-world appeal of stripping HVAC units. Modelled on the example
    -- reward shape: most rolls return 2-3 different scrap items per success.
    -- Per-level loot count now lives in each Rewards level bucket below (lootCount).

    -- Any reward row below can take `guaranteed = true` to always be granted
    -- (its `chance` is ignored); it fills one lootCount slot while the rest roll
    -- normally. Supported in every reward table routed through server/rewards.lua.
    Rewards = {
        [1] = {
            lootCount = { min = 2, max = 3 },
            items = {
                { item = 'metalscrap', chance = 50, min = 2, max = 4, xp = 1 },
                { item = 'plastic',    chance = 35, min = 1, max = 3, xp = 1 },
                { item = 'copper',     chance = 35, min = 1, max = 3, xp = 2 },
                { item = 'aluminum',   chance = 25, min = 1, max = 2, xp = 3 },
                { item = 'rubber',     chance = 25, min = 1, max = 2, xp = 1 },
                { item = 'iron',       chance = 25, min = 1, max = 2, xp = 2 },
                { item = 'glass',      chance = 20, min = 1, max = 2, xp = 1 },
            },
        },
        [2] = {
            lootCount = { min = 2, max = 3 },
            items = {
                { item = 'metalscrap', chance = 45, min = 3, max = 5, xp = 1 },
                { item = 'copper',     chance = 35, min = 2, max = 4, xp = 2 },
                { item = 'aluminum',   chance = 30, min = 2, max = 3, xp = 3 },
                { item = 'plastic',    chance = 30, min = 1, max = 4, xp = 1 },
                { item = 'iron',       chance = 25, min = 1, max = 3, xp = 2 },
                { item = 'steel',      chance = 18, min = 1, max = 2, xp = 5 },
                { item = 'rubber',     chance = 22, min = 1, max = 2, xp = 1 },
                { item = 'glass',      chance = 20, min = 1, max = 2, xp = 1 },
            },
        },
        [3] = {
            lootCount = { min = 2, max = 3 },
            items = {
                { item = 'copper',         chance = 40, min = 3, max = 6, xp = 2 },
                { item = 'metalscrap',     chance = 35, min = 4, max = 6, xp = 1 },
                { item = 'aluminum',       chance = 30, min = 2, max = 4, xp = 3 },
                { item = 'steel',          chance = 22, min = 2, max = 3, xp = 5 },
                { item = 'iron',           chance = 22, min = 2, max = 3, xp = 2 },
                { item = 'plastic',        chance = 25, min = 1, max = 4, xp = 1 },
                { item = 'rubber',         chance = 20, min = 1, max = 2, xp = 1 },
                { item = 'glass',          chance = 18, min = 1, max = 2, xp = 1 },
                { item = 'platinum_chunk', chance = 8,  min = 1, max = 1, xp = 20 },
            },
        },
    },
}
