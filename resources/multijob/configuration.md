# Configuration

All configuration is managed in two files: `config.lua` for general settings, jobs, zones, stats, and leaderboard options, and `server/logs.lua` for logging preferences. This page documents every available option with its default value.

## General Settings

```lua
Locale.LoadLocale('en')

Config.Debug = false
Config.UseCustomUI = true
Config.UseNoiseEffect = true
Config.NotificationDuration = 259200
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Locale.LoadLocale()` | `string` | `'en'` | Language locale to load. Must match a file in the `locales` folder (e.g. `'en'`, `'de'`, `'es'`, `'fr'`, `'ar'`). |
| `Config.Debug` | `boolean` | `false` | Enables PolyZone debug visualization for duty zones. Useful during zone setup. |
| `Config.UseCustomUI` | `boolean` | `true` | When `true`, uses the custom NUI panel (`web/dist/`) for the multijob selector. When `false`, falls back to ox_lib context menus. |
| `Config.UseNoiseEffect` | `boolean` | `true` | Adds a noise/grain effect overlay on the custom NUI panel. Only applies when `Config.UseCustomUI` is `true`. |
| `Config.NotificationDuration` | `number` | `259200` | How long (in seconds) bonus and message notifications persist before expiring. Default is 72 hours. |

## Multi-Job Settings

```lua
Config.Multijob = {
    enable = true,
    jobsLimit = {
        enable = true,
        amount = 5,
        notify = true,
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `enable` | `boolean` | `true` | Enables the multijob system. If `false`, the resource acts as a boss menu only. Messages and bonuses are also disabled. |
| `jobsLimit.enable` | `boolean` | `true` | When `true`, limits how many jobs a player can hold simultaneously. When `false`, unlimited. |
| `jobsLimit.amount` | `number` | `5` | Maximum number of jobs a player can have in their multijob roster. |
| `jobsLimit.notify` | `boolean` | `true` | When `true`, sends a notification to the player if they receive a new job but have already reached the limit. |

::: warning
Setting `Config.Multijob.enable` to `false` disables the entire multijob selector, messages, and bonuses. Only the boss menu functionality remains. It is heavily recommended to keep this as `true`.
:::

## Command & Keybind

```lua
Config.Command = {
    name = 'multijob',
    keybind = {
        enabled = true,
        key = 'F5',
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | `string` | `'multijob'` | The chat command used to open the job selector menu (e.g. `/multijob`). |
| `keybind.enabled` | `boolean` | `true` | Whether to register a FiveM key mapping for the command. Set `false` to disable. |
| `keybind.key` | `string` | `'F5'` | The default key mapping. Any valid FiveM key string works: `'F2'`, `'F5'`, `'INSERT'`, etc. |

::: tip
Players can rebind the key in their GTA V **Settings > Key Bindings > FiveM** menu after the mapping is registered.
:::

## Messages & Bonuses

```lua
Config.EnableMessages = {
    enable = true,
    enableMessagesToBoss = true,
    enableMessagesToEmployees = true,
}

Config.EnableBonuses = true
Config.SetJobOnHire = false
```

| Key | Type | Default | Description |
|---|---|---|---|
| `Config.EnableMessages.enable` | `boolean` | `true` | Enables or disables the messaging system as a whole. |
| `Config.EnableMessages.enableMessagesToBoss` | `boolean` | `true` | Allows employees to send messages to bosses. |
| `Config.EnableMessages.enableMessagesToEmployees` | `boolean` | `true` | Allows bosses to send messages to employees. |
| `Config.EnableBonuses` | `boolean` | `true` | Enables the bonus system, allowing bosses to give in-game currency bonuses to employees. |
| `Config.SetJobOnHire` | `boolean` | `false` | When `true`, hiring a player immediately sets their active job to the hired role. When `false`, the job is saved to their multijob roster only -- they must manually switch to it. |

## Target Icons

```lua
Config.TargetIcons = {
    duty = 'fa-solid fa-briefcase',
    boss = 'fa-solid fa-users-gear',
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `duty` | `string` | `'fa-solid fa-briefcase'` | FontAwesome icon class shown on the target option for toggling duty. |
| `boss` | `string` | `'fa-solid fa-users-gear'` | FontAwesome icon class shown on the target option for opening the boss menu. |

::: info
These icons are only visible when the interaction type for a zone is set to `"target"`.
:::

## Society Accounting

Controls how society (organization) funds are managed. You can use the built-in system, disable it entirely, or bridge to an external banking resource.

```lua
Config.UseSociety = {
    enable = true,
    useCustomLogic = false,

    deposit = function(source, jobName, amount, moneyType)
        return false
    end,

    withdraw = function(source, jobName, amount, moneyType)
        return false
    end,

    getBalance = function(source, jobName)
        return false
    end,
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `enable` | `boolean` | `true` | When `true`, society accounting is shown in the boss menu. When `false`, society features are disabled entirely (bonuses and weekly goal bonuses will not work). |
| `useCustomLogic` | `boolean` | `false` | When `true`, bypasses built-in society handling and calls the custom `deposit`, `withdraw`, and `getBalance` functions below. When `false`, all accounting is handled internally. |
| `deposit` | `function` | returns `false` | Custom function called when a boss deposits into the society account. Must return the new balance on success or `false` on error. |
| `withdraw` | `function` | returns `false` | Custom function called when a boss withdraws from the society account. Must return the new balance on success or `false` on error. |
| `getBalance` | `function` | returns `false` | Custom function called to retrieve the current society balance. Must return the balance or `false` on error. |

Each custom function receives these parameters:

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The boss's server ID performing the action. |
| `jobName` | `string` | The society/job key (e.g. `"police"`). |
| `amount` | `number` | The amount to deposit or withdraw (not used by `getBalance`). |
| `moneyType` | `string` | `"cash"` or `"bank"` (not used by `getBalance`). |

::: warning
Disabling society entirely (`enable = false`) means bonuses and weekly goal bonuses will not function, since there is no society balance to deduct from.
:::

### Renewed-Banking Integration Example

If you use [Renewed-Banking](https://github.com/Renewed-Scripts/Renewed-Banking), uncomment the provided template in each function. Below is the full working example:

```lua
Config.UseSociety = {
    enable = true,
    useCustomLogic = true, -- must be true to use custom functions

    deposit = function(source, jobName, amount, moneyType)
        if type(amount) ~= "number" or amount <= 0 then
            return false
        end

        local ok = exports['Renewed-Banking']:addAccountMoney(jobName, amount)
        if not ok then
            return false
        end

        local newBalance = exports['Renewed-Banking']:getAccountMoney(jobName)
        return newBalance or false
    end,

    withdraw = function(source, jobName, amount, moneyType)
        if type(amount) ~= "number" or amount <= 0 then
            return false
        end

        local ok = exports['Renewed-Banking']:removeAccountMoney(jobName, amount)
        if not ok then
            return false
        end

        local newBalance = exports['Renewed-Banking']:getAccountMoney(jobName)
        return newBalance or false
    end,

    getBalance = function(source, jobName)
        return exports['Renewed-Banking']:getAccountMoney(jobName)
    end,
}
```

::: tip
To have external transactions (from other resources) appear in the boss menu's transaction log, use the `logTransaction` export:
```lua
exports['sd-multijob']:logTransaction(src, action, amount, jobName)
```
:::

## Application Input

Controls validation for job application form answers.

```lua
Config.ApplicationInput = {
    minLength = 1,
    maxLength = 500,
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `minLength` | `number` | `1` | Minimum character length for each application answer. |
| `maxLength` | `number` | `500` | Maximum character length for each application answer. |

## Job Definitions

Each entry in `Config.Jobs` defines a job that can appear in the multijob roster. You do not need to add every job from your framework -- only those you want available in the multijob system.

```lua
Config.Jobs = {
    police = {
        label = 'Police',
        icon = 'shield',
        bossGrades = { 4 },
        salaries = {
            [0] = 50,
            [1] = 75,
            [2] = 100,
            [3] = 125,
            [4] = 150,
        },
        gradeLabels = {
            [0] = 'Recruit',
            [1] = 'Officer',
            [2] = 'Sergeant',
            [3] = 'Lieutenant',
            [4] = 'Chief',
        },
        stash = {
            enabled = true,
            slots = 50,
            weight = 100000,
        },
    },

    ambulance = {
        label = 'Ambulance',
        icon = 'ambulance',
        bossGrades = { 4 },
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
        stash = {
            enabled = true,
            slots = 40,
            weight = 80000,
        },
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `label` | `string` | -- | Display name shown in the multijob menu for this job. |
| `icon` | `string` | -- | FontAwesome icon name used in menus and on the map (e.g. `'shield'`, `'ambulance'`). |
| `bossGrades` | `table` | -- | Array of grade numbers that grant boss menu access. You can specify multiple grades. |
| `salaries` | `table` | -- | Salary amounts indexed by grade number. **Display only** -- there is no automatic payout system. |
| `gradeLabels` | `table` | -- | Human-readable grade names indexed by grade number, shown in menus. |
| `stash.enabled` | `boolean` | `true` | Enables a shared boss stash for this job. **Requires ox_inventory.** |
| `stash.slots` | `number` | varies | Number of inventory slots in the boss stash. |
| `stash.weight` | `number` | varies | Maximum weight capacity of the boss stash, in grams. |

::: info
The job key (e.g. `police`, `ambulance`) must match the job name defined in your framework's shared jobs file (e.g. `shared/jobs.lua` for QBCore). The `salaries` table is purely cosmetic and does not trigger any payouts.
:::

## Zone Configuration

`Config.Zones` defines the physical locations and interaction methods for each job's duty toggle, duty enforcement zone, and boss menu. Each job key in `Config.Zones` should match a key in `Config.Jobs`.

### Duty Toggle (`duty`)

Where players go on/off duty.

```lua
Config.Zones = {
    police = {
        duty = {
            enabled = true,
            interactionType = 'marker', -- 'marker', 'textui', or 'target'
            locations = {
                {
                    coords   = vec3(440.48, -976.02, 29.69),
                    distance = 3.0,
                    marker = {
                        type    = 1,
                        red     = 0,
                        green   = 155,
                        blue    = 255,
                        opacity = 150,
                    },
                },
                -- Add more locations as needed
            },
        },
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `true` | Whether the duty toggle point is active for this job. |
| `interactionType` | `string` | `'marker'` | How the player interacts to toggle duty: `"marker"`, `"textui"`, or `"target"`. |
| `locations[n].coords` | `vec3` | -- | World coordinates of the duty toggle point. |
| `locations[n].distance` | `number` | `3.0` | Interaction distance from the coords. |
| `locations[n].marker.type` | `number` | `1` | GTA marker type ID (only used when `interactionType` is `"marker"`). |
| `locations[n].marker.red` | `number` | `0` | Red color component (0--255). |
| `locations[n].marker.green` | `number` | `155` | Green color component (0--255). |
| `locations[n].marker.blue` | `number` | `255` | Blue color component (0--255). |
| `locations[n].marker.opacity` | `number` | `150` | Marker opacity (0--255). |

::: tip
The `marker` table is ignored when `interactionType` is set to `"target"` or `"textui"`. You can still define it as a fallback if you switch interaction types later.
:::

### Duty Zone (`dutyZone`)

Optional polygon zones that enforce on-duty status. If enabled, players **must** be inside the zone to remain on duty. Leaving the zone forces them off duty.

```lua
dutyZone = {
    enabled = false,
    bossImmune = false,
    timeout = {
        enabled = true,
        seconds = 30,
    },
    zones = {
        {
            points = {
                vec3(416.3, -961.91, 25.0),
                vec3(498.26, -962.05, 25.0),
                vec3(494.67, -1042.9, 25.0),
                vec3(403.34, -1046.47, 25.0),
            },
            thickness = 100.0,
        },
        -- Add more polygon zones as needed
    },
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `false` | When `true`, players are auto-forced off duty upon leaving the defined zone(s). |
| `bossImmune` | `boolean` | `false` | When `true`, players with a boss grade remain on duty even when leaving the zone. |
| `timeout.enabled` | `boolean` | `true` | When `true`, a delayed off-duty countdown begins when leaving the zone. When `false`, off-duty is immediate. |
| `timeout.seconds` | `number` | `30` | Seconds of grace period before the player is forced off duty after leaving the zone. |
| `zones[n].points` | `table` | -- | Array of `vec3` coordinates defining the polygon vertices. Minimum 3 points required. |
| `zones[n].thickness` | `number` | `100.0` | Vertical thickness / detection height of the polygon zone. |

::: info
Enable `Config.Debug` to visualize duty zones in-game while setting up polygon points. You can define multiple polygon zones per job to cover separate buildings or areas.
:::

### Boss Menu (`bossMenu`)

Where boss-grade players open the management panel.

```lua
bossMenu = {
    enabled = true,
    interactionType = 'target', -- 'marker', 'target', or 'textui'
    locations = {
        {
            coords   = vec3(448.21, -973.12, 29.69),
            distance = 2.5,
            marker = {
                type    = 1,
                red     = 255,
                green   = 200,
                blue    = 0,
                opacity = 150,
            },
        },
        -- Add more locations as needed
    },
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `enabled` | `boolean` | `true` | Whether the boss menu access point is active for this job. |
| `interactionType` | `string` | `'target'` | How the boss interacts to open the menu: `"marker"`, `"target"`, or `"textui"`. |
| `locations[n].coords` | `vec3` | -- | World coordinates of the boss menu access point. |
| `locations[n].distance` | `number` | `2.5` | Interaction distance from the coords. |
| `locations[n].marker.*` | -- | -- | Same marker options as the duty toggle (type, red, green, blue, opacity). Ignored for `"target"` and `"textui"`. |

## Statistics

Per-job stat tracking displayed in the "View Stats" menu. Stats are incremented via the `updateStats` export and displayed using configurable titles, icons, and descriptions.

```lua
Config.Stats = {
    enable = true,
    police = {
        {
            key         = 'minutesWorked',
            title       = 'Time on Duty',
            icon        = 'clock',
            -- no description; uses built-in FormatMinutesWorked
        },
        {
            key         = 'arrests',
            title       = 'Arrests Made',
            description = 'You made {amount} arrests.',
            icon        = 'handcuffs',
        },
        {
            key         = 'ticketsIssued',
            title       = 'Tickets Issued',
            description = 'You issued {amount} tickets.',
            icon        = 'ticket',
        },
        {
            key         = 'vehiclesImpounded',
            title       = 'Vehicles Impounded',
            description = 'You impounded {amount} vehicles.',
            icon        = 'car',
        },
        {
            key         = 'callsResponded',
            title       = 'Calls Responded',
            description = 'You responded to {amount} calls.',
            icon        = 'phone',
        },
        {
            key         = 'bonuses',
            title       = 'Bonuses Received',
            description = 'You received ${amount} in bonuses.',
            icon        = 'gift',
        },
    },
    ambulance = {
        {
            key   = 'minutesWorked',
            title = 'Time on Duty',
            icon  = 'clock',
        },
        {
            key         = 'patientsSaved',
            title       = 'Patients Saved',
            description = 'You saved {amount} lives.',
            icon        = 'heart-pulse',
        },
        {
            key         = 'revives',
            title       = 'Revives Performed',
            description = 'You revived {amount} players.',
            icon        = 'heart',
        },
        {
            key         = 'transportsCompleted',
            title       = 'Transports Completed',
            description = 'You transported {amount} patients.',
            icon        = 'car-side',
        },
        {
            key         = 'suppliesUsed',
            title       = 'Supplies Used',
            description = 'You used {amount} medical supplies.',
            icon        = 'box-medical',
        },
        {
            key         = 'bonuses',
            title       = 'Bonuses Received',
            description = 'You received ${amount} in bonuses.',
            icon        = 'gift',
        },
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `enable` | `boolean` | `true` | Enables or disables the stats feature globally. |
| `[job].key` | `string` | -- | Internal stat identifier. `minutesWorked` is tracked automatically for all jobs while on duty. |
| `[job].title` | `string` | -- | Display title shown in the stats menu. |
| `[job].description` | `string` | `nil` | Description text with `{amount}` placeholder for the stat value. If omitted for `minutesWorked`, a built-in time formatter is used. |
| `[job].icon` | `string` | -- | FontAwesome icon name for this stat entry. |

::: tip
The `minutesWorked` stat is incremented automatically while a player is on duty. Custom stats must be updated via the server export:
```lua
exports['sd-multijob']:updateStats(src, jobName, statKey, increment)
```
For example, to add 1 arrest for player source `1`:
```lua
exports['sd-multijob']:updateStats(1, 'police', 'arrests', 1)
```
:::

## Leaderboard

Configures per-job scoring weights that determine how employees are ranked on the boss menu leaderboard. Each stat contributes points based on its weight multiplied by the stat value.

```lua
Config.Leaderboard = {
    enable = true,
    police = {
        timeWeight = 1,
        statWeights = {
            arrests           = 60,
            ticketsIssued     = 10,
            vehiclesImpounded = 30,
            callsResponded    = 15,
            bonuses           = 1,
        },
    },
    ambulance = {
        timeWeight = 1,
        statWeights = {
            patientsSaved       = 45,
            revives             = 20,
            transportsCompleted = 15,
            suppliesUsed        = 5,
            bonuses             = 1,
        },
    },
}
```

| Key | Type | Default | Description |
|---|---|---|---|
| `enable` | `boolean` | `true` | Enables or disables the leaderboard feature globally. |
| `[job].timeWeight` | `number` | `1` | Points awarded per minute on duty. |
| `[job].statWeights.[stat]` | `number` | varies | Points awarded per unit of the named stat. Higher values make that stat more influential in the ranking. |

::: info
The leaderboard displays the top 5 employees by total weighted score. An employee's total score is calculated as: `(minutesWorked * timeWeight) + sum(stat * statWeight)`.
:::

## Logging

Logging is configured in `server/logs.lua`. The resource supports multiple logging backends and granular event-level control.

```lua
return {
    logs = {
        service     = 'none',
        dataset     = 'sd-multijob',
        screenshots = false,

        events = { ... },

        discord = { ... },
        loki    = { ... },
        grafana = { ... },
    },
}
```

### Service Selection

| Key | Type | Default | Description |
|---|---|---|---|
| `service` | `string` | `'none'` | Logging backend to use. Options: `'none'`, `'fivemanage'`, `'fivemerr'`, `'discord'`, `'loki'`, `'grafana'`. |
| `dataset` | `string` | `'sd-multijob'` | Fivemanage dataset ID. Only used when `service = 'fivemanage'`. |
| `screenshots` | `boolean` | `false` | Attach screenshots to log entries. Only applicable to Fivemanage and Fivemerr. |

### Log Events

Every loggable event can be individually enabled (`true`) or disabled (`false`). All events default to `true`.

```lua
events = {
    -- Player job lifecycle
    job_selected            = true,
    remove_job              = true,
    set_player_job          = true,

    -- Stat tracking
    update_stats            = true,

    -- Player data retrieval
    retrieve_jobs           = true,
    get_active_group        = true,
    get_employee_stats      = true,
    get_boss_data           = true,

    -- Application form management
    add_application_question    = true,
    remove_application_question = true,
    edit_application_question   = true,
    set_application_location    = true,

    -- Player application flow
    submit_application      = true,
    edit_submission          = true,

    -- Interview scheduling
    schedule_interview      = true,
    respond_interview       = true,

    -- Messaging & bonuses
    give_employee_bonus     = true,
    redeem_bonus            = true,
    send_employee_message   = true,
    send_boss_message       = true,
    delete_notification     = true,
    delete_boss_message     = true,

    -- Weekly goals
    set_weekly_target       = true,
    claim_weekly_reward     = true,

    -- Society funds management
    deposit_society         = true,
    withdraw_society        = true,

    -- Employee management
    add_employee            = true,
    remove_employee         = true,
    set_employee_grade      = true,

    -- Data persistence
    save_player_data        = true,
    save_all_data           = true,
},
```

| Category | Events | Description |
|---|---|---|
| **Job Lifecycle** | `job_selected`, `remove_job`, `set_player_job` | Tracks when players select, lose, or have jobs set via callback. |
| **Stat Tracking** | `update_stats` | Logs when the `updateStats` export is called. |
| **Data Retrieval** | `retrieve_jobs`, `get_active_group`, `get_employee_stats`, `get_boss_data` | Logs when player or boss data is fetched. |
| **Application Management** | `add_application_question`, `remove_application_question`, `edit_application_question`, `set_application_location` | Logs boss actions on application forms. |
| **Application Flow** | `submit_application`, `edit_submission` | Logs player application submissions and edits. |
| **Interviews** | `schedule_interview`, `respond_interview` | Logs interview scheduling and player responses. |
| **Messages & Bonuses** | `give_employee_bonus`, `redeem_bonus`, `send_employee_message`, `send_boss_message`, `delete_notification`, `delete_boss_message` | Logs all messaging and bonus activity. |
| **Weekly Goals** | `set_weekly_target`, `claim_weekly_reward` | Logs when bosses set weekly targets and when employees claim rewards. |
| **Society Funds** | `deposit_society`, `withdraw_society` | Logs society account deposits and withdrawals. |
| **Employee Management** | `add_employee`, `remove_employee`, `set_employee_grade` | Logs hiring, firing, and grade changes. |
| **Data Persistence** | `save_player_data`, `save_all_data` | Logs individual player saves and batch saves (e.g. on server shutdown). |

### Discord Webhook

Only used when `service = 'discord'`.

```lua
discord = {
    name   = 'Multijob Logs',
    link   = '',
    image  = '',
    footer = '',
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | `string` | `'Multijob Logs'` | Display name for the webhook bot. |
| `link` | `string` | `''` | Discord webhook URL. |
| `image` | `string` | `''` | Avatar image URL for the webhook bot. |
| `footer` | `string` | `''` | Footer icon URL for embed messages. |

### Loki

Only used when `service = 'loki'`.

```lua
loki = {
    endpoint = '',
    user     = '',
    password = '',
    tenant   = '',
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `endpoint` | `string` | `''` | Base URL without trailing slash (e.g. `'https://loki.example.com'`). |
| `user` | `string` | `''` | Basic auth username (optional). |
| `password` | `string` | `''` | Basic auth password or API key (optional). |
| `tenant` | `string` | `''` | `X-Scope-OrgID` header value (optional). |

### Grafana Cloud Logs

Only used when `service = 'grafana'`.

```lua
grafana = {
    endpoint = '',
    apiKey   = '',
    tenant   = '',
},
```

| Key | Type | Default | Description |
|---|---|---|---|
| `endpoint` | `string` | `''` | Base URL without trailing slash (e.g. `'https://logs-prod.grafana.net'`). |
| `apiKey` | `string` | `''` | Grafana API key (prefixed with `'Bearer '`). |
| `tenant` | `string` | `''` | `X-Scope-OrgID` header value (optional). |
