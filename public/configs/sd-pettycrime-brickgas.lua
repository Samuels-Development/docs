return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- Skill-check minigame run during the setup. Enable = false to skip it. Swap
    -- `rhythm` for any other minigame.* (see client/minigame.lua) or your own
    -- function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.rhythm({
                lanes     = 4,    -- number of lanes (keys A S D F)
                noteCount = 12,   -- total notes to clear
                fallSec   = 1.6,  -- seconds a note takes to reach the hit line
                maxMisses = 3,    -- misses allowed before caught
                hitWindow = 0.11, -- clean-hit timing window (fraction of fall)
            }).success
        end,
    },

    Cooldown = 20, -- Per-plate cooldown (minutes) before the same car can be re-sabotaged.
    Items = { 'brick' }, -- Brick required to drop on the pedal.
    ShowTargetWithoutItem = false, -- Show the target even without a required tool (false = only show when you have one). The action still requires the tool.
    SetupTime = 3.5, -- Seconds spent leaning into the cabin wedging the brick (progress bar duration).
    JoyrideDuration = 30, -- Seconds the ghost driver keeps the throttle pinned before despawning.
    BaseXP = 22, -- Base XP per successful sabotage.
    ConsumeBrick = true, -- The brick stays wedged on the pedal in the runaway car — remove one from the player on success.
    Logging = true, -- Enables lib.logger usage for this action.

    -- Vehicle classes the target option will refuse to attach to. Bikes
    -- don't have a gas pedal in the meaningful sense; everything else
    -- is the standard road-vehicle-only filter.
    IgnoreClasses = {
        [8]  = true, -- Motorcycles
        [13] = true, -- Cycles
        [14] = true, -- Boats
        [15] = true, -- Helicopters
        [16] = true, -- Planes
        [17] = true, -- Service (taxi, bus, ambulance)
        [18] = true, -- Emergency (police, fire)
        [19] = true, -- Military
        [21] = true, -- Trains
        [22] = true, -- Open Wheel (F1)
    },

    -- Pre-hashed model exemption list.
    IgnoreModels = {
        -- ['emperor'] = true,
    },

    -- Runaway behaviour. An invisible "ghost driver" ped is dropped into the seat
    -- and holds the accelerator straight down, so the physics engine actually
    -- drives the car. It only ever presses the gas (no AI navigation) with the
    -- wheels pinned dead-ahead, so it never swerves or follows roads -- it just
    -- careens straight off the parked heading until JoyrideDuration closes. Because
    -- the engine (not a forced velocity) moves the car, walls simply stop it and
    -- ramps launch it only with the momentum it earned -- no more rocket-jumps.
    --   MaxSpeed       : soft cruise ceiling (m/s). The ghost floors it up to this
    --                    speed, then eases off and coasts. 22 is about 50 mph /
    --                    79 km/h. A high cap is now safe -- it no longer launches
    --                    the car off bumps.
    --   ThrottleAction : how hard the ghost presses the gas. All three drive
    --                    perfectly straight; only the intensity differs:
    --                      9 = gentle    23 = firm (default)    32 = flat-out
    MaxSpeed       = 22.0,
    ThrottleAction = 23,

    PoliceAlert = {
        Enable = true,
        Chance = 55, -- Loud, visible, dangerous — runaway car gets called in fast.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21G',
                title       = 'Runaway Vehicle',
                message     = 'Vehicle accelerating uncontrolled',
                description = 'Vehicle accelerating uncontrolled',
                blipText    = '911 - Runaway Vehicle',
                sprite      = 380,
                colour      = 1,
                scale       = 1.2,
            })
        end,
    },
}
