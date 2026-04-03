Config = {}

SD.Locale.LoadLocale('en') -- Load the locale language, if available. You can change 'en' to any other available language in the locales folder.

-- General Settings..
Config.YachtDebug = false -- Change to true to enable PolyZone DebugPoly's for testing.

Config.MinimumCops = 4 -- How many on duty police required to start
Config.PoliceJobs = { 'police', --[['sheriff']] } -- Array of jobs that are checked in the cop count callback.
Config.HasSpawnedOnYacht = true -- If you're testing the resource, please set this to false. If you restart the script, while having this as true, the script won't function. Make SURE to change this back to true for your Live Server

Config.Cooldown = 180 -- minutes 
Config.ResetYachtOnLeave = false -- if true, the yacht and the cooldown (therefore everything else) will reset, if the code hasn't been input yet and nobody is inside the Polyzone whilst the cooldown is active! (This is to avoid, people starting the robbery, then retreating and locking the yacht for everyone else without ever actually starting the 'robbery' section, till the cooldown is finished)
-- if false, the cooldown will count down as normal, regardless if the codes have been input.

Config.CheckForItem = true -- Will check that the users entering have at least Config.Items.YachtCodes, if they don't the robbery won't trigger.

Config.Interaction = 'target' -- 'target' = qb-target/qtarget/ox_target or 'textui' = cd_drawtextui/qb-core/ox_lib textui 

-- Police Alert for Yacht Robbery
policeAlert = function()
    SD.PoliceDispatch({
        displayCode = "10-31D",                       -- Dispatch code for a Pacific bank heist
        title = 'Yacht Heist',                 -- Title is used in cd_dispatch/ps-dispatch
        description = "Yacht Heist in progress", -- Description of the heist
        message = "Multiple suspects reported near the Yacht", -- Additional message or information
        -- Blip information is used for ALL dispatches besides ps_dispatch, please reference dispatchcodename below.
        sprite = 108,                                 -- The blip sprite for bank or related icon
        scale = 1.0,                                  -- The size of the blip on the map
        colour = 1,                                   -- The color of the blip on the map
        blipText = "Yacht Heist",               -- Text that appears on the Blip
        -- ps-dispatch
        dispatchcodename = "yacht_heist"       -- This is the name used by ps-dispatch users for the sv_dispatchcodes.lua or config.lua under the Config.Blips entry. (Depending on Version)
    })
end -- This is the function that is called when the police are meant to be alerted. You can modify this in any way.

-- Items used in our script.
Config.UsedItems = {
    USB = 'default_gateway_override',
    YachtCodes = 'yachtcodes',
    CasinoCodes = 'casinocodes',
    Safe = 'secured_safe',
    ReviveKit = 'revivekit',
}

-- Configuration for cash and gold tray rewards on the yacht heist.
Config.CashoutType = 'dirty' -- Options: 'clean' = distribute unmarked cash; 'dirty' = distribute marked bills with worth (or dirty_money as 1-1 in the case of ESX); 'custom' = distribute custom item as currency.
-- 'custom' mode allows specifying a custom item to be used as currency.
-- For example, setting a dirty money item where each unit is equivalent to $1. (This is already the case in default ESX, so you can use 'dirty' mode instead of 'custom' if you're using base ESX dirty_money)
if Config.CashoutType == 'custom' then
    Config.CustomCash = {
        CashItem = 'markedbills',  -- Example item identifier. Replace with the actual item identifier used on your server.
        -- 'CashQuantity' determines how the cash amount is given:
        -- If false, each item represents 1 unit of currency (e.g., 1 'markedbills' item = $1). The amount of 'CashItem' given will be determined in Config.CashTrays.
        -- If true, the number of Config.CustomCash.CashItem given will equal the value of 'CashAmount' as defined by your server's economy. (this is good if you have a moneywashing script where one 'markedbills' equals to $5000 for ex.)
        CashQuantity = false, CashAmount = {min = 1, max = 2},
    }
end

-- With the below config commented, the script will automatically generate a random sequence of screens to hack each robbery,
-- if you want to set a specific sequence, uncomment the below config and set the sequence as needed.
-- Config.ScreenSequence = {3, 1, 2} -- The sequence of screens that need to be hacked in order to unlock the pressure regulation (eg. 3, 1, 2 = Pull Lever 3, then Lever 1, then Lever 2)

Config.FinalItems = {'casinocodes'}  -- These are the items you will recieve for completing the heist (You can continue the array, however long eg. {'casinocodes', 'phade'} )
Config.PasswordAttempts = 2 -- How many tries you get to enter the final password before failing the heist

Config.AlertPoliceOnEnter = true -- true = will alert police when someone enters the zone (and triggers the cooldown (eg. they're starting the heist)), false = will instead alert Police when the yacht codes have been inputted..

Config.GiveHints = true -- true = gives you hints on what to do, false = have fun finding out how to do the robbery..
Config.EnableExplosion = true -- true = if pressure reaches 0 the yacht will blow up, if false, the yacht will still seize up but not explode.
Config.PressureToExplode = 15 -- The pressure will cause the yacht to explode if it gets to or below this number

-- By how much does the Increase/Decrease pressure targets increase/decrease the pressure. Effectievely regulates, how often the pressure needs to be worked on.
Config.IncreasePressure1 = math.random(3, 5) -- You can change me! (Target1)
Config.IncreasePressure2 = math.random(5, 8) -- You can change me! (Target2)
Config.DecreasePressure1 = math.random(1, 3) -- You can change me! (Target1)
Config.DecreasePressure2 = math.random(5, 8) -- You can change me! (Target2)

Config.DecreaseTime = 5 -- How frequently (in seconds) does the pressure decrease by Config.DecreaseAmount
Config.DecreaseAmount = 1 -- By how much does the pressure decrease per Config.DecreaseTime

Config.ForceAnimation = true -- if true, the player will be forced into an animation, holding certain items

Config.SendToBeachOnSpawn = true -- TRUE = If the player spawns in at the yacht, it will send them to the beach, false = will do nothing (This is to avoid people exploting by logging and then spawning back on the Yacht at a later time)
Config.WashUpOnBeach = true -- Wash up on Beach after completing the heist (true = yes, false = no)
Config.SendBackOnReset = true -- True = You want players to be "wash up on the beach" if they are in the yacht area when the cooldown resets, False = You want nothing to happen to them
Config.UsingReviveKits = true -- If you want to Revivekits to work then set to true, if you don't want them to have a function, set to false..

Config.GiveAll = false -- If set to true, the player will receive all the items in the 'items' table of the searched cabin (Config.Cabins). If set to false, the player will receive a random item from the 'items' table of the searched cabin.

-- Blip Settings
Config.Blip = { -- Blip Settings
    Enable = true, -- Change to false to disable the Blip
    Location = vector3(-2031.6, -1038.13, 5.88), -- Change the blip coords here
    Sprite = 455,
    Display = 4,
    Scale = 0.6,
    Colour = 1,
    Name = "Secured Yacht", --Change the name to your liking
    Radius = { Enable = true, Size = 100.0 }  -- Add this line to configure the radius
}

-- Guards
Config.EnableGuards = true -- Enable NPC Guards for Yacht

Config.PedParameters = { -- Guard Settings
    Ped = "mp_m_bogdangoon",             -- The Model of the Ped, you'd like to use.
    Health = 200,                        -- The health of guards (both maximum and initial)
    Weapon = {"WEAPON_PISTOL", "WEAPON_SMG", "WEAPON_ASSAULTRIFLE"}, -- List of Weapons that the peds may have. (Randomized)
    MinArmor = 50,                       -- Minimum Amount of Armor the ped can have
    MaxArmor = 100,                      -- Maximum Amount of Armor the ped can have
    Headshots = true,                    -- Determines if guards can suffer critical hits (e.g., headshots)
    CombatAbility = 100,                 -- The combat ability of guards (0-100, 100 being the highest)
    Accuracy = 60,                       -- The accuracy of guards' shots (0-100, 100 being the highest)
    CombatRange = 2,                     -- The combat range of guards (0 = short, 1 = medium, 2 = long)
    CombatMovement = 2,                  -- The combat movement style of guards (0 = calm, 1 = normal, 2 = aggressive)
    CanRagdoll = true                    -- Determines if guards can be ragdolled from player impact.
}

Config.Guards = { 
    {
        coords = {
            vector4(-2018.79, -1034.8, 2.44, 227.68),
            vector4(-2042.43, -1032.15, 2.58, 295.69),
            vector4(-2061.38, -1021.41, 3.06, 224.1),
            vector4(-2046.92, -1029.44, 12.17, 243.86),
            vector4(-2084.52, -1018.06, 12.68, 167.13),
            vector4(-2120.55, -1007.19, 7.97, 204.83),
            vector4(-2079.44, -1019.75, 5.88, 264.04),
            vector4(-2099.52, -1009.07, 5.88, 214.19),
            vector4(-2080.38, -1019.14, 8.95, 258.9),
            vector4(-2057.1, -1031.69, 8.97, 190.27)
        },
    },
}

Config.EnableLooting = true -- Do you want to be able to Loot the Guards.

-- Rewards from Looting Peds
-- Note that 'chance' does not need to add up to 100 across all categories. It's a weight indicating the likelihood of a particular category being chosen relative to others. So, a category with chance 20 is twice as likely to be chosen as a category with chance 10.
-- Only ONE 'isGunReward' can be chosen for each loot. This means that even if the 'itemRange' allows for 4 items, only 3 items will be chosen if all the 'isGunReward' are set to true, as only one gun reward can be given per loot. If you want the users to have a chance to receive multiple weapons from different categories per loot, you need to set 'isGunReward' to false for the additional weapon categories.
-- For example, if 'itemRange' is set to 4, and Pistol, Rare, SMG & Shotgun all have 'isGunReward' set to true, then a max of 3 items will be given (one of which is a weapon). To potentially get 4 items with more than one weapon, at least one of these categories must have 'isGunReward' set to false.
Config.Rewards = {
    weaponChance = 60, -- overall chance of getting any gun-related reward
    itemRange = {min = 2, max = 3}, -- 'itemRange' determines the minimum and maximum number of items a player can get from each loot
    PistolRewards = {
        items = {"weapon_heavypistol", "weapon_pistol", "weapon_pistol_mk2"}, -- 'items' is the list of possible rewards
        chance = 37, -- 'chance' is the percentage probability of getting a reward
        isGunReward = true -- 'isGunReward' indicates whether this category is gun-related. If true, only one item from this category will be chosen per loot, even if 'itemRange' allows for more items.
    },
    RareRewards = {
        items = {"weapon_assaultrifle", "weapon_compactrifle", "weapon_mg"}, -- Items
        chance = 15, -- %
        isGunReward = true -- 'isGunReward' indicates whether this category is gun-related. If true, only one item from this category will be chosen per loot, even if 'itemRange' allows for more items.
    },
    SMGRewards = {
        items = {"weapon_assaultsmg", "weapon_minismg", "weapon_combatpdw"}, -- Items
        chance = 32, -- %
        isGunReward = true -- 'isGunReward' indicates whether this category is gun-related. If true, only one item from this category will be chosen per loot, even if 'itemRange' allows for more items.
    },
    ShotgunRewards = {
        items = {"weapon_sawnoffshotgun", "weapon_pumpshotgun", "weapon_dbshotgun"}, -- Items
        chance = 25, -- %
        isGunReward = true -- 'isGunReward' indicates whether this category is gun-related. If true, only one item from this category will be chosen per loot, even if 'itemRange' allows for more items.
    },
    AmmoRewards = {
        items = {"pistol_ammo", "shotgun_ammo", "rifle_ammo", "smg_ammo"}, -- Items
        chance = 45, -- %
        amount = {min = 1, max = 2} -- specifying amount that can be given if AmmoRewards is picked.
    },
    MedicRewards = {
        items = {"bandage", "revivekit"}, -- Items
        chance = 45, -- %
        amount = {min = 1, max = 2} -- specifying amount that can be given if MedicRewards is picked.
    },
}

-- Point that encompass the entirety of the Yacht area
Config.Points = {
    yacht = {
        coords = vector3(-2044.17, -1011.93, 0.0),  -- Approximate center
        distance = 60.0,  -- Effective radius, adjust as needed
    }
}

-- Settings for the hacking throughout the resource.
Config.Hacking = {
    Laptop = {
        Minigame = 'hacking-opengame', -- Choose any available minigame from SD.StartHack/below listed minigames.
        Args = {
            -- ps_ui minigames
            ['ps-circle'] = {2, 20}, -- {Number of circles, Time in milliseconds}
            ['ps-maze'] = {20}, -- {Time in seconds}
            ['ps-varhack'] = {2, 3}, -- {Number of blocks, Time in seconds}
            ['ps-thermite'] = {10, 5, 3}, -- {Time in seconds, Grid size, Incorrect blocks}
            ['ps-scrambler'] = {'numeric', 30, 0}, -- {Type, Time in seconds, Mirrored option}
            -- standalone memorygame
            ['memorygame-thermite'] = {10, 3, 3, 10}, -- {Correct blocks, Incorrect blocks, Show time in seconds, Lose time in seconds}
            -- ran minigames
            ['ran-memorycard'] = {360}, -- {Time in seconds}
            ['ran-openterminal'] = {}, -- No additional arguments
            -- nopixel hacking minigame
            ['hacking-opengame'] = {15, 4, 1}, -- {Time in seconds, Number of blocks, Number of repeats}
            -- howdy minigame
            ['howdy-begin'] = {3, 5000}, -- {Number of icons, Time in milliseconds}
            -- sn minigames
            ['sn-memorygame'] = {3, 2, 10000}, -- {Keys needed, Number of rounds, Time in milliseconds}
            ['sn-skillcheck'] = {50, 5000, {'w','a','s','w'}, 2, 20, 3}, -- {Speed in milliseconds, Time in milliseconds, Keys, Number of rounds, Number of bars, Number of safe bars}
            ['sn-thermite'] = {7, 5, 10000, 2, 2, 3000}, -- {Number of boxes, Number of correct boxes, Time in milliseconds, Number of lives, Number of rounds, Show time in milliseconds}
            ['sn-keypad'] = {999, 3000}, -- {Code number, Time in milliseconds}
            ['sn-colorpicker'] = {3, 7000, 3000}, -- {Number of icons, Type time in milliseconds, View time in milliseconds}
            -- rainmad minigames
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
            -- bl_ui
            ['bl-circlesum']         = {3, {length = 4, duration = 5000}}, -- {Iterations, {length, duration}}
            ['bl-digitdazzle']       = {3, {length = 4, duration = 5000}}, -- {Iterations, {length, duration}}
            ['bl-lightsout']         = {3, {level  = 2, duration = 5000}}, -- {Iterations, {level, duration}}
            ['bl-minesweeper']       = {3, {grid = 4, duration = 10000, target = 4, previewDuration = 2000}}, -- {Iterations, {grid, duration, target, previewDuration}}
            ['bl-pathfind']          = {3, {numberOfNodes = 10, duration = 5000}}, -- {Iterations, {numberOfNodes, duration}}
            ['bl-printlock']         = {3, {grid = 4, duration = 5000, target = 4}}, -- {Iterations, {grid, duration, target}}
            ['bl-untangle']          = {3, {numberOfNodes = 10, duration = 5000}}, -- {Iterations, {numberOfNodes, duration}}
            ['bl-wavematch']         = {3, {duration = 5000}}, -- {Iterations, {duration}}
            ['bl-wordwiz']           = {3, {length = 4, duration = 5000}}, -- {Iterations, {length, duration}}
            -- glitch-minigames
            ['gl-firewall-pulse']    = {3, 2, 10, 10, 40, 120, 10},    -- {requiredHacks, initialSpeed, maxSpeed, timeLimit(s), safeZoneMinWidth(px), safeZoneMaxWidth(px), safeZoneShrinkAmount(px)}
            ['gl-backdoor-sequence'] = {3, 5, 15, 3, 1.0, 1, 3, {'W','A','S','D','←','→','↑','↓','0','1','2','3','4','5','6','7','8','9'},"W, A, S, D, ←, →, ↑, ↓, 0-9"}, -- {requiredSeq, seqLength, timeLimit(s), maxAttempts, timePenalty(s), minSimKeys, maxSimKeys, customKeys, keyHintText}
            ['gl-circuit-rhythm']    = {4, {'A','S','D','F'}, 150, 1000, 20, 'normal', 5, 3}, -- {lanes, keys, noteSpeed, noteSpawnRate(ms), requiredNotes, difficulty, maxWrongKeys, maxMissedNotes}
            ['gl-surge-override']    = {{'E'}, 50, 2, false, {{'E','F'},{'SPACE','B'}}},  -- {possibleKeys, requiredPresses, decayRate, multiKeyMode, keyCombinations}
            ['gl-circuit-breaker']   = {1, 0, 1000, 5000, 5000, 0, 0, 3000, 30000}, -- {levelNumber, difficultyLevel, delayStart(ms), minFailDelay(ms), maxFailDelay(ms), disconnectChance, disconnectChanceRate, minReconnectTime(ms), maxReconnectTime(ms)}
            ['gl-data-crack']        = {3}, -- {difficulty}
            ['gl-brute-force']       = {}, -- No additional arguments (uses default numLives=5)
            ['gl-var-hack']          = {5, 5}, -- {blocks, speed(s)} 
        }
    },
    Terminal = { -- Terminals on the bridge
        Minigame = 'ps-circle', -- Choose any available minigame from SD.StartHack/below listed minigames.
        Args = {
            -- ps_ui minigames
            ['ps-circle'] = {2, 20}, -- {Number of circles, Time in milliseconds}
            ['ps-maze'] = {20}, -- {Time in seconds}
            ['ps-varhack'] = {2, 3}, -- {Number of blocks, Time in seconds}
            ['ps-thermite'] = {10, 5, 3}, -- {Time in seconds, Grid size, Incorrect blocks}
            ['ps-scrambler'] = {'numeric', 30, 0}, -- {Type, Time in seconds, Mirrored option}
            -- standalone memorygame
            ['memorygame-thermite'] = {10, 3, 3, 10}, -- {Correct blocks, Incorrect blocks, Show time in seconds, Lose time in seconds}
            -- ran minigames
            ['ran-memorycard'] = {360}, -- {Time in seconds}
            ['ran-openterminal'] = {}, -- No additional arguments
            -- nopixel hacking minigame
            ['hacking-opengame'] = {15, 4, 1}, -- {Time in seconds, Number of blocks, Number of repeats}
            -- howdy minigame
            ['howdy-begin'] = {3, 5000}, -- {Number of icons, Time in milliseconds}
            -- sn minigames
            ['sn-memorygame'] = {3, 2, 10000}, -- {Keys needed, Number of rounds, Time in milliseconds}
            ['sn-skillcheck'] = {50, 5000, {'w','a','s','w'}, 2, 20, 3}, -- {Speed in milliseconds, Time in milliseconds, Keys, Number of rounds, Number of bars, Number of safe bars}
            ['sn-thermite'] = {7, 5, 10000, 2, 2, 3000}, -- {Number of boxes, Number of correct boxes, Time in milliseconds, Number of lives, Number of rounds, Show time in milliseconds}
            ['sn-keypad'] = {999, 3000}, -- {Code number, Time in milliseconds}
            ['sn-colorpicker'] = {3, 7000, 3000}, -- {Number of icons, Type time in milliseconds, View time in milliseconds}
            -- rainmad minigames
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
            -- bl_ui
            ['bl-circlesum']         = {3, {length = 4, duration = 5000}}, -- {Iterations, {length, duration}}
            ['bl-digitdazzle']       = {3, {length = 4, duration = 5000}}, -- {Iterations, {length, duration}}
            ['bl-lightsout']         = {3, {level  = 2, duration = 5000}}, -- {Iterations, {level, duration}}
            ['bl-minesweeper']       = {3, {grid = 4, duration = 10000, target = 4, previewDuration = 2000}}, -- {Iterations, {grid, duration, target, previewDuration}}
            ['bl-pathfind']          = {3, {numberOfNodes = 10, duration = 5000}}, -- {Iterations, {numberOfNodes, duration}}
            ['bl-printlock']         = {3, {grid = 4, duration = 5000, target = 4}}, -- {Iterations, {grid, duration, target}}
            ['bl-untangle']          = {3, {numberOfNodes = 10, duration = 5000}}, -- {Iterations, {numberOfNodes, duration}}
            ['bl-wavematch']         = {3, {duration = 5000}}, -- {Iterations, {duration}}
            ['bl-wordwiz']           = {3, {length = 4, duration = 5000}}, -- {Iterations, {length, duration}}
            -- glitch-minigames
            ['gl-firewall-pulse']    = {3, 2, 10, 10, 40, 120, 10},    -- {requiredHacks, initialSpeed, maxSpeed, timeLimit(s), safeZoneMinWidth(px), safeZoneMaxWidth(px), safeZoneShrinkAmount(px)}
            ['gl-backdoor-sequence'] = {3, 5, 15, 3, 1.0, 1, 3, {'W','A','S','D','←','→','↑','↓','0','1','2','3','4','5','6','7','8','9'},"W, A, S, D, ←, →, ↑, ↓, 0-9"}, -- {requiredSeq, seqLength, timeLimit(s), maxAttempts, timePenalty(s), minSimKeys, maxSimKeys, customKeys, keyHintText}
            ['gl-circuit-rhythm']    = {4, {'A','S','D','F'}, 150, 1000, 20, 'normal', 5, 3}, -- {lanes, keys, noteSpeed, noteSpawnRate(ms), requiredNotes, difficulty, maxWrongKeys, maxMissedNotes}
            ['gl-surge-override']    = {{'E'}, 50, 2, false, {{'E','F'},{'SPACE','B'}}},  -- {possibleKeys, requiredPresses, decayRate, multiKeyMode, keyCombinations}
            ['gl-circuit-breaker']   = {1, 0, 1000, 5000, 5000, 0, 0, 3000, 30000}, -- {levelNumber, difficultyLevel, delayStart(ms), minFailDelay(ms), maxFailDelay(ms), disconnectChance, disconnectChanceRate, minReconnectTime(ms), maxReconnectTime(ms)}
            ['gl-data-crack']        = {3}, -- {difficulty}
            ['gl-brute-force']       = {}, -- No additional arguments (uses default numLives=5)
            ['gl-var-hack']          = {5, 5}, -- {blocks, speed(s)} 
        }
    },
}

-- Settings for the Puzzle -- Please don't mess with it, if you don't understand what you're doing..
Config.Puzzle = {
     [1] = {
         screens = false,
     },
     [2] = {
        one = false,
    },
    [3] = {
        two = false,
     },
     [4] = {
        three = false,
     },
     [5] = {
         four = false,
     },
     [6] = {
         pressure = 100,
     },
     [7] = {
         bricked = false,
     },
     [8] = {
        word = math.random(1, 4),
    },
    [9] = {
        button = false,
    },
    [10] = {
        vault = false,
    },
    [11] = {
        case = false,
    },
    [12] = {
        codes = false,
    },
 }

-- Locations for all the interactable(s) / targets
Config.Locations = {
    BeachWashup = vector4(-1839.39, -885.44, 1.68, 117.33), -- Beach washup after heist
    Screen_One = vector3(-2086.77, -1019.86, 12.53), -- 1st screen
    Screen_Two = vector3(-2086.66, -1017.5, 12.5), -- 2nd screen
    Screen_Three = vector3(-2085.31, -1015.74, 12.27), -- 3rd screen
    PuzzleStart = vector3(-2029.52, -1033.62, 2.8), -- Puzzle start
    PressureValve_One = vector3(-2063.6, -1025.01, 2.5), -- First pressure valve
    PressureValve_Two = vector3(-2052.57, -1032.55, 3.29), -- Second pressure valve
    CheckPressure = vector3(-2068.92, -1023.55, 3.1), -- Check pressure
    AttemptPassword = vector4(-2074.1, -1024.5, 11.62, 251.28), -- Password attempt
    RedButton = vector3(-2030.78, -1037.69, 2.8), -- Start engine
    EnterVault = vector3(-2071.36, -1018.63, 3.24), -- Enter vault
    ExitVault = vector3(-2072.83, -1018.49, 2.62), -- Exit vault
    EnterVaultPlayer = vector4(-2072.94, -1018.59, 1.46, 72.14), -- Teleport player entering vault
    ExitVaultPlayer = vector4(-2071.04, -1018.72, 1.95, 246.56), -- Teleport player exiting vault
    FinalBriefcase = vector4(-2074.31, -1018.11, 2.0, 72.12), -- Briefcase in vault
    Hack_1 = vector3(-2079.38, -1015.88, 5.91), -- Hack location 1
    Hack_2 = vector3(-2081.64, -1022.54, 8.38), -- Hack location 2
    Hack_3 = vector3(-2072.3, -1019.0, 11.82), -- Hack location 3
    Hack_4 = vector3(-2072.3, -1021.66, 2.99) -- Hack location 4
}

-- If true, we'll generate a new 3-segment code on every restart.
Config.RandomizeYachtCodes = true

-- If RandomizeYachtCodes = false, this is the code that’ll be used.
Config.YachtCodeDefault    = "21-65-31"

Config.CasinoCodesFirstHalf = "Z892-25B6-14R4-" -- The first half of the codes for yacht heist, or for dynamic version uncomment the one below

Config.ScreenLocationCenter = vector3(-2055.88, -1027.57, 4.28)-- The center of all the screen symbols

Config.ScreenPoints = { -- The locations and text for the 4 screens
    [1] = {
        coords = vector3(-2056.33032, -1028.51733, 3.16481071),
        url = '',
    },
    [2] = {
        coords = vector3(-2056.10645, -1027.82825, 3.16481071),
        url = '',
    },
    [3] = {
        coords = vector3(-2055.88232, -1027.13867, 3.16481071),
        url = '',
    },
    [4] = {
        coords = vector3(-2055.6582, -1026.44885, 3.16481071),
        url = '',
    },
    [5] = {
        coords = vector3(-2056.33032, -1028.51733, 2.66788249),
        url = '',
    },
    [6] = {
        coords = vector3(-2056.10645, -1027.82825, 2.66788249),
        url = '',
    },
    [7] = {
        coords = vector3(-2055.88232, -1027.13867, 2.66788249),
        url = '',
    },
    [8] = {
        coords = vector3(-2055.6582, -1026.44885, 2.66788249),
        url = '',
    },
}

Config.Items = {
    [1] = {
        model = 'prop_champ_01b',
        coords = vector4(-2093.58, -1015.22, 9.09, 63.29),
        item_name = 'expensive_champagne',
        item_label = 'Champagne',
        taken = false,
        networkID = 0,
    },
    [2] = {
        model = 'prop_champ_01b',
        coords = vector4(-2094.71, -1021.18, 8.85, 137.92),
        item_name = 'expensive_champagne',
        item_label = 'Champagne',
        taken = false,
        networkID = 0,
    },
    [3] = {
        model = 'prop_champ_01b',
        coords = vector4(-2097.4, -1017.0, 8.84, 97.6),
        item_name = 'expensive_champagne',
        item_label = 'Champagne',
        taken = false,
        networkID = 0,
    },
    [4] = {
        model = 'prop_champ_01b',
        coords = vector4(-2051.42, -1031.7, 8.90, 213.82),
        item_name = 'expensive_champagne',
        item_label = 'Champagne',
        taken = false,
        networkID = 0,
    },
    [5] = {
        model = 'p_watch_05',
        coords = vector4(-2070.54, -1021.0, 5.77, 161.66),
        item_name = 'rolex',
        item_label = 'Watch',
        taken = false,
        networkID = 0,
    },
    [6] = {
        model = 'p_watch_05',
        coords = vector4(-2050.21, -1032.42, 8.90, 140.04),
        item_name = 'rolex',
        item_label = 'Watch',
        taken = false,
        networkID = 0,
    },
    [7] = {
        model = 'prop_champ_01b',
        coords = vector4(-2085.0, -1021.99, 5.82, 165.17),
        item_name = 'expensive_champagne',
        item_label = 'Champagne',
        taken = false,
        networkID = 0,
    },
    [8] = {
        model = 'prop_ld_int_safe_01', -- The safe is slightly hardcoded
        coords = vector4(-2099.37, -1016.24, 4.8, 160.50),
        taken = false,
        networkID = 0,
    },
}

Config.Cabins = {
    [1] = {
        coords = vector4(-2050.86, -1024.12, 8.8, 335.89),
        isSearched = false,
        isBusy = false,
        animDic = 'veh@break_in@0h@p_m_one@',
        animName = 'low_force_entry_ds',
        ['items'] = {
            [1] = {
                item_name = 'rolex',
                item_amount = 1,
            },
            [2] = {
                item_name = 'rolex',
                item_amount = 2,
            },
        }
    },
    [2] = {
        coords = vector4(-2076.09, -1018.72, 8.95, 252.62),
        isSearched = false,
        isBusy = false,
        animDic = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        animName = 'machinic_loop_mechandplayer',
        ['items'] = {
            [1] = {
                item_name = 'rolex',
                item_amount = 1,
            },
            [2] = {
                item_name = 'rolex',
                item_amount = 2,
            },
        }
    },
    [3] = {
        coords = vector4(-2089.83, -1009.79, 5.76, 70.23),
        isSearched = false,
        isBusy = false,
        animDic = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        animName = 'machinic_loop_mechandplayer',
        ['items'] = {
            [1] = {
                item_name = 'rolex',
                item_amount = 1,
            },
            [2] = {
                item_name = '10kgoldchain',
                item_amount = 2,
            },
        }
    },
    [4] = {
        coords = vector4(-2085.1, -1015.45, 9.07, 250.98),
        isSearched = false,
        isBusy = false,
        animDic = 'veh@break_in@0h@p_m_one@',
        animName = 'low_force_entry_ds',
        ['items'] = {
            [1] = {
                item_name = 'goldbar',
                item_amount = 1,
            },
            [2] = {
                item_name = '10kgoldchain',
                item_amount = 1,
            },
        }
    },
    [5] = {
        coords = vector4(-2071.62, -1024.08, 4.83, 254.6),
        isSearched = false,
        isBusy = false,
        animDic = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        animName = 'machinic_loop_mechandplayer',
        ['items'] = {
            [1] = {
                item_name = '10kgoldchain',
                item_amount = 2,
            },
            [2] = {
                item_name = 'tablet',
                item_amount = 1,
            },
        }
    },
}

Config.CashTrays = {
    [1] = {
        coords = vector4(-2099.54, -1020.7, 5.38, 162.57),
        isSearched = false,
        model = 'h4_prop_h4_cash_stack_01a',
        tabel_model = 'prop_office_desk_01',
        min = 5000,
        max = 10000,
    },
    [2] = {
        coords = vector4(-2087.76, -1024.76, 5.38, 161.87),
        isSearched = false,
        model = 'h4_prop_h4_cash_stack_01a',
        tabel_model = 'prop_office_desk_01',
        min = 5000,
        max = 10000,
    },
    [3] = {
        coords = vector4(-2092.7, -1008.2, 4.88, 341.87),
        isSearched = false,
        model = 'h4_prop_h4_cash_stack_01a',
        tabel_model = 'prop_office_desk_01',
        min = 5000,
        max = 10000,
    },
}

Config.Screens = {
    [1] = {
        url = 'https://i.ibb.co/cDYQzYY/r.jpg', -- R
    },
    [2] = {
        url = 'https://i.ibb.co/fD3zKqm/L.jpg', -- l
    },
    [3] = {
        url = 'https://i.ibb.co/Hzy1sbT/G.jpg', -- G
    },
    [4] = {
        url = 'https://i.ibb.co/7ndTSHc/D.jpg', -- D
    },
    [5] = {
        url = 'https://i.ibb.co/C9vcXHh/U.jpg', -- U
    },
    [6] = {
        url = 'https://i.ibb.co/BjbcY7L/E.jpg', -- E
    },
    [7] = {
        url = 'https://i.ibb.co/yk6mSJ0/O.jpg', -- O
    },
    [8] = {
        url = 'https://i.ibb.co/1rFHjrr/N.jpg', -- N
    },
    [9] = {
        url = 'https://i.ibb.co/pKxY1xy/P.jpg', -- P
    },
    [10] = {
        url = 'https://i.ibb.co/ZhX47Cr/F.jpg', -- F
    },
    [11] = {
        url = 'https://i.ibb.co/ZmRfrMr/W.jpg', -- W
    },
    [12] = {
        url = 'https://i.ibb.co/HYMwcpv/M.jpg', -- M
    },
    [13] = {
        url = 'https://i.ibb.co/0qT9HBT/I.jpg', -- I
    },
    [14] = {
        url = 'https://i.ibb.co/XSmKgLJ/A.jpg', -- A
    },
    ------------ non english characters --------------
    [15] = {
        url = 'https://i.ibb.co/tprpfZj/screen1.jpg',
    },
    [16] = {
        url = 'https://i.ibb.co/GHm0wmn/screen2.jpg',
    },
    [17] = {
        url = 'https://i.ibb.co/2NXP5wg/screen4.jpg',
    },
    [18] = {
        url = 'https://i.ibb.co/8sn6RLS/symbol-2.jpg',
    },
    [19] = {
        url = 'https://i.ibb.co/WBNg9tm/symbol-5.jpg',
    },
    [20] = {
        url = 'https://i.ibb.co/GszgZrV/symbol-6.jpg',
    },
    [21] = {
        url = 'https://i.ibb.co/xJ1x10r/symbol-7.jpg',
    },
    [22] = {
        url = 'https://i.ibb.co/QdJ6ygW/symbol-8.jpg',
    },
    [23] = {
        url = 'https://i.ibb.co/mGGCbNq/symbol-9.jpg',
    },
    [24] = {
        url = 'https://i.ibb.co/bsQxWBM/symbol-10.jpg',
    },
    [25] = {
        url = 'https://i.ibb.co/GHm0wmn/screen2.jpg',
    },
    [26] = {
        url = 'https://i.ibb.co/pdPWQns/symbol-12.jpg',
    },
    [27] = {
        url = 'https://i.ibb.co/hWgnv3J/symbol-13.jpg',
    },
    [28] = {
        url = 'https://i.ibb.co/4T5TD3p/symbol-14.jpg',
    },
    [29] = {
        url = 'https://i.ibb.co/zsRHDwd/symbol1-9.jpg',
    },
    [30] = {
        url = 'https://i.ibb.co/WDjZ44P/symbol5.jpg',
    },
}