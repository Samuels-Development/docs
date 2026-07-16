return {
    Locale = 'en', -- Locale used to load `locales/<Locale>.json`. Falls back to `en` if missing.
    ShopLogging = true, -- Enable/Disable logging for shop/ped actions.
    IconColors = false, -- Enable/Disable icon colors in the menus.
    ShowRequiredItemsInNotify = true, -- When a robbery fails because you lack the tool, name the required item(s) in the notification (e.g. "(Requires: Lockpick)"). Most useful with a crime's ShowTargetWithoutItem enabled.
    AllowCancel = true, -- Whether players can cancel a crime's progress bar (press X). true = cancellable (good if cops show up); false = locked in until it finishes.

    -- ============================================================================
    -- Debug logging. Master switch for the resource's tagged diagnostic prints
    -- (tag format: [sd-pettycrime:<category>]). OFF by default — flip to true to
    -- trace what the resource is doing in the client (F8) and server consoles.
    --
    -- DebugCategories optionally narrows the firehose once DebugPrints is true:
    --   {}                -> every category prints
    --   { fuel = true }   -> ONLY fuelsabotage (any `true` => allowlist mode)
    --   { fuel = false }  -> everything EXCEPT fuelsabotage (only `false`s => denylist)
    -- Categories are the crime names (mailbox, payphone, ... speedbomb), the
    -- bridge modules (bridge:inventory, bridge:fuel, bridge:money, ...), and the
    -- core systems (shop, rewards, stats, cooldown, tools, menus, ped, ...).
    -- ============================================================================
    DebugPrints = false,
    DebugCategories = {},

    -- ============================================================================
    -- Tool wear. The tool a player used to commit a crime loses durability and
    -- eventually breaks. Durability is the primary system; an optional flat
    -- break-chance can also be turned on. Per-crime amounts live in each crime
    -- config as `ToolDrain` (durability lost per success) and `ToolBreakChance`
    -- (% chance to break per success); cardoor can override both per door. Works
    -- on ox / qb / qs / origen / codem / tgiann / jaksam — on inventories without
    -- per-slot metadata, durability is skipped automatically but break-chance
    -- still works.
    -- ============================================================================
    ToolWear = {
        Durability = {
            Enable = true,          -- Master switch: drain the used tool's durability on a successful crime.
            Max = 100,              -- Durability a fresh tool (no durability metadata yet) is treated as starting at.
            NotifyOnLow = true,     -- Warn the player when a tool's durability drops to/below LowThreshold.
            LowThreshold = 20,      -- The "getting low" warning fires at or below this durability value.
            IncludeWeapons = true, -- Also wear/break WEAPON_* tools (e.g. WEAPON_HATCHET). false = leave weapons untouched.
        },
        BreakChance = {
            Enable = false,         -- Master switch: flat % chance (per crime's ToolBreakChance) to instantly break the used tool on success. Independent of durability.
        },
    },

    -- ============================================================================
    -- Personal anti-spam cooldowns. A PER-PLAYER cooldown (on top of each crime's
    -- per-target cooldown) so one player can't rattle off the same crime over and
    -- over, whatever target they pick. Keyed by player identifier, so reconnecting
    -- doesn't reset it (it clears on resource restart). Time is in SECONDS; if a
    -- player tries again too soon they're told how long is left (minutes, or
    -- seconds when under a minute). Enabled on the destructive / dangerous crimes
    -- by default and wired-but-off on the pettier ones -- flip Enable per crime.
    -- (atmskimmer is intentionally not listed: no personal cooldown.)
    -- ============================================================================
    PersonalCooldowns = {
        -- Destructive / dangerous -- ON by default.
        catalytic    = { Enable = true,  Time = 180 }, -- 3 min
        tiretheft    = { Enable = true,  Time = 180 },
        wheelloose   = { Enable = true,  Time = 180 },
        brakecut     = { Enable = true,  Time = 240 }, -- 4 min
        fuelsabotage = { Enable = true,  Time = 180 },
        brickgas     = { Enable = true,  Time = 240 },
        speedbomb    = { Enable = true,  Time = 300 }, -- 5 min

        -- Pettier crimes -- wired but OFF by default (set Enable = true to use).
        acstrip      = { Enable = false, Time = 180 },
        cardoor      = { Enable = false, Time = 180 },
        tireslash    = { Enable = false, Time = 120 },
        shoplift     = { Enable = false, Time = 120 },
        mailbox      = { Enable = false, Time = 120 },
        parkingmeter = { Enable = false, Time = 120 },
        payphone     = { Enable = false, Time = 120 },
        newsrack     = { Enable = false, Time = 120 },
        vending      = { Enable = false, Time = 120 },
        parceltheft  = { Enable = false, Time = 120 },
        smashgrab    = { Enable = false, Time = 180 },
        signrob      = { Enable = false, Time = 120 },

        -- robaped / pickpocket: migrated here from their own configs. Left OFF by
        -- default, matching their previous defaults.
        robaped      = { Enable = false, Time = 30 },
        pickpocket   = { Enable = false, Time = 30 },
    },

    Ped = {
        Location = {
            {x = 366.44, y = -1250.83, z = 31.51, w = 321.98},
            -- Add more locations as needed (Will Randomize from available locations each script start)
        },
        Model = "a_m_m_mlcrisis_01",
        Interaction = {
            Icon = "fas fa-circle",
            Distance = 3.0,
        },
        Scenario = "WORLD_HUMAN_STAND_IMPATIENT" -- Full list of scenarios @ https://pastebin.com/6mrYTdQv
    },
    Shop = {
        Enable = { Buying = true, Selling = true },
        BuyItems = {
            {
                Product = "lockpick", -- internal identifier for the item (item name)
                Price = 50, -- how much the player pays per unit
                Label = "Lockpick", -- direct string for title
                Description = "Essential tool for breaking into mailboxes and other locked containers", -- direct string for description
                IconName = "fas fa-key", -- FontAwesome icon
                IconColor = "#FFD700" -- Gold color for lockpick, if you don't have IconColor specified, no color will be applied.
            },
            {
                Product = "screwdriver",
                Price = 75,
                Label = "Screwdriver",
                Description = "Useful for tampering with parking meters and payphones",
                IconName = "fas fa-screwdriver",
                IconColor = "#C0C0C0"
            },
            {
                Product = "crowbar",
                Price = 150,
                Label = "Crowbar",
                Description = "Heavy-duty tool for more serious criminal activities",
                IconName = "fas fa-hammer",
                IconColor = "#e56969" 
            },
            {
                Product = "gloves",
                Price = 25,
                Label = "Gloves",
                Description = "Reduce the chance of leaving fingerprints behind",
                IconName = "fas fa-hand-paper",
                IconColor = "#26bbc5"
            },
            {
                Product = "multitool",
                Price = 120,
                Label = "Multitool",
                Description = "Pry open parking meters, payphones, newsracks and street signs",
                IconName = "fas fa-toolbox",
                IconColor = "#9E9E9E"
            },
            {
                Product = "anglegrinder",
                Price = 250,
                Label = "Angle Grinder",
                Description = "Cuts catalytic converters and AC units off in seconds",
                IconName = "fas fa-circle-notch",
                IconColor = "#FF5722"
            },
            {
                Product = "powersaw",
                Price = 300,
                Label = "Power Saw",
                Description = "Heavy cutting tool for catalytic converters and AC units",
                IconName = "fas fa-gears",
                IconColor = "#607D8B"
            },
            {
                Product = "oxycutter",
                Price = 350,
                Label = "Oxy Cutter",
                Description = "Oxy-acetylene torch that slices through catalytic converters and AC units in seconds",
                IconName = "fas fa-fire",
                IconColor = "#FF5722"
            },
            {
                Product = "bolt_cutter",
                Price = 180,
                Label = "Bolt Cutters",
                Description = "Snap locks and metal on AC units and converters",
                IconName = "fas fa-scissors",
                IconColor = "#90A4AE"
            },
            {
                Product = "cutter",
                Price = 90,
                Label = "Cutting Tool",
                Description = "Slash tyres, snip brake lines and puncture fuel tanks",
                IconName = "fas fa-scissors",
                IconColor = "#B0BEC5"
            },
            {
                Product = "wirecutter",
                Price = 90,
                Label = "Wire Cutters",
                Description = "Snip brake lines cleanly",
                IconName = "fas fa-scissors",
                IconColor = "#B0BEC5"
            },
            {
                Product = "skimmer",
                Price = 400,
                Label = "Card Skimmer",
                Description = "Install on ATMs to harvest card data over time",
                IconName = "fas fa-credit-card",
                IconColor = "#4CAF50"
            },
            {
                Product = "atm_skimmer_usb",
                Price = 60,
                Label = "USB Stick",
                Description = "Slot it into an installed skimmer to record stolen card data",
                IconName = "fas fa-sd-card",
                IconColor = "#9E9E9E"
            },
            {
                Product = "brick",
                Price = 15,
                Label = "Brick",
                Description = "Wedge it on a gas pedal to send a parked car running",
                IconName = "fas fa-cube",
                IconColor = "#8D6E63"
            },
            {
                Product = "speed_bomb",
                Price = 25000,
                Label = "Speedbomb",
                Description = "Black-market car bomb — wire it under a parked vehicle. Arms when driven fast and blows if they slow down",
                IconName = "fas fa-bomb",
                IconColor = "#f44336"
            }
        },
        SellItems = {
            {
                Product = "jewelry",
                Price = 200,
                Label = "Stolen Jewelry",
                Description = "Valuable jewelry obtained from pickpocketing",
                IconName = "fas fa-gem",
                IconColor = "#9C27B0"
            },
            {
                Product = "electronics",
                Price = 150,
                Label = "Electronics",
                Description = "Electronic devices stolen from various sources",
                IconName = "fas fa-mobile-alt",
                IconColor = "#2196F3"
            },
            -- Reward valuables dropped by the various crimes (pickpocket, robaped,
            -- smashgrab, mailbox, catalytic, packages, etc.). Raw crafting scrap
            -- (copper/iron/steel/...) and food drops are intentionally left out —
            -- those route through other economy systems.
            {
                Product = "phone",
                Price = 120,
                Label = "Stolen Phone",
                Description = "A lifted smartphone, wiped and ready to move",
                IconName = "fas fa-mobile-screen",
                IconColor = "#2196F3"
            },
            {
                Product = "laptop",
                Price = 250,
                Label = "Stolen Laptop",
                Description = "A pinched laptop worth a fair bit to the right buyer",
                IconName = "fas fa-laptop",
                IconColor = "#3F51B5"
            },
            {
                Product = "goldchain",
                Price = 180,
                Label = "Gold Chain",
                Description = "A flashy gold chain",
                IconName = "fas fa-link",
                IconColor = "#FFD700"
            },
            {
                Product = "10kgoldchain",
                Price = 450,
                Label = "10k Gold Chain",
                Description = "A heavy 10-karat gold chain",
                IconName = "fas fa-link",
                IconColor = "#FFC107"
            },
            {
                Product = "gold_watch",
                Price = 220,
                Label = "Gold Watch",
                Description = "A stolen gold timepiece",
                IconName = "fas fa-clock",
                IconColor = "#FFD700"
            },
            {
                Product = "rolex",
                Price = 400,
                Label = "Rolex",
                Description = "A luxury watch that fences love",
                IconName = "fas fa-clock",
                IconColor = "#FFD700"
            },
            {
                Product = "goldbar",
                Price = 800,
                Label = "Gold Bar",
                Description = "A solid bar of gold — the big score",
                IconName = "fas fa-bars",
                IconColor = "#FFD700"
            },
            {
                Product = "diamond",
                Price = 600,
                Label = "Diamond",
                Description = "A loose cut diamond",
                IconName = "fas fa-gem",
                IconColor = "#00BCD4"
            },
            {
                Product = "diamond_ring",
                Price = 500,
                Label = "Diamond Ring",
                Description = "A stolen diamond ring",
                IconName = "fas fa-ring",
                IconColor = "#9C27B0"
            },
            {
                Product = "purse",
                Price = 90,
                Label = "Stolen Purse",
                Description = "A snatched purse and whatever's inside",
                IconName = "fas fa-bag-shopping",
                IconColor = "#E91E63"
            },
            {
                Product = "gang-keychain",
                Price = 40,
                Label = "Gang Keychain",
                Description = "A novelty keychain lifted off a mark",
                IconName = "fas fa-key",
                IconColor = "#795548"
            },
            {
                Product = "catalytic_converter",
                Price = 350,
                Label = "Catalytic Converter",
                Description = "A sawn-off converter packed with precious metals",
                IconName = "fas fa-car",
                IconColor = "#607D8B"
            },
            {
                Product = "oxygen_sensor",
                Price = 150,
                Label = "Oxygen Sensor",
                Description = "A salvaged O2 sensor",
                IconName = "fas fa-gauge",
                IconColor = "#607D8B"
            },
            {
                Product = "thermite",
                Price = 300,
                Label = "Thermite",
                Description = "Volatile contraband the fence will quietly take off your hands",
                IconName = "fas fa-fire",
                IconColor = "#FF5722"
            }
        },

        -- Special-cased sellable: loaded `usb` sticks are priced from the total
        -- `worth` stamped into each stick's metadata by the ATM skimmer (sum of
        -- every card it scanned), not a flat unit price. Only USBs that actually
        -- hold card data appear here; blank USBs stay a buyable tool. Each loaded
        -- stick renders/sells as one unit and pays out its stored worth.
        CardData = {
            Enable         = true,
            Item           = 'atm_skimmer_usb',
            Label          = 'Card Data USB',
            Description    = "Loaded skimmer USBs — the fence pays for the card data stored on them",
            IconName       = 'fas fa-sd-card',
            IconColor      = '#4caf50',
            SellMultiplier = 1.0, -- Fraction of stored worth the fence pays (0.8 = 80%).
            FallbackWorth  = 80,  -- $ for a loaded USB with no `worth` metadata (e.g. admin-spawned).

            -- How a sale consumes the stick:
            --   'usb'  → the whole USB is taken by the fence (player loses the stick).
            --   'data' → only the card data is sold; the now-blank USB is handed back for reuse.
            SellMode       = 'data',

            -- Sell-row title + description shown at the ped, picked by SellMode so
            -- the copy matches what actually happens to the stick.
            Modes = {
                usb  = {
                    Label       = 'Card Data USB',
                    Description  = 'Loaded skimmer USBs — the fence pays for the USB with the card data stored on them',
                },
                data = {
                    Label       = 'Card Data on USB',
                    Description  = 'The fence pays for the card data stored on them, and hands the blank USB back',
                },
            },
        }
    },
    Stats = {
        Enable = true,
    },

    Levels = {
        mailbox = {
            [1] = {
                -- Starting level - no XP threshold required
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 150,
            },
            [3] = {
                xpRequired = 300,
            }
        },
        payphone = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 120,
            },
            [3] = {
                xpRequired = 250,
            }
        },
        parkingmeter = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 180,
            },
            [3] = {
                xpRequired = 350,
            }
        },
        pickpocket = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 100,
            },
            [3] = {
                xpRequired = 200,
            }
        },
        robaped = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 200,
            },
            [3] = {
                xpRequired = 400,
            }
        },
        shoplift = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 80,
            },
            [3] = {
                xpRequired = 160,
            }
        },
        parceltheft = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 175,
            },
            [3] = {
                xpRequired = 380,
            }
        },
        vending = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 100,
            },
            [3] = {
                xpRequired = 220,
            }
        },
        catalytic = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 250,
            },
            [3] = {
                xpRequired = 550,
            }
        },
        smashgrab = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 200,
            },
            [3] = {
                xpRequired = 450,
            }
        },
        tiretheft = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 280,
            },
            [3] = {
                xpRequired = 600,
            }
        },
        acstrip = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 220,
            },
            [3] = {
                xpRequired = 480,
            }
        },
        newsrack = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 90,
            },
            [3] = {
                xpRequired = 220,
            }
        },
        atmskimmer = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 200,
            },
            [3] = {
                xpRequired = 460,
            }
        },
        tireslash = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 150,
            },
            [3] = {
                xpRequired = 320,
            }
        },
        brakecut = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 240,
            },
            [3] = {
                xpRequired = 520,
            }
        },
        wheelloose = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 200,
            },
            [3] = {
                xpRequired = 440,
            }
        },
        fuelsabotage = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 230,
            },
            [3] = {
                xpRequired = 500,
            }
        },
        signrob = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 100,
            },
            [3] = {
                xpRequired = 220,
            }
        },
        brickgas = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 200,
            },
            [3] = {
                xpRequired = 450,
            }
        },
        cardoor = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 180,
            },
            [3] = {
                xpRequired = 400,
            }
        },
        speedbomb = {
            [1] = {
                xpRequired = 0,
            },
            [2] = {
                xpRequired = 250,
            },
            [3] = {
                xpRequired = 550,
            }
        }
    }
}
