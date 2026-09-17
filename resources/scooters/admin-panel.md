# Admin Panel

The admin panel is where the whole rental network is built and run - placing bunkers and charging stations, managing the fleet, watching rides, tuning handling, and changing prices live. Open it with `/scootadmin`. Configuration is in `configs/shared/admin.lua`.

## Permissions

| Access | Who | What they can do |
|---|---|---|
| **Full** | `Config.Admin.Group` (default `group.admin`) | Open the panel and change anything |
| **View-only** | `Config.Admin.ViewGroup` (default off) | Open the panel, see everything, and teleport. Every change is refused server-side |

Full access is made of two ACEs: `command.scootadmin` to open the panel, and `sd_scoot.edit` to change things. Both are granted to `Group` automatically. To let another group edit, add this to your `server.cfg`:

```cfg
add_ace group.mod command.scootadmin allow
add_ace group.mod sd_scoot.edit allow
```

## Commands

| Command | Description |
|---|---|
| `/scootadmin` | Opens the admin panel |
| `/scootflush` | Rebuilds station props and respawns idle scooters on every client. Does **not** reload changed model files |
| `/scootlift [metres]` | Debug: holds the nearest bunker above ground on your client. Run it again without a number to sink it |

## Tabs

### Overview

A dashboard for the whole network: revenue and rides today, riders right now, total stock, a 24-hour ride chart, and the battery spread across the fleet.

### Rides

- **Live rides** - see who is riding and end any ride (the rider is billed and the scooter docked as usual)
- **Totals** for today, the last 7 days, and all time
- **Revenue per start bunker**
- **Searchable history** of every ride, including unpaid ones
- Click a rider to see every ride they took and **refund** a paid ride (the rider must be online)

### Bunkers

- **Place** a new bunker with the placement tool
- Rename, enable or disable, teleport to, and delete
- Click a bunker to open its detail drawer and **set its stock**

### Stations

- **Place** a new charging station, choosing its colour and number of docks
- Move, repaint, rename, enable or disable, and delete
- Click a station to see each dock with the scooter's plate, charge, and charge target, and **release** a docked scooter

### Scooters

- **Search** by plate, **filter** by status, and **sort** by plate, battery, or distance
- **Multi-select** for bulk actions: set battery, lock, unlock, send home, respawn, and delete
- **Spawn on me** creates a scooter under you, seats you, and hands over the keys
- **Spawn at a bunker** in a chosen colour
- Click a scooter for its detail drawer: a **3D preview** in its paint, its current rider, and actions to teleport, bring to me, set battery, lock, send home, repaint, and respawn

### Map

- Every bunker, station, scooter, and live rider on a live map
- Nearby pins group into a count when zoomed out
- An **activity layer** draws recent ride starts and ends
- Switch between **atlas** and **satellite** tiles
- **Right-click** anywhere to teleport there

### Handling

The live handling editor - see [Handling Editor](#handling-editor) below.

### Settings

Change the most common config values live for the whole server and every client, with no restart. The charger screens update too.

| Group | Settings |
|---|---|
| **Pricing** | Unlock fee, price per minute, payment account |
| **Rides** | Max ride length, lock idle scooters, rent / bunker / dock distances, app radius |
| **Battery** | Drain rate, charge rate, minimum to rent, flat recovery time, adopted scooter level |
| **Charging** | Paid charging on/off, price per percent, minimum fee, target step, refund on stop, payment account |
| **Fleet** | Stock for newly created bunkers |

Overrides are saved to the database and take priority over the config files. Setting a value back to its config file default removes its override.

### Log

Every change made through the panel - who did what, and when - with search.

## Undo and Shortcuts

Deleting a bunker, station, or scooter can be **undone** from its toast for `UndoSeconds` (default 30). A restored item gets a new ID.

| Key | Action |
|---|---|
| `1`-`9` | Switch tabs |
| `/` | Focus search |
| `Esc` | Close the top-most drawer or dialog, then the panel |

## Placement Tool

Bunkers and charging stations are placed with the game's **native editor gizmo**. The whole assembly - the station totem, every dock, and the end cap - previews and moves as one. You can keep walking and looking around while placing.

| Key | Action |
|---|---|
| `Left Mouse` | Grab the gizmo |
| `G` | Toggle the mouse cursor |
| `W` / `R` | Move mode / rotate mode |
| `Q` | Toggle local / world axes |
| `Alt` | Drop to the ground |
| `X` | Toggle snapping |
| `T` | Toggle stick to ground |
| `Mouse Wheel` | Turn (`Shift` for 15°, `Ctrl` for 1°) |
| `Arrow Keys` / `Page Up` / `Page Down` | Nudge (`Shift` for faster) |
| `Ctrl + Z` / `Ctrl + Y` | Undo / redo |
| `Enter` | Place |
| `Backspace` | Cancel |

Rotation keeps only the heading, so placements always stay upright. The HUD warns when a placement is floating above the ground, or sits close enough to another station to share its charger screen.

::: tip
The gizmo keys can be rebound in **Settings > Key Bindings > FiveM**.
:::

## Handling Editor

The **Handling** tab tunes the scooter's handling live - no restart and no reconnect.

### Profiles

- A profile stores only the fields that differ from `data/handling.meta`
- **One profile can be live** at a time. Every client applies it to every scooter they see, including scooters spawned by other scripts
- With no live profile, `data/handling.meta` applies unmodified
- New profiles can start from a template: **Relaxed (25 mph)**, **Rental (40 mph)**, or **Sport (55 mph)**

### Quick Tune

Plain-language dials for **top speed**, **acceleration**, **grip**, **braking**, and **lean** set the raw handling values for you. Every raw field stays editable below the dials, with a reset back to the file value.

::: info
The real top speed comes from drive force against air drag, not from `fInitialDriveMaxFlatVel`. The top speed dial accounts for this. Confirm the result with a test ride.
:::

### Test Rides

- While you ride a scooter with the panel open, **unsaved edits apply to your scooter only**
- **Test ride** hides the panel, puts you on a scooter (spawning one if needed), and shows your speed, top speed, and 0-30 mph (or 0-50 km/h) time
- Press **`F7`** (`Config.Handling.ReturnKey`) to come back to the editor

### History and Export

- **History** records who changed what in each profile, with undo
- **Export** produces a complete `handling.meta` with your values filled in - use it to make a tuning the permanent default
