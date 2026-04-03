return {
    logs = {
        -- What logging service do you want to use?
        -- Available options: 'fivemanage', 'fivemerr', 'discord', 'loki', 'grafana' & 'none'
        service     = 'none',

        -- Fivemanage dataset ID (only used when service = 'fivemanage')
        dataset     = 'sd-traphouse',

        -- Do you want to include screenshots with your logs?
        -- This is only applicable to Fivemanage and Fivemerr
        screenshots = false,

        -- You can enable (true) or disable (false) specific events to log here
        events = {
            -- when a player removes a front-door or vault item (chance-based)
            remove_item         = true,
            -- when a player receives money or an item from a prop
            give_object         = true,
            -- when a player loots a guard for rewards
            loot_guards         = true,
            -- when someone starts the traphouse cooldown
            start_cooldown      = true,
            -- when checking if player has the front-door key item
            has_frontdoor_item  = true,
            -- when checking if player has the vault key item
            has_vault_item      = true,
        },

        -- If service = 'discord', you can customize the webhook data here
        -- If not using Discord, this section can be ignored
        discord = {
            -- The name of the webhook
            name   = 'TrapHouse Logs',
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
        }
    },
}
