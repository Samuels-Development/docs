Config = Config or {}

Config.EnableRats = true -- true/false, disabling this will not make the rat option available

Config.LevelRestrict = { Enable = true, Level = 2 } -- If you want to restrict when a player can buy a rat, you can set this to true and specifiy the level

-- Define the rat levels.
-- Each level entry includes an XPThreshold that determines the XP cap for that level.
-- For example, if a rat has less than 100 XP it is level 1, less than 300 XP is level 2, etc.
Config.RatLevels = {
    { XPThreshold = 100 },   -- Level 1: XP < 100
    { XPThreshold = 300 },   -- Level 2: XP < 300
    { XPThreshold = 600 },   -- Level 3: XP < 600
    { XPThreshold = 1000 },  -- Level 4: XP < 1000
    { XPThreshold = 1500 }   -- Level 5: XP < 1500
    -- Add additional levels as needed.
}

-- Define the export for menu.
-- Enable/disable the export for menu option, and whether to only allow purchase at the hobo king.
-- This is great if you want people to be able to access their rat from a Radial Menu for ex. 
-- exports['sd-dumpsters']:openRatMenu()
-- event: sd-dumpsters:client:openRatMenu
Config.CreateExportForMenu = {
    Enable = true,         -- Enable/disable the export for menu option (true/false)
    -- If the player doesn't own a rat and OnlyAllowPurchaseAtKing is set to true, then calling the export from a radial for ex. will just give you a notification informing you that you don't have a rat.
    OnlyAllowPurchaseAtKing = false, -- If set to false, allow purchase from the menu when opening it via the export and not the hobo king. If set to true then you can buy a rat remotely.
}

-- exports['sd-dumpsters']:callRat()
-- event: sd-dumpsters:client:callRat
Config.CreateExportForRatFollow = { -- If enabled, it'll open up an export on the client which you can run to allow your players to have their rat follow them around.
    Enable = true,         -- Enable/disable the export for rat follow option (true/false)
}

Config.RegisterCommandForFollow = true -- This will register a command "CallRat" to allow your players to have their rat follow them around.

Config.PriceForRat = 1000 -- Price to purchase a Rat.

Config.InjuryRecoveryTime = 600 -- Amount of time it takes the rat to recover in case of injury, in seconds.

Config.PerkPointPerLevel = 2 -- The amount of perk points that are given to the user for each level

Config.RatPerks = {
    fleetFooted = { -- This perk makes your expeditions faster
        title = "rat.perk_fleet_footed", -- locale key 
        shortDesc = "rat.perk_fleet_footed_desc", -- locale key
        icon = "fas fa-running", -- icon for perk in menu
        levels = { -- each perk has levels with varying bonuses.
            { bonus = 10 }, -- % 
            { bonus = 20 }, -- %
            { bonus = 30 } -- %
        }
    },
    scavengerSupreme = { -- This perk boosts your rat's carrying capacity and amplies the amount of all picked items quantites (refer to Config.RatExpeditions.Loot.Items[item].quantity)
    -- So for example, if you have set the boost for level 1 to 1 and you've levelled the perk to level 1 and the quantities in an expedition for metalscrap is 2, then that value will be amplified to 3 and so on.
        title = "rat.perk_scavenger_supreme",
        shortDesc = "rat.perk_scavenger_supreme_desc",
        icon = "fas fa-box-open",
        levels = {
            { bonus = 1 }, -- Static Amount (Increase to Base Loot.Items[item].quantity for any given expedition, refer to Config.RatExpeditions)
            { bonus = 2 }, -- Static Amount (Increase to Base Loot.Items[item].quantity for any given expedition, refer to Config.RatExpeditions)
            { bonus = 3 }, -- Static Amount (Increase to Base Loot.Items[item].quantity for any given expedition, refer to Config.RatExpeditions)
        }
    },
    luckyWhiskers = { -- Improves the chance of getting rare items (for ex. if level 1 boost is 3 and a rare item has a 10% chance of dropping and you've levelled to level 1 then the chance will be 13%)
        title = "rat.perk_lucky_whiskers",
        shortDesc = "rat.perk_lucky_whiskers_desc",
        icon = "fas fa-clover",
        levels = {
            { bonus = 3 }, -- % (bonuses that modify chances of other itoms dropping apply to the chance itself (i.e. if rare chance is 10, then you upgrade this perk to level 1, your new chances will be 13 )
            { bonus = 5 }, -- % (rareItemChance + bonus)
            { bonus = 10 } -- % (rareItemChance + bonus)
        }
    },
    safetyPaws = { -- Reduces the risk of expeditions for your rat (same logic as with luckyWhiskers in terms of how the boosts are applied)
        title = "rat.perk_safety_paws",
        shortDesc = "rat.perk_safety_paws_desc",
        icon = "fas fa-shield-alt",
        levels = {
            { bonus = 10 }, -- %
            { bonus = 20 }, -- %
            { bonus = 30 } -- %
        }
    },
    quickRecovery = {  -- Reduces the amount of time your rat requires to recover in the scenario that it gets injured (same logic as with luckyWhiskers in terms of how the boosts are applied)
    title = "rat.perk_quick_recovery",
    shortDesc = "rat.perk_quick_recovery_desc",
    icon = "fas fa-hourglass-half",
    levels = {
        { bonus = 10 }, -- %
        { bonus = 20 }, -- %
        { bonus = 30 } -- %
    }
}
}

Config.RatExpeditions = {
    {
        id = "downtown", -- simply the id, no need to modify
        name = "Downtown Dash", -- the name as displayed in the menu for this expedition
        xpReward = 75,         -- base xp reward (you can set this to 0 or remove the line entirely, if you want their to only be XP from the items retrieved)
        duration = 1800,       -- 30 minutes (in seconds)
        risk = 10,             -- 10% risk of injury
        minLevel = 1,          -- The minimum rat level required to go on this expedition
        Loot = {
            Amount = {min = 2, max = 3}, -- The amount of stuff listed in items to pick from. i.e. if Amount is 2 then it'll choose 2 entries in the Items table to give you
            Items = {
                { name = 'metalscrap', quantity = {min = 5, max = 9}, chance = 50, xp = 5 }, -- item, quantity of said item that you get, chance as opposed to others, additional xp your rat gets if this item is chosen (xpReward + this)
                { name = 'plastic', quantity = {min = 4, max = 10}, chance = 30, xp = 10 }, -- item, quantity of said item that you get, chance as opposed to others, additional xp your rat gets if this item is chosen (xpReward + this)
                { name = 'glass', quantity = {min = 4, max = 10}, chance = 20, xp = 15 } -- item, quantity of said item that you get, chance as opposed to others, additional xp your rat gets if this item is chosen (xpReward + this)
            },
            RareItem = { -- 
                Enable = true, -- true/false enable rare drops
                Quantity = {min = 1, max = 1}, -- Quantity
                Chance = 2, -- Chance of receiving a rare item(s)
                Items = {
                    { name = 'lockpick', quantity = {min = 1, max = 1}, xp = 50 } -- item, quantity of said item that you get, chance as opposed to others, additional xp your rat gets if this item is chosen
                },
            }
        }
    },
    {
        id = "vinewood",
        name = "Vinewood Venture",
        xpReward = 125,
        duration = 2700,       -- 45 minutes
        risk = 15,
        minLevel = 1,
        Loot = {
            Amount = {min = 1, max = 3},
            Items = {
                { name = 'plastic', quantity = {min = 4, max = 10}, chance = 40, xp = 5 },
                { name = 'glass', quantity = {min = 4, max = 10}, chance = 30, xp = 10 },
                { name = 'metalscrap', quantity = {min = 4, max = 10}, chance = 30, xp = 10 }
            },
            RareItem = {
                Enable = true, -- Enable Rare Items
                Chance = 2, -- Chance of receiving a rare item(s)
                Quantity = {min = 1, max = 1}, -- Quantity
                Items = {
                    { name = 'rims', quantity = {min = 1, max = 1}, xp = 20 }
                },
            }
        }
    },
    {
        id = "east_ls",
        name = "East Los Santos Expedition",
        xpReward = 130,
        duration = 3600,       -- 1 hour
        risk = 20,
        minLevel = 1,
        Loot = {
            Amount = {min = 2, max = 3},
            Items = {
                { name = 'metalscrap', quantity = {min = 4, max = 10}, chance = 45, xp = 5 },
                { name = 'plastic', quantity = {min = 4, max = 10}, chance = 35, xp = 5 },
                { name = 'glass', quantity = {min = 4, max = 10}, chance = 20, xp = 5 }
            },
            RareItem = {
                Enable = true, -- Enable Rare Items
                Chance = 2, -- Chance of receiving a rare item(s)
                Quantity = {min = 1, max = 1}, -- Quantity
                Items = {
                    { name = 'rims', quantity = {min = 1, max = 1}, xp = 20 }
                },
            }
        }
    },
    {
        id = "west_ls",
        name = "West LS Wander",
        xpReward = 140,
        duration = 3000,       -- 50 minutes
        risk = 25,
        minLevel = 1,
        Loot = {
            Amount = {min = 2, max = 3},
            Items = {
                { name = 'plastic', quantity = {min = 4, max = 10}, chance = 40, xp = 5 },
                { name = 'metalscrap', quantity = {min = 4, max = 10}, chance = 40, xp = 5 },
                { name = 'glass', quantity = {min = 4, max = 10}, chance = 20, xp = 5 }
            },
            RareItem = {
                Enable = true, -- Enable Rare Items
                Chance = 5, -- Chance of receiving a rare item(s)
                Quantity = {min = 1, max = 1}, -- Quantity
                Items = {
                    { name = 'rims', quantity = {min = 1, max = 1}, xp = 20 }
                },
            }
        }
    },
    {
        id = "rich_run",
        name = "Rockford Rich Run",
        xpReward = 165,
        duration = 4500,       -- 1 hour 15 minutes
        risk = 30,
        minLevel = 1,
        Loot = {
            Amount = {min = 2, max = 4},
            Items = {
                { name = 'metalscrap', quantity = {min = 4, max = 10}, chance = 40, xp = 5 },
                { name = 'plastic', quantity = {min = 4, max = 10}, chance = 30, xp = 5 },
                { name = 'glass', quantity = {min = 4, max = 10}, chance = 30, xp = 5 }
            },
            RareItem = {
                Enable = true, -- Enable Rare Items
                Chance = 5, -- Chance of receiving a rare item(s)
                Quantity = {min = 1, max = 1}, -- Quantity
                Items = {
                    { name = 'rims', quantity = {min = 1, max = 1}, xp = 20 }
                },
            }
        }
    },
    {
        id = "south_ls",
        name = "South LS Scavenge",
        xpReward = 200,
        duration = 5400,       -- 1 hour 30 minutes
        risk = 35,
        minLevel = 1,
        Loot = {
            Amount = {min = 2, max = 4},
            Items = {
                { name = 'plastic', quantity = {min = 4, max = 10}, chance = 35, xp = 5 },
                { name = 'metalscrap', quantity = {min = 4, max = 10}, chance = 35, xp = 5 },
                { name = 'glass', quantity = {min = 4, max = 10}, chance = 30, xp = 5 }
            },
            RareItem = {
                Enable = true, -- Enable Rare Items
                Chance = 5, -- Chance of receiving a rare item(s)
                Quantity = {min = 1, max = 1}, -- Quantity
                Items = {
                    { name = 'rims', quantity = {min = 1, max = 1}, xp = 20 }
                },
            }
        }
    },
    {
        id = "littleseoul",
        name = "Little Seoul Loop",
        xpReward = 225,
        duration = 6000,       -- 1 hour 40 minutes
        risk = 40,
        minLevel = 2,
        Loot = {
            Amount = {min = 2, max = 3},
            Items = {
                { name = 'metalscrap', quantity = {min = 4, max = 10}, chance = 40, xp = 5 },
                { name = 'plastic', quantity = {min = 4, max = 10}, chance = 30, xp = 5 },
                { name = 'glass', quantity = {min = 4, max = 10}, chance = 30, xp = 5 }
            },
            RareItem = {
                Enable = true, -- Enable Rare Items
                Chance = 10, -- Chance of receiving a rare item(s)
                Quantity = {min = 1, max = 1}, -- Quantity
                Items = {
                    { name = 'rims', quantity = {min = 1, max = 1}, xp = 20 }
                },
            }
        }
    },
    {
        id = "lamesa",
        name = "La Mesa Mission",
        xpReward = 250,
        duration = 7200,       -- 2 hours
        risk = 45,
        minLevel = 3,
        Loot = {
            Amount = {min = 2, max = 4},
            Items = {
                { name = 'metalscrap', quantity = {min = 4, max = 10}, chance = 35, xp = 5 },
                { name = 'plastic', quantity = {min = 4, max = 10}, chance = 35, xp = 5 },
                { name = 'glass', quantity = {min = 4, max = 10}, chance = 30, xp = 5 }
            },
            RareItem = {
                Enable = true, -- Enable Rare Items
                Chance = 10, -- Chance of receiving a rare item(s)
                Quantity = {min = 1, max = 1}, -- Quantity
                Items = {
                    { name = 'rims', quantity = {min = 1, max = 1}, xp = 20 }
                },
            }
        }
    },
    {
        id = "delperro",
        name = "Del Perro Drive",
        xpReward = 280,
        duration = 8100,       -- 2 hours 15 minutes
        risk = 50,
        minLevel = 4,
        Loot = {
            Amount = {min = 2, max = 4},
            Items = {
                { name = 'metalscrap', quantity = {min = 4, max = 10}, chance = 30, xp = 5 },
                { name = 'plastic', quantity = {min = 4, max = 10}, chance = 30, xp = 5 },
                { name = 'glass', quantity = {min = 4, max = 10}, chance = 40, xp = 5 }
            },
            RareItem = {
                Enable = true, -- Enable Rare Items
                Chance = 10, -- Chance of receiving a rare item(s)
                Quantity = {min = 1, max = 1}, -- Quantity
                Items = {
                    { name = 'rims', quantity = {min = 1, max = 1}, xp = 20 }
                },
            }
        }
    },
    {
        id = "port_ls",
        name = "Port of Los Santos Probe",
        xpReward = 300,
        duration = 9000,       -- 2 hours 30 minutes
        risk = 60,
        minLevel = 5,
        Loot = {
            Amount = {min = 2, max = 4},
            Items = {
                { name = 'metalscrap', quantity = {min = 10, max = 30}, chance = 25, xp = 5 },
                { name = 'plastic', quantity = {min = 10, max = 30}, chance = 25, xp = 5 },
                { name = 'glass', quantity = {min = 10, max = 30}, chance = 25, xp = 5 }
            },
            RareItem = {
                Enable = true, -- Enable Rare Items
                Chance = 10, -- Chance of receiving a rare item(s)
                Quantity = {min = 1, max = 1}, -- Quantity
                Items = {
                    { name = 'rims', quantity = {min = 1, max = 1}, xp = 20 }
                },
            }
        }
    }
}