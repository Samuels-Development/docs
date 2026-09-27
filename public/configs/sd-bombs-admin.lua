-- Admin panel + placement tool. Both are the ones sd-scooters uses, so they look and handle the same.
return {
    Command = 'bombadmin', -- chat command that opens the panel; the ace it grants is command.bombadmin
    Group = 'group.admin', -- ace principal with full access: the command, every read and every change
    ViewGroup = false, -- optional ace principal (e.g. 'group.mod') that can open the panel and look, but not change anything
    EditAce = 'sd_bombs.edit', -- the ace every change needs; granted to Group automatically, add it to other principals to let them edit

    PlaceReach = 25.0, -- metres ahead of the camera a new placement starts when nothing closer is in view
    Placement = { -- the placement gizmo used for walls and bombs (panel, /wall_place and the wall-kit items alike)
        SnapMove = 0.25, -- metres per step while snapping is on (X)
        SnapTurn = 15.0, -- degrees per step while snapping is on
        Nudge = 0.05, -- metres per frame the arrow keys / Page Up / Page Down move it (Shift x5)
        TurnStep = 5.0, -- degrees per mouse-wheel notch (Shift + wheel: 15, Ctrl + wheel: 1)
    },

    RefreshMs = 2500, -- ms between snapshot refreshes while the panel is open (bomb clocks, breaches by players)
}
