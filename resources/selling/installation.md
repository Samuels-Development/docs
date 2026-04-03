# Installation

## Dependencies

Ensure the following resources are installed and running **before** sd-selling:

| Dependency | Options |
|---|---|
| **Library** | `sd_lib` |
| **Target** | `ox_target` |
| **UI Library** | `ox_lib` |
| **Inventory** | `ox_inventory` (recommended) |
| **Database** | `oxmysql` |

## Step 1: Add the Resource

1. Download `sd-selling` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add `ensure sd-selling` to your `server.cfg` **after** all dependencies

```ini
ensure sd_lib
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure oxmysql
ensure sd-selling
```

::: tip
The `sd_cornerselling` database table is created automatically on first start. No manual SQL required.
:::

## Step 2: Add Items

If using money washing, ensure the cash items exist:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua (if not already present)

['bands'] = {
    label = 'Band of Cash',
    weight = 30,
    stack = true,
    close = true,
},
['rolls'] = {
    label = 'Roll of Cash',
    weight = 30,
    stack = true,
    close = true,
},
```

```sql [ESX]
-- Import sd-selling/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('bands', 'Band of Cash', 30),
  ('rolls', 'Roll of Cash', 30);
```

:::

Also ensure all drugs configured in `Config.Zones` and `Config.Delivery.Drugs` exist in your inventory system (e.g., `cokebaggy`, `crack_baggy`, `xtcbaggy`, `oxy`, `meth`, weed variants).

## Step 3: Start and Verify

1. Start your server
2. Check the server console for any errors
3. The Drug Lord NPC spawns at one of 3 random locations (for deliveries)
4. Approach NPCs in configured selling zones to start selling

::: warning
Make sure `sd_lib` is started **before** sd-selling in your server.cfg, or the resource will fail to load.
:::

## Database Table

| Column | Type | Purpose |
|---|---|---|
| `Identifier` | VARCHAR(255) | Player identifier |
| `XP` | INT | Total reputation experience points |
| `Stats` | JSON | Per-drug sales counts |
| `Milestones` | JSON | Redeemed milestone tracking |
