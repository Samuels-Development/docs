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
Framework, target system, and inventory are all automatically detected — no configuration needed. Any required database tables are also created automatically on first start.
:::

::: tip Recommendation
We heavily recommend using `ox_inventory` — it's the best inventory system available and more importantly, it's completely free and open source! You won't be missing out on any features in our scripts if you use a different inventory, this is simply a recommendation.
:::

## <span class="step-num">1</span> Add the Resource

1. Download the latest version of `sd-multijob` from the [CFX Portal](https://portal.cfx.re/assets/granted-assets)
2. Extract it into your server's `resources` directory
3. Ensure the resource is started in your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before. Here's an example:

```cfg
ensure oxmysql
ensure ox_lib
ensure qb-core

ensure sd-multijob
```

## <span class="step-num">2</span> Start the Resource

To load the resource, you can either:

- **Restart your server** entirely, or
- Run the following commands in your **server console** (F8 or txAdmin live console):

```cfg
refresh
ensure sd-multijob
```

## Database Tables

Three tables are created automatically:

| Table | Purpose |
|---|---|
| `saved_jobs` | Stores player job rosters, grades, and stats |
| `boss_menus` | Stores society data, applications, transactions, and messages |
| `sd_multijob_settings` | Stores system settings (e.g., last weekly reset timestamp) |

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./configuration) page for detailed explanations of each setting, or edit the config files directly in the resource's `configs/` folder.
