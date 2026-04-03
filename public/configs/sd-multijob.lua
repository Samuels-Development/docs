Config = {}

Locale.LoadLocale('en') -- Load the locale language, if available. You can change 'en' to any other available language in the locales folder.

Config.Debug = false -- true/false the debug for polyzones (in regards to the duty zones)

Config.UseCustomUI = true -- true/false to use a custom NUI (web/dist/) for the multijob selector instead of ox_lib context menus

Config.UseNoiseEffect = true -- true/false to use a noise/grain effect overlay on the custom NUI panel (only applies when Config.UseCustomUI is true)

-- How long (in seconds) bonus and message notifications persist before expiring.
Config.NotificationDuration = 259200 -- 72h (in seconds)

-- You can disable the multijob system and only have a boss menu if you wish. It's heavily recommended to keep this as true.
-- If false, messages and bonuses will be disabled.
Config.Multijob = {
    enable = true, -- true/false
    jobsLimit = { enable = true, amount = 5, notify = true } -- if enabled, limits the amount of jobs that player can have in their multijob. If disabled, infinite. notify true = send player notification if they get a new job but they've already reached max.
}

-- Enable or disable the messages menu (if false, you can't send messages to bosses and bosses can't send messages to you)
Config.EnableMessages = {
    enable = true, -- true/false the messaing system as a whole
    enableMessagesToBoss = true, -- true/false the ability for employees to send the bosses messages.
    enableMessagesToEmployees = true, -- true/false the ability for bosses to send messages to employees.
}

-- Enable or disable the bonus system (bosses can give in-game currency bonuses to employees)
Config.EnableBonuses = true -- true/false the ability for bosses to send bonuses to employees

-- Auto-assign job on hire; if false, only saves to savedJobs (so the player will have the job they were hired for available in their multijob menu)
-- if true, saves to savedJobs as well as sets the current job of the player directly (e.g. when they do /job they'll be that job immediately)
Config.SetJobOnHire = false -- true/false 

-- Setup a command and optionally a keybind to open the multijob menu. If Config.EnableMultijob is false, then you can ignore this.
Config.Command = {
    -- the chat command to open your jobs menu
    name       = 'multijob',  

    -- whether to also register a key-mapping for it
    keybind    = {
        enabled = true,      -- set false to disable keybind entirely
        key     = 'F5'       -- any valid FiveM key string: 'F2', 'F5', 'INSERT', etc.
    }
}

-- Icons for the target options to toggle duty and open the boss menu.
Config.TargetIcons = {
    duty = 'fa-solid fa-briefcase',
    boss = 'fa-solid fa-users-gear'
}

Config.UseSociety = {
    -- Use built-in society accounting (via this resource’s exports and the boss-menu UI). Doesn't link to anything external, all handled in-resource.
    -- When useCustomLogic = true, bypass built-in handling in favor of your own logic (e.g., Renewed-Banking, fd_banking etc.).
    -- Note: To have external transactions appear in the boss menu’s transaction log, implement the transactionLog export to other resources (see docs).

    -- If you don't want the society to be handled AT ALL through my resource, then simply setting enable to false will suffice.
    -- Do note, that disabling society entirely will result in stuff such as the bonuses and weekly goal bonuses not working.
    enable = true,  -- when true: shows society accounting in boss menu; when false: disables it entirely
    useCustomLogic = false, -- when true: calls your custom deposit/withdraw/getBalance below; when false: uses internal methods

    -- === CUSTOM BALANCE FUNCTIONS BELOW ===
    -- if useCustomLogic is true, you can implement your own deposit/withdraw/getBalance functions here.

    --- Deposit into a society account using Renewed-Banking.
    --- @param source     number  The boss’s server ID performing the deposit.
    --- @param jobName    string  The society/job key (e.g. "police").
    --- @param amount     number  Amount to deposit (must be > 0).
    --- @param moneyType  string  "cash" or "bank".  (not used here, since Renewed-Banking tracks bank accounts)
    --- @return number|false      New balance on success, or false on error.
    deposit = function(source, jobName, amount, moneyType)
        -- Renewed Banking Integration (if you're using Renewed, you can just uncomment the code block below, if you're not, then you can add your own logic here)
        --[[
        if type(amount) ~= "number" or amount <= 0 then
            return false
        end

        -- Add `amount` to the society’s Renewed-Banking account
        local ok = exports['Renewed-Banking']:addAccountMoney(jobName, amount)
        if not ok then
            return false
        end

        -- Fetch and return the updated balance
        local newBalance = exports['Renewed-Banking']:getAccountMoney(jobName)
        return newBalance or false
        ]]
        return false -- Just to clarify, a function can only have one return statement. So if you uncomment renewed-banking above, remove this return.
    end,

    --- Withdraw from a society account using Renewed-Banking.
    --- @param source     number  The boss’s server ID performing the withdrawal.
    --- @param jobName    string  The society/job key (e.g. "police").
    --- @param amount     number  Amount to withdraw (must be > 0).
    --- @param moneyType  string  "cash" or "bank".  (not used here)
    --- @return number|false      New balance on success, or false on error.
    withdraw = function(source, jobName, amount, moneyType)
        -- Renewed Banking Integration (if you're using Renewed, you can just uncomment the code block below, if you're not, then you can add your own logic here)
        --[[
        if type(amount) ~= "number" or amount <= 0 then
            return false
        end

        -- Remove `amount` from the society’s Renewed-Banking account
        local ok = exports['Renewed-Banking']:removeAccountMoney(jobName, amount)
        if not ok then
            return false
        end

        -- Fetch and return the updated balance
        local newBalance = exports['Renewed-Banking']:getAccountMoney(jobName)
        return newBalance or false
        ]] 
        return false -- Just to clarify, a function can only have one return statement. So if you uncomment renewed-banking above, remove this return.
    end,

    --- Get the current society balance via Renewed-Banking.
    --- @param source  number  The boss’s server ID requesting balance.
    --- @param jobName string  The society/job key (e.g. "police").
    --- @return number|false    Current balance, or false if error.
    getBalance = function(source, jobName)
        -- Renewed Banking Integration (if you're using Renewed, you can just uncomment the code block below, if you're not, then you can add your own logic here)
        --[[
        return exports['Renewed-Banking']:getAccountMoney(jobName)
        ]]
        return false -- Just to clarify, a function can only have one return statement. So if you uncomment renewed-banking above, remove this return.
    end,
}

-- Application input settings (for job application forms)
Config.ApplicationInput = {
    minLength = 1,    -- Minimum character length for application answers
    maxLength = 500,  -- Maximum character length for application answers
}

-- Definition of each available job: its map icon, pay scales by grade, and human-readable grade labels.
-- So on qb-core for example, you'd effectively copy/mimic the entries from the shared/jobs.lua file here.
-- You don't have to add all your jobs here, just the ones you want people to be able to have in their multijob.
Config.Jobs = {
    police = {
        label = 'Police', -- Label that'll appear in the multijob for this job. 
        icon = "shield",  -- FontAwesome icon for menus/maps
        bossGrades  = { 4 }, -- grade 4 (“Chief”) is boss (you can add more)
        salaries = { -- Salary payout per payday, indexed by job grade (THERE IS NO PAYOUT SYSTEM, ITS ONLY FOR DISPLAY IN THE MENU.)
            [0] = 50,
            [1] = 75,
            [2] = 100,
            [3] = 125,
            [4] = 150,
        },
        gradeLabels = { -- Display names for display in the menu.
            [0] = 'Recruit',
            [1] = 'Officer',
            [2] = 'Sergeant',
            [3] = 'Lieutenant',
            [4] = 'Chief',
        },
        -- for ox_inventory users only
        stash = {
            enabled = true, -- Enable/disable stash functionality for this job
            slots = 50,     -- Number of inventory slots
            weight = 100000 -- Maximum weight capacity (in grams)
        }
    },
    -- Example for other job entries
    
    ambulance = {
        label = 'Ambulance',
        icon = "ambulance",
        bossGrades  = { 4 },
        salaries = {
            [0] = 50,
            [1] = 75,
            [2] = 100,
            [3] = 125,
            [4] = 150,
        },
        gradeLabels = {
            [0] = 'Recruit',
            [1] = 'Paramedic',
            [2] = 'Doctor',
            [3] = 'Surgeon',
            [4] = 'Chief',
        },
        -- for ox_inventory users only
        stash = {
            enabled = true, -- Enable/disable stash functionality for this job
            slots = 40,     -- Number of inventory slots
            weight = 80000  -- Maximum weight capacity (in grams)
        }
    },
    -- You can add more...
}

-- Locations and everything else related to every job.
Config.Zones = {
    police = {
        duty = {
            enabled = true,
            interactionType = "marker", -- how the player toggles duty: "target", "textui", or "marker"
            locations = { -- Now supports multiple locations
                {
                    coords   = vec3(440.48, -976.02, 29.69),
                    distance = 3.0,
                    marker = { -- if target or textui this table is ignored
                        type    = 1,
                        red     = 0,
                        green   = 155,
                        blue    = 255,
                        opacity = 150,
                    },
                },
                -- You can add as many locations as you like!
                --[[
                {
                    coords   = vec3(450.0, -980.0, 30.0),
                    distance = 2.5,
                    marker = {
                        type    = 1,
                        red     = 0,
                        green   = 155,
                        blue    = 255,
                        opacity = 150,
                    },
                },
                ]]
            },
        },
        dutyZone = { -- Essentially, if enabled, you HAVE to be in the zone to be on duty. You can't go on-duty outside and if you're on duty and leave you'll be forced off.
            enabled = false,     -- whether to auto–offduty when leaving this zone
            bossImmune  = false, -- if true, bosses stay on duty when they leave
            timeout = {
                enabled = true,  -- if true, delayed offduty; if false, immediate offduty
                seconds = 30,    -- delay in seconds
            },
            zones = {
                {
                    points = {
                        vec3(416.3, -961.91, 25.0),
                        vec3(498.26, -962.05, 25.0),
                        vec3(494.67, -1042.9, 25.0),
                        vec3(403.34, -1046.47, 25.0),
                    },
                    thickness = 100.0,  -- draw thickness / detection width
                },
                -- You can add as many polys as you like!
                --[[
                {
                    points = {
                        vec3(408.81, -1614.82, 32.73),
                        vec3(360.49, -1574.25, 31.33),
                        vec3(337.84, -1602.52, 31.39),
                        vec3(387.28, -1641.61, 32.17),
                    },
                    thickness = 50.0,
                }, ]]
            }, 
        },
        bossMenu = {
            enabled         = true,
            interactionType = "target",  -- "marker", "target", or "textui"
            locations = { -- Now supports multiple locations
                {
                    coords   = vec3(448.21, -973.12, 29.69),
                    distance = 2.5,
                    marker = { -- ignored for target/textui
                        type    = 1,
                        red     = 255,
                        green   = 200,
                        blue    = 0,
                        opacity = 150,
                    },
                },
                -- You can add as many locations as you like!
                --[[
                {
                    coords   = vec3(460.0, -970.0, 30.0),
                    distance = 2.0,
                    marker = {
                        type    = 1,
                        red     = 255,
                        green   = 200,
                        blue    = 0,
                        opacity = 150,
                    },
                },
                ]]
            },
        },
    },
    -- Example for other more entries
    --[[ambulance = {
        duty = {
            enabled = true,
            interactionType = "target",
            locations = {
                {
                    coords   = vec3(440.0, -980.0, 30.0),
                    distance = 2.0,
                    marker = { -- ignored by textui/target
                        type    = 1,
                        red     = 0,
                        green   = 155,
                        blue    = 255,
                        opacity = 150,
                    },
                },
                --[[
                {
                    coords   = vec3(350.0, -590.0, 43.0),
                    distance = 2.5,
                    marker = {
                        type    = 1,
                        red     = 0,
                        green   = 155,
                        blue    = 255,
                        opacity = 150,
                    },
                }
            },
        },
        dutyZone = {
            enabled = false,     -- whether to auto–offduty when leaving this zone
            bossImmune  = false, -- if true, bosses stay on duty when they leave
            timeout = {
                enabled = true,  -- if true, use delayed offduty; if false, offduty immediately
                seconds = 30,    -- how many seconds outside before auto-offduty
            },
            zones = {
                {
                    points = {
                        vec3(275.38, -597.4, 45.0),
                        vec3(290.57, -544.91, 45.0),
                        vec3(344.73, -562.78, 45.0),
                        vec3(355.75, -640.78, 45.0),
                    },
                    thickness = 1.0,
                },
                {
                    points = {
                        vec3(200.0, -500.0, 45.0),
                        vec3(250.0, -500.0, 45.0),
                        vec3(250.0, -550.0, 45.0),
                        vec3(200.0, -550.0, 45.0),
                    },
                    thickness = 2.0,
                },
            },
        },
        bossMenu = {
            enabled         = true,
            interactionType = "marker",  -- "marker", "target", or "textui"
            locations = {
                {
                    coords   = vec3(309.99, -598.67, 42.29),
                    distance = 2.5,
                    marker = { -- ignored for target/textui
                        type    = 1,
                        red     = 255,
                        green   = 200,
                        blue    = 0,
                        opacity = 150,
                    },
                },
                {
                    coords   = vec3(320.0, -580.0, 43.0),
                    distance = 2.0,
                    marker = {
                        type    = 1,
                        red     = 255,
                        green   = 200,
                        blue    = 0,
                        opacity = 150,
                    },
                },
            },
        }, 
    }, ]]
    -- You can add more...
}

-- Which statistics to display per job in the “View Stats” menu, and how to format each entry.
-- You can increment the stats via the updateStats export. exports['sd-multijob']:updateStats(src, jobName, statKey, increment)
-- So as an example, to increment the police arrests stat by 1 for source 1, you would call: exports['sd-multijob']:updateStats(1, 'police', 'arrests', 1)
Config.Stats = {
    enable = true, -- enable/disable stat functionality
    police = { -- job key 
        {
            key         = "minutesWorked",      -- Internal stat name (minutesWorked works for ALL jobs as a stat by default)
            title       = "Time on Duty",       -- Menu title
            icon        = "clock",              -- Icon for this stat
            -- no description here; uses FormatMinutesWorked
        },
        {
            key         = "arrests", -- Internal stat name
            title       = "Arrests Made", -- Menu title
            description = "You made {amount} arrests.",  -- {amount} interpolates the value
            icon        = "handcuffs" -- Icon for this stat
        },
        {
            key         = "ticketsIssued",
            title       = "Tickets Issued",
            description = "You issued {amount} tickets.",
            icon        = "ticket"
        },
        {
            key         = "vehiclesImpounded",
            title       = "Vehicles Impounded",
            description = "You impounded {amount} vehicles.",
            icon        = "car"
        },
        {
            key         = "callsResponded",
            title       = "Calls Responded",
            description = "You responded to {amount} calls.",
            icon        = "phone"
        },
        {
            key         = "bonuses",
            title       = "Bonuses Received",
            description = "You received ${amount} in bonuses.",
            icon        = "gift"
        }
    },
    ambulance = {
        {
            key   = "minutesWorked",
            title = "Time on Duty",
            icon  = "clock"
        },
        {
            key         = "patientsSaved",
            title       = "Patients Saved",
            description = "You saved {amount} lives.",
            icon        = "heart-pulse"
        },
        {
            key         = "revives",
            title       = "Revives Performed",
            description = "You revived {amount} players.",
            icon        = "heart"
        },
        {
            key         = "transportsCompleted",
            title       = "Transports Completed",
            description = "You transported {amount} patients.",
            icon        = "car-side"
        },
        {
            key         = "suppliesUsed",
            title       = "Supplies Used",
            description = "You used {amount} medical supplies.",
            icon        = "box-medical"
        },
        {
            key         = "bonuses",
            title       = "Bonuses Received",
            description = "You received ${amount} in bonuses.",
            icon        = "gift"
        }
    },
    -- You can add more...
}

-- Leaderboard scoring weights: how much each stat contributes to overall rank.
Config.Leaderboard = {
    enable = true, -- enable/disable leaderboard functionality
    police = {
        timeWeight  = 1, -- Points per minute on duty
        statWeights = {
            arrests             = 60,  -- Points per arrest
            ticketsIssued       = 10,  -- Points per ticket issued
            vehiclesImpounded   = 30,  -- Points per vehicle impounded
            callsResponded      = 15,  -- Points per call responded
            bonuses             = 1    -- Points per dollar in bonuses
        },
    },

    -- Example detailed stat weights for the ambulance job
    ambulance = {
        timeWeight  = 1, -- Points per minute on duty
        statWeights = {
            patientsSaved         = 45, -- Points per patient saved
            revives               = 20, -- Points per revive performed
            transportsCompleted   = 15, -- Points per transport completed
            suppliesUsed          = 5,  -- Points per supply used
            bonuses               = 1   -- Points per dollar in bonuses
        },
    },
    -- You can add more...
}