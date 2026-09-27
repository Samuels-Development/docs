-- The in-world bomb is assembled from generic props (stream/, built by blender/build_props.py):
-- one casing, plus a prop per bay and per edge widget attached to it where the seed dealt them.
-- The props show WHICH module sits WHERE - not that bomb's wire colours or symbols, which only
-- exist in the UI.
--
-- The numbers below are the UI's bomb dimensions (web/src/scene/layout.ts) times the prop scale.
-- blender/build_props.py prints them after every export - if you re-export at another SCALE,
-- copy its line over these. Prop space: +X right, -Y the FRONT face, +Z up, origin on the ground
-- under the casing's centre.
return {
    Casing = 'sd_bomb_casing',

    -- Bay props by module type (web/src/game/modules/index.ts ids, plus the timer and the blank cover).
    Modules = {
        timer = 'sd_bomb_mod_timer',
        empty = 'sd_bomb_mod_empty',
        wires = 'sd_bomb_mod_wires',
        button = 'sd_bomb_mod_button',
        keypads = 'sd_bomb_mod_keypads',
        simon = 'sd_bomb_mod_simon',
        whosOnFirst = 'sd_bomb_mod_whosonfirst',
        memory = 'sd_bomb_mod_memory',
        morse = 'sd_bomb_mod_morse',
        complicatedWires = 'sd_bomb_mod_complicatedwires',
        wireSequences = 'sd_bomb_mod_wiresequences',
        mazes = 'sd_bomb_mod_mazes',
        passwords = 'sd_bomb_mod_passwords',
        ventingGas = 'sd_bomb_mod_ventinggas',
        capacitor = 'sd_bomb_mod_capacitor',
        knobs = 'sd_bomb_mod_knobs',
    },

    -- Edge widget props. Indicators come lit and unlit, since a lit lamp reads from a distance.
    Widgets = {
        serial = 'sd_bomb_w_serial',
        batteryAA = 'sd_bomb_w_battery_aa',
        batteryD = 'sd_bomb_w_battery_d',
        indicator = 'sd_bomb_w_indicator',
        indicatorLit = 'sd_bomb_w_indicator_lit',
        ports = 'sd_bomb_w_ports',
    },

    -- The screw-down lids over a planted bomb's faces (the defusal screen's, web/src/scene/Cover.tsx; blender/build_lids.py):
    -- a frame per bay grid and a tile per bay - the timer's with a window over it. A lid comes off the bomb in the world, for
    -- everyone, once its defuser has unscrewed it. Enabled = false: planted bombs show their modules bare.
    Lids = {
        Enabled = true,
        -- the XL's frame round its bay grid; a compact case's round its whole face (blender/build_lids.py > FACES)
        Frames = { ['3x2'] = 'sd_bomb_lid_3x2', small = 'sd_bomb_lid_small', medium = 'sd_bomb_lid_medium', large = 'sd_bomb_lid_large' },
        Tile = 'sd_bomb_lid_tile',
        Window = 'sd_bomb_lid_window',
        Stand = 0.0824, -- metres from the XL casing's centre out to where a lid stands (layout.ts COVER.z: on its frame bars)
        CompactStand = 0.0, -- metres out from a compact case's face: right on it, its corner bolts inside the lid
    },

    Pitch = 0.1590, -- metres between bay centres (layout.ts PITCH)
    Lift = 0.2235, -- metres from the ground up to the casing's centre (half its height + the feet)
    FaceOffset = 0.0768, -- metres from the casing's centre out to a faceplate (layout.ts FACE_Z)
    EdgeOffset = 0.1785, -- metres from the casing's centre up/down to its top/bottom edge
    Feet = 0.045, -- metres the prop's origin is under its body: where its feet stood (it has none - it is set down this much lower)
    WidgetSpacing = 0.1380, -- metres between widget centres along an edge
    EdgeSeat = 0.004, -- metres the edge's clip plates stand off it (blender/build_bomb.py > edge_rails): the widgets sit on them
    -- The arming pin's port (config.Items.Builder.Steps.Pin), in the casing's space: on its right-hand end, low. The pin
    -- prop's origin sits there with its shaft along +X into the port; PinOut = where it hangs once pulled (on its lanyard).
    PinPort = vec3(0.262, 0.0, 0.1),
    PinOut = vec3(0.33, 0.0, 0.07),
}
