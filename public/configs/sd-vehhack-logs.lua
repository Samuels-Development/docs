--[[
    ============================================
    SD-VEHHACK LOGGING CONFIGURATION
    ============================================

    Every hack and scan can be logged to Discord or a log aggregator.

    AVAILABLE PLACEHOLDERS:
    -----------------------
    Player info:
        {player}        Player name with ID, e.g. "John (ID: 12)"
        {playerName}    Just the player name
        {playerId}      Just the server ID
        {identifier}    citizenid (QB) / license (ESX)
        {charName}      Character full name

    Hack info (varies by event):
        {hackId}        Internal id (e.g. 'explode_car')
        {hackLabel}     Display label (e.g. 'EXPLODE_VEHICLE')
        {hackCategory}  'sabotage' / 'control' / 'chaos' / 'intel'
        {hackCost}      Cost in Scripts (or cash)
        {plate}         Target vehicle plate
        {vehicleClass}  'car' / 'heli' / 'bike'
        {ownerFirstName}   (owner_scan only) owner's first name
        {ownerLastName}    (owner_scan only) owner's last name
        {ownerStatus}      (owner_scan only) Registered / Unverified / POLICE / EMS / FIRE

    DISCORD EMBED COLORS (decimal):
    -------------------------------
        Red 15548997  Orange 16744448  Yellow 16776960  Green 5763719
        Blue 255      Blurple 5793266  Gold 16766720     Gray 9807270
]]

return {
    logs = {
        -- Active logging backend. One of:
        -- 'discord' | 'fivemanage' | 'fivemerr' | 'loki' | 'grafana' | 'none'.
        service = 'none',

        screenshots = false,

        -- Discord webhook configuration (used when service = 'discord').
        discord = {
            webhook       = '',
            botName       = 'SD-Vehhack',
            botAvatar     = '',
            footerText    = 'SD-Vehhack Logging',
            footerIcon    = '',
            flushInterval = 5,      -- Seconds between batched Discord posts
            tagEveryone   = false,  -- @everyone on high-impact hacks
        },

        -- Alternative logging backends -- Fivemanage, Fivemerr, Loki, Grafana.
        fivemanage = { dataset = 'sd-vehhack' },
        loki       = { endpoint = '', user = '', password = '', tenant = '', server = '' },
        grafana    = { endpoint = '', apiKey   = '',            tenant = '', server = '' },

        -- Per-event templates. Set `enabled = false` to stop logging a specific
        -- event. Edit titles, descriptions, and fields to taste.
        events = {

            hack_executed = {
                enabled = true,
                title = 'Hack Executed',
                description = 'A vehicle hack was successfully executed.',
                color = 16776960, -- Yellow
                fields = {
                    { name = 'Player',     value = '{player}',        inline = true },
                    { name = 'Identifier', value = '{identifier}',    inline = true },
                    { name = 'Character',  value = '{charName}',      inline = true },
                    { name = 'Hack',       value = '{hackLabel}',     inline = true },
                    { name = 'Category',   value = '{hackCategory}',  inline = true },
                    { name = 'Cost',       value = '{hackCost} Scripts', inline = true },
                    { name = 'Target',     value = '{plate}',         inline = true },
                    { name = 'Class',      value = '{vehicleClass}',  inline = true },
                },
            },

            owner_scan_performed = {
                enabled = true,
                title = 'Owner Scan',
                description = 'A player scanned a vehicle for its registered owner.',
                color = 5763719, -- Green
                fields = {
                    { name = 'Player',        value = '{player}',            inline = true },
                    { name = 'Identifier',    value = '{identifier}',        inline = true },
                    { name = 'Plate',         value = '{plate}',             inline = true },
                    { name = 'Scan Result',   value = '{ownerStatus}',       inline = true },
                    { name = 'Resolved Name', value = '{ownerFirstName} {ownerLastName}', inline = true },
                    { name = 'Cost',          value = '{hackCost} Scripts',     inline = true },
                },
            },

        },
    },
}
