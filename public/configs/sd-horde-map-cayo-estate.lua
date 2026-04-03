-- ============================================
-- CAYO PERICO ESTATE MAP
-- ============================================

return {
    id = "cayo_estate",  -- Unique map identifier
    label = "Cayo Perico Estate",
    description = "El Rubio's private estate on Cayo Perico. Lush tropical grounds surround this heavily fortified compound. Expect cartel security and elite mercenaries.",
    icon = "fa-umbrella-beach",

    -- Map intro text configuration (shown when game starts)
    intro = {
        enabled = true,
        title = "RAID THE\nCAYO ESTATE",
        subtitle = nil,
        description = "EL RUBIO'S PRIVATE COMPOUND IS HEAVILY GUARDED BY CARTEL SOLDIERS AND MERCENARIES. SURVIVE THE WAVES, COLLECT VALUABLE LOOT, AND ESCAPE WITH YOUR LIFE.",
        tagline = "THE CARTEL DOESN'T TAKE PRISONERS.",
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
        --     { map = "doomsday_bunker", difficulty = "easy" },  -- Can require multiple maps!
        -- },
        -- item = "cayo_access_key",                              -- Single item (not consumed)
        -- item = { name = "cayo_access_key", consume = true },   -- Single item (consumed on start)
        -- items = {                                              -- Multiple items example:
        --     { name = "cayo_access_key", consume = true },      -- This item will be consumed
        --     { name = "lockpick", count = 2 },                  -- These items will NOT be consumed
        -- },
    },

    -- Entry location (where players go to enter the horde)
    entryLocation = {
        coords = vector4(4982.56, -5710.94, 20.35, 231.66),
        blip = {
            sprite = 310,
            color = 1,
            scale = 0.8,
            label = "Horde Entry - Cayo Estate",
        },
        radius = 2.0,
    },

    -- Leave location (where players are teleported when game ends)
    leaveLocation = vec4(4981.29, -5709.47, 19.89, 47.24),

    -- End loot crate location (where players collect rewards after game ends)
    endLootLocation = {
        coords = vector4(4983.16, -5706.32, 18.89, 180.02),
        model = 'v_ind_cfcrate3',
    },

    spawnPoint = vector4(4990.21, -5717.31, 19.88, 230.24),

    -- Zone boundary points (for lib.zones poly zone)
    -- Players will be warned/teleported back if they leave this area and removed if they stay outside for over 3 seconds.
    zonePoints = {
        vec3(4987.88, -5704.50, 18.89),
        vec3(4991.61, -5707.76, 18.89),
        vec3(5020.55, -5675.38, 18.90),
        vec3(5043.47, -5694.83, 16.43),
        vec3(5052.78, -5693.20, 15.49),
        vec3(5058.85, -5702.05, 14.90),
        vec3(5077.90, -5718.19, 14.77),
        vec3(5072.30, -5725.58, 14.77),
        vec3(5078.54, -5730.23, 14.77),
        vec3(5079.96, -5728.50, 14.77),
        vec3(5087.72, -5734.46, 14.77),
        vec3(5086.23, -5737.10, 14.77),
        vec3(5098.51, -5746.08, 12.71),
        vec3(5032.07, -5838.11, -9.88),
        vec3(4999.63, -5805.32, 19.92),
        vec3(4997.07, -5810.37, 19.70),
        vec3(4966.71, -5796.30, 19.93),
        vec3(4956.88, -5791.26, 19.85),
        vec3(4960.92, -5783.24, 19.84),
        vec3(4958.90, -5760.47, 19.69),
        vec3(4961.69, -5752.59, 19.17),
        vec3(4953.77, -5748.61, 19.04),
        vec3(4969.78, -5717.04, 18.77),
        vec3(4974.52, -5719.27, 18.89),
        vec3(4987.81, -5704.42, 18.89),
    },
    zoneThickness = 40.0, -- Height of the zone (above/below center point)

    -- Terminal configuration (shop access point)
    terminal = {
        coords = vector3(4996.31, -5724.72, 19.89),
        object = {
            model = 'prop_laptop_01a',
            heading = 282.04,
        },
    },

    -- Deposit crate configuration
    depositCrate = {
        model = 'tr_prop_tr_mil_crate_02',
        coords = vector3(4996.57, -5721.82, 18.91),
        heading = 239.59,
    },

    -- Mystery Box configuration (COD-style random weapon box)
    -- Weapon display models are configured in configs/config.lua under WeaponDisplayModels
    -- Add new weapon-to-model mappings there to display them correctly in the mystery box
    mysteryBox = {
        enabled = true,
        coords = vector3(4996.4, -5733.61, 18.88),
        heading = 228.4,
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

    -- Loot object spawn locations
    lootSpawns = {
        vector4(4981.54, -5768.98, 19.88, 293.97),
        vector4(4964.13, -5782.56, 19.91, 182.00),
        vector4(4984.79, -5800.98, 19.88, 239.66),
        vector4(5015.46, -5792.25, 16.68, 296.36),
        vector4(5005.52, -5805.96, 17.49, 219.75),
        vector4(5021.94, -5786.86, 15.36, 357.68),
        vector4(5049.28, -5786.92, 14.68, 317.09),
        vector4(5065.92, -5781.34, 10.48, 317.57),
        vector4(5062.80, -5776.21, 15.28, 316.50),
        vector4(5060.62, -5758.52, 14.72, 48.48),
        vector4(5074.26, -5743.51, 14.70, 45.12),
        vector4(5084.12, -5735.99, 20.04, 344.45),
        vector4(5050.54, -5748.22, 14.68, 148.88),
        vector4(5064.44, -5732.24, 14.68, 281.40),
        vector4(5054.32, -5713.41, 13.59, 52.78),
        vector4(5068.68, -5721.65, 13.46, 241.46),
        vector4(5033.18, -5690.43, 18.88, 58.25),
        vector4(5013.90, -5703.50, 18.87, 132.18),
        vector4(5028.00, -5720.79, 16.67, 205.65),
        vector4(5019.22, -5737.47, 16.68, 196.69),
        vector4(4999.21, -5735.77, 18.88, 49.24),
        vector4(4979.58, -5723.30, 18.93, 47.55),
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

    -- Enemy spawn locations
    enemySpawns = {
        vector4(5011.44, -5722.06, 18.48, 285.31),
        vector4(5013.52, -5704.01, 18.87, 49.45),
        vector4(5035.31, -5693.23, 18.88, 7.80),
        vector4(5015.44, -5690.37, 18.87, 59.99),
        vector4(5045.97, -5710.04, 13.60, 200.97),
        vector4(5070.84, -5716.75, 13.51, 240.74),
        vector4(5075.71, -5732.38, 14.88, 242.10),
        vector4(5078.88, -5744.93, 14.70, 253.93),
        vector4(5088.33, -5756.48, 14.68, 231.30),
        vector4(5070.18, -5775.97, 10.48, 123.80),
        vector4(5059.53, -5788.31, 10.48, 131.74),
        vector4(5044.24, -5783.38, 14.68, 79.06),
        vector4(5063.92, -5778.96, 15.28, 310.69),
        vector4(5051.36, -5772.52, 15.28, 140.40),
        vector4(5034.71, -5798.43, 16.48, 126.41),
        vector4(5017.16, -5809.62, 16.48, 122.42),
        vector4(5019.52, -5793.92, 16.68, 42.52),
        vector4(5028.97, -5785.71, 15.29, 308.84),
        vector4(5009.89, -5778.72, 16.68, 9.14),
        vector4(4993.93, -5804.42, 19.88, 126.59),
        vector4(4987.13, -5789.76, 19.88, 57.26),
        vector4(4973.16, -5794.21, 19.88, 73.22),
        vector4(4968.68, -5782.44, 19.88, 40.44),
        vector4(4975.85, -5761.37, 19.88, 340.50),
        vector4(4973.30, -5744.10, 18.88, 32.89),
        vector4(4989.00, -5753.93, 18.88, 203.76),
    },

    -- Rounds where players can choose to end the game early
    canEndGameOnRounds = {2, 5, 7, 10},

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
            description = "Light cartel presence. Basic guards patrolling the perimeter.",
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
                [5] = 25,
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
                    "g_m_y_mexgoon_01",
                    "g_m_y_mexgoon_02",
                    "g_m_y_mexgoon_03",
                },
                weapons = {
                    `WEAPON_PISTOL`,
                    `WEAPON_COMBATPISTOL`,
                    `WEAPON_MICROSMG`,
                },
                health = { min = 130, max = 200 },
                armor = { min = 10, max = 35 },
                accuracy = 28,
                combatAbility = 0,
                combatRange = 1,
                canRagdoll = true,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 4,                          -- Round when boss spawns
                    name = "CARTEL ENFORCER",           -- Boss name (displayed on health bar)
                    subtitle = "El Rubio's Muscle",     -- Optional subtitle
                    model = "g_m_m_mexboss_01",         -- Ped model
                    health = 1500,                      -- Boss health
                    armor = 100,                        -- Boss armor
                    weapon = `WEAPON_ASSAULTRIFLE`,     -- Boss weapon
                    accuracy = 45,                      -- Shooting accuracy
                    combatAbility = 2,                  -- 0=Poor, 1=Average, 2=Professional
                    combatRange = 2,                    -- 0=Near, 1=Medium, 2=Far
                    canRagdoll = false,                 -- Bosses typically can't be ragdolled
                    canHeadshot = false,         -- Headshots don't insta-kill
                    killReward = 500,                   -- Money reward for killing boss
                },
                {
                    round = 5,
                    name = "GUSTAVO",
                    subtitle = "Cartel Lieutenant",
                    model = "g_m_m_mexboss_02",
                    health = 2500,
                    armor = 150,
                    weapon = `WEAPON_COMBATMG`,
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
            description = "Full cartel security. Armed guards with tactical coordination.",
            icon = "fa-face-meh",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 8,
                completedMaps = {
                    { map = "cayo_estate", difficulty = "easy" },
                },
                -- item = "normal_access_key",
            },
            maxRounds = 10,
            killPoints = { min = 60, max = 160 },
            enemiesPerRound = {
                [1] = 12,
                [2] = 16,
                [3] = 20,
                [4] = 24,
                [5] = 28,
                [6] = 32,
                [7] = 36,
                [8] = 40,
                [9] = 45,
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
                    "g_m_y_mexgoon_01",
                    "g_m_y_mexgoon_02",
                    "g_m_y_mexgoon_03",
                    "g_m_m_mexboss_01",
                    "g_m_m_mexboss_02",
                },
                weapons = {
                    `WEAPON_COMBATPISTOL`,
                    `WEAPON_MICROSMG`,
                    `WEAPON_SMG`,
                    `WEAPON_ASSAULTRIFLE`,
                },
                health = { min = 170, max = 280 },
                armor = { min = 30, max = 85 },
                accuracy = 42,
                combatAbility = 1,
                combatRange = 2,
                canRagdoll = true,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 3,
                    name = "CARTEL ENFORCER",
                    subtitle = "El Rubio's Muscle",
                    model = "g_m_m_mexboss_01",
                    health = 2000,
                    armor = 150,
                    weapon = `WEAPON_ASSAULTRIFLE`,
                    accuracy = 50,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 750,
                },
                {
                    round = 6,
                    name = "GUSTAVO",
                    subtitle = "Cartel Lieutenant",
                    model = "g_m_m_mexboss_02",
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
                    name = "EL RUBIO",
                    subtitle = "The Drug Lord",
                    model = "csb_mweather",  -- Merryweather merc, fitting for island crime boss's personal guard
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
            description = "Elite mercenaries. El Rubio's personal guard with military training.",
            icon = "fa-face-angry",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 12,
                completedMaps = {
                    { map = "cayo_estate", difficulty = "normal" },
                },
                -- item = "hard_access_key",
            },
            maxRounds = 15,
            killPoints = { min = 85, max = 220 },
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
                    "g_m_m_mexboss_01",
                    "g_m_m_mexboss_02",
                    "s_m_y_blackops_01",
                    "s_m_y_blackops_02",
                    "u_m_y_juggernaut_01",
                },
                weapons = {
                    `WEAPON_SMG`,
                    `WEAPON_ASSAULTRIFLE`,
                    `WEAPON_CARBINERIFLE`,
                    `WEAPON_SPECIALCARBINE`,
                },
                health = { min = 220, max = 420 },
                armor = { min = 60, max = 135 },
                accuracy = 58,
                combatAbility = 2,
                combatRange = 2,
                canRagdoll = false,
                canHeadshot = false,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 4,
                    name = "SICARIO",
                    subtitle = "Cartel Assassin",
                    model = "g_m_m_chicold_01",  -- Cartel member in suit
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
                    name = "GENERAL CRUZ",
                    subtitle = "Mercenary Commander",
                    model = "s_m_m_armoured_02",  -- Armored military look
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
                    name = "EL DIABLO",
                    subtitle = "El Rubio's Right Hand",
                    model = "u_m_y_juggernaut_01",  -- Juggernaut for final boss
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
            description = "Full military response. Special forces deployed to eliminate all threats.",
            icon = "fa-skull",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 18,
                completedMaps = {
                    { map = "cayo_estate", difficulty = "hard" },
                },
                -- item = "nightmare_access_key",
            },
            maxRounds = 20,
            killPoints = { min = 120, max = 350 },
            enemiesPerRound = {
                [1] = 25,
                [2] = 30,
                [3] = 35,
                [4] = 40,
                [5] = 45,
                [6] = 50,
                [7] = 55,
                [8] = 60,
                [9] = 65,
                [10] = 70,
                [11] = 75,
                [12] = 80,
                [13] = 85,
                [14] = 90,
                [15] = 95,
                [16] = 100,
                [17] = 105,
                [18] = 110,
                [19] = 115,
                [20] = 125,
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
                    "s_m_y_marine_01",
                    "s_m_y_marine_02",
                    "s_m_y_marine_03",
                },
                weapons = {
                    `WEAPON_ASSAULTRIFLE`,
                    `WEAPON_CARBINERIFLE`,
                    `WEAPON_SPECIALCARBINE`,
                    `WEAPON_MG`,
                    `WEAPON_COMBATMG`,
                },
                health = { min = 320, max = 520 },
                armor = { min = 115, max = 220 },
                accuracy = 72,
                combatAbility = 2,
                combatRange = 2,
                canRagdoll = false,
                canHeadshot = false,
            },
            -- Boss fights for this difficulty
            bossFights = {
                {
                    round = 5,
                    name = "THE EXECUTIONER",
                    subtitle = "Cartel Hitman",
                    model = "g_m_m_chicold_01",  -- Cartel assassin in suit
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
                    name = "COMMANDER SANTOS",
                    subtitle = "Death Squad Leader",
                    model = "s_m_m_armoured_02",  -- Heavily armored military commander
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
                    name = "LA MUERTE",
                    subtitle = "The Reaper",
                    model = "u_m_y_juggernaut_01",  -- Ultimate juggernaut boss
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
