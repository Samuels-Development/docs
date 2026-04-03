# Installation

## Dependencies

Ensure the following resources are installed and running **before** sd-traphouse:

| Dependency | Options |
|---|---|
| **Library** | `sd_lib` |
| **Interaction** | `ox_target` / `qb-target` / `qtarget` |
| **Doorlock** | `ox_doorlock` / `qb-nui_doorlock` |

## Step 1: Add the Resource

1. Download `sd-traphouse` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add `ensure sd-traphouse` to your `server.cfg` **after** all dependencies

```ini
ensure sd_lib
ensure ox_lib
ensure ox_target
ensure ox_doorlock
ensure sd-traphouse
```

## Step 2: Import Doorlock Data

Import the front door entry for your doorlock system:

::: code-group

```sql [ox_doorlock]
-- Import sd-traphouse/doorlock/ox_doorlock/traphouse.sql into your database
-- This creates 1 door entry: traphouse-front
```

```lua [qb-nui_doorlock]
-- Copy the contents of sd-traphouse/doorlock/qb-nui_doorlock/traphouse.lua
-- into your qb-nui_doorlock config file
```

:::

## Step 3: Add Items

Register the required items in your inventory system:

::: code-group

```lua [ox_inventory]
-- Add to ox_inventory/data/items.lua

['gang-keychain'] = {
    label = 'Gang Keychain',
    weight = 100,
    stack = true,
    close = true,
},
['safecracker'] = {
    label = 'Safecracker Kit',
    weight = 500,
    stack = true,
    close = true,
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['gang-keychain'] = { name = 'gang-keychain', label = 'Gang Keychain',  weight = 100, type = 'item', image = 'gang-keychain.png', unique = false, useable = true, shouldClose = true, description = 'A gang keychain' },
['safecracker']   = { name = 'safecracker',   label = 'Safecracker Kit', weight = 500, type = 'item', image = 'safecracker.png',   unique = false, useable = true, shouldClose = true, description = 'Tools for cracking safes' },
```

:::

## Step 4: Start and Verify

1. Start your server
2. Check the server console for any errors
3. If `Config.Blip.Enable` is true, look for the **Vagos Traphouse** blip on the map
4. Ensure the minimum police requirement is met before attempting the robbery

::: warning
Make sure `sd_lib` is started **before** sd-traphouse in your server.cfg, or the resource will fail to load.
:::

::: tip
No database tables are required. All robbery state is managed in memory and resets on server restart.
:::
