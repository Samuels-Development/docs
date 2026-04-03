-- ============================================
-- GUNRUNNING BUNKER MAP
-- ============================================
-- Uses the Gunrunning DLC Bunker interior
-- All bunkers share the same interior layout

return {
    id = "gunrunning_bunker",
    label = "Gunrunning Bunker",
    description = "An underground weapons manufacturing facility. This bunker houses illegal arms operations, research labs, and a full vehicle bay.",
    icon = "fa-warehouse",

    -- Map intro text configuration
    intro = {
        enabled = true,
        title = "RAID THE\nGUNRUNNING BUNKER",
        subtitle = nil,
        description = "AN ILLEGAL ARMS MANUFACTURING FACILITY. SURVIVE THE WAVES, COLLECT VALUABLE LOOT, AND ESCAPE WITH YOUR LIFE.",
        tagline = "THE ARMS TRADE NEVER SLEEPS.",
        duration = 15000,
    },

    -- ============================================
    -- MAP-LEVEL REQUIREMENTS (to access this map)
    -- ============================================
    -- NOTE: If a difficulty has its own 'requirements' table defined, those will be used INSTEAD of these!
    --       Map-level requirements only apply when the selected difficulty has NO requirements defined.
    --
    -- Available requirement types:
    --   level = 5                                                -- Require minimum horde level
    --   completedMaps = {                                        -- Require completion of other maps (can list multiple!)
    --       { map = "map_id", difficulty = "easy" },             -- Player must have completed this map on this difficulty
    --       { map = "another_map", difficulty = "normal" },      -- Can require multiple different map completions
    --   }
    --   item = "item_name"                                       -- Require single item in inventory
    --   item = { name = "item_name", count = 3 }                 -- Require multiple of the same item
    --   item = { name = "item_name", consume = true }            -- Require AND CONSUME item when horde starts
    --   item = { name = "x", count = 2, consume = true }         -- Combine count and consume
    --   items = {                                                -- Require MULTIPLE DIFFERENT items
    --       { name = "item1", consume = true },                  -- This item will be consumed on start
    --       { name = "item2", count = 3 },                       -- Requires 3, will NOT be consumed
    --       { name = "item3", count = 2, consume = true },       -- Requires 2, both will be consumed
    --   }
    --
    -- CONSUME EXPLAINED:
    --   - consume = false (default): Item is checked but NOT removed from inventory
    --   - consume = true: Item is REMOVED from inventory when the horde starts successfully
    --   - Use this for entry tickets, keys, or consumable access items
    --
    -- Item labels are automatically fetched from your inventory system
    requirements = {
        level = 5,
        -- completedMaps = {
        --     { map = "server_farm", difficulty = "normal" },
        --     { map = "another_map", difficulty = "easy" },      -- Can require multiple maps!
        -- },
        -- item = "bunker_access_key",                            -- Single item (not consumed)
        -- item = { name = "bunker_access_key", consume = true }, -- Single item (consumed on start)
        -- items = {                                              -- Multiple items example:
        --     { name = "bunker_access_key", consume = true },    -- This item will be consumed
        --     { name = "lockpick", count = 2 },                  -- These items will NOT be consumed
        -- },
    },

    -- Entry location (Route 68 Bunker entrance)
    entryLocation = {
        coords = vector4(147.26, 6366.82, 31.90, 303.15),
        blip = {
            sprite = 557,
            color = 1,
            scale = 0.8,
            label = "Bunker Entry",
        },
        radius = 4.0,
    },

    -- Leave location (where players are teleported when game ends)
    leaveLocation = vec4(146.68, 6366.8, 31.53, 118.82),

    -- End loot crate location (where players collect rewards after game ends)
    endLootLocation = {
        coords = vector4(143.76, 6369.93, 30.53, 210.28),
        model = 'v_ind_cfcrate3',
    },

    -- Spawn point inside the bunker
    spawnPoint = vector4(895.51, -3245.67, -98.25, 83.84),

    -- Zone boundary points (for lib.zones poly zone)
    -- Players will be warned/teleported back if they leave this area
    zonePoints = {
        vec3(897.39, -3248.98, -99.16),
        vec3(897.37, -3242.85, -99.20),
        vec3(927.78, -3241.39, -99.18),
        vec3(947.82, -3241.18, -99.16),
        vec3(951.57, -3237.71, -99.24),
        vec3(951.57, -3233.53, -99.22),
        vec3(951.57, -3228.24, -99.22),
        vec3(951.58, -3215.25, -99.17),
        vec3(950.88, -3204.21, -99.20),
        vec3(949.97, -3198.43, -99.23),
        vec3(943.68, -3198.73, -99.20),
        vec3(943.28, -3196.35, -99.17),
        vec3(945.78, -3195.67, -99.04),
        vec3(932.90, -3192.19, -99.20),
        vec3(924.46, -3193.18, -99.20),
        vec3(916.13, -3193.80, -99.24),
        vec3(904.34, -3185.14, -98.02),
        vec3(903.83, -3178.75, -98.12),
        vec3(899.78, -3179.31, -98.12),
        vec3(919.78, -3066.91, -98.12),
        vec3(910.54, -3064.96, -98.10),
        vec3(907.20, -3081.74, -98.12),
        vec3(904.80, -3081.38, -98.10),
        vec3(901.80, -3095.59, -98.10),
        vec3(904.37, -3095.91, -98.12),
        vec3(898.45, -3126.74, -98.12),
        vec3(896.45, -3126.56, -98.11),
        vec3(894.88, -3134.81, -98.10),
        vec3(896.88, -3134.93, -98.12),
        vec3(889.66, -3172.24, -98.10),
        vec3(889.17, -3179.39, -98.04),
        vec3(865.27, -3183.35, -97.23),
        vec3(862.86, -3184.52, -97.03),
        vec3(864.63, -3191.71, -97.09),
        vec3(858.32, -3210.18, -99.40),
        vec3(854.34, -3210.45, -99.26),
        vec3(853.51, -3230.67, -99.26),
        vec3(842.70, -3230.38, -98.94),
        vec3(838.43, -3225.80, -98.82),
        vec3(824.87, -3225.68, -99.44),
        vec3(823.06, -3235.94, -99.68),
        vec3(825.02, -3243.19, -100.11),
        vec3(826.34, -3248.32, -99.91),
        vec3(828.91, -3248.95, -99.85),
        vec3(829.77, -3248.22, -99.82),
        vec3(839.52, -3248.62, -99.45),
        vec3(845.26, -3248.96, -99.31),
        vec3(847.92, -3250.43, -99.23),
        vec3(862.73, -3250.52, -99.25),
        vec3(892.41, -3250.66, -99.27),
    },
    zoneThickness = 30.0, -- Height of the zone (above/below center point)

    -- Terminal configuration (shop access point)
    terminal = {
        coords = vector3(881.38, -3248.51, -98.08),
        object = {
            model = 'prop_laptop_01a',
            heading = 210.09,
        },
    },

    -- Deposit crate configuration
    depositCrate = {
        model = 'tr_prop_tr_mil_crate_02',
        coords = vector3(879.07, -3248.20, -99.29),
        heading = 124.82,
    },

    -- Mystery Box configuration (COD-style random weapon box)
    -- Weapon display models are configured in configs/config.lua under WeaponDisplayModels
    -- Add new weapon-to-model mappings there to display them correctly in the mystery box
    mysteryBox = {
        enabled = true, 
        coords = vector3(881.7, -3237.55, -99.29),
        heading = 359.49,
        cost = 950,
        boxModelClosed = 'xm3_prop_xm3_crate_01a',
        boxModelOpen = 'xm3_prop_xm3_crate_01b',
        useCamera = false,
        enableParticles = true,
        lights = {
            enabled = true,
            pulsating = false,
        },
        cycleDuration = 8000,
        cycleSpeedStart = 50,
        cycleSpeedEnd = 1500,
        sounds = {
            open = { name = "PICK_UP", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
            cycle = { name = "NAV_UP_DOWN", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
            finish = { name = "WEAPON_PURCHASE", set = "HUD_AMMO_SHOP_SOUNDSET" },
        },
        weaponPool = {
            { name = "weapon_pistol", label = "PISTOL", rarity = "common", chance = 100, ammo = 60 },
            { name = "weapon_combatpistol", label = "COMBAT PISTOL", rarity = "common", chance = 90, ammo = 60 },
            { name = "weapon_snspistol", label = "SNS PISTOL", rarity = "common", chance = 85, ammo = 60 },
            { name = "weapon_vintagepistol", label = "VINTAGE PISTOL", rarity = "common", chance = 80, ammo = 60 },
            { name = "weapon_microsmg", label = "MICRO SMG", rarity = "common", chance = 75, ammo = 100 },
            { name = "weapon_pumpshotgun", label = "PUMP SHOTGUN", rarity = "common", chance = 70, ammo = 40 },
            { name = "weapon_pistol_mk2", label = "PISTOL MK2", rarity = "uncommon", chance = 50, ammo = 60 },
            { name = "weapon_appistol", label = "AP PISTOL", rarity = "uncommon", chance = 50, ammo = 60 },
            { name = "weapon_machinepistol", label = "MACHINE PISTOL", rarity = "uncommon", chance = 45, ammo = 100 },
            { name = "weapon_smg", label = "SMG", rarity = "uncommon", chance = 45, ammo = 100 },
            { name = "weapon_minismg", label = "MINI SMG", rarity = "uncommon", chance = 40, ammo = 100 },
            { name = "weapon_sawnoffshotgun", label = "SAWED-OFF SHOTGUN", rarity = "uncommon", chance = 40, ammo = 40 },
            { name = "weapon_dbshotgun", label = "DOUBLE BARREL SHOTGUN", rarity = "uncommon", chance = 35, ammo = 40 },
            { name = "weapon_compactrifle", label = "COMPACT RIFLE", rarity = "uncommon", chance = 35, ammo = 120 },
            { name = "weapon_smg_mk2", label = "SMG MK2", rarity = "rare", chance = 25, ammo = 100 },
            { name = "weapon_combatpdw", label = "COMBAT PDW", rarity = "rare", chance = 25, ammo = 100 },
            { name = "weapon_assaultshotgun", label = "ASSAULT SHOTGUN", rarity = "rare", chance = 20, ammo = 40 },
            { name = "weapon_carbinerifle", label = "CARBINE RIFLE", rarity = "rare", chance = 20, ammo = 120 },
            { name = "weapon_assaultrifle", label = "ASSAULT RIFLE", rarity = "rare", chance = 18, ammo = 120 },
            { name = "weapon_specialcarbine", label = "SPECIAL CARBINE", rarity = "rare", chance = 18, ammo = 120 },
            { name = "weapon_bullpuprifle", label = "BULLPUP RIFLE", rarity = "rare", chance = 15, ammo = 120 },
            { name = "weapon_advancedrifle", label = "ADVANCED RIFLE", rarity = "epic", chance = 10, ammo = 120 },
            { name = "weapon_militaryrifle", label = "MILITARY RIFLE", rarity = "epic", chance = 10, ammo = 120 },
            { name = "weapon_combatmg", label = "COMBAT MG", rarity = "epic", chance = 8, ammo = 200 },
            { name = "weapon_mg", label = "MG", rarity = "epic", chance = 8, ammo = 200 },
            { name = "weapon_marksmanrifle", label = "MARKSMAN RIFLE", rarity = "epic", chance = 6, ammo = 60 },
            { name = "weapon_sniperrifle", label = "SNIPER RIFLE", rarity = "epic", chance = 5, ammo = 30 },
            { name = "weapon_heavysniper", label = "HEAVY SNIPER", rarity = "epic", chance = 3, ammo = 20 },
            { name = "weapon_rpg", label = "RPG", rarity = "epic", chance = 2, ammo = 5 },
            { name = "weapon_minigun", label = "MINIGUN", rarity = "epic", chance = 1, ammo = 500 },
            { name = "weapon_raypistol", label = "UP-N-ATOMIZER", rarity = "epic", chance = 2, ammo = 50 },
        },
    },

    -- Loot objects that can spawn during looting phase
    lootObjects = {
        -- Small
        { model = 'prop_box_ammo02a', value = 100 },
        { model = 'prop_box_ammo01a', value = 125 },
        { model = 'prop_cs_cardbox_01', value = 150 },
        { model = 'prop_box_ammo04a', value = 175 },
        { model = 'h4_prop_h4_crate_cloth_01a', value = 200 },
        -- Medium
        { model = 'prop_box_guncase_01a', value = 250 },
        { model = 'h4_prop_h4_box_ammo03a', value = 300 },
        { model = 'hei_prop_heist_box', value = 350 },
        { model = 'xm3_prop_xm3_boxwood_01a', value = 400 },
        { model = 'gr_prop_gr_v_mill_crate_01a', value = 450 },
        { model = 'ch_prop_ch_crate_full_01a', value = 500 },
        -- Large
        { model = 'h4_prop_h4_box_ammo_02a', value = 600 },
        { model = 'sm_prop_smug_crate_m_01a', value = 700 },
        { model = 'xm3_prop_xm3_crate_supp_01a', value = 800 },
        { model = 'prop_mb_crate_01a', value = 950 },
        { model = 'm23_2_prop_m32_prof_crate_01a', value = 1000 },
    },

    -- Loot object spawn locations (throughout bunker)
    lootSpawns = {
        vector4(875.14, -3239.73, -99.01, 344.52),
        vector4(830.70, -3234.73, -99.70, 13.10),
        vector4(848.60, -3243.16, -99.70, 252.69),
        vector4(856.70, -3212.95, -99.48, 4.02),
        vector4(867.32, -3186.84, -97.24, 103.16),
        vector4(886.75, -3207.90, -99.20, 228.03),
        vector4(892.10, -3202.05, -98.41, 94.38),
        vector4(892.75, -3197.66, -99.20, 290.72),
        vector4(901.03, -3182.22, -98.07, 284.69),
        vector4(881.40, -3186.44, -97.77, 94.30),
        vector4(905.45, -3205.83, -98.19, 107.79),
        vector4(905.69, -3229.21, -99.29, 164.47),
        vector4(891.48, -3225.61, -99.23, 46.45),
        vector4(900.52, -3221.99, -99.25, 295.65),
        vector4(928.44, -3208.96, -99.26, 351.04),
        vector4(937.01, -3195.43, -99.26, 353.11),
        vector4(941.36, -3216.75, -99.28, 174.96),
        vector4(937.50, -3236.90, -99.30, 117.45),
    },

    -- Enemy spawn settings
    -- spawnMode: "furthest" = spawn furthest from players (default)
    --            "minDistance" = random spawns, but filtered by minSpawnDistance (i.e. no peds will spawn within minSpawnDistance of the player)
    --            "random" = completely random, ignores player positions entirely
    -- minSpawnDistance: minimum distance from players (only used by "furthest" and "minDistance" modes, default: 15.0)
    enemySpawnSettings = {
        spawnMode = "furthest",
        minSpawnDistance = 15.0,
    },

    -- Enemy spawn locations (throughout bunker)
    enemySpawns = {
        vector4(858.74, -3248.08, -99.29, 96.55),
        vector4(839.84, -3238.60, -99.70, 67.69),
        vector4(857.21, -3214.66, -99.47, 357.02),
        vector4(874.11, -3203.65, -97.90, 337.12),
        vector4(866.22, -3186.80, -97.21, 73.37),
        vector4(900.24, -3182.26, -98.07, 269.57),
        vector4(893.83, -3190.79, -98.03, 267.30),
        vector4(895.60, -3201.19, -99.20, 60.94),
        vector4(883.33, -3204.17, -99.20, 141.25),
        vector4(890.12, -3210.28, -99.20, 140.18),
        vector4(905.32, -3205.86, -98.19, 289.38),
        vector4(895.61, -3221.60, -99.24, 148.17),
        vector4(905.47, -3226.01, -99.28, 278.72),
        vector4(921.76, -3214.58, -99.26, 256.01),
        vector4(935.12, -3196.04, -99.26, 289.03),
        vector4(949.07, -3220.68, -99.29, 197.98),
        vector4(933.28, -3222.02, -99.28, 55.85),
        vector4(930.94, -3239.26, -99.30, 116.32),
        vector4(919.40, -3226.50, -99.28, 354.73),
        vector4(902.95, -3215.42, -99.23, 94.84),
        vector4(911.99, -3237.20, -99.29, 273.43),
        vector4(883.68, -3240.56, -99.28, 83.50),
        vector4(868.87, -3226.23, -99.14, 351.14),
    },

    -- Rounds where players can choose to end the game early
    canEndGameOnRounds = {3, 5, 7, 10, 15},

    -- ============================================
    -- END GAME LOOT TABLE (Map-Level)
    -- ============================================
    -- Map-specific loot pool for end game rewards.
    -- This is used when NO per-difficulty endGameLoot is defined.
    -- Priority: difficulty-specific > map-level > main config fallback
    --
    -- Each item has: name, label, rarity, price, chance (weight), quantity (optional)
    -- Higher "chance" values = more likely to appear
    endGameLoot = {
        rerollCost = 200,
        itemCount = 6,
        duration = 60,

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

    -- ============================================
    -- OPTIONAL: Map-specific Shop Items
    -- ============================================
    -- Uncomment this block to override the default shop items from configs/config.lua
    -- If not defined, the default ShopItems from config.lua is used.
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
    -- ammoBoostMultiplier: how much to boost ammo chance when matching weapon is in shop (default 3x)
    --[[
    shopItems = {
        guaranteeAmmoForWeapons = true,
        ammoBoostMultiplier = 3,

        items = {
            itemCount = 6,
            list = {
                -- Healing
                { name = "bandage", label = "BANDAGE", rarity = "common", price = 150, quantity = 3, chance = 100 },
                { name = "firstaid", label = "FIRST AID KIT", rarity = "uncommon", price = 400, quantity = 1, chance = 50 },
                { name = "ifaks", label = "IFAK", rarity = "uncommon", price = 350, quantity = 1, chance = 55 },
                -- Food & Drink
                { name = "water", label = "WATER", rarity = "common", price = 100, quantity = 2, chance = 80 },
                { name = "burger", label = "BURGER", rarity = "common", price = 120, quantity = 2, chance = 75 },
                -- Armor
                { name = "armour", label = "BODY ARMOR", rarity = "rare", price = 600, quantity = 1, chance = 25 },
                -- Ammo (name must match WeaponAmmoTypes in config.lua)
                { name = "ammo-9", label = "9MM AMMO", rarity = "common", price = 100, quantity = 60, chance = 40, amount = 3 },
                { name = "ammo-rifle", label = "5.56 RIFLE AMMO", rarity = "uncommon", price = 150, quantity = 60, chance = 30, amount = 3 },
                { name = "ammo-shotgun", label = "12 GAUGE SHELLS", rarity = "uncommon", price = 140, quantity = 24, chance = 30, amount = 3 },
            },
        },

        weapons = {
            itemCount = 3,
            list = {
                -- Pistols
                { name = "weapon_pistol", label = "PISTOL", rarity = "common", price = 400, chance = 80 },
                { name = "weapon_combatpistol", label = "COMBAT PISTOL", rarity = "common", price = 500, chance = 70 },
                -- SMGs
                { name = "weapon_smg", label = "SMG", rarity = "rare", price = 900, chance = 30 },
                { name = "weapon_microsmg", label = "MICRO SMG", rarity = "uncommon", price = 700, chance = 40 },
                -- Shotguns
                { name = "weapon_pumpshotgun", label = "PUMP SHOTGUN", rarity = "uncommon", price = 750, chance = 35 },
                -- Rifles
                { name = "weapon_carbinerifle", label = "CARBINE RIFLE", rarity = "rare", price = 1200, chance = 20 },
                { name = "weapon_assaultrifle", label = "ASSAULT RIFLE", rarity = "rare", price = 1100, chance = 22 },
                -- Melee
                { name = "weapon_machete", label = "MACHETE", rarity = "uncommon", price = 350, chance = 40 },
            },
        },

        perks = {
            itemCount = 2,
            list = {
                { name = "thick_skin", label = "-25% DAMAGE TAKEN", rarity = "common", price = 500, chance = 80 },
                { name = "speed_demon", label = "+50% MOVEMENT SPEED", rarity = "uncommon", price = 750, chance = 50 },
                { name = "vampire", label = "+25 HP PER KILL (NO REGEN)", rarity = "rare", price = 1000, chance = 25 },
                { name = "double_damage", label = "+100% DAMAGE (+50% DMG TAKEN)", rarity = "rare", price = 1200, chance = 20 },
            },
        },
    },
    ]]

    -- Difficulty tiers
    difficulties = {
        easy = {
            label = "Easy",
            description = "Skeleton crew. A few guards watching the merchandise.",
            icon = "fa-face-smile",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 5,
                -- completedMaps = { { map = "server_farm", difficulty = "easy" } },
                -- item = "easy_access_key",
            },
            maxRounds = 5,
            killPoints = { min = 30, max = 80 },
            enemiesPerRound = {
                [1] = 8,
                [2] = 12,
                [3] = 16,
                [4] = 20,
                [5] = 24,
            },
            lootPerRound = {
                [1] = 3,
                [2] = 4,
                [3] = 5,
                [4] = 6,
                [5] = 7,
            },
            enemies = {
                models = {
                    "g_m_m_armboss_01",
                    "g_m_m_armgoon_01",
                    "g_m_y_armgoon_02",
                },
                weapons = {
                    `WEAPON_PISTOL`,
                    `WEAPON_COMBATPISTOL`,
                    `WEAPON_MICROSMG`,
                },
                health = { min = 130, max = 190 },
                armor = { min = 15, max = 40 },
                accuracy = 30,
                combatAbility = 1,
                combatRange = 1,
                canRagdoll = true,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 3,
                    name = "QUARTERMASTER",
                    subtitle = "Arms Dealer",
                    model = "g_m_m_armboss_01",
                    health = 1500,
                    armor = 100,
                    weapon = `WEAPON_ASSAULTRIFLE`,
                    accuracy = 45,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 500,
                },
                {
                    round = 5,
                    name = "HEAVY GUNNER",
                    subtitle = "Bunker Security Chief",
                    model = "s_m_y_armymech_01",
                    health = 2500,
                    armor = 150,
                    weapon = `WEAPON_MG`,
                    accuracy = 55,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 1000,
                },
            },

            -- Per-difficulty end game loot (overrides map-level endGameLoot)
            -- Easy: Lower chances for rare/epic items (-20-25%), slightly higher prices (+5-10%)
            endGameLoot = {
                rerollCost = 200,
                itemCount = 6,
                duration = 60,
                lootTable = {
                    -- ============================================
                    -- COMMON ITEMS (chance 60-100) - Silver jewelry, cash & heist tools
                    -- ============================================
                    { name = "bands", label = "Band of Notes", rarity = "common", price = 840, chance = 100, quantity = 3 },
                    { name = "rolls", label = "Roll of Notes", rarity = "common", price = 735, chance = 95, quantity = 3 },
                    { name = "md_silverring", label = "Silver Ring", rarity = "common", price = 945, chance = 90 },
                    { name = "md_silverearings", label = "Silver Earrings", rarity = "common", price = 1050, chance = 85 },
                    { name = "md_silverdime", label = "Silver Dime", rarity = "common", price = 630, chance = 95 },
                    { name = "md_blackwatch", label = "Watch", rarity = "common", price = 1155, chance = 80 },
                    { name = "md_ancientcoin", label = "Ancient Coin", rarity = "common", price = 1260, chance = 75 },
                    { name = "lockpick", label = "Lockpick", rarity = "common", price = 525, chance = 85, quantity = 3 },
                    { name = "advancedlockpick", label = "Advanced Lockpick", rarity = "common", price = 840, chance = 70 },
                    { name = "thermite", label = "Thermite", rarity = "common", price = 1575, chance = 65 },

                    -- ============================================
                    -- UNCOMMON ITEMS (chance 30-55) - Gold jewelry, cases & valuable loot
                    -- ============================================
                    { name = "md_silverounce", label = "1oz Silver Bar", rarity = "uncommon", price = 1890, chance = 55 },
                    { name = "md_goldring", label = "Gold Ring", rarity = "uncommon", price = 2310, chance = 50 },
                    { name = "md_golddollar", label = "Gold Dollar", rarity = "uncommon", price = 2100, chance = 52 },
                    { name = "md_goldearings", label = "Gold Earrings", rarity = "uncommon", price = 2625, chance = 45 },
                    { name = "goldchain", label = "Gold Chain", rarity = "uncommon", price = 2940, chance = 42 },
                    { name = "rolex", label = "Golden Watch", rarity = "uncommon", price = 3675, chance = 38 },
                    { name = "fleeca_case", label = "Fleeca Bank Case", rarity = "uncommon", price = 3150, chance = 40 },
                    { name = "house_case", label = "House Robbery Case", rarity = "uncommon", price = 2940, chance = 42 },
                    { name = "cryptostick", label = "Crypto Stick", rarity = "uncommon", price = 2625, chance = 45 },
                    { name = "drill", label = "Drill", rarity = "uncommon", price = 2100, chance = 48 },

                    -- ============================================
                    -- RARE ITEMS (chance 10-28) - Gold bars, diamonds & premium cases
                    -- ============================================
                    { name = "md_goldnecklace", label = "Gold Necklace", rarity = "rare", price = 4200, chance = 21 },
                    { name = "md_goldnugget", label = "Gold Nugget", rarity = "rare", price = 4725, chance = 19 },
                    { name = "md_diamondearings", label = "Diamond Earrings", rarity = "rare", price = 5250, chance = 17 },
                    { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 6300, chance = 14 },
                    { name = "diamond_ring", label = "Diamond Ring", rarity = "rare", price = 7350, chance = 11 },
                    { name = "jewelry_case", label = "Jewelry Store Case", rarity = "rare", price = 5775, chance = 15 },
                    { name = "chopshop_case", label = "Chop Shop Case", rarity = "rare", price = 4725, chance = 17 },
                    { name = "coke_small_brick", label = "Coke Package", rarity = "rare", price = 5250, chance = 15 },
                    { name = "md_goldounce", label = "1oz Gold Bar", rarity = "rare", price = 8400, chance = 9 },
                    { name = "md_platinumnugget", label = "Platinum Nugget", rarity = "rare", price = 9450, chance = 8 },

                    -- ============================================
                    -- EPIC ITEMS (chance 2-8) - Jackpot loot & legendary items
                    -- ============================================
                    { name = "md_diamondnecklace", label = "Diamond Necklace", rarity = "epic", price = 12600, chance = 6 },
                    { name = "md_diamondring", label = "Diamond Ring", rarity = "epic", price = 10500, chance = 6 },
                    { name = "md_presidentialwatch", label = "Presidential Watch", rarity = "epic", price = 15750, chance = 4 },
                    { name = "md_relicrevolver", label = "Relic Revolver", rarity = "epic", price = 12600, chance = 5 },
                    { name = "pacific_case", label = "Pacific Bank Case", rarity = "epic", price = 18900, chance = 3 },
                    { name = "casino_case", label = "Casino Heist Case", rarity = "epic", price = 26250, chance = 2 },
                    { name = "coke_brick", label = "Coke Brick", rarity = "epic", price = 15750, chance = 4 },
                    { name = "weed_brick", label = "Weed Brick", rarity = "epic", price = 12600, chance = 5 },
                    { name = "secured_safe", label = "Secured Safe", rarity = "epic", price = 14700, chance = 4 },
                    { name = "expensive_champagne", label = "Expensive Champagne", rarity = "epic", price = 8400, chance = 5, quantity = 3 },
                },
            },
        },
        normal = {
            label = "Normal",
            description = "Full security detail. Armed contractors protecting the operation.",
            icon = "fa-face-meh",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 8,
                completedMaps = {
                    { map = "gunrunning_bunker", difficulty = "easy" },
                },
                -- item = "normal_access_key",
            },
            maxRounds = 10,
            killPoints = { min = 60, max = 175 },
            enemiesPerRound = {
                [1] = 12,
                [2] = 16,
                [3] = 20,
                [4] = 24,
                [5] = 28,
                [6] = 32,
                [7] = 36,
                [8] = 40,
                [9] = 44,
                [10] = 50,
            },
            lootPerRound = {
                [1] = 4,
                [2] = 5,
                [3] = 5,
                [4] = 6,
                [5] = 6,
                [6] = 7,
                [7] = 7,
                [8] = 8,
                [9] = 8,
                [10] = 9,
            },
            enemies = {
                models = {
                    "g_m_m_armboss_01",
                    "g_m_m_armgoon_01",
                    "g_m_y_armgoon_02",
                    "s_m_y_blackops_01",
                },
                weapons = {
                    `WEAPON_COMBATPISTOL`,
                    `WEAPON_MICROSMG`,
                    `WEAPON_SMG`,
                    `WEAPON_CARBINERIFLE`,
                },
                health = { min = 170, max = 280 },
                armor = { min = 35, max = 85 },
                accuracy = 45,
                combatAbility = 1,
                combatRange = 2,
                canRagdoll = true,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 3,
                    name = "QUARTERMASTER",
                    subtitle = "Arms Dealer",
                    model = "g_m_m_armboss_01",
                    health = 2000,
                    armor = 150,
                    weapon = `WEAPON_CARBINERIFLE`,
                    accuracy = 50,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 750,
                },
                {
                    round = 6,
                    name = "THE FOREMAN",
                    subtitle = "Weapons Manufacturer",
                    model = "s_m_y_armymech_01",  -- Army mechanic, fits weapons manufacturing
                    health = 3500,
                    armor = 200,
                    weapon = `WEAPON_COMBATMG`,
                    accuracy = 55,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 1250,
                },
                {
                    round = 10,
                    name = "AGENT 14",
                    subtitle = "IAA Handler",
                    model = "csb_agent",
                    health = 5000,
                    armor = 300,
                    weapon = `WEAPON_SPECIALCARBINE`,
                    accuracy = 65,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 2500,
                },
            },

            -- Per-difficulty end game loot (overrides map-level endGameLoot)
            -- Normal: Base values (same as map-level endGameLoot)
            endGameLoot = {
                rerollCost = 200,
                itemCount = 6,
                duration = 60,
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
        },
        hard = {
            label = "Hard",
            description = "Merryweather backup. Professional mercenaries defending the bunker.",
            icon = "fa-face-angry",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 12,
                completedMaps = {
                    { map = "gunrunning_bunker", difficulty = "normal" },
                },
                -- item = "hard_access_key",
            },
            maxRounds = 15,
            killPoints = { min = 90, max = 225 },
            enemiesPerRound = {
                [1] = 18,
                [2] = 22,
                [3] = 26,
                [4] = 30,
                [5] = 34,
                [6] = 38,
                [7] = 42,
                [8] = 46,
                [9] = 50,
                [10] = 55,
                [11] = 60,
                [12] = 65,
                [13] = 70,
                [14] = 75,
                [15] = 80,
            },
            lootPerRound = {
                [1] = 5,
                [2] = 5,
                [3] = 6,
                [4] = 6,
                [5] = 7,
                [6] = 7,
                [7] = 8,
                [8] = 8,
                [9] = 9,
                [10] = 9,
                [11] = 10,
                [12] = 10,
                [13] = 11,
                [14] = 11,
                [15] = 12,
            },
            enemies = {
                models = {
                    "s_m_y_armymech_01",
                    "s_m_m_merimsec_01",  -- Merryweather security
                    "s_m_y_blackops_01",
                    "s_m_y_blackops_02",
                },
                weapons = {
                    `WEAPON_SMG`,
                    `WEAPON_ASSAULTRIFLE`,
                    `WEAPON_CARBINERIFLE`,
                    `WEAPON_SPECIALCARBINE`,
                },
                health = { min = 220, max = 400 },
                armor = { min = 60, max = 130 },
                accuracy = 60,
                combatAbility = 2,
                combatRange = 2,
                canRagdoll = false,
                canHeadshot = false,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 4,
                    name = "MERRYWEATHER CAPTAIN",
                    subtitle = "PMC Commander",
                    model = "s_m_m_merimsec_01",  -- Merryweather security
                    health = 4000,
                    armor = 250,
                    weapon = `WEAPON_SPECIALCARBINE`,
                    accuracy = 60,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 1500,
                },
                {
                    round = 9,
                    name = "THE SUPPLIER",
                    subtitle = "Black Market Kingpin",
                    model = "g_m_m_armboss_01",  -- Arms dealer boss, fits black market kingpin
                    health = 6000,
                    armor = 350,
                    weapon = `WEAPON_COMBATMG`,
                    accuracy = 65,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 2500,
                },
                {
                    round = 15,
                    name = "WAR MACHINE",
                    subtitle = "Walking Arsenal",
                    model = "u_m_y_juggernaut_01",
                    health = 10000,
                    armor = 500,
                    weapon = `WEAPON_MINIGUN`,
                    accuracy = 70,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 5000,
                },
            },

            -- Per-difficulty end game loot (overrides map-level endGameLoot)
            -- Hard: Better chances for rare/epic (+25-40%), slightly lower prices (-5-10%)
            endGameLoot = {
                rerollCost = 200,
                itemCount = 6,
                duration = 60,
                lootTable = {
                    -- ============================================
                    -- COMMON ITEMS (chance 60-100) - Silver jewelry, cash & heist tools
                    -- ============================================
                    { name = "bands", label = "Band of Notes", rarity = "common", price = 720, chance = 100, quantity = 3 },
                    { name = "rolls", label = "Roll of Notes", rarity = "common", price = 630, chance = 95, quantity = 3 },
                    { name = "md_silverring", label = "Silver Ring", rarity = "common", price = 810, chance = 90 },
                    { name = "md_silverearings", label = "Silver Earrings", rarity = "common", price = 900, chance = 85 },
                    { name = "md_silverdime", label = "Silver Dime", rarity = "common", price = 540, chance = 95 },
                    { name = "md_blackwatch", label = "Watch", rarity = "common", price = 990, chance = 80 },
                    { name = "md_ancientcoin", label = "Ancient Coin", rarity = "common", price = 1080, chance = 75 },
                    { name = "lockpick", label = "Lockpick", rarity = "common", price = 450, chance = 85, quantity = 3 },
                    { name = "advancedlockpick", label = "Advanced Lockpick", rarity = "common", price = 720, chance = 70 },
                    { name = "thermite", label = "Thermite", rarity = "common", price = 1350, chance = 65 },

                    -- ============================================
                    -- UNCOMMON ITEMS (chance 30-55) - Gold jewelry, cases & valuable loot
                    -- ============================================
                    { name = "md_silverounce", label = "1oz Silver Bar", rarity = "uncommon", price = 1620, chance = 55 },
                    { name = "md_goldring", label = "Gold Ring", rarity = "uncommon", price = 1980, chance = 50 },
                    { name = "md_golddollar", label = "Gold Dollar", rarity = "uncommon", price = 1800, chance = 52 },
                    { name = "md_goldearings", label = "Gold Earrings", rarity = "uncommon", price = 2250, chance = 45 },
                    { name = "goldchain", label = "Gold Chain", rarity = "uncommon", price = 2520, chance = 42 },
                    { name = "rolex", label = "Golden Watch", rarity = "uncommon", price = 3150, chance = 38 },
                    { name = "fleeca_case", label = "Fleeca Bank Case", rarity = "uncommon", price = 2700, chance = 40 },
                    { name = "house_case", label = "House Robbery Case", rarity = "uncommon", price = 2520, chance = 42 },
                    { name = "cryptostick", label = "Crypto Stick", rarity = "uncommon", price = 2250, chance = 45 },
                    { name = "drill", label = "Drill", rarity = "uncommon", price = 1800, chance = 48 },

                    -- ============================================
                    -- RARE ITEMS (chance 10-28) - Gold bars, diamonds & premium cases
                    -- ============================================
                    { name = "md_goldnecklace", label = "Gold Necklace", rarity = "rare", price = 3600, chance = 35 },
                    { name = "md_goldnugget", label = "Gold Nugget", rarity = "rare", price = 4050, chance = 31 },
                    { name = "md_diamondearings", label = "Diamond Earrings", rarity = "rare", price = 4500, chance = 28 },
                    { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 5400, chance = 23 },
                    { name = "diamond_ring", label = "Diamond Ring", rarity = "rare", price = 6300, chance = 19 },
                    { name = "jewelry_case", label = "Jewelry Store Case", rarity = "rare", price = 4950, chance = 25 },
                    { name = "chopshop_case", label = "Chop Shop Case", rarity = "rare", price = 4050, chance = 28 },
                    { name = "coke_small_brick", label = "Coke Package", rarity = "rare", price = 4500, chance = 25 },
                    { name = "md_goldounce", label = "1oz Gold Bar", rarity = "rare", price = 7200, chance = 15 },
                    { name = "md_platinumnugget", label = "Platinum Nugget", rarity = "rare", price = 8100, chance = 13 },

                    -- ============================================
                    -- EPIC ITEMS (chance 2-8) - Jackpot loot & legendary items
                    -- ============================================
                    { name = "md_diamondnecklace", label = "Diamond Necklace", rarity = "epic", price = 10800, chance = 10 },
                    { name = "md_diamondring", label = "Diamond Ring", rarity = "epic", price = 9000, chance = 10 },
                    { name = "md_presidentialwatch", label = "Presidential Watch", rarity = "epic", price = 13500, chance = 6 },
                    { name = "md_relicrevolver", label = "Relic Revolver", rarity = "epic", price = 10800, chance = 8 },
                    { name = "pacific_case", label = "Pacific Bank Case", rarity = "epic", price = 16200, chance = 5 },
                    { name = "casino_case", label = "Casino Heist Case", rarity = "epic", price = 22500, chance = 3 },
                    { name = "coke_brick", label = "Coke Brick", rarity = "epic", price = 13500, chance = 6 },
                    { name = "weed_brick", label = "Weed Brick", rarity = "epic", price = 10800, chance = 8 },
                    { name = "secured_safe", label = "Secured Safe", rarity = "epic", price = 12600, chance = 6 },
                    { name = "expensive_champagne", label = "Expensive Champagne", rarity = "epic", price = 7200, chance = 9, quantity = 3 },
                },
            },
        },
        nightmare = {
            label = "Nightmare",
            description = "Full lockdown. Elite PMC units with heavy weapons and armor.",
            icon = "fa-skull",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 20,
                completedMaps = {
                    { map = "gunrunning_bunker", difficulty = "hard" },
                },
                -- item = "nightmare_access_key",
            },
            maxRounds = 20,
            killPoints = { min = 125, max = 350 },
            enemiesPerRound = {
                [1] = 24,
                [2] = 28,
                [3] = 32,
                [4] = 36,
                [5] = 40,
                [6] = 44,
                [7] = 48,
                [8] = 52,
                [9] = 58,
                [10] = 64,
                [11] = 70,
                [12] = 76,
                [13] = 82,
                [14] = 88,
                [15] = 94,
                [16] = 100,
                [17] = 106,
                [18] = 112,
                [19] = 120,
                [20] = 130,
            },
            lootPerRound = {
                [1] = 6,
                [2] = 6,
                [3] = 7,
                [4] = 7,
                [5] = 8,
                [6] = 8,
                [7] = 9,
                [8] = 9,
                [9] = 10,
                [10] = 10,
                [11] = 11,
                [12] = 11,
                [13] = 12,
                [14] = 12,
                [15] = 13,
                [16] = 13,
                [17] = 14,
                [18] = 14,
                [19] = 15,
                [20] = 16,
            },
            enemies = {
                models = {
                    "s_m_y_armymech_01",
                    "s_m_m_merimsec_01",  -- Merryweather security
                    "s_m_y_blackops_01",
                    "s_m_y_blackops_02",
                    "s_m_y_blackops_03",
                    "u_m_y_juggernaut_01",
                },
                weapons = {
                    `WEAPON_CARBINERIFLE`,
                    `WEAPON_SPECIALCARBINE`,
                    `WEAPON_ADVANCEDRIFLE`,
                    `WEAPON_MG`,
                    `WEAPON_COMBATMG`,
                },
                health = { min = 320, max = 550 },
                armor = { min = 110, max = 220 },
                accuracy = 75,
                combatAbility = 2,
                combatRange = 2,
                canRagdoll = false,
                canHeadshot = false,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 5,
                    name = "IRON HAMMER",
                    subtitle = "Elite PMC Operator",
                    model = "s_m_m_merimsec_01",  -- Merryweather elite
                    health = 8000,
                    armor = 400,
                    weapon = `WEAPON_COMBATMG`,
                    accuracy = 70,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 3000,
                },
                {
                    round = 12,
                    name = "THE ARMS BARON",
                    subtitle = "International Dealer",
                    model = "g_m_m_armboss_01",  -- Arms dealer boss
                    health = 12000,
                    armor = 500,
                    weapon = `WEAPON_MG`,
                    accuracy = 75,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 5000,
                },
                {
                    round = 20,
                    name = "DOOMSDAY DEVICE",
                    subtitle = "Ultimate Weapon",
                    model = "u_m_y_juggernaut_01",
                    health = 20000,
                    armor = 750,
                    weapon = `WEAPON_MINIGUN`,
                    accuracy = 80,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 10000,
                },
            },

            -- Per-difficulty end game loot (overrides map-level endGameLoot)
            -- Nightmare: Best chances for rare/epic (+50-75%), lowest prices (-10-15%)
            endGameLoot = {
                rerollCost = 200,
                itemCount = 6,
                duration = 60,
                lootTable = {
                    -- ============================================
                    -- COMMON ITEMS (chance 60-100) - Silver jewelry, cash & heist tools
                    -- ============================================
                    { name = "bands", label = "Band of Notes", rarity = "common", price = 680, chance = 100, quantity = 3 },
                    { name = "rolls", label = "Roll of Notes", rarity = "common", price = 595, chance = 95, quantity = 3 },
                    { name = "md_silverring", label = "Silver Ring", rarity = "common", price = 765, chance = 90 },
                    { name = "md_silverearings", label = "Silver Earrings", rarity = "common", price = 850, chance = 85 },
                    { name = "md_silverdime", label = "Silver Dime", rarity = "common", price = 510, chance = 95 },
                    { name = "md_blackwatch", label = "Watch", rarity = "common", price = 935, chance = 80 },
                    { name = "md_ancientcoin", label = "Ancient Coin", rarity = "common", price = 1020, chance = 75 },
                    { name = "lockpick", label = "Lockpick", rarity = "common", price = 425, chance = 85, quantity = 3 },
                    { name = "advancedlockpick", label = "Advanced Lockpick", rarity = "common", price = 680, chance = 70 },
                    { name = "thermite", label = "Thermite", rarity = "common", price = 1275, chance = 65 },

                    -- ============================================
                    -- UNCOMMON ITEMS (chance 30-55) - Gold jewelry, cases & valuable loot
                    -- ============================================
                    { name = "md_silverounce", label = "1oz Silver Bar", rarity = "uncommon", price = 1530, chance = 55 },
                    { name = "md_goldring", label = "Gold Ring", rarity = "uncommon", price = 1870, chance = 50 },
                    { name = "md_golddollar", label = "Gold Dollar", rarity = "uncommon", price = 1700, chance = 52 },
                    { name = "md_goldearings", label = "Gold Earrings", rarity = "uncommon", price = 2125, chance = 45 },
                    { name = "goldchain", label = "Gold Chain", rarity = "uncommon", price = 2380, chance = 42 },
                    { name = "rolex", label = "Golden Watch", rarity = "uncommon", price = 2975, chance = 38 },
                    { name = "fleeca_case", label = "Fleeca Bank Case", rarity = "uncommon", price = 2550, chance = 40 },
                    { name = "house_case", label = "House Robbery Case", rarity = "uncommon", price = 2380, chance = 42 },
                    { name = "cryptostick", label = "Crypto Stick", rarity = "uncommon", price = 2125, chance = 45 },
                    { name = "drill", label = "Drill", rarity = "uncommon", price = 1700, chance = 48 },

                    -- ============================================
                    -- RARE ITEMS (chance 10-28) - Gold bars, diamonds & premium cases
                    -- ============================================
                    { name = "md_goldnecklace", label = "Gold Necklace", rarity = "rare", price = 3400, chance = 42 },
                    { name = "md_goldnugget", label = "Gold Nugget", rarity = "rare", price = 3825, chance = 38 },
                    { name = "md_diamondearings", label = "Diamond Earrings", rarity = "rare", price = 4250, chance = 33 },
                    { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 5100, chance = 27 },
                    { name = "diamond_ring", label = "Diamond Ring", rarity = "rare", price = 5950, chance = 23 },
                    { name = "jewelry_case", label = "Jewelry Store Case", rarity = "rare", price = 4675, chance = 30 },
                    { name = "chopshop_case", label = "Chop Shop Case", rarity = "rare", price = 3825, chance = 33 },
                    { name = "coke_small_brick", label = "Coke Package", rarity = "rare", price = 4250, chance = 30 },
                    { name = "md_goldounce", label = "1oz Gold Bar", rarity = "rare", price = 6800, chance = 18 },
                    { name = "md_platinumnugget", label = "Platinum Nugget", rarity = "rare", price = 7650, chance = 15 },

                    -- ============================================
                    -- EPIC ITEMS (chance 2-8) - Jackpot loot & legendary items
                    -- ============================================
                    { name = "md_diamondnecklace", label = "Diamond Necklace", rarity = "epic", price = 10200, chance = 12 },
                    { name = "md_diamondring", label = "Diamond Ring", rarity = "epic", price = 8500, chance = 12 },
                    { name = "md_presidentialwatch", label = "Presidential Watch", rarity = "epic", price = 12750, chance = 8 },
                    { name = "md_relicrevolver", label = "Relic Revolver", rarity = "epic", price = 10200, chance = 9 },
                    { name = "pacific_case", label = "Pacific Bank Case", rarity = "epic", price = 15300, chance = 6 },
                    { name = "casino_case", label = "Casino Heist Case", rarity = "epic", price = 21250, chance = 3 },
                    { name = "coke_brick", label = "Coke Brick", rarity = "epic", price = 12750, chance = 8 },
                    { name = "weed_brick", label = "Weed Brick", rarity = "epic", price = 10200, chance = 9 },
                    { name = "secured_safe", label = "Secured Safe", rarity = "epic", price = 11900, chance = 8 },
                    { name = "expensive_champagne", label = "Expensive Champagne", rarity = "epic", price = 6800, chance = 11, quantity = 3 },
                },
            },
        },
    },
}
