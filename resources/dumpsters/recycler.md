# Recycler

The Recycler system allows players to convert scavenged junk and scrap into processed materials at designated stations across the map. Configuration is in `configs/recycler.lua`.

## How It Works

1. **Visit a recycler station** marked on the map with a blip (if enabled)
2. **Interact** using the configured method (ped target, prop target, or box zone)
3. **Insert items** from your inventory into the recycler
4. **Start the recycling process** -- items are locked in and processing begins
5. **Wait for processing** to complete based on the configured time mode
6. **Collect recycled materials** -- claim or discard individual items or everything at once

::: info
Once the recycling process starts, inserted items cannot be retrieved. You can remove items before starting, but not after. Finished products must be collected before starting a new cycle.
:::

## Global Settings

```lua
Config.Recycling = {
    Enable = true,    -- Toggle the entire recycler system
    Shared = true,    -- true = recyclers shared among all players, false = per-player state

    RestrictAmount = { Enable = true, Amount = 50 }, -- Max items per recycler at once

    ProcessingTime = {
        useBaseTime = false,  -- true = flat time, false = per-item time
        baseTime    = 60,     -- Seconds (when useBaseTime is true)
        perItemTime = 1       -- Seconds per individual item (when useBaseTime is false)
    },
    -- ...
}
```

| Setting | Default | Description |
|---|---|---|
| `Enable` | `true` | Master toggle for the recycler system |
| `Shared` | `true` | When `true`, all players share the same recycler state. When `false`, each player has their own recycler instance |
| `RestrictAmount.Enable` | `true` | Limit the number of items that can be inserted at once |
| `RestrictAmount.Amount` | `50` | Maximum items per recycler (when restriction is enabled) |

## Processing Modes

### Per-Item Time (Default)

```lua
ProcessingTime = {
    useBaseTime = false,
    perItemTime = 1  -- 1 second per item
}
```

Each individual item adds time to the processing duration. Recycling 100 plastic items takes 100 seconds.

### Base Time (Flat)

```lua
ProcessingTime = {
    useBaseTime = true,
    baseTime = 60  -- 60 seconds regardless of quantity
}
```

All items process in a single batch with a fixed timer regardless of how many items are inserted.

| Mode | Best For | Example |
|---|---|---|
| **Per-Item** | Fair scaling for all batch sizes | 10 items = 10s, 50 items = 50s |
| **Base Time** | Simplified, encourages bulk recycling | 10 items = 60s, 50 items = 60s |

## Locations

Each recycler location is defined with its own coordinates, blip settings, and interaction method:

```lua
Locations = {
    {
        coords = vector3(44.22, -1040.55, 29.52),
        heading = 161.72,
        blipEnable = true,

        Interaction = {
            enablePed = true,
            pedModel = "s_m_y_dockwork_01",

            enableProp = false,
            propModel = "bzzz_prop_recycler_b",
            activePropModel = "bzzz_prop_recycler_a", -- Swaps to this model when processing

            enableBoxZone = false,

            distance = 1.5
        }
    },
    -- Add more locations...
}
```

### Interaction Methods

Each location supports **one** interaction method at a time. Enable only one and disable the others:

| Method | Setting | Description |
|---|---|---|
| **Ped Target** | `enablePed = true` | Spawns an NPC that players interact with via target |
| **Prop Target** | `enableProp = true` | Places a prop model that players interact with via target. Optionally swaps to `activePropModel` when processing |
| **Box Zone** | `enableBoxZone = true` | Creates an interaction zone at the coordinates |

::: warning
Do not enable multiple interaction methods for the same location. Only one should be set to `true` at a time.
:::

### Blip Configuration

Global blip appearance settings for all recycler locations:

```lua
Blip = {
    sprite = 365,
    scale = 0.75,
    color = 2,
    name = "Recycler",
    display = 4
},
```

Each individual location controls whether its blip is shown via `blipEnable = true/false`.

## Default Locations

The script ships with two default recycler locations:

| Location | Coordinates | Interaction |
|---|---|---|
| Near Legion Square | `vector3(44.22, -1040.55, 29.52)` | Ped (`s_m_y_dockwork_01`) |
| East Vinewood | `vector3(612.83, -471.45, 24.76)` | Ped (`s_m_y_dockwork_01`) |

## Recyclable Items

The recycler accepts **19 items** and converts them into processed materials. Below is the complete list from the default configuration:

### Full Item Table

| Input Item | Output Materials |
|---|---|
| `plastic_bottle` | `scrap_plastic` (1-2) + `plastic_cap` (1) |
| `cardboard` | `paper_scraps` (1-3) |
| `metalscrap` | `scrap_metal` (1-3) |
| `plastic` | `scrap_plastic` (1-2) |
| `glass` | `broken_glass` (1-2) |
| `rubber` | `rubber_chunk` (1) |
| `steel` | `scrap_steel` (1-3) |
| `bottle_cap` | `scrap_aluminum` (1-2) |
| `garbage` | `scrap_generic` (1-2) |
| `paperbag` | `paper_scraps` (1-3) |
| `cleaningkit` | `scrap_plastic` (1-2) + `scrap_cloth` (1-2) |
| `walkstick` | `wood_chunk` (1) |
| `lighter` | `metal_filings` (1) + `scrap_plastic` (1-2) |
| `toaster` | `scrap_metal` (1-2) + `scrap_electronics` (1) |
| `weapon_bottle` | `broken_glass` (1-2) |
| `lockpick` | `metal_filings` (1-2) |
| `10kgoldchain` | `gold_scraps` (1) |
| `ruby_earring_silver` | `silver_scraps` (1-2) + `ruby_chip` (1) |
| `goldearring` | `gold_scraps` (1-2) |
| `antique_coin` | `rare_metal` (1) |

### Output Materials

All recycled output items and their metadata (from `Config.ItemsMetadata`):

| Item Name | Display Label |
|---|---|
| `scrap_plastic` | Scrap Plastic |
| `plastic_cap` | Plastic Cap |
| `paper_scraps` | Paper Scraps |
| `scrap_metal` | Scrap Metal |
| `broken_glass` | Broken Glass |
| `rubber_chunk` | Rubber Chunk |
| `scrap_steel` | Scrap Steel |
| `scrap_aluminum` | Scrap Aluminum |
| `scrap_generic` | Generic Scrap |
| `scrap_cloth` | Scrap Cloth |
| `wood_chunk` | Wood Chunk |
| `metal_filings` | Metal Filings |
| `scrap_electronics` | Scrap Electronics |
| `gold_scraps` | Gold Scraps |
| `silver_scraps` | Silver Scraps |
| `ruby_chip` | Ruby Chip |
| `rare_metal` | Rare Metal |

::: warning
All input and output items must be registered in your inventory system. Refer to `Config.ItemsMetadata` in `configs/config.lua` for the complete list of item names and labels used throughout the script.
:::

## Adding Custom Recyclable Items

To add a new recyclable item, add an entry to the `Config.Recycling.Items` table:

```lua
{
    name = "your_item_name",       -- The input item
    recycleInto = {
        { name = "output_item_1", min = 1, max = 3 },  -- Output with quantity range
        { name = "output_item_2", min = 1, max = 1 },  -- Can have multiple outputs
    }
}
```

Also add corresponding entries to `Config.ItemsMetadata` for proper display labels and icons in the UI.

## Collection Menu

When recycling is complete, players interact with the recycler again to access the collection menu:

- **Grab Everything** -- collect all recycled materials at once
- **Toss Out Everything** -- discard all recycled materials
- **Collect/Discard individually** -- manage each output item with selectable quantities

::: info
Finished products must be collected (or discarded) before starting a new recycling cycle at that recycler.
:::
