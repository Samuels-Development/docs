return {
    -- Inventory item names. Both are registered as usable through the bridge
    -- (bridge/server/inventory.lua), so they work on ox_inventory, qb-inventory, qs, ESX, ...
    -- On ox_inventory the item definition must point at this resource's export, which the bridge
    -- names after the item: server = { export = 'sd-bombs.use<Item>' } with the item's first
    -- letter upper-cased (sd_bomb -> useSd_bomb). Rename an item here and you rename its export.
    Bomb = 'sd_bomb', -- use: aim at where it goes - floor, wall or ceiling - and arm it (consumed once planted)
    -- The image a bomb of each compact size shows in the inventory (metadata.image: a .png in your inventory's image folder,
    -- blender/icons/sd_bomb_<size>.png). The Extra Large keeps sd_bomb's own. false = every bomb shows the item's image.
    BombImages = { small = 'sd_bomb_small', medium = 'sd_bomb_medium', large = 'sd_bomb_large' },
    Manual = 'sd_bomb_manual', -- use: read the Expert's field manual (never consumed)

    -- The bomb builder. Using a casing kit opens a bench: the empty casing in 3D, and every module
    -- item the player carries in a parts bin beside it. Any module goes into any bay of either
    -- face (the parcel supplies a loose countdown display; fit and fasten it on the front).
    -- "Assemble" takes the kit and the parts used and hands back a Bomb item that carries the
    -- build - plant it like any other bomb, and THAT bomb is what the Defuser gets. A Bomb item
    -- without a build (given by an admin, bought in a shop) is still a random one.
    -- Needs an inventory with item metadata (ox_inventory, qb-inventory, qs, ...).
    Builder = {
        Kit = 'sd_bomb_kit', -- the casing. At a workbench in the world it goes from the kit bag onto the mat (taken then); used as an item it opens the builder's page where there is no bench
        MaxModules = 11, -- bays a build may fill, 1-11 (the twelfth is the timer's)
        -- Step 1 of every build: the casing is packed with explosive. One item = one block = one
        -- point of YIELD, and the yield decides how hard the bomb hits and how big a hole it blows
        -- in a breakable wall (configs/shared/breaking.lua > Bomb.Yield).
        Charge = {
            Item = 'sd_explosive',
            Min = 1, -- blocks a bomb needs at least
            Max = 6, -- cells in the casing (the open casing has six: do not raise this past 6)
            Model = 'sd_bomb_charge', -- the block (blender/build_bench.py)
            OpenCasing = 'sd_bomb_casing_open', -- the casing with its front off, to pack them into (its firing unit sits astride the middle divider)
            Front = 'sd_bomb_casing_front', -- the casing's front by itself: what lies on the bench while the case is open
            Cap = 'sd_bomb_cap', -- the detonator cap crimped into a packed block; its lead runs to a terminal of the firing unit
            Probe = 'sd_bomb_probe', -- the multimeter's red probe: what follows the cursor while the meter lies before an open case
            Pin = 'sd_bomb_pin', -- the arming pin (Steps.Pin) and its red 'remove before calibration' flag, in its port on the casing's end
        },
        -- What a build USES UP, besides its parts. Each is a box: an item, dragged off the kit bag onto the bench, and from
        -- then on the bench's own - whoever works there next finds what is left in it. (A box goes back into the bag only
        -- as it came: full, and not tipped out.) false = that supply is not asked for (screws and wire are just there).
        --   Screws    a box of machine screws, Count to the box. Put it down on the bench, pick it up again and HOLD
        --             RIGHT-CLICK: it tips over in the hand, its lid comes off and the screws pour out of it - the further it
        --             is tipped, the faster - falling onto the bench and piling up where they land. Every screw driven at this
        --             bench comes off a heap - three to a module plate, two to a charge bracket - and every screw backed out
        --             goes back on one. (The front's four bolts are the casing's own.) OpenModel = the box with its lid off.
        --   Wire      a sealed carton of hook-up wire: cut its three tape seams, fold back the flaps, then drag each spool
        --             onto any free rack slot. Six channel colours, Lengths of each. The open carton stays movable. With
        --             the pliers (or the strippers) in hand, click a spool: a length of THAT colour is in the jaws. A cap's
        --             lead has to be the colour of the channel the firing plan gives its cell - a lead of another colour
        --             fails the unit's TEST like one under the wrong terminal. A module's lead takes a length of any colour.
        --             Spools = where they stand in the carton, in its own space (blender/build_bench.py prints these).
        --   Bracket   the steel saddle a block of explosive is strapped into. PerKit of them come in every kit's carton and
        --             lie on the bench once the casing is lifted out; one goes into a cell, its two screws are driven, and
        --             only then does that cell take a block. They are an item too (Item): bought by the box, dragged off the
        --             kit bag like any part, and back into it. Give = how many /bomb_toolkit parts hands out. false = bare cells.
        Supplies = {
            Handbook = { Item = 'sd_assembly_book', Model = 'sd_bomb_handbook', OpenModel = 'sd_bomb_handbook_open', Give = 1 },
            Screws = { Item = 'sd_screw_box', Count = 48, Model = 'sd_bomb_screwbox', OpenModel = 'sd_bomb_screwbox_open',
                FillModels = { 'sd_bomb_screwbox_open_0', 'sd_bomb_screwbox_open_1', 'sd_bomb_screwbox_open_2', 'sd_bomb_screwbox_open_3', 'sd_bomb_screwbox_open' } },
            Wire = { Item = 'sd_wire_box', Lengths = 4, Model = 'sd_bomb_wirebox',
                Package = { Size = vec3(0.244, 0.176, 0.060), BodyModel = 'sd_bomb_wirebox_body', FlapModel = 'sd_bomb_wirebox_flap_%s' },
                Spools = { vec3(-0.076, 0.04, 0.024), vec3(0.0, 0.04, 0.024), vec3(0.076, 0.04, 0.024), vec3(-0.076, -0.04, 0.024), vec3(0.0, -0.04, 0.024), vec3(0.076, -0.04, 0.024) } },
            Bracket = { Item = 'sd_charge_bracket', Model = 'sd_bomb_bracket', PerKit = 6, Give = 6 },
            Straps = { Item = 'sd_retaining_strap', Model = 'sd_bomb_strap_slack', Give = 12 },
        },
        -- The work a build takes beyond packing and screwing - each needs its tool on the bench (Bench.Tools).
        -- false = that step is not asked for (and its tool is never needed).
        --   Cut    a kit comes taped shut: slit it open with the knife before anything goes in
        --   Crimp  every packed block gets a detonator cap crimped in (pliers: press and hold on the block, let go in the green)
        --          and the cap's lead clamped under a terminal of the casing's firing unit, before the front goes on
        --   Bolts  the front's four corner fixings are hex bolts: the hex key, not the driver
        --   Wire   every fitted module is wired in (wire strippers) once it is screwed down
        --   Route  ...by hand: its lead is run along the gutters between the bays, clipped down at every corner, to the
        --          harness socket on the timer (a gutter holds two leads: a full face takes planning). false = one click wires it
        --   Test   the finished circuit is proved with the multimeter; any change after that, and it is tested again
        --   Strap  every block packed into a bracket is strapped down: a steel band over it, pumped tight with the band
        --          tensioner (click to pump: stop in the green, one too many and the band snaps) and sealed - before it is wired
        --   Prep   every length of wire is prepared before it goes on (Supplies.Wire only): click a spool and the length is
        --          laid out along the mat's rule - snip it with the side cutters while its end is in the green - then the
        --          strippers come down and take the insulation off its end (click while the sweep is on the marked notch).
        --          How near the middle of both greens the hand was goes into the joint, like the crimp and the clamp
        --   Sign   once the circuit is proved, QC signs the work order off (its big button) - only then is it assembled
        --   Edge   the builder fits the edgework: a kit's carton brings a bag of edge fittings dealt from its lot (batteries,
        --          indicators, port plates) and its serial plate; with the case closed they clip into the five slots of its
        --          top and bottom edges (any of them, or none), the serial plate into its own. The bomb's edgework - what the
        --          Defuser's rules read - is exactly what was fitted. false = the lot deals it, as for a bomb nobody built
        --   Pin    a kit's firing unit ships with an arming pin in it, in a port on the casing's end (click it to pull it, click
        --          again to push it back). Signed off with it still in, the bomb is a DUD: it plants and its clock runs, and at
        --          zero (or on the last strike) it only clicks - the pin still shows on it. Pulled while the case is open, the
        --          unit is live: a self-test with a fault fires that cell's cap (the block is lost, the builder is hurt)
        Steps = { Cut = true, Crimp = true, Bolts = true, Wire = true, Route = true, Test = true, Strap = true, Prep = true, Sign = true, Edge = true, Pin = false }, -- (Pin: no arming pin - taken off the XL)
        -- /bomb_toolkit [what] [player]: hands out what a build takes (admin). what = 'tools' (one of every bench tool,
        -- the default), 'parts' (a kit, six blocks, one of every module, a box of screws and a carton of wire) or 'all'. false = no command.
        GiveCommand = 'bomb_toolkit',
        Strikes = 3, -- what the work order starts on; the builder picks 1-5
        Timer = { Min = 60, Max = 900, Step = 30, Default = 300 }, -- seconds the builder may put on the clock

        -- Workbenches: where bombs are built. Walk up to one (with a casing kit on you) and the
        -- camera comes down onto the bench top, where the casing and your modules are laid out.
        Bench = {
            -- The bench bombs are built on: a prop of our own (stream/sd_bomb_bench.ydr, built by
            -- blender/build_bench.py) with the cutting mat and the parts tray modelled into its top.
            Model = 'sd_bomb_bench',
            -- true = building happens IN THE WORLD, on that bench: the camera comes down over it, the
            -- parts come out of the kit bag at your feet and are put down on it as real props, moved with a
            -- cursor (client/bomb/assembly.lua) - and what is put down STAYS on that bench, for everyone, across
            -- restarts (server/bomb/workspace.lua): the item is taken when the part is put down, not at the end.
            -- Needs the bench model above - its Layout says where the mat and the tray are. false = the builder is a 3D page instead (any bench prop).
            World = true,
            BakedHarness = true, -- finished leads, straps and terminal marks are engine-rendered props; live work stays animated
            -- Where things are on the bench, in ITS space (metres; +Y = away from whoever stands at
            -- it). blender/build_bench.py prints these: re-export the bench, copy its lines over.
            Layout = {
                Top = 0.92,
                Mat = vec3(0.28, -0.07, 0.9230),
                -- The padded drawer extends only for unpacking; both coordinates refer to its receiving pad.
                CaseRest = vec3(-0.49, -0.80, 0.72),
                CaseRestHalf = vec2(0.318, 0.112),
                CaseRestModel = 'sd_bomb_case_drawer',
                CaseDrawer = { Closed = vec3(-0.49, -0.37, 0.72), Rails = 'sd_bomb_case_drawer_rails', Time = 0.8 },
                -- The parts organiser: cols x rows cells, origin = the far-left one's floor. It is stepped: each row stands rise metres
                -- higher than the one in front of it, so the far rows (and the names on their lips) clear the near ones.
                Tray = { origin = vec3(-0.7200, 0.3200, 0.9860), pitch = vec2(0.1600, 0.1600), cols = 4, rows = 3, rise = 0.03 },
                Lamp = { head = vec3(-0.16, 0.1, 1.52), aim = vec3(0.12, -0.06, 0.92) },
                Sheet = { centre = vec3(0.43, 0.3298, 1.0566), size = vec2(0.16, 0.22), pitch = 68.0 }, -- the work order on its copy stand, right of the handbook (pitch: degrees stood up from lying flat)
                Charges = { origin = vec3(-0.265, 0.13, 0.9245), gap = 0.105, rise = 0.0495 }, -- the pad the explosive is stacked on
                -- The Harlow handbook, open on its stand on the back of the top (blender/bench_book.py; its patch
                -- is in Keepout below). spine = the middle of
                -- its spine, level with the pages; yaw / pitch = how it is turned and stood up (Rz(yaw) Rx(pitch): 0 / 0 = lying flat,
                -- reading the right way up from the front); page = one page, metres. Its pages are baked (cd web && npm run book).
                -- Remove it and there is no handbook at the bench.
                Book = { spine = vec3(0.09, 0.32, 1.078), yaw = 0.0, pitch = 68.0, page = vec2(0.165, 0.233), gutter = 0.028, dip = 0.009 },
                Stand = vec3(-0.12, -0.92, 0.0), -- where the builder stands
                -- Parts lie where they are put down, and stay there. Surface = the patch of bench top a part
                -- may lie on (its edge, not its middle); Keepout = patches inside it that stay clear: the casing's place
                -- on the mat, the clipboard, the vice, the rack the case's front stands in.
                -- The tray is apart from both: a part let go over it drops into the cell under it.
                Surface = { min = vec2(-0.94, -0.615), max = vec2(0.94, 0.405) },
                -- The top's own edges (blender/build_bench.py: SIZE, and TOP_FRONT - the top overhangs the frame at the front,
                -- towards the builder, to leave room along it: a wire carton goes down there with the biggest kit on the mat).
                Edge = { min = vec2(-0.95, -0.625), max = vec2(0.95, 0.475) },
                -- The magnetic parts dish left of the mat, below the organiser: poured screws stay in it, pulled together.
                -- Click its screws with the driver to load the bit. at = its middle, r = its inside radius, floor = how high its
                -- bottom is off the bench top (blender/build_bench.py > DISH).
                Dish = { at = vec2(0.635, 0.33), r = 0.062, floor = 0.005 }, -- at the back, right of the work order's stand
                -- The fittings caddy (blender/build_bench.py > CADDY): nine pockets, an edge fitting to each, at the front left.
                -- origin = the back-left pocket's middle, on its floor; cols run right, rows come towards the builder.
                -- The bracket stand (blender/build_bench.py > STAND), in the gap between the caddy and the mat: charge brackets nest
                -- on it in two piles, one behind the other, as they came in the carton - levels high, each rise above the one under
                -- it (two piles of three: a kit's six). Its base runs exactly as far back and forward as the caddy. z = its plate.
                BracketStand = { piles = { vec2(-0.217, -0.1925), vec2(-0.217, -0.3245) }, levels = 3, rise = 0.008, z = 0.926 },
                Caddy = { origin = vec3(-0.72, -0.1735, 0.924), pitch = vec2(0.16, 0.085), cols = 3, rows = 3 }, -- (a small gap in front of the organiser, under its first three columns)
                Bin = { at = vec3(0.80, -0.345, 1.146), half = vec2(0.105, 0.125), depth = 0.22 }, -- scrap bin standing on the top's front-right corner (at = its rim); matches build_bench.py > BIN
                -- The bench's own utility kit (blender/bench_utility.py) - the bench's, not items: every bench has them.
                --   Cup   an enamel cup: pour a box of screws into it (hold the box over it, hold right-click), carry it to the
                --         job - click the cup with a driver to load one screw onto its magnetic bit. Tip it
                --         (right-click) to pour them out again. Home = where a bench's cup starts; Max = screws it holds.
                --   Reel  the wire dispenser on the pegboard: drag individual spools from an open carton into free slots; click a
                --         spool for a length. Spools = where they hang (bench space); Max = lengths a spool holds.
                Cup = { Home = vec2(-0.87, -0.30), Max = 60 }, -- in the front-left corner, beside the fittings caddy
                Reel = { Max = 24, Spools = { vec3(-0.61, 0.365, 1.25), vec3(-0.566, 0.365, 1.25), vec3(-0.522, 0.365, 1.25), vec3(-0.478, 0.365, 1.25), vec3(-0.434, 0.365, 1.25), vec3(-0.39, 0.365, 1.25) } },
                Keepout = {
                    { centre = vec2(0.28, -0.07), half = vec2(0.27, 0.19), carton = vec2(0.325, 0.24) }, -- the case's reserved working area; carton also marks this keepout for size-specific profiles
                    { centre = vec2(-0.56, -0.2585), half = vec2(0.246, 0.1335) }, -- the fittings caddy (fittings snapped into its pockets bypass this)
                    { centre = vec2(-0.217, -0.2585), half = vec2(0.092, 0.1335) },   -- the bracket stand, both piles: level with the caddy beside it (brackets nested on it bypass this)
                    { centre = vec2(0.80, -0.345), half = vec2(0.115, 0.135) }, -- the scrap bin, front-right
                    { centre = vec2(0.835, 0.06), half = vec2(0.115, 0.27) },  -- the rack at the right of the top, side on, and the front leaning in it
                    { centre = vec2(0.09, 0.34), half = vec2(0.2, 0.1) },       -- the handbook's stand
                    { centre = vec2(0.43, 0.32), half = vec2(0.115, 0.08) },    -- the work order's copy stand
                    { centre = vec2(-0.48, 0.16), half = vec2(0.332, 0.252) },  -- the organiser's walls (parts snapped into cells bypass this)
                    { centre = vec2(-0.85, 0.39), half = vec2(0.045, 0.055) }, -- lamp clamp
                    { centre = vec2(0.0, -0.07), half = vec2(0.02, 0.078) }, -- case handles
                    { centre = vec2(0.56, -0.07), half = vec2(0.02, 0.078) },
                    { centre = vec2(0.052, -0.271), half = vec2(0.023, 0.025) }, -- case feet project past its front edge
                    { centre = vec2(0.508, -0.271), half = vec2(0.023, 0.025) },
                },
                -- Storage: the shelf under the bench. Parts put down on it are stored IN the bench - they stay
                -- there like anything on the top. z = the shelf's surface; min / max = the strip along its front
                -- that is free (the toolbox and the carton stand behind it); Keepout = the spray cans.
                Shelf = { z = 0.243, min = vec2(-0.84, -0.415), max = vec2(0.84, -0.085), Keepout = { { centre = vec2(0.055, -0.2), half = vec2(0.105, 0.065) } } },
                -- Where the front of the case stands while the case is open: on the floor, against the bench's
                -- front, by the kit bag (that is where everyone sees it; the builder fetches it off its chip in the bag).
                Park = { at = vec3(-0.56, -0.6, 0.0), half = vec2(0.27, 0.2) },
                -- Where the front of the case is put down while the case is open - it is lifted off by hand and lies on
                -- the bench until it goes back on. at = the middle of it, lying face up; yaw = how it lies; half = the patch
                -- of bench it covers (nothing else lies there meanwhile). A rest with a pitch has it standing up instead:
                -- 'rack' = the universal padded cradle on the back-right (blender/build_bench.py > RACK), leaning back so its top
                -- stays below the tools on the pegboard behind it. pitch = degrees it is stood up from
                -- lying face up (-90 = lying, 0 = upright; -10 leans it back against the rack), at = the middle of the groove its
                -- bottom edge stands in, edge = XL's half-height (compact lids use their own dimensions), half = along the groove and
                -- across it. home = the one that is always free: where a front goes that nobody has said where to put.
                Rests = {
                    rack = { at = vec3(0.8, 0.06, 0.928), yaw = -90.0, pitch = -20.0, edge = 0.1785, half = vec2(0.26, 0.03), home = true },
                },
            },
            -- The kit bag: what the builder carries. On screen it is a compact drawer opened with Dock.Key (Q) or its button
            -- (client/bomb/dock.lua): an icon and a count per kind of part in the player's pockets. A part is
            -- dragged straight off its chip onto the bench - the item leaves the inventory when the part is put
            -- DOWN - and a part in hand is dropped on the bag button to go back in. There is no bag in the world:
            -- Mouth = the point off the bench's corner, low, where a part going back in flies to (and comes out of).
            Bag = { Mouth = vec3(-1.02, -1.0, 0.42) },
            -- The carton a casing kit comes in (blender/build_bench.py > package): it stands on the mat, taped shut, until its
            -- three seams are slit with the knife - press on a seam and draw the blade along it. Size = its width, depth, height.
            -- The carton a kit comes in. Model = whole and taped shut (carried, in the bag), OpenModel = whole, empty,
            -- its flaps back (shoved off the bench). ON the bench it is its BodyModel and four flaps (FlapModel % which),
            -- because its lid is opened by hand. Flaps (blender/build_bench.py prints them): hinge = the middle of the
            -- flap's hinge, in the carton's own space; axis = what it turns about; dir = the way it reaches from its
            -- hinge while shut (+1 / -1 along the other axis); reach = how far; span = its length along the hinge;
            -- open = degrees it is folded back once open. The hinge is the flap's outer top edge (its score line): folded right back,
            -- a flap hangs flush down the outside of its wall.
            Package = { Model = 'sd_bomb_package_xl_layered', OpenModel = 'sd_bomb_package_xl_layered_open', BodyModel = 'sd_bomb_package_xl_layered_body', FlapModel = 'sd_bomb_package_xl_layered_flap_%s',
                Size = vec3(0.64, 0.46, 0.335), InsertModel = 'sd_bomb_package_xl_parts_tray', DisplayInsertModel = 'sd_bomb_package_xl_timer_tray',
                Flaps = {
                    near = { hinge = vec3(0.0, -0.23, 0.335), axis = 'x', dir = 1.0, reach = 0.23, span = 0.64, open = 269.5 },
                    far = { hinge = vec3(0.0, 0.23, 0.335), axis = 'x', dir = -1.0, reach = 0.23, span = 0.64, open = 269.5 },
                    left = { hinge = vec3(-0.32, 0.0, 0.3292885246), axis = 'y', dir = 1.0, reach = 0.16, span = 0.448, open = 269.5 },
                    right = { hinge = vec3(0.32, 0.0, 0.3292885246), axis = 'y', dir = -1.0, reach = 0.16, span = 0.448, open = 269.5 },
                } },
            -- The chips' icons: one image per ITEM, named after it (the ones shipped are the inventory's own,
            -- web/public/pips/icons). Rename an item and its chip shows initials until its image is there too.
            -- Key = the control that opens and shuts the kit bag (44 = INPUT_COVER, Q by default; not Tab - that is the
            -- inventory's), KeyLabel = what its keycap says.
            Dock = { Icons = 'web/build/pips/icons/%s.png', Key = 44, KeyLabel = 'Q' },
            -- The site radio on the top shelf (blender/bench_shelf.py > radio): a prop of its own, and a working one - it plays
            -- GTA's own stations out of the radio itself, for everyone near the bench (the station is part of the bench's state:
            -- kept across restarts, the same for everybody). In the pegboard view (T) click it to switch it on or skip to the next
            -- station, the wheel steps through them, right-click switches it off; walking up to the bench, the bench's target
            -- has it too. Range = metres it is heard up to (only the nearest radio that is on plays: the game gives every player
            -- one such speaker). At = its middle, bench space (where it is clicked). Stations = GTA's station names, in the order a
            -- click steps through them (their names on screen are the game's own). false = no radio.
            Radio = {
                Model = 'sd_bomb_bench_radio', At = vec3(0.77, 0.345, 1.74), Range = 30.0, Emitter = 'SE_Script_Placed_Prop_Emitter_Boombox',
                Stations = { 'RADIO_01_CLASS_ROCK', 'RADIO_02_POP', 'RADIO_03_HIPHOP_NEW', 'RADIO_04_PUNK', 'RADIO_06_COUNTRY', 'RADIO_07_DANCE_01',
                    'RADIO_08_MEXICAN', 'RADIO_09_HIPHOP_OLD', 'RADIO_12_REGGAE', 'RADIO_13_JAZZ', 'RADIO_14_DANCE_02', 'RADIO_15_MOTOWN',
                    'RADIO_16_SILVERLAKE', 'RADIO_17_FUNK', 'RADIO_18_90S_ROCK', 'RADIO_20_THELAB', 'RADIO_21_DLC_XM17', 'RADIO_22_DLC_BATTLE_MIX1_RADIO',
                    'RADIO_23_DLC_XM19_RADIO', 'RADIO_27_DLC_PRHEI4', 'RADIO_34_DLC_HEI4_KULT', 'RADIO_35_DLC_HEI4_MLR', 'RADIO_37_MOTOMAMI',
                    'RADIO_05_TALK_01', 'RADIO_11_TALK_02' },
                -- The six preset buttons under its screen (and on the screen): a station each.
                Presets = { 'RADIO_01_CLASS_ROCK', 'RADIO_02_POP', 'RADIO_03_HIPHOP_NEW', 'RADIO_09_HIPHOP_OLD', 'RADIO_20_THELAB', 'RADIO_04_PUNK' },
                -- Tuning it up close (the bench's target > Tune the radio): the camera comes up to its face and its knobs and buttons
                -- work like a real set's - drag the tuning knob round (or scroll on it) and every notch is the next station, turn the
                -- volume knob down to click it off (or click it), press a preset. The screen only shows what it is on. Knobs = the moving
                -- parts, props hung on the radio, bench space (blender/bench_shelf.py > radio: the radio stands at (0.77, 0.345, 1.664)
                -- facing the builder): At = where each sits on its face, R = a knob's radius. The tuning knob turns a station a notch
                -- (a full turn = every station); the volume knob's scale runs Min..Max (degrees clockwise from its pointer up: quietest to
                -- loudest), and past Min it clicks Off. Loudness goes through the game's own jukebox volume (the Arcade's: an audio
                -- scene and its variable, 0 = full, 1 = ducked right down); Default = the volume a radio starts at. Spin = 1 or
                -- -1: which way the game turns a prop for "clockwise" (flip it if the knobs turn backwards). Camera = Eye / Look, bench space.
                Knobs = { Tune = { Model = 'sd_bomb_radio_knob_tune', At = vec3(0.799, 0.295, 1.709), R = 0.0155 },
                    Volume = { Model = 'sd_bomb_radio_knob_vol', At = vec3(0.849, 0.295, 1.709), R = 0.013, Off = -158.0, Min = -135.0, Max = 135.0, Default = 0.7,
                        Scene = 'dlc_ch_arcade_music_volume', Variable = 'ArcadeRadioVolumeDucking' },
                    Button = { Model = 'sd_bomb_radio_button', X0 = 0.79, Pitch = 0.014, Y = 0.2942, Z = 1.737, Press = 0.0028 }, Spin = 1 },
                Screen = { centre = vec3(0.825, 0.2929, 1.771), size = vec2(0.078, 0.039) },
                Camera = { Eye = vec3(0.805, -0.03, 1.765), Look = vec3(0.805, 0.29, 1.735), Fov = 36.0, InMs = 900, OutMs = 950 },
            },
            -- Under the bench it is dark: a work light, while the camera is down there (G).
            ShelfLight = { Enabled = true, At = vec3(0.0, -0.5, 0.68), Color = { 255, 214, 170 }, Range = 1.8, Intensity = 2.4 },
            Save = 'data/bench_state.json', -- where what lies on the benches is kept across restarts
            -- Tools. Work on the bench is done with a tool IN HAND: click the pegboard and the camera
            -- turns to it, click a tool and it comes down with you; right-click (or Esc) hangs it back
            -- up. Each tool is a prop of its own, standing where the bench model has a place for it.
            --   Home  where it lives (bench space) + Yaw against the bench     Tip   its working end, in its own space
            --   Grab  the patch of pegboard that picks it: centre (x, z) and half-size, on the board's face
            --   Does  what it is for: 'screws' = driving and backing out the modules' screws
            -- (More tools - pliers, cutters - go here as the work that needs them is added.)
            --
            -- A bench comes with NO tools, only the HOLDERS for them on its pegboard: a drilled rail (screwdrivers and
            -- the hex key stand in it), a plier rack of wire loops, sheaths for knives, cradles for meters, the power
            -- driver's shelf - all empty. Tools are items: a builder brings them and puts them in a holder made for
            -- them (drag the tool off the kit bag: the camera turns to the board, let go over a free place) - and
            -- there they stay, the bench's own, for whoever works at it next. A job can be done when a tool
            -- for it hangs on THIS bench (taken down into your hand, it is still the bench's).
            --   Item   the inventory item that is one of it                 Model  its prop (blender/build_bench.py)
            --   Fits   the kind of holder it lives in (a key of Pegs)         Yaw    turned against the bench where it lives
            --   Tip    its working end, in its own space (the script prints these)
            --   Down   degrees of roll at which that end points straight down: how it is held to work
            --   Does   the job it is for:  screws = the modules' screws      bolts = the four in the front's corners
            --          cut = slits the tape a casing kit comes shut with     crimp = a detonator cap into every packed block
            --          strip = wires a fitted module in                      test = proves the circuit before the bomb is assembled
            --          strap = pumps the steel band over a packed block tight, and seals it
            --   Time   seconds one go of that job takes with this tool (a hand screwdriver is slower than the driver)
            Board = { Y = 0.411, X = 0.86, Z = { 1.0, 1.6 } }, -- the pegboard's face: y, half-width, bottom / top
            Pegs = { -- the places in each kind of holder, in bench space (blender/build_bench.py prints these: HOLDERS there decides how many)
                -- (all on the right of the board: seen from the bench, the lamp stands in front of its left half)
                rail = { vec3(0.23, 0.39, 1.4214), vec3(0.305, 0.39, 1.4214), vec3(0.38, 0.39, 1.4214), vec3(0.455, 0.39, 1.4214) },
                loop = { vec3(0.525, 0.408, 1.4262), vec3(0.605, 0.408, 1.4262), vec3(0.685, 0.408, 1.4262), vec3(0.765, 0.408, 1.4262), -- the top row...
                    vec3(0.61, 0.408, 1.1762), vec3(0.695, 0.408, 1.1762), vec3(0.78, 0.408, 1.1762) }, -- ...and the lower right
                sheath = { vec3(0.84, 0.399, 1.45) },
                cradle = { vec3(-0.2, 0.41, 1.12) },
                shelf = { vec3(0.1, 0.359, 1.33) }, -- (the driver's: first along the row, clear of the case front's rack)
            },
            Tools = {
                camkey = { Item = 'sd_tool_camkey', Model = 'sd_bomb_tool_camkey', Fits = 'rail', Tip = vec3(0,0,-.146), Down = 0, Does = 'index', Time = 1 },
                trimgauge = { Item = 'sd_tool_trimgauge', Model = 'sd_bomb_tool_trimgauge', Fits = 'loop', Tip = vec3(0,0,-.145), Down = 0, Does = 'balance', Time = 1 },
                signalprobe = { Item = 'sd_tool_signalprobe', Model = 'sd_bomb_tool_signalprobe', Fits = 'rail', Tip = vec3(0,0,-.137), Down = 0, Does = 'signal', Time = 1 },
                driver = { Item = 'sd_tool_driver', Model = 'sd_bomb_tool_driver', Fits = 'shelf', Yaw = 180.0, Tip = vec3(0.1805, 0.0, 0.205), Down = 90.0, Does = 'screws', Time = 0.46 },
                screwdriver = { Item = 'sd_tool_screwdriver', Model = 'sd_bomb_tool_screwdriver', Fits = 'rail', Tip = vec3(0.0, 0.0, -0.143), Down = 0.0, Does = 'screws', Time = 1.3 },
                hexkey = { Item = 'sd_tool_hexkey', Model = 'sd_bomb_tool_hexkey', Fits = 'rail', Tip = vec3(0.0, 0.0, -0.1475), Down = 0.0, Does = 'bolts', Time = 0.9 },
                knife = { Item = 'sd_tool_knife', Model = 'sd_bomb_tool_knife', Fits = 'sheath', Tip = vec3(0.004, 0.0, -0.102), Down = 0.0, Does = 'cut', Time = 0.9 },
                pliers = { Item = 'sd_tool_pliers', Model = 'sd_bomb_tool_pliers', Fits = 'loop', Tip = vec3(0.0, -0.0062, 0.05), Down = 180.0, Does = 'crimp', Time = 0.7 },
                tensioner = { Item = 'sd_tool_tensioner', Model = 'sd_bomb_tool_tensioner', Fits = 'loop', Tip = vec3(0.0, -0.008, 0.052), Down = 180.0, Does = 'strap', Time = 0.6 },
                cutters = { Item = 'sd_tool_cutters', Model = 'sd_bomb_tool_cutters', Fits = 'loop', Tip = vec3(0.0, -0.0062, 0.03), Down = 180.0, Does = 'snip', Time = 0.5 },
                strippers = { Item = 'sd_tool_strippers', Model = 'sd_bomb_tool_strippers', Fits = 'loop', Tip = vec3(0.0, -0.004, 0.062), Down = 180.0, Does = 'strip', Time = 0.8 },
                multimeter = { Item = 'sd_tool_multimeter', Model = 'sd_bomb_tool_multimeter', Fits = 'cradle', Tip = vec3(0.0, -0.03, 0.0), Down = 0.0, Does = 'test', Time = 1.4 },
            },
            -- The bench's own lamp, while somebody works at it: a spot light out of the shade.
            Light = { Enabled = true, Color = { 255, 222, 176 }, Distance = 3.2, Brightness = 9.0, Radius = 42.0, Falloff = 14.0 },
            -- How the work feels (metres / seconds).
            Feel = { CarryHeight = 0.27, HoverHeight = 0.055, Follow = 15.0, DropTime = 0.2, ScrewTime = 0.46, ScrewOut = 0.022, FlipTime = 0.75, FlipLift = 0.28,
                Parallax = 0.012 }, -- metres the view leans after the cursor: the bench is looked AT, not photographed
            -- true = a kit can only be opened AT a bench (using the item tells you to find one).
            -- As long as the server has no bench at all, the item opens the builder on the spot anyway.
            Required = true,
            Reach = 3.0, -- metres from a bench it can be used from
            SpawnDistance = 60.0, -- metres at which the bench prop spawns
            Locations = {}, -- fixed benches: { vec4(x, y, z, heading), ... } - z = the ground
            Command = 'bomb_bench', -- /bomb_bench places one in front of you, /bomb_bench remove takes the nearest away (saved to data/benches.json); false = no command
            Restricted = 'group.admin',
            -- The bench as an ITEM, for players: use it and stand the bench wherever you like with the placement gizmo (the
            -- item is taken once it stands; the bench stays across restarts). Whoever stood it can pack it up again - empty,
            -- and nobody working at it - and gets the item back. Icon: blender/icons/sd_workbench.png. false = no item
            -- (benches come only from Locations, the command and the admin panel).
            --   Limit   benches one character may have standing at once (0 = no limit)
            --   Reach   metres from the player the bench may be stood
            --   PackUp  false = a bench stays where it was stood (only an admin takes it away)
            Item = { Name = 'sd_workbench', Limit = 2, Reach = 8.0, PackUp = true },
            -- The move onto the bench. With the World bench, Eye and Look are points in the bench's
            -- space; with another prop (World = false) Height/Back are metres above its top / out
            -- towards the player's side of it.
            Camera = { Eye = vec3(0.02, -0.97, 2.2), Look = vec3(0.02, -0.03, 0.965), Height = 1.15, Back = 0.35, Fov = 49.0, InMs = 1500, OutMs = 900,
                -- The camera works with you (World bench only). Click the work order and it comes down
                -- over the sheet to read it; drive a screw and it closes in on that module, stays while
                -- you work on it and draws back 'Hold' seconds after the last screw. Back / Up = where it
                -- hangs, in metres from what it looks at; Spring = how briskly it moves (higher = snappier).
                Focus = { Sheet = { Back = -0.12, Up = 0.4, Fov = 42.0 }, Bay = { Back = 0.19, Up = 0.4, Fov = 40.0 }, Hold = 1.1, Spring = 6.5,
                    Unpack = { Eye = vec3(0.02, -1.52, 2.30), Look = vec3(0.0, -0.24, 0.95), Fov = 51.0 }, -- drawer, carton and bin together during unpacking
                    Book = { Back = 0.34, Up = 0.0, Fov = 40.0 }, -- square on to the open handbook (Layout.Book): Back = metres out from its pages
                    Wire = { Back = 0.2, Up = 0.62, Fov = 40.0, Close = 0.7, Meter = 1.24 }, -- the view down into the open case while the pliers cap its blocks; Close = how much nearer it comes to the block being wired, Meter = how much further off it stands with the multimeter laid out before the case

                    Prep = { Back = 0.34, Up = 0.42, Fov = 40.0 }, -- over the mat's front edge while a length of wire is cut to length and stripped (Steps.Prep)
                    Board = { Eye = vec3(0.4, -0.62, 1.46), Look = vec3(0.36, 0.41, 1.3), Fov = 50.0 }, -- the view of the pegboard, to hang a tool up or take one down
                    Shelf = { Eye = vec3(0.0, -1.75, 0.8), Look = vec3(0.0, -0.22, 0.27), Fov = 46.0 } } }, -- the view under the bench, of the shelf things are stored on (Layout.Shelf)
        },
        -- One item per module. Rename an item here and in your inventory's item list; remove a
        -- line and that module cannot be built with (the random bombs still deal it).
        Modules = {
            wires = 'sd_mod_wires',
            button = 'sd_mod_button',
            keypads = 'sd_mod_keypads',
            simon = 'sd_mod_simon',
            whosOnFirst = 'sd_mod_whos_on_first',
            memory = 'sd_mod_memory',
            morse = 'sd_mod_morse',
            complicatedWires = 'sd_mod_complicated_wires',
            wireSequences = 'sd_mod_wire_sequences',
            mazes = 'sd_mod_mazes',
            passwords = 'sd_mod_passwords',
            ventingGas = 'sd_mod_venting_gas',
            capacitor = 'sd_mod_capacitor',
            knobs = 'sd_mod_knobs',
        },
    },

    -- Planting: the player AIMS first - a see-through casing shows how the bomb would sit on what
    -- they are looking at (standing on a floor, flat against a wall, under a ceiling); left click
    -- or E settles it, right click or Backspace backs out, the wheel turns a standing bomb. Then
    -- a cancellable progress bar, and the bomb is armed right there. The bomb it deals uses
    -- config.Bomb.Defaults (random seed), exactly like a bare /bomb_plant.
    Plant = {
        Aim = true, -- false = the old way: no aiming, the bomb is set on the ground in front of you
        Reach = 2.5, -- metres from you a spot may be (the server allows a little more for lag, no further)
        FloorNormal = 0.7, -- how level a surface must be to STAND a bomb on it (its normal's z); steeper = hung on it like a wall
        Standoff = 0.035, -- metres left between a wall and the casing's back, for the modules on its back face
        TurnStep = 15.0, -- degrees per wheel click
        Surfaces = { floor = true, wall = true, ceiling = true }, -- set one to false to refuse it
        -- true = while a player aims, every wall near enough shows what THEIR bomb would do to it: the hole it would
        -- open (the wall shown breached, right where the blast would put it), or why not - too tough for its charge,
        -- no room for another hole, out of reach. false = they find out when it goes off. (Admins always see it.)
        Preview = true,
        Hud = 'own', -- 'own' = the placing panel at the bottom of the screen (the same look as the admin placer); 'textui' = ox_lib's text UI
        -- Planting as a moment (client/bomb/plantfx.lua + aim.lua). Any animation the game does not have is skipped.
        Fx = {
            Glide = 18.0, -- how quickly the aimed bomb glides after the aim (0 = it jumps there)
            Outline = { breach = { 72, 214, 128 }, widen = { 72, 214, 128 }, tough = { 229, 163, 59 }, full = { 229, 163, 59 }, none = { 190, 205, 230 } }, -- by what it would do to the wall; false = none
            Carry = {
                Enabled = true, -- false = it is armed where it was aimed, the player just turning to it
                Hold = { dict = 'anim@heists@box_carry@', clip = 'idle', flag = 49 }, -- carried in front, both hands, walked up to the spot
                Grip = vec3(-0.105, 0.27, 0.03), -- the middle of the palms in that pose (the ped's space, measured): the bomb's middle, its face to the player
                WalkIf = 0.2, WalkTime = 4000, -- metres off where to stand before walking there; ms at most spent walking
                LowWall = 1.0, -- metres up a wall below which it is crouched to (wallLow) instead of pushed on at chest height
                -- Setting it on, by surface. Measured from each animation: where the hands' middle is at the moment they meet the
                -- surface (reach forward / side, metres in the ped's space as it started - where the player is stood so they
                -- land on it), when that is (contact, s), and when the gesture is over (stopAt, s) and the arming pose takes over.
                Place = {
                    -- arm = the pose held while it is armed (the progress bar), armReach = metres from the player to it for that pose.
                    -- (stopAt: once the gesture has stepped the player back - the push and the set-down both lean them in 0.3 m.)
                    wall = { dict = 'anim@heists@load_box', clip = 'load_box_1', reach = 1.1, ahead = true, side = -0.05, contact = 1.45, stopAt = 3.2, -- both arms, pushed on
                        arms = false }, -- (then stood back from it, hands off: the camera does the work - an arm = { dict, clip } here would play instead)
                    wallLow = { dict = 'weapons@projectile@sticky_bomb', clip = 'plant_vertical', reach = 0.36, side = -0.09, contact = 0.85, stopAt = 1.35,
                        arm = { dict = 'amb@medic@standing@kneel@base', clip = 'base', flag = 1 }, armReach = 0.45, armSide = 0.42 },
                    floor = { dict = 'amb@medic@standing@kneel@enter', clip = 'enter', reach = 0.5, side = 0.25, contact = 2.3, stopAt = 3.2, flag = 2, -- kneeling down to set it by them
                        arm = { dict = 'amb@medic@standing@kneel@base', clip = 'base', flag = 1 }, armReach = 0.23, armSide = 0.25 }, -- (where the kneel ends: no step)
                    ceiling = { dict = 'amb@prop_human_movie_bulb@base', clip = 'base', reach = 0.24, side = 0.03, contact = 0.5, stopAt = 1.2,
                        arm = { dict = 'amb@prop_human_movie_bulb@base', clip = 'base', flag = 1 }, armReach = 0.24 },
                },
                BlendIn = 250, -- ms the bomb takes from where it was carried to between the hands, as the animation starts
                PressTime = 260, -- ms from the hands onto the spot
                Shake = true, ShakeAmount = 0.03, -- a small jolt as it lands
            },
            Arm = { FadeIn = 0.06, Boot = 0.38, Decode = 0.16, ArmedAt = 0.82, BeepSlow = 520, BeepFast = 130 }, -- (fractions of Duration: the screen fades up, its boot bar fills to Boot, the countdown decodes in over Decode, it arms at ArmedAt; ms between beeps)
            -- The arming, directed (client/bomb/plantfx.lua > direct), in cinema bars (Letterbox: of the screen's height) with the
            -- HUD hidden, a shallow focus (Dof) and a handheld sway (Handheld). false = no camera move at all. Each shot is set
            -- out from the display in its own frame - Out of its face, Side across it, Rise up it (metres) - and kept within
            -- ~20 degrees of straight on: the display sits at the bottom of a well in its lid, and past that the digits are cut off.
            --   Open    from the start: over the player's shoulder, high, pushing in (Push)
            --   Close   at CloseAt (0-1 through the arming): straight at the display as its boot bar fills and it counts, from
            --           Out pushing in to OutTo
            --   Reveal  just before it arms: a quick pull back, wide, with a jolt, settling back (Drift)
            --   By      per way it went on (wall, wallLow, floor, ceiling), over the three above
            Camera = { Push = 0.15, EaseIn = 900, EaseOut = 800, Letterbox = 0.1, Dof = true, DofStrength = 1.0, Handheld = 0.18,
                Open = { Out = 1.5, Side = -0.45, Rise = 0.5, Fov = 38.0 },
                CloseAt = 0.18, Close = { Out = 0.42, OutTo = 0.3, Side = 0.02, Rise = 0.03, Fov = 30.0, Ease = 650 },
                RevealLead = 0.03, Reveal = { Out = 1.8, Side = -0.6, Rise = 0.5, Fov = 40.0, Ease = 420, Jolt = 0.08, Drift = 0.25 },
                By = { floor = { Open = { Out = 1.2, Side = -0.7, Rise = 0.55 }, Reveal = { Out = 1.7, Side = -0.75, Rise = 0.7 } },
                    wallLow = { Open = { Out = 1.2, Side = -0.7, Rise = 0.5 }, Reveal = { Out = 1.7, Side = -0.75, Rise = 0.6 } } } },
            Sounds = { -- { name, sound set } (frontend / from the bomb); remove one to silence it
                Snap = { 'CLICK_BACK', 'WEB_NAVIGATION_SOUNDS_PHONE' },
                Thunk = { 'Drill_Pin_Break', 'DLC_HEIST_FLEECA_SOUNDSET' },
                Beep = { 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS' },
                Armed = { 'Beep_Green', 'DLC_HEIST_HACKING_SNAKE_SOUNDS' },
            },
        },
        Duration = 4500, -- ms on the progress bar
        -- Held while arming it: kneeling for a bomb on the floor, hands up to it for one on a wall
        -- or overhead. false plants standing still.
        Anim = { dict = 'amb@medic@standing@kneel@base', clip = 'base', flag = 1 },
        AnimMounted = { dict = 'mini@repair', clip = 'fixing_a_player', flag = 17 },
    },

    -- Pose held while a UI is open, so other players see what you are up to (you only see the
    -- blurred world behind the page). Set either to false for no pose.
    Pose = {
        -- Reading the manual: clipboard in the left hand. bone 36029 = left hand; offset/rot are
        -- tuned for this dict + prop - re-tune if you swap either.
        Manual = {
            dict = 'missfam4', clip = 'base', flag = 49,
            prop = 'p_amb_clipboard_01', bone = 36029,
            offset = vec3(0.16, 0.08, 0.1), rot = vec3(-130.0, -50.0, 0.0),
        },
        -- Defusing: kneeling over the bomb - or standing at it, when it hangs on a wall or overhead.
        Defuse = { dict = 'amb@medic@standing@kneel@base', clip = 'base', flag = 1 },
        DefuseMounted = { dict = 'mini@repair', clip = 'fixing_a_player', flag = 17 },
        -- Building: kneeling over the open casing (the kit opened on the spot), or standing at a workbench.
        Build = { dict = 'amb@medic@standing@kneel@base', clip = 'base', flag = 1 },
        BuildAtBench = { dict = 'mini@repair', clip = 'fixing_a_player', flag = 1 },
    },
}
