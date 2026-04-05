---
title: Installation
description: How to install and set up Shops Pro for your FiveM server.
---

# Installation

Follow these steps to install Shops Pro on your FiveM server.

## Supported Inventories

| Inventory | Status |
|---|---|
| `ox_inventory` | Supported |
| `tgiann-inventory` | Supported |
| `jaksam_inventory` | Supported |
| `qs-inventory` | Supported |
| `qs-inventory-pro` | Supported |
| `origen_inventory` | Supported |
| `qb-inventory` | Supported |
| `ps-inventory` | Supported |
| `lj-inventory` | Supported |
| `codem-inventory` | Supported |

::: tip Recommendation
We heavily recommend using `ox_inventory` — it's the best inventory system available and more importantly, it's completely free and open source! You won't be missing out on any features in our scripts if you use a different inventory, this is simply a recommendation.
:::

## Dependencies

Ensure the following dependencies are installed and running on your server before starting:

| Dependency | Required | Notes |
|---|---|---|
| **Framework** | Yes | `qb-core` / `qbx_core` / `es_extended` |
| **ox_lib** | Yes | Must be started before `sd-shops` |
| **oxmysql** | Yes | Must be started before `sd-shops` |
| **Target System** | Yes | `ox_target` / `qb-target` / `qtarget` |
| **Inventory** | Yes | Any of the supported inventories listed above |

## Step 1 -- Add the Resource

Drag and drop the `sd-shops` folder into your server's `resources` directory.

```
resources/
  [standalone]/
  [qb]/
  sd-shops/        <-- place here
```

::: tip
Framework, target system, and inventory are all automatically detected and used — you don't need to configure any of it.
:::

Add the following to your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before.

```ini
ensure oxmysql
ensure ox_lib
ensure qb-core       # or es_extended
ensure ox_target      # or qb-target / qtarget
ensure ox_inventory   # or any other supported inventory

ensure sd-shops
```

## Step 2 -- Start Your Server

Start your server. On the first boot, Shops Pro will:

1. Detect your framework automatically (QBCore or ESX)
2. Detect your inventory system automatically
3. Detect your target system automatically
4. Create all required database tables
5. Spawn shop peds and blips at configured locations
6. Initialize the shop system

Check your server console for startup messages. You should see:
```
[SD-SHOPS] Framework detected: qb
[SD-SHOPS] Loaded locale: en
[SD-SHOPS] Server hooks system loaded
[SD-SHOPS] Client hooks system loaded
```

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./config-main) pages for detailed explanations of each setting, or edit the files directly in the `configs/` folder.
