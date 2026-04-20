-- =============================================================================
--  SD-VEHHACK / configs/config.lua
-- =============================================================================
--  Everything you need to tune this script lives in this file.
--  The list of hacks themselves is split out into configs/hacks.lua so both
--  files stay readable.
--  After any change, restart the resource:  restart sd-vehhack
-- =============================================================================

return {
    -- Which language file to load from locales/. Available: 'en', 'de'.
    Locale = 'en',

    -- Enable console debug prints for validation steps
    DebugPrints = false,

    -- The hacking device item that triggers the UI when used (e.g. phone plug).
    -- Set to nil to gate entry to /testhackui only.
    HackingItem = 'phone_plug',

    -- When true, the hacking item is consumed every use. Keep false for a
    -- reusable dongle where SIMs are the real consumable.
    ConsumeOnUse = false,

    -- Stackable item spent per hack. Set to nil to use cash instead.
    CurrencyItem = 'hacking_sim',

    -- Short text shown in the UI next to the balance
    CurrencyLabel = 'SIMS',

    -- Camera raycast reach (maximum distance to detect vehicles). Must be
    -- >= the largest per-class limit below, otherwise heli targeting can't
    -- physically reach at range.
    MaxTargetDistance = 150.0,

    -- Lock/execute range for cars, bikes, and boats (in units)
    MaxTargetDistanceCar = 30.0,

    -- Lock/execute range for helicopters (in units)
    MaxTargetDistanceHeli = 150.0,

    -- Selected-vehicle outline color.
    --   followAccent = true  -> RGB is taken from the player's chosen accent
    --                          colour in the settings panel (falls back to
    --                          Config.Settings.defaultAccent when unset, or
    --                          when Settings.allowAccent is false).
    --   followAccent = false -> always use the r/g/b below (force override).
    -- The `a` value is always used as the outline alpha regardless of mode.
    OutlineColor = {
        followAccent = true,
        r = 74, g = 222, b = 128, a = 255,
    },

    -- If true, the targeting HUD and in-panel connection strip show the
    -- vehicle's licence plate (e.g. "12ABC345") instead of the display /
    -- spawn name (e.g. "KURUMA"). Empty plates fall back to the display
    -- name so the HUD never shows a blank label.
    ShowPlate = true,

    -- Visual highlights shown while targeting / locked on a vehicle.
    -- Disable any you don't want to render. Omitting the block or individual
    -- keys keeps that highlight enabled (fail-open).
    --   brackets : subtle white corner brackets around the vehicle bounding box
    --   outline  : screen-space coloured outline shader on the vehicle mesh
    --   arrow    : 3D arrow marker floating above the target
    Highlights = {
        brackets = true,
        outline  = true,
        arrow    = false,
    },

    -- Cooldowns (server-authoritative). Set either to 0 to disable.
    -- HackCooldown    -> per-user, seconds a player must wait after any hack.
    -- VehicleCooldown -> per-plate, seconds a specific licence plate is
    --                    protected after being hacked (by any player).
    HackCooldown    = 5,
    VehicleCooldown = 600,

    -- When true, confirming a hack shows a progress bar before it fires.
    -- When false, hacks execute instantly on click.
    UseProgressBar = true,

    -- Default progress bar duration in milliseconds. Used when a hack in
    -- hacks.lua doesn't specify its own `executeTime`. Per-hack values
    -- override this.
    ProgressDuration = 3000,

    -- Which progress bar renderer to use when UseProgressBar = true.
    --   'custom' -> in-house NUI progress card (distance sub-bar, countdown)
    --   'native' -> bridge StartProgress (ox_lib / QBCore / ESX native bar)
    -- Both paths still validate distance during the progress; if the player
    -- walks out of range the hack aborts and no SIMs are deducted. Native-
    -- path cancellation relies on ox_lib.cancelProgress when available.
    ProgressBarStyle = 'custom',

    -- Logging is configured separately in configs/logs.lua. Supports Discord,
    -- Fivemanage, Fivemerr, Loki, and Grafana.

    -- Per-client UI customization toggles. Each allow* decides whether that
    -- section is visible to the player; when disabled, the defaults below
    -- are enforced server-side.
    --   enabled         = false -> hide the gear icon entirely
    --   allowPosition   = false -> panel always sits at defaultPosition
    --   allowAccent     = false -> accent color always matches defaultAccent
    --   defaultPosition accepts: 'top-left', 'top-right', 'center-left',
    --                            'center-right', 'bottom-left', 'bottom-right'
    --   defaultAccent   is a 6-char hex without '#'
    Settings = {
        enabled         = true,
        allowPosition   = true,
        allowAccent     = true,
        defaultPosition = 'center-right',
        defaultAccent   = '4ade80',
    },

    -- Emergency vehicle model names. When OWNER_SCAN runs on an unowned
    -- vehicle whose model appears in one of these lists, the card shows a
    -- department label (e.g. "POLICE") instead of a fake randomised name.
    -- If the vehicle IS owned by a real player, the player's name wins.
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

    -- Model names listed here CANNOT be hacked. Any attempt is rejected
    -- server-side before cost is deducted and the client sees a notification.
    -- Leave empty ({}) to allow every vehicle.
    ExemptVehicles = {
        -- 'stockade',
        -- 'rhino',
    },

    -- The list of hacks lives in `configs/hacks.lua`. Edit that file to add,
    -- remove, tune, or disable individual hacks -- the full field reference
    -- is documented there. The rest of the codebase reads from `Config.Hacks`.
    Hacks = require('configs.hacks'),
}
