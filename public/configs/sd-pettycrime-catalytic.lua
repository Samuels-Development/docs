return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run before the saw. Enable = false to skip it. Swap
    -- `tracking` for any other minigame.* (see client/minigame.lua) or your own
    -- function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.tracking({
                catchRadius     = 46,  -- on-target radius (px)
                holdDurationSec = 2.5, -- on-target focus needed to win
                targetSpeed     = 140, -- target wander speed (px/sec)
                timeLimitSec    = 12,  -- seconds before caught; 0 = no limit
            }).success
        end,
    },

    Cooldown = 30, -- Per-plate cooldown until the same vehicle can be hit again. (in minutes)
    Items = { 'powersaw', 'anglegrinder', 'oxycutter', 'bolt_cutter', 'WEAPON_HATCHET' }, -- Cutting tools (any one is enough)

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful converter theft. WEAPON_* tools in Items
    -- only wear while ToolWear.IncludeWeapons is on.
    --
    -- ToolDrain is the DEFAULT method (durability): the used tool loses this many
    -- points each success and breaks once it hits 0. Active while
    -- ToolWear.Durability.Enable is on (the default).
    ToolDrain = 10,

    -- ToolBreakChance is the OPTIONAL alternative (random break): a flat % chance
    -- to break the used tool outright on a success, independent of durability.
    -- Active only while ToolWear.BreakChance.Enable is on (off by default).
    ToolBreakChance = 10,

    ShowTargetWithoutItem = false, -- Show the target even without a required tool (false = only show when you have one). The action still requires the tool.
    CheckTime = 4, -- Stage 1 — seconds spent "checking around" before committing to the saw.
    Time = 18, -- Stage 2 — seconds it takes to saw the converter off (progress bar duration).

    -- Where along the car the under-vehicle saw pose sits: 0 = longitudinal
    -- middle, 1 = front bumper. Catalytic converters sit forward on the
    -- undercarriage near the engine, so the thief lies further toward the front
    -- than dead-centre. 0.45 lands roughly under the front footwell.
    UnderVehicleForwardBias = 0.45,

    -- What a stolen converter leaves behind on the victim's car. The first person
    -- to drive it is warned (engine light, loud exhaust, the smell), and the
    -- engine is left damaged so it runs a little rough until repaired.
    VictimEffect = {
        Enable              = true,
        EngineDamagePercent = 20, -- Caps the engine at (100 - this)% health on theft (20 = left at 80%). 0 = no engine damage.
    },

    BaseXP = 35, -- Base XP awarded for successful catalytic converter theft
    GiveXPForItems = true, -- Whether to give additional XP based on items received
    Logging = true, -- Enables lib.logger usage for this action.

    -- Vehicle classes the target option will refuse to attach to. Maps to the
    -- result of `GetVehicleClass(vehicle)` — see https://docs.fivem.net/natives/?_0x29439776AAA00A62
    -- Default skips emergency / utility / aircraft / boats / military.
    IgnoreClasses = {
        [13] = true, -- Cycles (you can't really put a converter on a bike)
        [14] = true, -- Boats
        [15] = true, -- Helicopters
        [16] = true, -- Planes
        [17] = true, -- Service (taxi, bus, ambulance)
        [18] = true, -- Emergency (police, fire)
        [19] = true, -- Military
        [21] = true, -- Trains
        [22] = true, -- Open Wheel (F1)
    },

    -- Pre-hashed model exemption list — civilian models you don't want eligible.
    -- Empty by default; populate with specific models you want to protect.
    IgnoreModels = {
        -- ['emperor'] = true,
    },

    PoliceAlert = {
        Enable = true, -- Enable/disable police alerts for catalytic converter thefts
        Chance = 50, -- Percentage chance (0-100) that police will be alerted
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21A',
                title       = 'Vehicle Theft',
                message     = 'Catalytic converter theft reported',
                description = 'Catalytic converter theft reported',
                blipText    = '911 - Cat Theft',
                sprite      = 380,
                colour      = 1,
                scale       = 1.2,
            })
        end,
    },

    -- Loot bucket per player level. Same shape as mailbox PackageRewards. Each
    -- level has a `lootCount` (how many DISTINCT items it rolls) and an `items`
    -- pool drawn from by weighted `chance`.
    --
    -- guaranteed = true on a row means that item is ALWAYS granted (its `chance`
    -- is ignored). It takes one of the lootCount slots; the rest are filled by
    -- the normal weighted roll. That's how the catalytic converter below is
    -- always handed out while bonus parts still roll for the remaining slot(s).
    -- This flag works in ANY crime's reward table (it lives in the shared rewards
    -- roller, server/rewards.lua), not just here.

    Rewards = {
        [1] = { -- Level 1 rewards (basic)
            lootCount = { min = 2, max = 2 },
            items = {
                { item = 'catalytic_converter', chance = 80, min = 1, max = 1, xp = 8, guaranteed = true },
                { item = 'metalscrap',          chance = 20, min = 2, max = 4, xp = 1 },
            },
        },
        [2] = { -- Level 2 rewards (improved)
            lootCount = { min = 2, max = 2 },
            items = {
                { item = 'catalytic_converter', chance = 70, min = 1, max = 1, xp = 8, guaranteed = true },
                { item = 'metalscrap',          chance = 20, min = 3, max = 5, xp = 1 },
            },
        },
        [3] = { -- Level 3 rewards (advanced)
            -- Converter is guaranteed; max 2 lets one bonus part roll on top of it.
            lootCount = { min = 1, max = 2 },
            items = {
                { item = 'catalytic_converter', chance = 60, min = 1, max = 2, xp = 8, guaranteed = true },
                { item = 'metalscrap',          chance = 18, min = 4, max = 6, xp = 1 },
                { item = 'oxygen_sensor',       chance = 18, min = 1, max = 1, xp = 12 },
                { item = 'platinum_chunk',      chance = 8,  min = 1, max = 1, xp = 20 },
            },
        },
    },
}
