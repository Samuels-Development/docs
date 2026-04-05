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

## <span class="step-num">1</span> Add the Resource

1. Download the latest version of `sd-shops` from the [CFX Portal](https://portal.cfx.re/assets/granted-assets)
2. Extract it into your server's `resources` directory
3. Ensure the resource is started in your `server.cfg` (or `resources.cfg`, in case you load resources differently). Simply ensuring the sub-folder (i.e. `ensure [sd]`) will work too, provided dependencies are started in a separate sub-folder before. Here's an example:

```cfg
ensure oxmysql
ensure ox_lib
ensure qb-core
ensure ox_target
ensure ox_inventory

ensure sd-shops
```

## <span class="step-num">2</span> Start the Resource

To load the resource, you can either:

- **Restart your server** entirely, or
- Run the following commands in your **server console** (F8 or txAdmin live console):

```cfg
refresh
ensure sd-shops
```

## Configuration

Configure the resource to fit your server's needs. See the [Configuration](./config-main) pages for detailed explanations of each setting, or edit the files directly in the `configs/` folder.
