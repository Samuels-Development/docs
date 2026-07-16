return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    Cooldown = 2, -- Cooldown until a mailbox is robbable again. (in minutes)
    Items = { 'WEAPON_HAMMER' }, -- Tools (any one is enough) — used to smash the mailbox open.

    -- Tool wear for this crime (how it works + the master switches live in
    -- config.lua under ToolWear). The tool that wears is the one the player
    -- actually used (their lowest-durability matching tool from Items above), and
    -- it only happens on a successful mailbox robbery. WEAPON_* tools in Items
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
    Time = 15, -- Time in seconds it takes to look for loot in a mailbox. (progressbar time)
    BaseXP = 15, -- Base XP awarded for successful mailbox robbery
    GiveXPForItems = true, -- Whether to give additional XP based on items received
    Models = { -- Props to create interaction points for
        'prop_letterbox_01',
        'prop_letterbox_02',
        'prop_letterbox_03',
        'prop_letterbox_04',
    },
    Logging = true, -- Enables lib.logger usage for this action. Will log a players source, character name and identifier as well as the action they took and the items and cash they received from it.
    Minigame = {
        Enable = true, -- Enable/disable custom minigame (if false, no minigame will be used)
        Start = function()
            -- Runs a built-in minigame and returns pass/fail. Swap `mash` for
            -- any other minigame.* (see client/minigame.lua for the full list)
            -- or your own function that returns true/false. Tune below.
            return Minigames.mash({
                fillPerTap   = 0.08, -- bar gained per E tap (0..1)
                decayPerSec  = 0.4,  -- bar lost per second (0..1)
                timeLimitSec = 6,    -- seconds to fill it; 0 = no limit
            }).success
        end,
    },
    PoliceAlert = {
        Enable = true, -- Enable/disable police alerts for mailbox robberies
        Chance = 25, -- Percentage chance (0-100) that police will be alerted
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-15',
                title       = 'Mail Theft',
                message     = 'Mailbox tampering reported',
                description = 'Mailbox tampering reported',
                blipText    = '911 - Mail Theft',
                sprite      = 431,
                colour      = 3,
                scale       = 1.2,
            })
        end,
    },

    -- The openable item mailbox robberies hand out, and the loot pool it rolls
    -- into. Self-contained here (no longer the shared `package`). Made usable on
    -- the server via the inventory bridge; its ox_inventory entry points
    -- `server.export` at `sd-pettycrime.useMail_package`.
    --   OpenTime  : seconds for the open-package progress bar.
    --   LootCount : distinct items rolled per open (no repeats). Every open yields loot.
    Package = {
        Item         = 'mail_package',
        OpenTime     = 2,
        LootCount    = { min = 1, max = 2 },
        -- Any reward row below can take `guaranteed = true` to always be granted
        -- (its `chance` is ignored); it fills one LootCount slot while the rest
        -- roll normally. (Handled by the package loot roller in server/packages.lua.)
        Rewards = {
            { item = 'lockpick',      chance = 22, min = 1, max = 2 },
            { item = 'phone',         chance = 18, min = 1, max = 1 },
            { item = 'goldchain',     chance = 16, min = 1, max = 1 },
            { item = 'purse',         chance = 16, min = 1, max = 1 },
            { item = 'gold_watch',    chance = 14, min = 1, max = 1 },
            { item = 'rolex',         chance = 10, min = 1, max = 1 },
            { item = 'gang-keychain', chance = 8,  min = 1, max = 1 },
            { item = '10kgoldchain',  chance = 5,  min = 1, max = 1 },
            { item = 'goldbar',       chance = 3,  min = 1, max = 1 },
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

        -- Carry animation: while holding this package the player carries the prop
        -- with movement controls locked. Enable = false to skip the forced carry.
        Carry = {
            Enable = true,
            Prop   = 'prop_cs_package_01',
        },
    },

    -- Per-level loot count now lives in each Rewards level bucket below (lootCount).

    -- Any reward row below can take `guaranteed = true` to always be granted
    -- (its `chance` is ignored); it fills one lootCount slot while the rest roll
    -- normally. Supported in every reward table routed through server/rewards.lua.
    Rewards = { -- Level-based rewards from robbing mailboxes
        -- HOW WEIGHTED CHANCE WORKS:
        -- The "chance" number is like putting that many tickets in a hat.
        -- Higher chance = more tickets = more likely to be picked.
        -- 
        -- Example: cash=10, laptop=50, rolex=25, package=25 tickets
        -- Total tickets in hat = 110 tickets
        -- laptop has 50/110 = 45% chance to be picked
        -- cash has 10/110 = 9% chance to be picked
        -- rolex and package each have 25/110 = 23% chance
        --
        -- You can use any numbers you want - 1, 100, 1000, etc.
        -- What matters is the ratio between them!
        
        [1] = { -- Level 1 rewards (basic)
            lootCount = { min = 1, max = 1 },
            items = {
                {item = "cash", chance = 15, min = 3, max = 8, xp = 0},
                {item = "mail_package", chance = 30, min = 1, max = 1, xp = 5},
                {item = "metalscrap", chance = 25, min = 1, max = 2, xp = 2},
            },
        },
        [2] = { -- Level 2 rewards (improved)
            lootCount = { min = 1, max = 1 },
            items = {
                {item = "cash", chance = 12, min = 8, max = 15, xp = 0},
                {item = "laptop", chance = 20, min = 1, max = 1, xp = 12},
                {item = "rolex", chance = 15, min = 1, max = 1, xp = 8},
                {item = "mail_package", chance = 25, min = 1, max = 2, xp = 5},
            },
        },
        [3] = { -- Level 3 rewards (advanced)
            lootCount = { min = 1, max = 1 },
            items = {
                {item = "cash", chance = 10, min = 15, max = 25, xp = 0},
                {item = "laptop", chance = 25, min = 1, max = 2, xp = 12},
                {item = "rolex", chance = 20, min = 1, max = 2, xp = 8},
                {item = "goldchain", chance = 15, min = 1, max = 1, xp = 15},
                {item = "mail_package", chance = 20, min = 2, max = 3, xp = 5},
            },
        },
    },
}
