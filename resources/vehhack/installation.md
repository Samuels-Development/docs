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
['phone_plug'] = {
    label = 'Phone Plug',
    weight = 80,
    stack = false,
    close = true,
    description = 'An OTG breakout dongle. Plugs into your phone to run vehicle exploits — needs a burner SIM to fire.',
    client = {
        image = 'usb_device.png',
        export = 'sd-vehhack.useHackingDevice'
    }
},
['hacking_sim'] = {
    label = 'Hacking SIM',
    weight = 5,
    stack = true,
    description = 'A pre-loaded burner SIM. One shot of exploit credits.',
    client = { image = 'tunerchip.png' },
},
```

```lua [qb-core]
['phone_plug']  = { name = 'phone_plug',  label = 'Phone Plug',  weight = 80, type = 'item', image = 'phone_plug.png',  unique = false, useable = true,  shouldClose = true,  combinable = nil, description = 'Plugs into your phone to run vehicle exploits.' },
['hacking_sim'] = { name = 'hacking_sim', label = 'Hacking SIM', weight = 5,  type = 'item', image = 'hacking_sim.png', unique = false, useable = false, shouldClose = false, combinable = nil, description = 'A pre-loaded burner SIM.' },
```

```sql [ESX]
INSERT INTO items (name, label, weight, rare, can_remove) VALUES
('phone_plug',  'Phone Plug',  5, 0, 1),
('hacking_sim', 'Hacking SIM', 1, 0, 1);
```

:::

::: tip Item Images
The `ox_inventory` example above reuses existing icons (`usb_device.png`, `tunerchip.png`). For custom art, drop your PNGs into your inventory's image folder and update the `image` field.
:::

## <span class="step-num">3</span> Start the Resource

To load the resource, you can either:

- **Restart your server** entirely, or
- Run the following commands in your **server console** (F8 or txAdmin live console):

```cfg
refresh
ensure sd-vehhack
```

## <span class="step-num">4</span> Give Yourself the Items

Grant yourself both items to test:

```cfg
/giveitem <yourId> phone_plug 1
/giveitem <yourId> hacking_sim 20
```

Use the phone plug from your inventory, aim at a vehicle, and click.

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
