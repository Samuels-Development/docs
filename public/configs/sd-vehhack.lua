-- =============================================================================
--  SD-VEHHACK / Configuration
-- =============================================================================
--  Everything you need to tune this script lives in this file.
--  After any change, restart the resource:  restart sd-vehhack
-- =============================================================================

return {

    -- ─────────────────────────────────────────────────────────────────────────
    --  GENERAL
    -- ─────────────────────────────────────────────────────────────────────────

    Locale         = 'en',           -- locale file in locales/<code>.json
    AccentColor    = '4ade80',       -- UI accent (hex, no '#')
    DebugPrints    = false,          -- set true to log validation steps

    -- ─────────────────────────────────────────────────────────────────────────
    --  ITEMS & CURRENCY
    -- ─────────────────────────────────────────────────────────────────────────
    --  HackingItem : the device item (e.g. phone plug). Triggers the UI when used.
    --                Set to nil if you want to gate entry to /testhackui only.
    --  ConsumeOnUse: true = item deleted on every use. Keep false for a reusable
    --                dongle where SIMs are the real consumable.
    --  CurrencyItem: the stackable item spent per hack. nil = use cash balance.
    --  CurrencyLabel: short text shown in the UI next to the balance.

    HackingItem    = 'phone_plug',
    ConsumeOnUse   = false,
    CurrencyItem   = 'hacking_sim',
    CurrencyLabel  = 'SIMS',

    -- ─────────────────────────────────────────────────────────────────────────
    --  TARGETING
    -- ─────────────────────────────────────────────────────────────────────────
    --  MaxTargetDistance      : camera raycast reach. Must be ≥ the largest
    --                           per-class limit below (otherwise heli targeting
    --                           can't physically reach at range).
    --  MaxTargetDistanceCar   : lock/execute range for cars, bikes, boats
    --  MaxTargetDistanceHeli  : lock/execute range for helicopters
    --  OutlineColor           : RGBA for the selected-vehicle outline

    MaxTargetDistance     = 150.0,
    MaxTargetDistanceCar  = 30.0,
    MaxTargetDistanceHeli = 150.0,
    OutlineColor          = { r = 74, g = 222, b = 128, a = 255 },

    -- ─────────────────────────────────────────────────────────────────────────
    --  HACK EXECUTION
    -- ─────────────────────────────────────────────────────────────────────────
    --  HackCooldown     : seconds a player must wait between any two hacks.
    --  UseProgressBar   : show the "executing…" bar after confirming a hack.
    --  ProgressDuration : how long that bar takes to fill, in ms.

    HackCooldown     = 5,
    UseProgressBar   = true,
    ProgressDuration = 3000,

    -- Logging is configured separately in configs/logs.lua — supports Discord,
    -- Fivemanage, Fivemerr, Loki, and Grafana. Set the `service` field there
    -- to enable it. Default is 'none'.

    -- ─────────────────────────────────────────────────────────────────────────
    --  EMERGENCY VEHICLES
    -- ─────────────────────────────────────────────────────────────────────────
    --  When OWNER_SCAN runs on an unowned vehicle whose model appears in one
    --  of these lists, the card shows a department label (e.g. "POLICE") instead
    --  of a fake randomised name. If the vehicle IS owned by a real player, the
    --  player's name is still used — ownership wins.
    --
    --  Add your server's custom emergency vehicle spawn names to the right list.

    EmergencyVehicles = {
        POLICE = {
            'police', 'police2', 'police3', 'police4', 'policeb', 'policet',
            'policeold1', 'policeold2', 'sheriff', 'sheriff2',
            'fbi', 'fbi2', 'riot', 'riot2', 'pranger', 'predator',
        },
        EMS = {
            'ambulance',
        },
        FIRE = {
            'firetruk',
        },
    },

    -- ═════════════════════════════════════════════════════════════════════════
    --  HACKS LIST
    -- ═════════════════════════════════════════════════════════════════════════
    --  Add, remove, or tweak hacks here. Each entry is a table with these fields:
    --
    --    id          (string)  UNIQUE identifier. Used in code — do not duplicate.
    --    enabled     (bool)    false = hidden from menu & rejected server-side.
    --    label       (string)  Text shown on the button.
    --    icon        (string)  Lucide icon name. See web/src/App.tsx iconMap for
    --                          the supported list (add new imports there to extend).
    --    cost        (number)  SIMs (or cash) spent on success.
    --    duration    (number)  Effect length in ms. 0 = instant / permanent.
    --    description (string)  Tooltip text (reserved for future UI use).
    --    applies     (string)  Which vehicle class the hack works on:
    --                            'car'  → cars + bikes (ground vehicles)
    --                            'heli' → helicopters only
    --                            nil    → any vehicle
    --    excludes    (table)   Optional list of classes to block, e.g. { 'bike' }.
    --    category    (string)  UI tab: 'sabotage' | 'control' | 'chaos' | 'intel'.
    --    sound       (string)  Success sound. One of:
    --                            'success' | 'activate' | 'select' |
    --                            'target_lock' | 'targeting_start' | 'explode'
    --
    --  ─── How to DISABLE a hack ───
    --    Flip `enabled = false` on that line. It stays in the file but is hidden.
    --
    --  ─── How to REMOVE a hack permanently ───
    --    Delete its line here AND (optionally) its handler block in
    --    client/main.lua inside the RegisterNetEvent('sd-hacking:client:ApplyHack'
    --    ...) function. Unused handlers do no harm if left in.
    --
    --  ─── How to ADD a new hack ───
    --    1. Add a new entry below with a unique `id`.
    --    2. Open client/main.lua → find the 'RegisterNetEvent(..:ApplyHack..'
    --       block → add your `elseif hackId == 'your_id' then` branch with
    --       the in-game effect (native calls on the vehicle).
    --    3. If you used a new icon, import it in web/src/App.tsx and add it to
    --       the iconMap, then `npm run build` inside /web.
    --
    --  Cost tiers (guidance, not enforced):
    --    5-10   trivial   20-40  mid       100+   serious
    --    10-20  cheap     40-75  heavy
    -- ═════════════════════════════════════════════════════════════════════════

    Hacks = {

        -- ── Trivial (5-10) ─────────────────────────────────────────────────
        {
            id          = 'honk_loop',
            enabled     = true,
            label       = 'HONK_HORN',
            icon        = 'megaphone',
            cost        = 5,
            duration    = 30000,
            description = 'Jam the horn on the target vehicle',
            category    = 'chaos',
            sound       = 'activate',
        },
        {
            id          = 'open_hood',
            enabled     = true,
            label       = 'OPEN_HOOD',
            icon        = 'wrench',
            cost        = 5,
            duration    = 0,
            description = 'Unlock and pop the hood',
            applies     = 'car',
            excludes    = { 'bike' },
            category    = 'control',
            sound       = 'select',
        },
        {
            id          = 'open_doors',
            enabled     = true,
            label       = 'OPEN_DOORS',
            icon        = 'door-open',
            cost        = 8,
            duration    = 0,
            description = 'Unlock and open all vehicle doors',
            excludes    = { 'bike' },
            category    = 'control',
            sound       = 'select',
        },
        {
            id          = 'alarm_trigger',
            enabled     = true,
            label       = 'TRIGGER_ALARM',
            icon        = 'bell',
            cost        = 10,
            duration    = 30000,
            description = 'Trigger the vehicle alarm',
            applies     = 'car',
            category    = 'chaos',
            sound       = 'activate',
        },
        {
            id          = 'owner_scan',
            enabled     = true,
            label       = 'OWNER_SCAN',
            icon        = 'fingerprint',
            cost        = 10,
            duration    = 0,
            description = 'Look up the registered owner of a vehicle',
            category    = 'intel',
            sound       = 'activate',
        },

        -- ── Cheap control (15-25) ──────────────────────────────────────────
        {
            id          = 'steer_right',
            enabled     = true,
            label       = 'STEER_RIGHT',
            icon        = 'arrow-right',
            cost        = 20,
            duration    = 3000,
            description = 'Force the vehicle to steer right',
            applies     = 'car',
            category    = 'control',
            sound       = 'target_lock',
        },
        {
            id          = 'steer_left',
            enabled     = true,
            label       = 'STEER_LEFT',
            icon        = 'arrow-left',
            cost        = 20,
            duration    = 3000,
            description = 'Force the vehicle to steer left',
            applies     = 'car',
            category    = 'control',
            sound       = 'target_lock',
        },
        {
            id          = 'smoke_screen',
            enabled     = true,
            label       = 'SMOKE_SCREEN',
            icon        = 'cloud',
            cost        = 20,
            duration    = 60000,
            description = 'Release a thick smoke screen from the exhaust',
            category    = 'chaos',
            sound       = 'targeting_start',
        },
        {
            id          = 'pop_tires',
            enabled     = true,
            label       = 'POP_TIRES',
            icon        = 'circle-x',
            cost        = 25,
            duration    = 0,
            description = 'Pop all tires on the target vehicle',
            applies     = 'car',
            category    = 'sabotage',
            sound       = 'success',
        },

        -- ── Mid disruption (30-50) ─────────────────────────────────────────
        {
            id          = 'lock_steering',
            enabled     = true,
            label       = 'LOCK_STEERING',
            icon        = 'lock',
            cost        = 30,
            duration    = 5000,
            description = 'Lock the steering wheel so the vehicle cannot turn',
            applies     = 'car',
            category    = 'control',
            sound       = 'target_lock',
        },
        {
            id          = 'fuel_leak',
            enabled     = true,
            label       = 'FUEL_LEAK',
            icon        = 'droplet',
            cost        = 40,
            duration    = 20000,
            description = 'Puncture the fuel tank — slow leak + health drain',
            category    = 'sabotage',
            sound       = 'success',
        },
        {
            id          = 'force_hover',
            enabled     = true,
            label       = 'PULL_UP',
            icon        = 'wind',
            cost        = 45,
            duration    = 15000,
            description = 'Force the helicopter to pull up and hover',
            applies     = 'heli',
            category    = 'control',
            sound       = 'activate',
        },
        {
            id          = 'deploy_brakes',
            enabled     = true,
            label       = 'DEPLOY_BRAKES',
            icon        = 'octagon',
            cost        = 50,
            duration    = 15000,
            description = 'Slam the brakes for 15 seconds',
            applies     = 'car',
            category    = 'control',
            sound       = 'target_lock',
        },

        -- ── Heavy (60-75) ──────────────────────────────────────────────────
        {
            id          = 'disable_engine',
            enabled     = true,
            label       = 'DISABLE_ENGINE',
            icon        = 'power-off',
            cost        = 60,
            duration    = 0,
            description = 'Kill the engine until the vehicle is repaired',
            applies     = 'car',
            category    = 'sabotage',
            sound       = 'success',
        },

        -- ── Top-tier (100-150) ─────────────────────────────────────────────
        {
            id          = 'disable_rotor',
            enabled     = true,
            label       = 'DISABLE_ROTOR',
            icon        = 'fan',
            cost        = 100,
            duration    = 0,
            description = 'Disable the helicopter tail rotor',
            applies     = 'heli',
            category    = 'sabotage',
            sound       = 'success',
        },
        {
            id          = 'explode_car',
            enabled     = true,
            label       = 'EXPLODE_VEHICLE',
            icon        = 'flame',
            cost        = 150,
            duration    = 0,
            description = 'Detonate the target vehicle',
            category    = 'chaos',
            sound       = 'explode',
        },

    },
}
