return {
    logs = {
        -- What logging service do you want to use?
        -- Available options: 'fivemanage', 'fivemerr', 'discord', 'loki', 'grafana' & 'none'
        service     = 'none',

        -- Fivemanage dataset ID (only used when service = 'fivemanage')
        dataset     = 'sd-pacificbank',

        -- Do you want to include screenshots with your logs?
        -- This is only applicable to Fivemanage and Fivemerr
        screenshots = false,

        -- You can enable (true) or disable (false) specific events to log here
        events = {
            tray_loot    = true,  -- when a player successfully loots a tray
            give_loot    = true,  -- when a player takes loot from a deposit box
            reward_ped   = true,  -- when a player receives a ped reward
            remove_item  = true,  -- when an item is removed from a player's inventory
        },

        -- If service = 'discord', you can customize the webhook data here
        -- If not using Discord, this section can be ignored
        discord = {
            -- The name of the webhook
            name   = 'Pacific Bank Logs',
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
