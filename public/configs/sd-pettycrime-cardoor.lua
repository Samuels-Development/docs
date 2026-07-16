return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- ============================================================================
    -- Vehicle door theft. The player aims a saw at a specific door of a parked
    -- vehicle (ox_target attaches a per-door option to each door bone), runs the
    -- saw animation + sparks, and the door is cut off (SetVehicleDoorBroken). Each
    -- door is independent — a four-door car can lose all four. Reuses the same saw
    -- prop/animation/FX as sd-dumpsters' locked-dumpster cut.
    -- ============================================================================

    -- Skill-check minigame run before the saw. Enable = false to skip it. Swap
    -- `tracking` for any other minigame.* (see client/minigame.lua) or your own
    -- function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.tracking({
                catchRadius     = 46,
                holdDurationSec = 2.0,
                targetSpeed     = 130,
                timeLimitSec    = 12,
            }).success
        end,
    },

    Cooldown = 30, -- Per-plate-per-door cooldown (minutes) before the same door can be hit again.
    Items = { 'powersaw', 'anglegrinder', 'bolt_cutter', 'WEAPON_HATCHET' }, -- Cutting tools (any one is enough).

    -- Tool wear for car doors (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful door cut. WEAPON_* tools in Items only wear
    -- while ToolWear.IncludeWeapons is on. The two values here are the FALLBACK
    -- amounts; each Doors entry below can override them per door via its own
    -- `drain` / `breakChance`.
    --
    -- ToolDrain is the DEFAULT method (durability): the used tool loses this many
    -- points per door and breaks once it hits 0. Active while
    -- ToolWear.Durability.Enable is on (the default).
    ToolDrain = 8,

    -- ToolBreakChance is the OPTIONAL alternative (random break): a flat % chance
    -- to break the used tool outright on a door cut, independent of durability.
    -- Active only while ToolWear.BreakChance.Enable is on (off by default).
    ToolBreakChance = 10,

    ShowTargetWithoutItem = false, -- Show the target even without a required tool (false = only show when you have one). The action still requires the tool.
    Time = 12,     -- Seconds to saw a door off (progress bar duration).
    BaseXP = 15,
    GiveXPForItems = true,
    Logging = true,

    -- The doors the option is offered on. `bone` is the GTA V vehicle door bone
    -- ox_target attaches to; `index` is the door index passed to
    -- SetVehicleDoorBroken / IsVehicleDoorDamaged. Cars missing a bone (e.g. a
    -- two-door has no rear bones) simply never show that option.
    Doors = {
        -- `drain` / `breakChance` are optional per-door tool-wear overrides; omit
        -- either to fall back to ToolDrain / ToolBreakChance above.
        { bone = 'door_dside_f', index = 0, drain = 8, breakChance = 10 }, -- front left (driver)
        { bone = 'door_pside_f', index = 1, drain = 8, breakChance = 10 }, -- front right (passenger)
        { bone = 'door_dside_r', index = 2, drain = 8, breakChance = 10 }, -- rear left
        { bone = 'door_pside_r', index = 3, drain = 8, breakChance = 10 }, -- rear right
    },

    -- Vehicle classes the option refuses to attach to. Mirrors catalytic's list.
    IgnoreClasses = {
        [8]  = true, -- Motorcycles (no doors)
        [13] = true, -- Cycles
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
    IgnoreModels = {
        -- ['emperor'] = true,
    },

    PoliceAlert = {
        Enable = true,
        Chance = 45,
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21A',
                title       = 'Vehicle Theft',
                message     = 'Vehicle door theft reported',
                description = 'Vehicle door theft reported',
                blipText    = '911 - Vehicle Theft',
                sprite      = 380,
                colour      = 1,
                scale       = 1.2,
            })
        end,
    },

    -- Per-level loot count now lives in each Rewards level bucket below (lootCount).

    -- A cut-off door is mostly scrap metal; higher levels add a chance at
    -- reusable parts. Make sure every item here exists in your inventory.
    -- Any reward row below can take `guaranteed = true` to always be granted
    -- (its `chance` is ignored); it fills one lootCount slot while the rest roll
    -- normally. Supported in every reward table routed through server/rewards.lua.
    Rewards = {
        [1] = {
            lootCount = { min = 1, max = 2 },
            items = {
                { item = 'metalscrap', chance = 80, min = 1, max = 2, xp = 2 },
                { item = 'plastic',    chance = 20, min = 1, max = 2, xp = 1 },
            },
        },
        [2] = {
            lootCount = { min = 1, max = 2 },
            items = {
                { item = 'metalscrap', chance = 75, min = 2, max = 3, xp = 2 },
                { item = 'plastic',    chance = 15, min = 1, max = 3, xp = 1 },
                { item = 'steel',      chance = 10, min = 1, max = 2, xp = 5 },
            },
        },
        [3] = {
            lootCount = { min = 1, max = 2 },
            items = {
                { item = 'metalscrap', chance = 70, min = 2, max = 4, xp = 2 },
                { item = 'steel',      chance = 18, min = 1, max = 2, xp = 5 },
                { item = 'aluminum',   chance = 12, min = 1, max = 3, xp = 3 },
            },
        },
    },
}
