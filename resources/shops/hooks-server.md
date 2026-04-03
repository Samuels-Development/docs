---
title: Server Hooks
description: Server-side hook events for extending Shops Pro functionality.
---

# Server Hooks

Server hooks allow you to react to events on the server side. Use these to integrate with external systems (MDT, Discord, dashboards), log activity, trigger custom server logic, or extend Shops Pro functionality.

## How to Use Hooks

Hooks in sd-shops use a **callback registration system**, not standard FiveM events. Register handlers using either:

**From within the sd-shops resource** (in `server/hooks.lua`):

```lua
ServerHooks.Register('onCustomerPurchase', function(data)
    print(('[SD-SHOPS] %s purchased %d items'):format(data.customerName, #data.items))
end)
```

**From another resource** (via export):

```lua
exports['sd-shops']:registerServerHook('onCustomerPurchase', function(data)
    print(('[SD-SHOPS] %s purchased %d items'):format(data.customerName, #data.items))
end)
```

Both methods return a `handlerId` that can be used to unregister the hook later:

```lua
local id = exports['sd-shops']:registerServerHook('onCustomerPurchase', function(data) ... end)
exports['sd-shops']:unregisterServerHook('onCustomerPurchase', id)
```

All hook callbacks receive a single `data` table with event-specific fields.

---

## Purchase Events

### onCustomerPurchase

Triggered when a customer completes a purchase at any shop. This is the primary server-side purchase hook.

```lua
ServerHooks.Register('onCustomerPurchase', function(data)
    print(('[SD-SHOPS] %s purchased %d items for $%d at %s'):format(
        data.customerName, #data.items, data.totalAmount, data.shopName))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `shopId` | `string` | Shop identifier |
| `shopType` | `string` | Shop type |
| `shopName` | `string` | Shop display name |
| `isShopOwned` | `boolean` | Whether the shop has an owner |
| `ownerIdentifier` | `string\|nil` | Owner's character identifier (if owned) |
| `items` | `table` | Array of purchased items |
| `totalAmount` | `number` | Total price paid |
| `subtotal` | `number` | Subtotal before discounts |
| `paymentMethod` | `string` | Payment method (`'cash'`, `'bank'`, `'society'`) |
| `societyName` | `string\|nil` | Society name if payment method is `'society'` |
| `customerIdentifier` | `string` | Buyer's character identifier |
| `customerName` | `string` | Buyer's character name |
| `discounts` | `table` | Applied discounts information |
| `couponCode` | `string\|nil` | Coupon code used |
| `couponDiscount` | `number\|nil` | Coupon discount percentage |
| `saleId` | `string\|nil` | Active sale ID |
| `saleName` | `string\|nil` | Active sale name |
| `saleDiscount` | `number\|nil` | Sale discount percentage |
| `loyaltyPointsEarned` | `number` | Loyalty points earned |
| `loyaltyDiscountPercent` | `number\|nil` | Loyalty membership discount |
| `timestamp` | `number` | Unix timestamp |

---

### onCustomerPurchaseForPlayer

Triggered when a gift purchase is completed for another player.

```lua
ServerHooks.Register('onCustomerPurchaseForPlayer', function(data)
    print(('[SD-SHOPS] Gift purchase completed at %s'):format(data.shopName))
end)
```

---

## Shop Ownership Events

### onShopPurchased

Triggered when a player purchases an unowned shop.

```lua
ServerHooks.Register('onShopPurchased', function(data)
    print(('[SD-SHOPS] %s purchased %s for $%d'):format(
        data.ownerName, data.shopName, data.purchasePrice))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `shopId` | `string` | Shop identifier |
| `shopType` | `string` | Shop type |
| `shopName` | `string` | Shop display name |
| `ownerIdentifier` | `string` | Buyer's character identifier |
| `ownerName` | `string` | Buyer's character name |
| `purchasePrice` | `number` | Purchase price |
| `paymentMethod` | `string` | Payment method used |
| `societyName` | `string\|nil` | Society name if applicable |
| `shopLocation` | `vector3\|nil` | Shop ped coordinates |
| `timestamp` | `number` | Unix timestamp |

---

### onShopSold

Triggered when a shop owner sells their shop back to the system.

```lua
ServerHooks.Register('onShopSold', function(data)
    print(('[SD-SHOPS] Shop %s sold'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onShopOwnershipTransferred

Triggered when shop ownership is transferred to another player.

```lua
ServerHooks.Register('onShopOwnershipTransferred', function(data)
    print(('[SD-SHOPS] Shop %s transferred'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onShopSettingsSaved

Triggered when a shop owner updates shop settings (name, blip, opening hours, etc.).

```lua
ServerHooks.Register('onShopSettingsSaved', function(data)
    print(('[SD-SHOPS] Settings updated for %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

## Employee Events

### onEmployeeHired

Triggered when a shop owner hires a new employee.

```lua
ServerHooks.Register('onEmployeeHired', function(data)
    print(('[SD-SHOPS] %s was hired at %s by %s'):format(
        data.employeeName, data.shopName, data.hiredBy))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |
| `shopName` | `string` | Shop display name |
| `employeeName` | `string` | Name of the hired employee |
| `hiredBy` | `string` | Name of the person who hired them |

---

### onEmployeeFired

Triggered when a shop owner fires an employee.

```lua
ServerHooks.Register('onEmployeeFired', function(data)
    print(('[SD-SHOPS] Employee fired at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onEmployeePermissionsUpdated

Triggered when an employee's permissions are changed.

```lua
ServerHooks.Register('onEmployeePermissionsUpdated', function(data)
    print(('[SD-SHOPS] Permissions updated at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

## Product Events

### onProductAdded

Triggered when a new product is added to a shop.

```lua
ServerHooks.Register('onProductAdded', function(data)
    print(('[SD-SHOPS] Product added to %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onProductRemoved

Triggered when a product is removed from a shop.

```lua
ServerHooks.Register('onProductRemoved', function(data)
    print(('[SD-SHOPS] Product removed from %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onProductUpdated

Triggered when a product's properties are updated (price, restrictions, etc.).

```lua
ServerHooks.Register('onProductUpdated', function(data)
    print(('[SD-SHOPS] Product updated in %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

## Coupon Events

### onCouponCreated

Triggered when a shop owner creates a new coupon.

```lua
ServerHooks.Register('onCouponCreated', function(data)
    print(('[SD-SHOPS] Coupon created at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onCouponDeleted

Triggered when a coupon is deleted.

```lua
ServerHooks.Register('onCouponDeleted', function(data)
    print(('[SD-SHOPS] Coupon deleted at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onCouponUsed

Triggered when a customer uses a coupon during checkout.

```lua
ServerHooks.Register('onCouponUsed', function(data)
    print(('[SD-SHOPS] Coupon used at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

## Sale Events

### onSaleCreated

Triggered when a shop owner creates a sale promotion.

```lua
ServerHooks.Register('onSaleCreated', function(data)
    print(('[SD-SHOPS] Sale created at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onSaleStatusChanged

Triggered when a sale's status changes (activated, deactivated).

```lua
ServerHooks.Register('onSaleStatusChanged', function(data)
    print(('[SD-SHOPS] Sale status changed at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onSaleDeleted

Triggered when a sale is deleted.

```lua
ServerHooks.Register('onSaleDeleted', function(data)
    print(('[SD-SHOPS] Sale deleted at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

## Stock Events

### onStockOrdered

Triggered when a shop owner places a stock order.

```lua
ServerHooks.Register('onStockOrdered', function(data)
    print(('[SD-SHOPS] Stock ordered at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onStockOrderCollected

Triggered when a delivered stock order is collected.

```lua
ServerHooks.Register('onStockOrderCollected', function(data)
    print(('[SD-SHOPS] Stock collected at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onStockTransferredToShop

Triggered when items are deposited from a player's inventory into shop stock.

```lua
ServerHooks.Register('onStockTransferredToShop', function(data)
    print(('[SD-SHOPS] Stock deposited at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onStockWithdrawnFromShop

Triggered when items are withdrawn from shop stock to a player's inventory.

```lua
ServerHooks.Register('onStockWithdrawnFromShop', function(data)
    print(('[SD-SHOPS] Stock withdrawn from %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

## Loyalty Events

### onLoyaltyPointsEarned

Triggered when a customer earns loyalty points from a purchase.

```lua
ServerHooks.Register('onLoyaltyPointsEarned', function(data)
    print(('[SD-SHOPS] Loyalty points earned at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onLoyaltyRewardRedeemed

Triggered when a customer redeems a loyalty reward.

```lua
ServerHooks.Register('onLoyaltyRewardRedeemed', function(data)
    print(('[SD-SHOPS] Loyalty reward redeemed at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onLoyaltySettingsSaved

Triggered when a shop owner updates the loyalty program settings.

```lua
ServerHooks.Register('onLoyaltySettingsSaved', function(data)
    print(('[SD-SHOPS] Loyalty settings updated at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

## Society Events

### onSocietyDeposit

Triggered when funds are deposited into a shop's society account.

```lua
ServerHooks.Register('onSocietyDeposit', function(data)
    print(('[SD-SHOPS] Society deposit at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onSocietyWithdrawal

Triggered when funds are withdrawn from a shop's society account.

```lua
ServerHooks.Register('onSocietyWithdrawal', function(data)
    print(('[SD-SHOPS] Society withdrawal from %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

## Customer Events

### onCustomerBanned

Triggered when a shop owner bans a customer.

```lua
ServerHooks.Register('onCustomerBanned', function(data)
    print(('[SD-SHOPS] Customer banned from %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

### onCustomerUnbanned

Triggered when a shop owner unbans a customer.

```lua
ServerHooks.Register('onCustomerUnbanned', function(data)
    print(('[SD-SHOPS] Customer unbanned from %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

## Upgrade Events

### onUpgradePurchased

Triggered when a shop owner purchases an upgrade.

```lua
ServerHooks.Register('onUpgradePurchased', function(data)
    print(('[SD-SHOPS] Upgrade purchased at %s'):format(data.shopId))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `shopId` | `string` | Shop identifier |

---

## Weapon Events

### onWeaponSerialGenerated

Triggered every time a weapon serial number is generated during a shop purchase. Use this to integrate with MDT systems, weapon registration databases, etc.

```lua
ServerHooks.Register('onWeaponSerialGenerated', function(data)
    print(('[SD-SHOPS] Weapon registered: %s (Serial: %s) to %s at %s'):format(
        data.weaponLabel, data.serial, data.characterName, data.shopName))
end)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `playerName` | `string` | Steam/FiveM display name |
| `characterName` | `string` | In-game character name (first + last) |
| `identifier` | `string` | Unique player identifier (citizenid / license) |
| `weaponName` | `string` | Item name (e.g., `'WEAPON_PISTOL'`) |
| `weaponLabel` | `string` | Display label (e.g., `'Pistol'`) |
| `serial` | `string` | Generated serial number (e.g., `'482917ABK637201'`) |
| `registered` | `string\|nil` | Registered owner name, or `nil` if `registerToOwner` is false |
| `shopId` | `string` | Shop ID (e.g., `'gunstore_1'`) |
| `shopName` | `string` | Shop display name |
| `shopType` | `string` | Shop type (e.g., `'gunstore'`, `'police_armory'`) |
| `timestamp` | `number` | Unix timestamp of the purchase |
| `metadata` | `table` | Full item metadata table |

### MDT Integration Example

```lua
-- From another resource via export
exports['sd-shops']:registerServerHook('onWeaponSerialGenerated', function(data)
    exports['your-mdt']:RegisterWeapon({
        serial = data.serial,
        weapon = data.weaponName,
        label = data.weaponLabel,
        owner = data.characterName,
        identifier = data.identifier,
        shopName = data.shopName,
        purchaseDate = os.date('%Y-%m-%d %H:%M:%S', data.timestamp),
    })
end)
```

---

::: tip Integration Ideas
Use server hooks to:
- Log transactions to a Discord webhook for audit trails
- Sync shop data with an external database or dashboard
- Track weapon serial numbers in a police MDT system
- Notify shop owners when sales occur while they are offline
- Implement custom anti-exploit logic on purchase events
- Send telemetry data to analytics platforms
:::
