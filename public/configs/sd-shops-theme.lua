return {
    -- Pick a built-in preset as the base: 'deepVoid', 'slateStorm', 'midnightBlue',
    -- 'purpleHaze', 'charcoalPro', 'carbonBlack', 'forestNight', 'roseGold',
    -- 'electricBlue', 'amberGlow'
    preset = 'deepVoid',

    -- Background pattern: 'none', 'grid', 'dots', 'cross', 'diagonal'
    pattern = 'grid',
    patternOpacity = 0.15,
    patternSize = '14px 14px',

    -- Scrollbar
    --[[
    scrollbar = {
        track = '#ff0000',
        thumb = '#00ff00',
        thumbHover = '#0000ff',
    },
    ]]

    -- Override individual preset colors (backgrounds, borders, text, accents)
    --[[
    overrides = {
        bgPrimary = '#1a0a2e',
        bgSecondary = '#2d1b4e',
        bgTertiary = '#3d2b5e',
        bgHover = '#4d3b6e',
        bgOverlay = 'rgba(26, 10, 46, 0.85)',
        borderPrimary = '#ff00ff',
        borderHover = '#ff66ff',
        textPrimary = '#00ffff',
        textSecondary = '#ffff00',
        textMuted = '#ff8800',
        accentPrimary = '#ff0066',
        accentHover = '#cc0052',
        accentBg = 'rgba(255, 0, 102, 0.15)',
        accentBorder = 'rgba(255, 0, 102, 0.4)',
    },
    ]]

    -- Semantic state colors (positive/negative values, warnings, info badges)
    --[[
    colors = {
        positive = '#ff0000',   -- Income amounts, success states, hired badges
        negative = '#39ff14',   -- Expense amounts, danger/error states, removed badges
        warning = '#ff00ff',    -- Warnings, pending states
        info = '#ffff00',       -- Informational badges, today highlight
    },
    ]]

    -- Tag/badge colors — each key needs only ONE hex color.
    -- Backgrounds (20% opacity) and borders (30% opacity) are auto-derived.
    --[[
    tags = {
        sale = '#ff0000',
        expense = '#00ff00',
        refund = '#0000ff',
        transfer = '#ffff00',
        deposit = '#ff00ff',
        withdrawal = '#00ffff',

        stockOrder = '#ff0000',
        stockCollected = '#39ff14',
        stockTransferIn = '#ff00ff',
        stockWithdraw = '#ffff00',
        stockManualAdjust = '#00ffff',

        inStock = '#ff0000',
        lowStock = '#ffff00',
        outOfStock = '#00ff00',

        actStock = '#0000ff',
        actSociety = '#ff0000',
        actPermission = '#00ff00',
        actLoyalty = '#ffff00',
        actCoupon = '#ff00ff',
        actSale = '#00ffff',
        actProduct = '#ff0000',
        actEmployee = '#39ff14',
        actCustomer = '#0000ff',
        actSettings = '#ff00ff',

        paymentCash = '#ff0000',
        paymentBank = '#0000ff',
        paymentSociety = '#00ff00',

        searchProduct = '#ff0000',
        searchSale = '#00ff00',
        searchCoupon = '#0000ff',
        searchEmployee = '#ffff00',
        searchCustomer = '#ff00ff',
        searchTransaction = '#00ffff',
        searchStock = '#ff0000',
        searchUpgrade = '#39ff14',
        searchReward = '#ff00ff',

        upgradePurple = '#ff0000',
        upgradePink = '#00ff00',
        upgradeCyan = '#ffff00',
    },
    ]]
}
