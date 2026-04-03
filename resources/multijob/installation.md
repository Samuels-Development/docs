# Installation

## Dependencies

Ensure the following resources are installed and running **before** sd-multijob:

| Dependency | Options |
|---|---|
| **Framework** | `qb-core` / `qbx_core` / `es_extended` |
| **Library** | `ox_lib` |
| **Database** | `oxmysql` |
| **Inventory** | `ox_inventory` (optional, for boss stash) |

## Step 1: Add the Resource

1. Download `sd-multijob` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add `ensure sd-multijob` to your `server.cfg` **after** all dependencies

```ini
ensure oxmysql
ensure ox_lib
ensure qb-core
ensure sd-multijob
```

::: tip
Three database tables (`saved_jobs`, `boss_menus`, `sd_multijob_settings`) are created automatically on first start. No manual SQL required.
:::

## Step 2: Configure Jobs

Open `config.lua` and define your jobs in `Config.Jobs`. Each job needs:

- A label and icon
- Boss grades (which grade levels can access the boss menu)
- Salary display values per grade
- Grade labels

```lua
Config.Jobs = {
    police = {
        label = 'Police',
        icon = 'shield',
        bossGrades = { 4 },
        salaries = {
            [0] = 50, [1] = 75, [2] = 100, [3] = 125, [4] = 150,
        },
        gradeLabels = {
            [0] = 'Recruit', [1] = 'Officer', [2] = 'Sergeant',
            [3] = 'Lieutenant', [4] = 'Chief',
        },
        stash = {
            enabled = true,
            slots = 50,
            weight = 100000,
        },
    },
}
```

## Step 3: Configure Duty & Boss Locations

Define duty toggle and boss menu locations per job in `Config.Zones`:

```lua
Config.Zones = {
    police = {
        duty = {
            enabled = true,
            interactionType = 'marker',  -- 'marker', 'textui', or 'target'
            locations = {
                {
                    coords = vec3(440.48, -976.02, 29.69),
                    distance = 3.0,
                },
            },
        },
        bossMenu = {
            enabled = true,
            interactionType = 'target',
            locations = { ... },
        },
    },
}
```

## Step 4: Start and Verify

1. Start your server
2. Check the server console for any errors
3. Use `/multijob` or press **F5** to open the job menu
4. Test duty toggle and boss menu locations

## Database Tables

Three tables are created automatically:

| Table | Purpose |
|---|---|
| `saved_jobs` | Stores player job rosters, grades, and stats |
| `boss_menus` | Stores society data, applications, transactions, and messages |
| `sd_multijob_settings` | Stores system settings (e.g., last weekly reset timestamp) |
