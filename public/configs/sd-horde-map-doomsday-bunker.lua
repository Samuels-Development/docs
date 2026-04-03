-- ============================================
-- DOOMSDAY BUNKER MAP
-- ============================================
-- Uses the Doomsday Heist Facility interior
-- Interior ID: 269313
-- Reference: https://github.com/Bob74/bob74_ipl/blob/master/dlc_doomsday/facility.lua

return {
    id = "doomsday_bunker",
    label = "Doomsday Bunker",
    description = "A covert government black site buried deep underground. This sprawling complex houses classified operations, weapons research, and intelligence archives.",
    icon = "fa-building-shield",

    -- IPLs required for this map (Doomsday Heist Facility)
    -- The main facility interior IPL
    ipls = {
        -- Main facility interior
        "xm_x17dlc_int_placement_interior_33_x17dlc_int_02_milo_",
        -- Exterior hatches and terrain (for complete facility)
    },

    -- Interior prop configuration
    interior = {
        coords = vector3(345.0, 4842.0, -60.0),  -- Coords to get interior ID
        propSets = {
            -- Walls/Shell (required)
            -- "set_int_02_shell",
            -- Decal style (1-9 available, using style 2)
            "set_int_02_decal_01",
            -- Lounge furniture
            "set_int_02_lounge1",
            -- Security room
            "set_int_02_security",
            -- Sleeping quarters
            "set_int_02_sleep",
            -- Orbital cannon
            "set_int_02_cannon",
            -- Clutter/details
            "set_int_02_clutter1",
        },
        propColor = 2,  -- Color scheme: 1=utility, 2=expertise, 3=altitude, etc.
    },

    -- Doors to freeze (prevent opening)
    doors = {
        { coords = vector4(336.51, 4832.96, -60.00, 125.00), model = 1877137660, radius = 1.0 },
        { coords = vector4(335.10, 4834.98, -60.00, 305.00), model = 1877137660, radius = 1.0 },  -- Double sliding door
    },

    -- Map intro text configuration
    intro = {
        enabled = true,
        title = "BREACH THE\nDOOMSDAY BUNKER",
        subtitle = nil,
        description = "A CLASSIFIED BLACK SITE HOUSING GOVERNMENT SECRETS. SURVIVE THE WAVES, COLLECT VALUABLE LOOT, AND FIGHT YOUR WAY OUT.",
        tagline = "SOME SECRETS ARE BURIED FOR A REASON.",
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

    -- Entry location (near facility hatch in the world)
    entryLocation = {
        coords = vector4(-263.65, 4729.01, 138.67, 129.29),
        blip = {
            sprite = 590,
            color = 1,
            scale = 0.8,
            label = "Facility Entry",
        },
        radius = 2.0,
    },

    -- Leave location (where players are teleported when game ends)
    leaveLocation = vec4(-262.79, 4729.86, 138.35, 318.08),

    -- End loot crate location (where players collect rewards after game ends)
    endLootLocation = {
        coords = vector4(-259.40, 4729.72, 135.78, 230.79),
        model = 'v_ind_cfcrate3',
    },

    -- Spawn point inside the facility
    spawnPoint = vector4(336.50, 4834.40, -59.00, 305.23),

    -- Zone boundary points (for lib.zones poly zone)
    -- Players will be warned/teleported back if they leave this area
    zonePoints = {
        vec3(325.24, 4883.49, -63.60),
        vec3(338.60, 4868.65, -63.55),
        vec3(344.17, 4876.63, -61.00),
        vec3(349.08, 4878.40, -61.56),
        vec3(354.94, 4876.28, -61.59),
        vec3(357.58, 4869.94, -61.40),
        vec3(353.26, 4863.48, -60.40),
        vec3(352.20, 4859.13, -63.56),
        vec3(368.67, 4852.35, -63.54),
        vec3(385.85, 4849.12, -63.60),
        vec3(416.28, 4848.87, -63.60),
        vec3(474.06, 4850.33, -54.99),
        vec3(491.72, 4848.63, -54.98),
        vec3(502.03, 4840.99, -54.99),
        vec3(507.21, 4832.55, -54.99),
        vec3(517.48, 4794.73, -54.99),
        vec3(517.96, 4781.63, -54.99),
        vec3(512.82, 4769.87, -54.99),
        vec3(503.03, 4761.38, -54.99),
        vec3(490.09, 4757.95, -54.99),
        vec3(477.40, 4760.42, -54.99),
        vec3(465.07, 4770.51, -54.99),
        vec3(460.84, 4779.53, -54.94),
        vec3(423.68, 4808.39, -60.00),
        vec3(413.12, 4808.36, -60.00),
        vec3(377.01, 4825.94, -60.00),
        vec3(374.73, 4819.11, -59.99),
        vec3(362.88, 4819.55, -59.17),
        vec3(342.50, 4828.78, -60.00),
        vec3(339.25, 4830.25, -60.00),
        vec3(335.04, 4823.19, -60.4),
        vec3(335.88, 4823.27, -63.47),
        vec3(331.8, 4819.99, -59.4),
        vec3(326.7, 4819.63, -59.04),
        vec3(319.89, 4824.81, -59.51),
        vec3(319.39, 4831.46, -59.33),
        vec3(322.95, 4836.63, -59.22),
        vec3(333.23, 4838.23, -60.00),
        vec3(330.26, 4839.14, -60.00),
        vec3(328.67, 4840.22, -60.00),
        vec3(327.85, 4841.82, -60.00),
        vec3(328.44, 4844.28, -60.00),
        vec3(329.99, 4845.32, -60.00),
        vec3(332.13, 4845.40, -60.00),
        vec3(313.74, 4875.31, -63.60),
    },
    zoneThickness = 20.0, -- Height of the zone (above/below center point)

    -- Terminal configuration (shop access point)
    terminal = { 
        coords = vector3(344.58, 4845.64, -59.54),
        object = {
            model = 'prop_laptop_01a',
            heading = 300.98,
        },
    },

    -- Deposit crate configuration
    depositCrate = {
        model = 'tr_prop_tr_mil_crate_02',
        coords = vector3(346.44, 4842.69, -60.00), 
        heading = 305.20,
    },

    -- Mystery Box configuration (COD-style random weapon box)
    -- Weapon display models are configured in configs/config.lua under WeaponDisplayModels
    -- Add new weapon-to-model mappings there to display them correctly in the mystery box
    mysteryBox = {
        enabled = true,
        coords = vector3(349.24, 4842.04, -60.0),
        heading = 63.58,
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

    -- Loot object spawn locations (throughout facility)
    lootSpawns = {
        vector4(352.38, 4874.87, -61.79, 327.88),
        vector4(335.53, 4850.66, -60.00, 61.96),
        vector4(350.89, 4841.37, -60.00, 62.05),
        vector4(353.01, 4852.72, -63.60, 328.04),
        vector4(335.70, 4866.86, -63.60, 36.09),
        vector4(376.55, 4837.94, -63.60, 248.30),
        vector4(405.67, 4845.34, -63.60, 305.85),
        vector4(367.55, 4821.94, -59.99, 127.62),
        vector4(406.40, 4830.74, -60.00, 111.90),
        vector4(418.46, 4812.79, -59.20, 280.08),
        vector4(423.60, 4826.31, -60.00, 243.08),
        vector4(469.80, 4831.34, -59.99, 310.51),
        vector4(451.70, 4822.68, -60.00, 279.12),
        vector4(483.60, 4809.38, -59.38, 220.41),
        vector4(486.27, 4780.51, -59.39, 189.64),
        vector4(482.68, 4767.93, -59.99, 161.12),
        vector4(508.14, 4775.22, -54.99, 182.25),
        vector4(415.10, 4844.18, -60.00, 273.77),
    },

    -- Enemy spawn settings
    -- spawnMode: "furthest" = spawn furthest from players (default)
    --            "minDistance" = random spawns, but filtered by minSpawnDistance (i.e. no peds will spawn within minSpawnDistance of the player)
    --            "random" = completely random, ignores player positions entirely
    -- minSpawnDistance: minimum distance from players (only used by "furthest" and "minDistance" modes, default: 15.0)
    enemySpawnSettings = {
        spawnMode = "minDistance",
        minSpawnDistance = 20.0,
    },

    -- Enemy spawn locations (throughout facility)
    enemySpawns = {
        vector4(362.13, 4832.06, -60.00, 251.87),
        vector4(372.42, 4829.66, -60.00, 259.35),
        vector4(372.42, 4829.66, -60.00, 259.35),
        vector4(400.88, 4822.19, -60.00, 259.49),
        vector4(413.22, 4828.95, -60.00, 313.28),
        vector4(429.30, 4825.29, -60.00, 322.34),
        vector4(440.84, 4821.04, -60.00, 278.19),
        vector4(460.66, 4825.86, -60.00, 358.53),
        vector4(469.16, 4827.89, -59.99, 337.79),
        vector4(476.77, 4824.31, -59.38, 312.59),
        vector4(491.37, 4812.95, -59.39, 209.97),
        vector4(491.19, 4790.10, -59.39, 175.31),
        vector4(478.27, 4776.16, -59.99, 190.75),
        vector4(464.55, 4802.06, -54.99, 50.10),
        vector4(475.03, 4842.99, -54.99, 307.36),
        vector4(504.30, 4809.51, -54.99, 198.12),
        vector4(407.28, 4843.68, -63.60, 301.21),
        vector4(386.01, 4844.26, -60.00, 90.09),
        vector4(375.17, 4838.00, -63.60, 116.56),
        vector4(360.97, 4842.98, -60.00, 117.08),
        vector4(351.28, 4854.25, -60.00, 64.98),
        vector4(352.40, 4848.34, -63.60, 146.07),
        vector4(366.56, 4851.95, -63.60, 297.10),
        vector4(339.88, 4856.13, -60.00, 130.45),
        vector4(328.50, 4871.88, -60.00, 45.91),
        vector4(334.63, 4859.50, -63.60, 206.97),
        vector4(324.72, 4868.25, -63.60, 122.25),
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
            description = "Skeleton crew. Basic security guards on routine patrol.",
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
            bossFights = {
                {
                    round = 3,
                    name = "FACILITY WARDEN",
                    subtitle = "HEAD OF SECURITY",
                    model = "s_m_m_highsec_01",
                    health = 800,
                    armor = 100,
                    weapon = `WEAPON_COMBATPISTOL`,
                    accuracy = 45,
                    combatAbility = 1,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 500,
                },
                {
                    round = 5,
                    name = "AGENT MASON",
                    subtitle = "CLASSIFIED OPERATIVE",
                    model = "s_m_m_ciasec_01",  -- CIA security for government facility
                    health = 1200,
                    armor = 150,
                    weapon = `WEAPON_SMG`,
                    accuracy = 55,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 750,
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
                    { name = "md_goldnecklace", label = "Gold Necklace", rarity = "rare", price = 4200, chance = 22 },
                    { name = "md_goldnugget", label = "Gold Nugget", rarity = "rare", price = 4725, chance = 20 },
                    { name = "md_diamondearings", label = "Diamond Earrings", rarity = "rare", price = 5250, chance = 17 },
                    { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 6300, chance = 14 },
                    { name = "diamond_ring", label = "Diamond Ring", rarity = "rare", price = 7350, chance = 12 },
                    { name = "jewelry_case", label = "Jewelry Store Case", rarity = "rare", price = 5775, chance = 16 },
                    { name = "chopshop_case", label = "Chop Shop Case", rarity = "rare", price = 4725, chance = 17 },
                    { name = "coke_small_brick", label = "Coke Package", rarity = "rare", price = 5250, chance = 16 },
                    { name = "md_goldounce", label = "1oz Gold Bar", rarity = "rare", price = 8400, chance = 9 },
                    { name = "md_platinumnugget", label = "Platinum Nugget", rarity = "rare", price = 9450, chance = 8 },

                    -- ============================================
                    -- EPIC ITEMS (chance 2-8) - Jackpot loot & legendary items
                    -- ============================================
                    { name = "md_diamondnecklace", label = "Diamond Necklace", rarity = "epic", price = 12600, chance = 6 },
                    { name = "md_diamondring", label = "Diamond Ring", rarity = "epic", price = 10500, chance = 6 },
                    { name = "md_presidentialwatch", label = "Presidential Watch", rarity = "epic", price = 15750, chance = 4 },
                    { name = "md_relicrevolver", label = "Relic Revolver", rarity = "epic", price = 12600, chance = 4 },
                    { name = "pacific_case", label = "Pacific Bank Case", rarity = "epic", price = 18900, chance = 3 },
                    { name = "casino_case", label = "Casino Heist Case", rarity = "epic", price = 26250, chance = 2 },
                    { name = "coke_brick", label = "Coke Brick", rarity = "epic", price = 15750, chance = 4 },
                    { name = "weed_brick", label = "Weed Brick", rarity = "epic", price = 12600, chance = 4 },
                    { name = "secured_safe", label = "Secured Safe", rarity = "epic", price = 14700, chance = 4 },
                    { name = "expensive_champagne", label = "Expensive Champagne", rarity = "epic", price = 8400, chance = 5, quantity = 3 },
                },
            },

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
                    "s_m_m_security_01",
                    "s_m_y_blackops_01",
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
        },
        normal = {
            label = "Normal",
            description = "Standard facility security. Armed operatives protecting classified assets.",
            icon = "fa-face-meh",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 8,
                completedMaps = {
                    { map = "doomsday_bunker", difficulty = "easy" },
                },
                -- item = "normal_access_key",
            },
            maxRounds = 10,
            killPoints = { min = 60, max = 175 },
            bossFights = {
                {
                    round = 3,
                    name = "FACILITY WARDEN",
                    subtitle = "HEAD OF SECURITY",
                    model = "s_m_m_highsec_01",
                    health = 1000,
                    armor = 150,
                    weapon = `WEAPON_SMG`,
                    accuracy = 50,
                    combatAbility = 1,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 600,
                },
                {
                    round = 6,
                    name = "DIRECTOR SHARP",
                    subtitle = "FACILITY ADMINISTRATOR",
                    model = "s_m_m_fibsec_01",  -- FIB security for government facility
                    health = 1500,
                    armor = 200,
                    weapon = `WEAPON_CARBINERIFLE`,
                    accuracy = 60,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 900,
                },
                {
                    round = 10,
                    name = "CODENAME: PHOENIX",
                    subtitle = "BLACK OPS COMMANDER",
                    model = "s_m_y_blackops_03",
                    health = 2200,
                    armor = 300,
                    weapon = `WEAPON_SPECIALCARBINE`,
                    accuracy = 70,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 1500,
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
                    "s_m_y_blackops_01",
                    "s_m_y_blackops_02",
                    "s_m_m_highsec_01",
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
        },
        hard = {
            label = "Hard",
            description = "Elite response team. Black ops operatives with advanced tactical training.",
            icon = "fa-face-angry",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 12,
                completedMaps = {
                    { map = "doomsday_bunker", difficulty = "normal" },
                },
                -- item = "hard_access_key",
            },
            maxRounds = 15,
            killPoints = { min = 90, max = 225 },
            bossFights = {
                {
                    round = 4,
                    name = "THE INTERROGATOR",
                    subtitle = "ENHANCED OPERATIVE",
                    model = "s_m_y_blackops_01",
                    health = 1800,
                    armor = 250,
                    weapon = `WEAPON_CARBINERIFLE`,
                    accuracy = 65,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 1000,
                },
                {
                    round = 9,
                    name = "GENERAL KRAUSS",
                    subtitle = "FACILITY OVERSEER",
                    model = "s_m_m_fibsec_01",  -- FIB security, distinct from earlier bosses
                    health = 2800,
                    armor = 400,
                    weapon = `WEAPON_ADVANCEDRIFLE`,
                    accuracy = 75,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 1500,
                },
                {
                    round = 15,
                    name = "PROJECT: TITAN",
                    subtitle = "EXPERIMENTAL SUPER-SOLDIER",
                    model = "u_m_y_juggernaut_01",
                    health = 4500,
                    armor = 600,
                    weapon = `WEAPON_MG`,
                    accuracy = 80,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 3000,
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
                    { name = "bands", label = "Band of Notes", rarity = "common", price = 760, chance = 100, quantity = 3 },
                    { name = "rolls", label = "Roll of Notes", rarity = "common", price = 665, chance = 95, quantity = 3 },
                    { name = "md_silverring", label = "Silver Ring", rarity = "common", price = 855, chance = 90 },
                    { name = "md_silverearings", label = "Silver Earrings", rarity = "common", price = 950, chance = 85 },
                    { name = "md_silverdime", label = "Silver Dime", rarity = "common", price = 570, chance = 95 },
                    { name = "md_blackwatch", label = "Watch", rarity = "common", price = 1045, chance = 80 },
                    { name = "md_ancientcoin", label = "Ancient Coin", rarity = "common", price = 1140, chance = 75 },
                    { name = "lockpick", label = "Lockpick", rarity = "common", price = 475, chance = 85, quantity = 3 },
                    { name = "advancedlockpick", label = "Advanced Lockpick", rarity = "common", price = 760, chance = 70 },
                    { name = "thermite", label = "Thermite", rarity = "common", price = 1425, chance = 65 },

                    -- ============================================
                    -- UNCOMMON ITEMS (chance 30-55) - Gold jewelry, cases & valuable loot
                    -- ============================================
                    { name = "md_silverounce", label = "1oz Silver Bar", rarity = "uncommon", price = 1710, chance = 55 },
                    { name = "md_goldring", label = "Gold Ring", rarity = "uncommon", price = 2090, chance = 50 },
                    { name = "md_golddollar", label = "Gold Dollar", rarity = "uncommon", price = 1900, chance = 52 },
                    { name = "md_goldearings", label = "Gold Earrings", rarity = "uncommon", price = 2375, chance = 45 },
                    { name = "goldchain", label = "Gold Chain", rarity = "uncommon", price = 2660, chance = 42 },
                    { name = "rolex", label = "Golden Watch", rarity = "uncommon", price = 3325, chance = 38 },
                    { name = "fleeca_case", label = "Fleeca Bank Case", rarity = "uncommon", price = 2850, chance = 40 },
                    { name = "house_case", label = "House Robbery Case", rarity = "uncommon", price = 2660, chance = 42 },
                    { name = "cryptostick", label = "Crypto Stick", rarity = "uncommon", price = 2375, chance = 45 },
                    { name = "drill", label = "Drill", rarity = "uncommon", price = 1900, chance = 48 },

                    -- ============================================
                    -- RARE ITEMS (chance 10-28) - Gold bars, diamonds & premium cases
                    -- ============================================
                    { name = "md_goldnecklace", label = "Gold Necklace", rarity = "rare", price = 3800, chance = 35 },
                    { name = "md_goldnugget", label = "Gold Nugget", rarity = "rare", price = 4275, chance = 31 },
                    { name = "md_diamondearings", label = "Diamond Earrings", rarity = "rare", price = 4750, chance = 28 },
                    { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 5700, chance = 23 },
                    { name = "diamond_ring", label = "Diamond Ring", rarity = "rare", price = 6650, chance = 19 },
                    { name = "jewelry_case", label = "Jewelry Store Case", rarity = "rare", price = 5225, chance = 25 },
                    { name = "chopshop_case", label = "Chop Shop Case", rarity = "rare", price = 4275, chance = 28 },
                    { name = "coke_small_brick", label = "Coke Package", rarity = "rare", price = 4750, chance = 25 },
                    { name = "md_goldounce", label = "1oz Gold Bar", rarity = "rare", price = 7600, chance = 15 },
                    { name = "md_platinumnugget", label = "Platinum Nugget", rarity = "rare", price = 8550, chance = 13 },

                    -- ============================================
                    -- EPIC ITEMS (chance 2-8) - Jackpot loot & legendary items
                    -- ============================================
                    { name = "md_diamondnecklace", label = "Diamond Necklace", rarity = "epic", price = 11400, chance = 11 },
                    { name = "md_diamondring", label = "Diamond Ring", rarity = "epic", price = 9500, chance = 11 },
                    { name = "md_presidentialwatch", label = "Presidential Watch", rarity = "epic", price = 14250, chance = 7 },
                    { name = "md_relicrevolver", label = "Relic Revolver", rarity = "epic", price = 11400, chance = 8 },
                    { name = "pacific_case", label = "Pacific Bank Case", rarity = "epic", price = 17100, chance = 6 },
                    { name = "casino_case", label = "Casino Heist Case", rarity = "epic", price = 23750, chance = 3 },
                    { name = "coke_brick", label = "Coke Brick", rarity = "epic", price = 14250, chance = 7 },
                    { name = "weed_brick", label = "Weed Brick", rarity = "epic", price = 11400, chance = 8 },
                    { name = "secured_safe", label = "Secured Safe", rarity = "epic", price = 13300, chance = 7 },
                    { name = "expensive_champagne", label = "Expensive Champagne", rarity = "epic", price = 7600, chance = 10, quantity = 3 },
                },
            },

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
                    "s_m_y_blackops_01",
                    "s_m_y_blackops_02",
                    "s_m_y_blackops_03",
                    "s_m_m_ciasec_01",
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
        },
        nightmare = {
            label = "Nightmare",
            description = "Lockdown protocol activated. The facility's deadliest assets are now hunting you.",
            icon = "fa-skull",
            -- Difficulty-level requirements (overrides map-level requirements if defined)
            -- See map-level requirements above for all available options (level, completedMaps, item, items, consume)
            requirements = {
                level = 20,
                completedMaps = {
                    { map = "doomsday_bunker", difficulty = "hard" },
                },
                -- item = "nightmare_access_key",
            },
            maxRounds = 20,
            killPoints = { min = 125, max = 350 },
            bossFights = {
                {
                    round = 5,
                    name = "AGENT ZERO",
                    subtitle = "GHOST PROTOCOL OPERATIVE",
                    model = "s_m_y_blackops_03",
                    health = 2500,
                    armor = 400,
                    weapon = `WEAPON_SPECIALCARBINE`,
                    accuracy = 75,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 1500,
                },
                {
                    round = 12,
                    name = "THE ARCHITECT",
                    subtitle = "DOOMSDAY PROTOCOL DESIGNER",
                    model = "ig_avon",  -- Avon Hertz for the mastermind character
                    health = 4000,
                    armor = 600,
                    weapon = `WEAPON_COMBATMG`,
                    accuracy = 85,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 2500,
                },
                {
                    round = 20,
                    name = "OMEGA PRIME",
                    subtitle = "THE FINAL CONTINGENCY",
                    model = "u_m_y_juggernaut_01",
                    health = 8000,
                    armor = 1000,
                    weapon = `WEAPON_MINIGUN`,
                    accuracy = 90,
                    combatAbility = 2,
                    combatRange = 2,
                    canRagdoll = false,
                    canHeadshot = false,
                    killReward = 5000,
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
                    { name = "md_goldnecklace", label = "Gold Necklace", rarity = "rare", price = 3600, chance = 42 },
                    { name = "md_goldnugget", label = "Gold Nugget", rarity = "rare", price = 4050, chance = 38 },
                    { name = "md_diamondearings", label = "Diamond Earrings", rarity = "rare", price = 4500, chance = 33 },
                    { name = "goldbar", label = "Gold Bar", rarity = "rare", price = 5400, chance = 27 },
                    { name = "diamond_ring", label = "Diamond Ring", rarity = "rare", price = 6300, chance = 23 },
                    { name = "jewelry_case", label = "Jewelry Store Case", rarity = "rare", price = 4950, chance = 30 },
                    { name = "chopshop_case", label = "Chop Shop Case", rarity = "rare", price = 4050, chance = 33 },
                    { name = "coke_small_brick", label = "Coke Package", rarity = "rare", price = 4500, chance = 30 },
                    { name = "md_goldounce", label = "1oz Gold Bar", rarity = "rare", price = 7200, chance = 18 },
                    { name = "md_platinumnugget", label = "Platinum Nugget", rarity = "rare", price = 8100, chance = 15 },

                    -- ============================================
                    -- EPIC ITEMS (chance 2-8) - Jackpot loot & legendary items
                    -- ============================================
                    { name = "md_diamondnecklace", label = "Diamond Necklace", rarity = "epic", price = 10800, chance = 14 },
                    { name = "md_diamondring", label = "Diamond Ring", rarity = "epic", price = 9000, chance = 14 },
                    { name = "md_presidentialwatch", label = "Presidential Watch", rarity = "epic", price = 13500, chance = 9 },
                    { name = "md_relicrevolver", label = "Relic Revolver", rarity = "epic", price = 10800, chance = 10 },
                    { name = "pacific_case", label = "Pacific Bank Case", rarity = "epic", price = 16200, chance = 7 },
                    { name = "casino_case", label = "Casino Heist Case", rarity = "epic", price = 22500, chance = 4 },
                    { name = "coke_brick", label = "Coke Brick", rarity = "epic", price = 13500, chance = 9 },
                    { name = "weed_brick", label = "Weed Brick", rarity = "epic", price = 10800, chance = 10 },
                    { name = "secured_safe", label = "Secured Safe", rarity = "epic", price = 12600, chance = 9 },
                    { name = "expensive_champagne", label = "Expensive Champagne", rarity = "epic", price = 7200, chance = 12, quantity = 3 },
                },
            },

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
                    "s_m_y_blackops_01",
                    "s_m_y_blackops_02",
                    "s_m_y_blackops_03",
                    "s_m_m_ciasec_01",
                    "s_m_m_fibsec_01",
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
        },
    },
}
