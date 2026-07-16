return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    Time = 5,              -- (Legacy) progress-bar duration — unused since the minigame replaced it. Kept for compat with any third-party readers.
    Chance = 75,           -- (Legacy) overall % chance to find anything — superseded by the minigame outcome.
    BaseXP = 8,            -- Base XP awarded on every successful pick.

    -- When true, the target ped is tasked to stand still for the duration of the
    -- attempt so it doesn't wander off while you stand there picking its pocket.
    -- The hold is released once the attempt resolves (or the ped flees if caught).
    FreezeTarget = true,

    -- Minigame selector. `Start` runs when a pickpocket attempt begins; it
    -- receives ctx (ctx.items = the server-rolled REAL loot slots, each
    -- carrying its own rarity-sized zone) and returns the minigame result.
    -- Swap the body for any other built-in (see client/minigame.lua: lockpick,
    -- lockpickBar, holdSteady, mash, stealth, dial, wires, sequence) or your
    -- own — without touching the crime code. Set Enable = false to skip it.
    --
    -- Note: only mg.pickpocket reports which slots were grabbed (partial
    -- loot). Other minigames are pass/fail, so on success the player gets all
    -- rolled items, otherwise none.
    Minigame = {
        Enable = true,
        Start = function(ctx)
            return Minigames.pickpocket({
                items               = ctx.items, -- real loot slots; count + rarity rolled server-side per tier/level
                -- Extra EMPTY "???" decoy slots shuffled in among the real loot.
                -- They look identical until grabbed, then reveal as empty and
                -- give nothing (pure time-sink). Randomised per attempt;
                -- { min = 0, max = 0 } disables them. (How many REAL items show,
                -- and how rare they are, is set per tier/level in Tiers below.)
                emptySlots          = { min = 1, max = 3 },
                -- Grab-zone width per slot, in degrees of the marker's full pass
                -- (360°). Scales on rarity: the rarest rolled item gets `min`
                -- (hardest), the most common gets `max` (easiest); empty decoys
                -- use `max`. Widen the spread for an easier game, narrow it for a
                -- harder one. A plain number (e.g. 30) gives every slot the same
                -- width (no rarity scaling).
                grabZoneDeg         = { min = 12, max = 34 },
                -- Marker speed in deg/sec (360° = one full pass across the bar).
                rotationSpeedDegSec = 180,
                -- Speed up (and flip direction) after each successful grab.
                -- false = constant speed, only the direction flips.
                speedUp             = true,
                -- Speed multiplier per grab — only applied when speedUp = true.
                speedUpMultiplier   = 1.35,
                -- Time limit in seconds; running out = caught. 0 = no limit.
                timeLimitSec        = 15,
                -- Per-item chance (0..1) a REAL card starts hidden as "???"
                -- (empty slots are always hidden until grabbed).
                mysteryChance       = 0.5,
            })
        end,
    },
    GiveXPForItems = true, -- Adds the per-item XP value when an item drops.
    GiveXPForCash = true,  -- Adds 1 XP per $ stolen (set false for flat per-pick XP).
    Logging = true,        -- lib.logger entries on success/fail.

    PoliceAlert = {
        Enable = true,
        Chance = 15, -- 0-100 chance an alert fires on a successful pick.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-15',
                title       = 'Pickpocketing',
                message     = 'Pickpocketing reported',
                description = 'Pickpocketing reported',
                blipText    = '911 - Pickpocketing',
                sprite      = 431,
                colour      = 3,
                scale       = 1.2,
            })
        end,
    },

    -- Tiered loot tables. Each tier carries its own cash range *and* a level-
    -- keyed bucket (`[1]`, `[2]`, `[3]`). Each level bucket has:
    --   lootCount : { min, max } — how many REAL loot slots to roll for a player
    --               at that level in this tier (each becomes a card + grab zone).
    --   items     : the weighted pool the slots are drawn from (duplicates ok).
    --
    -- HOW WEIGHTED CHANCE WORKS
    -- The `chance` field is a *weight*, not a percentage — higher weight =
    -- proportionally more likely, AND it sizes the grab zone (rarer = smaller).
    -- e.g. `chance=20` is twice as likely as `chance=10` in the same bucket.
    Tiers = {
        low = {
            cash = { min = 4, max = 15 },
            [1] = {
                lootCount = { min = 2, max = 3 },
                items = {
                    { item = 'metalscrap', chance = 25, min = 1, max = 2, xp = 1 },
                    { item = 'copper',     chance = 15, min = 1, max = 1, xp = 2 },
                },
            },
            [2] = {
                lootCount = { min = 2, max = 4 },
                items = {
                    { item = 'metalscrap', chance = 20, min = 2, max = 3, xp = 1 },
                    { item = 'copper',     chance = 15, min = 1, max = 2, xp = 2 },
                    { item = 'aluminum',   chance = 10, min = 1, max = 1, xp = 3 },
                },
            },
            [3] = {
                lootCount = { min = 3, max = 5 },
                items = {
                    { item = 'metalscrap', chance = 18, min = 3, max = 4, xp = 1 },
                    { item = 'copper',     chance = 15, min = 2, max = 3, xp = 2 },
                    { item = 'aluminum',   chance = 12, min = 1, max = 2, xp = 3 },
                    { item = 'steel',      chance = 8,  min = 1, max = 1, xp = 5 },
                },
            },
        },
        medium = {
            cash = { min = 12, max = 32 },
            [1] = {
                lootCount = { min = 1, max = 2 },
                items = {
                    { item = 'rolex', chance = 15, min = 1, max = 1, xp = 8 },
                    { item = 'phone', chance = 20, min = 1, max = 1, xp = 6 },
                },
            },
            [2] = {
                lootCount = { min = 2, max = 3 },
                items = {
                    { item = 'rolex',     chance = 18, min = 1, max = 2, xp = 8  },
                    { item = 'phone',     chance = 15, min = 1, max = 1, xp = 6  },
                    { item = 'goldchain', chance = 12, min = 1, max = 1, xp = 10 },
                },
            },
            [3] = {
                lootCount = { min = 2, max = 4 },
                items = {
                    { item = 'rolex',     chance = 20, min = 1, max = 3, xp = 8  },
                    { item = 'phone',     chance = 15, min = 1, max = 2, xp = 6  },
                    { item = 'goldchain', chance = 15, min = 1, max = 2, xp = 10 },
                    { item = 'laptop',    chance = 10, min = 1, max = 1, xp = 12 },
                },
            },
        },
        high = {
            cash = { min = 25, max = 65 },
            [1] = {
                lootCount = { min = 1, max = 2 },
                items = {
                    { item = 'diamond_ring', chance = 12, min = 1, max = 1, xp = 15 },
                    { item = 'goldchain',    chance = 18, min = 1, max = 1, xp = 10 },
                },
            },
            [2] = {
                lootCount = { min = 1, max = 3 },
                items = {
                    { item = 'diamond_ring', chance = 15, min = 1, max = 1, xp = 15 },
                    { item = 'goldchain',    chance = 15, min = 1, max = 2, xp = 10 },
                    { item = '10kgoldchain', chance = 10, min = 1, max = 1, xp = 20 },
                },
            },
            [3] = {
                lootCount = { min = 2, max = 4 },
                items = {
                    { item = 'diamond_ring', chance = 18, min = 1, max = 2, xp = 15 },
                    { item = 'goldchain',    chance = 15, min = 2, max = 3, xp = 10 },
                    { item = '10kgoldchain', chance = 12, min = 1, max = 2, xp = 20 },
                    { item = 'diamond',      chance = 8,  min = 1, max = 1, xp = 25 },
                },
            },
        },
    },

    -- Zones grouped by tier. Keys are GTA's `GetNameOfZone()` short codes —
    -- they have to match the engine return values exactly. Anything *not*
    -- listed defaults to the `low` tier, so leaving a zone off gives it
    -- the cheapest loot pool rather than no loot at all.
    --
    -- Re-tiering a zone is a one-line move between arrays.
    ZoneTiers = {
        high = {
            'ROCKF',   -- Rockford Hills
            'CHIL',    -- Vinewood Hills
            'HAWICK',  -- Hawick
            'PBLUFF',  -- Pacific Bluffs
            'TONGVAH', -- Tongva Hills
            'RGLEN',   -- Richman Glen
            'RICHM',   -- Richman
            'HORS',    -- Vinewood Racetrack
            'STAD',    -- Maze Bank Arena
            'MOVIE',   -- Richards Majestic
            'BHAMCA',  -- Banham Canyon
            'GOLF',    -- GWC and Golfing Society
        },
        medium = {
            'AIRP',    -- Los Santos International Airport
            'BEACH',   -- Vespucci Beach
            'DELBE',   -- Del Perro Beach
            'DELPE',   -- Del Perro
            'MIRR',    -- Mirror Park
            'MORN',    -- Morningwood
            'ALTA',    -- Alta
            'BURTON',  -- Burton
            'PBOX',    -- Pillbox Hill
            'LEGSQU',  -- Legion Square
            'KOREAT',  -- Little Seoul
            'VINE',    -- Vinewood
            'WVINE',   -- West Vinewood
            'DTVINE',  -- Downtown Vinewood
            'EAST_V',  -- East Vinewood
            'DOWNT',   -- Downtown
            'TEXTI',   -- Textile City
            'HARMO',   -- Harmony
        },
        -- Everything else (Davis, Strawberry, Chamberlain, El Burro, Stab
        -- City, Sandy Shores, Grapeseed, Paleto, the wilds, etc.) falls
        -- through to the `low` tier automatically. Promote a zone by
        -- adding its short code to one of the lists above.
    },
}
