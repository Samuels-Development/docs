# Installation

Getting Horde Mission up and running on your server is straightforward. The script handles framework detection and database setup automatically.

## Requirements

Before installing, make sure you have the following resources running on your server:

| Dependency | Required | Notes |
|---|---|---|
| `qb-core` / `es_extended` | Yes | Any one supported framework |
| `ox_lib` | Yes | Utility library (used for zones, targets, points, callbacks) |
| `oxmysql` | Yes | Database driver |
| `pma-voice` | No | Required only if `RadioSync.enabled = true` |
| `ox_inventory` | No | Required for `InventoryRestrictions` (drop/give prevention) |

::: warning
The script only supports **QBCore** (`qb-core`) and **ESX** (`es_extended`). QBX (`qbx_core`) is not listed as a detected framework in the bridge code. Target interactions are handled through `ox_target` via `ox_lib` -- there is no separate target system detection.
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

## Troubleshooting

### Script fails to start

- Ensure all dependencies are listed **before** `sd-horde` in your `server.cfg`
- Check that `oxmysql` is connected to your database
- Check that `ox_lib` is the correct version and started

### Framework not detected

- The script checks for `qb-core` and `es_extended` via `GetResourceState()`. If neither returns `'started'`, the script will throw a critical error and stop
- Make sure your framework resource name matches exactly (`qb-core` or `es_extended`)

### Radio sync not working

- Confirm `pma-voice` is running and players can use radios normally outside of horde missions
- Ensure `RadioSync.enabled` is `true` in the config
- Check the radio channel configuration in [Configuration](/resources/horde/configuration)

### Players cannot interact with horde NPC

- Verify `ox_lib` is running (target interactions use `ox_target` via ox_lib)
- Make sure the ped spawns at the configured coordinates (check `Ped.coords` in config)
- Check that `Ped.enabled` is `true` and/or `Zone.enabled` is `true` for zone-based interaction

### Map fails to load

- Verify the map file name in `Config.Maps` matches the actual file name in `configs/maps/` (without `.lua` extension)
- Check server console for specific error messages from the map loader
