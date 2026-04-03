--[[
    ============================================
    SD-HORDE LOGGING CONFIGURATION
    ============================================

    This file configures the logging system for SD-Horde.
    You can customize every aspect of how logs appear.

    AVAILABLE PLACEHOLDERS FOR MESSAGES:
    ------------------------------------
    Player Info:
        {player}        - Player name with ID, e.g. "OOpium (ID: 272)"
        {playerName}    - Just the player name
        {playerId}      - Just the server ID
        {identifier}    - Player identifier (citizenid/license)
        {charName}      - Character name (firstname lastname)

    Game Info:
        {gameId}        - The unique game session ID
        {map}           - Map name
        {difficulty}    - Difficulty level
        {round}         - Current round number
        {maxRounds}     - Maximum rounds for this difficulty
        {playerCount}   - Number of players in game
        {money}         - Current team money/coins

    Event-Specific (varies by event):
        {cost}          - Cost of purchase/action
        {item}          - Item name/label
        {weapon}        - Weapon name/label
        {perk}          - Perk name/label
        {bossName}      - Boss name
        {reason}        - Reason for action
        {duration}      - Duration in minutes
        {value}         - Generic value field
        {lootItems}     - End game loot items purchased (formatted list)
        {itemList}      - Inventory items (formatted list for confiscate/restore)

    DISCORD EMBED COLORS (Decimal format):
    --------------------------------------
        Red:        16711680    (0xFF0000)
        Green:      65280       (0x00FF00)
        Blue:       255         (0x0000FF)
        Yellow:     16776960    (0xFFFF00)
        Orange:     16744448    (0xFF8000)
        Purple:     10494192    (0xA020F0)
        Cyan:       65535       (0x00FFFF)
        Pink:       16761035    (0xFFB6C1)
        Gold:       16766720    (0xFFD700)
        Gray:       9807270     (0x959595)
        Dark Gray:  5592405     (0x555555)
        White:      16777215    (0xFFFFFF)

        -- SD-Horde Theme Colors --
        Success:    5763719     (0x57F287) - Green
        Error:      15548997    (0xED4245) - Red
        Warning:    16776960    (0xFFFF00) - Yellow
        Info:       5793266     (0x5865F2) - Blurple
        Neutral:    9807270     (0x959595) - Gray
]]

return {
    logs = {
        -- ============================================
        -- SERVICE CONFIGURATION
        -- ============================================

        --[[
            Available services:
            - 'discord'     : Send logs to Discord via webhook
            - 'fivemanage'  : Send logs to Fivemanage dashboard
            - 'fivemerr'    : Send logs to Fivemerr (fm-logs)
            - 'loki'        : Send logs to Loki/Prometheus stack
            - 'grafana'     : Send logs to Grafana Cloud
            - 'none'        : Disable all logging
        ]]
        service = 'none',

        -- Include screenshots with logs (Fivemanage/Fivemerr only)
        screenshots = false,

        -- ============================================
        -- DISCORD CONFIGURATION
        -- ============================================
        -- Only used when service = 'discord'

        discord = {
            -- REQUIRED: Your Discord webhook URL
            webhook = '',

            -- Bot display name in Discord
            botName = 'Horde Logger',

            -- Bot avatar image URL (leave empty for default)
            botAvatar = '',

            -- Footer text shown on all embeds
            footerText = 'SD-Horde Logging',

            -- Footer icon URL (leave empty for none)
            footerIcon = '',

            -- How often to send batched logs (in seconds)
            -- Lower = more real-time, Higher = less Discord API calls
            flushInterval = 5,

            -- Tag @everyone for critical events?
            -- Events tagged: game_ended_victory, boss_killed, player_disconnected
            tagEveryone = false,
        },

        -- ============================================
        -- FIVEMANAGE CONFIGURATION
        -- ============================================
        -- Only used when service = 'fivemanage'

        fivemanage = {
            -- Dataset ID for organizing logs
            dataset = 'sd-horde',
        },

        -- ============================================
        -- LOKI CONFIGURATION
        -- ============================================
        -- Only used when service = 'loki'

        loki = {
            -- Loki push endpoint (without trailing slash)
            -- Example: 'https://loki.example.com'
            endpoint = '',

            -- Basic auth credentials (optional)
            user     = '',
            password = '',

            -- X-Scope-OrgID header for multi-tenancy (optional)
            tenant   = '',

            -- Server name label for filtering logs
            server   = '',
        },

        -- ============================================
        -- GRAFANA CLOUD CONFIGURATION
        -- ============================================
        -- Only used when service = 'grafana'

        grafana = {
            -- Grafana Cloud Logs endpoint (without trailing slash)
            -- Example: 'https://logs-prod-us-central1.grafana.net'
            endpoint = '',

            -- Your Grafana Cloud API key
            apiKey   = '',

            -- X-Scope-OrgID header (optional)
            tenant   = '',

            -- Server name label for filtering logs
            server   = '',
        },

        -- ============================================
        -- EVENT CONFIGURATIONS
        -- ============================================
        --[[
            Each event can have:
            - enabled       : true/false - Whether to log this event
            - title         : The title (supports emojis)
            - description   : The main message (supports placeholders)
            - color         : Embed color in decimal format (DISCORD ONLY)
            - fields        : Array of field definitions for structured data

            Field definition:
            {
                name   = "Field Label",     -- The bold label
                value  = "{placeholder}",   -- Value with placeholders
                inline = true/false         -- Display inline (DISCORD ONLY)
            }

            =============================================
            HOW LOGS APPEAR ON DIFFERENT SERVICES:
            =============================================

            DISCORD:
            - Full rich embed with title, description, color, and inline fields
            - Example:
              ┌─────────────────────────────────────┐
              │ 📤 Inventory Returned               │ <- title
              │ Player inventory has been returned  │ <- description
              │                                     │
              │ Player: OOpium    Identifier: abc   │ <- inline fields
              │ Items: Pistol x1, Bandage x5        │ <- non-inline field
              └─────────────────────────────────────┘

            FIVEMANAGE / FIVEMERR / LOKI / GRAFANA:
            - Converted to plain text format
            - Title is used as the log title/label
            - Description + fields become the message body
            - 'color' and 'inline' are IGNORED
            - Example:
              [Title: 📤 Inventory Returned]
              Player inventory has been returned after horde match ended.

              Player: OOpium (ID: 272)
              Identifier: license:abc123
              Item Count: 5 items
              Items: Pistol x1, Bandage x5, Water x3

            WHAT EACH PROPERTY DOES:
            -------------------------
            enabled     - ALL SERVICES  - Toggles the event on/off
            title       - ALL SERVICES  - Log title/header
            description - ALL SERVICES  - Main message body
            color       - DISCORD ONLY  - Embed sidebar color
            fields      - ALL SERVICES  - Structured data (name: value pairs)
            inline      - DISCORD ONLY  - Whether fields appear side-by-side
        ]]

        events = {
            -- ============================================
            -- GAME LIFECYCLE EVENTS
            -- ============================================

            game_created = {
                enabled = true,
                title = "🎮 Game Lobby Created",
                description = "A new horde game lobby has been created.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Host",       value = "{player}",      inline = true },
                    { name = "Identifier", value = "{identifier}",  inline = true },
                    { name = "Map",        value = "{map}",         inline = true },
                    { name = "Difficulty", value = "{difficulty}",  inline = true },
                    { name = "Players",    value = "{playerCount}", inline = true },
                    { name = "Game ID",    value = "{gameId}",      inline = true },
                    { name = "Player List", value = "{playerList}", inline = false },
                },
            },

            game_cancelled = {
                enabled = true,
                title = "❌ Game Lobby Cancelled",
                description = "A horde game lobby has been cancelled before starting.",
                color = 15548997, -- Red
                fields = {
                    { name = "Cancelled By", value = "{player}",      inline = true },
                    { name = "Identifier",   value = "{identifier}",  inline = true },
                    { name = "Map",          value = "{map}",         inline = true },
                    { name = "Difficulty",   value = "{difficulty}",  inline = true },
                    { name = "Players",      value = "{playerCount}", inline = true },
                    { name = "Game ID",      value = "{gameId}",      inline = true },
                    { name = "Player List",  value = "{playerList}",  inline = false },
                },
            },

            game_started = {
                enabled = true,
                title = "⚔️ Horde Match Started",
                description = "A horde match has officially begun!",
                color = 5763719, -- Green
                fields = {
                    { name = "Map",         value = "{map}",         inline = true },
                    { name = "Difficulty",  value = "{difficulty}",  inline = true },
                    { name = "Max Rounds",  value = "{maxRounds}",   inline = true },
                    { name = "Players",     value = "{playerCount}", inline = true },
                    { name = "Game ID",     value = "{gameId}",      inline = true },
                },
            },

            game_ended_victory = {
                enabled = true,
                title = "🏆 Horde Match Completed - Victory!",
                description = "The team has successfully completed all rounds!",
                color = 16766720, -- Gold
                fields = {
                    { name = "Map",         value = "{map}",         inline = true },
                    { name = "Difficulty",  value = "{difficulty}",  inline = true },
                    { name = "Final Round", value = "{round}",       inline = true },
                    { name = "Duration",    value = "{duration}",    inline = true },
                    { name = "Total Coins", value = "{money}",       inline = true },
                    { name = "Game ID",     value = "{gameId}",      inline = true },
                    { name = "Players",     value = "{playerList}",  inline = false },
                    { name = "End Game Loot Purchased", value = "{lootItems}", inline = false },
                },
            },

            game_ended_defeat = {
                enabled = true,
                title = "💀 Horde Match Ended - Defeat",
                description = "All players have been eliminated. Game over.",
                color = 15548997, -- Red
                fields = {
                    { name = "Map",           value = "{map}",         inline = true },
                    { name = "Difficulty",    value = "{difficulty}",  inline = true },
                    { name = "Reached Round", value = "{round}",       inline = true },
                    { name = "Duration",      value = "{duration}",    inline = true },
                    { name = "Total Coins",   value = "{money}",       inline = true },
                    { name = "Game ID",       value = "{gameId}",      inline = true },
                    { name = "Players",       value = "{playerList}",  inline = false },
                    { name = "End Game Loot Purchased", value = "{lootItems}", inline = false },
                },
            },

            game_ended_abandoned = {
                enabled = true,
                title = "🚪 Horde Match Abandoned",
                description = "All players have left the game.",
                color = 9807270, -- Gray
                fields = {
                    { name = "Map",        value = "{map}",        inline = true },
                    { name = "Difficulty", value = "{difficulty}", inline = true },
                    { name = "Last Round", value = "{round}",      inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            game_force_ended = {
                enabled = true,
                title = "🛑 Game Force Ended by Admin",
                description = "An administrator has forcefully ended the game.",
                color = 15548997, -- Red
                fields = {
                    { name = "Admin",      value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Round",      value = "{round}",      inline = true },
                    { name = "Players",    value = "{playerCount}", inline = true },
                    { name = "Coins",      value = "{money}",      inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            game_abandoned_empty = {
                enabled = true,
                title = "👻 Game Abandoned - All Players Disconnected",
                description = "An active horde game was abandoned because all players disconnected.",
                color = 9807270, -- Gray
                fields = {
                    { name = "Map",        value = "{map}",        inline = true },
                    { name = "Difficulty", value = "{difficulty}", inline = true },
                    { name = "Last Round", value = "{round}",      inline = true },
                    { name = "Duration",   value = "{duration}",   inline = true },
                    { name = "Coins Left", value = "{money}",      inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            game_abandoned_all_dead = {
                enabled = true,
                title = "💀 Game Abandoned - All Players Dead",
                description = "An active horde game was abandoned because all players died and rejoin system is disabled.",
                color = 15548997, -- Red
                fields = {
                    { name = "Map",        value = "{map}",        inline = true },
                    { name = "Difficulty", value = "{difficulty}", inline = true },
                    { name = "Last Round", value = "{round}",      inline = true },
                    { name = "Duration",   value = "{duration}",   inline = true },
                    { name = "Coins Left", value = "{money}",      inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            game_abandoned_pause_timeout = {
                enabled = true,
                title = "⏰ Game Abandoned - Pause Timeout",
                description = "A paused horde game was abandoned because no players rejoined within the timeout period.",
                color = 16744448, -- Orange
                fields = {
                    { name = "Map",        value = "{map}",        inline = true },
                    { name = "Difficulty", value = "{difficulty}", inline = true },
                    { name = "Last Round", value = "{round}",      inline = true },
                    { name = "Duration",   value = "{duration}",   inline = true },
                    { name = "Coins Left", value = "{money}",      inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            game_timeout_dead_players = {
                enabled = true,
                title = "⏰ Game Ended - Dead Player Timeout",
                description = "Game ended because all players were dead and the timeout expired.",
                color = 15548997, -- Red
                fields = {
                    { name = "Map",        value = "{map}",        inline = true },
                    { name = "Difficulty", value = "{difficulty}", inline = true },
                    { name = "Last Round", value = "{round}",      inline = true },
                    { name = "Duration",   value = "{duration}",   inline = true },
                    { name = "Coins Left", value = "{money}",      inline = true },
                    { name = "Players",    value = "{playerCount}", inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                    { name = "Player List", value = "{playerList}", inline = false },
                },
            },

            game_paused = {
                enabled = true,
                title = "⏸️ Game Paused",
                description = "A horde game has been paused due to player disconnection.",
                color = 16776960, -- Yellow
                fields = {
                    { name = "Map",              value = "{map}",              inline = true },
                    { name = "Difficulty",       value = "{difficulty}",       inline = true },
                    { name = "Round",            value = "{round}",            inline = true },
                    { name = "Players Remaining", value = "{remainingPlayers}", inline = true },
                    { name = "Game ID",          value = "{gameId}",           inline = true },
                },
            },

            game_resumed = {
                enabled = true,
                title = "▶️ Game Resumed",
                description = "A paused horde game has been resumed.",
                color = 5763719, -- Green
                fields = {
                    { name = "Map",            value = "{map}",           inline = true },
                    { name = "Difficulty",     value = "{difficulty}",    inline = true },
                    { name = "Round",          value = "{round}",         inline = true },
                    { name = "Restored State", value = "{restoredState}", inline = true },
                    { name = "Game ID",        value = "{gameId}",        inline = true },
                },
            },

            lobby_abandoned_empty = {
                enabled = true,
                title = "👻 Lobby Abandoned - All Players Disconnected",
                description = "A game lobby was abandoned because all players disconnected before starting.",
                color = 9807270, -- Gray
                fields = {
                    { name = "Map",        value = "{map}",        inline = true },
                    { name = "Difficulty", value = "{difficulty}", inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            lobby_cancelled_host_left = {
                enabled = true,
                title = "🚪 Lobby Cancelled - Host Disconnected",
                description = "A game lobby was cancelled because the host disconnected.",
                color = 16744448, -- Orange
                fields = {
                    { name = "Map",         value = "{map}",         inline = true },
                    { name = "Difficulty",  value = "{difficulty}",  inline = true },
                    { name = "Players",     value = "{playerCount}", inline = true },
                    { name = "Game ID",     value = "{gameId}",      inline = true },
                    { name = "Affected Players", value = "{playerList}", inline = false },
                },
            },

            -- ============================================
            -- ROUND EVENTS
            -- ============================================

            round_started = {
                enabled = true,
                title = "🔔 Round Started",
                description = "A new combat round has begun.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Round",        value = "{round} / {maxRounds}", inline = true },
                    { name = "Enemy Count",  value = "{enemyCount}",          inline = true },
                    { name = "Players Alive", value = "{aliveCount}",         inline = true },
                    { name = "Game ID",      value = "{gameId}",              inline = true },
                },
            },

            round_completed = {
                enabled = true,
                title = "✅ Round Completed",
                description = "All enemies have been eliminated!",
                color = 5763719, -- Green
                fields = {
                    { name = "Round",       value = "{round} / {maxRounds}", inline = true },
                    { name = "Team Coins",  value = "{money}",               inline = true },
                    { name = "Players",     value = "{playerCount}",         inline = true },
                    { name = "Game ID",     value = "{gameId}",              inline = true },
                },
            },

            -- ============================================
            -- PHASE EVENTS
            -- ============================================

            looting_phase_started = {
                enabled = false, -- Disabled by default (can be noisy)
                title = "📦 Looting Phase Started",
                description = "Players can now loot bodies and collect items.",
                color = 16744448, -- Orange
                fields = {
                    { name = "Round",           value = "{round}",      inline = true },
                    { name = "Duration",        value = "{duration}s",  inline = true },
                    { name = "Bodies Available", value = "{bodyCount}", inline = true },
                    { name = "Game ID",         value = "{gameId}",     inline = true },
                },
            },

            looting_phase_ended = {
                enabled = false,
                title = "📦 Looting Phase Ended",
                description = "Looting phase has concluded.",
                color = 9807270, -- Gray
                fields = {
                    { name = "Round",   value = "{round}",  inline = true },
                    { name = "Game ID", value = "{gameId}", inline = true },
                },
            },

            voting_phase_started = {
                enabled = false,
                title = "🗳️ Perk Voting Started",
                description = "Players are voting on their next perk.",
                color = 10494192, -- Purple
                fields = {
                    { name = "Round",    value = "{round}",       inline = true },
                    { name = "Duration", value = "{duration}s",   inline = true },
                    { name = "Options",  value = "{perkOptions}", inline = false },
                    { name = "Game ID",  value = "{gameId}",      inline = true },
                },
            },

            voting_phase_ended = {
                enabled = true,
                title = "🗳️ Perk Voting Ended",
                description = "Voting has concluded and a perk has been selected.",
                color = 10494192, -- Purple
                fields = {
                    { name = "Winner",       value = "{winningPerk}",  inline = true },
                    { name = "Votes",        value = "{winningVotes}", inline = true },
                    { name = "Total Voters", value = "{totalVoters}",  inline = true },
                    { name = "Round",        value = "{round}",        inline = true },
                    { name = "Game ID",      value = "{gameId}",       inline = true },
                },
            },

            -- ============================================
            -- BOSS EVENTS
            -- ============================================

            boss_spawned = {
                enabled = true,
                title = "👹 Boss Spawned!",
                description = "A powerful boss has entered the arena!",
                color = 15548997, -- Red
                fields = {
                    { name = "Boss Name", value = "{bossName}",   inline = true },
                    { name = "Health",    value = "{bossHealth}", inline = true },
                    { name = "Reward",    value = "{bossReward}", inline = true },
                    { name = "Round",     value = "{round}",      inline = true },
                    { name = "Game ID",   value = "{gameId}",     inline = true },
                },
            },

            boss_killed = {
                enabled = true,
                title = "💀 Boss Defeated!",
                description = "The boss has been slain!",
                color = 16766720, -- Gold
                fields = {
                    { name = "Boss Name",  value = "{bossName}",   inline = true },
                    { name = "Killed By",  value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Reward",     value = "{bossReward}", inline = true },
                    { name = "Round",      value = "{round}",      inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            -- ============================================
            -- PLAYER LIFECYCLE EVENTS
            -- ============================================

            player_joined_game = {
                enabled = true,
                title = "➡️ Player Joined Game",
                description = "A player has entered the horde match area and is ready.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",     value = "{player}",      inline = true },
                    { name = "Identifier", value = "{identifier}",  inline = true },
                    { name = "Character",  value = "{charName}",    inline = true },
                    { name = "Map",        value = "{map}",         inline = true },
                    { name = "Difficulty", value = "{difficulty}",  inline = true },
                    { name = "Game ID",    value = "{gameId}",      inline = true },
                },
            },

            player_rejoined = {
                enabled = true,
                title = "🔄 Player Rejoined Game",
                description = "A disconnected player has rejoined an active horde match.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",              value = "{player}",              inline = true },
                    { name = "Identifier",          value = "{identifier}",          inline = true },
                    { name = "Map",                 value = "{map}",                 inline = true },
                    { name = "Difficulty",          value = "{difficulty}",          inline = true },
                    { name = "Round",               value = "{round}",               inline = true },
                    { name = "Time Since Disconnect", value = "{timeSinceDisconnect}s", inline = true },
                    { name = "Game ID",             value = "{gameId}",              inline = true },
                },
            },

            player_disconnected = {
                enabled = true,
                title = "🚨 Player Disconnected During Horde",
                description = "A player has disconnected while in an active horde match.",
                color = 15548997, -- Red
                fields = {
                    { name = "Player",     value = "{player}",          inline = true },
                    { name = "Identifier", value = "{identifier}",      inline = true },
                    { name = "Reason",     value = "{reason}",          inline = false },
                    { name = "Round",      value = "{round}",           inline = true },
                    { name = "Remaining",  value = "{remainingPlayers}", inline = true },
                    { name = "Game ID",    value = "{gameId}",          inline = true },
                },
            },

            player_left_zone = {
                enabled = true,
                title = "⚠️ Player Left Play Zone",
                description = "A player has left the play area and was removed from the game.",
                color = 16776960, -- Yellow
                fields = {
                    { name = "Player",     value = "{player}",          inline = true },
                    { name = "Identifier", value = "{identifier}",      inline = true },
                    { name = "Round",      value = "{round}",           inline = true },
                    { name = "Remaining",  value = "{remainingPlayers}", inline = true },
                    { name = "Game ID",    value = "{gameId}",          inline = true },
                },
            },

            -- ============================================
            -- DEATH & REVIVE EVENTS
            -- ============================================

            player_died = {
                enabled = true,
                title = "💀 Player Died",
                description = "A player has been killed during the horde match.",
                color = 15548997, -- Red
                fields = {
                    { name = "Player",      value = "{player}",     inline = true },
                    { name = "Identifier",  value = "{identifier}", inline = true },
                    { name = "Round",       value = "{round}",      inline = true },
                    { name = "Dead Count",  value = "{deadCount}",  inline = true },
                    { name = "Alive Count", value = "{aliveCount}", inline = true },
                    { name = "Game ID",     value = "{gameId}",     inline = true },
                },
            },

            player_revived = {
                enabled = true,
                title = "💚 Player Revived",
                description = "A player has been revived by a teammate.",
                color = 5763719, -- Green
                fields = {
                    { name = "Revived",     value = "{revivedPlayer}", inline = true },
                    { name = "Revived ID",  value = "{revivedId}",     inline = true },
                    { name = "Revived By",  value = "{player}",        inline = true },
                    { name = "Cost",        value = "{cost} coins",    inline = true },
                    { name = "Round",       value = "{round}",         inline = true },
                    { name = "Game ID",     value = "{gameId}",        inline = true },
                },
            },

            -- ============================================
            -- INVENTORY EVENTS
            -- ============================================

            inventory_confiscated = {
                enabled = true,
                title = "📥 Inventory Confiscated",
                description = "Player's inventory has been stored for the horde match.",
                color = 16744448, -- Orange
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Item Count", value = "{itemCount} items", inline = true },
                    { name = "Method",     value = "{method}",     inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                    { name = "Items",      value = "{itemList}",   inline = false },
                },
            },

            inventory_restored = {
                enabled = true,
                title = "📤 Inventory Returned",
                description = "Player inventory has been returned after horde match ended.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Item Count", value = "{itemCount} items", inline = true },
                    { name = "Method",     value = "{method}",     inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                    { name = "Items",      value = "{itemList}",   inline = false },
                },
            },

            inventory_restore_failed = {
                enabled = true,
                title = "❌ Inventory Restore Failed",
                description = "Failed to restore player's inventory after horde match!",
                color = 15548997, -- Red
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Items Lost", value = "{itemCount}",  inline = true },
                    { name = "Method",     value = "{method}",     inline = true },
                    { name = "Items",      value = "{itemList}",   inline = false },
                },
            },

            -- ============================================
            -- SHOP & PURCHASE EVENTS
            -- ============================================

            shop_item_purchased = {
                enabled = true,
                title = "🛒 Item Purchased",
                description = "A player purchased an item from the shop.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Item",       value = "{item}",       inline = true },
                    { name = "Quantity",   value = "{quantity}",   inline = true },
                    { name = "Cost",       value = "{cost} coins", inline = true },
                    { name = "Balance",    value = "{balance}",    inline = true },
                    { name = "Round",      value = "{round}",      inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            shop_weapon_purchased = {
                enabled = true,
                title = "🔫 Weapon Purchased",
                description = "A player purchased a weapon from the shop.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Weapon",     value = "{weapon}",     inline = true },
                    { name = "Cost",       value = "{cost} coins", inline = true },
                    { name = "Balance",    value = "{balance}",    inline = true },
                    { name = "Round",      value = "{round}",      inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            shop_perk_purchased = {
                enabled = true,
                title = "⚡ Perk Purchased",
                description = "A player purchased a team perk from the shop.",
                color = 10494192, -- Purple
                fields = {
                    { name = "Player",     value = "{player}",      inline = true },
                    { name = "Identifier", value = "{identifier}",  inline = true },
                    { name = "Perk",       value = "{perk}",        inline = true },
                    { name = "Cost",       value = "{cost} coins",  inline = true },
                    { name = "Balance",    value = "{balance}",     inline = true },
                    { name = "Team Size",  value = "{playerCount}", inline = true },
                    { name = "Round",      value = "{round}",       inline = true },
                    { name = "Game ID",    value = "{gameId}",      inline = true },
                },
            },

            -- ============================================
            -- MYSTERY BOX EVENTS
            -- ============================================

            mystery_box_used = {
                enabled = true,
                title = "🎰 Mystery Box Used",
                description = "A player is spinning the mystery box!",
                color = 10494192, -- Purple
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Cost",       value = "{cost} coins", inline = true },
                    { name = "Balance",    value = "{balance}",    inline = true },
                    { name = "Round",      value = "{round}",      inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            mystery_box_weapon_received = {
                enabled = true,
                title = "🎁 Mystery Box Reward",
                description = "A player received a weapon from the mystery box!",
                color = 16766720, -- Gold
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Weapon",     value = "{weapon}",     inline = true },
                    { name = "Ammo",       value = "{ammoAmount}", inline = true },
                    { name = "Round",      value = "{round}",      inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            -- ============================================
            -- PERK EVENTS
            -- ============================================

            perk_vote_cast = {
                enabled = false, -- Disabled by default (can be noisy)
                title = "🗳️ Perk Vote Cast",
                description = "A player has cast their vote for a perk.",
                color = 10494192, -- Purple
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Voted For",  value = "{perk}",       inline = true },
                    { name = "Round",      value = "{round}",      inline = true },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            perk_applied = {
                enabled = true,
                title = "⚡ Perk Applied to Team",
                description = "A perk has been applied to all players.",
                color = 10494192, -- Purple
                fields = {
                    { name = "Perk",       value = "{perk}",        inline = true },
                    { name = "Team Size",  value = "{playerCount}", inline = true },
                    { name = "Source",     value = "{source}",      inline = true },
                    { name = "Round",      value = "{round}",       inline = true },
                    { name = "Game ID",    value = "{gameId}",      inline = true },
                },
            },

            -- ============================================
            -- ADMIN EVENTS
            -- ============================================

            admin_action = {
                enabled = true,
                title = "🛡️ Admin Action",
                description = "An administrator has performed an action.",
                color = 15548997, -- Red
                fields = {
                    { name = "Admin",      value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Action",     value = "{action}",     inline = true },
                    { name = "Details",    value = "{details}",    inline = false },
                    { name = "Game ID",    value = "{gameId}",     inline = true },
                },
            },

            -- ============================================
            -- ERROR EVENTS
            -- ============================================

            error_occurred = {
                enabled = true,
                title = "❌ Error Occurred",
                description = "An error has occurred in the horde system.",
                color = 15548997, -- Red
                fields = {
                    { name = "Error Type", value = "{errorType}", inline = true },
                    { name = "Details",    value = "{details}",   inline = false },
                    { name = "Player",     value = "{player}",    inline = true },
                    { name = "Game ID",    value = "{gameId}",    inline = true },
                },
            },
        },
    },
}
