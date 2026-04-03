# Installation

## Dependencies

Ensure the following resources are installed and running **before** sd-oxyrun:

| Dependency | Options |
|---|---|
| **Library** | `sd_lib` |
| **Zones** | `PolyZone` |
| **Database** | `oxmysql` |
| **Interaction** | `ox_target` / `qb-target` / `qtarget` (or use TextUI) |

## Step 1: Add the Resource

1. Download `sd-oxyrun` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add `ensure sd-oxyrun` to your `server.cfg` **after** all dependencies

```ini
ensure sd_lib
ensure ox_lib
ensure PolyZone
ensure oxmysql
ensure ox_target
ensure sd-oxyrun
```

::: tip
The `sd_oxyrun` database table is created automatically on first start. No manual SQL required.
:::

## Step 2: Add Items

Register the package item and reward items in your inventory system:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['package'] = {
    label = 'A Sealed Package',
    weight = 2500,
    stack = true,
    close = true,
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['package'] = { name = 'package', label = 'A Sealed Package', weight = 2500, type = 'item', image = 'package.png', unique = false, useable = false, shouldClose = true, description = 'A sealed package' },
```

```sql [ESX]
-- Import sd-oxyrun/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('package', 'A Sealed Package', 2500);
```

:::

Also ensure your reward items exist: `oxy`, `bands`, `rolls`, and any rare items configured in the level rewards.

## Step 3: Start and Verify

1. Start your server
2. Check the server console for any errors
3. The Boss NPC spawns at one of 3 random locations
4. Ensure the minimum police requirement is met before starting a run

::: warning
Make sure `sd_lib` is started **before** sd-oxyrun in your server.cfg, or the resource will fail to load.
:::

## Database Table

| Column | Type | Purpose |
|---|---|---|
| `Identifier` | VARCHAR(255) | Player identifier (license, steam, etc.) |
| `XP` | INT | Total reputation experience points |
