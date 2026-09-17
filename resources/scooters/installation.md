# Installation

Follow these steps to install sd-scooters on your FiveM server.

## Supported Phones

The SCOOT rental app registers itself automatically with whichever phone is running. No phone configuration is needed.

| Phone | Status |
|---|---|
| `sd-phone` | Supported |
| `lb-phone` | Supported |

::: info
The phone app is how players rent and end rides. Bunkers, charging stations, the fleet, and the admin panel all work without a phone, but players will have no way to start a rental.
:::

## Dependencies

Ensure the following dependencies are installed and running on your server before starting:

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` / `qbx_core` / `es_extended` - needed for rental payments |
| **ox_lib** | Yes | |
| **oxmysql** | Yes | |
| **Phone** | Yes | `sd-phone` / `lb-phone` |
| **Target System** | Optional | `ox_target` for the charger screen - falls back to a text prompt without it |
| **Vehicle Keys** | Optional | `qbx_vehiclekeys` - renters are handed the keys when present |

::: tip
Framework, phone, target system, and vehicle keys are all automatically detected - no configuration needed. Every database table is created automatically on first start.
:::

## <span class="step-num">1</span> Add the Resource

1. Download the latest version of `sd-scooters` from the [CFX Portal](https://portal.cfx.re/assets/granted-assets)
2. Extract it into your server's `resources` directory
3. Ensure the resource is started in your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before. Here's an example:

```cfg
ensure ox_lib
ensure oxmysql
ensure qbx_core
ensure sd-phone

ensure sd-scooters
```

## <span class="step-num">2</span> Grant Admin Access

The admin panel uses ACE permissions. By default, everyone in `group.admin` gets full access - `command.scootadmin` to open the panel and `sd_scoot.edit` to change things. If your admins are already in `group.admin`, there is nothing to do.

To give another group **full** access, add this to your `server.cfg`:

```cfg
add_ace group.mod command.scootadmin allow
add_ace group.mod sd_scoot.edit allow
```

To give staff a **view-only** panel instead (they can look and teleport, but every change is refused), set `ViewGroup` in `configs/shared/admin.lua`:

```lua
ViewGroup = 'group.mod',
```

## <span class="step-num">3</span> Start the Resource

To load the resource, **restart your server** entirely.

::: danger Never restart sd-scooters with players connected
Stopping or restarting this resource while players are online **crashes their game**. It unloads the scooter's vehicle layout and animation set, which clients cannot survive mid-session. Changed models are also only picked up when a player connects, so a live restart gains nothing. Always restart it with the server empty, or restart the whole server.
:::

## <span class="step-num">4</span> Build Your Network

A fresh install seeds one bunker at **Legion Square** so you have something to look at. Everything else is placed in-game:

1. Run `/scootadmin` to open the admin panel
2. Open the **Bunkers** tab and place rental bunkers where players should pick scooters up
3. Open the **Stations** tab and place charging stations where scooters should be docked and charged
4. Open the **Scooters** tab to spawn scooters into bunkers

::: warning Keep charging stations at least 25 m apart
Every charger screen shows the station nearest the player within 12 m. Stations placed closer than that show each other's docks. The placement tool warns you when a station is too close to another one.
:::

See the [Admin Panel](./admin-panel) page for the placement controls and every panel feature.

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.

::: tip
Most everyday values - pricing, ride limits, battery drain, charging prices, and bunker stock - can also be changed **live** from the **Settings** tab of the admin panel, with no restart.
:::
