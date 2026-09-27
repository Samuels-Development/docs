return {
    -- Defaults for a planted bomb; /bomb_plant and the plantBomb export can override each one.
    -- Ranges are the UI's own (web/src/pages/BombPage.tsx): anything outside is clamped.
    Defaults = {
        Modules = 5, -- 1-11 modules (needy ones included); 6+ spills onto the back face
        Seconds = 300, -- 30-3600 on the clock when the bomb is planted
        Strikes = 3, -- 1-5; the last strike is the explosion
        Needy = false, -- true = also deal 1-2 needy modules (they can never be solved, only babysat)
        Yield = 3, -- 1-6: how much explosive it is packed with (a hand-built bomb carries its own)
    },

    -- The clock starts when the bomb is PLANTED and runs server-side, whether or not anyone is
    -- looking at it. A Defuser opening the UI gets whatever is left - but never less than
    -- MinSeconds, the floor the UI itself enforces. At zero with nobody defusing, it goes off.
    MinSeconds = 30,

    -- One Defuser at a time: the UI holds the puzzle state, so a second player would be solving
    -- a different copy. Backing out frees the bomb but throws the progress away (the clock keeps
    -- running) - defusing is meant to be done in one sitting, with the Experts on the radio.
    SpawnDistance = 80.0, -- metres at which the prop assembles via lib.points (and despawns)

    Interact = {
        Distance = 1.6, -- metres to the casing for the target option / key prompt
        Key = 38, -- control id for the fallback prompt when no target resource runs (38 = E)
        Icon = 'fa-solid fa-bomb', -- target option icon
    },

    -- Armed bombs survive a restart of this resource (data/bombs.json), their clocks still running; one whose clock ran
    -- out while it was down goes off as it starts. false = a restart clears every planted bomb.
    Persist = true,

    -- A planted, armed bomb's timer counts down on its display for anyone looking at it (drawn live over the model's
    -- blank '--:--': client/bomb/clock.lua). Range = metres within which it is drawn.
    -- It beeps as it ticks down (Tick: { sound name, sound set }; false = silent): once a second, twice a second in its last
    -- Hurry seconds, heard within TickRange metres.
    LiveTimer = { Enabled = true, Range = 12.0, Tick = { 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS' }, Hurry = 10, TickRange = 10.0 },

    -- What happens when it goes off (strikes or clock). AddExplosion ids:
    -- docs.fivem.net/docs/game-references/explosions
    Explosion = {
        Enabled = true, -- false = the prop just vanishes (useful on a test server)
        Type = 2, -- 2 = EXP_TAG_STICKYBOMB-sized blast
        Damage = 1.0, -- damage scale
        Shake = 1.0, -- camera shake
        -- Both are multiplied by the bomb's yield (1-6 blocks of explosive): index = yield.
        ByYield = { 0.5, 0.75, 1.0, 1.3, 1.6, 2.0 },
    },

    DefusedLinger = 60, -- seconds a defused bomb's prop stays in the world before it is cleaned up

    -- Admin commands (ace-restricted like any lib.addCommand). Set a name to false to not
    -- register that command.
    Commands = {
        Restricted = 'group.admin',
        Plant = 'bomb_plant', -- /bomb_plant [modules] [seconds] [strikes] [needy 0|1] [seed] - players plant with the bomb item instead
        Clear = 'bomb_clear', -- /bomb_clear - removes every planted bomb
        Detonate = 'bomb_detonate', -- /bomb_detonate [id] - sets an armed bomb off NOW: the one with that id, or the nearest to you (within DetonateReach)
        DetonateReach = 150.0, -- metres the no-id form looks around you
        GiveSet = 'bomb_give_set', -- /bomb_give_set [player] - one bomb item of every size (S, M, L, XL), each packed with as much as it holds
    },

    -- The Expert's field manual is an ITEM (configs/shared/items.lua). Set a command name here
    -- to ALSO open it with a chat command - unrestricted: anyone may read the book, that is the
    -- game. The openManual client export works either way.
    ManualCommand = false, -- e.g. 'bomb_manual'
}
