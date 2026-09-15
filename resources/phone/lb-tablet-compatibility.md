---
title: lb-tablet Compatibility
description: Answer lb-tablet's dispatch and MDT exports from sd-phone's own MDT, so scripts written for lb-tablet keep working after the switch to sd-tablet.
---

# lb-tablet Compatibility

Scripts that were written against lb-tablet call two families of exports: the dispatch ones, which push an alert to every terminal, and the MDT ones, which read and write officers, reports, warrants and weapons. sd-phone answers both families under the `lb-tablet` resource name, so a server moving from lb-tablet to sd-tablet does not have to run two tablets side by side while its other scripts catch up.

The layer is deliberately narrower than the [lb-phone one](./lb-phone-compatibility). lb-phone's exports map almost one to one onto phone features, so every name is registered. lb-tablet's MDT stores things sd-phone's MDT does not, and several of its exports have no source to check permissions against, so only the names that have a faithful equivalent are answered. Everything else is left unregistered on purpose, and the tables below say which is which.

::: info
Everything here needs the MDT itself, which is off by default. Set `Enabled = true` in `configs/mdt.lua` first. With it off, every export answers `nil` or `false` rather than erroring.
:::

## How it works

The same mechanism as the lb-phone layer: FiveM resolves `exports['lb-tablet']:Name(...)` through a `__cfx_export_lb-tablet_Name` event, and sd-phone binds handlers on those events directly. The server half lives in `server/compat/lbtablet/`, the client half in `client/compat/lbtablet.lua`. Dispatch calls go through the same quarantined mirror path as [`mdtMirrorCall`](./dispatch-mdt#mdtmirrorcall), and MDT calls go through the [native MDT exports](./exports-server#mdt-records-and-paperwork), so nothing here reaches the database by a route the terminal itself does not use.

The manifest declares `provide 'lb-tablet'`, which satisfies `GetResourceState('lb-tablet')` polls. Two things to know about that line:

- `provide` registers when the resource is **mounted**, so after adding sd-phone the server needs a full restart before the poll answers, not just an `ensure`.
- A leftover `lb-tablet` folder anywhere in the resources tree shadows the alias even when it is stopped. Remove the old resource rather than only stopping it.

## Enabling and disabling

On by default, with its own kill switch:

```cfg
set sd_phone_lbtabletcompat "false"   # disables the whole layer
```

If a real resource named `lb-tablet` is present and started, the layer does not register and a console line explains why. If the real lb-tablet starts mid-session, the layer deregisters its handlers and warns. As with lb-phone, consumers that already resolved an `exports['lb-tablet']` function keep the cached one until they restart.

## Dispatch exports

### Server

| Export | Behaviour |
|---|---|
| `AddDispatch(options)` | Files the alert on the police or medical call board through the quarantined mirror path. Returns a numeric id, or `false` when nothing was filed |
| `GetDispatch(id)` | The call behind an id in lb-tablet's `DispatchNotification` shape, or `nil` once it has expired or been taken off the board |
| `RemoveDispatch(id)` | Takes the call off the board early. `true` when something was removed |
| `UpdateDispatch(id, options)` | Not supported: the board has no in-place edit. Warns once and returns `false` |

**How `options` maps onto the board**

| lb-tablet field | On the board |
|---|---|
| `code`, `title` | The ten-code and the headline |
| `priority` | `high`, `medium`, `low` become `1`, `3`, `4`. Mirrored calls are floored at `2`, so `high` lands at `2` |
| `mdt`, `mdts` | `Police` routes to the police board, `Ambulance` and `Fire` to the medical one. `Mechanic` has no board and is refused with a warning rather than filed on the police one |
| `job` | Routed by job name the same way the automatic dispatch systems are |
| `location.label`, `location.coords` | Street text and map pin. A `vector2`, `vector3` or `{ x, y }` table all work |
| `description`, `fields` | Joined into the detail line as `description, label: value, ...`. A field whose label contains `weapon` fills the weapon slot instead |
| `time`, `image`, `sound`, `blip`, `responders`, `notificationTime` | Dropped. The board has no equivalent |

Ids are handed out per server session and the last 512 are remembered, which is well past the board's capacity. Everything that applies to a mirrored call applies here: the rate limit, the dedupe window, the mirrored share of the board and the priority floor are all described on the [dispatch page](./dispatch-mdt#how-mirrored-calls-behave).

### Client

| Export | Behaviour |
|---|---|
| `AddDispatch(options)` | Relays to the server, which files the alert as a client-raised one: the relay's per-character cooldown and proximity check run before the usual rate limit. Returns the numeric id or `false` |
| `ToggleDispatchVisible(visible)` | No-op. Dispatches are read on the board, not as a popup |
| `IsDispatchVisible()` | Always `true` |
| `IsDispatchOnScreen()` | Always `false` |
| `ViewDispatchInTablet(id)` | Always `false` |

## MDT exports

lb-tablet addresses an MDT by name. sd-phone's departments are configured by job in `configs/mdt.lua`, so a name is matched against the department's job, short code, label, or its lb-tablet label: `Police` for `leo` departments, `Ambulance` for `ems`, `Court` for `doj`. Where an export takes a `target` or `source`, either a server id or a citizenid is accepted, and the player has to be online.

### Shared, server and client

| Export | Behaviour |
|---|---|
| `GetMDTs()` | Every configured department keyed by its lb name, each as `{ name, department, deviceName, jobsArray, tabs }`. `tabs` is always empty: sd-phone's terminal is not tab-configured |
| `GetMDT(name)` | One of the above, or `nil` |
| `IsEmployeeOfMDT(name, source)` | Whether that player belongs to that department. On the client `source` is omitted and resolved server-side, so a client cannot claim a job it does not hold |
| `GetMDTPermissions(name, source)` | lb's `{ default, users, vehicles, reports, weapons, dispatch }` blocks with `view`, `create`, `edit`, `delete` booleans, derived from the permission keys the player actually holds |

### Staff

| Export | Behaviour |
|---|---|
| `GetMDTAccount(name, target)` | `{ id, name, avatar, callsign, rank }`, or `nil` when the target is not in that department |
| `GetMDTCallsign(name, target)`, `GetPoliceCallsign(target)`, `GetAmbulanceCallsign(target)` | The callsign or `nil` |
| `GetMDTAvatar(name, target)`, `GetPoliceAvatar(target)`, `GetAmbulanceAvatar(target)` | The avatar URL or `nil` |
| `SetMDTCallsign(name, target, callsign, ignoreCheck)`, `SetPoliceCallsign(...)`, `SetAmbulanceCallsign(...)` | Sets the callsign and returns it, or `false` with `invalid_target`, `invalid_callsign` or `callsign_taken`. Without `ignoreCheck` the write is audited and needs the roster permission; with it the callsign is written directly, but only within the target's own department |

### Persons, vehicles and weapons

| Export | Behaviour |
|---|---|
| `GetMDTUser(name, target)` | The police person record with `id` set to the citizenid. Police departments only; `false` for any other |
| `GetMDTVehicle(name, plate)` | The vehicle record with `id` set to the plate. Police only |
| `RegisterMDTWeapon(name, serial, data, registrant)`, `RegisterWeapon(serial, data)` | Files the firearm through [`mdtRegisterWeapon`](./exports-server#mdtregisterweapon). `data.weaponName` or `data.name` and `data.owner` are read. Returns the serial or `false` |
| `GetMDTWeapon(name, serial)` | The registry record with `id` set to the serial. Police only |
| `GetPolicePlayerCharges(identifier)` | `{ { id = code, charges = count }, ... }` for every unexpunged police charge against the citizen. `id` is the sd-phone offence code rather than a numeric lb id |

### Reports

| Export | Behaviour |
|---|---|
| `GetMDTReport(name, tabId, id)` | The report in lb's shape. Only `tabId = 'reports'` maps; any other tab returns `false` |
| `CreateMDTReport(name, tabId, creator, data)`, `UpdateMDTReport(...)` | Files or amends a report as `creator`, who must be an online employee of that department. Returns the numeric part of the report ref |
| `DeleteMDTReport(id)` | Deletes without an actor. `true` when a report was removed |
| `CreatePoliceReport(creator, data)`, `UpdatePoliceReport`, `GetPoliceReport(id)`, `DeletePoliceReport(id)` | The police aliases of the four above |
| `CreateAmbulanceReport(creator, data)`, `UpdateAmbulanceReport`, `GetAmbulanceReport(id)`, `DeleteAmbulanceReport(id)` | The medical aliases. `patient`, `doctors` and `injuries` map onto the medical report's roles and body |
| `GetPoliceCase(id)` | The case in lb's shape, read-only |
| `GetPoliceWarrant(id)` | The warrant in lb's shape, read-only |

A police report carrying `officers`, `weapons` or `tags` is **refused with a warning** rather than saved with those fields silently dropped. sd-phone reports store suspects, victims and witnesses and have no report-level weapon relation, so there is nowhere honest to put them.

## What is not registered

The following lb-tablet names are not answered, and a caller that uses one hits FiveM's usual "No such export" error. Check this list before relying on a name.

- **Case and warrant writes**: `CreatePoliceCase`, `UpdatePoliceCase`, `DeletePoliceCase`, `CreatePoliceWarrant`, `UpdatePoliceWarrant`, `DeletePoliceWarrant`. lb models these as report tabs with tags, arbitrary involved entities and sentencing; sd-phone's cases and warrants are separate entities with their own required fields and lifecycle, and an issued warrant flags the citizen as wanted across the server. Use [`mdtIssueWarrant`](./exports-server#mdtissuewarrant) and [`mdtSaveCase`](./exports-server#mdtsavecase) directly.
- **Report tabs other than `reports`**, and generic `CreateMDTReport` calls against them.
- Anything else lb-tablet documents that is not in the tables above.

::: tip
The native exports the layer is built on are documented under [MDT records and paperwork](./exports-server#mdt-records-and-paperwork). A script you maintain yourself should call those: they take the acting officer and walk the terminal's permission checks, where most of the lb-tablet names have to trust the calling resource instead.
:::
