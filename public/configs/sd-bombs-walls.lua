-- A wall is a RUN: one straight stretch of one style, 3 m tall and as long as the gap it closes
-- (any multiple of 0.25 m). The script lays it from modular props - solid pieces 2 / 1 / 0.5 / 0.25 m
-- wide - and re-lays it around a 2 m hole unit when it is breached, wherever along the run the blast
-- was: to the player it is one wall, not a row of blocks (shared/runs.lua). Each style ships
-- (stream/, built by blender/build_walls.py):
--   sdw_<style>_200, _100_p*, _050_p*, _025_p*   solid pieces (one per texture phase, so joints never show)
--   sdw_<style>_hole1..10   a stretch with a breach through it: ten shapes, 2 m wide or 4 m for the two a vehicle fits (shared/runs.lua > SHAPES)
--   sdw_<style>_rubble      what is left of a run too short to stand around a hole
--   sdw_<style>_debris1..3  loose chunks the blast throws around
--   sdw_<style>.ytd         the style's textures, shared by all of the above
-- A painted style ships the whole set once more, tinted (sdw_<style>__t_*): any colour of the chart is a row of its
-- tint palette (shared/runs.lua > paint), so a colour costs no files of its own.
return {
    Height = 3.0, -- metres; the props' real height - change it only if you rebuild them
    MaxLength = 40.0, -- metres; the longest single run (longer gaps: place two)

    -- Toughness is what an explosion's Power (configs/shared/breaking.lua) has to reach to breach
    -- the wall. 1 = anything that goes bang, 4 = only the heavy stuff (and the briefcase bomb).
    -- Fx picks the particle set in configs/shared/breaking.lua; Debris is how many chunks fly.
    -- Painted surfaces also come in colours: Colors lists the ones that were built for the style
    -- (keys into Colors below) and Stock is the swatch the panel shows for the style as it comes.
    -- A colour only exists if blender/build_walls.py built it - adding a name here is not enough.
    Styles = {
        drywall             = { label = 'Stud wall (plasterboard)', toughness = 1, fx = 'plaster', debris = 10, stock = '#B0A8A6', colors = { 'white', 'cream', 'sand', 'yellow', 'peach', 'terracotta', 'red', 'burgundy', 'pink', 'lilac', 'navy', 'blue', 'teal', 'mint', 'sage', 'green', 'olive', 'charcoal', 'black', 'brown' } },
        wood_planks         = { label = 'Timber plank wall', toughness = 1, fx = 'wood', debris = 10 },
        corrugated_metal    = { label = 'Corrugated iron sheeting', toughness = 1, fx = 'metal', debris = 8 },
        stucco_old          = { label = 'Old rendered wall', toughness = 1, fx = 'plaster', debris = 12, stock = '#E6D2B4', colors = { 'white', 'yellow', 'peach', 'terracotta', 'red', 'burgundy', 'pink', 'lilac', 'navy', 'blue', 'teal', 'mint', 'sage', 'green', 'olive', 'grey', 'charcoal', 'black', 'brown' } },
        wood_painted        = { label = 'Painted plank wall', toughness = 1, fx = 'wood', debris = 10, stock = '#5E7886', colors = { 'white', 'cream', 'sand', 'yellow', 'peach', 'terracotta', 'red', 'burgundy', 'pink', 'lilac', 'navy', 'blue', 'teal', 'mint', 'sage', 'green', 'olive', 'grey', 'charcoal', 'black', 'brown' } },
        roller_shutter      = { label = 'Steel roller shutter', toughness = 1, fx = 'metal', debris = 8, stock = '#8A9098', colors = { 'white', 'cream', 'sand', 'yellow', 'peach', 'terracotta', 'red', 'burgundy', 'pink', 'lilac', 'navy', 'blue', 'teal', 'mint', 'sage', 'green', 'olive', 'charcoal', 'black', 'brown' } },
        brick_red           = { label = 'Red brick wall', toughness = 2, fx = 'masonry', debris = 16 },
        brick_painted       = { label = 'Painted brick wall', toughness = 2, fx = 'masonry', debris = 16, stock = '#8CC0D2', colors = { 'white', 'cream', 'sand', 'yellow', 'peach', 'terracotta', 'red', 'burgundy', 'pink', 'lilac', 'navy', 'blue', 'teal', 'mint', 'sage', 'green', 'olive', 'grey', 'charcoal', 'black', 'brown' } },
        cinder_block        = { label = 'Cinder block wall', toughness = 2, fx = 'masonry', debris = 12, stock = '#3E342A', colors = { 'white', 'cream', 'sand', 'yellow', 'peach', 'terracotta', 'red', 'burgundy', 'pink', 'lilac', 'navy', 'blue', 'teal', 'mint', 'sage', 'green', 'olive', 'grey', 'charcoal', 'black' } },
        ledgestone          = { label = 'Dry-stacked stone wall', toughness = 2, fx = 'masonry', debris = 16 },
        tile_white          = { label = 'White tiled wall', toughness = 2, fx = 'plaster', debris = 16, stock = '#E4DED0', colors = { 'cream', 'sand', 'yellow', 'peach', 'terracotta', 'red', 'burgundy', 'pink', 'lilac', 'navy', 'blue', 'teal', 'mint', 'sage', 'green', 'olive', 'grey', 'charcoal', 'black', 'brown' } },
        rusted_sheet        = { label = 'Rusted sheet-steel wall', toughness = 2, fx = 'metal', debris = 8 },
        stone_block         = { label = 'Rough stone block wall', toughness = 3, fx = 'masonry', debris = 12 },
        concrete            = { label = 'Poured concrete wall', toughness = 3, fx = 'masonry', debris = 14 },
        concrete_painted    = { label = 'Painted concrete wall', toughness = 3, fx = 'masonry', debris = 14, stock = '#2F7048', colors = { 'white', 'cream', 'sand', 'yellow', 'peach', 'terracotta', 'red', 'burgundy', 'pink', 'lilac', 'navy', 'blue', 'teal', 'mint', 'sage', 'olive', 'grey', 'charcoal', 'black', 'brown' } },
        sandstone           = { label = 'Sandstone block wall', toughness = 3, fx = 'masonry', debris = 12 },
        basalt_stone        = { label = 'Fitted basalt wall', toughness = 3, fx = 'masonry', debris = 12 },
        castle_stone        = { label = 'Castle ashlar wall', toughness = 4, fx = 'masonry', debris = 10 },
        concrete_reinforced = { label = 'Reinforced concrete wall', toughness = 4, fx = 'masonry', debris = 14 },
        steel_plate         = { label = 'Riveted steel plate wall', toughness = 4, fx = 'metal', debris = 8 },
    },

    -- The paint chart: what the panel calls each colour and the swatch it shows for it.
    Colors = {
        white      = { label = 'White', hex = '#CCCAC4' },
        cream      = { label = 'Cream', hex = '#D4C6A4' },
        sand       = { label = 'Sand', hex = '#C4B08C' },
        yellow     = { label = 'Mustard yellow', hex = '#D0AE54' },
        peach      = { label = 'Peach', hex = '#D6A080' },
        terracotta = { label = 'Terracotta', hex = '#BE785E' },
        red        = { label = 'Barn red', hex = '#8E342C' },
        burgundy   = { label = 'Burgundy', hex = '#682830' },
        pink       = { label = 'Dusty pink', hex = '#C8969A' },
        lilac      = { label = 'Lilac', hex = '#A092B6' },
        navy       = { label = 'Navy', hex = '#2C3E5C' },
        blue       = { label = 'Dusty blue', hex = '#809CB6' },
        teal       = { label = 'Teal', hex = '#387A7C' },
        mint       = { label = 'Mint', hex = '#AAD0BE' },
        sage       = { label = 'Sage green', hex = '#96A88A' },
        green      = { label = 'Bottle green', hex = '#3E6E52' },
        olive      = { label = 'Olive', hex = '#6E7042' },
        grey       = { label = 'Grey', hex = '#929496' },
        charcoal   = { label = 'Charcoal', hex = '#3E4044' },
        black      = { label = 'Black', hex = '#222224' },
        brown      = { label = 'Brown', hex = '#684C38' },
    },

    SpawnDistance = 180.0, -- metres at which a wall's prop spawns via lib.points (and despawns)
}
