# What Types of Dirty Money Are Supported?

Several of our scripts (particularly **Shops Pro**) support dirty money / black money transactions for illegal shops and activities.

## Supported Types

| Type | Framework | Description |
|------|-----------|-------------|
| `black_money` | ESX | Default ESX black money account |
| `crypto` | QBCore | Cryptocurrency via QBCore |
| `markedbills` | Both | Physical marked bills item |
| Custom items | Both | Any item can be used as currency |

## How It Works

In **Shops Pro**, illegal shops can be configured to accept dirty money instead of regular cash:

```lua
['illegal_shop'] = {
    type = 'illegal',
    currency = 'black_money', -- or 'markedbills', or a custom item
    -- ...
}
```

## Using Custom Currency Items

You can configure any inventory item as the payment method. This is useful for custom economies:

```lua
['underground_market'] = {
    type = 'illegal',
    currency = 'gold_coin', -- Any item in your inventory system
    -- ...
}
```

::: info
When using an item as currency, the script will check the player's inventory for that item and deduct the appropriate quantity on purchase.
:::
