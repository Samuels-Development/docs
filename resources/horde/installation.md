# Installation

Getting Horde Mission up and running on your server is straightforward. The script handles framework detection and database setup automatically.

## Supported Inventories

| Inventory | Status |
|---|---|
| `ox_inventory` | Fully supported |
| `tgiann-inventory` | Supported |
| `jaksam_inventory` | Supported |
| `qs-inventory` | Supported |
| `qs-inventory-pro` | Supported |
| `origen_inventory` | Supported |
| `qb-inventory` | Supported |
| `codem-inventory` | Supported |

## Dependencies

Before installing, make sure you have the following resources running on your server:

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` / `qbx_core` / `es_extended` |
| **Library** | Yes | `ox_lib` |
| **Database** | Yes | `oxmysql` |
| **Voice** | Optional | `pma-voice` (required for radio sync) |
| **Inventory** | Recommended | `ox_inventory` (required for inventory restrictions) |

::: info
The framework is auto-detected on startup. Target interactions use `ox_target` via `ox_lib`.
:::

## Step-by-Step Installation

### 1. Download and Extract

Download the `sd-horde` resource and place it in your server's resources directory:

```
resources/
  [standalone]/
    sd-horde/
```

::: tip
You can place the resource in any folder within your resources directory. The subfolder name does not matter.
:::

### 2. Add to Server Configuration

Add the following line to your `server.cfg`:

```ini
ensure sd-horde
```

Make sure it starts **after** all dependencies:

```ini
ensure qb-core       # or es_extended
ensure ox_lib
ensure oxmysql
ensure pma-voice      # optional, for radio sync
ensure ox_inventory   # optional, for inventory restrictions

ensure sd-horde
```

### 3. Start the Server

Start (or restart) your server. On first boot, Horde Mission will:

1. **Auto-detect your framework** (`qb-core` or `es_extended`) via the bridge system
2. **Create database tables** automatically via `oxmysql`
3. **Load locale files** based on the `Locale` setting in config (defaults to `en`)
4. **Load all map configs** from `configs/maps/`

::: info
No manual database setup is needed. All required tables are created on first start. If you need to reset data, you can safely drop the horde-related tables and they will be recreated.
:::

## Verifying Installation

After starting the server, check your server console for:

```
[SD-HORDE] Framework detected: qb
[sd-horde] Loaded map: server_farm
[sd-horde] Loaded map: cayo_estate
[sd-horde] Loaded map: doomsday_bunker
[sd-horde] Loaded map: gunrunning_bunker
[sd-horde] Map loader complete - 4 maps loaded
[SD-HORDE] Loaded locale: en
```

If you see errors, verify that:

- All dependencies are started before `sd-horde`
- Your `oxmysql` connection string is configured correctly
- The `configs/maps/` directory contains valid map files matching the names in `Config.Maps`

## Updating

To update Horde Mission:

1. Back up your current `sd-horde` folder (especially `configs/config.lua`, `configs/logs.lua`, and any customized map files)
2. Replace the resource files with the new version
3. Restart the resource or the server

::: tip
Configuration files are preserved during updates as long as you do not overwrite them. Always compare your config with the new version's defaults to check for new options.
:::

