---
title: Fallback Configuration
description: Configure item name and description fallbacks for Shops Pro.
---

# Fallback Configuration

The fallback configuration file (`configs/fallbacks.lua`) provides fallback display names and descriptions for items. These are used when the inventory system does not provide a name or description for an item.

::: info Config File Location
All options documented on this page are in `configs/fallbacks.lua`.
:::

## How Fallbacks Work

The script resolves item names and descriptions in the following priority order:

1. **Per-item overrides** -- `label` and `description` set directly on items in `BaseProducts`, shop `items`, or `ProductWhitelist` (highest priority)
2. **Inventory system** -- Names and descriptions fetched from your inventory (e.g., `ox_inventory`, `qb-inventory`)
3. **Fallback tables** -- `ItemNameFallbacks` and `ItemDescriptionFallbacks` from this file
4. **Auto-generated** -- If all else fails, the script converts the spawn name to a readable format (e.g., `twerks_candy` becomes `Twerks Candy`)

## Item Name Fallbacks

```lua
ItemNameFallbacks = {
    -- 24/7 Store Items
    ['water'] = 'Water Bottle',
    ['sandwich'] = 'Sandwich',
    ['coffee'] = 'Coffee',
    ['burger'] = 'Burger',
    ['cola'] = 'E-Cola',
    ['sprunk'] = 'Sprunk',
    ['tosti'] = 'Tosti',
    ['twerks_candy'] = 'Twerks Candy',
    ['cigarette'] = 'Cigarette',
    ['rolling_paper'] = 'Rolling Paper',
    ['scratchcard'] = 'Scratch Card',
    ['id_card'] = 'ID Card',
    ['driver_license'] = 'Driver License',

    -- Medical Items
    ['bandage'] = 'Bandage',
    ['painkillers'] = 'Painkillers',
    ['firstaid'] = 'First Aid Kit',
    ['medicalbag'] = 'Medical Bag',
    ['vicodin'] = 'Vicodin',
    ['morphine'] = 'Morphine',
    ['antibiotics'] = 'Antibiotics',
    ['gauze'] = 'Gauze',
    ['icepack'] = 'Ice Pack',
    ['heatpack'] = 'Heat Pack',

    -- Tools & Equipment
    ['phone'] = 'Phone',
    ['radio'] = 'Radio',
    ['radiocell'] = 'Radio Battery',
    ['lighter'] = 'Lighter',
    ['weapon_flashlight'] = 'Flashlight',
    ['lockpick'] = 'Lockpick',
    ['advancedlockpick'] = 'Advanced Lockpick',
    ['repairkit'] = 'Repair Kit',
    ['advancedrepairkit'] = 'Advanced Repair Kit',
    ['screwdriverset'] = 'Screwdriver Set',
    ['drill'] = 'Drill',
    ['powersaw'] = 'Power Saw',
    ['welding_torch'] = 'Welding Torch',
    ['cleaningkit'] = 'Cleaning Kit',
    ['electronickit'] = 'Electronic Kit',
    ['binoculars'] = 'Binoculars',

    -- Materials & Crafting
    ['metalscrap'] = 'Metal Scrap',
    ['plastic'] = 'Plastic',
    ['copper'] = 'Copper',
    ['iron'] = 'Iron',
    ['aluminium'] = 'Aluminium',
    ['glass'] = 'Glass',
    ['rubber'] = 'Rubber',
    ['wood'] = 'Wood',
    ['wood_planks'] = 'Wood Planks',
    ['md_nails'] = 'Nails',
    ['md_screw'] = 'Screws',

    -- Alcohol & Drinks
    ['beer'] = 'Beer',
    ['vodka'] = 'Vodka',
    ['whiskey'] = 'Whiskey',
    ['wine'] = 'Wine',
    ['tequila'] = 'Tequila',
    ['champagne'] = 'Champagne',
    ['rum'] = 'Rum',

    -- Snacks
    ['chips'] = 'Chips',
    ['chocolate'] = 'Chocolate',
    ['peanuts'] = 'Peanuts',

    -- Weapons
    ['weapon_pistol'] = 'Pistol',
    ['weapon_combatpistol'] = 'Combat Pistol',
    ['weapon_appistol'] = 'AP Pistol',
    ['weapon_pistol50'] = 'Pistol .50',

    -- Misc
    ['diving_crate'] = 'Diving Crate',
}
```

::: tip
If your inventory system provides labels for all items (which most do), these fallbacks will never be used. They exist as a safety net so items always have readable names even if the inventory lookup fails.
:::

## Item Description Fallbacks

```lua
ItemDescriptionFallbacks = {
    ['water'] = 'Refreshing bottled water to quench your thirst',
    ['sandwich'] = 'Fresh sandwich perfect for a quick meal',
    ['coffee'] = 'Hot coffee to keep you energized',
    -- ... more descriptions
}
```

Works the same way as name fallbacks but for item descriptions. The full list covers all default items across all shop types.

### Covered Item Categories

The fallback tables include entries for:

| Category | Example Items |
|---|---|
| 24/7 Store | `water`, `sandwich`, `coffee`, `burger`, `cola`, `sprunk`, `tosti` |
| Medical | `bandage`, `painkillers`, `firstaid`, `medicalbag`, `vicodin`, `morphine`, `antibiotics` |
| Tools | `phone`, `radio`, `lockpick`, `repairkit`, `drill`, `powersaw`, `welding_torch` |
| Materials | `metalscrap`, `plastic`, `copper`, `iron`, `aluminium`, `glass`, `rubber`, `wood` |
| Alcohol | `beer`, `vodka`, `whiskey`, `wine`, `tequila`, `champagne`, `rum` |
| Snacks | `chips`, `chocolate`, `peanuts` |
| Weapons | `weapon_pistol`, `weapon_combatpistol`, `weapon_appistol`, `weapon_pistol50` |
| Ammo/Attachments | `pistol_ammo`, `rifle_ammo`, `shotgun_ammo`, `weapon_suppressor`, `weapon_grip` |

## Adding Custom Fallbacks

If you add new items to your shops that your inventory system does not have labels/descriptions for, add entries to both tables:

```lua
-- In ItemNameFallbacks:
['my_custom_item'] = 'Custom Item Name',

-- In ItemDescriptionFallbacks:
['my_custom_item'] = 'Description of the custom item',
```
