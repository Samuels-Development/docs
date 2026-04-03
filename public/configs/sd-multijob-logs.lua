return {
    logs = {
        -- What logging service do you want to use?
        -- Available options: 'fivemanage', 'fivemerr', 'discord', 'loki', 'grafana' & 'none'
        service     = 'none',

        -- Fivemanage dataset ID (only used when service = 'fivemanage')
        dataset     = 'sd-multijob',

        -- Do you want to include screenshots with your logs?
        -- This is only applicable to Fivemanage and Fivemerr
        screenshots = false,

        -- You can enable (true) or disable (false) specific events to log here
        events = {
            -- Player job lifecycle
            job_selected            = true,  -- when a player selects or adds a new job
            remove_job              = true,  -- when a job is removed from a player
            set_player_job          = true,  -- when a player's job is set via callback

            -- Stat tracking
            update_stats            = true,  -- when an UpdateStats export is called

            -- Player data retrieval
            retrieve_jobs           = true,  -- when a player retrieves their job list
            get_active_group        = true,  -- when a player’s active job group/duty is fetched
            get_employee_stats      = true,  -- when a boss fetches an employee’s stats
            get_boss_data           = true,  -- when a boss fetches their society/boss data

            -- Application form management
            add_application_question    = true,  -- when a boss adds a new application question
            remove_application_question = true,  -- when a boss removes an application question
            edit_application_question   = true,  -- when a boss edits an application question
            set_application_location    = true, -- when a boss sets the location for where you can submit applications

            -- Player application flow
            submit_application       = true,  -- when a player submits a new application
            edit_submission          = true,  -- when a player edits their existing submission

            -- Interview scheduling
            schedule_interview       = true,  -- when a boss schedules an interview
            respond_interview        = true,  -- when a player confirms or declines an interview

            -- Messaging & bonuses
            give_employee_bonus      = true,  -- when a boss gives a bonus to an employee
            redeem_bonus             = true,  -- when a player redeems a bonus notification
            send_employee_message    = true,  -- when a boss sends a message to an employee
            send_boss_message        = true,  -- when a player sends a message to all bosses
            delete_notification      = true,  -- when any notification (message or bonus) is deleted
            delete_boss_message      = true,  -- when a boss deletes one of their own messages

            -- Weekly goals
            set_weekly_target        = true,  -- when a boss sets the weekly hours target & reward
            claim_weekly_reward      = true,  -- when a player claims their weekly reward

            -- Society funds management
            deposit_society          = true,  -- when a boss deposits money into the society account
            withdraw_society         = true,  -- when a boss withdraws money from the society account

            -- Employee management
            add_employee             = true,  -- when a boss hires a new employee
            remove_employee          = true,  -- when a boss fires an existing employee
            set_employee_grade       = true,  -- when a boss changes an employee's grade

            -- Data persistence
            save_player_data         = true,  -- when a player's data is saved on disconnect
            save_all_data            = true,  -- when all data is batch-saved (e.g. on shutdown)
        },

        -- If service = 'discord', you can customize the webhook data here
        -- If not using Discord, this section can be ignored
        discord = {
            -- The name of the webhook
            name   = 'Multijob Logs',
            -- The webhook URL
            link   = '',
            -- The webhook avatar image
            image  = '',
            -- The webhook footer icon
            footer = '',
        },

        -- If service = 'loki', provide your Loki push settings
        loki = {
            -- Base URL (without trailing slash), e.g. 'https://loki.example.com'
            endpoint = '',
            -- (Optional) Basic auth username
            user     = '',
            -- (Optional) Basic auth password or API key
            password = '',
            -- (Optional) X-Scope-OrgID header value
            tenant   = '',
        },

        -- If service = 'grafana', provide your Grafana Cloud Logs settings
        grafana = {
            -- Base URL (without trailing slash), e.g. 'https://logs-prod.grafana.net'
            endpoint = '',
            -- Your Grafana API key (prefixed with 'Bearer ')
            apiKey   = '',
            -- (Optional) X-Scope-OrgID header value
            tenant   = '',
        },
    },
}
