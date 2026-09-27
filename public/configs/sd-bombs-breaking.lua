return {
    -- ANY explosion in the game world can breach a wall: grenades, stickies, rockets, a car going
    -- up - and whatever another script sets off with AddExplosion. The server sees them all
    -- (explosionEvent), rates each one with a Power, and breaches every intact wall within reach
    -- whose toughness (configs/shared/walls.lua) that Power meets.
    Explosions = {
        Enabled = true, -- false = walls only break through the exports / the bomb link below

        -- Power by explosion type id (docs.fivem.net/docs/game-references/explosions).
        -- 0 = never breaches anything (fire, water, steam, flares).
        Power = {
            [0] = 2,  -- grenade
            [1] = 2,  -- grenade launcher
            [2] = 3,  -- sticky bomb
            [3] = 0,  -- molotov
            [4] = 3,  -- rocket
            [5] = 4,  -- tank shell
            [6] = 1,  -- hi-octane
            [7] = 2,  -- car
            [8] = 3,  -- plane
            [9] = 2,  -- petrol pump
            [10] = 1, -- bike
            [11] = 0, [12] = 0, [13] = 0, [14] = 0, -- steam, flame, water hydrant, gas canister flame
            [15] = 2, -- boat
            [16] = 3, -- ship destroy
            [17] = 3, -- truck
            [18] = 1, -- bullet (explosive rounds)
            [19] = 0, [20] = 0, [21] = 0, [22] = 0, [24] = 0, -- smoke launcher, smoke grenade, bz gas, flare, extinguisher
            [25] = 2, -- programmable AR
            [26] = 3, -- train
            [27] = 2, -- barrel
            [28] = 2, -- propane
            [29] = 3, -- blimp
            [30] = 0, -- flame explode
            [31] = 3, -- tanker
            [32] = 4, -- plane rocket
            [33] = 3, -- vehicle bullet
            [34] = 2, -- gas tank
            [36] = 3, -- railgun
            [37] = 3, -- blimp 2
            [38] = 1, -- firework
            [39] = 0, -- snowball
            [40] = 3, -- proximity mine
            [41] = 4, -- valkyrie cannon
            [43] = 2, -- pipe bomb
        },
        DefaultPower = 1, -- any type not listed above

        -- How far a blast reaches, measured to the nearest point of the wall (not its centre).
        Reach = { Base = 2.0, PerPower = 0.9 }, -- metres = Base + PerPower * Power (a sticky: 4.7 m)

        IgnoreInvisible = false, -- true = explosions flagged invisible never breach (some scripts use them for damage only)
    },

    -- The link to sd-bombs: when a briefcase bomb goes off, every wall within Radius whose
    -- toughness Power meets is breached - even if that resource has its visible explosion turned
    -- off. Nothing here needs sd-bombs to be installed; without it this simply never fires.
    Bomb = {
        Enabled = true,
        Power = 4, -- a briefcase bomb goes through anything
        Radius = 7.5, -- metres
        Hole = 5, -- hole shape it leaves (see Holes below; 5 = one a car drives through, where the wall is long enough); false = by power, like any explosion
        -- A bomb breaches only a wall it is SET AGAINST: stuck on it, or standing right at its foot - within this many metres
        -- of it (measured from the bomb to the middle of the wall's thickness, so a thick wall is not harder to reach).
        -- The hole opens where the bomb is. false = every wall within the Radius below breaks, wherever the bomb stands.
        Contact = 0.75,
        -- How high on the wall a bomb sits can decide its hole (a Yield row's Hole = { low = shape, high = shape }): set
        -- within this many metres of the wall's foot it is 'low', above that 'high'.
        LowBelow = 0.9,
        TopAbove = 2.2, -- ...set this many metres up or more it is at the 'top'
        EndWithin = 1.0, -- ...and within this many metres of either end of the wall, near its 'end' ('corner': at the top as well)
        -- ...unless the bomb says how much explosive it was packed with (1-6 blocks: every bomb
        -- does - a hand-built one what its builder put in, any other Bomb.Defaults.Yield). Then the
        -- row for that yield is used instead of the three values above: a single block blows a hole
        -- to crawl through and cannot get through a tough wall at all; six bring the section down. A row's Hole may be a
        -- pair, { low = shape, high = shape }: which one a bomb leaves depends on how high on the wall it is set (LowBelow).
        Yield = {
            -- Hole = { low, high, top, end, corner }: the shape for where on the wall the bomb is set (LowBelow, TopAbove,
            -- EndWithin above). 8 = the top edge blown out, 9 = the end knocked off, 10 = the upper corner gone.
            -- (A zone a row has no shape for gets the one for the bomb's height: 1-2 blocks near an end blow their usual
            -- hole, at the end - too small a charge to knock the end of a wall off.)
            { Power = 2, Radius = 4.0, Hole = { low = 4, high = 7, top = 8 } }, -- 1: a crawl hole at the foot; a window higher up; the top edge at the top
            { Power = 3, Radius = 5.0, Hole = { low = 1, high = 7, top = 8 } }, -- 2: a doorway at the foot; a window higher up; the top edge at the top
            { Power = 4, Radius = 6.0, Hole = { low = 3, high = 3, top = 8, ['end'] = 9, corner = 10 } }, -- 3: blown wide
            { Power = 4, Radius = 7.5, Hole = { low = 5, high = 5, top = 8, ['end'] = 9, corner = 10 } }, -- 4: a car drives through
            { Power = 5, Radius = 8.5, Hole = { low = 5, high = 5, top = 8, ['end'] = 9, corner = 10 } }, -- 5: the same, from further off
            { Power = 5, Radius = 10.0, Hole = 6 }, -- 6: the whole section comes down, wherever it is set
        },
    },

    -- Where the hole goes in a wall longer than the hole: 'blast' = centred on the explosion, as
    -- closely as the run allows (a charge at one end of a long wall opens that end); 'centre' =
    -- always the middle of the run. Either way a hole spans whatever pieces stand there, and a wall
    -- can be breached again further along.
    HolePosition = 'blast',

    -- Which hole a blast leaves. Every style ships ten shapes (shared/runs.lua > SHAPES):
    --   1 breach    doorway-sized, walk through          5 vehicle   4 m unit: a car drives through, the wall still spans above
    --   2 split     tall and narrow, squeeze through      6 collapse  4 m unit: open to the top - a van or a truck fits
    --   3 wide      most of a 2 m unit gone               7 window    does not reach the ground: see and shoot through
    --   4 low       knee- to waist-high: crawl / shoot through
    --   8 top       the top edge blown out, the wall below standing: climb, see and shoot over
    --   9 end       the END of the run knocked off, top to bottom, open to the side (a corner: both walls' ends)
    --  10 corner    the upper corner at an end come away on a diagonal
    -- (9 and 10 only ever open at a run's end; a bomb has to be set near one - Bomb.EndWithin - to leave them.)
    -- BySurplus is keyed by how much Power the blast had to spare over the wall's Toughness; one of
    -- the listed shapes is picked at random. A 4 m shape that does not fit the run (or the gap
    -- between two holes) falls back to the biggest 2 m one.
    Holes = {
        BySurplus = {
            [0] = { 2, 4, 7 }, -- only just through: a split, a low hole or a window
            [1] = { 1 },       -- one to spare: a doorway
            [2] = { 3 },       -- two: blown wide
            [3] = { 5, 6 },    -- three or more: vehicle-sized, or the whole section comes down
        },
        -- A blast INTO a hole that is already there makes it bigger instead of doing nothing: the
        -- shape the blast would have left, or one size up from what is there, whichever is more.
        -- Near = metres either side of a hole that still count as "into it" when there is no room
        -- left for a hole of its own.
        Widen = true,
        Near = 1.0,
    },

    -- A breached wall rebuilds itself after this many seconds (0 = stays breached until
    -- /wall_repair or the repairWall export). The clock survives a restart.
    RepairAfter = 900,

    -- What the breach looks like to players near it.
    Effects = {
        Range = 120.0, -- metres within which a client bothers to play any of this
        Debris = {
            Enabled = true,
            Lifetime = 25.0, -- seconds a chunk lies around before it fades out
            FadeTime = 2.5, -- seconds of fade
            Speed = { 4.0, 10.0 }, -- metres/second a chunk leaves the wall at
            MaxChunks = 60, -- hard cap on chunks alive at once per client (oldest go first)
        },
        -- Particle effects from the base game's 'core' asset, all played at the breach. A name
        -- the game does not know is skipped silently, so this list is safe to experiment with.
        Particles = {
            Asset = 'core',
            Sets = {
                masonry = { { 'ent_dst_concrete_large', 2.5 }, { 'ent_dst_rocks', 2.0 }, { 'exp_grd_bzgas_smoke', 1.6 } },
                plaster = { { 'ent_dst_concrete_large', 1.8 }, { 'exp_grd_bzgas_smoke', 1.4 } },
                wood = { { 'ent_dst_wood_splinter', 3.0 }, { 'exp_grd_bzgas_smoke', 1.0 } },
                metal = { { 'ent_dst_metal_frag', 2.5 }, { 'ent_sparking_wires', 2.0 }, { 'exp_grd_bzgas_smoke', 1.0 } },
            },
        },
        Shake = { Name = 'SMALL_EXPLOSION_SHAKE', Amount = 0.35, Range = 40.0 }, -- camera shake, scaled down with distance
    },
}
