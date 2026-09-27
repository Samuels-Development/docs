return {
    -- Walls placed through the commands / the placement tool are written to data/walls.json and
    -- come back after a restart. Walls placed by another script decide for themselves
    -- (placeWall's opts.persistent, default false - a heist script rebuilds its own set).
    Persist = true,

    -- Admin commands (ace-restricted like any lib.addCommand). Set a name to false to not
    -- register that command. Whoever may run Place may also confirm a placement.
    Commands = {
        Restricted = 'group.admin',
        Place = 'wall_place', -- /wall_place [style] - places one wall with the gizmo (no style = the last one used); the panel does the same with a 3D picker
        Remove = 'wall_remove', -- /wall_remove - removes the wall nearest to you (within Reach)
        Break = 'wall_break', -- /wall_break - breaches the nearest wall, to see what it looks like
        Repair = 'wall_repair', -- /wall_repair [all] - rebuilds the nearest breached wall, or every one
        Clear = 'wall_clear', -- /wall_clear - removes EVERY wall (persistent ones included)
        Styles = 'wall_styles', -- /wall_styles - lists the style names
        Reach = 6.0, -- metres the "nearest wall" commands look around you
    },

    -- Placing itself is done with the gizmo (configs/shared/admin.lua > Placement), whether it is
    -- started from the /bombadmin panel, /wall_place or a wall-kit item.

    -- Optional ox_inventory "wall kit" items: using one starts the placement gizmo for its style and
    -- is consumed when the wall is built. Point each item at this resource's export in
    -- ox_inventory/data/items.lua:   server = { export = 'sd-bombs.useWallKit' }
    -- Players placing through an item need no ace. Leave the table empty to not use items at all.
    Items = {
        wallkit_drywall = 'drywall',
        wallkit_wood_planks = 'wood_planks',
        wallkit_corrugated_metal = 'corrugated_metal',
        wallkit_stucco_old = 'stucco_old',
        wallkit_brick_red = 'brick_red',
        wallkit_brick_painted = 'brick_painted',
        wallkit_cinder_block = 'cinder_block',
        wallkit_ledgestone = 'ledgestone',
        wallkit_stone_block = 'stone_block',
        wallkit_concrete = 'concrete',
        wallkit_concrete_reinforced = 'concrete_reinforced',
        wallkit_steel_plate = 'steel_plate',
        wallkit_wood_painted = 'wood_painted',
        wallkit_roller_shutter = 'roller_shutter',
        wallkit_tile_white = 'tile_white',
        wallkit_rusted_sheet = 'rusted_sheet',
        wallkit_concrete_painted = 'concrete_painted',
        wallkit_sandstone = 'sandstone',
        wallkit_basalt_stone = 'basalt_stone',
        wallkit_castle_stone = 'castle_stone',
    },
}
