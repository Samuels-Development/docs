-- Aggregate config root, loaded by both sides via `require 'configs.config'`.
-- Everything here is shared (client + server): the resource holds no secrets - a bomb is fully
-- described by its seed, and the seed is printed on the Defuser's screen.
-- Three parts live in this one resource: the briefcase bomb (Bomb / Items / Props), the breakable
-- walls it can blow a hole in (Walls / Breaking / Placement), and the admin panel over both (Admin).
local config = {
    Debug = false, -- dev logging (cyan [sd-bombs:*] lines); leave off in production

    -- Bridge diagnostics (bridge/shared/debug.lua): very verbose per-call prints from the
    -- framework/inventory bridge. Separate from Debug above so gameplay debugging doesn't drown
    -- in bridge traffic. DebugCategories filters by tag when set, e.g.
    -- { ['bridge:inventory'] = true } prints only that category.
    DebugPrints = false,
    -- DebugCategories = { ['bridge:inventory'] = true },

    Bomb = require 'configs.shared.bomb', -- bomb defaults, interaction, explosion, commands
    Items = require 'configs.shared.items', -- the bomb + manual inventory items, planting, held poses
    Props = require 'configs.shared.props', -- prop model names + where each piece attaches to the casing

    Walls = require 'configs.shared.walls', -- the wall styles: label, toughness, effects
    Breaking = require 'configs.shared.breaking', -- what breaches a wall, the bomb link, auto-repair, effects
    Placement = require 'configs.shared.placement', -- wall persistence, admin commands, wall-kit items

    Admin = require 'configs.shared.admin', -- the /bombadmin panel + the placement gizmo
}

return config
