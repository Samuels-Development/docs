return {
    -- Locale Configuration
    -- Defines which language file to use from the locales folder
    -- Available: 'en' for English, 'de' for German (Deutsch)
    Locale = 'en',

    -- Enable debug prints and polyzones
    Debug = false,

    -- Saving Configuration
    -- All shop data is automatically saved when the server shuts down/restarts via txAdmin.
    -- Enable interval saving if you also want periodic saves while the server is running,
    -- as a safety net against crashes or unexpected shutdowns. 
    -- Warning: There is a LOT of data to save. I'd recommend keeping this disabled and if you do want ie enabled, make sure the interval isn't super frequent.
    Saving = {
        enabled = false,      -- Enable periodic saving while the server is running
        interval = 30,       -- How often to save (in minutes)
    },

    -- Weapon Serial Number Configuration
    -- When enabled, weapons purchased from shops will receive a unique serial number as metadata
    -- Default format mirrors ox_inventory: [6-digit-number][3-letter-code][6-digit-number]
    -- Example: 482917ABK637201
    WeaponSerial = {
        enabled = true,                     -- Enable/disable serial number generation for weapons
        registerToOwner = true,             -- If true, weapon metadata will include the buyer's character name

        -- Serial Format Configuration
        -- Controls how the serial number is generated
        -- Default values match ox_inventory's format
        serialFormat = {
            digitCount = 6,                 -- Number of random digits on each side (default: 6, produces 100000-999999)
            letterCount = 3,                -- Number of random uppercase letters in the middle (default: 3)
            excludedTexts = { 'POL', 'EMS' }, -- Letter combinations that won't be randomly generated (reserved for prefixes)
        },

        -- Optional: Define a default serial prefix (used as the middle letter block instead of random letters)
        -- Must be <= letterCount characters. Set to nil to generate random letters
        serialPrefix = nil,

        -- Per-shop-type serial prefixes (overrides the global serialPrefix for specific shop types)
        -- Useful for police armories, military shops, etc.
        shopTypePrefixes = {
            ['police_armory'] = 'POL',      -- Police armory weapons get POL prefix (e.g., 482917POL637201)
            -- ['military'] = 'MIL',
        },

        -- Weapon items that should receive a serial number
        -- Only items in this list will get serials. Items not listed (melee, throwables, utility) are skipped.
        -- If an item has the WEAPON_ prefix but is NOT in this list, it will NOT receive a serial.
        -- This list is based on ox_inventory's weapon data (firearms + stungun).
        -- You can add or remove items as needed for your server.
        serialWeapons = {
            -- Pistols
            'WEAPON_PISTOL',
            'WEAPON_PISTOL_MK2',
            'WEAPON_PISTOL50',
            'WEAPON_PISTOLXM3',
            'WEAPON_APPISTOL',
            'WEAPON_CERAMICPISTOL',
            'WEAPON_COMBATPISTOL',
            'WEAPON_DOUBLEACTION',
            'WEAPON_GADGETPISTOL',
            'WEAPON_HEAVYPISTOL',
            'WEAPON_MARKSMANPISTOL',
            'WEAPON_NAVYREVOLVER',
            'WEAPON_REVOLVER',
            'WEAPON_REVOLVER_MK2',
            'WEAPON_SNSPISTOL',
            'WEAPON_SNSPISTOL_MK2',
            'WEAPON_VINTAGEPISTOL',
            'WEAPON_FLAREGUN',
            'WEAPON_TECPISTOL',

            -- SMGs
            'WEAPON_SMG',
            'WEAPON_SMG_MK2',
            'WEAPON_ASSAULTSMG',
            'WEAPON_COMBATPDW',
            'WEAPON_MACHINEPISTOL',
            'WEAPON_MICROSMG',
            'WEAPON_MINISMG',

            -- Shotguns
            'WEAPON_ASSAULTSHOTGUN',
            'WEAPON_AUTOSHOTGUN',
            'WEAPON_BULLPUPSHOTGUN',
            'WEAPON_COMBATSHOTGUN',
            'WEAPON_DBSHOTGUN',
            'WEAPON_HEAVYSHOTGUN',
            'WEAPON_PUMPSHOTGUN',
            'WEAPON_PUMPSHOTGUN_MK2',
            'WEAPON_SAWNOFFSHOTGUN',
            'WEAPON_MUSKET',

            -- Rifles
            'WEAPON_ADVANCEDRIFLE',
            'WEAPON_ASSAULTRIFLE',
            'WEAPON_ASSAULTRIFLE_MK2',
            'WEAPON_BATTLERIFLE',
            'WEAPON_BULLPUPRIFLE',
            'WEAPON_BULLPUPRIFLE_MK2',
            'WEAPON_CARBINERIFLE',
            'WEAPON_CARBINERIFLE_MK2',
            'WEAPON_COMPACTRIFLE',
            'WEAPON_HEAVYRIFLE',
            'WEAPON_MILITARYRIFLE',
            'WEAPON_SPECIALCARBINE',
            'WEAPON_SPECIALCARBINE_MK2',
            'WEAPON_TACTICALRIFLE',

            -- Machine Guns
            'WEAPON_COMBATMG',
            'WEAPON_COMBATMG_MK2',
            'WEAPON_GUSENBERG',
            'WEAPON_MG',
            'WEAPON_MINIGUN',

            -- Sniper Rifles
            'WEAPON_HEAVYSNIPER',
            'WEAPON_HEAVYSNIPER_MK2',
            'WEAPON_MARKSMANRIFLE',
            'WEAPON_MARKSMANRIFLE_MK2',
            'WEAPON_PRECISIONRIFLE',
            'WEAPON_SNIPERRIFLE',

            -- Heavy / Launchers
            'WEAPON_COMPACTLAUNCHER',
            'WEAPON_EMPLAUNCHER',
            'WEAPON_FIREWORK',
            'WEAPON_GRENADELAUNCHER',
            'WEAPON_HOMINGLAUNCHER',
            'WEAPON_RAILGUN',
            'WEAPON_RAILGUNXM3',
            'WEAPON_RPG',
            'WEAPON_SNOWLAUNCHER',

            -- Energy / Sci-Fi
            'WEAPON_RAYCARBINE',
            'WEAPON_RAYMINIGUN',

            -- Special (no ammo but gets serial in ox_inventory)
            'WEAPON_STUNGUN',
        },
    },

    -- Global Item Metadata
    -- When enabled, applies metadata to items purchased from any shop without configuring each item individually.
    -- Define groups with different metadata for different sets of items.
    -- Per-item metadata (from BaseProducts or shop items) overrides group values if the same key exists.
    -- Weapon serial metadata (serial, registered) always takes highest priority.
    -- You can define metadata and display metadata for each item in Config.BaseProducts[type].items (just below) and also in each individual shop (shops.lua)
    --
    -- Each group has:
    --   applyTo  → 'all' (every item) or a list of item names
    --   metadata → the metadata table to apply
    --
    -- Groups are processed in order. Later groups override earlier groups for the same key.
    -- This means you can set a default for 'all', then override specific items in a later group.
    --
    -- Priority order: groups (earliest → latest) → per-item metadata → weapon metadata (highest)
    --
    -- displayMetadata (ox_inventory only):
    --   Maps metadata keys to display labels shown in the item tooltip.
    --   Uses ox_inventory's exports.ox_inventory:displayMetadata() on startup.
    --   Only keys listed here will be visible in the tooltip; unlisted keys are still stored but hidden.
    --
    --   Value types:
    --     String form:  key = 'Label'                                              → booleans display as "Yes"/"No"
    --     Table form:   key = { label = 'Label', trueValue = '...', falseValue = '...' } → booleans display as custom text
    --   Number metadata values are displayed as-is (e.g., quality = 80 → "Quality: 80").
    --
    --   DO NOT add these keys — ox_inventory already displays them by default:
    --     durability, description, ammo, serial, components, weapontint, type, label
    --   Adding them here will cause duplicate entries in the tooltip.
    --
    -- Example:
    --   groups = {
    --       { applyTo = 'all', metadata = { durability = 100 } },                          -- All items get durability 100 (displayed by ox_inventory automatically)
    --       { applyTo = { 'lockpick', 'screwdriver' }, metadata = { durability = 50 } },   -- These get durability 50 instead
    --       { applyTo = { 'bandage', 'firstaid' }, metadata = { sterile = true } },         -- These also get sterile = true (plus durability 100 from 'all')
    --   }
    --   displayMetadata = {
    --       sterile = 'Sterile',         -- Shows "Sterile: Yes" in the tooltip
    --       -- OR with custom boolean text:
    --       -- sterile = { label = 'Sterile', trueValue = 'Sanitized', falseValue = 'Contaminated' },
    --   }
    ApplyMetadata = {
        enabled = false,
        groups = {
            { applyTo = 'all', metadata = { durability = 100 } },
            { applyTo = { 'lockpick', 'screwdriver' }, metadata = { durability = 50 } },
            { applyTo = { 'bandage', 'firstaid' }, metadata = { sterile = true } },
        },
        displayMetadata = {
            -- Map metadata keys to their display labels (ox_inventory only).
            -- Do NOT add: durability, description, ammo, serial, components, weapontint, type, label, these will be ignored as ox_inventory handles them already.
            -- String form: key = 'Label' (booleans → "Yes"/"No", numbers → as-is)
            -- Table form:  key = { label = 'Label', trueValue = 'Custom Yes', falseValue = 'Custom No' }
            sterile = 'Sterile',
            -- sterile = { label = 'Sterile', trueValue = 'Sanitized', falseValue = 'Contaminated' },  -- Custom boolean display
        },
    },

    -- Ped spawn distance (distance at which peds will spawn/despawn)
    PedSpawnDistance = 50.0,

    -- Interaction distance
    InteractionDistance = 2.0,

    -- Society Payment System Configuration
    -- Allows players to purchase items using their job society funds
    SocietyPayments = {
        enabled = true,  -- Set to false to completely disable society payments in shops

        -- Define which societies/jobs can use society funds and what grade is required
        -- Format: ['society_name'] = { minGrade = 0, label = 'Display Name' }
        allowedSocieties = {
            ['police'] = {
                minGrade = 2,  -- Minimum job grade required to use society funds (sergeant and above)
                label = 'Police Society'
            },
            ['ambulance'] = {
                minGrade = 2,  -- Minimum grade to use EMS funds
                label = 'Ambulance Society'
            },
            ['mechanic'] = {
                minGrade = 1,  -- Mechanics can use society funds from grade 1+
                label = 'Mechanic Society'
            },
            -- Add more societies as needed
            -- ['realestate'] = {
            --     minGrade = 3,
            --     label = 'Real Estate Agency'
            -- },
        }
    },

    -- Unowned Shop Stock Configuration
    -- Controls starting stock levels for shops that don't have an owner
    -- This allows you to configure whether unowned shops have infinite stock or limited, tracked stock
    UnownedShopStock = {
        -- Global settings (can be overridden per shop type below)
        default = {
            infinite = true,        -- If true, unowned shops have infinite stock (999)
            startingStock = 50,     -- If infinite = false, this is the starting stock amount per item
        },

        -- Per-shop-type overrides (optional)
        -- If not specified for a shop type, it will use the default settings above
        ['247store'] = {
            infinite = true,
            startingStock = 50,
        },
        -- Example: liquorstore could have different settings
        -- ['liquorstore'] = {
        --     infinite = true,
        --     startingStock = 0,  -- Ignored when infinite = true
        -- },
    },

    -- Coupon system, these are the default coupons that are usable, if shops are ownable, owners can make these freely.
    Coupons = {
        ['WELCOME10'] = {
            discount = 10, -- 10% off
            description = 'Welcome discount'
        },
        ['SUMMER20'] = {
            discount = 20, -- 20% off
            description = 'Summer sale'
        },
        ['VIP25'] = {
            discount = 25, -- 25% off
            description = 'VIP discount'
        },
        ['GRANDOPENING'] = {
            discount = 15, -- 15% off
            description = 'Grand opening special'
        }
    },

    -- Loyalty System Configuration
    LoyaltySystem = {
        enabled = true,  -- Set to false to completely disable loyalty system (This setting also applies to the management menu, i.e. if false, even owned shops can't have loyalty system)
        requireUpgrade = true,  -- If true, shops must purchase the loyalty_program upgrade to use it
                               -- If false and enabled = true, loyalty is always available to all shops
        pointsPerDollar = 1,  -- How many loyalty points earned per dollar spent (by default)
    },

    -- Default Loyalty Rewards (for non-owned shops)
    -- These are the default rewards shown when a shop isn't owned
    DefaultLoyaltyRewards = {
        {
            id = 'default_reward_1',
            name = '5% Off Coupon',
            description = 'Get 5% off your next purchase',
            type = 'coupon',
            cost = 100,
            icon = '🎫',
            discountPercent = 5
        },
        {
            id = 'default_reward_2',
            name = '10% Off Coupon',
            description = 'Get 10% off your next purchase',
            type = 'coupon',
            cost = 250,
            icon = '🎟️',
            discountPercent = 10
        },
        {
            id = 'default_reward_3',
            name = '15% Off Coupon',
            description = 'Get 15% off your next purchase',
            type = 'coupon',
            cost = 500,
            icon = '🏷️',
            discountPercent = 15
        },
        {
            id = 'default_reward_4',
            name = '20% Off Coupon',
            description = 'Get 20% off your next purchase',
            type = 'coupon',
            cost = 1000,
            icon = '🏷️',
            discountPercent = 20
        },
    },

    -- Shop Type Display Configuration
    -- Define the icon and color scheme for each shop type
    -- Icons: Use ANY icon name from https://lucide.dev/icons (use the kebab-case format shown on the site)
    -- Available colors: emerald, purple, orange, red, slate, blue, green, yellow, pink, indigo,
    --                   cyan, teal, lime, amber, rose, fuchsia, violet, sky, gray, zinc, neutral, stone
    ShopTypeDisplay = {
        ['247store'] = {
            icon = 'shopping-cart',
            color = 'emerald'
        },
        ['liquorstore'] = {
            icon = 'wine',
            color = 'purple'
        },
        ['hardware'] = {
            icon = 'wrench',
            color = 'orange'
        },
        ['pharmacy'] = {
            icon = 'heart',
            color = 'red'
        },
        ['gunstore'] = {
            icon = 'crosshair',
            color = 'red'
        },
        ['pawn'] = {
            icon = 'hand-coins',
            color = 'amber'
        },
        ['item'] = { icon = 'Gem', color = 'purple' }
    },

    -- Global Product Categories
    -- Centralized category definitions used across all shops
    -- Each category defines its title, color, and which shop types use it
    -- Categories can be referenced by their key (e.g., 'food', 'medical') in product definitions
    Categories = {
        colorsEnabled = true, -- Set to false to disable category colors/badges globally

        ['food'] = {
            title = 'Food & Drinks',
            color = 'green',
            types = {'247store', 'liquorstore'}, -- Shop types that use this category (MAKE EMPTY ARRAY IF CATEGORY SHOULD APPLY TO ALL TYPES)
            items = {'water', 'sandwich', 'coffee', 'burger', 'cola', 'sprunk', 'tosti', 'twerks_candy', 'cigarette', 'beer', 'vodka', 'whiskey', 'wine', 'tequila', 'champagne', 'rum'} -- Items belonging to this category
        },
        ['alcohol'] = {
            title = 'Alcohol',
            color = 'orange',
            types = {'liquorstore'},
            items = {'beer', 'vodka', 'whiskey', 'wine', 'tequila', 'champagne', 'rum'}
        },
        ['snacks'] = {
            title = 'Snacks',
            color = 'yellow',
            types = {'liquorstore'},
            items = {'chips', 'chocolate', 'peanuts'}
        },
        ['medical'] = {
            title = 'Medical',
            color = 'red',
            types = {'247store', 'pharmacy'},
            items = {'bandage', 'painkillers', 'firstaid', 'medicalbag', 'vicodin', 'morphine', 'antibiotics'}
        },
        ['tools'] = {
            title = 'Tools',
            color = 'blue',
            types = {'247store', 'hardware', 'pawn'},
            items = {'lighter', 'weapon_flashlight', 'repairkit', 'lockpick', 'rolling_paper', 'scratchcard', 'id_card', 'driver_license', 'advancedlockpick', 'screwdriverset', 'drill', 'powersaw', 'welding_torch', 'advancedrepairkit', 'cleaningkit'}
        },
        ['electronics'] = {
            title = 'Electronics',
            color = 'cyan',
            types = {'247store', 'hardware', 'pawn'},
            items = {'phone', 'radio', 'electronickit', 'radiocell', 'binoculars'}
        },
        ['valuables'] = {
            title = 'Valuables',
            color = 'amber',
            types = {'pawn'},
            items = {'goldbar', 'diamond', 'rolex', 'goldchain', 'jewelry', 'necklace', 'ring', 'bracelet', 'watch'}
        },
        ['weapons'] = {
            title = 'Weapons',
            color = 'red',
            types = {'weaponshop', 'gunstore'},
            items = {'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_APPISTOL', 'WEAPON_PISTOL50', 'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_CERAMICPISTOL', 'WEAPON_PISTOLXM3', 'WEAPON_SMG', 'WEAPON_MICROSMG', 'WEAPON_MINISMG', 'WEAPON_PUMPSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN', 'WEAPON_DBSHOTGUN'}
        },
        ['ammo'] = {
            title = 'Ammunition',
            color = 'orange',
            types = {'weaponshop', 'gunstore'},
            items = {'ammo-9', 'ammo-45', 'ammo-50', 'ammo-shotgun', 'ammo-22', 'ammo-38', 'ammo-rifle', 'ammo-rifle2', 'ammo-sniper'}
        },
        ['attachments'] = {
            title = 'Attachments',
            color = 'purple',
            types = {'weaponshop', 'gunstore'},
            items = {'at_flashlight', 'at_suppressor_light', 'at_suppressor_heavy', 'at_grip', 'at_scope_small', 'at_scope_holo', 'at_scope_medium', 'at_clip_extended_pistol', 'at_clip_extended_smg', 'at_clip_extended_shotgun', 'at_clip_extended_rifle'}
        },
        ['clothing'] = {
            title = 'Clothing',
            color = 'pink',
            types = {'clothingstore'},
            items = {} -- Add clothing items as needed
        },
        ['accessories'] = {
            title = 'Accessories',
            color = 'cyan',
            types = {'clothingstore'},
            items = {} -- Add accessory items as needed
        },
        ['automotive'] = {
            title = 'Automotive',
            color = 'gray',
            types = {'hardware'},
            items = {} -- Add automotive items as needed
        },
        ['hardware'] = {
            title = 'Hardware',
            color = 'blue',
            types = {'hardware'},
            items = {} -- Add hardware-specific items as needed
        },
        ['materials'] = {
            title = 'Materials',
            color = 'gray',
            types = {'hardware', 'pawn'},
            items = {'metalscrap', 'plastic', 'copper', 'iron', 'aluminium', 'glass', 'rubber', 'wood', 'wood_planks', 'md_nails', 'md_screw'}
        },
        ['supplies'] = {
            title = 'Supplies',
            color = 'pink',
            types = {'pharmacy'},
            items = {'gauze', 'icepack', 'heatpack'}
        },
    },

        -- Base Products Configuration
    -- When enabled, all shops of a type will use these items and prices
    -- This replaces the individual shop item definitions
    -- When disabled, falls back to using individual shop item definitions from Config.Shops[shopId].items
    -- If a type of store is used in Config.Shops[shopId] that isn't defined here, it'll fall back to using the individual shop item definitions.
    --
    -- PER-ITEM CURRENCY OVERRIDE (currencyItem):
    -- Any item can use currencyItem to require an item instead of cash. The price becomes the quantity needed.
    -- This works in both BaseProducts and individual shop items (Config.Shops[shopId].items).
    -- Example: { item = 'iron', price = 5, currencyItem = 'metalscrap' }  -- Costs 5 metalscrap instead of $5
    --
    -- ITEM DISPLAY OVERRIDES (label, description, image):
    -- Any item can override its display name, description, and image in the shop UI.
    -- These work in both BaseProducts and individual shop items (Config.Shops[shopId].items).
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
    -- This works in both BaseProducts and individual shop items (Config.Shops[shopId].items).
    -- For weapons, configured metadata is merged with weapon serial metadata (weapon fields take priority).
    --
    -- DISPLAY METADATA (ox_inventory only):
    -- Items can include a 'displayMetadata' table to register custom metadata keys for ox_inventory tooltip display.
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
    --
    -- Full item example:
    --   { item = 'bandage', price = 15, label = 'First Aid Bandage', description = 'Medical-grade bandage.', metadata = { durability = 100, sterile = true }, displayMetadata = { sterile = { label = 'Sterile', trueValue = 'Sanitized', falseValue = 'Contaminated' } } }
    --   → In the ox_inventory tooltip: "Durability: 100" (built-in) + "Sterile: Sanitized" (from displayMetadata)
    BaseProducts = {
        enabled = true, -- Set to false to use individual shop item definitions instead

        -- 24/7 Store Configuration
        ['247store'] = {
            items = {
                { item = 'water', price = 2 },
                { item = 'water', price = 5, label = 'Premium Spring Water', description = 'Imported artisan spring water.', image = 'lockpick.png', metadata = { quality = 100, purified = true }, displayMetadata = { quality = 'Quality', purified = { label = 'Purified', trueValue = 'Yes', falseValue = 'No' } } },
                { item = 'coffee', price = 4 },
                { item = 'burger', price = 8 },
                { item = 'cola', price = 3 },
                { item = 'sprunk', price = 3 },
                { item = 'tosti', price = 5 },
                { item = 'bandage', price = 15, --[[label = 'First Aid Bandage', description = 'Medical-grade bandage.', image = 'custom_bandage.png', metadata = { durability = 100, sterile = true }, displayMetadata = { sterile = { label = 'Sterile', trueValue = 'Sanitized', falseValue = 'Contaminated' } } ]] },
                { item = 'painkillers', price = 10 },
                { item = 'firstaid', price = 50 },
                { item = 'phone', price = 350 },
                { item = 'radio', price = 250, --[[ image = 'nui://ox_inventory/web/images/custom_bandage_image.png' ]] }, -- Example: full NUI path image override
                { item = 'lighter', price = 2 },
                { item = 'weapon_flashlight', price = 20 },
                { item = 'repairkit', price = 50 },
                { item = 'lockpick', price = 25 },
                { item = 'rolling_paper', price = 2 },
                { item = 'id_card', price = 100 },
                { item = 'driver_license', price = 150 }
            }
        },

        -- Liquor Store Configuration
        ['liquorstore'] = {
            items = {
                { item = 'water', price = 2 },
                { item = 'beer', price = 5 },
                { item = 'vodka', price = 15 },
                { item = 'whiskey', price = 20 },
                { item = 'wine', price = 18 },
                { item = 'tequila', price = 22 },
                { item = 'champagne', price = 30 },
                { item = 'rum', price = 16 },
                { item = 'chips', price = 3 },
                { item = 'chocolate', price = 4 },
                { item = 'peanuts', price = 3 }
            }
        },

        -- Hardware Store Configuration
        ['hardware'] = {
            items = {
                { item = 'lockpick', price = 50 },
                { item = 'advancedlockpick', price = 150 },
                { item = 'screwdriverset', price = 75 },
                { item = 'drill', price = 200 },
                { item = 'powersaw', price = 300 },
                { item = 'welding_torch', price = 250 },
                { item = 'repairkit', price = 100 },
                { item = 'advancedrepairkit', price = 200 },
                { item = 'cleaningkit', price = 50 },
                { item = 'electronickit', price = 150 },
                { item = 'metalscrap', price = 10 },
                { item = 'plastic', price = 8 },
                { item = 'copper', price = 15 },
                --{ item = 'iron', price = 12 },
                -- Example: this item costs 5 metalscrap instead of cash (per-item currency override)
                { item = 'iron', price = 5, currencyItem = 'metalscrap' },
                { item = 'aluminium', price = 10 },
                { item = 'glass', price = 5 },
                { item = 'rubber', price = 8 },
                { item = 'wood', price = 5 },
                { item = 'wood_planks', price = 10 },
                { item = 'md_nails', price = 2 },
                { item = 'md_screw', price = 2 },
                { item = 'radio', price = 250 },
                { item = 'radiocell', price = 15 },
                { item = 'binoculars', price = 100 },
                { item = 'lighter', price = 2 },
                { item = 'bandage', price = 15 },
            }
        },

        -- Pharmacy Configuration
        ['pharmacy'] = {
            items = {
                { item = 'bandage', price = 15 },
                { item = 'painkillers', price = 10 },
                { item = 'firstaid', price = 50 },
                { item = 'medicalbag', price = 150 },
                { item = 'vicodin', price = 30 },
                { item = 'morphine', price = 50 },
                { item = 'antibiotics', price = 25 },
                { item = 'gauze', price = 8 },
                { item = 'icepack', price = 10 },
                { item = 'heatpack', price = 10 }
            }
        },

        -- Gun Store Configuration
        ['gunstore'] = {
            items = { -- You can remove the license param entirely and then that item won't be locked behind the license requirement.
                -- Pistols (require weapon license)
                { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
                { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

                -- Ammunition (no license required)
                { item = 'ammo-9', price = 25 },

                -- Attachments (no license required)
                { item = 'at_flashlight', price = 150 },
                { item = 'at_suppressor_light', price = 800 },
                { item = 'at_clip_extended_pistol', price = 300 },
            }
        },

        -- ============================================================================
        -- PAWN SHOP CONFIGURATION (Hardcoded Shop Type)
        -- ============================================================================
        -- Pawn shops are a special hardcoded shop type that BUYS items FROM players.
        -- Unlike regular shops where players buy items, pawn shops pay players for their items.
        --
        -- HOW IT WORKS:
        -- - Players bring items from their inventory to sell
        -- - The pawn shop displays only items the player has that match the list below
        -- - The 'price' is what the PLAYER RECEIVES for selling the item
        -- - Players select items and quantities, then receive cash payment
        --
        -- To create a pawn shop, set shopType = 'pawn' in your shop definition (shops.lua)
        -- ============================================================================
        ['pawn'] = {
            items = {
                -- Electronics (common items players find/buy)
                { item = 'phone', price = 100 },
                { item = 'radio', price = 75 },
                { item = 'electronickit', price = 50 },

                -- Jewelry & Valuables (high value items)
                { item = 'goldbar', price = 500 },
                { item = 'diamond', price = 750 },
                { item = 'rolex', price = 1000 },
                { item = 'goldchain', price = 350 },

                -- Raw Materials (from jobs/gathering)
                { item = 'metalscrap', price = 5 },
                { item = 'copper', price = 8 },
                { item = 'iron', price = 6 },
                { item = 'aluminium', price = 5 },
                { item = 'glass', price = 2 },

                -- Tools (used items players want to offload)
                { item = 'lockpick', price = 10 },
                { item = 'advancedlockpick', price = 50 },
                { item = 'repairkit', price = 25 },
                { item = 'drill', price = 75 },

                -- Miscellaneous
                { item = 'lighter', price = 1 },
                { item = 'binoculars', price = 30 },
            }
        },

        -- Police Armory Configuration
        ['police_armory'] = {
            items = {
                -- Protective Equipment
                { item = 'armour', price = 500 },
                { item = 'heavyarmor', price = 1500 },

                -- Medical Supplies
                { item = 'bandage', price = 25 },
                { item = 'painkillers', price = 20 },
                { item = 'firstaid', price = 75 },
                { item = 'medicalbag', price = 200 },

                -- Tools & Equipment
                { item = 'radio', price = 100 },
                { item = 'weapon_flashlight', price = 50 },
                { item = 'handcuffs', price = 75 },
                { item = 'binoculars', price = 150 },

                -- Weapons
                { item = 'WEAPON_PISTOL', price = 500 },
                { item = 'WEAPON_COMBATPISTOL', price = 750 },
                { item = 'WEAPON_STUNGUN', price = 350 },
                { item = 'WEAPON_PUMPSHOTGUN', price = 1500 },
                { item = 'WEAPON_CARBINERIFLE', price = 2500 },
                { item = 'WEAPON_SMG', price = 1800 },
                { item = 'WEAPON_NIGHTSTICK', price = 100 },

                -- Ammunition
                { item = 'ammo-9', price = 15 },
                { item = 'ammo-rifle', price = 25 },
                { item = 'ammo-shotgun', price = 20 },
            }
        }
    },

}
