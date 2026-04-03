---
title: Client Hooks
description: Client-side hook events for extending Shops Pro functionality.
---

# Client Hooks

Client hooks allow you to react to events on the client side. Use these to trigger custom UI effects, notifications, animations, sounds, or any client-side logic when specific shop events occur.

## How to Use Hooks

Hooks in sd-shops use a **callback registration system**, not standard FiveM events. Register handlers using either:

**From within the sd-shops resource** (in `client/hooks.lua`):

```lua
ClientHooks.Register('onShopOpened', function(data)
    print(('Shop opened: %s'):format(data.shopName))
end)
```

**From another resource** (via export):

```lua
exports['sd-shops']:registerClientHook('onShopOpened', function(data)
    print(('Shop opened: %s'):format(data.shopName))
end)
```

Both methods return a `handlerId` that can be used to unregister the hook later:

```lua
local id = exports['sd-shops']:registerClientHook('onShopOpened', function(data) ... end)
exports['sd-shops']:unregisterClientHook('onShopOpened', id)
```

---

## onShopOpened

Triggered when the shop UI is opened for the player.

```lua
ClientHooks.Register('onShopOpened', function(data)
    -- data.shopId (string) - The shop identifier
    -- data.shopName (string) - The display name of the shop
    -- data.shopType (string) - The type of shop

    print(('Opened shop: %s (%s)'):format(data.shopName, data.shopType))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |
| `shopName` | `string` | Display name of the shop |
| `shopType` | `string` | Shop type (e.g., `'247store'`, `'gunstore'`, `'pawn'`) |

---

## onShopClosed

Triggered when the shop UI is closed.

```lua
ClientHooks.Register('onShopClosed', function(data)
    -- data.shopId (string) - The shop identifier

    print(('Closed shop: %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier that was closed |

---

## onShopAccessDenied

Triggered when a player attempts to access a shop but is denied (wrong job, gang, opening hours, banned, etc.).

```lua
ClientHooks.Register('onShopAccessDenied', function(data)
    -- data.shopId (string) - The shop identifier
    -- data.reason (string) - The reason for denial

    print(('Access denied to %s: %s'):format(data.shopId, data.reason))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |
| `reason` | `string` | Reason for access denial |

---

## onPurchaseCompleted

Triggered when a purchase is successfully completed.

```lua
ClientHooks.Register('onPurchaseCompleted', function(data)
    -- data.shopId (string) - The shop identifier
    -- data.items (table) - List of purchased items
    -- data.totalPrice (number) - Total price paid

    print(('Purchased items for $%d at %s'):format(data.totalPrice, data.shopId))
    PlaySoundFrontend(-1, 'PURCHASE', 'HUD_LIQUOR_STORE_SOUNDSET', true)
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |
| `items` | `table` | Array of purchased items |
| `totalPrice` | `number` | Total price of the transaction |

---

## onPurchaseFailed

Triggered when a purchase attempt fails.

```lua
ClientHooks.Register('onPurchaseFailed', function(data)
    -- data.shopId (string) - The shop identifier
    -- data.reason (string) - The reason for failure

    print(('Purchase failed at %s: %s'):format(data.shopId, data.reason))
    PlaySoundFrontend(-1, 'ERROR', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |
| `reason` | `string` | Reason the purchase failed |

---

## onPawnShopSale

Triggered when the player sells items to a pawn shop.

```lua
ClientHooks.Register('onPawnShopSale', function(data)
    -- data.shopId (string) - The pawn shop identifier
    -- (additional sale data)

    print(('Sold items at pawn shop: %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Pawn shop identifier |

---

## onCouponApplied

Triggered when a coupon is successfully applied to a purchase.

```lua
ClientHooks.Register('onCouponApplied', function(data)
    -- data.couponCode (string) - The coupon code that was applied
    -- data.shopId (string) - The shop identifier

    print(('Coupon %s applied at %s'):format(data.couponCode, data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `couponCode` | `string` | The coupon code that was applied |
| `shopId` | `string` | Shop identifier where the coupon was used |

---

## onCouponValidationFailed

Triggered when a coupon code fails validation (expired, invalid, already used, etc.).

```lua
ClientHooks.Register('onCouponValidationFailed', function(data)
    -- data.couponCode (string) - The coupon code that failed
    -- data.shopId (string) - The shop identifier

    print(('Coupon %s failed at %s'):format(data.couponCode, data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `couponCode` | `string` | The coupon code that was rejected |
| `shopId` | `string` | Shop identifier |

---

## onGiftPurchaseCompleted

Triggered when the player successfully purchases a gift for another player.

```lua
ClientHooks.Register('onGiftPurchaseCompleted', function(data)
    -- data.shopId (string) - The shop identifier

    print(('Gift purchase completed at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

## onGiftReceived

Triggered on the recipient's client when they receive a gift from another player.

```lua
ClientHooks.Register('onGiftReceived', function(data)
    -- data.shopId (string) - The shop the gift was purchased from

    print(('You received a gift from shop %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier where the gift was purchased |

---

## onLoyaltyRewardClaimed

Triggered when the player claims a loyalty reward.

```lua
ClientHooks.Register('onLoyaltyRewardClaimed', function(data)
    -- data.shopId (string) - The shop identifier

    print(('Loyalty reward claimed at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

::: tip Integration Ideas
Use client hooks to:
- Play custom sounds on purchase completion or failure
- Trigger camera effects when opening/closing shops
- Show custom notifications using your preferred notification system
- Start animations when the player interacts with a shop
- Log client-side events for debugging
:::
