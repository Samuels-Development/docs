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
    weight = 200,
    stack = false,
    close = true,
    description = 'The first half of codes for the Yacht',
},
['casinocodes'] = {
    label = 'Casino Access Codes',
    weight = 200,
    stack = false,
    close = true,
    description = 'The first half of codes for the Casino',
},
['secured_safe'] = {
    label = 'Safe',
    weight = 200,
    stack = false,
    close = true,
    description = 'Meant to protect valuables',
},
['expensive_champagne'] = {
    label = 'Champagne',
    weight = 200,
    stack = true,
    close = true,
    description = 'A sparkling wine from France',
},
['default_gateway_override'] = {
    label = 'Gateway Override',
    weight = 200,
    stack = false,
    close = true,
    description = 'A default gateway override on a usb',
},
['revivekit'] = {
    label = 'Revival Kit',
    weight = 3000,
    stack = false,
    close = true,
    description = 'When your pal needs that pick me up',
},
```

```lua [qb-core]
-- Add to qb-core/shared/items.lua

['yachtcodes']               = { name = 'yachtcodes',               label = 'Yacht Access Codes',  weight = 200,  type = 'item', image = 'yachtcodes.png',               unique = true,  useable = true,  shouldClose = true,  description = 'The first half of codes for the Yacht' },
['casinocodes']              = { name = 'casinocodes',              label = 'Casino Access Codes', weight = 200,  type = 'item', image = 'casinocodes.png',              unique = true,  useable = true,  shouldClose = true,  description = 'The first half of codes for the Casino' },
['secured_safe']             = { name = 'secured_safe',             label = 'Safe',                weight = 200,  type = 'item', image = 'secured_safe.png',             unique = true,  useable = true,  shouldClose = true,  description = 'Meant to protect valuables' },
['expensive_champagne']      = { name = 'expensive_champagne',      label = 'Champagne',           weight = 200,  type = 'item', image = 'expensive_champagne.png',      unique = false, useable = true,  shouldClose = true,  description = 'A sparkling wine from France' },
['default_gateway_override'] = { name = 'default_gateway_override', label = 'Gateway Override',    weight = 200,  type = 'item', image = 'default_gateway_override.png', unique = true,  useable = true,  shouldClose = true,  description = 'A default gateway override on a usb' },
['revivekit']                = { name = 'revivekit',                label = 'Revival Kit',         weight = 3000, type = 'item', image = 'revivekit.png',                unique = true,  useable = true,  shouldClose = false, description = 'When your pal needs that pick me up' },
```

```sql [ESX]
-- Import sd-yacht/[SQL]/ESX/items.sql or run manually:

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('yachtcodes', 'Yacht Access Codes', 2),
  ('casinocodes', 'Casino Access Codes', 2),
  ('secured_safe', 'Safe', 2),
  ('expensive_champagne', 'Champagne', 2),
  ('default_gateway_override', 'Gateway Override', 2),
  ('revivekit', 'Revival Kit', 30);
```

:::

## Step 3: Copy Item Images

Copy the item images from `sd-yacht/images/` to your inventory's image folder:

| Inventory | Image Path |
|---|---|
| ox_inventory | `ox_inventory/web/images/` |
| qb-inventory / ps-inventory | `<inventory>/html/images/` |
| qs-inventory | `qs-inventory/html/images/` |
| codem-inventory | `codem-inventory/html/itemimages/` |
| origen_inventory | `origen_inventory/ui/images/` |

<ItemImageGrid
  title="Yacht Item Images"
  zipName="sd-yacht-images"
  :images="[
    { src: '/items/yacht/casinocodes.png', name: 'casinocodes.png', alt: 'Casino Codes' },
    { src: '/items/yacht/default_gateway_override.png', name: 'default_gateway_override.png', alt: 'Gateway Override' },
    { src: '/items/yacht/expensive_champagne.png', name: 'expensive_champagne.png', alt: 'Expensive Champagne' },
    { src: '/items/yacht/revivekit.png', name: 'revivekit.png', alt: 'Revive Kit' },
    { src: '/items/yacht/secured_safe.png', name: 'secured_safe.png', alt: 'Secured Safe' },
    { src: '/items/yacht/yachtcodes.png', name: 'yachtcodes.png', alt: 'Yacht Codes' },
  ]"
/>

::: tip
If you are using a custom inventory, place the images wherever your inventory loads item icons from.
:::

## Step 4: Start and Verify

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
