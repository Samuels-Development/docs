return {
    logs = {
        -- What logging service do you want to use?
        -- Available options: 'fivemanage', 'fivemerr', 'discord', 'loki', 'grafana' & 'none'
        service     = 'none',

        -- Fivemanage dataset ID (only used when service = 'fivemanage')
        dataset     = 'sd-selling',

        -- Do you want to include screenshots with your logs?
        -- This is only applicable to Fivemanage and Fivemerr
        screenshots = false,

        -- You can enable (true) or disable (false) specific events to log here
        events = {
            -- Delivery workflow
            complete_stop            = true,  -- when a delivery stop is completed

            -- Experience & progression
            add_xp                   = true,  -- when XP is awarded

            -- Stolen drugs
            stash_drugs              = true,  -- when drugs are marked as stolen
            return_drugs             = true,  -- when stolen drugs are returned

            -- Encounters
            complete_encounter       = true,  -- when an encounter finishes

            -- Milestones
            redeem_milestone         = true,  -- when a milestone is redeemed

            -- Sales
            sell_drug                = true,  -- when a player sells drugs / receives payout
            money_launder            = true,  -- when a player launders money
        },

        -- If service = 'discord', you can customize the webhook data here
        -- If not using Discord, this section can be ignored
        discord = {
            -- The name of the webhook
            name   = 'Selling Logs',
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
            tenant   = ''
        },

        -- If service = 'grafana', provide your Grafana Cloud Logs settings
        grafana = {
            -- Base URL (without trailing slash), e.g. 'https://logs-prod.grafana.net'
            endpoint = '',
            -- Your Grafana API key (prefixed with 'Bearer ')
            apiKey   = '',
            -- (Optional) X-Scope-OrgID header value
            tenant   = ''
        },
    },
}