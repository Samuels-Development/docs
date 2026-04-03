Config = Config or {}

Config.Recycling = {
    Enable = true, -- Toggle the recycler system on/off
    Shared = true, -- If true, recyclers are shared among all players. If false, each player has their own.

    -- Restrict the amount of items that can be put into the same recycler at once, if enable is false then allow an infinite amount.
    RestrictAmount = { Enable = true, Amount = 50 },

    ProcessingTime = {
        useBaseTime = false,   -- If true, use baseTime for all recycling processes
        baseTime    = 60,     -- 60 seconds if useBaseTime is true
        perItemTime = 1       -- Each individual item adds this amount in seconds if useBaseTime is false (with this set to 1, if you recycle 100 plastic, it will take 100 seconds)
    },

    Blip = {
        sprite = 365,
        scale = 0.75,
        color = 2,
        name = "Recycler",
        display = 4
    },

    Locations = {
        {
            coords = vector3(44.22, -1040.55, 29.52), -- Recycler location (add as many as needed)
            heading = 161.72, -- Direction the entity/prop faces

            blipEnable = true, -- Enable blip for this location

            Interaction = { -- You can't enable multiple options, choose one and disable (set to false) the rest of them.
                enablePed = true, -- Enable a ped target?
                pedModel = "s_m_y_dockwork_01", -- Model of the NPC (if enabled)

                enableProp = false, -- Enable a prop target?
                propModel = "bzzz_prop_recycler_b", -- Model of the prop (if enabled)
                activePropModel = "bzzz_prop_recycler_a", -- Model to swap to if recycler is active (if enabled) you can remove this line if you don't want the prop to swap when active

                enableBoxZone = false, -- Enable interaction using a BoxZone?

                distance = 1.5 -- Interaction distance
            }
        },
        {
            coords = vector3(612.83, -471.45, 24.76),
            heading = 176.09,

            blipEnable = true,

            Interaction = {
                enablePed = true,
                pedModel = "s_m_y_dockwork_01",

                enableProp = false,
                propModel = "bzzz_prop_recycler_b",
                activePropModel = "bzzz_prop_recycler_a",

                enableBoxZone = false,

                distance = 1.5
            }
        },
        -- You can add more locations here...
    },

    Items = {
        {
            name = "plastic_bottle",
            recycleInto = {
                { name = "scrap_plastic", min = 1, max = 2 },
                { name = "plastic_cap",   min = 1, max = 1 },
            }
        },
        {
            name = "cardboard",
            recycleInto = {
                { name = "paper_scraps", min = 1, max = 3 },
            }
        },
        {
            name = "metalscrap",
            recycleInto = {
                { name = "scrap_metal", min = 1, max = 3 },
            }
        },
        {
            name = "plastic",
            recycleInto = {
                { name = "scrap_plastic", min = 1, max = 2 },
            }
        },
        {
            name = "glass",
            recycleInto = {
                { name = "broken_glass", min = 1, max = 2 },
            }
        },
        {
            name = "rubber",
            recycleInto = {
                { name = "rubber_chunk", min = 1, max = 1 },
            }
        },
        {
            name = "steel",
            recycleInto = {
                { name = "scrap_steel", min = 1, max = 3 },
            }
        },
        {
            name = "bottle_cap",
            recycleInto = {
                { name = "scrap_aluminum", min = 1, max = 2 },
            }
        },
        {
            name = "garbage",
            recycleInto = {
                { name = "scrap_generic", min = 1, max = 2 },
            }
        },
        {
            name = "paperbag",
            recycleInto = {
                { name = "paper_scraps", min = 1, max = 3 },
            }
        },
        {
            name = "cleaningkit",
            recycleInto = {
                { name = "scrap_plastic", min = 1, max = 2 },
                { name = "scrap_cloth",   min = 1, max = 2 },
            }
        },
        {
            name = "walkstick",
            recycleInto = {
                { name = "wood_chunk", min = 1, max = 1 },
            }
        },
        {
            name = "lighter",
            recycleInto = {
                { name = "metal_filings", min = 1, max = 1 },
                { name = "scrap_plastic", min = 1, max = 2 },
            }
        },
        {
            name = "toaster",
            recycleInto = {
                { name = "scrap_metal",       min = 1, max = 2 },
                { name = "scrap_electronics", min = 1, max = 1 },
            }
        },
        {
            name = "weapon_bottle",
            recycleInto = {
                { name = "broken_glass", min = 1, max = 2 },
            }
        },
        {
            name = "lockpick",
            recycleInto = {
                { name = "metal_filings", min = 1, max = 2 },
            }
        },
        {
            name = "10kgoldchain",
            recycleInto = {
                { name = "gold_scraps", min = 1, max = 1 },
            }
        },
        {
            name = "ruby_earring_silver",
            recycleInto = {
                { name = "silver_scraps", min = 1, max = 2 },
                { name = "ruby_chip",     min = 1, max = 1 },
            }
        },
        {
            name = "goldearring",
            recycleInto = {
                { name = "gold_scraps", min = 1, max = 2 },
            }
        },
        {
            name = "antique_coin",
            recycleInto = {
                { name = "rare_metal", min = 1, max = 1 },
            }
        }
    }
}