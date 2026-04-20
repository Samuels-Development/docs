-- =============================================================================
--  SD-VEHHACK / configs/hacks.lua
-- =============================================================================
--  This file defines every hack the device can run. It's imported by
--  configs/config.lua via `Hacks = require('configs.hacks')` and exposed to
--  the rest of the codebase as `Config.Hacks`.
--
--  Every hack below has two quick-tuning knobs owners typically want to edit:
--
--    enabled = true/false    <-- TOGGLE the hack on or off (hides from menu
--                               AND rejects server-side). No hack loop reload
--                               needed; a resource restart is enough.
--
--    duration = <ms>         <-- CHANGE the EFFECT length (how long the hack's
--                               consequence persists after it lands).
--                               0 = instant/permanent.
--                               Example: `duration = 60000` = 60 seconds.
--                               Ignored by hacks that have no timed effect
--                               (e.g. explode_car, pop_tires, owner_scan).
--
--    executeTime = <ms>      <-- OPTIONAL. CHANGE how long the progress bar
--                               runs before the hack fires. Omit / nil to use
--                               Config.ProgressDuration as the default.
--                               Example: `executeTime = 5000` makes a scan
--                               feel deliberate; `executeTime = 1500` makes
--                               a bomb detonation feel snappy.
--                               If Config.UseProgressBar is false the hack
--                               executes instantly regardless -- this field
--                               is only read when the bar is enabled.
--
--  Other fields configure identity, icon, cost, category, and vehicle-class
--  restrictions. Full reference below:
--
--    id          (string)  UNIQUE identifier. Used in code -- do not duplicate.
--    enabled     (bool)    false = hidden from menu & rejected server-side.
--    label       (string)  Text shown on the button.
--    icon        (string)  Lucide icon name. See web/src/App.tsx iconMap for
--                          the supported list (add new imports there to extend).
--    cost        (number)  Scripts (or cash) spent on success.
--    duration    (number)  Effect length in ms. 0 = instant / permanent.
--    executeTime (number?) Optional progress-bar duration in ms. Falls back
--                          to Config.ProgressDuration when omitted. Ignored
--                          entirely if Config.UseProgressBar is false (hacks
--                          fire instantly in that mode).
--    description (string)  Tooltip text (reserved for future UI use).
--    applies     (string?) Restricts which vehicle classes can be hacked.
--                          Valid values (omit / nil for no restriction):
--                            'car'   -> any ground vehicle (cars AND bikes).
--                                       Helicopters are blocked.
--                            'heli'  -> helicopters only. Cars + bikes blocked.
--                            nil     -> no class restriction; any vehicle works.
--                          Note: 'car' is a legacy name that covers all ground
--                          vehicles, not literally only cars. Use `excludes`
--                          below to narrow further (e.g. exclude bikes).
--    excludes    (table?)  Optional list of vehicle-class names to block even
--                          when `applies` would otherwise allow them. Each
--                          entry must be one of: 'car' | 'heli' | 'bike'.
--                          Example: `excludes = { 'bike' }` keeps the hack off
--                          motorbikes but still allows cars (and heli if
--                          `applies` permits).
--    category    (string)  UI tab: 'sabotage' | 'control' | 'chaos' | 'intel'.
--    sound       (string)  Success sound. One of:
--                            'success' | 'activate' | 'select' |
--                            'target_lock' | 'targeting_start' | 'explode'
--    hackedFx    (string)  Screen effect shown to occupants of the hacked
--                          vehicle (not the hacker). One of:
--                            'static'    -> RGB chromatic split + scan-line
--                                           static + horizontal tear bars
--                                           (chaotic analog-TV interference)
--                            'nosignal'  -> SMPTE colour-bar "no signal" TV
--                                           flash with grain, scan lines, and
--                                           occasional white strobes
--                                           (classic broken-broadcast look)
--                            'blackout'  -> stuttering black flashes ending
--                                           with a thin white line that
--                                           horizontally collapses to centre
--                                           (CRT / electrical power-off)
--                          Omit or set to nil to use 'static'. Unknown values
--                          also fall back to 'static'.
--
--  Extended fields (only some hacks use these):
--
--    requiresSeat  (bool)   When true, opens a seat-picker modal after click.
--                           Picked seat index (-1 driver, 0 front-pass,
--                           1 rear-left, 2 rear-right) is sent to the server.
--    allMultiplier (number) Optional "ALL" button in the seat picker. Cost is
--                           `base * allMultiplier` and every occupant is ejected.
--                           Omit/nil to hide the ALL button.
--    requiresSpeed (bool)   When true, opens a speed-picker slider after click.
--    speedMin      (number) Lower bound (mph) for the slider.
--    speedMax      (number) Upper bound (mph) for the slider.
--    costAtMin     (number) Cost at `speedMin`. Cost slides linearly between
--                           `costAtMin` at speedMin and `cost` at speedMax
--                           (lower top speed = harder to escape = more expensive).
--    speedThreshold(number) SPEED_BOMB arming threshold (mph). Bomb arms when
--                           driver hits this speed; falling back below detonates.
--    fuelLevel     (number) FUEL_PURGE target fuel level (0-100). Tank is forced
--                           down to this value. 0 = hard drain.
-- =============================================================================

return {

    -- Trivial (5-10)
    {
        id          = 'honk_loop',
        enabled     = true,
        label       = 'HONK_HORN',
        icon        = 'megaphone',
        cost        = 5,
        duration    = 30000,
        executeTime = 1500,
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
        executeTime = 1500,
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
        executeTime = 1500,
        description = 'Unlock and open all vehicle doors',
        excludes    = { 'bike' },
        category    = 'control',
        sound       = 'select',
    },
    {
        id          = 'door_lock',
        enabled     = true,
        label       = 'LOCK_DOORS',
        icon        = 'lock',
        cost        = 20,
        duration    = 30000,
        executeTime = 2000,
        description = 'Magnetically lock all doors so occupants cannot exit',
        applies     = 'car',
        excludes    = { 'bike' },
        category    = 'control',
        sound       = 'target_lock',
    },
    {
        id          = 'door_unlock',
        enabled     = true,
        label       = 'UNLOCK_DOORS',
        icon        = 'unlock',
        cost        = 15,
        duration    = 0,
        executeTime = 2000,
        description = 'Remotely release the door locks on a vehicle',
        applies     = 'car',
        excludes    = { 'bike' },
        category    = 'control',
        sound       = 'target_lock',
    },
    {
        id          = 'alarm_trigger',
        enabled     = true,
        label       = 'TRIGGER_ALARM',
        icon        = 'bell',
        cost        = 10,
        duration    = 30000,
        executeTime = 1500,
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
        executeTime = 4500,
        description = 'Look up the registered owner of a vehicle',
        category    = 'intel',
        sound       = 'activate',
        hackedFx    = 'nosignal',
    },
    {
        id          = 'gps_ping',
        enabled     = true,
        label       = 'GPS_PING',
        icon        = 'map-pin',
        cost        = 25,
        duration    = 120000,
        executeTime = 3500,
        description = 'Tag the vehicle on your map for 2 minutes',
        category    = 'intel',
        sound       = 'target_lock',
        hackedFx    = 'nosignal',
    },

    -- Cheap control (15-25)
    {
        id          = 'steer_right',
        enabled     = true,
        label       = 'STEER_RIGHT',
        icon        = 'arrow-right',
        cost        = 20,
        duration    = 3000,
        executeTime = 2000,
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
        executeTime = 2000,
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
        executeTime = 2000,
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
        executeTime = 2500,
        description = 'Pop all tires on the target vehicle',
        applies     = 'car',
        category    = 'sabotage',
        sound       = 'success',
    },

    -- Mid disruption (30-50)
    {
        id            = 'eject_occupant',
        enabled       = true,
        label         = 'EJECT_OCCUPANT',
        icon          = 'log-out',
        cost          = 35,
        duration      = 0,
        executeTime   = 3000,
        description   = 'Force a specific occupant out of their seat',
        applies       = 'car',
        excludes      = { 'bike' },
        category      = 'chaos',
        sound         = 'target_lock',
        requiresSeat  = true,
        allMultiplier = 3,
    },
    {
        id          = 'drift_mode',
        enabled     = true,
        label       = 'DRIFT_MODE',
        icon        = 'rotate-ccw',
        cost        = 35,
        duration    = 15000,
        executeTime = 3000,
        description = 'Kill rear-tire grip so the car slides under throttle',
        applies     = 'car',
        excludes    = { 'bike' },
        category    = 'control',
        sound       = 'target_lock',
    },
    {
        id          = 'flashbang',
        enabled     = true,
        label       = 'FLASHBANG',
        icon        = 'zap',
        cost        = 35,
        duration    = 5000,
        executeTime = 2000,
        description = 'Detonate a flashbang in the cabin, blinding the driver',
        applies     = 'car',
        excludes    = { 'bike' },
        category    = 'chaos',
        sound       = 'explode',
    },
    {
        id          = 'reverse_camera',
        enabled     = true,
        label       = 'REVERSE_CAMERA',
        icon        = 'camera',
        cost        = 30,
        duration    = 10000,
        executeTime = 2500,
        description = "Flip the driver's camera to face backward",
        applies     = 'car',
        excludes    = { 'bike' },
        category    = 'chaos',
        sound       = 'target_lock',
    },
    {
        id            = 'speed_limit',
        enabled       = true,
        label         = 'SPEED_LIMITER',
        icon          = 'gauge',
        cost          = 15,
        costAtMin     = 60,
        duration      = 30000,
        executeTime   = 3000,
        description   = 'Cap the target vehicle to a chosen top speed',
        applies       = 'car',
        excludes      = { 'bike' },
        category      = 'control',
        sound         = 'target_lock',
        requiresSpeed = true,
        speedMin      = 30,
        speedMax      = 70,
    },
    {
        id          = 'lock_steering',
        enabled     = true,
        label       = 'LOCK_STEERING',
        icon        = 'lock',
        cost        = 30,
        duration    = 5000,
        executeTime = 2500,
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
        executeTime = 3000,
        description = 'Puncture the fuel tank - slow leak + health drain',
        category    = 'sabotage',
        sound       = 'success',
    },
    {
        id          = 'fuel_purge',
        enabled     = true,
        label       = 'FUEL_PURGE',
        icon        = 'fuel',
        cost        = 40,
        duration    = 0,
        executeTime = 3000,
        description = 'Drain the fuel tank down to a configured low level',
        applies     = 'car',
        excludes    = { 'bike' },
        category    = 'sabotage',
        sound       = 'success',
        hackedFx    = 'blackout',
        fuelLevel   = 10,
    },
    {
        id          = 'force_hover',
        enabled     = true,
        label       = 'PULL_UP',
        icon        = 'wind',
        cost        = 45,
        duration    = 15000,
        executeTime = 3500,
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
        executeTime = 3000,
        description = 'Slam the brakes for 15 seconds',
        applies     = 'car',
        category    = 'control',
        sound       = 'target_lock',
    },

    -- Heavy (60-75)
    {
        id          = 'disable_engine',
        enabled     = true,
        label       = 'DISABLE_ENGINE',
        icon        = 'power-off',
        cost        = 60,
        duration    = 0,
        executeTime = 4000,
        description = 'Kill the engine until the vehicle is repaired',
        applies     = 'car',
        category    = 'sabotage',
        sound       = 'success',
        hackedFx    = 'blackout',
    },

    -- Top-tier (100-150)
    {
        id          = 'local_chaos',
        enabled     = true,
        label       = 'LOCAL_CHAOS',
        icon        = 'radar',
        cost        = 100,
        duration    = 30000,
        executeTime = 5000,
        description = 'Every NPC driver within 50m floors it straight at the target',
        category    = 'chaos',
        sound       = 'explode',
    },
    {
        id             = 'speed_bomb',
        enabled        = true,
        label          = 'SPEED_BOMB',
        icon           = 'bomb',
        cost           = 120,
        duration       = 60000,
        executeTime    = 4500,
        description    = 'Vehicle explodes if it drops below the threshold once armed',
        applies        = 'car',
        excludes       = { 'bike' },
        category       = 'sabotage',
        sound          = 'explode',
        speedThreshold = 90,
    },
    {
        id          = 'disable_rotor',
        enabled     = true,
        label       = 'DISABLE_ROTOR',
        icon        = 'fan',
        cost        = 100,
        duration    = 0,
        executeTime = 4500,
        description = 'Disable the helicopter tail rotor',
        applies     = 'heli',
        category    = 'sabotage',
        sound       = 'success',
        hackedFx    = 'blackout',
    },
    {
        id          = 'explode_car',
        enabled     = true,
        label       = 'EXPLODE_VEHICLE',
        icon        = 'flame',
        cost        = 150,
        duration    = 0,
        executeTime = 1500,
        description = 'Detonate the target vehicle',
        category    = 'chaos',
        sound       = 'explode',
    },

}
