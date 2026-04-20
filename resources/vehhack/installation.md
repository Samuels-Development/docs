# Installation

## Supported Inventories

| Inventory | Status |
|---|---|
| `ox_inventory` | Supported |
| `qb-inventory` | Supported |
| `ps-inventory` | Supported |
| `lj-inventory` | Supported |
| `qs-inventory` | Supported |
| `codem-inventory` | Supported |

::: tip Recommendation
We heavily recommend using `ox_inventory` — it's the best inventory system available and more importantly, it's completely free and open source!
:::

## Dependencies

Ensure the following dependencies are installed and running on your server before starting:

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` / `qbx_core` / `es_extended` |
| **ox_lib** | Yes | Callbacks, notifications, progress bars |
| **oxmysql** | Yes | Used by the `OWNER_SCAN` hack |
| **Inventory** | Yes | Any of the supported inventories listed above |

::: tip
Framework and inventory are automatically detected — no configuration needed.
:::

## <span class="step-num">1</span> Add the Resource

1. Download the latest version of `sd-vehhack` from the [CFX Portal](https://portal.cfx.re/assets/granted-assets)
2. Extract it into your server's `resources` directory
3. Ensure the resource is started in your `server.cfg` **in this order**:

```cfg
ensure oxmysql
ensure ox_lib
ensure ox_inventory
ensure qb-core

ensure sd-vehhack
```

## <span class="step-num">2</span> Add Items

Register the two required items in your inventory system:

::: code-group

```lua [ox_inventory]
["hacking_script"] = {
    label = "Hack Script",
    weight = 10,
    stack = true,
    close = true,
    consume = 0,
    description = "One-shot exploit script loaded onto your hacking device. Burned on execution.",
    client = {
        image = "hacking_script.png",
    },
},

["vehicle_hacking_device"] = {
    label = "Vehicle Hacking Device",
    weight = 500,
    stack = false,
    close = true,
    consume = 0,
    description = "Use Scripts to execute hacks on marked vehicles. Plug it in, aim, exploit.",
    client = {
        image = "vehicle_hacking_device.png",
    },
    server = {
        export = 'sd-vehhack.useVehicle_hacking_device'
    }
},
```

```lua [qb-core]
['hacking_script']         = { name = 'hacking_script',         label = 'Hack Script',            weight = 10,  type = 'item', image = 'hacking_script.png',         unique = false, useable = false, shouldClose = true, combinable = nil, description = 'One-shot exploit script loaded onto your hacking device. Burned on execution.' },
['vehicle_hacking_device'] = { name = 'vehicle_hacking_device', label = 'Vehicle Hacking Device', weight = 500, type = 'item', image = 'vehicle_hacking_device.png', unique = false, useable = true,  shouldClose = true, combinable = nil, description = 'Use Scripts to execute hacks on marked vehicles. Plug it in, aim, exploit.' },
```

```sql [ESX]
INSERT INTO items (name, label, weight, rare, can_remove) VALUES
('hacking_script',         'Hack Script',            10,  0, 1),
('vehicle_hacking_device', 'Vehicle Hacking Device', 500, 0, 1);
```

:::

## <span class="step-num">3</span> Add Item Images

Copy the item images from `sd-vehhack/images/` to your inventory's image folder. You can also download them directly from the container below.

<ItemImageGrid
  title="Vehicle Hacking Device Item Images"
  zipName="sd-vehhack-images"
  :images="[
    { src: '/items/vehhack/vehicle_hacking_device.png', name: 'vehicle_hacking_device.png', alt: 'Vehicle Hacking Device' },
    { src: '/items/vehhack/hacking_script.png', name: 'hacking_script.png', alt: 'Hack Script' },
  ]"
/>

## <span class="step-num">4</span> Start the Resource

To load the resource, you can either:

- **Restart your server** entirely, or
- Run the following commands in your **server console** (F8 or txAdmin live console):

```cfg
refresh
ensure sd-vehhack
```

## <span class="step-num">5</span> Give Yourself the Items

Grant yourself both items to test:

```cfg
/giveitem <yourId> vehicle_hacking_device 1
/giveitem <yourId> hacking_script 20
```

Use the hacking device from your inventory, aim at a vehicle, and click.

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
