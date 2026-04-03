return {
    -- Debug prints (enables console debug messages)
    DebugPrints = false,

    -- Debug zones/targets (enables visual debug for zones and target spheres)
    DebugZones = false,

    -- Locale configuration
    Locale = "en", -- Language for translations (en, es, de, etc.)

    -- UI Accent Color (hex color without #, used for HUD elements, shop, etc.)
    -- Examples: "d97706" (orange/amber - default), "3b82f6" (blue), "10b981" (green), "ef4444" (red), "8b5cf6" (purple) "ec4899"" (pink)
    AccentColor = "d97706",

    -- Maps to load (file names in configs/maps without .lua extension)
    Maps = {
        'server_farm',
        'cayo_estate',
        'doomsday_bunker',
        'gunrunning_bunker'
    },

    -- Cooldown configuration
    Cooldown = {
        enabled = true, -- If true, players will be put on cooldown after completing a horde
        duration = 60, -- Cooldown duration in minutes (e.g., 60 = 1 hour)
    },

    -- Restart restriction configuration (txAdmin scheduled restart integration)
    -- When enabled, ends all games and blocks new ones before server restart
    RestartRestrict = {
        enabled = true, -- If true, games will be ended and blocked before scheduled restarts
        blockNewGamesTime = 1800, -- Seconds before restart to block new games / ped interaction (1800 = 30 minutes)
        endActiveGamesTime = 600, -- Seconds before restart to end active/pending games (600 = 10 minutes)
    },

    -- Rejoin system configuration (allows players to rejoin after disconnect)
    RejoinSystem = {
        enabled = true,                 -- Master toggle for the entire rejoin system
        allowRejoin = true,             -- Allow individual players to rejoin after disconnect
        rejoinTimeout = 300,            -- Seconds a player has to rejoin (5 minutes)
        pauseOnEmpty = true,            -- Pause game instead of ending when all players disconnect
        pauseTimeout = 120,             -- Seconds game stays paused waiting for rejoin (10 minutes)
        resumeCountdown = 10,           -- Seconds countdown before game resumes after rejoin (if it was in paused state)
        resumeEnemyDelay = 1000,        -- Milliseconds delay before enemies start attacking after game resumes (gives players time to react)
        deadPlayerTimeout = 120,        -- Seconds before game ends when only dead players remain after alive players disconnect (2 minutes)
    },

    -- Inventory configuration
    ConfiscateInventory = true, -- If true, player's inventory is confiscated when entering horde and returned when leaving
    ManualInventoryReturn = true, -- If true, adds a target option on the ped to manually return confiscated inventory (fallback for crashes)

    -- Inventory restrictions during horde (prevents item exploit where players drop items outside zone)
    -- Note: Only works with ox_inventory. Other inventories don't support external hooks or the prevention of giving/dropping items entirely.
    InventoryRestrictions = {
        preventDrop = true, -- If true, players cannot drop items during a horde game
        preventGive = true, -- If true, players cannot give items to other players during a horde game
    },

    -- Zone exit timeout (seconds before player is kicked when leaving the play area)
    -- Set to 0 for instant kick, or any number of seconds for a grace period
    ZoneExitTimeout = 3,

    -- Group system configuration
    MaxGroupMembers = 4, -- Maximum number of players allowed in a group (including the leader). Set to 0 for unlimited.

    -- Friendly fire configuration
    FriendlyFire = false, -- If true, players can damage each other during horde. If false, players cannot damage teammates.

    -- Revive on exit configuration
    ReviveOnExit = true, -- If true, players will be revived when they leave/are kicked from a horde game

    -- Shop Revive configuration (revive dead teammates from the shop menu)
    ShopRevive = {
        enabled = true, -- If true, players can revive dead teammates from the shop menu for points
        cost = 5000, -- Cost in points to revive a teammate
    },

    -- Starting loadout given to players when entering horde
    StartingLoadout = {
        enabled = true, -- If true, give players the starting loadout when they enter horde
        items = {
            { name = "WEAPON_PISTOL", count = 1 },
            { name = "ammo-9", count = 200 },
            { name = "bandage", count = 10 },
            { name = "oxy", count = 10 },
            { name = "burger", count = 3 },
            { name = "water", count = 3 },
            { name = "radio", count = 1 },
        },
    },

    -- Radio sync configuration (requires pma-voice)
    -- Channel allocation priority: useChannelPool > useRandomChannel > channelOffset
    RadioSync = {
        enabled = true, -- If true, all players in a horde game will be set to the same radio frequency
        
        useChannelPool = false, -- If true, use a predefined pool of channels
        channelPool = { 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010 }, -- Pool of available radio channels (only used if useChannelPool = true)

        useRandomChannel = true, -- If true (and useChannelPool = false), generate a random channel between randomMin and randomMax
        randomMin = 100000, -- Minimum random channel value (only used if useRandomChannel = true)
        randomMax = 999999, -- Maximum random channel value (only used if useRandomChannel = true)

        channelOffset = 1000, -- Radio channel = gameIdCounter + offset (only used if useChannelPool = false and useRandomChannel = false)
    },

    -- Level System Configuration
    LevelSystem = {
        -- XP required to reach each level (index = level)
        levels = {
            [1] = 0,          -- Starting level
            [2] = 100,
            [3] = 250,
            [4] = 450,
            [5] = 700,
            [6] = 1000,
            [7] = 1400,
            [8] = 1900,
            [9] = 2500,
            [10] = 3200,
            [11] = 4000,
            [12] = 5000,
            [13] = 6200,
            [14] = 7600,
            [15] = 9200,
            [16] = 11000,
            [17] = 13000,
            [18] = 15500,
            [19] = 18500,
            [20] = 22000,
            -- Add more levels as needed
        },
        -- XP rewards
        xpRewards = {
            enemyKill = 10,               -- XP per enemy killed
            roundComplete = 50,           -- XP per round completed
            hordeComplete = 200,          -- XP for completing a full horde
            lootDeposit = 5,              -- XP per loot deposited
        },
    },

    -- Ped configuration (spawns via ox_lib point proximity)
    -- You can use EITHER Ped, Zone, or BOTH for horde entry
    Ped = {
        enabled = true,                              -- Enable/disable ped spawning
        model = 'g_m_y_lost_01',                     -- Ped model (use any valid ped model)
        coords = vector4(705.81, -966.72, 29.41, 304.76), -- Spawn location (x, y, z, heading)
        spawnDistance = 50.0,                        -- Distance to spawn ped (in units)
        despawnDistance = 60.0,                      -- Distance to despawn ped (should be > spawnDistance)
        scenario = 'WORLD_HUMAN_SMOKING',            -- Ped scenario/animation (nil to disable)
        invincible = true,                           -- Make ped invincible
        freeze = true,                               -- Freeze ped in place
        blockEvents = true,                          -- Block ped from reacting to events
        -- ox_target options for the ped
        target = {
            enabled = true,                          -- Enable target on ped
            icon = 'fas fa-comments',                -- Target icon (Font Awesome)
            label = 'Talk',                          -- Target label
            distance = 2.5,                          -- Interaction distance
            -- You can add custom action here or override in code
        }
    },

    -- Zone-only configuration (target zone without a ped)
    -- Use this if you want a target location instead of/in addition to a ped
    Zone = {
        enabled = false,                             -- Enable/disable zone target (set to true and Ped.enabled to false for zone-only)
        coords = vector3(707.32, -967.67, 30.48),    -- Zone center location (x, y, z)
        size = vector3(1.5, 1.5, 2.0),               -- Zone size (width, depth, height)
        rotation = 0.0,                              -- Zone rotation in degrees
        debug = false,                               -- Show debug zone outline (useful for positioning)
        -- ox_target options for the zone
        target = {
            icon = 'fas fa-skull-crossbones',        -- Target icon (Font Awesome)
            label = 'Horde Mode',                    -- Target label (shown in target menu)
            distance = 2.5,                          -- Interaction distance
        }
    },

    -- ============================================
    -- WEAPON DISPLAY MODELS (Mystery Box)
    -- ============================================
    -- Maps weapon names to their prop models for the mystery box weapon display
    -- Add new weapons here to show them properly in the mystery box animation
    -- The key is the weapon name (lowercase), the value is the prop model name
    -- If a weapon is not listed, it will use the fallback model (w_pi_pistol)
    WeaponDisplayModels = {
        -- Pistols
        ["weapon_pistol"] = "w_pi_pistol",
        ["weapon_combatpistol"] = "w_pi_combatpistol",
        ["weapon_pistol_mk2"] = "w_pi_pistol_mk2",
        ["weapon_appistol"] = "w_pi_appistol",
        ["weapon_snspistol"] = "w_pi_sns_pistol",
        ["weapon_vintagepistol"] = "w_pi_vintage_pistol",
        ["weapon_heavypistol"] = "w_pi_heavypistol",
        ["weapon_ceramicpistol"] = "w_pi_ceramic_pistol",
        ["weapon_pistol50"] = "w_pi_pistol50",

        -- Machine Pistols
        ["weapon_machinepistol"] = "w_sb_compactsmg",

        -- SMGs
        ["weapon_microsmg"] = "w_sb_microsmg",
        ["weapon_smg"] = "w_sb_smg",
        ["weapon_smg_mk2"] = "w_sb_smg_mk2",
        ["weapon_minismg"] = "w_sb_minismg",
        ["weapon_combatpdw"] = "w_sb_pdw",

        -- Shotguns
        ["weapon_pumpshotgun"] = "w_sg_pumpshotgun",
        ["weapon_pumpshotgun_mk2"] = "w_sg_pumpshotgunmk2",
        ["weapon_sawnoffshotgun"] = "w_sg_sawnoff",
        ["weapon_dbshotgun"] = "w_sg_doublebarrel",
        ["weapon_assaultshotgun"] = "w_sg_assaultshotgun",
        ["weapon_combatshotgun"] = "w_sg_pumpshotgunh4",
        ["weapon_heavyshotgun"] = "w_sg_heavyshotgun",

        -- Assault Rifles
        ["weapon_carbinerifle"] = "w_ar_carbinerifle",
        ["weapon_carbinerifle_mk2"] = "w_ar_carbineriflemk2",
        ["weapon_assaultrifle"] = "w_ar_assaultrifle",
        ["weapon_assaultrifle_mk2"] = "w_ar_assaultriflemk2",
        ["weapon_specialcarbine"] = "w_ar_specialcarbine",
        ["weapon_specialcarbine_mk2"] = "w_ar_specialcarbinemk2",
        ["weapon_bullpuprifle"] = "w_ar_bullpuprifle",
        ["weapon_bullpuprifle_mk2"] = "w_ar_bullpupriflemk2",
        ["weapon_advancedrifle"] = "w_ar_advancedrifle",
        ["weapon_militaryrifle"] = "w_ar_bullpuprifleh4",
        ["weapon_compactrifle"] = "w_ar_assaultrifle_smg",
        ["weapon_tacticalrifle"] = "w_ar_carbinerifle",

        -- Machine Guns
        ["weapon_combatmg"] = "w_mg_combatmg",
        ["weapon_combatmg_mk2"] = "w_mg_combatmgmk2",
        ["weapon_mg"] = "w_mg_mg",
        ["weapon_gusenberg"] = "w_sb_gusenberg",

        -- Sniper Rifles
        ["weapon_marksmanrifle"] = "w_sr_marksmanrifle",
        ["weapon_marksmanrifle_mk2"] = "w_sr_marksmanriflemk2",
        ["weapon_sniperrifle"] = "w_sr_sniperrifle",
        ["weapon_heavysniper"] = "w_sr_heavysniper",
        ["weapon_heavysniper_mk2"] = "w_sr_heavysnipermk2",

        -- Heavy Weapons
        ["weapon_rpg"] = "w_lr_rpg",
        ["weapon_minigun"] = "w_mg_minigun",
        ["weapon_grenadelauncher"] = "w_lr_grenadelauncher",
        ["weapon_hominglauncher"] = "w_lr_homing",

        -- Melee (optional - for display in mystery box if added)
        ["weapon_bat"] = "w_me_bat",
        ["weapon_crowbar"] = "w_me_crowbar",
        ["weapon_knife"] = "w_me_knife_01",
        ["weapon_machete"] = "w_me_machette_lr",
        ["weapon_hatchet"] = "w_me_hatchet",
        ["weapon_switchblade"] = "w_me_switchblade",
    },

    -- Fallback model when weapon is not found in WeaponDisplayModels
    WeaponDisplayFallback = "w_pi_pistol",

    -- ============================================
    -- WEAPON AMMO TYPE MAPPING
    -- ============================================
    -- Central config linking weapons to their ammo types
    -- Add your weapons here and they'll automatically link to the correct ammo in shops (use lowercase)
    -- Weapons not listed here (like melee) won't have ammo requirements
    WeaponAmmoTypes = {
        -- Pistols (9mm)
        ["weapon_pistol"] = "ammo-9",
        ["weapon_combatpistol"] = "ammo-9",
        ["weapon_pistol_mk2"] = "ammo-9",
        ["weapon_appistol"] = "ammo-9",
        ["weapon_ceramicpistol"] = "ammo-9",
        ["weapon_vintagepistol"] = "ammo-9",
        ["weapon_machinepistol"] = "ammo-9",

        -- Pistols (.45 ACP)
        ["weapon_heavypistol"] = "ammo-45",
        ["weapon_snspistol"] = "ammo-45",
        ["weapon_snspistol_mk2"] = "ammo-45",
        ["weapon_pistol50"] = "ammo-45",

        -- Revolvers
        ["weapon_revolver"] = "ammo-44",
        ["weapon_revolver_mk2"] = "ammo-44",
        ["weapon_doubleaction"] = "ammo-38",
        ["weapon_navyrevolver"] = "ammo-38",

        -- SMGs (9mm)
        ["weapon_smg"] = "ammo-9",
        ["weapon_smg_mk2"] = "ammo-9",
        ["weapon_combatpdw"] = "ammo-9",
        ["weapon_minismg"] = "ammo-9",

        -- SMGs (.45 ACP)
        ["weapon_microsmg"] = "ammo-45",

        -- Shotguns
        ["weapon_pumpshotgun"] = "ammo-shotgun",
        ["weapon_pumpshotgun_mk2"] = "ammo-shotgun",
        ["weapon_sawnoffshotgun"] = "ammo-shotgun",
        ["weapon_dbshotgun"] = "ammo-shotgun",
        ["weapon_assaultshotgun"] = "ammo-shotgun",
        ["weapon_combatshotgun"] = "ammo-shotgun",
        ["weapon_heavyshotgun"] = "ammo-shotgun",
        ["weapon_musket"] = "ammo-shotgun",

        -- Assault Rifles (5.56)
        ["weapon_carbinerifle"] = "ammo-rifle",
        ["weapon_carbinerifle_mk2"] = "ammo-rifle",
        ["weapon_specialcarbine"] = "ammo-rifle",
        ["weapon_specialcarbine_mk2"] = "ammo-rifle",
        ["weapon_bullpuprifle"] = "ammo-rifle",
        ["weapon_bullpuprifle_mk2"] = "ammo-rifle",
        ["weapon_advancedrifle"] = "ammo-rifle",
        ["weapon_militaryrifle"] = "ammo-rifle",
        ["weapon_tacticalrifle"] = "ammo-rifle",
        ["weapon_heavyrifle"] = "ammo-rifle",

        -- Assault Rifles (7.62)
        ["weapon_assaultrifle"] = "ammo-rifle2",
        ["weapon_assaultrifle_mk2"] = "ammo-rifle2",
        ["weapon_compactrifle"] = "ammo-rifle2",

        -- Machine Guns
        ["weapon_mg"] = "ammo-rifle",
        ["weapon_combatmg"] = "ammo-rifle",
        ["weapon_combatmg_mk2"] = "ammo-rifle",
        ["weapon_gusenberg"] = "ammo-rifle",

        -- Sniper Rifles
        ["weapon_sniperrifle"] = "ammo-sniper",
        ["weapon_heavysniper"] = "ammo-sniper",
        ["weapon_heavysniper_mk2"] = "ammo-sniper",
        ["weapon_marksmanrifle"] = "ammo-sniper",
        ["weapon_marksmanrifle_mk2"] = "ammo-sniper",
        ["weapon_precisionrifle"] = "ammo-sniper",
    },

    -- ============================================
    -- SHOP ITEMS CONFIGURATION (DEFAULT)
    -- ============================================
    -- This is the default shop configuration used for all maps.
    -- Individual maps can override this by defining their own `shopItems` table
    -- in their map config file (see configs/maps/*.lua for examples).
    --
    -- Item parameters:
    --   name: item spawn name (must match ox_inventory item name)
    --   label: display name in the shop UI
    --   rarity: "common", "uncommon", "rare", or "epic" (affects color/styling)
    --   price: cost in horde currency
    --   chance: weighted chance to appear (higher = more likely, e.g. 100 vs 10)
    --   quantity: how many of the item you receive per purchase (e.g. buy 1, get 3 bandages)
    --   amount (optional): how many times this item can be purchased before it becomes sold out
    --                      - If set to 3, players can buy the item 3 times (each time getting 'quantity' items)
    --                      - Once purchased 'amount' times, item gets removed from list
    --                      - If omitted, item is removed from shop after a single purchase
    --
    -- Weighted chance system: higher "chance" values = more likely to appear
    -- itemCount: number of items to show from this category in the shop
    -- guaranteeAmmoForWeapons: if true, ammo for selected weapons will always appear in items section
    -- ammoBoostMultiplier: how much to boost ammo chance when matching weapon is in shop (default 3x) - only used if guaranteeAmmoForWeapons is false
    ShopItems = {
        guaranteeAmmoForWeapons = true, -- Always include ammo for selected weapons in the items section
        ammoBoostMultiplier = 3, -- Boost ammo chance by this multiplier when matching weapon is selected (fallback if guarantee is false)

        items = {
            itemCount = 6, -- Number of items to show in shop
            list = {
                -- Healing items
                { name = "bandage", label = "BANDAGE", rarity = "common", price = 150, quantity = 3, chance = 100 },
                { name = "firstaid", label = "FIRST AID KIT", rarity = "uncommon", price = 400, quantity = 1, chance = 50 },
                { name = "ifaks", label = "IFAK", rarity = "uncommon", price = 350, quantity = 1, chance = 55 },
                { name = "painkillers", label = "PAINKILLERS", rarity = "common", price = 200, quantity = 2, chance = 70 },
                { name = "oxy", label = "OXYCODONE", rarity = "rare", price = 300, quantity = 3, chance = 30 },

                -- Food & Drink
                { name = "water", label = "WATER", rarity = "common", price = 100, quantity = 2, chance = 80 },
                { name = "burger", label = "BURGER", rarity = "common", price = 120, quantity = 2, chance = 75 },
                { name = "sandwich", label = "SANDWICH", rarity = "common", price = 110, quantity = 2, chance = 75 },
                { name = "sprunk", label = "SPRUNK", rarity = "common", price = 80, quantity = 2, chance = 85 },

                -- Armor
                { name = "armour", label = "BODY ARMOR", rarity = "rare", price = 600, quantity = 1, chance = 25 },

                -- Ammo types (item name must match the ammo type in WeaponAmmoTypes, e.g., "ammo-9")
                { name = "ammo-9", label = "9MM AMMO", rarity = "common", price = 100, quantity = 60, chance = 40, amount = 3 },
                { name = "ammo-45", label = ".45 ACP AMMO", rarity = "common", price = 120, quantity = 50, chance = 35, amount = 3 },
                { name = "ammo-38", label = ".38 SPECIAL AMMO", rarity = "uncommon", price = 130, quantity = 48, chance = 30, amount = 3 },
                { name = "ammo-44", label = ".44 MAGNUM AMMO", rarity = "uncommon", price = 160, quantity = 36, chance = 25, amount = 3 },
                { name = "ammo-rifle", label = "5.56 RIFLE AMMO", rarity = "uncommon", price = 150, quantity = 60, chance = 30, amount = 3 },
                { name = "ammo-rifle2", label = "7.62 RIFLE AMMO", rarity = "uncommon", price = 180, quantity = 60, chance = 25, amount = 3 },
                { name = "ammo-shotgun", label = "12 GAUGE SHELLS", rarity = "uncommon", price = 140, quantity = 24, chance = 30, amount = 3 },
                { name = "ammo-sniper", label = "SNIPER AMMO", rarity = "rare", price = 200, quantity = 20, chance = 15, amount = 3 },

                -- Utilities
                { name = "lockpick", label = "LOCKPICK", rarity = "uncommon", price = 250, quantity = 1, chance = 40 },
                { name = "radio", label = "RADIO", rarity = "uncommon", price = 300, quantity = 1, chance = 35 },
                { name = "repairkit", label = "REPAIR KIT", rarity = "rare", price = 500, quantity = 1, chance = 20 },
            },
        },

        -- Weapons (ammo types are looked up from WeaponAmmoTypes config above)
        weapons = {
            itemCount = 3, -- Number of weapons to show in shop
            list = {
                -- Pistols
                { name = "weapon_pistol", label = "PISTOL", rarity = "common", price = 400, chance = 80 },
                { name = "weapon_combatpistol", label = "COMBAT PISTOL", rarity = "common", price = 500, chance = 70 },
                { name = "weapon_pistol_mk2", label = "PISTOL MK2", rarity = "uncommon", price = 650, chance = 45 },
                { name = "weapon_appistol", label = "AP PISTOL", rarity = "uncommon", price = 700, chance = 40 },
                { name = "weapon_ceramicpistol", label = "CERAMIC PISTOL", rarity = "uncommon", price = 600, chance = 50 },
                { name = "weapon_vintagepistol", label = "VINTAGE PISTOL", rarity = "uncommon", price = 550, chance = 55 },
                { name = "weapon_heavypistol", label = "HEAVY PISTOL", rarity = "uncommon", price = 650, chance = 50 },
                { name = "weapon_snspistol", label = "SNS PISTOL", rarity = "common", price = 350, chance = 65 },
                { name = "weapon_machinepistol", label = "MACHINE PISTOL", rarity = "uncommon", price = 700, chance = 45 },

                -- Revolvers
                { name = "weapon_revolver", label = "REVOLVER", rarity = "rare", price = 800, chance = 30 },
                { name = "weapon_doubleaction", label = "DOUBLE ACTION REVOLVER", rarity = "uncommon", price = 600, chance = 40 },

                -- SMGs
                { name = "weapon_smg", label = "SMG", rarity = "rare", price = 900, chance = 30 },
                { name = "weapon_smg_mk2", label = "SMG MK2", rarity = "rare", price = 1100, chance = 20 },
                { name = "weapon_combatpdw", label = "COMBAT PDW", rarity = "rare", price = 950, chance = 25 },
                { name = "weapon_minismg", label = "MINI SMG", rarity = "uncommon", price = 750, chance = 35 },
                { name = "weapon_microsmg", label = "MICRO SMG", rarity = "uncommon", price = 700, chance = 40 },

                -- Shotguns
                { name = "weapon_pumpshotgun", label = "PUMP SHOTGUN", rarity = "uncommon", price = 750, chance = 35 },
                { name = "weapon_sawnoffshotgun", label = "SAWED-OFF SHOTGUN", rarity = "uncommon", price = 650, chance = 40 },
                { name = "weapon_dbshotgun", label = "DOUBLE BARREL SHOTGUN", rarity = "rare", price = 850, chance = 25 },
                { name = "weapon_assaultshotgun", label = "ASSAULT SHOTGUN", rarity = "epic", price = 1400, chance = 10 },
                { name = "weapon_combatshotgun", label = "COMBAT SHOTGUN", rarity = "epic", price = 1500, chance = 8 },

                -- Assault Rifles
                { name = "weapon_carbinerifle", label = "CARBINE RIFLE", rarity = "rare", price = 1200, chance = 20 },
                { name = "weapon_specialcarbine", label = "SPECIAL CARBINE", rarity = "rare", price = 1300, chance = 18 },
                { name = "weapon_bullpuprifle", label = "BULLPUP RIFLE", rarity = "rare", price = 1250, chance = 18 },
                { name = "weapon_advancedrifle", label = "ADVANCED RIFLE", rarity = "epic", price = 1500, chance = 12 },
                { name = "weapon_militaryrifle", label = "MILITARY RIFLE", rarity = "epic", price = 1600, chance = 10 },
                { name = "weapon_tacticalrifle", label = "TACTICAL RIFLE", rarity = "epic", price = 1550, chance = 10 },
                { name = "weapon_assaultrifle", label = "ASSAULT RIFLE", rarity = "rare", price = 1100, chance = 22 },
                { name = "weapon_compactrifle", label = "COMPACT RIFLE", rarity = "uncommon", price = 900, chance = 30 },

                -- Sniper Rifles
                { name = "weapon_marksmanrifle", label = "MARKSMAN RIFLE", rarity = "epic", price = 1800, chance = 8 },
                { name = "weapon_sniperrifle", label = "SNIPER RIFLE", rarity = "epic", price = 2000, chance = 6 },

                -- Machine Guns
                { name = "weapon_combatmg", label = "COMBAT MG", rarity = "epic", price = 2200, chance = 5 },

                -- Melee (no ammo needed)
                { name = "weapon_bat", label = "BASEBALL BAT", rarity = "common", price = 200, chance = 60 },
                { name = "weapon_crowbar", label = "CROWBAR", rarity = "common", price = 250, chance = 55 },
                { name = "weapon_knife", label = "KNIFE", rarity = "common", price = 180, chance = 65 },
                { name = "weapon_machete", label = "MACHETE", rarity = "uncommon", price = 350, chance = 40 },
                { name = "weapon_hatchet", label = "HATCHET", rarity = "uncommon", price = 300, chance = 45 },
            },
        },

        -- Shop perks reference VotePerks by their id
        -- These apply the actual perk effects to the entire team
        perks = {
            itemCount = 2, -- Number of perks to show in shop
            list = {
                -- Common perks
                { name = "thick_skin", label = "-25% DAMAGE TAKEN", rarity = "common", price = 500, chance = 80 },
                { name = "fortified", label = "+50 ARMOR (-20% DMG)", rarity = "common", price = 400, chance = 70 },
                { name = "adrenaline", label = "+25% SPEED BELOW 50% HP", rarity = "common", price = 450, chance = 75 },

                -- Uncommon perks
                { name = "speed_demon", label = "+50% MOVEMENT SPEED", rarity = "uncommon", price = 750, chance = 50 },
                { name = "scavenger", label = "+10 AMMO ON KILL", rarity = "uncommon", price = 600, chance = 55 },
                { name = "hired_gun", label = "+15 CURRENCY PER KILL", rarity = "uncommon", price = 650, chance = 50 },
                { name = "bargain_hunter", label = "-25% SHOP PRICES (-10% DMG)", rarity = "uncommon", price = 700, chance = 45 },

                -- Rare perks
                { name = "vampire", label = "+25 HP PER KILL (NO REGEN)", rarity = "rare", price = 1000, chance = 25 },
                { name = "double_damage", label = "+100% DAMAGE (+50% DMG TAKEN)", rarity = "rare", price = 1200, chance = 20 },
                { name = "last_stand", label = "SURVIVE FATAL HIT ONCE", rarity = "rare", price = 1500, chance = 15 },
                { name = "lightweight", label = "+35% SPEED, +75% JUMP (+40% DMG TAKEN)", rarity = "rare", price = 900, chance = 30 },
                { name = "rich_loot", label = "+75% LOOT VALUE (+25% DMG TAKEN)", rarity = "rare", price = 1100, chance = 25 },
                { name = "headhunter", label = "+200% HEADSHOT DMG (-50% BODY)", rarity = "rare", price = 850, chance = 30 },
                { name = "bounty_hunter", label = "+50% CURRENCY (ENEMIES +25% FASTER)", rarity = "rare", price = 950, chance = 28 },

                -- Epic perks
                { name = "infinite_ammo", label = "INFINITE AMMO", rarity = "epic", price = 2000, chance = 10 },
            },
        },
    },

    -- Reroll costs
    RerollCost = 200,

    -- Looting phase configuration
    LootingPhaseDuration = 240, -- Duration in seconds (120 = 2 minutes)

    -- Start with loot round instead of enemy round
    -- If true, the first round will be a looting phase (after the intro), then enemy rounds begin
    -- If false (default), the first round starts immediately (after the intro) with enemies
    StartWithLootRound = true, -- If you have Confiscate to true, then it's pretty much a MUST that you enable this, unless you want your players to go at the NPCs with their bare hands :)

    -- Clear dead bodies when a new round begins (after perk voting and looting phase, as "Round X beginning" appears)
    -- If false, bodies remain until EndLootingPhase clears all bodies unconditionally
    ClearBodiesOnRoundEnd = true,

    -- ============================================
    -- ENEMY SPAWN CAP SYSTEM
    -- ============================================
    -- Limits the number of enemies alive at once to reduce performance impact.
    -- When an enemy dies, a new one spawns (if there are still enemies left to spawn for the round).
    -- This creates a continuous flow of enemies rather than spawning all at once.
    --
    -- Example: Round has 30 enemies, maxAliveEnemies = 15
    --   - Initially spawns 15 enemies
    --   - When 1 dies: 14 alive, spawns 1 more = 15 alive, 14 left to spawn
    --   - Continues until all 30 have been spawned and killed
    --
    -- Set to 0 or nil to disable (spawn all enemies at once like before)
    -- Can also be configured per-difficulty in map configs (overrides this global setting)
    MaxAliveEnemies = 15,

    -- ============================================
    -- DEAD BODY CLEANUP SYSTEM
    -- ============================================
    -- Controls automatic cleanup of dead bodies during rounds to reduce entity count.
    -- Bodies are cleaned up either when:
    --   1. The max dead body count is exceeded (oldest bodies removed first)
    --   2. A body has been dead longer than the despawn time
    --
    -- Note: Bodies are always fully cleaned up at round end (if ClearBodiesOnRoundEnd = true)
    -- and at the end of the looting phase.

    -- Maximum number of dead bodies allowed at once during a round
    -- When exceeded, the oldest dead bodies are removed
    -- Set to 0 or nil to disable max dead body limit
    MaxDeadBodies = 10,

    -- Time in seconds before a dead body is automatically cleaned up
    -- Set to 0 or nil to disable timed cleanup (bodies only removed by max count or round end)
    DeadBodyDespawnTime = 30,

    -- ============================================
    -- PER-MODEL CARRY OFFSETS
    -- ============================================
    -- Override offset/rotation for specific loot models
    -- If a model is not listed here, it uses the default CarryAnimation values
    CarryOffsets = {
        ['prop_box_ammo01a'] = {
            offset = vector3(0.155, -0.090, 0.130),
            rotation = vector3(-110.0, 179.0, 45.0),
        },
        ['prop_box_ammo02a'] = {
            offset = vector3(0.105, -0.090, 0.180),
            rotation = vector3(-110.0, 184.0, 47.0),
        },
        ['prop_cs_cardbox_01'] = {
            offset = vector3(-0.065, 0.030, 0.230),
            rotation = vector3(-130.0, 105.0, -1.0),
        },
        ['prop_box_ammo04a'] = {
            offset = vector3(0.135, -0.000, 0.200),
            rotation = vector3(-137.0, 109.0, -21.0),
        },
        ['h4_prop_h4_crate_cloth_01a'] = {
            offset = vector3(0.175, 0.040, 0.190),
            rotation = vector3(-99.0, 184.0, 35.0),
        },
        ['prop_box_guncase_01a'] = {
            offset = vector3(0.065, -0.060, 0.200),
            rotation = vector3(-130.0, 105.0, -11.0),
        },
        ['h4_prop_h4_box_ammo03a'] = {
            offset = vector3(0.195, 0.030, 0.210),
            rotation = vector3(-136.0, 107.0, -11.0),
        },
        ['hei_prop_heist_box'] = {
            offset = vector3(-0.085, -0.000, 0.230),
            rotation = vector3(-132.0, 109.0, 0.0),
        },
        ['xm3_prop_xm3_boxwood_01a'] = {
            offset = vector3(0.355, 0.150, 0.070),
            rotation = vector3(-124.0, 111.0, 0.0),
        },
        ['gr_prop_gr_v_mill_crate_01a'] = {
            offset = vector3(0.195, 0.030, 0.190),
            rotation = vector3(-76.0, 12.0, 42.0),
        },
        ['ch_prop_ch_crate_full_01a'] = {
            offset = vector3(0.265, 0.090, 0.200),
            rotation = vector3(-139.0, 108.0, -10.0),
        },
        ['h4_prop_h4_box_ammo_02a'] = {
            offset = vector3(0.185, -0.030, 0.300),
            rotation = vector3(-130.0, 105.0, 0.0),
        },
        ['sm_prop_smug_crate_m_01a'] = {
            offset = vector3(0.175, -0.010, 0.160),
            rotation = vector3(-128.0, 116.0, -4.0),
        },
        ['xm3_prop_xm3_crate_supp_01a'] = {
            offset = vector3(0.155, -0.030, 0.190),
            rotation = vector3(-130.0, 105.0, 0.0),
        },
        ['prop_mb_crate_01a'] = {
            offset = vector3(0.335, 0.160, 0.080),
            rotation = vector3(-127.0, 104.0, 0.0),
        },
        ['m23_2_prop_m32_prof_crate_01a'] = {
            offset = vector3(-0.025, 0.190, 0.300),
            rotation = vector3(-130.0, 105.0, 0.0),
        },
    },

    -- Default carry animation configuration (used when model not in CarryOffsets)
    CarryAnimation = {
        dict = 'anim@heists@box_carry@',
        anim = 'idle',
        bone = 0xEB95, -- Spine bone
        offset = vector3(0.075, -0.15, 0.30),
        rotation = vector3(-130.0, 105.0, 0.0),
    },

    -- ============================================
    -- MODULAR PERK SYSTEM
    -- ============================================
    -- Each perk has an id, icon, and a list of effects (buffs/debuffs)
    -- Effects are automatically applied/removed by the perk system
    --
    -- Available effect types:
    --
    -- PLAYER COMBAT MODIFIERS:
    --   { type = "damage", value = 0.5 }              -- +50% damage dealt (use negative for reduction)
    --   { type = "speed", value = 0.3 }               -- +30% movement speed
    --   { type = "incoming_damage", value = 0.25 }    -- +25% damage taken (use negative for reduction)
    --   { type = "armor", value = 50 }                -- +50 flat armor
    --   { type = "heal_on_kill", value = 25 }         -- +25 HP per kill
    --   { type = "ammo_on_kill", value = 50 }         -- +50 ammo per kill
    --   { type = "headshot_damage", value = 2.0 }     -- +200% headshot damage
    --   { type = "bodyshot_damage", value = -0.5 }    -- -50% body damage
    --   { type = "regen_per_second", value = 5 }      -- Regenerate 5 HP per second
    --
    -- CURRENCY/REWARDS MODIFIERS:
    --   { type = "loot_value", value = 0.75 }         -- +75% loot value
    --   { type = "points", value = 1.0 }              -- +100% points earned
    --   { type = "currency", value = 0.5 }            -- +50% all currency earned
    --   { type = "headshot_currency", value = 0.5 }   -- +50% bonus currency for headshot kills
    --   { type = "kill_currency", value = 10 }        -- +10 flat bonus currency per kill
    --
    -- ENEMY/GUARD MODIFIERS (debuffs - makes enemies stronger):
    --   { type = "enemy_speed", value = 0.25 }        -- Enemies move +25% faster
    --   { type = "enemy_health", value = 0.5 }        -- Enemies have +50% more health
    --   { type = "enemy_damage", value = 0.3 }        -- Enemies deal +30% more damage
    --   { type = "enemy_armor", value = 0.5 }         -- Enemies have +50% more armor
    --   { type = "enemy_accuracy", value = 0.25 }     -- Enemies have +25% better accuracy
    --
    -- BOOLEAN TOGGLES:
    --   { type = "infinite_ammo", value = true }      -- Enable infinite ammo
    --   { type = "no_health_regen", value = true }    -- Disable natural health regen
    --   { type = "one_hit_kill", value = true }       -- Player dies in one hit
    --   { type = "explosive_rounds", value = true }   -- Bullets cause explosions
    --   { type = "thermite_rounds", value = true }    -- Enemies burn on hit
    --   { type = "no_armor", value = true }           -- Cannot have armor
    --   { type = "last_stand", value = true }         -- Survive one fatal hit
    --   { type = "super_jump", value = true }         -- Super jump (very high)
    --   { type = "jump_height", value = 0.5 }         -- +50% jump height (normal jump modifier)
    --
    -- SPECIAL EFFECTS:
    --   { type = "berserker", value = 0.25 }          -- +25% damage per kill, resets on hit
    --   { type = "adrenaline", value = 0.25 }         -- +25% speed when below 50% HP
    --   { type = "rage_mode", value = 0.1 }           -- +10% damage per 10% HP lost
    --   { type = "gambler", value = true }            -- Random bonuses/penalties
    --
    -- benefit/downside are display strings for the UI (auto-generated from effects if omitted)
    --
    -- ICONS: Use any icon from https://lucide.dev/icons
    -- Copy the icon name exactly as shown on the website (kebab-case)
    -- Examples: "crosshair", "skull", "flame", "shield", "zap", "target", "swords", "heart"

    VotePerks = {
        -- Damage perks
        {
            id = "double_damage",
            icon = "crosshair",
            benefit = "+100% DAMAGE",
            downside = "+50% DAMAGE TAKEN",
            effects = {
                { type = "damage", value = 1.0 },
                { type = "incoming_damage", value = 0.5 },
            }
        },
        {
            id = "glass_cannon",
            icon = "skull",
            benefit = "+150% DAMAGE",
            downside = "ONE-HIT KILLS YOU",
            effects = {
                { type = "damage", value = 1.5 },
                { type = "one_hit_kill", value = true },
            }
        },
        {
            id = "berserker",
            icon = "flame",
            benefit = "+25% DMG PER KILL (STACKS)",
            downside = "LOSE STACKS ON HIT",
            effects = {
                { type = "berserker", value = 0.25, maxStacks = 10 },
            }
        },
        -- Explosive rounds perk (commented out by default - can cause issues with certain weapons)
        -- Uncomment to enable:
        -- {
        --     id = "explosive_rounds",
        --     icon = "bomb",
        --     benefit = "BULLETS CAUSE EXPLOSIONS",
        --     downside = "-50% DAMAGE",
        --     effects = {
        --         { type = "explosive_rounds", value = true },
        --         { type = "damage", value = -0.5 },
        --     }
        -- },
        {
            id = "headhunter",
            icon = "target",
            benefit = "+200% HEADSHOT DAMAGE",
            downside = "-50% BODY DAMAGE",
            effects = {
                { type = "headshot_damage", value = 2.0 },
                { type = "bodyshot_damage", value = -0.5 },
            }
        },

        -- Defensive perks
        {
            id = "fortified",
            icon = "hard-hat",
            benefit = "+50 ARMOR",
            downside = "-20% DAMAGE",
            effects = {
                { type = "armor", value = 50 },
                { type = "damage", value = -0.2 },
            }
        },
        {
            id = "thick_skin",
            icon = "shield",
            benefit = "-25% DAMAGE TAKEN",
            downside = "NO DOWNSIDE",
            effects = {
                { type = "incoming_damage", value = -0.25 },
            }
        },
        {
            id = "last_stand",
            icon = "heart-crack",
            benefit = "SURVIVE FATAL HIT ONCE",
            downside = "NO DOWNSIDE",
            effects = {
                { type = "last_stand", value = true },
            }
        },
        -- Mobility perks
        {
            id = "speed_demon",
            icon = "zap",
            benefit = "+50% MOVEMENT SPEED",
            downside = "NO DOWNSIDE",
            effects = {
                { type = "speed", value = 0.5 },
            }
        },
        {
            id = "adrenaline",
            icon = "heart-pulse",
            benefit = "+25% SPEED BELOW 50% HP",
            downside = "NO DOWNSIDE",
            effects = {
                { type = "adrenaline", value = 0.25, threshold = 0.5 },
            }
        },
        {
            id = "lightweight",
            icon = "feather",
            benefit = "+35% SPEED, +75% JUMP HEIGHT",
            downside = "+40% DAMAGE TAKEN",
            effects = {
                { type = "speed", value = 0.35 },
                { type = "jump_height", value = 0.75 }, -- Increased from 0.5 for more noticeable effect
                { type = "incoming_damage", value = 0.4 },
            }
        },

        -- Utility perks
        {
            id = "infinite_ammo",
            icon = "infinity",
            benefit = "INFINITE AMMO",
            downside = "NO DOWNSIDE",
            effects = {
                { type = "infinite_ammo", value = true },
            }
        },
        {
            id = "rich_loot",
            icon = "coins",
            benefit = "+75% LOOT VALUE",
            downside = "+25% DAMAGE TAKEN",
            effects = {
                { type = "loot_value", value = 0.75 },
                { type = "incoming_damage", value = 0.25 },
            }
        },
        {
            id = "scavenger",
            icon = "package-open",
            benefit = "+10 AMMO ON KILL",
            downside = "NO DOWNSIDE",
            effects = {
                { type = "ammo_on_kill", value = 10 },
            }
        },
        -- Thermite rounds perk (commented out by default - can cause issues with certain weapons)
        -- Uncomment to enable:
        -- {
        --     id = "thermite_rounds",
        --     icon = "flame",
        --     benefit = "ENEMIES BURN ON HIT",
        --     downside = "-25% DAMAGE",
        --     effects = {
        --         { type = "thermite_rounds", value = true },
        --         { type = "damage", value = -0.25 },
        --     }
        -- },

        -- Risk/Reward perks
        {
            id = "vampire",
            icon = "droplet",
            benefit = "+25 HP PER KILL",
            downside = "NO HEALTH REGEN",
            effects = {
                { type = "heal_on_kill", value = 25 },
                { type = "no_health_regen", value = true },
            }
        },
        -- Kinda a memey one, would recommend not enabling.
        --[[{
            id = "gambler",
            icon = "dices",
            benefit = "RANDOM BONUS EACH KILL",
            downside = "RANDOM PENALTY EACH HIT",
            effects = {
                { type = "gambler", value = true },
            }
        }, ]]
        {
            id = "rage_mode",
            icon = "angry",
            benefit = "+10% DMG PER 10% HP LOST",
            downside = "NO ARMOR ALLOWED",
            effects = {
                { type = "rage_mode", value = 0.1 },
                { type = "no_armor", value = true },
            }
        },
        {
            id = "marked_for_death",
            icon = "circle-dot",
            benefit = "+100% LOOT & POINTS",
            downside = "+50% DAMAGE TAKEN",
            effects = {
                { type = "loot_value", value = 1.0 },
                { type = "points", value = 1.0 },
                { type = "incoming_damage", value = 0.5 },
            }
        },

        -- Currency perks
        {
            id = "bounty_hunter",
            icon = "dollar-sign",
            benefit = "+50% CURRENCY",
            downside = "ENEMIES +25% FASTER",
            effects = {
                { type = "currency", value = 0.5 },
                { type = "enemy_speed", value = 0.25 },
            }
        },
        {
            id = "precision_payout",
            icon = "target",
            benefit = "+75% HEADSHOT CURRENCY",
            downside = "-25% BODY DAMAGE",
            effects = {
                { type = "headshot_currency", value = 0.75 },
                { type = "bodyshot_damage", value = -0.25 },
            }
        },
        {
            id = "hired_gun",
            icon = "banknote",
            benefit = "+15 CURRENCY PER KILL",
            downside = "NO DOWNSIDE",
            effects = {
                { type = "kill_currency", value = 15 },
            }
        },
        {
            id = "bargain_hunter",
            icon = "percent",
            benefit = "-25% SHOP PRICES",
            downside = "-10% DAMAGE",
            effects = {
                { type = "shop_discount", value = 0.25 },
                { type = "damage", value = -0.1 },
            }
        },

        -- Enemy modifier perks (high risk/reward)
        {
            id = "elite_guards",
            icon = "shield-alert",
            benefit = "+200% CURRENCY",
            downside = "ENEMIES +50% ARMOR",
            effects = {
                { type = "currency", value = 2.0 },
                { type = "enemy_armor", value = 0.5 },
            }
        },
        {
            id = "berserker_horde",
            icon = "footprints",
            benefit = "+100% DAMAGE",
            downside = "ENEMIES +50% SPEED",
            effects = {
                { type = "damage", value = 1.0 },
                { type = "enemy_speed", value = 0.5 },
            }
        },
        {
            id = "brutal_guards",
            icon = "swords",
            benefit = "+150% LOOT VALUE",
            downside = "ENEMIES +40% DAMAGE",
            effects = {
                { type = "loot_value", value = 1.5 },
                { type = "enemy_damage", value = 0.4 },
            }
        },
        {
            id = "sharpshooter_enemies",
            icon = "eye",
            benefit = "+50% ALL CURRENCY",
            downside = "ENEMIES +30% ACCURACY",
            effects = {
                { type = "currency", value = 0.5 },
                { type = "enemy_accuracy", value = 0.3 },
            }
        },
    },

    -- Perk voting configuration
    PerkVoteDuration = 15, -- Seconds to vote for a perk

    -- ============================================
    -- END GAME LOOT CONFIGURATION
    -- ============================================
    -- When players end the game early or run out of rounds, they get a loot shop screen
    -- where they can spend their remaining points on items
    --
    -- LOOT TABLE PRIORITY (highest to lowest):
    --   1. Per-difficulty endGameLoot (in difficulty config, e.g., difficulties.hard.endGameLoot)
    --   2. Map-level endGameLoot (in map config, e.g., maps/cayo_estate.lua)
    --   3. Main config EndGameLoot (this file - fallback)
    --
    -- This allows you to:
    --   - Give better rewards for completing harder difficulties
    --   - Have different loot pools per map
    --   - Use a single fallback for all maps/difficulties
    --
    -- Weighted chance system:
    --   - Higher "chance" values = more likely to appear
    --   - The system picks items based on weighted probability
    --   - Example: item with chance=10 is 10x more likely than item with chance=1
    --
    -- ============================================
    -- FALLBACK END GAME LOOT (OPTIONAL)
    -- ============================================
    -- By default, every map has its own loot pool defined in configs/maps/<map_name>.lua
    -- You can uncomment this section to specify a central/fallback loot table that will be
    -- used for maps that don't define their own endGameLoot (central or per-difficulity), or if you prefer to manage
    -- all loot from one place (in which case, remove endGameLoot from individual map files).
    --
    --[[
    EndGameLoot = {
        -- Cost to reroll the loot shop items
        rerollCost = 200,

        -- Number of items to show in the shop at once
        itemCount = 6,

        -- Duration in seconds before game fully ends (countdown timer)
        duration = 60,

        -- Fallback loot table (used if map doesn't specify its own)
        -- Each item has: name, label, rarity, price, chance (weight), quantity (optional), image (optional)
        lootTable = {
            -- ============================================
            -- COMMON ITEMS (chance 60-100) - Silver jewelry, cash & heist tools
            -- ============================================
            { name = "bands", label = "Band of Notes", rarity = "common", price = 800, chance = 100, quantity = 3 },
            { name = "rolls", label = "Roll of Notes", rarity = "common", price = 700, chance = 95, quantity = 3 },
            { name = "md_silverring", label = "Silver Ring", rarity = "common", price = 900, chance = 90 },
            { name = "md_silverearings", label = "Silver Earrings", rarity = "common", price = 1000, chance = 85 },
            { name = "md_silverdime", label = "Silver Dime", rarity = "common", price = 600, chance = 95 },
            { name = "md_blackwatch", label = "Watch", rarity = "common", price = 1100, chance = 80 },
            { name = "md_ancientcoin", label = "Ancient Coin", rarity = "common", price = 1200, chance = 75 },
            { name = "lockpick", label = "Lockpick", rarity = "common", price = 500, chance = 85, quantity = 3 },
            { name = "advancedlockpick", label = "Advanced Lockpick", rarity = "common", price = 800, chance = 70 },
            { name = "thermite", label = "Thermite", rarity = "common", price = 1500, chance = 65 },

            -- ============================================
            -- UNCOMMON ITEMS (chance 30-55) - Gold jewelry, cases & valuable loot
            -- ============================================
            { name = "md_silverounce", label = "1oz Silver Bar", rarity = "uncommon", price = 1800, chance = 55 },
            { name = "md_goldring", label = "Gold Ring", rarity = "uncommon", price = 2200, chance = 50 },
            { name = "md_golddollar", label = "Gold Dollar", rarity = "uncommon", price = 2000, chance = 52 },
            { name = "md_goldearings", label = "Gold Earrings", rarity = "uncommon", price = 2500, chance = 45 },
            { name = "goldchain", label = "Gold Chain", rarity = "uncommon", price = 2800, chance = 42 },
            { name = "rolex", label = "Golden Watch", rarity = "uncommon", price = 3500, chance = 38 },
            { name = "fleeca_case", label = "Fleeca Bank Case", rarity = "uncommon", price = 3000, chance = 40 },
            { name = "house_case", label = "House Robbery Case", rarity = "uncommon", price = 2800, chance = 42 },
            { name = "cryptostick", label = "Crypto Stick", rarity = "uncommon", price = 2500, chance = 45 },
            { name = "drill", label = "Drill", rarity = "uncommon", price = 2000, chance = 48 },

            -- ============================================
            -- RARE ITEMS (chance 10-28) - Gold bars, diamonds & premium cases
            -- ============================================
            { name = "md_goldnecklace", label = "Gold Necklace", rarity = "rare", price = 4000, chance = 28 },
            { name = "md_goldnugget", label = "Gold Nugget", rarity = "rare", price = 4500, chance = 25 },
            { name = "md_diamondearings", label = "Diamond Earrings", rarity = "rare", price = 5000, chance = 22 },
            { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 6000, chance = 18 },
            { name = "diamond_ring", label = "Diamond Ring", rarity = "rare", price = 7000, chance = 15 },
            { name = "jewelry_case", label = "Jewelry Store Case", rarity = "rare", price = 5500, chance = 20 },
            { name = "chopshop_case", label = "Chop Shop Case", rarity = "rare", price = 4500, chance = 22 },
            { name = "coke_small_brick", label = "Coke Package", rarity = "rare", price = 5000, chance = 20 },
            { name = "md_goldounce", label = "1oz Gold Bar", rarity = "rare", price = 8000, chance = 12 },
            { name = "md_platinumnugget", label = "Platinum Nugget", rarity = "rare", price = 9000, chance = 10 },

            -- ============================================
            -- EPIC ITEMS (chance 2-8) - Jackpot loot & legendary items
            -- ============================================
            { name = "md_diamondnecklace", label = "Diamond Necklace", rarity = "epic", price = 12000, chance = 8 },
            { name = "md_diamondring", label = "Diamond Ring", rarity = "epic", price = 10000, chance = 8 },
            { name = "md_presidentialwatch", label = "Presidential Watch", rarity = "epic", price = 15000, chance = 5 },
            { name = "md_relicrevolver", label = "Relic Revolver", rarity = "epic", price = 12000, chance = 6 },
            { name = "pacific_case", label = "Pacific Bank Case", rarity = "epic", price = 18000, chance = 4 },
            { name = "casino_case", label = "Casino Heist Case", rarity = "epic", price = 25000, chance = 2 },
            { name = "coke_brick", label = "Coke Brick", rarity = "epic", price = 15000, chance = 5 },
            { name = "weed_brick", label = "Weed Brick", rarity = "epic", price = 12000, chance = 6 },
            { name = "secured_safe", label = "Secured Safe", rarity = "epic", price = 14000, chance = 5 },
            { name = "expensive_champagne", label = "Expensive Champagne", rarity = "epic", price = 8000, chance = 7, quantity = 3 },
        },
    },
    ]]

    -- Stats configuration
    Stats = {
        enabled = true, -- Master toggle: if false, stats option is hidden from ped menu entirely
        -- Individual stat toggles (only applicable if enabled = true)
        showGamesPlayed = true,
        showSoloGames = true,
        showGroupGames = true,
        showPlayTime = true,
        showKills = true,
        showRoundsCleared = true,
        showHordesCompleted = true,
        showDamageDealt = true,
        showDamageTaken = true,
        showCoinsEarned = true,
        showCoinsSpent = true,
        showLootDeposited = true,
    },

}
