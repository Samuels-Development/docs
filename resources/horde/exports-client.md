# Client Exports

Horde Mission provides client-side exports for querying game state, player status, and UI control from other scripts.

## IsPlayerInHorde

Check whether the local player is currently in a horde game.

**Syntax**
```lua
local inGame, gameState = exports['sd-horde']:IsPlayerInHorde()
```

| Return | Type | Description |
|---|---|---|
| `inGame` | `boolean` | `true` if the player is in an active horde game |
| `gameState` | `string` | The current game state (see below) |

| State | Description |
|---|---|
| `"none"` | Not in a game |
| `"starting"` | Game is starting |
| `"active"` | An enemy round is in progress |
| `"looting"` | Looting phase between rounds |
| `"perk_voting"` | Perk vote phase |
| `"ending"` | Game is ending |
| `"completed"` | All rounds finished |

**Example**
```lua
local inGame, state = exports['sd-horde']:IsPlayerInHorde()
if inGame then
    print('Player is in horde, current state: ' .. state)

    if state == 'active' then
        print('Combat is active!')
    elseif state == 'looting' then
        print('Looting phase between rounds')
    end
else
    print('Player is not in a horde game')
end
```

## GetCurrentRound

Get the current round number.

**Syntax**
```lua
local round = exports['sd-horde']:GetCurrentRound()
```

| Return | Type | Description |
|---|---|---|
| `round` | `number?` | Current round number (starting from 1), or `nil` if not in a game |

**Example**
```lua
local round = exports['sd-horde']:GetCurrentRound()
if round then
    print('Currently on round ' .. round)
end
```

## GetCurrentMap

Get the current map name.

**Syntax**
```lua
local mapName = exports['sd-horde']:GetCurrentMap()
```

| Return | Type | Description |
|---|---|---|
| `mapName` | `string?` | Map ID (e.g. `"server_farm"`), or `nil` if not in a game |

**Example**
```lua
local mapName = exports['sd-horde']:GetCurrentMap()
if mapName then
    print('Playing on map: ' .. mapName)
end
```

## OpenHordeMenu

Open the horde menu programmatically (the same menu shown when talking to the ped).

**Syntax**
```lua
local success = exports['sd-horde']:OpenHordeMenu()
```

| Return | Type | Description |
|---|---|---|
| `success` | `boolean` | `true` if menu was opened, `false` if the player is already in a game |

**Example**
```lua
local success = exports['sd-horde']:OpenHordeMenu()
if not success then
    print('Could not open menu — player is already in a game')
end
```

## IsPlayerDead

Check if the local player is currently dead/downed in a horde game.

**Syntax**
```lua
local isDead, reason = exports['sd-horde']:IsPlayerDead()
```

| Return | Type | Description |
|---|---|---|
| `isDead` | `boolean` | Whether the player is dead or downed |
| `reason` | `string?` | Debug reason for the detection |

**Example**
```lua
local isDead, reason = exports['sd-horde']:IsPlayerDead()
if isDead then
    print('Player is down, reason: ' .. (reason or 'unknown'))
end
```

## IsCarryingLoot

Check if the local player is currently carrying a loot object.

**Syntax**
```lua
local isCarrying, lootValue = exports['sd-horde']:IsCarryingLoot()
```

| Return | Type | Description |
|---|---|---|
| `isCarrying` | `boolean` | Whether the player is carrying loot |
| `lootValue` | `number` | Point value of the carried loot (0 if not carrying) |

**Example**
```lua
local isCarrying, lootValue = exports['sd-horde']:IsCarryingLoot()
if isCarrying then
    print('Carrying loot worth ' .. lootValue .. ' points')
end
```

## HasPendingGame

Check if the player has a pending game (heading to the entry location).

**Syntax**
```lua
local hasPending, isHost = exports['sd-horde']:HasPendingGame()
```

| Return | Type | Description |
|---|---|---|
| `hasPending` | `boolean` | Whether a pending game exists |
| `isHost` | `boolean` | Whether the player is the host of the pending game |

**Example**
```lua
local hasPending, isHost = exports['sd-horde']:HasPendingGame()
if hasPending then
    if isHost then
        print('You are hosting a pending game')
    else
        print('You are joining someone else\'s game')
    end
end
```

## GetPlayerLevel

Get the local player's level and XP information.

**Syntax**
```lua
local levelInfo = exports['sd-horde']:GetPlayerLevel()
```

| Return | Type | Description |
|---|---|---|
| `levelInfo` | `table?` | Table with `level`, `xp`, and `stats` fields, or `nil` if not loaded |

**Example**
```lua
local info = exports['sd-horde']:GetPlayerLevel()
if info then
    print('Level: ' .. info.level .. ', XP: ' .. info.xp)
    print('Total kills: ' .. (info.stats.kills or 0))
end
```

## CloseAllUI

Close any open horde UI elements (shop, perk selection, end game loot, HUD).

**Syntax**
```lua
local success = exports['sd-horde']:CloseAllUI()
```

| Return | Type | Description |
|---|---|---|
| `success` | `boolean` | Always `true` |

**Example**
```lua
-- Force close all horde UI when opening your own menu
exports['sd-horde']:CloseAllUI()
```

## Perk Exports

These exports are used to manage and query the perk system during a horde game. Perk IDs are strings matching the keys in the `VotePerks` config (e.g. `"double_damage"`, `"speed_demon"`, `"vampire"`).

::: info
Perk exports are primarily used internally by the script. They are exposed for advanced integrations where you need to query or modify perk states from external scripts.
:::

### ApplyPerk

Apply a perk to the local player.

**Syntax**
```lua
exports['sd-horde']:ApplyPerk(perkId)
```

| Parameter | Type | Description |
|---|---|---|
| `perkId` | `string` | The perk ID from config (e.g. `"double_damage"`) |

**Example**
```lua
exports['sd-horde']:ApplyPerk('double_damage')
```

### RemovePerk

Remove a specific active perk from the local player.

**Syntax**
```lua
exports['sd-horde']:RemovePerk(perkId)
```

| Parameter | Type | Description |
|---|---|---|
| `perkId` | `string` | The perk ID to remove |

**Example**
```lua
exports['sd-horde']:RemovePerk('double_damage')
```

### ClearAllPerks

Remove all active perks from the local player.

**Syntax**
```lua
exports['sd-horde']:ClearAllPerks()
```

### GetPerkModifiers

Get the combined modifier values from all currently active perks.

**Syntax**
```lua
local modifiers = exports['sd-horde']:GetPerkModifiers()
```

| Return | Type | Description |
|---|---|---|
| `modifiers` | `table` | Table of effect keys and their combined values (e.g. `{ damage = 2.0, speed = 1.5 }`) |

**Example**
```lua
local mods = exports['sd-horde']:GetPerkModifiers()
print('Damage modifier: ' .. (mods.damage or 1.0))
print('Speed modifier: ' .. (mods.speed or 1.0))
```

### IsPerkActive

Check if a specific perk is currently active.

**Syntax**
```lua
local active = exports['sd-horde']:IsPerkActive(perkId)
```

| Parameter | Type | Description |
|---|---|---|
| `perkId` | `string` | The perk ID to check |

| Return | Type | Description |
|---|---|---|
| `active` | `boolean` | Whether the perk is currently active |

**Example**
```lua
if exports['sd-horde']:IsPerkActive('infinite_ammo') then
    print('Player has infinite ammo active')
end
```

### GetActivePerks

Get a list of all currently active perk IDs.

**Syntax**
```lua
local perks = exports['sd-horde']:GetActivePerks()
```

| Return | Type | Description |
|---|---|---|
| `perks` | `table` | Array of active perk ID strings |

**Example**
```lua
local perks = exports['sd-horde']:GetActivePerks()
print(#perks .. ' perks active')
for _, perkId in ipairs(perks) do
    print('  - ' .. perkId)
end
```

### GetActivePerksForHUD

Get active perk data formatted for HUD display (includes labels and icons).

**Syntax**
```lua
local perks = exports['sd-horde']:GetActivePerksForHUD()
```

| Return | Type | Description |
|---|---|---|
| `perks` | `table` | Array of perk display tables with `id`, `label`, and `icon` fields |

### GetTotalDamageMultiplier

Get the combined damage multiplier from all active perks.

**Syntax**
```lua
local multiplier = exports['sd-horde']:GetTotalDamageMultiplier()
```

| Return | Type | Description |
|---|---|---|
| `multiplier` | `number` | Combined damage multiplier (1.0 = no change) |

**Example**
```lua
local dmg = exports['sd-horde']:GetTotalDamageMultiplier()
print('Dealing ' .. (dmg * 100) .. '% damage')
```

### GetDamageMultiplierForTarget

Get the damage multiplier for a specific target entity, accounting for perks like headshot bonuses.

**Syntax**
```lua
local multiplier = exports['sd-horde']:GetDamageMultiplierForTarget(entity)
```

| Parameter | Type | Description |
|---|---|---|
| `entity` | `number` | The target entity handle |

| Return | Type | Description |
|---|---|---|
| `multiplier` | `number` | Damage multiplier for this specific target |

### GetWeaponHandlingModifiers

Get weapon handling modifiers from active perks (recoil, spread, reload speed, etc.).

**Syntax**
```lua
local modifiers = exports['sd-horde']:GetWeaponHandlingModifiers()
```

| Return | Type | Description |
|---|---|---|
| `modifiers` | `table` | Table of weapon handling modifier values |

### GetLootValueMultiplier

Get the loot value multiplier from active perks.

**Syntax**
```lua
local multiplier = exports['sd-horde']:GetLootValueMultiplier()
```

| Return | Type | Description |
|---|---|---|
| `multiplier` | `number` | Loot value multiplier (1.0 = no change) |

**Example**
```lua
local lootMult = exports['sd-horde']:GetLootValueMultiplier()
print('Loot is worth ' .. (lootMult * 100) .. '% of base value')
```

### GetPointsMultiplier

Get the points multiplier from active perks.

**Syntax**
```lua
local multiplier = exports['sd-horde']:GetPointsMultiplier()
```

| Return | Type | Description |
|---|---|---|
| `multiplier` | `number` | Points multiplier (1.0 = no change) |

### HasInfiniteAmmo

Check if the player currently has infinite ammo from a perk.

**Syntax**
```lua
local has = exports['sd-horde']:HasInfiniteAmmo()
```

| Return | Type | Description |
|---|---|---|
| `has` | `boolean` | Whether infinite ammo is active |

### HasExplosiveRounds

Check if the player currently has explosive rounds from a perk.

**Syntax**
```lua
local has = exports['sd-horde']:HasExplosiveRounds()
```

| Return | Type | Description |
|---|---|---|
| `has` | `boolean` | Whether explosive rounds are active |

### HasThermiteRounds

Check if the player currently has thermite rounds from a perk.

**Syntax**
```lua
local has = exports['sd-horde']:HasThermiteRounds()
```

| Return | Type | Description |
|---|---|---|
| `has` | `boolean` | Whether thermite rounds are active |

### GetCurrencyMultiplier

Get the currency earning multiplier from active perks.

**Syntax**
```lua
local multiplier = exports['sd-horde']:GetCurrencyMultiplier()
```

| Return | Type | Description |
|---|---|---|
| `multiplier` | `number` | Currency earning multiplier (1.0 = no change) |

### GetHeadshotCurrencyBonus

Get the bonus currency earned per headshot kill from active perks.

**Syntax**
```lua
local bonus = exports['sd-horde']:GetHeadshotCurrencyBonus()
```

| Return | Type | Description |
|---|---|---|
| `bonus` | `number` | Bonus currency per headshot (0 = no bonus) |

### GetKillCurrencyBonus

Get the bonus currency earned per kill from active perks.

**Syntax**
```lua
local bonus = exports['sd-horde']:GetKillCurrencyBonus()
```

| Return | Type | Description |
|---|---|---|
| `bonus` | `number` | Bonus currency per kill (0 = no bonus) |

### GetEnemySpeedMultiplier

Get the enemy speed multiplier from active perks (debuffs from negative perks make enemies faster).

**Syntax**
```lua
local multiplier = exports['sd-horde']:GetEnemySpeedMultiplier()
```

| Return | Type | Description |
|---|---|---|
| `multiplier` | `number` | Enemy speed multiplier (1.0 = default speed) |

### GetEnemyHealthMultiplier

Get the enemy health multiplier from active perks.

**Syntax**
```lua
local multiplier = exports['sd-horde']:GetEnemyHealthMultiplier()
```

| Return | Type | Description |
|---|---|---|
| `multiplier` | `number` | Enemy health multiplier (1.0 = default health) |

### GetEnemyDamageMultiplier

Get the enemy damage multiplier from active perks.

**Syntax**
```lua
local multiplier = exports['sd-horde']:GetEnemyDamageMultiplier()
```

| Return | Type | Description |
|---|---|---|
| `multiplier` | `number` | Enemy damage multiplier (1.0 = default damage) |

### GetEnemyArmorMultiplier

Get the enemy armor multiplier from active perks.

**Syntax**
```lua
local multiplier = exports['sd-horde']:GetEnemyArmorMultiplier()
```

| Return | Type | Description |
|---|---|---|
| `multiplier` | `number` | Enemy armor multiplier (1.0 = default armor) |

### GetEnemyAccuracyMultiplier

Get the enemy accuracy multiplier from active perks.

**Syntax**
```lua
local multiplier = exports['sd-horde']:GetEnemyAccuracyMultiplier()
```

| Return | Type | Description |
|---|---|---|
| `multiplier` | `number` | Enemy accuracy multiplier (1.0 = default accuracy) |

### OnEnemyKilled

Notify the perk system that an enemy was killed. Triggers perk effects like heal-on-kill, ammo-on-kill, and currency bonuses.

**Syntax**
```lua
exports['sd-horde']:OnEnemyKilled(entity, isHeadshot)
```

| Parameter | Type | Description |
|---|---|---|
| `entity` | `number` | The killed enemy entity handle |
| `isHeadshot` | `boolean` | Whether the kill was a headshot |

### OnPlayerDamaged

Notify the perk system that the player took damage. Triggers perk effects like damage reduction, rage mode, and adrenaline.

**Syntax**
```lua
exports['sd-horde']:OnPlayerDamaged(damageAmount)
```

| Parameter | Type | Description |
|---|---|---|
| `damageAmount` | `number` | The amount of damage taken |

## Mystery Box Exports

### SpawnMysteryBox

Spawn a mystery box at a position in the world.

**Syntax**
```lua
exports['sd-horde']:SpawnMysteryBox(coords)
```

| Parameter | Type | Description |
|---|---|---|
| `coords` | `vector3` | World position to spawn the mystery box |

### RemoveMysteryBox

Remove a spawned mystery box.

**Syntax**
```lua
exports['sd-horde']:RemoveMysteryBox(boxId)
```

| Parameter | Type | Description |
|---|---|---|
| `boxId` | `number` | The mystery box identifier |

### UseMysteryBox

Interact with and use a mystery box (opens the random weapon roll).

**Syntax**
```lua
exports['sd-horde']:UseMysteryBox(boxId)
```

| Parameter | Type | Description |
|---|---|---|
| `boxId` | `number` | The mystery box identifier |

::: tip
Use exports sparingly in loops. Checking game state once per second (1000ms) is sufficient for most integration purposes.
:::
