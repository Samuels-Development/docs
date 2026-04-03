Config = Config or {}

Locale.LoadLocale('en')

-- Table of items used in the script
Config.Items = {
    BottleCap = 'bottle_cap', -- Bottle Caps
    Grinder = 'powersaw' -- Power Saw
}

Config.DumpsterCooldown = 10 -- Cooldown in minutes before a player can loot a dumpster or trash can again

-- true = dumpster/camp cooldowns are shared across all players (uses networking), false = per-player cooldowns (no networking needed)
-- If you're server produces a large volume of network entities, my script might fail to network dumpsters, essentially preventing users from looting any dumpsters. This only occurs in a small number of servers, if you can't figure out where 
-- the large volume of networked entities stem from in your server, then I'd suggest setting the below config to false.
Config.GlobalCooldown = true

-- Controls chance-based events during dumpster diving (e.g., needle pricks, hobo attacks).
Config.Events = {
    NeedlePrick = { -- Settings for the Needle Prick event
        Enable = true, -- Enable Needle Prick Event
        Duration = 120, -- Duration of the drunk/drug effect in seconds
        Cooldown = 600, -- Cooldown before the player can get pricked again in seconds
    },
    HoboAttack = { -- Settings for the Hobo Attack event
        Enable = true, -- Enable the Hobo attack event
        Cooldown = 600, -- Cooldown before the player can get attacked again in seconds
        Models = { -- Models that are used for the hobo attack event, will randomize between them.
            'a_m_m_tramp_01',
            'a_m_m_trampbeac_01',
            'a_m_m_hillbilly_01',
            'a_m_m_hillbilly_02',
            'a_f_m_tramp_01',
            'a_f_m_trampbeac_01',
        },
        MaxDistance = 150, -- Maximum distance the player can be from the hobo before it despawns
        Weapon = {      -- New weapon configuration sub-table
            Enable = true,        -- If false, no weapon will be given
            Name = "WEAPON_KNIFE", -- Weapon name 
            DropWeapon = true      -- If true, the weapon will be added to the hobo's loot pool (e.g. when a player loots the hobo give the weapon as well as other stuff, refer to Config.HoboLoot)
        }
    }
}

-- Determines how buying/selling transactions are handled (e.g., 'cash' or 'caps').
-- This value is referenced to decide if the player uses money or bottle caps.
Config.Payout = 'caps' -- cash/caps

-- Controls whether players can open stashes in dumpsters and trash cans
-- Requires ox_inventory to be running
Config.Stashes = {
    Enable = true, -- Enable/Disable stash functionality for dumpsters and trash cans
}

-- Choose between the resource giving you items after the progressbar or opening up a stash with your items in it. (counts for dumpsters, trash cans and camps)
-- If true: loot goes into a temporary stash, instead of directly to player inventory, that's opened after the progressbar.
-- If false: gives the items directly to the player after the progressbar.
-- Requires ox_inventory to be running
Config.LootToStash = false

-- Controls the Hobo King NPC itself (model, spawn location, scenario, etc.).
--  Location is randomized from Config.Ped.Location in your script.
--  Interaction: sets up the NPC target so players can open the PedMenu.
Config.Ped = {
    Enable = true, -- true/false
    Location = {
        {x = 3.152987, y = -1215.155, z = 25.70303, w = 267.1587}
        -- Add more locations as needed (Will Randomize from available locations each script start)
    },
    Model = "u_m_y_militarybum",
    Interaction = {
        Icon = "fas fa-circle",
        Distance = 3.0,
    },
    Scenario = "WORLD_HUMAN_BUM_STANDING" -- Full list of scenarios @ https://pastebin.com/6mrYTdQv
}

-- Creates a map blip for the Hobo King’s location (if enabled).
Config.Blip = {
    Enable = false, -- Change to false to disable blip creation
    Sprite = 480, -- Sprite/Icon
    Display = 4, -- No Touce
    Scale = 0.6, -- Scale of the Blip
    Colour = 1, -- Color of the Blip
    Name = "Hobo King", -- Name of the blip
}

-- This table holds descriptive metadata for various items in your script.
-- Key (e.g., 'lockpick', 'weapon_knuckle') is the item's "internal" name.
-- Value is a table defining:
--   label = A player-friendly display name (used in menus, notifications, etc.).
--   icon  = A Font Awesome (or similar) icon reference for UI elements.
Config.ItemsMetadata = {
    ['lockpick'] = { label = 'Lockpick', icon = 'fas fa-tools' },
    ['weapon_knuckle'] = { label = 'Knuckle Duster', icon = 'fas fa-hand-rock' }, 
    ['weapon_switchblade'] = { label = 'Switchblade', icon = 'fas fa-tools' },
    ['low_quality_meth'] = { label = 'Low Quality Meth', icon = 'fas fa-vial' },
    ['metalscrap'] = { label = 'Scrap Metal', icon = 'fas fa-cogs' },
    ['plastic'] = { label = 'Plastic', icon = 'fas fa-box-open' },
    ['glass'] = { label = 'Glass', icon = 'fas fa-glass-martini' },
    ['rubber'] = { label = 'Rubber', icon = 'fas fa-circle' },
    ['steel'] = { label = 'Steel', icon = 'fas fa-tools' },
    ['garbage'] = { label = 'Garbage', icon = 'fas fa-trash' },
    ['paperbag'] = { label = 'Paper Bag', icon = 'fas fa-shopping-bag' },
    ['cleaningkit'] = { label = 'Cleaning Kit', icon = 'fas fa-broom' },
    ['walkstick'] = { label = 'Walking Stick', icon = 'fas fa-cane' },
    ['lighter'] = { label = 'Lighter', icon = 'fas fa-fire' },
    ['toaster'] = { label = 'Toaster', icon = 'fas fa-box' },
    ['10kgoldchain'] = { label = '10k Gold Chain', icon = 'fas fa-gem' },
    ['ruby_earring_silver'] = { label = 'Ruby Earring', icon = 'fas fa-gem' },
    ['goldearring'] = { label = 'Gold Earring', icon = 'fas fa-gem' },
    ['antique_coin'] = { label = 'Antique Coin', icon = 'fas fa-coins' },
    ['rims'] = { label = 'Rims', icon = 'fas fa-cogs' },
    ['md_silverearings'] = { label = 'Silver Earrings', icon = 'fas fa-gem' },
    ['bottle_cap'] = { label = 'Bottle Cap', icon = 'fas fa-circle' },
    ['gold_nugget'] = { label = 'Gold Nugget', icon = 'fas fa-gem' },
    ['ancient_coin'] = { label = 'Ancient Coin', icon = 'fas fa-coins' },
    ['weapon_bottle'] = { label = 'Broken Bottle', icon = 'fas fa-wine-bottle' },

    -- Items that result from recycling:
    ['scrap_plastic'] = { label = 'Scrap Plastic', icon = 'fas fa-recycle' },
    ['plastic_cap'] = { label = 'Plastic Cap', icon = 'fas fa-circle-notch' },
    ['paper_scraps'] = { label = 'Paper Scraps', icon = 'fas fa-file-alt' },
    ['scrap_metal'] = { label = 'Scrap Metal', icon = 'fas fa-cogs' },
    ['broken_glass'] = { label = 'Broken Glass', icon = 'fas fa-glass-martini-alt' },
    ['rubber_chunk'] = { label = 'Rubber Chunk', icon = 'fas fa-cube' },
    ['scrap_steel'] = { label = 'Scrap Steel', icon = 'fas fa-wrench' },
    ['scrap_aluminum'] = { label = 'Scrap Aluminum', icon = 'fas fa-industry' },
    ['scrap_generic'] = { label = 'Generic Scrap', icon = 'fas fa-trash-alt' },
    ['scrap_cloth'] = { label = 'Scrap Cloth', icon = 'fas fa-tshirt' },
    ['wood_chunk'] = { label = 'Wood Chunk', icon = 'fas fa-tree' },
    ['metal_filings'] = { label = 'Metal Filings', icon = 'fas fa-cog' },
    ['scrap_electronics'] = { label = 'Scrap Electronics', icon = 'fas fa-plug' },
    ['gold_scraps'] = { label = 'Gold Scraps', icon = 'fas fa-gem' },
    ['silver_scraps'] = { label = 'Silver Scraps', icon = 'fas fa-gem' },
    ['ruby_chip'] = { label = 'Ruby Chip', icon = 'fas fa-gem' },
    ['rare_metal'] = { label = 'Rare Metal', icon = 'fas fa-flask' }
}

-- Config.Shop
-- Defines items the Hobo King can Buy or Sell, along with their prices.
Config.Shop = {
    -- Format: [itemName] = { price = number, level = optional required level },
    Buy = {
        ['lockpick'] = { price = 150 },
        ['weapon_knuckle'] = { price = 100 },
        ['weapon_switchblade'] = { price = 150 },
        ['low_quality_meth'] = { price = 150, level = 3 },
    },
    Sell = {
    -- Format: [itemName] = { price = number },
        ['metalscrap'] = { price = 5 },
        ['plastic'] = { price = 5 },
        ['glass'] = { price = 5 },
        ['rubber'] = { price = 5 },
        ['steel'] = { price = 5 },
        ['garbage'] = { price = 2 },
        ['paperbag'] = { price = 5 },
        ['cleaningkit'] = { price = 5 },
        ['walkstick'] = { price = 10 },
        ['lighter'] = { price = 5 },
        ['toaster'] = { price = 10 },
        ['10kgoldchain'] = { price = 150 },
        ['ruby_earring_silver'] = { price = 130 },
        ['goldearring'] = { price = 180 },
        ['antique_coin'] = { price = 120 },
        ['rims'] = { price = 50 },
        ['md_silverearings'] = { price = 75 },
    },
}

-- Organizes which world-models are considered "Small" trash bins vs. "Large" dumpsters.
-- This helps the script determine locked/unlocked logic (for large dumpsters) 
-- or other distinctions.
Config.BinProps = {
    Small = { -- Trashcans/bins
        'prop_bin_07b',
        'prop_bin_01a',
        'prop_recyclebin_03_a',
        'zprop_bin_01a_old',
        'prop_bin_07c',
        'prop_bin_04a',
        'prop_bin_09a',
        'prop_bin_03a',
        'prop_bin_02a',
        'prop_bin_12a',
        'prop_bin_05a',
        'prop_bin_07a',
    },
    Large = { -- Large bins/Dumpsters/Skips
        'prop_skip_05a',
        'prop_dumpster_3a',
        'prop_skip_08a',
        'prop_dumpster_4b',
        'prop_bin_14a',
        'prop_skip_03',
        'prop_dumpster_01a',
        'prop_dumpster_4a',
        'prop_skip_10a',
        'prop_dumpster_02b',
        'prop_bin_14b',
        'prop_skip_06a',
        'prop_dumpster_02a',
        'prop_skip_02a',
    },
}

Config.Levels = {
    [1] = {
        Duration = 10, -- Time in seconds to loot a dumpster
        XPThreshold = 2000, -- XP required to reach level 2
        LockChance = 25, -- Chance of a dumpster being locked (percentage)
        SawDuration = 15, -- Time in seconds to saw open a locked dumpster
        LockCooldown = 30, -- Cooldown between locked dumpsters (minutes)
        BagLootChance = 25, -- Chance of finding loot in bags (percentage)
        DumpsterLootChance = 60, -- Chance of finding loot in dumpsters (percentage)
        CampLootChance = 50, -- Chance of finding loot in camps (percentage)
        NeedlePrickChance = 25,  -- Chance to get a prick from a needle when searching a bin or dumpster (percentage)
        HoboAttackChance = 15     -- Chance to be attacked by a hobo when searching a bin or dumpster (percentage)
    },
    [2] = {
        Duration = 9,
        XPThreshold = 5000,
        LockChance = 20,
        SawDuration = 11,
        LockCooldown = 35,
        BagLootChance = 30,
        DumpsterLootChance = 65,
        CampLootChance = 55,
        NeedlePrickChance = 22,
        HoboAttackChance = 14
    },
    [3] = {
        Duration = 8,
        XPThreshold = 10000,
        LockChance = 15,
        SawDuration = 8,
        LockCooldown = 40,
        LootChance = 40,
        DumpsterLootChance = 70,
        CampLootChance = 60,
        NeedlePrickChance = 20,
        HoboAttackChance = 13
    },
    [4] = {
        Duration = 6,
        XPThreshold = 16000,
        LockChance = 10,
        SawDuration = 7,
        LockCooldown = 45,
        BagLootChance = 50,
        DumpsterLootChance = 75,
        CampLootChance = 65,
        NeedlePrickChance = 18,
        HoboAttackChance = 11
    },
    [5] = {
        Duration = 4,
        XPThreshold = 24000,
        LockChance = 5,
        SawDuration = 5,
        LockCooldown = 50,
        BagLootChance = 75,
        DumpsterLootChance = 80,
        CampLootChance = 70,
        NeedlePrickChance = 15,
        HoboAttackChance = 9
    }
}

Config.LockedDumpster = {
    Enable = true,
}

-- Simple toggle controlling if the script will track and display player stats 
-- (like how many dumpsters they've searched, hobos looted, etc.).
Config.Stats = {
    Enable = true,
}

-- Enables a global leaderboard system based on the total stats and XP.
--   ShowNames: if false, only the local player sees their name; others are "Anonymous."
--   Amount: how many top players to show (e.g., top 5).
--   LevelMultipliers: multiplies your total stats by a factor based on your level.
Config.Leaderboard = {
    Enable = true, -- Enable the Leaderboard
    ShowNames = true, -- Show in-game Names of the Players, if false just says Anonymous
    Amount = 5, -- The amount of players to display on the leaderboard
    -- Leaderboard 'score' is calculated like this: total amount of stats * LevelMultiplier
    LevelMultipliers = { -- Define the multiplier for each level
        [1] = 1,   -- Level 1: No additional multiplier
        [2] = 2,   -- Level 2: 2x multiplier
        [3] = 3,   -- Level 3: 3x multiplier
        [4] = 4,   -- Level 4: 4x multiplier
        [5] = 5    -- Level 5: 5x multiplier
        -- Add more levels as needed
    }
}

-- Controls which mini-hack or skill-check is used to search certain dumpsters
-- or hobo camps. 'Args' is used to pass the correct arguments to that minigame.
Config.Minigame = {
    Dumpsters = {
        Enable = true, -- Enable/Disable the minigame for looting Dumpsters
        Minigame = 'lib.skillCheck', -- Choose any available minigame from StartHack/below listed minigames.
        Args = {
            ['ps-circle'] = {2, 10}, -- {Number of circles, Time in milliseconds}
            ['ps-maze'] = {20}, -- {Time in seconds}
            ['ps-varhack'] = {2, 3}, -- {Number of blocks, Time in seconds}
            ['ps-thermite'] = {10, 5, 3}, -- {Time in seconds, Grid size, Incorrect blocks}
            ['ps-scrambler'] = {'numeric', 30, 0}, -- {Type, Time in seconds, Mirrored option}
            ['memorygame-thermite'] = {10, 3, 3, 10}, -- {Correct blocks, Incorrect blocks, Show time in seconds, Lose time in seconds}
            ['ran-memorycard'] = {360}, -- {Time in seconds}
            ['ran-openterminal'] = {}, -- No additional arguments
            ['hacking-opengame'] = {15, 4, 1}, -- {Time in seconds, Number of blocks, Number of repeats}
            ['howdy-begin'] = {3, 5000}, -- {Number of icons, Time in milliseconds}
            ['sn-memorygame'] = {3, 2, 10000}, -- {Keys needed, Number of rounds, Time in milliseconds}
            ['sn-skillcheck'] = {50, 5000, {'w', 'a', 's', 'w'}, 2, 20, 3}, -- {Speed in milliseconds, Time in milliseconds, Keys, Number of rounds, Number of bars, Number of safe bars}
            ['sn-thermite'] = {7, 5, 10000, 2, 2, 3000}, -- {Number of boxes, Number of correct boxes, Time in milliseconds, Number of lives, Number of rounds, Show time in milliseconds}
            ['sn-keypad'] = {999, 3000}, -- {Code number, Time in milliseconds}
            ['sn-colorpicker'] = {3, 7000, 3000}, -- {Number of icons, Type time in milliseconds, View time in milliseconds}
            ['rm-typinggame'] = {'easy', 20}, -- {Difficulty, Duration in seconds}
            ['rm-timedlockpick'] = {200}, -- {Speed value}
            ['rm-timedaction'] = {3}, -- {Number of locks}
            ['rm-quicktimeevent'] = {'easy'}, -- {Difficulty}
            ['rm-combinationlock'] = {'easy'}, -- {Difficulty}
            ['rm-buttonmashing'] = {5, 10}, -- {Decay rate, Increment rate}
            ['rm-angledlockpick'] = {'easy'}, -- {Difficulty}
            ['rm-fingerprint'] = {200, 5}, -- {Time in seconds, Number of lives}
            ['rm-hotwirehack'] = {10}, -- {Time in seconds}
            ['rm-hackerminigame'] = {5, 3}, -- {Length, Number of lives}
            ['rm-safecrack'] = {'easy'}, -- {Difficulty}
            ['lib.skillCheck'] = {
                {'easy', 'medium', {areaSize = 40, speedMultiplier = 1.2}}, -- Preset/custom difficulties
                {'w', 'a', 's', 'd'} -- Inputs for skill check
            }
        }
    },
    Camps = {
        Minigame = 'lib.skillCheck', -- Choose any available minigame from StartHack/below listed minigames.
        Args = {
            ['ps-circle'] = {2, 10}, -- {Number of circles, Time in milliseconds}
            ['ps-maze'] = {20}, -- {Time in seconds}
            ['ps-varhack'] = {2, 3}, -- {Number of blocks, Time in seconds}
            ['ps-thermite'] = {10, 5, 3}, -- {Time in seconds, Grid size, Incorrect blocks}
            ['ps-scrambler'] = {'numeric', 30, 0}, -- {Type, Time in seconds, Mirrored option}
            ['memorygame-thermite'] = {10, 3, 3, 10}, -- {Correct blocks, Incorrect blocks, Show time in seconds, Lose time in seconds}
            ['ran-memorycard'] = {360}, -- {Time in seconds}
            ['ran-openterminal'] = {}, -- No additional arguments
            ['hacking-opengame'] = {15, 4, 1}, -- {Time in seconds, Number of blocks, Number of repeats}
            ['howdy-begin'] = {3, 5000}, -- {Number of icons, Time in milliseconds}
            ['sn-memorygame'] = {3, 2, 10000}, -- {Keys needed, Number of rounds, Time in milliseconds}
            ['sn-skillcheck'] = {50, 5000, {'w', 'a', 's', 'w'}, 2, 20, 3}, -- {Speed in milliseconds, Time in milliseconds, Keys, Number of rounds, Number of bars, Number of safe bars}
            ['sn-thermite'] = {7, 5, 10000, 2, 2, 3000}, -- {Number of boxes, Number of correct boxes, Time in milliseconds, Number of lives, Number of rounds, Show time in milliseconds}
            ['sn-keypad'] = {999, 3000}, -- {Code number, Time in milliseconds}
            ['sn-colorpicker'] = {3, 7000, 3000}, -- {Number of icons, Type time in milliseconds, View time in milliseconds}
            ['rm-typinggame'] = {'easy', 20}, -- {Difficulty, Duration in seconds}
            ['rm-timedlockpick'] = {200}, -- {Speed value}
            ['rm-timedaction'] = {3}, -- {Number of locks}
            ['rm-quicktimeevent'] = {'easy'}, -- {Difficulty}
            ['rm-combinationlock'] = {'easy'}, -- {Difficulty}
            ['rm-buttonmashing'] = {5, 10}, -- {Decay rate, Increment rate}
            ['rm-angledlockpick'] = {'easy'}, -- {Difficulty}
            ['rm-fingerprint'] = {200, 5}, -- {Time in seconds, Number of lives}
            ['rm-hotwirehack'] = {10}, -- {Time in seconds}
            ['rm-hackerminigame'] = {5, 3}, -- {Length, Number of lives}
            ['rm-safecrack'] = {'easy'}, -- {Difficulty}
            ['lib.skillCheck'] = {
                {'easy', 'medium', {areaSize = 40, speedMultiplier = 1.2}}, -- Preset/custom difficulties
                {'w', 'a', 's', 'd'} -- Inputs for skill check
            }
        }
    }
}

-- Daily objectives are personal tasks (progress is tracked per player)
-- Daily challenges are server‑wide; once one is completed, it’s no longer available.
Config.Daily = {
    EnableObjectives = true,    -- Enable personal daily objectives
    EnableChallenges = true,    -- Enable global daily challenges
    ObjectiveCount = 5,         -- How many objectives each player gets per server cycle
    ChallengeCount = 3,         -- How many challenges to select globally per cycle

    -- hardcoded table identifiers you can use that check for specific actions
    -- dumpstersSearched; amount of dumpsters/bisn the player has searched
    -- campSearched; amount of camps the player has searched
    -- hoboLooted; amount of hobos the player has looted
    -- bagsLooted; amount of trash bags the player has searched, then destroyed.

    -- if you want to track specific items, you can just name the table like the item.

    Objectives = {
        {
            id = "dumpstersSearched", -- hardcoded identifier for searching dumpsters
            name = "Dumpster Diver",
            target = 20,
            -- Type: item, xp, money
            -- If Type 'item' then Parameters name, amount, label have to be specified
            -- If Type 'xp' then Parameters amount have to be specified
            -- If Type 'money' then Parameters amount have to be specified
            reward = { type = "xp", amount = 150 }
        },
        {
            id = "campSearched", -- hardcoded identifier for searching camps
            name = "Camp Explorer", -- Name that gets displayed on the objective
            target = 5, -- The target amount to complete this task
            reward = { type = "item", name = "bottle_cap", amount = 100 }
        },
        {
            id = "plastic", -- item 
            name = "Plastic Picker",
            target = 100,
            reward = { type = "item", name = "plastic", amount = 15 }
        },
        {
            id = "metalscrap",
            name = "Metal Master",
            target = 50,
            reward = { type = "xp", amount = 200 }
        },
        {
            id = "glass",
            name = "Glass Gatherer",
            target = 50,
            reward = { type = "xp", amount = 200 }
        },
        {
            id = "bagsLooted", -- hardcoded
            name = "Trash Master",
            target = 10,
            reward = { type = "money", amount = 300 }
        },
        {
            id = "bottle_cap",
            name = "Bottle Cap Collector",
            target = 200,
            reward = { type = "item", name = "bottle_cap", amount = 300 }
        }
    },
    Challenges = {
        {
            id = "dumpstersSearched",
            name = "First Dumpster Dive",
            target = 1,
            reward = { type = "money", amount = 500 }
        },
        {
            id = "campSearched",
            name = "Hobo Camp Pioneer",
            target = 3,
            reward = { type = "xp", amount = 300 }
        },
        {
            id = "plastic",
            name = "Plastic Pursuit",
            target = 300,
            reward = { type = "xp", amount = 500 }
        },
        {
            id = "metalscrap",
            name = "Metal Collection",
            target = 100,
            reward = { type = "money", amount = 700 }
        },
        {
            id = "glass",
            name = "Glass Gathering",
            target = 100,
            reward = { type = "money", amount = 700 }
        },
        {
            id = "bottle_cap",
            name = "Bottle Cap Bonanza",
            target = 500,
            reward = { type = "xp", amount = 600 }
        },
        {
            id = "bagsLooted",
            name = "Trash Bag Trailblazer",
            target = 20,
            reward = { type = "money", amount = 800 }
        }
    }
}

-- Players can hit milestones (e.g., X dumpsters searched) to earn extra rewards.
-- Each key corresponds to a stat or category (like 'dumpstersSearched').
-- Each element in the array has:
--   RequiredAmount: how many times you need to do X
--   Reward: a sub-table telling what the reward is (type=item, xp, money).
Config.Milestones = {
    Enable = true, -- Enables/disables the entire milestone system

    -- hardcoded table identifiers you can use that check for specific actions
    -- dumpstersSearched; amount of dumpsters/bisn the player has searched
    -- campSearched; amount of camps the player has searched
    -- hoboLooted; amount of hobos the player has looted
    -- bagsLooted; amount of trash bags the player has searched, then destroyed.

    -- if you want to track specific items, you can just name the table like the item, refer to the milestones underneath the 4 milestones below.

    -- This milestone is for total dumpsters searched
    ["dumpstersSearched"] = {
        Name = "Dumpster Diver", -- Overall name for this milestone category
        -- Stage 1
        [1] = {
            RequiredAmount = 5, -- Amount of dumpsters searched
            -- Type: item, xp, money
            -- If Type 'item' then Parameters Name, Amount, Label have to be specified
            -- If Type 'xp' then Parameters Amount have to be specified
            -- If Type 'money' then Parameters Amount have to be specified
            Reward = { Type = "item", Name = "bottle_cap", Amount = 250, Label = "Bottle Caps" }
        },
        -- Stage 2
        [2] = {
            RequiredAmount = 10, -- Amount of dumpsters searched
            Reward = { Type = "xp", Amount = 200 }
        },
        -- Stage 3
        [3] = {
            RequiredAmount = 20, -- Amount of dumpsters searched
            Reward = { Type = "money", Amount = 500 }
        }
    },

    -- This milestone is for total camps searched
    ["campSearched"] = {
        Name = "Camp Explorer", -- Overall name for this milestone category
        [1] = {
            RequiredAmount = 5,
            Reward = { Type = "item", Name = "bottle_cap", Amount = 250, Label = "Bottle Caps" }
        },
        [2] = {
            RequiredAmount = 10,
            Reward = { Type = "xp", Amount = 200 }
        },
        [3] = {
            RequiredAmount = 2,
            Reward = { Type = "money", Amount = 500 }
        }
    },

    -- This milestone is for total amount of Hobos Looted
    ["hoboLooted"] = {
        Name = "Hobo Scavenger", -- Overall name for this milestone category
        [1] = {
            RequiredAmount = 2,
            Reward = { Type = "item", Name = "bottle_cap", Amount = 250, Label = "Bottle Caps" }
        },
        [2] = {
            RequiredAmount = 2,
            Reward = { Type = "xp", Amount = 200 }
        },
        [3] = {
            RequiredAmount = 2,
            Reward = { Type = "money", Amount = 500 }
        }
    },

    -- This milestone is for total amount of trash bags looted
    ["bagsLooted"] = {
        Name = "Trash Master", -- Overall name for this milestone category
        [1] = {
            RequiredAmount = 2,
            Reward = { Type = "item", Name = "bottle_cap", Amount = 200, Label = "Bottle Caps" }
        },
        [2] = {
            RequiredAmount = 2,
            Reward = { Type = "xp", Amount = 200 }
        },
        [3] = {
            RequiredAmount = 2,
            Reward = { Type = "money", Amount = 500 }
        }
    },

    -- Milestone for the item "metalscrap"
    ["metalscrap"] = {
        Name = "Metal Master", -- Overall name for this milestone category
        [1] = {
            RequiredAmount = 20,
            Reward = { Type = "money", Amount = 1000 }
        },
        [2] = {
            RequiredAmount = 50,
            Reward = { Type = "xp", Amount = 300 }
        }
    },

    -- Milestone for the item "rubber"
    ["rubber"] = {
        Name = "Rubber Collector", -- Overall name for this milestone category
        [1] = {
            RequiredAmount = 10,
            Reward = { Type = "item", Name = "bottle_cap", Amount = 200, Label = "Bottle Caps" }
        },
        [2] = {
            RequiredAmount = 25,
            Reward = { Type = "money", Amount = 250 }
        }
    },

    -- Add more milestones for other items or categories as needed
    -- Example:
    -- ["exampleItem"] = {
    --     Name = "Example Collector", -- Overall name for this milestone category
    --     [1] = {
    --         RequiredAmount = 100,
    --         Reward = { Type = "money", Amount = 500 }
    --     },
    --     [2] = {
    --         RequiredAmount = 200,
    --         Reward = { Type = "xp", Amount = 1000 }
    --     }
    -- }
}

-- Controls custom “dumpster zones” or areas of the map where the loot table
-- can be overridden or specialized. If Enable = true, the script creates
-- polygonal zones that can define unique loot behaviors.
Config.Zones = {
    Enable = false, -- Enable/Disable the zone system
    {
        name = "Burgershot",
        points = { -- Define polygon points for the zone 
            vector3(-1155.22, -892.34, 0.0),
            vector3(-1205.06, -921.80, 0.0),
            vector3(-1223.98, -893.33, 0.0),
            vector3(-1174.48, -860.87, 0.0)
        },
        thickness = 100,
        debug = true,
        LootTable = {
            Amount = 1,
            Items = {
                { name = 'WEAPON_CARBINERIFLE', quantity = {min = 1, max = 1}, chance = 5, xp = 100 },
                --{ name = 'metal_scrap', quantity = 5, chance = 50, xp = 10 },
                -- additional items...
            }
        }
    },
    -- Add more zones as needed
}

-- Loot table used when you defeat a hostile "hobo" NPC.
Config.HoboLoot = {
    Enable = true, -- If false, no target will be added to the dead hobo ped to loot and you can ignore below options inside of HoboLoot.
    Amount = {min = 2, max = 4}, -- Number of items to give
    Items = {
        { name = 'bottle_cap', quantity = {min = 1, max = 2}, chance = 50, xp = 10 },
        { name = 'metalscrap', quantity = {min = 1, max = 3}, chance = 40, xp = 5 },
        { name = 'plastic', quantity = {min = 1, max = 2}, chance = 30, xp = 5 },
        { name = 'lockpick', quantity = {min = 1, max = 1}, chance = 3, xp = 25 },
    },
    RareItem = {
        Enable = true,
        Items = {
            { name = 'md_silverearings', quantity = {min = 1, max = 1}, xp = 100 },
        },
        Quantity = {min = 1, max = 1},
        Chance = 5, -- 10% chance to get a rare item
        Cooldown = 15, -- in minutes
    }
}

-- For loose trash bags in the world that players can interact with and possibly loot.
--   Models: which bag prop models to target.
--   Loot: per-level loot table for these bags.
Config.Bags = {
    Enable = true, -- Enable/Disable the ability to target trash bags and search for loot
    Models = { -- Loose trash bags and similar props
        'bkr_prop_fakeid_binbag_01',
        'prop_rub_binbag_01',
        'prop_rub_binbag_02',
        'prop_rub_binbag_03',
        'prop_rub_binbag_04',
        'prop_rub_binbag_05',
        'prop_rub_binbag_06',
        'prop_rub_binbag_07',
        'prop_rub_binbag_08',
        'prop_rub_binbag_01b',
        'prop_ld_binbag_01',
        'p_rub_binbag_test',
        'prop_cs_street_binbag_01',
        'prop_cs_rub_binbag_01',
        'prop_rub_binbag_03b',
        'prop_rub_binbag_sd_01',
        'prop_rub_binbag_sd_02',
        'prop_ld_rub_binbag_01',
    },
    Loot = {
        [1] = { -- Level 1
            Amount = {min = 2, max = 3},
            Items = {
                { name = 'metalscrap', quantity = {min = 1, max = 2}, chance = 50, xp = 5 },
                { name = 'plastic', quantity = {min = 1, max = 2}, chance = 30, xp = 5 },
                { name = 'glass', quantity = {min = 1, max = 2}, chance = 20, xp = 5 }
            },
            RareItem = {
                Enable = true,
                Items = {
                    { name = 'lockpick', quantity = {min = 1, max = 1}, xp = 50 }
                },
                Quantity = {min = 1, max = 2},
                Chance = 2,
                Cooldown = 30
            }
        },
        [2] = { -- Level 2
            Amount = {min = 2, max = 4},
            Items = {
                { name = 'metalscrap', quantity = {min = 1, max = 3}, chance = 40, xp = 5 },
                { name = 'plastic', quantity = {min = 1, max = 3}, chance = 30, xp = 5 },
                { name = 'glass', quantity = {min = 1, max = 3}, chance = 20, xp = 5 },
                { name = 'rubber', quantity = {min = 1, max = 1}, chance = 15, xp = 10 },
                { name = 'steel', quantity = {min = 1, max = 2}, chance = 5, xp = 15 }
            },
            RareItem = {
                Enable = true,
                Items = {
                    { name = '10kgoldchain', quantity = {min = 1, max = 1}, xp = 50 }
                },
                quantity = {min = 1, max = 1},
                Chance = 3,
                Cooldown = 27
            }
        },
        [3] = { -- Level 3
            Amount = {min = 3, max = 5},
            Items = {
                { name = 'metalscrap', quantity = {min = 1, max = 4}, chance = 35, xp = 5 },
                { name = 'plastic', quantity = {min = 1, max = 4}, chance = 25, xp = 5 },
                { name = 'glass', quantity = {min = 1, max = 4}, chance = 25, xp = 5 },
                { name = 'rubber', quantity = {min = 1, max = 1}, chance = 20, xp = 10 },
                { name = 'steel', quantity = {min = 1, max = 3}, chance = 15, xp = 15 },
                { name = 'bottle_cap', quantity = {min = 1, max = 1}, chance = 5, xp = 20 },
                { name = 'lockpick', quantity = {min = 1, max = 2}, chance = 5, xp = 25 }
            },
            RareItem = {
                Enable = true,
                Items = {
                    { name = 'ruby_earring_silver', quantity = {min = 1, max = 1}, xp = 50 }
                },
                quantity = {min = 1, max = 1},
                Chance = 9,
                Cooldown = 22
            }
        },
        [4] = { -- Level 4
            Amount = {min = 4, max = 6},
            Items = {
                { name = 'metalscrap', quantity = {min = 1, max = 5}, chance = 30, xp = 5 },
                { name = 'plastic', quantity = {min = 1, max = 5}, chance = 25, xp = 5 },
                { name = 'glass', quantity = {min = 1, max = 5}, chance = 20, xp = 5 },
                { name = 'rubber', quantity = {min = 1, max = 1}, chance = 20, xp = 10 },
                { name = 'steel', quantity = {min = 1, max = 4}, chance = 20, xp = 15 },
                { name = 'bottle_cap', quantity = {min = 1, max = 1}, chance = 10, xp = 20 },
                { name = 'lockpick', quantity = {min = 1, max = 2}, chance = 5, xp = 25 },
                { name = 'garbage', quantity = {min = 1, max = 3}, chance = 2, xp = 2 }
            },
            RareItem = {
                Enable = true,
                Items = {
                    { name = 'goldearring', quantity = {min = 1, max = 1}, xp = 150 }
                },
                quantity = {min = 1, max = 1},
                Chance = 12,
                Cooldown = 18
            }
        },
        [5] = { -- Level 5
            Amount = {min = 5, max = 7},
            Items = {
                { name = 'metalscrap', quantity = {min = 1, max = 6}, chance = 25, xp = 5 },
                { name = 'plastic', quantity = {min = 1, max = 6}, chance = 20, xp = 5 },
                { name = 'glass', quantity = {min = 1, max = 6}, chance = 15, xp = 5 },
                { name = 'rubber', quantity = {min = 1, max = 1}, chance = 10, xp = 10 },
                { name = 'steel', quantity = {min = 1, max = 5}, chance = 15, xp = 15 },
                { name = 'bottle_cap', quantity = {min = 1, max = 1}, chance = 15, xp = 20 },
                { name = 'lockpick', quantity = {min = 1, max = 2}, chance = 10, xp = 25 },
                { name = 'garbage', quantity = {min = 1, max = 4}, chance = 2, xp = 2 },
                { name = 'paperbag', quantity = {min = 1, max = 2}, chance = 2, xp = 3 },
                { name = 'cleaningkit', quantity = {min = 1, max = 2}, chance = 2, xp = 8 },
                { name = 'walkstick', quantity = {min = 1, max = 1}, chance = 1, xp = 15 },
                { name = 'lighter', quantity = {min = 1, max = 1}, chance = 1, xp = 5 },
                { name = 'toaster', quantity = {min = 1, max = 2}, chance = 1, xp = 10 },
                { name = 'weapon_bottle', quantity = {min = 1, max = 1}, chance = 1, xp = 10 }
            },
            RareItem = {
                Enable = true,
                Items = {
                    { name = 'antique_coin', quantity = {min = 1, max = 1}, xp = 150 }
                },
                quantity = {min = 1, max = 1},
                Chance = 15,
                Cooldown = 15
            }
        }
    }
}

-- Defines the search for special "hobo camp" props. 
--   Models: which prop models are recognized as "hobo camps."
--   Cooldown: how many minutes until the same camp can be searched again.
--   Loot: per-level loot tables for these camp props.
Config.HoboCamps = {
    Enable = true, -- Enable/Disable the ability to search hobo camps
    Cooldown = 30, -- Cooldown in minutes before a player can loot a camp again
    Models = { -- Models to be able to target and search for loot
        "prop_skid_tent_01b",
        "m23_2_prop_m32_tent_01a",
        "prop_skid_tent_cloth",
        "prop_skid_tent_03",
        "prop_skid_tent_01",
    },
    Loot = { -- Loot Table
        [1] = { -- Level 1
            Amount = {min = 2, max = 3},
            Items = {
                { name = 'metalscrap', quantity = {min = 1, max = 2}, chance = 50, xp = 5 },
                { name = 'plastic', quantity = {min = 1, max = 2}, chance = 30, xp = 5 },
                { name = 'glass', quantity = {min = 1, max = 2}, chance = 20, xp = 5 }
            },
            RareItem = {
                Enable = true,
                Items = {
                    { name = 'lockpick', quantity = {min = 1, max = 1}, xp = 50 }
                },
                Quantity = {min = 1, max = 2},
                Chance = 2,
                Cooldown = 30
            }
        },
        [2] = { -- Level 2
            Amount = {min = 2, max = 4},
            Items = {
                { name = 'metalscrap', quantity = {min = 1, max = 3}, chance = 40, xp = 5 },
                { name = 'plastic', quantity = {min = 1, max = 3}, chance = 30, xp = 5 },
                { name = 'glass', quantity = {min = 1, max = 3}, chance = 20, xp = 5 },
                { name = 'rubber', quantity = {min = 1, max = 1}, chance = 15, xp = 10 },
                { name = 'steel', quantity = {min = 1, max = 2}, chance = 5, xp = 15 }
            },
            RareItem = {
                Enable = true,
                Items = {
                    { name = '10kgoldchain', quantity = {min = 1, max = 1}, xp = 50 }
                },
                quantity = {min = 1, max = 1},
                Chance = 3,
                Cooldown = 27
            }
        },
        [3] = { -- Level 3
            Amount = {min = 3, max = 5},
            Items = {
                { name = 'metalscrap', quantity = {min = 1, max = 4}, chance = 35, xp = 5 },
                { name = 'plastic', quantity = {min = 1, max = 4}, chance = 25, xp = 5 },
                { name = 'glass', quantity = {min = 1, max = 4}, chance = 25, xp = 5 },
                { name = 'rubber', quantity = {min = 1, max = 1}, chance = 20, xp = 10 },
                { name = 'steel', quantity = {min = 1, max = 3}, chance = 15, xp = 15 },
                { name = 'bottle_cap', quantity = {min = 1, max = 1}, chance = 5, xp = 20 },
                { name = 'lockpick', quantity = {min = 1, max = 2}, chance = 5, xp = 25 }
            },
            RareItem = {
                Enable = true,
                Items = {
                    { name = 'ruby_earring_silver', quantity = {min = 1, max = 1}, xp = 50 }
                },
                quantity = {min = 1, max = 1},
                Chance = 9,
                Cooldown = 22
            }
        },
        [4] = { -- Level 4
            Amount = {min = 4, max = 6},
            Items = {
                { name = 'metalscrap', quantity = {min = 1, max = 5}, chance = 30, xp = 5 },
                { name = 'plastic', quantity = {min = 1, max = 5}, chance = 25, xp = 5 },
                { name = 'glass', quantity = {min = 1, max = 5}, chance = 20, xp = 5 },
                { name = 'rubber', quantity = {min = 1, max = 1}, chance = 20, xp = 10 },
                { name = 'steel', quantity = {min = 1, max = 4}, chance = 20, xp = 15 },
                { name = 'bottle_cap', quantity = {min = 1, max = 1}, chance = 10, xp = 20 },
                { name = 'lockpick', quantity = {min = 1, max = 2}, chance = 5, xp = 25 },
                { name = 'garbage', quantity = {min = 1, max = 3}, chance = 2, xp = 2 }
            },
            RareItem = {
                Enable = true,
                Items = {
                    { name = 'goldearring', quantity = {min = 1, max = 1}, xp = 150 }
                },
                quantity = {min = 1, max = 1},
                Chance = 12,
                Cooldown = 18
            }
        },
        [5] = { -- Level 5
            Amount = {min = 5, max = 7},
            Items = {
                { name = 'metalscrap', quantity = {min = 1, max = 6}, chance = 25, xp = 5 },
                { name = 'plastic', quantity = {min = 1, max = 6}, chance = 20, xp = 5 },
                { name = 'glass', quantity = {min = 1, max = 6}, chance = 15, xp = 5 },
                { name = 'rubber', quantity = {min = 1, max = 1}, chance = 10, xp = 10 },
                { name = 'steel', quantity = {min = 1, max = 5}, chance = 15, xp = 15 },
                { name = 'bottle_cap', quantity = {min = 1, max = 1}, chance = 15, xp = 20 },
                { name = 'lockpick', quantity = {min = 1, max = 2}, chance = 10, xp = 25 },
                { name = 'garbage', quantity = {min = 1, max = 4}, chance = 2, xp = 2 },
                { name = 'paperbag', quantity = {min = 1, max = 2}, chance = 2, xp = 3 },
                { name = 'cleaningkit', quantity = {min = 1, max = 2}, chance = 2, xp = 8 },
                { name = 'walkstick', quantity = {min = 1, max = 1}, chance = 1, xp = 15 },
                { name = 'lighter', quantity = {min = 1, max = 1}, chance = 1, xp = 5 },
                { name = 'toaster', quantity = {min = 1, max = 2}, chance = 1, xp = 10 },
                { name = 'weapon_bottle', quantity = {min = 1, max = 1}, chance = 1, xp = 10 }
            },
            RareItem = {
                Enable = true,
                Items = {
                    { name = 'antique_coin', quantity = {min = 1, max = 1}, xp = 150 }
                },
                quantity = {min = 1, max = 1},
                Chance = 15,
                Cooldown = 15
            }
        }
    }
}

-- Default loot tables by level for dumpsters (if no zone overrides).
-- Each level table should define:
--   Amount = how many random items you draw from the 'Items' array
--   Items = table of possible items, each with .name, .quantity, .chance, and optional .xp
--   RareItem = optional subtable for special chance-based items
Config.DumpsterLoot = {
    [1] = { -- Level 1
        Amount = {min = 2, max = 3},
        Items = {
            { name = 'metalscrap', quantity = {min = 1, max = 2}, chance = 50, xp = 5 },
            { name = 'plastic', quantity = {min = 1, max = 2}, chance = 30, xp = 5 },
            { name = 'glass', quantity = {min = 1, max = 2}, chance = 20, xp = 5 }
        },
        RareItem = {
            Enable = true,
            Items = {
                { name = 'lockpick', quantity = {min = 1, max = 1}, xp = 50 },
                -- { name = 'gold_nugget', quantity = {min = 1, max = 2}, xp = 100 },
                -- { name = 'ancient_coin', quantity = {min = 1, max = 1}, xp = 150 },
            },
            Quantity = {min = 1, max = 2},
            Chance = 2,
            Cooldown = 30
        }
    },
    [2] = { -- Level 2
        Amount = {min = 2, max = 4},
        Items = {
            { name = 'metalscrap', quantity = {min = 1, max = 3}, chance = 40, xp = 5 },
            { name = 'plastic', quantity = {min = 1, max = 3}, chance = 30, xp = 5 },
            { name = 'glass', quantity = {min = 1, max = 3}, chance = 20, xp = 5 },
            { name = 'rubber', quantity = {min = 1, max = 1}, chance = 15, xp = 10 },
            { name = 'steel', quantity = {min = 1, max = 2}, chance = 5, xp = 15 }
        },
        RareItem = {
            Enable = true,
            Items = {
                { name = '10kgoldchain', quantity = {min = 1, max = 1}, xp = 50 }
            },
            Quantity = {min = 1, max = 1},
            Chance = 3,
            Cooldown = 27
        }
    },
    [3] = { -- Level 3
        Amount = {min = 3, max = 5},
        Items = {
            { name = 'metalscrap', quantity = {min = 1, max = 4}, chance = 35, xp = 5 },
            { name = 'plastic', quantity = {min = 1, max = 4}, chance = 25, xp = 5 },
            { name = 'glass', quantity = {min = 1, max = 4}, chance = 25, xp = 5 },
            { name = 'rubber', quantity = {min = 1, max = 1}, chance = 20, xp = 10 },
            { name = 'steel', quantity = {min = 1, max = 3}, chance = 15, xp = 15 },
            { name = 'bottle_cap', quantity = {min = 1, max = 1}, chance = 5, xp = 20 },
            { name = 'lockpick', quantity = {min = 1, max = 2}, chance = 5, xp = 25 }
        },
        RareItem = {
            Enable = true,
            Items = {
                { name = 'ruby_earring_silver', quantity = {min = 1, max = 1}, xp = 50 }
            },
            Quantity = {min = 1, max = 1},
            Chance = 9,
            Cooldown = 22
        }
    },
    [4] = { -- Level 4
        Amount = {min = 4, max = 6},
        Items = {
            { name = 'metalscrap', quantity = {min = 1, max = 5}, chance = 30, xp = 5 },
            { name = 'plastic', quantity = {min = 1, max = 5}, chance = 25, xp = 5 },
            { name = 'glass', quantity = {min = 1, max = 5}, chance = 20, xp = 5 },
            { name = 'rubber', quantity = {min = 1, max = 1}, chance = 20, xp = 10 },
            { name = 'steel', quantity = {min = 1, max = 4}, chance = 20, xp = 15 },
            { name = 'bottle_cap', quantity = {min = 1, max = 1}, chance = 10, xp = 20 },
            { name = 'lockpick', quantity = {min = 1, max = 2}, chance = 5, xp = 25 },
            { name = 'garbage', quantity = {min = 1, max = 3}, chance = 2, xp = 2 }
        },
        RareItem = {
            Enable = true,
            Items = {
                { name = 'goldearring', quantity = {min = 1, max = 1}, xp = 150 }
            },
            Quantity = {min = 1, max = 1},
            Chance = 12,
            Cooldown = 18
        }
    },
    [5] = { -- Level 5
        Amount = {min = 5, max = 7},
        Items = {
            { name = 'metalscrap', quantity = {min = 1, max = 6}, chance = 25, xp = 5 },
            { name = 'plastic', quantity = {min = 1, max = 6}, chance = 20, xp = 5 },
            { name = 'glass', quantity = {min = 1, max = 6}, chance = 15, xp = 5 },
            { name = 'rubber', quantity = {min = 1, max = 1}, chance = 10, xp = 10 },
            { name = 'steel', quantity = {min = 1, max = 5}, chance = 15, xp = 15 },
            { name = 'bottle_cap', quantity = {min = 1, max = 1}, chance = 15, xp = 20 },
            { name = 'lockpick', quantity = {min = 1, max = 2}, chance = 10, xp = 25 },
            { name = 'garbage', quantity = {min = 1, max = 4}, chance = 2, xp = 2 },
            { name = 'paperbag', quantity = {min = 1, max = 2}, chance = 2, xp = 3 },
            { name = 'cleaningkit', quantity = {min = 1, max = 2}, chance = 2, xp = 8 },
            { name = 'walkstick', quantity = {min = 1, max = 1}, chance = 1, xp = 15 },
            { name = 'lighter', quantity = {min = 1, max = 1}, chance = 1, xp = 5 },
            { name = 'toaster', quantity = {min = 1, max = 2}, chance = 1, xp = 10 },
            { name = 'weapon_bottle', quantity = {min = 1, max = 1}, chance = 1, xp = 10 }
        },
        RareItem = {
            Enable = true,
            Items = {
                { name = 'antique_coin', quantity = {min = 1, max = 1}, xp = 150 }
            },
            Quantity = {min = 1, max = 1},
            Chance = 15,
            Cooldown = 15
        }
    }
}