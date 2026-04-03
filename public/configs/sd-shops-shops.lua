return { -- Shop locations and configuration
    -- You can add an "illegal" parameter to any shop, and that shop will then exclusively use dirty money. See the bottom of this list for an example of an illegal shop.
    -- You can add "itemOverride = true" to any shop to use the shop's specific items instead of BaseProducts, even when BaseProducts is enabled.
    -- Per-shop UI toggles (all default to false): disableTransactionHistory, disableLoyalty, disablePresets, disableCoupons (see police armory at the bottom as an example)
    -- You can set a blip sprite to 0 to disable the blip entirely. Blips use the ped coords as their position.
    -- ROTATING PED LOCATIONS: Use ped.locations (array) instead of ped.coords/heading to randomize the ped's
    --   spawn point each server start. See the illegal_dealer_1 example at the bottom. Format:
    --   locations = { { coords = vector3(...), heading = 0.0 }, { coords = vector3(...), heading = 90.0 } }
    --
    -- OPENING HOURS: Set default opening hours for any shop (owned shops set their own time).
    --   openingHours = { enabled = true, open = '08:00', close = '22:00' }
    -- See 247store_1 shop below for an example
    --
    -- PAWN SHOP PAYOUT: Set payoutType = 'dirty' on a pawn shop to pay in black money instead of clean cash.
    --   Defaults to clean if omitted. See pawn_1 below for an example.
    --
    -- targetDistance: The distance from which players can interact with the shop ped (default: 3.0)
    -- targetLabel: Custom label for the ped interaction (optional, defaults to locale 'target.open_shop')
    -- targetIcon: Custom icon for the ped interaction (optional, defaults to 'fas fa-shopping-basket')
    --
    -- SHOP-LEVEL JOB RESTRICTIONS (jobRestrictions):
    -- Restrict who can ACCESS the shop. Player needs ONE of the jobs to enter (OR logic).
    -- Supports both string format (any grade) and table format (with minGrade).
    -- If minGrade is omitted, defaults to 0 (any grade in that job can access).
    -- Examples:
    --   Any grade:     jobRestrictions = { 'police', 'ambulance' }
    --   With grades:   jobRestrictions = { { name = 'police', minGrade = 2 }, { name = 'sheriff', minGrade = 1 } }
    --   Mixed:         jobRestrictions = { 'ambulance', { name = 'police', minGrade = 2 } }
    --
    -- SHOP-LEVEL GANG RESTRICTIONS (gangRestrictions):
    -- Restrict who can ACCESS the shop by gang. Player needs ONE of the gangs to enter (OR logic).
    -- Supports both string format (any grade) and table format (with minGrade).
    -- If minGrade is omitted, defaults to 0 (any grade in that gang can access).
    -- NOTE: If a shop has BOTH jobRestrictions AND gangRestrictions, the player must satisfy BOTH (AND logic).
    -- Examples:
    --   Any grade:     gangRestrictions = { 'ballas', 'vagos' }
    --   With grades:   gangRestrictions = { { name = 'ballas', minGrade = 2 }, { name = 'vagos', minGrade = 1 } }
    --   Mixed:         gangRestrictions = { 'vagos', { name = 'ballas', minGrade = 2 } }
    --
    -- FRAMEWORK JOB INTEGRATION (frameworkJob):
    -- When enabled, purchasing a shop assigns the player a framework job (QBCore/ESX).
    -- The player must have this job ACTIVE to access shop management (inventory, employees, finances, etc.).
    -- This is useful for tying shop ownership to the framework's job system.
    --
    -- Behavior:
    --   - Purchase: Player is assigned the job at the specified grade
    --   - Sell: Player's job is removed (set to unemployed)
    --   - Transfer: Old owner loses job, new owner receives it (if online)
    --   - Management access: Blocked if player switches to a different job
    --
    -- The job must already exist in your framework's job configuration (shared/jobs.lua or equivalent).
    --
    -- Example:
    --   frameworkJob = {
    --       enabled = true,       -- Enable/disable this feature
    --       job = 'gasstation',   -- The framework job name (must exist in your job system)
    --       grade = 5             -- Grade assigned on purchase (e.g., 5 = boss/owner)
    --   }
    --
    -- PER-SHOP PURCHASE RESTRICTIONS (purchaseRestrictions):
    -- Restrict who can purchase a specific shop by character identifier (whitelist).
    -- If specified, this OVERRIDES the global PurchaseRestrictions in management.lua for this shop only.
    -- Useful when you want different whitelist rules for different shops.
    --
    -- Example:
    --   purchaseRestrictions = {
    --       enabled = true,
    --       allowedIdentifiers = {    -- Only these players can purchase this shop
    --           'ABC12345',           -- QBCore: CitizenID / ESX: Character identifier
    --           'XYZ98765',
    --       },
    --       restrictedMessage = 'This shop is reserved for specific players.'  -- Optional custom message
    --   }
    --
    -- PER-SHOP PRODUCT WHITELIST OVERRIDE (productWhitelist):
    -- Override the global ProductWhitelist (from management.lua) for a specific shop.
    -- Useful when different shops of the same type need different orderable/stockable items.
    -- When set, ONLY items in this list will appear in stock management (not the global whitelist).
    --
    -- Example:
    --   productWhitelist = {
    --       { item = 'water', canOrder = true, orderPrice = 2 },
    --       { item = 'special_local_item', canOrder = true, orderPrice = 10 },
    --   }
    --
    -- ITEM-LEVEL JOB RESTRICTIONS (jobRestriction):
    -- Restrict individual items by job and grade. Items will be HIDDEN from players who don't meet the requirements.
    -- Player only needs to meet ONE of the job requirements (OR logic).
    -- If minGrade is omitted, defaults to 0 (any grade in that job can access/purchase).
    -- Examples:
    --   Any police:    { item = 'WEAPON_PISTOL', price = 500, jobRestriction = { { name = 'police' } } }
    --   Grade 1+:      { item = 'WEAPON_PISTOL', price = 500, jobRestriction = { { name = 'police', minGrade = 1 } } }
    --   Multiple jobs: { item = 'WEAPON_CARBINERIFLE', price = 2500, jobRestriction = { { name = 'police', minGrade = 3 }, { name = 'sheriff', minGrade = 2 }, { name = 'swat' } } }
    --
    -- PER-ITEM CURRENCY OVERRIDE (currencyItem):
    -- In a regular cash shop, you can make specific items cost an item instead of money.
    -- This creates a "mixed" shop where most products use cash/bank, but certain products require item exchange.
    -- The price field becomes the quantity of the currency item required.
    -- Example:
    --   { item = 'lockpick', price = 5, currencyItem = 'iron' }  -- Costs 5 iron instead of $5
    --   { item = 'radio', price = 120 }                           -- Still costs $120 cash
    -- See the hardware_1 shop below for a working example.
    --
    -- ITEM-LEVEL GANG RESTRICTIONS (gangRestriction):
    -- Restrict individual items by gang and grade. Items will be HIDDEN from players who don't meet the requirements.
    -- Player only needs to meet ONE of the gang requirements (OR logic).
    -- If minGrade is omitted, defaults to 0 (any grade in that gang can access/purchase).
    -- NOTE: If an item has BOTH jobRestriction AND gangRestriction, the player must satisfy BOTH (AND logic).
    -- Examples:
    --   Any ballas:     { item = 'WEAPON_PISTOL', price = 5000, gangRestriction = { { name = 'ballas' } } }
    --   Grade 1+:       { item = 'WEAPON_PISTOL', price = 5000, gangRestriction = { { name = 'ballas', minGrade = 1 } } }
    --   Multiple gangs: { item = 'WEAPON_CARBINERIFLE', price = 10000, gangRestriction = { { name = 'ballas', minGrade = 2 }, { name = 'vagos', minGrade = 1 } } }
    --
    -- ITEM DISPLAY OVERRIDES (label, description, image):
    -- Any item can override its display name, description, and image in the shop UI.
    -- These work in both individual shop items here and in BaseProducts (config.lua).
    --   label       → Custom display name (overrides the auto-fetched inventory label)
    --   description → Custom description text (overrides the auto-fetched inventory description)
    --   image       → Custom image. Either a filename (e.g., 'lockpick.png') resolved via your inventory's
    --                  image directory, or a full path (e.g., 'nui://my_resource/images/custom.png' or a URL).
    -- Examples:
    --   { item = 'water', price = 5, label = 'Spring Water', description = 'Freshly sourced spring water.' }
    --   { item = 'lockpick', price = 50, image = 'lockpick_gold.png' }           -- Uses inventory image directory
    --   { item = 'radio', price = 250, image = 'nui://my_resource/radio.png' }   -- Full NUI path
    --
    -- ITEM METADATA:
    -- Any item can include an optional 'metadata' table that gets passed to the inventory system on purchase.
    -- This works in both individual shop items here and in BaseProducts (config.lua).
    -- For weapons, configured metadata is merged with weapon serial metadata (weapon fields take priority).
    -- Example:
    --   { item = 'ls_watering_can', price = 15, metadata = { durability = 100 } }
    --   { item = 'WEAPON_PISTOL', price = 500, metadata = { customField = 'value' } }  -- Merged with serial metadata
    --
    -- DISPLAY METADATA (ox_inventory only):
    -- Items can include a 'displayMetadata' table to register custom metadata keys
    -- for display in ox_inventory's item tooltip.
    -- Do NOT add ox_inventory built-in keys (durability, description, ammo, serial, components,
    -- weapontint, type, label) — they are already displayed and will be filtered out automatically.
    --
    -- Display value format:
    --   String form:  key = 'Label'                                              → booleans show "Yes"/"No", numbers show as-is
    --   Table form:   key = { label = 'Label', trueValue = '...', falseValue = '...' } → booleans show custom text
    --
    -- Examples:
    --   displayMetadata = { sterile = 'Sterile' }                                                          → "Sterile: Yes"
    --   displayMetadata = { sterile = { label = 'Sterile', trueValue = 'Sanitized', falseValue = 'Dirty' } } → "Sterile: Sanitized"
    --   displayMetadata = { quality = 'Quality' }  (with metadata = { quality = 80 })                      → "Quality: 80"
    ['247store_1'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        openingHours = { enabled = true, open = '08:00', close = '22:00' }, -- Set default opening hours (owner can override for owned shops)
        blip = {
            sprite = 52, -- set to 0 to disable the blip
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vec3(24.5, -1345.78, 29.5),
            heading = 269.19,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(24.95, -1347.29, 29.61),
                vector3(24.95, -1344.95, 29.61)
            }
        },
        items = { -- This item table is used if: Config.BaseProducts.enabled is false, OR itemOverride = true for this shop
            -- Food & Drinks
            { item = 'water', price = 5 },
            { item = 'water', price = 10, label = 'Premium Spring Water', description = 'Imported artisan spring water.', metadata = { quality = 100, purified = true }, displayMetadata = { quality = 'Quality', purified = { label = 'Purified', trueValue = 'Yes', falseValue = 'No' } } },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            -- Medical
            { item = 'bandage', price = 15, --[[ label = 'First Aid Bandage', description = 'Medical-grade bandage.', metadata = { durability = 100, sterile = true }, displayMetadata = { sterile = { label = 'Sterile', trueValue = 'Sanitized', falseValue = 'Contaminated' } } ]] },
            { item = 'painkillers', price = 10 },
            -- Tools & Items
            { item = 'phone', price = 350, --[[ image = 'phone_gold.png' ]] }, -- Example: filename resolved via inventory image directory, you can also specify file path like this: image = 'nui://ox_inventory/web/images/phone_gold.png'
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(29.37, -1338.72, 29.33),
            price = 50000
        },
        --[[
        -- You don't have to define these values, there fully optional. If you don't define purchaseRestrictions or productWhitelist they'll default to their base values from the main management.lua file.
        -- EXAMPLE: Uncomment to enable these features for this shop
        frameworkJob = {
            enabled = true,
            job = 'shopowner',
            grade = 0
        },
        purchaseRestrictions = {
            enabled = true,
            allowedIdentifiers = { 'ABC12345', 'XYZ98765' },
            restrictedMessage = 'This shop is reserved for specific players.'
        },
        productWhitelist = {  -- Overrides global ProductWhitelist for this shop only
            { item = 'water', canOrder = true, orderPrice = 2 },
            { item = 'sandwich', canOrder = true, orderPrice = 3 },
            { item = 'special_local_item', canOrder = true, orderPrice = 10 },
        },
        ]]
    },

    ['247store_2'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(-3040.09, 584.1, 7.91),
            heading = 17.55,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-3041.36, 584.27, 8.02),
                vector3(-3039.13, 584.98, 8.02)
            }
        },
        items = {
            { item = 'water', price = 999 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(-3048.62, 586.65, 7.74),
            price = 50000
        }
    },

    ['247store_3'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(-3243.79, 1000.12, 12.83),
            heading = 353.16,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-3242.25, 1000.46, 12.95),
                vector3(-3244.57, 1000.66, 12.95)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(-3250.36, 1005.76, 12.67),
            price = 50000
        }
    },

    ['247store_4'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(1728.49, 6416.57, 35.04),
            heading = 244.71,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1729.33, 6417.12, 35.15),
                vector3(1728.29, 6415.03, 35.15)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(1736.11, 6420.65, 34.87),
            price = 45000
        }
    },

    ['247store_5'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(1697.14, 4923.35, 42.06),
            heading = 323.42,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1698.31, 4923.37, 42.18),
                vector3(1696.64, 4924.54, 42.18)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(1707.12, 4921.53, 41.88),
            price = 45000
        }
    },

    ['247store_6'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(1959.31, 3741.39, 32.34),
            heading = 298.67,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1960.49, 3740.27, 32.46),
                vector3(1959.32, 3742.29, 32.46)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(1960.16, 3749.94, 32.18),
            price = 40000
        }
    },

    ['247store_7'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(549.27, 2669.7, 42.16),
            heading = 99.59,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(548.60, 2671.26, 42.27),
                vector3(548.90, 2668.94, 42.27)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(545.18, 2662.20, 41.99),
            price = 45000
        }
    },

    ['247store_8'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(2676.59, 3280.18, 55.24),
            heading = 331.52,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(2678.25, 3279.83, 55.36),
                vector3(2676.21, 3280.97, 55.36)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(2673.03, 3287.98, 55.08),
            price = 45000
        }
    },

    ['247store_9'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(2555.7, 380.88, 108.62),
            heading = 358.01,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(2557.21, 381.29, 108.74),
                vector3(2554.88, 381.39, 108.74)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(2548.88, 386.18, 108.46),
            price = 55000
        }
    },

    ['247store_10'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(372.97, 327.88, 103.57),
            heading = 256.84,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(373.3, 325.2, 103.56),
                vector3(373.8, 325.8, 103.56)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(379.49, 333.46, 103.40),
            price = 60000
        }
    },

    ['liquorstore_1'] = {
        name = 'Liquor Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'liquorstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 93,
            color = 69,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_m_eastsa_02',
            coords = vector3(1134.19, -981.83, 46.42),
            heading = 277.28,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1134.81, -982.36, 46.52)
            }
        },
        items = {
            { item = 'water', price = 10 },
            { item = 'beer', price = 15 },
            { item = 'vodka', price = 45 },
            { item = 'whiskey', price = 60 },
            { item = 'wine', price = 35 },
        },
        ownership = {
            enabled = true,
            coords = vector3(1127.09, -979.76, 45.71),
            price = 70000
        }
    },

    ['liquorstore_2'] = {
        name = 'Liquor Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'liquorstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 93,
            color = 69,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_m_eastsa_02',
            coords = vector3(-1222.62, -908.67, 12.33),
            heading = 32.92,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-1222.33, -907.82, 12.43)
            }
        },
        items = {
            { item = 'water', price = 10 },
            { item = 'beer', price = 15 },
            { item = 'vodka', price = 45 },
            { item = 'whiskey', price = 60 },
            { item = 'wine', price = 35 },
        },
        ownership = {
            enabled = true,
            coords = vector3(-1221.28, -915.89, 11.46),
            price = 65000
        }
    },

    ['liquorstore_3'] = {
        name = 'Liquor Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'liquorstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 93,
            color = 69,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_m_eastsa_02',
            coords = vector3(-1485.74, -378.62, 40.16),
            heading = 133.91,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-1486.67, -378.46, 40.27)
            }
        },
        items = {
            { item = 'water', price = 10 },
            { item = 'beer', price = 15 },
            { item = 'vodka', price = 45 },
            { item = 'whiskey', price = 60 },
            { item = 'wine', price = 35 },
        },
        ownership = {
            enabled = true,
            coords = vector3(-1478.98, -375.91, 39.29),
            price = 65000
        }
    },

    ['liquorstore_4'] = {
        name = 'Liquor Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'liquorstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 93,
            color = 69,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_m_eastsa_02',
            coords = vector3(-2966.51, 390.05, 15.04),
            heading = 86.38,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-2967.03, 390.90, 15.15)
            }
        },
        items = {
            { item = 'water', price = 10 },
            { item = 'beer', price = 15 },
            { item = 'vodka', price = 45 },
            { item = 'whiskey', price = 60 },
            { item = 'wine', price = 35 },
        },
        ownership = {
            enabled = true,
            coords = vector3(-2960.03, 386.82, 14.20),
            price = 55000
        }
    },

    ['liquorstore_5'] = {
        name = 'Liquor Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'liquorstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 93,
            color = 69,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_m_eastsa_02',
            coords = vector3(1166.73, 2710.79, 38.16),
            heading = 180.66,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1165.96, 2710.20, 38.26)
            }
        },
        items = {
            { item = 'water', price = 10 },
            { item = 'beer', price = 15 },
            { item = 'vodka', price = 45 },
            { item = 'whiskey', price = 60 },
            { item = 'wine', price = 35 },
        },
        ownership = {
            enabled = true,
            coords = vector3(1169.59, 2717.43, 37.32),
            price = 50000
        }
    },

    ['hardware_1'] = {
        name = 'Hardware Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'hardware',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 402,
            color = 47,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_m_cntrybar_01',
            coords = vector3(2747.52, 3472.83, 55.67),
            heading = 247.24,
        },
        registers = {
            enabled = false,
            coords = {}
        },
        items = {
            { item = 'lockpick', price = 50 },
            { item = 'repairkit', price = 75 },
            { item = 'radio', price = 120 },
            { item = 'flashlight', price = 25 },
            { item = 'rope', price = 30 },
            -- Example: this item costs 5 metalscrap instead of cash (per-item currency override)
            { item = 'iron', price = 5, currencyItem = 'metalscrap' },
        },
        ownership = {
            enabled = false,
            coords = vector3(2748.5, 3471.5, 55.67),
            price = 80000
        }
    },

    ['hardware_2'] = {
        name = 'Hardware Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'hardware',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 402,
            color = 47,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_m_cntrybar_01',
            coords = vector3(46.72, -1749.67, 29.63),
            heading = 50.47,
        },
        registers = {
            enabled = false,
            coords = {
                vector3(45.0, -1749.5, 29.6)
            }
        },
        items = {
            { item = 'lockpick', price = 50 },
            { item = 'repairkit', price = 75 },
            { item = 'radio', price = 120 },
            { item = 'flashlight', price = 25 },
            { item = 'rope', price = 30 },
        },
        ownership = {
            enabled = false,
            coords = vector3(45.0, -1749.5, 29.6),
            price = 50000
        }
    },

    -- Gun Stores / Ammu-Nation
    ['gunstore_1'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(-661.72, -933.49, 21.83),
            heading = 174.39,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-660.93, -934.10, 21.95)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(-660.93, -934.10, 21.95),
            price = 0
        }
    },

    ['gunstore_2'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(809.74, -2159.03, 29.62),
            heading = 357.41,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(808.86, -2158.51, 29.74)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(808.86, -2158.51, 29.74),
            price = 0
        }
    },

    ['gunstore_3'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(1692.47, 3761.27, 34.71),
            heading = 225.21,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1693.57, 3761.60, 34.82)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(1693.57, 3761.60, 34.82),
            price = 0
        }
    },

    ['gunstore_4'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(-331.33, 6085.29, 31.45),
            heading = 222.96,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-330.29, 6085.55, 31.57)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(-330.29, 6085.55, 31.57),
            price = 0
        }
    },

    ['gunstore_5'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(253.62, -51.09, 69.94),
            heading = 66.9,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(252.86, -51.63, 70.06)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(252.86, -51.63, 70.06),
            price = 0
        }
    },

    ['gunstore_6'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(23.06, -1105.67, 29.8),
            heading = 153.96,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(23.69, -1106.46, 29.92)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(23.69, -1106.46, 29.92),
            price = 0
        }
    },

    ['gunstore_7'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(2567.52, 292.54, 108.73),
            heading = 355.88,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(2566.59, 293.13, 108.85)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(2566.59, 293.13, 108.85),
            price = 0
        }
    },

    ['gunstore_8'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(-1118.67, 2700.15, 18.55),
            heading = 218.73,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-1117.61, 2700.26, 18.67)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(-1117.61, 2700.26, 18.67),
            price = 0
        }
    },

    ['gunstore_9'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(841.94, -1035.33, 28.19),
            heading = 359.29,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(841.06, -1034.76, 28.31)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(841.06, -1034.76, 28.31),
            price = 0
        }
    },

    -- EXAMPLE PAWN SHOP (Hardcoded Shop Type)
    -- Pawn shops are a special type that BUY items FROM players and give them money.
    -- Unlike regular shops, prices here represent what the PLAYER RECEIVES for selling.
    --
    -- When BaseProducts.enabled = true: Uses items from Config.BaseProducts['pawn']
    -- When BaseProducts.enabled = false: Uses items defined below in this shop
    ['pawn_1'] = {
        name = 'Pawn Shop',
        subtitle = 'We buy your items',
        shopType = 'pawn',  -- REQUIRED: This makes it a pawn shop
        -- payoutType = 'dirty', -- Set to 'dirty' to pay out in black money instead of clean cash (default: 'clean') (optional, if not specified, defaults to regular cash)
        itemOverride = false, -- Set to true to use this shop's items instead of BaseProducts (if BaseProducts is enabled to begin with)
        targetDistance = 3.0, -- Distance from which players can interact with the shop ped
        blip = {
            sprite = 267,  -- Pawn shop blip
            color = 46,    -- Amber color
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_y_business_02',
            coords = vector3(412.22, 314.6, 103.02),
            heading = 204.5,
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        },
        registers = {
            enabled = false,
            coords = {
                vector3(412.57, 315.10, 103.27)
            }
        },
        -- Items this pawn shop will BUY (only used if BaseProducts.enabled = false)
        -- Price = what the player RECEIVES for selling the item
        items = {
            { item = 'phone', price = 100 },
            { item = 'radio', price = 75 },
            { item = 'goldbar', price = 500 },
        },
        ownership = {
            enabled = false,
            coords = vector3(0.0, 0.0, 0.0),
            price = 0
        }
    },

    -- EXAMPLE JOB-RESTRICTED SHOP (see police_armory)
    ['police_armory'] = {
        name = 'Police Armory',
        subtitle = 'LSPD Equipment',
        shopType = 'police_armory',
        itemOverride = true,
        targetDistance = 3.0,
        targetLabel = 'Access Armory',
        targetIcon = 'fas fa-shield-alt',
        jobRestrictions = { 'police', 'sheriff' }, -- Only police/sheriff can access this shop
        disableTransactionHistory = true,
        disableLoyalty = true,
        disableCoupons = true,
        blip = {
            sprite = 0,
            color = 0,
            scale = 0.0,
            display = 0
        },
        ped = {
            enabled = true,
            model = 's_m_y_cop_01',
            coords = vec3(454.05, -980.09, 30.69),
            heading = 90.2,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = false,
            coords = {}
        },
        items = {
            -- GRADE 0 (Cadet) - Basic Equipment (no restriction = available to all)
            { item = 'armour', price = 0 },
            { item = 'bandage', price = 25 },
            { item = 'painkillers', price = 20 },
            { item = 'radio', price = 100 },
            { item = 'weapon_flashlight', price = 50 },
            { item = 'handcuffs', price = 75 },
            { item = 'WEAPON_NIGHTSTICK', price = 100 },

            -- GRADE 1 (Officer) - Standard Issue
            { item = 'WEAPON_STUNGUN', price = 350, jobRestriction = { { name = 'police', minGrade = 1 }, { name = 'sheriff', minGrade = 1 } } },
            { item = 'WEAPON_PISTOL', price = 500, jobRestriction = { { name = 'police', minGrade = 1 }, { name = 'sheriff', minGrade = 1 } } },
            { item = 'firstaid', price = 75, jobRestriction = { { name = 'police', minGrade = 1 }, { name = 'sheriff', minGrade = 1 } } },
            { item = 'ammo-9', price = 15, jobRestriction = { { name = 'police', minGrade = 1 }, { name = 'sheriff', minGrade = 1 } } },

            -- GRADE 2 (Senior Officer) - Advanced Equipment
            { item = 'WEAPON_COMBATPISTOL', price = 750, jobRestriction = { { name = 'police', minGrade = 2 }, { name = 'sheriff', minGrade = 2 } } },
            { item = 'WEAPON_PUMPSHOTGUN', price = 1500, jobRestriction = { { name = 'police', minGrade = 2 }, { name = 'sheriff', minGrade = 2 } } },
            { item = 'binoculars', price = 150, jobRestriction = { { name = 'police', minGrade = 2 }, { name = 'sheriff', minGrade = 2 } } },
            { item = 'medicalbag', price = 200, jobRestriction = { { name = 'police', minGrade = 2 }, { name = 'sheriff', minGrade = 2 } } },
            { item = 'ammo-shotgun', price = 20, jobRestriction = { { name = 'police', minGrade = 2 }, { name = 'sheriff', minGrade = 2 } } },

            -- GRADE 3 (Sergeant+) - Tactical Equipment
            { item = 'heavyarmor', price = 1500, jobRestriction = { { name = 'police', minGrade = 3 }, { name = 'sheriff', minGrade = 3 }, { name = 'swat', minGrade = 0 } } },
            { item = 'WEAPON_CARBINERIFLE', price = 2500, jobRestriction = { { name = 'police', minGrade = 3 }, { name = 'sheriff', minGrade = 3 }, { name = 'swat', minGrade = 0 } } },
            { item = 'WEAPON_SMG', price = 1800, jobRestriction = { { name = 'police', minGrade = 3 }, { name = 'sheriff', minGrade = 3 }, { name = 'swat', minGrade = 0 } } },
            { item = 'ammo-rifle', price = 25, jobRestriction = { { name = 'police', minGrade = 3 }, { name = 'sheriff', minGrade = 3 }, { name = 'swat', minGrade = 0 } } },
        },
        ownership = {
            enabled = false,
            coords = vector3(0.0, 0.0, 0.0),
            price = 0
        }
    },

    -- EXAMPLE ILLEGAL SHOP
    -- When 'illegal = true', the shop will ONLY accept black_money as payment
    -- For ox_inventory: uses 'black_money' item (IT WILL TRY TO USE OX FIRST, SINCE MOST PEOPLE USE OX, IF NOT FALLS BACK TO FRAMEWORK SPECIFIC STUFF)
    -- For QBCore: uses 'markedbills' item with 'worth' metadata
    -- For ESX: uses 'black_money' account
    -- To comment out the below shop, remove the --[[ directly below and the closing ]] at the end of the illegal_dealer_1 table.
    ['illegal_dealer_1'] = {
        name = 'Black Market Dealer',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'blackmarket',
        illegal = true, -- THIS FLAG FORCES BLACK_MONEY ONLY
        gangRestrictions = { { name = 'ballas', minGrade = 2 }, 'vagos' }, -- Ballas grade 2+ and any Vagos can access
        blip = {
            sprite = 0,
            color = 0,
            scale = 0,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'g_m_m_chicold_01',
            -- Multiple locations: ped randomly spawns at one of these each server start
            locations = {
                { coords = vector3(839.48, 2176.82, 52.29), heading = 154.0 },
                { coords = vector3(118.34, -3025.31, 6.02), heading = 88.23 },
                { coords = vector3(-1256.44, -820.15, 17.1), heading = 126.58 },
            },
            scenario = 'WORLD_HUMAN_DRUG_DEALER'
        },
        registers = {
            enabled = false,
            coords = {}
        },
        items = {
            { item = 'lockpick', price = 500 },
            { item = 'weapon_pistol', price = 15000, gangRestriction = { { name = 'ballas', minGrade = 2 } } },
            -- Add your illegal items here
        },
        -- Ownable illegal shops are essentially the same as normal shopss ownership, only difference is that the society is handeled in dirty money and not in regular cash/bank.
        ownership = {
            enabled = false,
            coords = vector3(0.0, 0.0, 0.0),
            price = 0
        }
    },

    -- ITEM CURRENCY SHOP
    -- Players pay with a specific inventory item instead of cash/bank.
    -- Set currencyItem to the ox_inventory item name. Prices = quantity of that item.
    -- currencyLabel is optional — if omitted, the label is auto-fetched from ox_inventory.
    -- Item currency shops do not support ownership, loyalty, or coupons.
    ['gold_trader_1'] = {
        name = 'Gold Trader',
        subtitle = 'Trade gold for goods',
        shopType = 'item',
        currencyItem = 'goldbar',           -- item name used as currency
        -- currencyLabel = 'Gold Bar',      -- Optional: display label (auto-fetched from inventory if omitted)
        itemOverride = true,                -- Item shops should always use their own items
        targetDistance = 3.0,
        blip = {
            sprite = 605,
            color = 46,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_y_business_02',
            coords = vector3(-1459.31, -413.54, 35.75),
            heading = 159.23,
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT'
        },
        registers = {
            enabled = false,
            coords = {}
        },
        items = {
            -- Prices = how many of the currency item the player must pay
            -- Items use the shop-level currencyItem ('goldbar') by default
            { item = 'lockpick', price = 2 },
            { item = 'radio', price = 3 },
            { item = 'phone', price = 5 },
            { item = 'repairkit', price = 4 },
            { item = 'weapon_flashlight', price = 1 },
            { item = 'binoculars', price = 3 },
            -- Per-item currency override: these items cost a different currency
            -- { item = 'firework1', price = 6, currencyItem = 'silverbar' },
            -- { item = 'firework2', price = 6, currencyItem = 'silverbar' },
            { item = 'firework1', price = 6 },
            { item = 'firework2', price = 6 },
            { item = 'firework3', price = 8 },
            { item = 'firework4', price = 10 },
        },
        ownership = {
            enabled = false,
            coords = vector3(0.0, 0.0, 0.0),
            price = 0
        }
    },
}
