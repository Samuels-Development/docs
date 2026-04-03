-- ============================================
-- SERVER FARM MAP
-- ============================================

return {
    id = "server_farm",  -- Unique map identifier
    label = "Server Farm",
    description = "A hidden underground server farm housing classified data. Narrow corridors lined with server racks and heavy security make this a high-risk infiltration.",
    icon = "fa-server",

    -- Map intro text configuration (shown when game starts)
    intro = {
        enabled = true,
        title = "INFILTRATE THE\nSERVER FARM",
        subtitle = nil,
        description = "A HIDDEN UNDERGROUND SERVER FARM HOUSING CLASSIFIED DATA. SURVIVE THE WAVES, COLLECT VALUABLE LOOT, AND ESCAPE WITH YOUR LIFE.",
        tagline = "THE SERVERS ARE WATCHING. STAY ALERT!",
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
        level = 1,
        -- completedMaps = {
        --     { map = "other_map", difficulty = "normal" },
        --     { map = "another_map", difficulty = "easy" },      -- Can require multiple maps!
        -- },
        -- item = "horde_access_key",                             -- Single item (not consumed)
        -- item = { name = "horde_access_key", consume = true },  -- Single item (consumed on start)
        -- items = {                                              -- Multiple items example:
        --     { name = "horde_access_key", consume = true },     -- This item will be consumed
        --     { name = "lockpick", count = 2 },                  -- These items will NOT be consumed
        -- },
    },

    -- Entry location (where players go to enter the horde)
    entryLocation = {
        coords = vector4(3.93, -200.44, 52.89, 344.66),
        blip = {
            sprite = 310,
            color = 1,
            scale = 0.8,
            label = "Horde Entry",
        },
        radius = 2.0,
    },

    -- Leave location (where players are teleported when game ends)
    leaveLocation = vec4(3.56, -201.21, 52.74, 159.47),

    -- End loot crate location (where players collect rewards after game ends)
    endLootLocation = {
        coords = vector4(-0.11, -201.83, 51.74, 130.77),
        model = 'v_ind_cfcrate3',
    },

    spawnPoint = vec4(2155.38, 2921.12, -81.08, 269.83),

    -- Zone boundary points (for lib.zones poly zone)
    -- Players will be warned/teleported back if they leave this area
    zonePoints = {
        vec3(1978.08, 2952.60, -85.80),
        vec3(1977.09, 2951.84, -85.80),
        vec3(1977.15, 2889.95, -85.80),
        vec3(1978.07, 2889.16, -85.80),
        vec3(2098.51, 2889.18, -85.80),
        vec3(2167.57, 2902.02, -85.80),
        vec3(2236.61, 2889.41, -85.80),
        vec3(2358.07, 2889.25, -85.80),
        vec3(2359.00, 2889.99, -85.80),
        vec3(2358.97, 2951.74, -85.80),
        vec3(2358.04, 2952.53, -85.80),
        vec3(2237.67, 2952.56, -85.80),
        vec3(2168.63, 2939.82, -85.80),
        vec3(2099.59, 2952.45, -85.80),
        vec3(2098.47, 2952.55, -85.80),
        vec3(1978.08, 2952.45, -85.80),
    },
    zoneThickness = 20.0, -- Height of the zone (above/below center point)

    -- Terminal configuration (shop access point)
    terminal = {
        coords = vector3(2185.78, 2928.72, -84.96),
        -- object = {
        --     model = 'prop_laptop_01a',
        --     heading = 0.0,
        -- },
    },

    -- Deposit crate configuration
    depositCrate = {
        model = 'tr_prop_tr_mil_crate_02',
        coords = vector3(2183.47, 2925.16, -85.80),
        heading = 0.0,
    },

    -- Mystery Box configuration (COD-style random weapon box)
    -- Weapon display models are configured in configs/config.lua under WeaponDisplayModels
    -- Add new weapon-to-model mappings there to display them correctly in the mystery box
    mysteryBox = {
        enabled = true,
        coords = vector3(2185.22, 2919.94, -85.8),
        heading = 269.95,
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

    -- Loot object spawn locations (x, y, z, heading)
    lootSpawns = {
        vec4(2208.97, 2931.20, -85.80, 324.97),
        vec4(2201.36, 2920.87, -85.72, 180.03),
        vec4(2208.17, 2900.67, -85.80, 201.76),
        vec4(2225.99, 2911.73, -85.80, 189.36),
        vec4(2234.00, 2921.09, -85.80, 40.71),
        vec4(2233.90, 2937.69, -85.80, 141.13),
        vec4(2240.49, 2950.35, -85.80, 343.20),
        vec4(2259.69, 2929.88, -85.80, 183.14),
        vec4(2259.83, 2903.74, -85.80, 133.79),
        vec4(2278.40, 2912.92, -85.80, 263.29),
        vec4(2278.38, 2928.92, -85.80, 7.50),
        vec4(2270.07, 2950.83, -85.80, 131.08),
        vec4(2306.73, 2942.19, -85.80, 268.92),
        vec4(2318.09, 2936.58, -85.80, 202.88),
        vec4(2318.51, 2914.67, -85.80, 179.09),
        vec4(2331.00, 2924.75, -85.79, 271.70),
        vec4(2338.51, 2935.21, -85.80, 342.78),
        vec4(2345.78, 2916.85, -85.80, 192.33),
        vec4(2330.79, 2908.47, -85.80, 168.61),
        vec4(2348.56, 2899.87, -85.80, 11.69),
        vec4(2348.57, 2891.08, -85.80, 264.94),
        vec4(2357.33, 2900.09, -85.79, 0.21),
        vec4(2357.35, 2933.98, -85.79, 359.81),
        vec4(2174.62, 2938.99, -85.79, 96.70),
        vec4(2177.99, 2920.38, -85.80, 145.51),
        vec4(2173.36, 2924.57, -82.08, 13.22),
        vec4(2127.38, 2931.44, -85.80, 80.03),
        vec4(2127.38, 2911.05, -85.80, 182.49),
        vec4(2113.15, 2902.76, -85.80, 101.18),
        vec4(2110.20, 2913.36, -85.79, 84.17),
        vec4(2093.63, 2908.54, -85.80, 88.55),
        vec4(2101.34, 2931.92, -85.80, 5.25),
        vec4(2111.70, 2944.32, -85.80, 310.42),
        vec4(2084.84, 2933.52, -85.80, 180.39),
        vec4(2076.87, 2950.26, -85.79, 81.65),
        vec4(2076.30, 2935.93, -85.80, 189.06),
        vec4(2076.44, 2908.50, -85.79, 180.89),
        vec4(2057.70, 2909.66, -85.80, 97.97),
        vec4(2049.48, 2916.22, -85.80, 57.08),
        vec4(2051.46, 2942.13, -85.80, 357.07),
        vec4(2057.23, 2950.59, -85.79, 14.28),
        vec4(2037.90, 2931.01, -85.80, 175.72),
        vec4(2022.09, 2933.02, -85.80, 87.67),
        vec4(2018.03, 2911.39, -85.80, 178.30),
        vec4(1997.86, 2921.61, -85.80, 33.34),
        vec4(1997.66, 2899.66, -85.79, 182.54),
        vec4(2005.69, 2941.64, -85.80, 359.66),
        vec4(1993.27, 2950.63, -85.80, 20.41),
        vec4(1978.63, 2941.92, -85.79, 92.74),
        vec4(1978.84, 2908.51, -85.80, 180.28),
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

    -- Enemy spawn locations (shared across difficulties)
    enemySpawns = {
        vec4(2225.62, 2927.72, -85.80, 173.15),
        vec4(2235.80, 2924.91, -85.80, 265.72),
        vec4(2235.11, 2934.03, -85.79, 350.84),
        vec4(2231.09, 2940.75, -85.80, 25.77),
        vec4(2246.86, 2925.07, -85.80, 270.81),
        vec4(2234.59, 2909.85, -85.80, 185.21),
        vec4(2234.57, 2901.52, -85.80, 180.05),
        vec4(2248.82, 2899.75, -85.80, 266.72),
        vec4(2240.73, 2894.68, -85.80, 220.61),
        vec4(2212.65, 2907.63, -85.80, 58.97),
        vec4(2200.50, 2907.16, -85.80, 81.07),
        vec4(2193.06, 2919.93, -85.80, 4.75),
        vec4(2128.75, 2905.99, -85.79, 99.72),
        vec4(2127.01, 2911.55, -85.80, 7.09),
        vec4(2126.82, 2920.95, -85.80, 1.06),
        vec4(2114.61, 2916.76, -85.80, 132.40),
        vec4(2119.03, 2921.05, -85.80, 0.41),
        vec4(2114.02, 2925.32, -85.80, 85.65),
        vec4(2110.96, 2934.27, -85.80, 357.98),
        vec4(2111.56, 2939.82, -85.80, 354.74),
        vec4(2111.92, 2947.65, -85.79, 357.35),
        vec4(2096.07, 2942.08, -85.80, 82.43),
        vec4(2095.64, 2933.62, -85.80, 166.99),
        vec4(2093.79, 2925.41, -85.80, 167.10),
        vec4(2093.86, 2916.80, -85.80, 90.0),
    },

    -- Rounds where players can choose to end the game early (during looting phase)
    canEndGameOnRounds = {3, 5, 7, 10},

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

    -- Difficulty tiers for this map
    difficulties = {
        easy = {
            label = "Easy",
            description = "Light security detail. Basic guards with minimal training.",
            icon = "fa-face-smile",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 1,
                -- item = { name = "blueprint_advancedlockpick", consume = false },
                -- item = "easy_access_key",
            },
            maxRounds = 5,
            killPoints = { min = 25, max = 75 },
            -- Max alive enemies at once (optional, overrides Config.MaxAliveEnemies for this difficulty)
            -- When set, only this many enemies will be alive at once.
            -- As enemies are killed, new ones spawn until the round's total is reached.
            -- Example: enemiesPerRound = 30, maxAliveEnemies = 15 -> 15 spawn initially,
            -- when one dies another spawns, until all 30 have been spawned and killed.
            -- Set to nil or 0 to use the global Config.MaxAliveEnemies value.
            -- maxAliveEnemies = 10,
            enemiesPerRound = {
                [1] = 6,
                [2] = 10,
                [3] = 14,
                [4] = 18,
                [5] = 22,
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
                    "s_m_m_security_01",
                    "s_m_y_doorman_01",
                },
                weapons = {
                    `WEAPON_PISTOL`,
                    `WEAPON_COMBATPISTOL`,
                },
                health = { min = 120, max = 180 },
                armor = { min = 0, max = 25 },
                accuracy = 25,
                combatAbility = 0,
                combatRange = 1,
                canRagdoll = true,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 3,
                    name = "CHIEF SECURITY",
                    subtitle = "Facility Guardian",
                    model = "s_m_m_highsec_01",  -- High security guard
                    health = 1500,
                    armor = 100,
                    weapon = `WEAPON_SMG`,
                    accuracy = 45,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 500,
                },
                {
                    round = 5,
                    name = "SYSADMIN BRUTE",
                    subtitle = "Server Protector",
                    model = "mp_m_securoguard_01",  -- Security uniform
                    health = 2500,
                    armor = 150,
                    weapon = `WEAPON_ASSAULTRIFLE`,
                    accuracy = 55,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 1000,
                },
            },
            -- Per-difficulty end game loot (overrides map-level endGameLoot)
            -- Easy: Lower chances for rare/epic items, slightly higher prices
            endGameLoot = {
                rerollCost = 200,
                itemCount = 6,
                duration = 60,
                lootTable = {
                    -- COMMON ITEMS (higher chances on easy)
                    { name = "bands", label = "Band of Notes", rarity = "common", price = 850, chance = 100, quantity = 3 },
                    { name = "rolls", label = "Roll of Notes", rarity = "common", price = 750, chance = 95, quantity = 3 },
                    { name = "md_silverring", label = "Silver Ring", rarity = "common", price = 950, chance = 90 },
                    { name = "md_silverearings", label = "Silver Earrings", rarity = "common", price = 1050, chance = 85 },
                    { name = "md_silverdime", label = "Silver Dime", rarity = "common", price = 650, chance = 95 },
                    { name = "md_blackwatch", label = "Watch", rarity = "common", price = 1150, chance = 80 },
                    { name = "md_ancientcoin", label = "Ancient Coin", rarity = "common", price = 1250, chance = 75 },
                    { name = "lockpick", label = "Lockpick", rarity = "common", price = 550, chance = 85, quantity = 3 },
                    { name = "advancedlockpick", label = "Advanced Lockpick", rarity = "common", price = 850, chance = 70 },
                    { name = "thermite", label = "Thermite", rarity = "common", price = 1550, chance = 65 },
                    -- UNCOMMON ITEMS (slightly lower chances on easy)
                    { name = "md_silverounce", label = "1oz Silver Bar", rarity = "uncommon", price = 1900, chance = 50 },
                    { name = "md_goldring", label = "Gold Ring", rarity = "uncommon", price = 2300, chance = 45 },
                    { name = "md_golddollar", label = "Gold Dollar", rarity = "uncommon", price = 2100, chance = 47 },
                    { name = "md_goldearings", label = "Gold Earrings", rarity = "uncommon", price = 2600, chance = 40 },
                    { name = "goldchain", label = "Gold Chain", rarity = "uncommon", price = 2900, chance = 37 },
                    { name = "rolex", label = "Golden Watch", rarity = "uncommon", price = 3600, chance = 33 },
                    { name = "fleeca_case", label = "Fleeca Bank Case", rarity = "uncommon", price = 3100, chance = 35 },
                    { name = "house_case", label = "House Robbery Case", rarity = "uncommon", price = 2900, chance = 37 },
                    { name = "cryptostick", label = "Crypto Stick", rarity = "uncommon", price = 2600, chance = 40 },
                    { name = "drill", label = "Drill", rarity = "uncommon", price = 2100, chance = 43 },
                    -- RARE ITEMS (lower chances on easy)
                    { name = "md_goldnecklace", label = "Gold Necklace", rarity = "rare", price = 4200, chance = 22 },
                    { name = "md_goldnugget", label = "Gold Nugget", rarity = "rare", price = 4700, chance = 20 },
                    { name = "md_diamondearings", label = "Diamond Earrings", rarity = "rare", price = 5200, chance = 17 },
                    { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 6200, chance = 14 },
                    { name = "diamond_ring", label = "Diamond Ring", rarity = "rare", price = 7200, chance = 11 },
                    { name = "jewelry_case", label = "Jewelry Store Case", rarity = "rare", price = 5700, chance = 15 },
                    { name = "chopshop_case", label = "Chop Shop Case", rarity = "rare", price = 4700, chance = 17 },
                    { name = "coke_small_brick", label = "Coke Package", rarity = "rare", price = 5200, chance = 15 },
                    { name = "md_goldounce", label = "1oz Gold Bar", rarity = "rare", price = 8200, chance = 9 },
                    { name = "md_platinumnugget", label = "Platinum Nugget", rarity = "rare", price = 9200, chance = 7 },
                    -- EPIC ITEMS (much lower chances on easy)
                    { name = "md_diamondnecklace", label = "Diamond Necklace", rarity = "epic", price = 12500, chance = 5 },
                    { name = "md_diamondring", label = "Diamond Ring", rarity = "epic", price = 10500, chance = 5 },
                    { name = "md_presidentialwatch", label = "Presidential Watch", rarity = "epic", price = 15500, chance = 3 },
                    { name = "md_relicrevolver", label = "Relic Revolver", rarity = "epic", price = 12500, chance = 4 },
                    { name = "pacific_case", label = "Pacific Bank Case", rarity = "epic", price = 18500, chance = 2 },
                    { name = "casino_case", label = "Casino Heist Case", rarity = "epic", price = 25500, chance = 1 },
                    { name = "coke_brick", label = "Coke Brick", rarity = "epic", price = 15500, chance = 3 },
                    { name = "weed_brick", label = "Weed Brick", rarity = "epic", price = 12500, chance = 4 },
                    { name = "secured_safe", label = "Secured Safe", rarity = "epic", price = 14500, chance = 3 },
                    { name = "expensive_champagne", label = "Expensive Champagne", rarity = "epic", price = 8500, chance = 5, quantity = 3 },
                },
            },
        },
        normal = {
            label = "Normal",
            description = "Standard security response. Armed guards with tactical training.",
            icon = "fa-face-meh",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 3,
                completedMaps = {
                    { map = "server_farm", difficulty = "easy" },
                },
                -- item = "normal_access_key",
            },
            maxRounds = 10,
            killPoints = { min = 50, max = 150 },
            enemiesPerRound = {
                [1] = 10,
                [2] = 14,
                [3] = 18,
                [4] = 22,
                [5] = 26,
                [6] = 30,
                [7] = 34,
                [8] = 38,
                [9] = 42,
                [10] = 48,
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
                    "s_m_m_security_01",
                    "s_m_m_highsec_01",
                    "s_m_m_highsec_02",
                },
                weapons = {
                    `WEAPON_PISTOL`,
                    `WEAPON_COMBATPISTOL`,
                    `WEAPON_MICROSMG`,
                    `WEAPON_SMG`,
                },
                health = { min = 150, max = 250 },
                armor = { min = 25, max = 75 },
                accuracy = 40,
                combatAbility = 1,
                combatRange = 2,
                canRagdoll = true,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 3,
                    name = "CHIEF SECURITY",
                    subtitle = "Facility Guardian",
                    model = "s_m_m_highsec_01",
                    health = 2000,
                    armor = 150,
                    weapon = `WEAPON_COMBATPISTOL`,
                    accuracy = 50,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 750,
                },
                {
                    round = 6,
                    name = "ADMINISTRATOR",
                    subtitle = "System Overlord",
                    model = "mp_m_securoguard_01",
                    health = 3500,
                    armor = 200,
                    weapon = `WEAPON_ASSAULTRIFLE`,
                    accuracy = 55,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 1250,
                },
                {
                    round = 10,
                    name = "FIREWALL",
                    subtitle = "Final Defense Protocol",
                    model = "s_m_y_swat_01",
                    health = 5000,
                    armor = 300,
                    weapon = `WEAPON_COMBATMG`,
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
                    -- COMMON ITEMS
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
                    -- UNCOMMON ITEMS
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
                    -- RARE ITEMS
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
                    -- EPIC ITEMS
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
            description = "Elite security team. Heavily armed mercenaries protecting the facility.",
            icon = "fa-face-angry",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 7,
                completedMaps = {
                    { map = "server_farm", difficulty = "normal" },
                },
                -- item = "hard_access_key",
            },
            maxRounds = 15,
            killPoints = { min = 75, max = 200 },
            enemiesPerRound = {
                [1] = 16,
                [2] = 20,
                [3] = 24,
                [4] = 28,
                [5] = 32,
                [6] = 36,
                [7] = 40,
                [8] = 44,
                [9] = 48,
                [10] = 52,
                [11] = 56,
                [12] = 60,
                [13] = 65,
                [14] = 70,
                [15] = 75,
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
                    "s_m_m_highsec_01",
                    "s_m_m_highsec_02",
                    "s_m_y_swat_01",
                    "mp_m_securoguard_01",
                },
                weapons = {
                    `WEAPON_COMBATPISTOL`,
                    `WEAPON_MICROSMG`,
                    `WEAPON_SMG`,
                    `WEAPON_ASSAULTRIFLE`,
                    `WEAPON_CARBINERIFLE`,
                },
                health = { min = 200, max = 380 },
                armor = { min = 50, max = 120 },
                accuracy = 55,
                combatAbility = 2,
                combatRange = 2,
                canRagdoll = false,
                canHeadshot = false,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 4,
                    name = "ROOT ACCESS",
                    subtitle = "Cybersecurity Elite",
                    model = "s_m_y_swat_01",
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
                    name = "KERNEL PANIC",
                    subtitle = "System Destroyer",
                    model = "s_m_y_blackops_01",
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
                    name = "MAINFRAME",
                    subtitle = "The Core Sentinel",
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
            -- Hard: Better chances for rare/epic items, slightly lower prices
            endGameLoot = {
                rerollCost = 200,
                itemCount = 6,
                duration = 60,
                lootTable = {
                    -- COMMON ITEMS (lower chances on hard - less filler)
                    { name = "bands", label = "Band of Notes", rarity = "common", price = 750, chance = 90, quantity = 3 },
                    { name = "rolls", label = "Roll of Notes", rarity = "common", price = 650, chance = 85, quantity = 3 },
                    { name = "md_silverring", label = "Silver Ring", rarity = "common", price = 850, chance = 80 },
                    { name = "md_silverearings", label = "Silver Earrings", rarity = "common", price = 950, chance = 75 },
                    { name = "md_silverdime", label = "Silver Dime", rarity = "common", price = 550, chance = 85 },
                    { name = "md_blackwatch", label = "Watch", rarity = "common", price = 1050, chance = 70 },
                    { name = "md_ancientcoin", label = "Ancient Coin", rarity = "common", price = 1150, chance = 65 },
                    { name = "lockpick", label = "Lockpick", rarity = "common", price = 450, chance = 75, quantity = 3 },
                    { name = "advancedlockpick", label = "Advanced Lockpick", rarity = "common", price = 750, chance = 60 },
                    { name = "thermite", label = "Thermite", rarity = "common", price = 1400, chance = 55 },
                    -- UNCOMMON ITEMS (slightly higher chances on hard)
                    { name = "md_silverounce", label = "1oz Silver Bar", rarity = "uncommon", price = 1700, chance = 60 },
                    { name = "md_goldring", label = "Gold Ring", rarity = "uncommon", price = 2100, chance = 55 },
                    { name = "md_golddollar", label = "Gold Dollar", rarity = "uncommon", price = 1900, chance = 57 },
                    { name = "md_goldearings", label = "Gold Earrings", rarity = "uncommon", price = 2400, chance = 50 },
                    { name = "goldchain", label = "Gold Chain", rarity = "uncommon", price = 2700, chance = 47 },
                    { name = "rolex", label = "Golden Watch", rarity = "uncommon", price = 3400, chance = 43 },
                    { name = "fleeca_case", label = "Fleeca Bank Case", rarity = "uncommon", price = 2900, chance = 45 },
                    { name = "house_case", label = "House Robbery Case", rarity = "uncommon", price = 2700, chance = 47 },
                    { name = "cryptostick", label = "Crypto Stick", rarity = "uncommon", price = 2400, chance = 50 },
                    { name = "drill", label = "Drill", rarity = "uncommon", price = 1900, chance = 53 },
                    -- RARE ITEMS (higher chances on hard)
                    { name = "md_goldnecklace", label = "Gold Necklace", rarity = "rare", price = 3800, chance = 35 },
                    { name = "md_goldnugget", label = "Gold Nugget", rarity = "rare", price = 4300, chance = 32 },
                    { name = "md_diamondearings", label = "Diamond Earrings", rarity = "rare", price = 4800, chance = 28 },
                    { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 5800, chance = 24 },
                    { name = "diamond_ring", label = "Diamond Ring", rarity = "rare", price = 6800, chance = 20 },
                    { name = "jewelry_case", label = "Jewelry Store Case", rarity = "rare", price = 5300, chance = 26 },
                    { name = "chopshop_case", label = "Chop Shop Case", rarity = "rare", price = 4300, chance = 28 },
                    { name = "coke_small_brick", label = "Coke Package", rarity = "rare", price = 4800, chance = 26 },
                    { name = "md_goldounce", label = "1oz Gold Bar", rarity = "rare", price = 7800, chance = 16 },
                    { name = "md_platinumnugget", label = "Platinum Nugget", rarity = "rare", price = 8800, chance = 14 },
                    -- EPIC ITEMS (higher chances on hard)
                    { name = "md_diamondnecklace", label = "Diamond Necklace", rarity = "epic", price = 11500, chance = 12 },
                    { name = "md_diamondring", label = "Diamond Ring", rarity = "epic", price = 9500, chance = 12 },
                    { name = "md_presidentialwatch", label = "Presidential Watch", rarity = "epic", price = 14500, chance = 8 },
                    { name = "md_relicrevolver", label = "Relic Revolver", rarity = "epic", price = 11500, chance = 9 },
                    { name = "pacific_case", label = "Pacific Bank Case", rarity = "epic", price = 17500, chance = 6 },
                    { name = "casino_case", label = "Casino Heist Case", rarity = "epic", price = 24500, chance = 4 },
                    { name = "coke_brick", label = "Coke Brick", rarity = "epic", price = 14500, chance = 8 },
                    { name = "weed_brick", label = "Weed Brick", rarity = "epic", price = 11500, chance = 9 },
                    { name = "secured_safe", label = "Secured Safe", rarity = "epic", price = 13500, chance = 8 },
                    { name = "expensive_champagne", label = "Expensive Champagne", rarity = "epic", price = 7500, chance = 10, quantity = 3 },
                },
            },
        },
        nightmare = {
            label = "Nightmare",
            description = "Black ops response team. Government-trained operatives with lethal precision.",
            icon = "fa-skull",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 15,
                completedMaps = {
                    { map = "server_farm", difficulty = "hard" },
                },
                -- item = "nightmare_access_key",
            },
            maxRounds = 20,
            killPoints = { min = 100, max = 300 },
            enemiesPerRound = {
                [1] = 22,
                [2] = 26,
                [3] = 30,
                [4] = 34,
                [5] = 38,
                [6] = 42,
                [7] = 46,
                [8] = 50,
                [9] = 55,
                [10] = 60,
                [11] = 65,
                [12] = 70,
                [13] = 75,
                [14] = 80,
                [15] = 85,
                [16] = 90,
                [17] = 95,
                [18] = 100,
                [19] = 110,
                [20] = 120,
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
                    "s_m_y_blackops_01",
                    "s_m_y_blackops_02",
                    "s_m_y_blackops_03",
                    "s_m_m_ciasec_01",
                    "s_m_m_fibsec_01",
                },
                weapons = {
                    `WEAPON_SMG`,
                    `WEAPON_ASSAULTRIFLE`,
                    `WEAPON_CARBINERIFLE`,
                    `WEAPON_SPECIALCARBINE`,
                    `WEAPON_MG`,
                },
                health = { min = 300, max = 500 },
                armor = { min = 100, max = 200 },
                accuracy = 70,
                combatAbility = 2,
                combatRange = 2,
                canRagdoll = false,
                canHeadshot = false,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 5,
                    name = "ZERO DAY",
                    subtitle = "Black Hat Operative",
                    model = "s_m_y_blackops_02",
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
                    name = "BACKDOOR",
                    subtitle = "NSA Ghost Protocol",
                    model = "s_m_m_ciasec_01",
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
                    name = "SKYNET",
                    subtitle = "Autonomous Defense System",
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
            -- Nightmare: Best chances for rare/epic items, lowest prices
            endGameLoot = {
                rerollCost = 200,
                itemCount = 6,
                duration = 60,
                lootTable = {
                    -- COMMON ITEMS (much lower chances on nightmare - rare filler)
                    { name = "bands", label = "Band of Notes", rarity = "common", price = 700, chance = 75, quantity = 3 },
                    { name = "rolls", label = "Roll of Notes", rarity = "common", price = 600, chance = 70, quantity = 3 },
                    { name = "md_silverring", label = "Silver Ring", rarity = "common", price = 800, chance = 65 },
                    { name = "md_silverearings", label = "Silver Earrings", rarity = "common", price = 900, chance = 60 },
                    { name = "md_silverdime", label = "Silver Dime", rarity = "common", price = 500, chance = 70 },
                    { name = "md_blackwatch", label = "Watch", rarity = "common", price = 1000, chance = 55 },
                    { name = "md_ancientcoin", label = "Ancient Coin", rarity = "common", price = 1100, chance = 50 },
                    { name = "lockpick", label = "Lockpick", rarity = "common", price = 400, chance = 60, quantity = 3 },
                    { name = "advancedlockpick", label = "Advanced Lockpick", rarity = "common", price = 700, chance = 45 },
                    { name = "thermite", label = "Thermite", rarity = "common", price = 1300, chance = 40 },
                    -- UNCOMMON ITEMS (higher chances on nightmare)
                    { name = "md_silverounce", label = "1oz Silver Bar", rarity = "uncommon", price = 1600, chance = 65 },
                    { name = "md_goldring", label = "Gold Ring", rarity = "uncommon", price = 2000, chance = 60 },
                    { name = "md_golddollar", label = "Gold Dollar", rarity = "uncommon", price = 1800, chance = 62 },
                    { name = "md_goldearings", label = "Gold Earrings", rarity = "uncommon", price = 2300, chance = 55 },
                    { name = "goldchain", label = "Gold Chain", rarity = "uncommon", price = 2600, chance = 52 },
                    { name = "rolex", label = "Golden Watch", rarity = "uncommon", price = 3300, chance = 48 },
                    { name = "fleeca_case", label = "Fleeca Bank Case", rarity = "uncommon", price = 2800, chance = 50 },
                    { name = "house_case", label = "House Robbery Case", rarity = "uncommon", price = 2600, chance = 52 },
                    { name = "cryptostick", label = "Crypto Stick", rarity = "uncommon", price = 2300, chance = 55 },
                    { name = "drill", label = "Drill", rarity = "uncommon", price = 1800, chance = 58 },
                    -- RARE ITEMS (much higher chances on nightmare)
                    { name = "md_goldnecklace", label = "Gold Necklace", rarity = "rare", price = 3600, chance = 42 },
                    { name = "md_goldnugget", label = "Gold Nugget", rarity = "rare", price = 4100, chance = 40 },
                    { name = "md_diamondearings", label = "Diamond Earrings", rarity = "rare", price = 4600, chance = 35 },
                    { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 5600, chance = 30 },
                    { name = "diamond_ring", label = "Diamond Ring", rarity = "rare", price = 6600, chance = 25 },
                    { name = "jewelry_case", label = "Jewelry Store Case", rarity = "rare", price = 5100, chance = 32 },
                    { name = "chopshop_case", label = "Chop Shop Case", rarity = "rare", price = 4100, chance = 35 },
                    { name = "coke_small_brick", label = "Coke Package", rarity = "rare", price = 4600, chance = 32 },
                    { name = "md_goldounce", label = "1oz Gold Bar", rarity = "rare", price = 7600, chance = 22 },
                    { name = "md_platinumnugget", label = "Platinum Nugget", rarity = "rare", price = 8600, chance = 18 },
                    -- EPIC ITEMS (much higher chances on nightmare)
                    { name = "md_diamondnecklace", label = "Diamond Necklace", rarity = "epic", price = 11000, chance = 16 },
                    { name = "md_diamondring", label = "Diamond Ring", rarity = "epic", price = 9000, chance = 16 },
                    { name = "md_presidentialwatch", label = "Presidential Watch", rarity = "epic", price = 14000, chance = 12 },
                    { name = "md_relicrevolver", label = "Relic Revolver", rarity = "epic", price = 11000, chance = 13 },
                    { name = "pacific_case", label = "Pacific Bank Case", rarity = "epic", price = 17000, chance = 10 },
                    { name = "casino_case", label = "Casino Heist Case", rarity = "epic", price = 24000, chance = 7 },
                    { name = "coke_brick", label = "Coke Brick", rarity = "epic", price = 14000, chance = 12 },
                    { name = "weed_brick", label = "Weed Brick", rarity = "epic", price = 11000, chance = 13 },
                    { name = "secured_safe", label = "Secured Safe", rarity = "epic", price = 13000, chance = 12 },
                    { name = "expensive_champagne", label = "Expensive Champagne", rarity = "epic", price = 7000, chance = 14, quantity = 3 },
                },
            },
        },
    },
}
