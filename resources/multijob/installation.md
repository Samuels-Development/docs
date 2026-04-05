# Installation

## Dependencies

Ensure the following dependencies are installed and running on your server before starting:

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` / `qbx_core` / `es_extended` |
| **ox_lib** | Yes | |
| **oxmysql** | Yes | |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` |
| **Inventory** | Yes | Any of the supported inventories listed above |

::: tip
Framework, target system, and inventory are all automatically detected and used — you don't need to configure any of it.
:::

::: tip Recommendation
We heavily recommend using `ox_inventory` — it's the best inventory system available and more importantly, it's completely free and open source! You won't be missing out on any features in our scripts if you use a different inventory, this is simply a recommendation.
:::

## Step 1: Add the Resource

1. Download `sd-multijob` from [Keymaster](https://keymaster.fivem.net)
2. Extract it into your server's `resources` directory
3. Add the following to your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before.

```ini
ensure oxmysql
ensure ox_lib
ensure qb-core
ensure sd-multijob
```

::: tip
Three database tables (`saved_jobs`, `boss_menus`, `sd_multijob_settings`) are created automatically on first start. No manual SQL required.
:::

## Step 2: Start and Verify

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

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
