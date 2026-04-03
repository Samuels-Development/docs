--[[
    ============================================
    SD-SHOPS LOGGING CONFIGURATION
    ============================================

    This file configures the logging system for SD-Shops.
    You can customize every aspect of how logs appear.

    AVAILABLE PLACEHOLDERS FOR MESSAGES:
    ------------------------------------
    Player Info:
        {player}        - Player name with ID, e.g. "OOpium (ID: 272)"
        {playerName}    - Just the player name
        {playerId}      - Just the server ID
        {identifier}    - Player identifier (citizenid/license)
        {charName}      - Character name (firstname lastname)

    Shop Info:
        {shopId}        - The shop identifier
        {shopName}      - The shop display name
        {shopType}      - The shop type (general, gunstore, etc.)

    Transaction Info:
        {item}          - Item name/label
        {itemName}      - Raw item name
        {quantity}      - Quantity purchased/sold
        {price}         - Total price of transaction
        {unitPrice}     - Price per unit
        {currency}      - Currency type used (cash, bank, black_money)
        {balance}       - Player balance after transaction

    Event-Specific (varies by event):
        {reason}        - Reason for action
        {oldPrice}      - Previous price
        {newPrice}      - New price
        {purchasePrice} - Shop purchase price
        {refundAmount}  - Amount refunded
        {newOwner}      - New owner name
        {employeeName}  - Employee name
        {upgradeName}   - Upgrade name
        {upgradeLevel}  - Upgrade level

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

        -- SD-Shops Theme Colors --
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
            botName = 'Shop Logger',

            -- Bot avatar image URL (leave empty for default)
            botAvatar = '',

            -- Footer text shown on all embeds
            footerText = 'SD-Shops Logging',

            -- Footer icon URL (leave empty for none)
            footerIcon = '',

            -- How often to send batched logs (in seconds)
            -- Lower = more real-time, Higher = less Discord API calls
            flushInterval = 5,

            -- Tag @everyone for critical events?
            -- Events tagged: suspicious_activity, error_occurred
            tagEveryone = false,
        },

        -- ============================================
        -- FIVEMANAGE CONFIGURATION
        -- ============================================
        -- Only used when service = 'fivemanage'

        fivemanage = {
            -- Dataset ID for organizing logs
            dataset = 'sd-shops',
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
              │ 🛒 Item Purchased                   │ <- title
              │ A player purchased an item          │ <- description
              │                                     │
              │ Player: OOpium    Shop: 24/7 Store  │ <- inline fields
              │ Item: Water x5    Price: $25        │ <- inline fields
              └─────────────────────────────────────┘

            FIVEMANAGE / FIVEMERR / LOKI / GRAFANA:
            - Converted to plain text format
            - Title is used as the log title/label
            - Description + fields become the message body
            - 'color' and 'inline' are IGNORED
            - Example:
              [Title: 🛒 Item Purchased]
              A player purchased an item from a shop.

              Player: OOpium (ID: 272)
              Identifier: license:abc123
              Shop: 24/7 Store
              Item: Water x5
              Price: $25

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
            -- PURCHASE EVENTS
            -- ============================================

            item_purchased = {
                enabled = true,
                title = "🛒 Items Purchased",
                description = "A player has purchased items from a shop.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",             value = "{player}",            inline = true },
                    { name = "Identifier",         value = "{identifier}",        inline = true },
                    { name = "Character",          value = "{charName}",          inline = true },
                    { name = "Shop",               value = "{shopId}",            inline = true },
                    { name = "Shop Type",          value = "{shopType}",          inline = true },
                    { name = "Item Count",         value = "{itemCount}",         inline = true },
                    { name = "Items",              value = "{quantities}",        inline = false },
                    { name = "Prices",             value = "{prices}",            inline = false },
                    { name = "Subtotal",           value = "{subtotal}",          inline = true },
                    { name = "Membership Discount", value = "{membershipDiscount}", inline = true },
                    { name = "Membership Savings", value = "{membershipSavings}", inline = true },
                    { name = "Coupon Used",        value = "{couponCode}",        inline = true },
                    { name = "Coupon Discount",    value = "{couponDiscount}",    inline = true },
                    { name = "Coupon Savings",     value = "{couponSavings}",     inline = true },
                    { name = "Total",              value = "${totalPrice}",       inline = true },
                    { name = "Currency",           value = "{currency}",          inline = true },
                },
            },

            item_sold = {
                enabled = true,
                title = "💰 Item Sold",
                description = "A player has sold an item to a pawn shop.",
                color = 16766720, -- Gold
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Character",  value = "{charName}",   inline = true },
                    { name = "Shop",       value = "{shopId}",     inline = true },
                    { name = "Shop Type",  value = "{shopType}",   inline = true },
                    { name = "Item",       value = "{item}",       inline = true },
                    { name = "Quantity",   value = "{quantity}",   inline = true },
                    { name = "Received",   value = "${price}",     inline = true },
                    { name = "Currency",   value = "{currency}",   inline = true },
                },
            },

            purchase_failed = {
                enabled = true,
                title = "❌ Purchase Failed",
                description = "A purchase attempt has failed.",
                color = 15548997, -- Red
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Shop",       value = "{shopId}",     inline = true },
                    { name = "Shop Type",  value = "{shopType}",   inline = true },
                    { name = "Item",       value = "{item}",       inline = true },
                    { name = "Reason",     value = "{reason}",     inline = false },
                },
            },

            -- ============================================
            -- SHOP OWNERSHIP EVENTS
            -- ============================================

            shop_purchased = {
                enabled = true,
                title = "🏪 Shop Purchased",
                description = "A player has purchased a shop.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",        value = "{player}",        inline = true },
                    { name = "Identifier",    value = "{identifier}",    inline = true },
                    { name = "Character",     value = "{charName}",      inline = true },
                    { name = "Shop",          value = "{shopId}",        inline = true },
                    { name = "Shop Type",     value = "{shopType}",      inline = true },
                    { name = "Purchase Price", value = "${purchasePrice}", inline = true },
                    { name = "Payment Method", value = "{paymentMethod}", inline = true },
                },
            },

            shop_sold = {
                enabled = true,
                title = "🏷️ Shop Sold",
                description = "A player has sold their shop back to the city.",
                color = 16744448, -- Orange
                fields = {
                    { name = "Player",       value = "{player}",       inline = true },
                    { name = "Identifier",   value = "{identifier}",   inline = true },
                    { name = "Character",    value = "{charName}",     inline = true },
                    { name = "Shop",         value = "{shopId}",       inline = true },
                    { name = "Shop Type",    value = "{shopType}",     inline = true },
                    { name = "Refund Amount", value = "${refundAmount}", inline = true },
                },
            },

            shop_ownership_transferred = {
                enabled = true,
                title = "🔄 Shop Ownership Transferred",
                description = "Shop ownership has been transferred to another player.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Previous Owner", value = "{player}",          inline = true },
                    { name = "Identifier",     value = "{identifier}",      inline = true },
                    { name = "New Owner",      value = "{newOwner}",        inline = true },
                    { name = "New Identifier", value = "{newIdentifier}",   inline = true },
                    { name = "Shop",           value = "{shopId}",          inline = true },
                    { name = "Shop Type",      value = "{shopType}",        inline = true },
                },
            },

            -- ============================================
            -- PRODUCT MANAGEMENT EVENTS
            -- ============================================

            product_added = {
                enabled = true,
                title = "➕ Product Added",
                description = "A new product has been added to a shop.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",      value = "{player}",          inline = true },
                    { name = "Identifier",  value = "{identifier}",      inline = true },
                    { name = "Shop",        value = "{shopId}",          inline = true },
                    { name = "Item",        value = "{item}",            inline = true },
                    { name = "Price",       value = "${price}",          inline = true },
                    { name = "Category",    value = "{category}",        inline = true },
                    { name = "Restrictions", value = "{restrictions}",   inline = false },
                    { name = "License",     value = "{requiredLicense}", inline = true },
                },
            },

            product_removed = {
                enabled = true,
                title = "➖ Product Removed",
                description = "A product has been removed from a shop.",
                color = 15548997, -- Red
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Shop",       value = "{shopId}",     inline = true },
                    { name = "Item",       value = "{item}",       inline = true },
                },
            },

            price_changed = {
                enabled = true,
                title = "💵 Price Changed",
                description = "A shop owner has changed an item's price.",
                color = 16744448, -- Orange
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Shop",       value = "{shopId}",     inline = true },
                    { name = "Item",       value = "{item}",       inline = true },
                    { name = "Old Price",  value = "${oldPrice}",  inline = true },
                    { name = "New Price",  value = "${newPrice}",  inline = true },
                },
            },

            product_edited = {
                enabled = true,
                title = "✏️ Product Edited",
                description = "A product has been edited in a shop.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Player",           value = "{player}",          inline = true },
                    { name = "Identifier",       value = "{identifier}",      inline = true },
                    { name = "Shop",             value = "{shopId}",          inline = true },
                    { name = "Item",             value = "{item}",            inline = true },
                    { name = "Changes",          value = "{changes}",         inline = false },
                    { name = "Old Price",        value = "${oldPrice}",       inline = true },
                    { name = "New Price",        value = "${newPrice}",       inline = true },
                    { name = "Old Category",     value = "{oldCategory}",     inline = true },
                    { name = "New Category",     value = "{newCategory}",     inline = true },
                    { name = "Old Restrictions", value = "{oldRestrictions}", inline = false },
                    { name = "New Restrictions", value = "{newRestrictions}", inline = false },
                    { name = "Old License",      value = "{oldLicense}",      inline = true },
                    { name = "New License",      value = "{newLicense}",      inline = true },
                },
            },

            -- ============================================
            -- STOCK MANAGEMENT EVENTS
            -- ============================================

            stock_restocked = {
                enabled = true,
                title = "📦 Stock Restocked",
                description = "A shop owner has restocked inventory.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Shop",       value = "{shopId}",     inline = true },
                    { name = "Item",       value = "{item}",       inline = true },
                    { name = "Quantity",   value = "{quantity}",   inline = true },
                    { name = "Cost",       value = "${price}",     inline = true },
                },
            },

            stock_deposited = {
                enabled = true,
                title = "📥 Stock Deposited",
                description = "Items have been deposited from player inventory to shop stock.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",         value = "{player}",        inline = true },
                    { name = "Identifier",     value = "{identifier}",    inline = true },
                    { name = "Shop",           value = "{shopId}",        inline = true },
                    { name = "Item",           value = "{item}",          inline = true },
                    { name = "Quantity",       value = "{quantity}",      inline = true },
                    { name = "Previous Stock", value = "{previousStock}", inline = true },
                    { name = "New Stock",      value = "{newStock}",      inline = true },
                },
            },

            stock_withdrawn = {
                enabled = true,
                title = "📤 Stock Withdrawn",
                description = "Items have been withdrawn from shop stock to player inventory.",
                color = 16744448, -- Orange
                fields = {
                    { name = "Player",         value = "{player}",        inline = true },
                    { name = "Identifier",     value = "{identifier}",    inline = true },
                    { name = "Shop",           value = "{shopId}",        inline = true },
                    { name = "Item",           value = "{item}",          inline = true },
                    { name = "Quantity",       value = "{quantity}",      inline = true },
                    { name = "Previous Stock", value = "{previousStock}", inline = true },
                    { name = "New Stock",      value = "{newStock}",      inline = true },
                },
            },

            -- ============================================
            -- EMPLOYEE EVENTS
            -- ============================================

            employee_added = {
                enabled = true,
                title = "👤 Employee Added",
                description = "A new employee has been added to a shop.",
                color = 5763719, -- Green
                fields = {
                    { name = "Added By",         value = "{player}",             inline = true },
                    { name = "Identifier",       value = "{identifier}",         inline = true },
                    { name = "Shop",             value = "{shopId}",             inline = true },
                    { name = "Employee",         value = "{employeeName}",       inline = true },
                    { name = "Employee ID",      value = "{employeeIdentifier}", inline = true },
                    { name = "Permissions",      value = "{permissions}",        inline = false },
                },
            },

            employee_removed = {
                enabled = true,
                title = "👤 Employee Removed",
                description = "An employee has been removed from a shop.",
                color = 15548997, -- Red
                fields = {
                    { name = "Removed By",       value = "{player}",             inline = true },
                    { name = "Identifier",       value = "{identifier}",         inline = true },
                    { name = "Shop",             value = "{shopId}",             inline = true },
                    { name = "Employee",         value = "{employeeName}",       inline = true },
                    { name = "Employee ID",      value = "{employeeIdentifier}", inline = true },
                    { name = "Permissions Had",  value = "{permissions}",        inline = false },
                    { name = "Reason",           value = "{reason}",             inline = false },
                },
            },

            employee_edited = {
                enabled = true,
                title = "✏️ Employee Edited",
                description = "An employee's permissions have been updated.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Edited By",            value = "{player}",             inline = true },
                    { name = "Identifier",           value = "{identifier}",         inline = true },
                    { name = "Shop",                 value = "{shopId}",             inline = true },
                    { name = "Employee",             value = "{employeeName}",       inline = true },
                    { name = "Employee ID",          value = "{employeeIdentifier}", inline = true },
                    { name = "Old Permissions",      value = "{oldPermissions}",     inline = false },
                    { name = "New Permissions",      value = "{newPermissions}",     inline = false },
                    { name = "Permissions Added",    value = "{addedPermissions}",   inline = true },
                    { name = "Permissions Removed",  value = "{removedPermissions}", inline = true },
                },
            },

            employee_profile_picture_updated = {
                enabled = true,
                title = "📷 Profile Picture Updated",
                description = "An employee's profile picture has been updated.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Updated By",       value = "{player}",             inline = true },
                    { name = "Identifier",       value = "{identifier}",         inline = true },
                    { name = "Shop",             value = "{shopId}",             inline = true },
                    { name = "Target",           value = "{targetName}",         inline = true },
                    { name = "Target ID",        value = "{targetIdentifier}",   inline = true },
                    { name = "Is Owner",         value = "{isOwner}",            inline = true },
                    { name = "Image URL",        value = "{imageUrl}",           inline = false },
                },
            },

            -- ============================================
            -- SALE EVENTS
            -- ============================================

            sale_created = {
                enabled = true,
                title = "🏷️ Sale Created",
                description = "A new sale has been created.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",       value = "{player}",       inline = true },
                    { name = "Identifier",   value = "{identifier}",   inline = true },
                    { name = "Shop",         value = "{shopId}",       inline = true },
                    { name = "Sale Name",    value = "{saleName}",     inline = true },
                    { name = "Discount",     value = "{discount}%",    inline = true },
                    { name = "Status",       value = "{isActive}",     inline = true },
                    { name = "Start Date",   value = "{startDate}",    inline = true },
                    { name = "End Date",     value = "{endDate}",      inline = true },
                    { name = "Description",  value = "{description}",  inline = false },
                    { name = "Applies To",   value = "{appliesTo}",    inline = false },
                    { name = "Restrictions", value = "{restrictions}", inline = false },
                },
            },

            sale_edited = {
                enabled = true,
                title = "✏️ Sale Edited",
                description = "A sale has been edited.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Player",           value = "{player}",          inline = true },
                    { name = "Identifier",       value = "{identifier}",      inline = true },
                    { name = "Shop",             value = "{shopId}",          inline = true },
                    { name = "Sale Name",        value = "{saleName}",        inline = true },
                    { name = "Changes",          value = "{changes}",         inline = false },
                    { name = "Old Discount",     value = "{oldDiscount}%",    inline = true },
                    { name = "New Discount",     value = "{newDiscount}%",    inline = true },
                    { name = "Old Status",       value = "{oldStatus}",       inline = true },
                    { name = "New Status",       value = "{newStatus}",       inline = true },
                    { name = "Old Dates",        value = "{oldStartDate} - {oldEndDate}", inline = true },
                    { name = "New Dates",        value = "{newStartDate} - {newEndDate}", inline = true },
                    { name = "Old Applies To",   value = "{oldAppliesTo}",    inline = false },
                    { name = "New Applies To",   value = "{newAppliesTo}",    inline = false },
                    { name = "Old Restrictions", value = "{oldRestrictions}", inline = false },
                    { name = "New Restrictions", value = "{newRestrictions}", inline = false },
                },
            },

            sale_toggled = {
                enabled = true,
                title = "🔄 Sale Toggled",
                description = "A sale's active status has been toggled.",
                color = 16744448, -- Orange
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Shop",       value = "{shopId}",     inline = true },
                    { name = "Sale Name",  value = "{saleName}",   inline = true },
                    { name = "Old Status", value = "{oldStatus}",  inline = true },
                    { name = "New Status", value = "{newStatus}",  inline = true },
                },
            },

            sale_deleted = {
                enabled = true,
                title = "🗑️ Sale Deleted",
                description = "A sale has been deleted.",
                color = 15548997, -- Red
                fields = {
                    { name = "Player",       value = "{player}",       inline = true },
                    { name = "Identifier",   value = "{identifier}",   inline = true },
                    { name = "Shop",         value = "{shopId}",       inline = true },
                    { name = "Sale Name",    value = "{saleName}",     inline = true },
                    { name = "Discount",     value = "{discount}%",    inline = true },
                    { name = "Was Active",   value = "{wasActive}",    inline = true },
                    { name = "Start Date",   value = "{startDate}",    inline = true },
                    { name = "End Date",     value = "{endDate}",      inline = true },
                    { name = "Description",  value = "{description}",  inline = false },
                    { name = "Applied To",   value = "{appliesTo}",    inline = false },
                    { name = "Restrictions", value = "{restrictions}", inline = false },
                },
            },

            -- ============================================
            -- COUPON EVENTS
            -- ============================================

            coupon_created = {
                enabled = true,
                title = "🎟️ Coupon Created",
                description = "A new coupon has been created.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",            value = "{player}",            inline = true },
                    { name = "Identifier",        value = "{identifier}",        inline = true },
                    { name = "Shop",              value = "{shopId}",            inline = true },
                    { name = "Coupon Code",       value = "{couponCode}",        inline = true },
                    { name = "Discount",          value = "{discount}%",         inline = true },
                    { name = "Status",            value = "{isActive}",          inline = true },
                    { name = "Max Uses",          value = "{maxUses}",           inline = true },
                    { name = "Max Per Person",    value = "{maxUsesPerPerson}",  inline = true },
                    { name = "Start Date",        value = "{startDate}",         inline = true },
                    { name = "Expiry Date",       value = "{expiryDate}",        inline = true },
                    { name = "Min Purchase",      value = "${minPurchaseAmount}", inline = true },
                    { name = "Max Discount",      value = "${maxDiscountAmount}", inline = true },
                    { name = "Description",       value = "{description}",       inline = false },
                    { name = "Applies To",        value = "{appliesTo}",         inline = false },
                    { name = "Restrictions",      value = "{restrictions}",      inline = false },
                    { name = "Global Reset",      value = "{globalUsageReset}",  inline = true },
                    { name = "Personal Reset",    value = "{personalUsageReset}", inline = true },
                },
            },

            coupon_edited = {
                enabled = true,
                title = "✏️ Coupon Edited",
                description = "A coupon has been edited.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Player",            value = "{player}",           inline = true },
                    { name = "Identifier",        value = "{identifier}",       inline = true },
                    { name = "Shop",              value = "{shopId}",           inline = true },
                    { name = "Coupon Code",       value = "{couponCode}",       inline = true },
                    { name = "Changes",           value = "{changes}",          inline = false },
                    { name = "Old Discount",      value = "{oldDiscount}%",     inline = true },
                    { name = "New Discount",      value = "{newDiscount}%",     inline = true },
                    { name = "Old Status",        value = "{oldStatus}",        inline = true },
                    { name = "New Status",        value = "{newStatus}",        inline = true },
                    { name = "Old Max Uses",      value = "{oldMaxUses}",       inline = true },
                    { name = "New Max Uses",      value = "{newMaxUses}",       inline = true },
                    { name = "Old Start",         value = "{oldStartDate}",     inline = true },
                    { name = "New Start",         value = "{newStartDate}",     inline = true },
                    { name = "Old Expiry",        value = "{oldExpiryDate}",    inline = true },
                    { name = "New Expiry",        value = "{newExpiryDate}",    inline = true },
                    { name = "Old Min Purchase",  value = "${oldMinPurchase}",  inline = true },
                    { name = "New Min Purchase",  value = "${newMinPurchase}",  inline = true },
                    { name = "Old Applies To",    value = "{oldAppliesTo}",     inline = false },
                    { name = "New Applies To",    value = "{newAppliesTo}",     inline = false },
                    { name = "Old Restrictions",  value = "{oldRestrictions}",  inline = false },
                    { name = "New Restrictions",  value = "{newRestrictions}",  inline = false },
                },
            },

            coupon_toggled = {
                enabled = true,
                title = "🔄 Coupon Toggled",
                description = "A coupon's active status has been toggled.",
                color = 16744448, -- Orange
                fields = {
                    { name = "Player",      value = "{player}",     inline = true },
                    { name = "Identifier",  value = "{identifier}", inline = true },
                    { name = "Shop",        value = "{shopId}",     inline = true },
                    { name = "Coupon Code", value = "{couponCode}", inline = true },
                    { name = "Old Status",  value = "{oldStatus}",  inline = true },
                    { name = "New Status",  value = "{newStatus}",  inline = true },
                },
            },

            coupon_deleted = {
                enabled = true,
                title = "🗑️ Coupon Deleted",
                description = "A coupon has been deleted.",
                color = 15548997, -- Red
                fields = {
                    { name = "Player",         value = "{player}",            inline = true },
                    { name = "Identifier",     value = "{identifier}",        inline = true },
                    { name = "Shop",           value = "{shopId}",            inline = true },
                    { name = "Coupon Code",    value = "{couponCode}",        inline = true },
                    { name = "Discount",       value = "{discount}%",         inline = true },
                    { name = "Was Active",     value = "{wasActive}",         inline = true },
                    { name = "Times Used",     value = "{timesUsed}",         inline = true },
                    { name = "Max Uses",       value = "{maxUses}",           inline = true },
                    { name = "Start Date",     value = "{startDate}",         inline = true },
                    { name = "Expiry Date",    value = "{expiryDate}",        inline = true },
                    { name = "Min Purchase",   value = "${minPurchaseAmount}", inline = true },
                    { name = "Max Discount",   value = "${maxDiscountAmount}", inline = true },
                    { name = "Description",    value = "{description}",       inline = false },
                    { name = "Applied To",     value = "{appliesTo}",         inline = false },
                    { name = "Restrictions",   value = "{restrictions}",      inline = false },
                },
            },

            -- ============================================
            -- SETTINGS EVENTS
            -- ============================================

            settings_changed = {
                enabled = true,
                title = "⚙️ Store Settings Changed",
                description = "Store settings have been modified.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Player",            value = "{player}",           inline = true },
                    { name = "Identifier",        value = "{identifier}",       inline = true },
                    { name = "Shop",              value = "{shopId}",           inline = true },
                    { name = "Changes",           value = "{changes}",          inline = false },
                    { name = "Old Shop Name",     value = "{oldShopName}",      inline = true },
                    { name = "New Shop Name",     value = "{newShopName}",      inline = true },
                    { name = "Old Blip Status",   value = "{oldBlipEnabled}",   inline = true },
                    { name = "New Blip Status",   value = "{newBlipEnabled}",   inline = true },
                    { name = "Old Blip Color",    value = "{oldBlipColor}",     inline = true },
                    { name = "New Blip Color",    value = "{newBlipColor}",     inline = true },
                    { name = "Old Blip Sprite",   value = "{oldBlipSprite}",    inline = true },
                    { name = "New Blip Sprite",   value = "{newBlipSprite}",    inline = true },
                    { name = "Old Opening Hours", value = "{oldOpeningHours}",  inline = true },
                    { name = "New Opening Hours", value = "{newOpeningHours}",  inline = true },
                },
            },

            -- ============================================
            -- LOYALTY PROGRAM EVENTS
            -- ============================================

            loyalty_settings_changed = {
                enabled = true,
                title = "🎯 Loyalty Settings Changed",
                description = "Loyalty program settings have been modified.",
                color = 10494192, -- Purple
                fields = {
                    { name = "Player",            value = "{player}",           inline = true },
                    { name = "Identifier",        value = "{identifier}",       inline = true },
                    { name = "Shop",              value = "{shopId}",           inline = true },
                    { name = "Changes",           value = "{changes}",          inline = false },
                    { name = "Old Status",        value = "{oldEnabled}",       inline = true },
                    { name = "New Status",        value = "{newEnabled}",       inline = true },
                    { name = "Old Points/Dollar", value = "{oldPointsPerDollar}", inline = true },
                    { name = "New Points/Dollar", value = "{newPointsPerDollar}", inline = true },
                    { name = "Old Tier Mode",     value = "{oldTierMode}",      inline = true },
                    { name = "New Tier Mode",     value = "{newTierMode}",      inline = true },
                },
            },

            loyalty_tiers_changed = {
                enabled = true,
                title = "📊 Loyalty Tiers Changed",
                description = "Loyalty tier thresholds have been modified.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Player",        value = "{player}",        inline = true },
                    { name = "Identifier",    value = "{identifier}",    inline = true },
                    { name = "Shop",          value = "{shopId}",        inline = true },
                    { name = "Changes",       value = "{changes}",       inline = false },
                    { name = "Tier Count",    value = "{tierCount}",     inline = true },
                    { name = "Tier Details",  value = "{tierDetails}",   inline = false },
                },
            },

            loyalty_reward_created = {
                enabled = true,
                title = "🎁 Loyalty Reward Created",
                description = "A new loyalty reward has been created.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",         value = "{player}",         inline = true },
                    { name = "Identifier",     value = "{identifier}",     inline = true },
                    { name = "Shop",           value = "{shopId}",         inline = true },
                    { name = "Reward Name",    value = "{rewardName}",     inline = true },
                    { name = "Points Cost",    value = "{pointsCost}",     inline = true },
                    { name = "Discount",       value = "{discount}%",      inline = true },
                    { name = "Required Tier",  value = "{requiredTier}",   inline = true },
                    { name = "Status",         value = "{status}",         inline = true },
                    { name = "Description",    value = "{description}",    inline = false },
                },
            },

            loyalty_reward_edited = {
                enabled = true,
                title = "✏️ Loyalty Reward Edited",
                description = "A loyalty reward has been edited.",
                color = 5793266, -- Blurple
                fields = {
                    { name = "Player",           value = "{player}",           inline = true },
                    { name = "Identifier",       value = "{identifier}",       inline = true },
                    { name = "Shop",             value = "{shopId}",           inline = true },
                    { name = "Reward Name",      value = "{rewardName}",       inline = true },
                    { name = "Changes",          value = "{changes}",          inline = false },
                    { name = "Old Points Cost",  value = "{oldPointsCost}",    inline = true },
                    { name = "New Points Cost",  value = "{newPointsCost}",    inline = true },
                    { name = "Old Discount",     value = "{oldDiscount}%",     inline = true },
                    { name = "New Discount",     value = "{newDiscount}%",     inline = true },
                    { name = "Old Tier",         value = "{oldRequiredTier}",  inline = true },
                    { name = "New Tier",         value = "{newRequiredTier}",  inline = true },
                    { name = "Old Status",       value = "{oldStatus}",        inline = true },
                    { name = "New Status",       value = "{newStatus}",        inline = true },
                },
            },

            loyalty_reward_toggled = {
                enabled = true,
                title = "🔄 Loyalty Reward Toggled",
                description = "A loyalty reward's active status has been toggled.",
                color = 16744448, -- Orange
                fields = {
                    { name = "Player",        value = "{player}",       inline = true },
                    { name = "Identifier",    value = "{identifier}",   inline = true },
                    { name = "Shop",          value = "{shopId}",       inline = true },
                    { name = "Reward Name",   value = "{rewardName}",   inline = true },
                    { name = "Points Cost",   value = "{pointsCost}",   inline = true },
                    { name = "Discount",      value = "{discount}%",    inline = true },
                    { name = "Old Status",    value = "{oldStatus}",    inline = true },
                    { name = "New Status",    value = "{newStatus}",    inline = true },
                },
            },

            loyalty_reward_deleted = {
                enabled = true,
                title = "🗑️ Loyalty Reward Deleted",
                description = "A loyalty reward has been deleted.",
                color = 15548997, -- Red
                fields = {
                    { name = "Player",          value = "{player}",         inline = true },
                    { name = "Identifier",      value = "{identifier}",     inline = true },
                    { name = "Shop",            value = "{shopId}",         inline = true },
                    { name = "Reward Name",     value = "{rewardName}",     inline = true },
                    { name = "Points Cost",     value = "{pointsCost}",     inline = true },
                    { name = "Discount",        value = "{discount}%",      inline = true },
                    { name = "Required Tier",   value = "{requiredTier}",   inline = true },
                    { name = "Times Redeemed",  value = "{timesRedeemed}",  inline = true },
                    { name = "Description",     value = "{description}",    inline = false },
                },
            },

            loyalty_reward_redeemed = {
                enabled = true,
                title = "🎁 Loyalty Reward Redeemed",
                description = "A customer has redeemed a loyalty reward.",
                color = 16766720, -- Gold
                fields = {
                    { name = "Player",          value = "{player}",         inline = true },
                    { name = "Identifier",      value = "{identifier}",     inline = true },
                    { name = "Character",       value = "{charName}",       inline = true },
                    { name = "Shop",            value = "{shopId}",         inline = true },
                    { name = "Reward Name",     value = "{rewardName}",     inline = true },
                    { name = "Discount",        value = "{discount}%",      inline = true },
                    { name = "Points Spent",    value = "{pointsSpent}",    inline = true },
                    { name = "Previous Points", value = "{previousPoints}", inline = true },
                    { name = "New Points",      value = "{newPoints}",      inline = true },
                    { name = "Coupon Code",     value = "{couponCode}",     inline = true },
                },
            },

            -- ============================================
            -- UPGRADE EVENTS
            -- ============================================

            upgrade_purchased = {
                enabled = true,
                title = "⬆️ Upgrade Purchased",
                description = "A shop upgrade has been purchased.",
                color = 10494192, -- Purple
                fields = {
                    { name = "Player",         value = "{player}",        inline = true },
                    { name = "Identifier",     value = "{identifier}",    inline = true },
                    { name = "Shop",           value = "{shopId}",        inline = true },
                    { name = "Upgrade",        value = "{upgradeName}",   inline = true },
                    { name = "Level",          value = "{oldLevel} → {newLevel}", inline = true },
                    { name = "Cost",           value = "${upgradeCost}",  inline = true },
                    { name = "Payment Method", value = "{paymentMethod}", inline = true },
                },
            },

            -- ============================================
            -- SOCIETY/FINANCE EVENTS
            -- ============================================

            society_deposit = {
                enabled = true,
                title = "🏦 Society Deposit",
                description = "Money has been deposited to a shop's society account.",
                color = 5763719, -- Green
                fields = {
                    { name = "Player",           value = "{player}",          inline = true },
                    { name = "Identifier",       value = "{identifier}",      inline = true },
                    { name = "Character",        value = "{charName}",        inline = true },
                    { name = "Shop",             value = "{shopId}",          inline = true },
                    { name = "Amount",           value = "${amount}",         inline = true },
                    { name = "Method",           value = "{depositMethod}",   inline = true },
                    { name = "Previous Balance", value = "${previousBalance}", inline = true },
                    { name = "New Balance",      value = "${newBalance}",     inline = true },
                },
            },

            society_withdrawal = {
                enabled = true,
                title = "🏦 Society Withdrawal",
                description = "Money has been withdrawn from a shop's society account.",
                color = 16744448, -- Orange
                fields = {
                    { name = "Player",           value = "{player}",            inline = true },
                    { name = "Identifier",       value = "{identifier}",        inline = true },
                    { name = "Character",        value = "{charName}",          inline = true },
                    { name = "Shop",             value = "{shopId}",            inline = true },
                    { name = "Amount",           value = "${amount}",           inline = true },
                    { name = "Method",           value = "{withdrawalMethod}",  inline = true },
                    { name = "Previous Balance", value = "${previousBalance}",  inline = true },
                    { name = "New Balance",      value = "${newBalance}",       inline = true },
                },
            },

            -- ============================================
            -- ERROR & SECURITY EVENTS
            -- ============================================

            suspicious_activity = {
                enabled = true,
                title = "⚠️ Suspicious Activity",
                description = "Potentially suspicious shop activity has been detected.",
                color = 16776960, -- Yellow
                fields = {
                    { name = "Player",     value = "{player}",     inline = true },
                    { name = "Identifier", value = "{identifier}", inline = true },
                    { name = "Shop",       value = "{shopId}",     inline = true },
                    { name = "Activity",   value = "{activity}",   inline = false },
                    { name = "Details",    value = "{details}",    inline = false },
                },
            },

            error_occurred = {
                enabled = true,
                title = "❌ Error Occurred",
                description = "An error has occurred in the shop system.",
                color = 15548997, -- Red
                fields = {
                    { name = "Error Type", value = "{errorType}", inline = true },
                    { name = "Details",    value = "{details}",   inline = false },
                    { name = "Player",     value = "{player}",    inline = true },
                    { name = "Shop",       value = "{shopId}",    inline = true },
                },
            },
        },
    },
}
