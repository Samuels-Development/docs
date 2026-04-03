# Installation

## Dependencies

Ensure the following resources are installed and running **before** sd-yacht:

| Dependency | Options |
|---|---|
| **Library** | `sd_lib` |
| **UI Library** | `ox_lib` |
| **Interaction** | `ox_target` / `qb-target` / `qtarget` (or use TextUI) |
| **Sound** | `InteractSound` (optional) |

## Step 1: Add the Resource

1. Download `sd-yacht` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add `ensure sd-yacht` to your `server.cfg` **after** all dependencies

```ini
ensure sd_lib
ensure ox_lib
ensure ox_target
ensure sd-yacht
```

## Step 2: Add Items

Register the required items in your inventory system:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['yachtcodes'] = {
    label = 'Yacht Access Codes',
    weight = 1500,
    stack = false,
    close = true,
},
['default_gateway_override'] = {
    label = 'Default Gateway Override',
    weight = 500,
    stack = true,
    close = true,
},
['casinocodes'] = {
    label = 'Casino Access Codes',
    weight = 1500,
    stack = false,
    close = true,
},
['secured_safe'] = {
    label = 'Safe',
    weight = 1500,
    stack = false,
    close = true,
},
['expensive_champagne'] = {
    label = 'Champagne',
    weight = 1500,
    stack = true,
    close = true,
},
['revivekit'] = {
    label = 'Revive Kit',
    weight = 2000,
    stack = true,
    close = true,
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['yachtcodes']               = { name = 'yachtcodes',               label = 'Yacht Access Codes',       weight = 1500, type = 'item', image = 'yachtcodes.png',               unique = true,  useable = true, shouldClose = true, description = 'Yacht access codes' },
['default_gateway_override'] = { name = 'default_gateway_override', label = 'Default Gateway Override', weight = 500,  type = 'item', image = 'default_gateway_override.png', unique = false, useable = true, shouldClose = true, description = 'USB gateway override' },
['casinocodes']              = { name = 'casinocodes',              label = 'Casino Access Codes',      weight = 1500, type = 'item', image = 'casinocodes.png',              unique = true,  useable = true, shouldClose = true, description = 'Casino access codes' },
['secured_safe']             = { name = 'secured_safe',             label = 'Safe',                     weight = 1500, type = 'item', image = 'secured_safe.png',             unique = true,  useable = false, shouldClose = true, description = 'A secured safe' },
['expensive_champagne']      = { name = 'expensive_champagne',      label = 'Champagne',                weight = 1500, type = 'item', image = 'expensive_champagne.png',      unique = false, useable = false, shouldClose = true, description = 'Expensive champagne' },
['revivekit']                = { name = 'revivekit',                label = 'Revive Kit',               weight = 2000, type = 'item', image = 'revivekit.png',                unique = false, useable = true, shouldClose = true, description = 'Medical revive kit' },
```

```sql [ESX]
-- Import sd-yacht/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('default_gateway_override', 'Default Gateway Override', 5),
  ('casinocodes', 'Casino Access Codes', 15),
  ('yachtcodes', 'Yacht Access Codes', 15),
  ('secured_safe', 'Safe', 15),
  ('expensive_champagne', 'Champagne', 15),
  ('revivekit', 'Revive Kit', 20);
```

:::

## Step 3: Start and Verify

1. Start your server
2. Check the server console for any errors
3. Look for the **Secured Yacht** blip on the map (if enabled)
4. Ensure the minimum police requirement is met (default: 4 cops)
5. You need `yachtcodes` item to start the heist

::: warning
Make sure `sd_lib` is started **before** sd-yacht in your server.cfg, or the resource will fail to load.
:::

::: tip
No database tables are required. All heist state is managed in memory and resets on server restart.
:::
