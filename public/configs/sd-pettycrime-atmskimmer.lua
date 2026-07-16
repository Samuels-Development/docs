return {
    Enable = true, -- Master on/off switch for this crime. false = fully disabled (no targets, no events).
    -- ============================================================================
    -- A delayed-payoff crime with continuous accumulation. The flow:
    --   1. Install:  player attaches a `skimmer` item to an ATM (~3s). On success
    --                a persistent interaction *zone* is placed at the ATM coords.
    --   2. Insert USB: from the "Check Skimmer" menu the owner inserts a `usb`
    --                item. The skimmer only records card data while a USB is in it.
    --   3. Scan:     the inserted USB gathers cards over time, capped at the
    --                per-level `capacity`. A partially-filled USB can be pulled and
    --                reinserted later (or moved to another skimmer) to top it up.
    --   4. Withdraw: the owner pulls the USB out — they keep the `usb` item with its
    --                stored cards/worth in metadata, and the skimmer stays installed
    --                ready for a fresh USB.
    --   5. Detach:   the owner pulls the whole skimmer off, getting the `skimmer`
    --                item back with its remaining durability stamped in metadata
    --                (and the inserted USB too, if one was in it).
    --
    -- Durability replaces the old random break roll: the device wears down while
    -- attached and as it scans, and despawns at 0 (the USB always survives).
    --
    -- The zone is keyed to world coords (not the ATM entity), so it survives the
    -- ATM streaming out/in and getting a fresh entity handle.
    --
    -- One skimmer per ATM at a time. Multiple players can each maintain their own
    -- skimmers across different ATMs, capped per-player by `MaxPerPlayer`.
    -- ============================================================================

    -- Skill-check minigame run while installing the skimmer. Enable = false to
    -- skip it. Swap `code` for any other minigame.* (see client/minigame.lua) or
    -- your own function returning true/false.
    Minigame = {
        Enable = true,
        Start = function()
            return Minigames.code({
                length       = 5, -- characters in the code
                timeLimitSec = 7, -- seconds before caught; 0 = no limit
            }).success
        end,
    },

    MaxPerPlayer = 5,                        -- Hard cap on simultaneously-installed skimmers per character.

    InstallItem  = 'skimmer',                 -- Skimmer device. Consumed at install; returned (with durability metadata) on manual detach.
    ShowTargetWithoutItem = false,            -- Show the install target even without the skimmer item (false = only show when you have it). Install still requires the item.
    UsbItem      = 'atm_skimmer_usb',          -- USB stick. One item type — blank vs loaded is told apart by `cards`/`worth` metadata.

    InstallTime   = 3,                        -- Seconds for the install progress bar.
    InsertUsbTime = 2,                        -- Seconds for the insert-USB progress bar.
    WithdrawTime  = 3,                        -- Seconds for the withdraw-USB progress bar.
    DetachTime    = 3,                        -- Seconds for the detach-skimmer progress bar.

    BaseXP       = 18,                        -- XP awarded each time a loaded USB is withdrawn.
    Logging      = true,

    ZoneRadius   = 1.6,                       -- Radius (m) of the "Check Skimmer" interaction sphere placed at the ATM.

    -- ── Durability ───────────────────────────────────────────────────────────
    -- The skimmer wears out instead of rolling a random break chance. Durability
    -- starts at `Max` on a fresh (shop-bought) skimmer and is stored in the item
    -- metadata, so a manually-detached skimmer remembers its wear and resumes from
    -- it when reinstalled. Two drains, both computed on read (no ticking):
    --   • DrainPerMinute — lost for every real minute the skimmer is attached,
    --                      whether or not a USB is recording. ("the more it's attached")
    --   • DrainPerCard   — lost for every card actually scanned onto a USB. ("the more it scans")
    -- When durability reaches 0 the skimmer despawns for good. Any inserted USB —
    -- and the card data already on it — survives and is returned to the owner.
    Durability = {
        Max            = 100,
        DrainPerMinute = 1.0,
        DrainPerCard   = 3.0,
    },

    -- Notification shown when the skimmer wears out (durability hit 0) and despawns.
    WornOutMessage = 'The skimmer wore out and crumbled — but you saved the USB.',

    -- Per-level skimmer behaviour. The level comes from the player's atmskimmer
    -- progression (see configs/config.lua). A level with no entry falls back to [1].
    --   capacity    : max cards an inserted USB will hold while scanned by a skimmer of this level.
    --   accrualSecs : real seconds to scan +1 card onto the inserted USB (compute-on-read, no ticking).
    --   worthMin/Max: per-card $ value range, rolled once when a USB is inserted and
    --                 used to value every card scanned during that insertion.
    Storage = {
        [1] = { capacity = 5,  accrualSecs = 500,  worthMin = 80,  worthMax = 150 },
        [2] = { capacity = 8,  accrualSecs = 360, worthMin = 120, worthMax = 220 },
        [3] = { capacity = 12, accrualSecs = 240, worthMin = 180, worthMax = 320 },
    },

    -- ATM prop hashes — the standard fleeca + generic ATMs that show up
    -- across LS. addModel attaches our install option to every world ATM.
    Models = {
        'prop_atm_01',
        'prop_atm_02',
        'prop_atm_03',
        'prop_fleeca_atm',
    },

    PoliceAlert = {
        Enable = true,
        Chance = 22, -- Skimmer install is quiet; collecting is even quieter. Single alert chance covers both phases.
        Send = function()
            -- Police alerts route through this resource's dispatch bridge at
            -- bridge/client/alert.lua, which auto-detects your dispatch system.
            -- You can freely change this Send function to whatever you want.
            Alert.send({
                displayCode = '10-21A',
                title       = 'ATM Tampering',
                message     = 'Suspicious activity at an ATM',
                description = 'Suspicious activity at an ATM',
                blipText    = '911 - ATM Tampering',
                sprite      = 431,
                colour      = 1,
                scale       = 1.1,
            })
        end,
    },
}
