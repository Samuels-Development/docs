# Exports

Horde Mission provides client and server exports for integration with other scripts. Use these to query game state, check player status, manage games programmatically, or hook into the perk and mystery box systems.

## Client Exports

### IsPlayerInHorde

Check whether the local player is currently in a horde game.

```lua
local inGame, gameState = exports['sd-horde']:IsPlayerInHorde()
-- Returns: boolean, string
```

**Returns:**
- `inGame` -- `true` if the player is in an active horde game
- `gameState` -- The current game state string

| State | Description |
|---|---|
| `"none"` | Not in a game |
| `"starting"` | Game is starting |
| `"active"` | An enemy round is in progress |
| `"looting"` | Looting phase between rounds |
| `"perk_voting"` | Perk vote phase |
| `"ending"` | Game is ending |
| `"completed"` | All rounds finished |

**Example:**

```lua
local inGame, state = exports['sd-horde']:IsPlayerInHorde()
if inGame then
    print('Currently in horde, state: ' .. state)
end
```

---

### GetCurrentRound

Get the current round number.

```lua
local round = exports['sd-horde']:GetCurrentRound()
-- Returns: number | nil
```

**Returns:** The current round number (starting from 1), or `nil` if not in a game.

---

### GetCurrentMap

Get the current map name.

```lua
local mapName = exports['sd-horde']:GetCurrentMap()
-- Returns: string | nil
```

**Returns:** The map ID string (e.g., `"server_farm"`), or `nil` if not in a game.

---

### OpenHordeMenu

Open the horde menu programmatically (the same menu shown when talking to the ped).

```lua
local success = exports['sd-horde']:OpenHordeMenu()
-- Returns: boolean
```

**Returns:** `true` if the menu was opened, `false` if the player is already in a game.

---

### IsPlayerDead

Check if the local player is currently dead/downed in a horde game.

```lua
local isDead, reason = exports['sd-horde']:IsPlayerDead()
-- Returns: boolean, string | nil
```

**Returns:**
- `isDead` -- Whether the player is dead or downed
- `reason` -- Debug reason for the detection (`"already_notified"`, `"revive_grace_period"`, etc.)

---

### IsCarryingLoot

Check if the local player is currently carrying a loot object.

```lua
local isCarrying, lootValue = exports['sd-horde']:IsCarryingLoot()
-- Returns: boolean, number
```

**Returns:**
- `isCarrying` -- Whether the player is carrying loot
- `lootValue` -- The point value of the carried loot (0 if not carrying)

---

### HasPendingGame

Check if the player has a pending game (heading to the entry location).

```lua
local hasPending, isHost = exports['sd-horde']:HasPendingGame()
-- Returns: boolean, boolean
```

**Returns:**
- `hasPending` -- Whether a pending game exists
- `isHost` -- Whether the player is the host of the pending game

---

### GetPlayerLevel

Get the local player's level and XP information.

```lua
local levelInfo = exports['sd-horde']:GetPlayerLevel()
-- Returns: table | nil
```

**Returns:** A table with `level`, `xp`, and `stats` fields, or `nil` if player data is not loaded.

```lua
local info = exports['sd-horde']:GetPlayerLevel()
if info then
    print('Level: ' .. info.level .. ', XP: ' .. info.xp)
end
```

---

### CloseAllUI

Close any open horde UI elements (shop, perk selection, end game loot, HUD).

```lua
local success = exports['sd-horde']:CloseAllUI()
-- Returns: boolean (always true)
```

---

## Server Exports

### IsPlayerInHorde

Check if a specific player is in a horde game.

```lua
local inGame, game, gameId = exports['sd-horde']:IsPlayerInHorde(source)
-- Returns: boolean, table | nil, string | nil
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

**Returns:**
- `inGame` -- Whether the player is in a game
- `game` -- The game session data table (if in game)
- `gameId` -- The game ID string (if in game)

---

### StartHordeGame

Start a horde game for a player (or their group). Creates a pending game and shows the entry location.

```lua
local gameId = exports['sd-horde']:StartHordeGame(source, mapName, difficultyId)
-- Returns: string | nil
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID (host) |
| `mapName` | `string` | Map ID from the Maps config (e.g., `"server_farm"`) |
| `difficultyId` | `string` | Difficulty ID (e.g., `"easy"`, `"normal"`, `"hard"`, `"nightmare"`) |

---

### ForceStartHordeGame

Force start a horde game immediately, skipping the entry location walkup.

```lua
local gameId = exports['sd-horde']:ForceStartHordeGame(source, mapName, difficultyId)
-- Returns: string | nil
```

Same parameters as `StartHordeGame`. The game begins immediately without players needing to travel to the entry point.

---

### StartHordeWithPlayers

The most flexible way to start a horde game. Pass any list of players in various formats.

```lua
local gameId, error = exports['sd-horde']:StartHordeWithPlayers(players, mapName, difficultyId, options)
-- Returns: string | nil, string | nil
```

| Parameter | Type | Description |
|---|---|---|
| `players` | `table` | Array of players in any format (see below) |
| `mapName` | `string` | Map ID |
| `difficultyId` | `string` | Difficulty ID |
| `options` | `table?` | Optional: `{ skipEntry = false, host = nil }` |

**Player formats accepted:**
- Simple array: `{1, 2, 3}` (server IDs)
- Object array: `{ {source = 1}, {source = 2} }`
- Named array: `{ {serverId = 1, name = "Player1"}, {id = 2} }`

**Options:**

| Key | Type | Default | Description |
|---|---|---|---|
| `skipEntry` | `boolean` | `false` | Skip the entry location and start immediately |
| `host` | `number` | First player | Which player is the host |

**Returns:** `gameId` on success, or `nil` and an error message string on failure.

```lua
local gameId, err = exports['sd-horde']:StartHordeWithPlayers(
    {1, 2, 3},
    "server_farm",
    "easy",
    { skipEntry = true }
)
if not gameId then
    print("Failed: " .. err)
end
```

---

### ForceEndGame

Force end a player's current game.

```lua
local success = exports['sd-horde']:ForceEndGame(source)
-- Returns: boolean
```

---

### GetActiveGames

Get a list of all currently active horde games.

```lua
local games = exports['sd-horde']:GetActiveGames()
-- Returns: table
```

**Returns:** An array of tables, each containing:

| Field | Type | Description |
|---|---|---|
| `gameId` | `string` | Unique game session ID |
| `map` | `string` | Map identifier |
| `difficulty` | `string` | Difficulty identifier |
| `playerCount` | `number` | Number of players in game |
| `players` | `table` | Array of player server IDs |
| `currentRound` | `number` | Current round number |
| `state` | `string` | Current game state |
| `money` | `number` | Current team money/coins |

---

### GetPlayerGameInfo

Get detailed information about a player's current game.

```lua
local info = exports['sd-horde']:GetPlayerGameInfo(source)
-- Returns: table | nil
```

**Returns:** A table with:

| Field | Type | Description |
|---|---|---|
| `gameId` | `string` | Game session ID |
| `map` | `string` | Map ID |
| `mapLabel` | `string` | Map display name |
| `difficulty` | `string` | Difficulty ID |
| `difficultyLabel` | `string` | Difficulty display name |
| `currentRound` | `number` | Current round |
| `maxRounds` | `number` | Maximum rounds for this difficulty |
| `state` | `string` | Current game state |
| `money` | `number` | Team currency |
| `playerCount` | `number` | Player count |
| `players` | `table` | Array of player server IDs |
| `isDead` | `boolean` | Whether this player is dead |

---

### GetPlayerStats

Get a player's persistent horde stats.

```lua
local stats = exports['sd-horde']:GetPlayerStats(source)
-- Returns: table | nil
```

**Returns:**

| Field | Type | Description |
|---|---|---|
| `level` | `number` | Current horde level |
| `xp` | `number` | Total XP earned |
| `stats` | `table` | Detailed statistics (kills, games, etc.) |
| `completedMaps` | `table` | Maps and difficulties completed |

---

### AddPlayerXP

Add XP to a player.

```lua
local success, newLevel = exports['sd-horde']:AddPlayerXP(source, amount)
-- Returns: boolean, number | nil
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `amount` | `number` | Amount of XP to add (must be > 0) |

**Returns:** `true` and the new level if the player leveled up, or `true, nil` if no level change.

---

### SetPlayerLevel

Set a player's level directly.

```lua
local success = exports['sd-horde']:SetPlayerLevel(source, level)
-- Returns: boolean
```

---

### IsPlayerOnCooldown

Check if a player is on cooldown from a recent mission.

```lua
local onCooldown, remainingSeconds, formattedTime = exports['sd-horde']:IsPlayerOnCooldown(source)
-- Returns: boolean, number | nil, string | nil
```

**Returns:** Whether on cooldown, remaining seconds, and a formatted time string.

---

### SetPlayerCooldown

Set a player's cooldown duration.

```lua
local success = exports['sd-horde']:SetPlayerCooldown(source, minutes)
-- Returns: boolean
```

Pass `0` or `nil` for minutes to clear the cooldown.

---

### ClearPlayerCooldown

Clear a player's cooldown.

```lua
local success = exports['sd-horde']:ClearPlayerCooldown(source)
-- Returns: boolean
```

---

### GetAvailableMaps

Get all available maps and their difficulties.

```lua
local maps = exports['sd-horde']:GetAvailableMaps()
-- Returns: table
```

**Returns:** An array of tables:

| Field | Type | Description |
|---|---|---|
| `id` | `string` | Map identifier |
| `label` | `string` | Map display name |
| `difficulties` | `table` | Array of `{ id, label, maxRounds }` |

---

### RemovePlayerFromGame

Remove a specific player from their current game (handles inventory return, bucket reset, etc.).

```lua
local success = exports['sd-horde']:RemovePlayerFromGame(source)
-- Returns: boolean
```

---

## Perk Exports

### Server Perk Exports

```lua
exports['sd-horde']:ApplyPerkToAllPlayers(...)
exports['sd-horde']:ClearAllPerksForAllPlayers(...)
exports['sd-horde']:GetActivePerks(...)
exports['sd-horde']:ProcessWinningPerk(...)
exports['sd-horde']:GetServerLootValueMultiplier(...)
```

### Client Perk Exports

```lua
exports['sd-horde']:ApplyPerk(...)
exports['sd-horde']:RemovePerk(...)
exports['sd-horde']:ClearAllPerks(...)
exports['sd-horde']:GetPerkModifiers(...)
exports['sd-horde']:IsPerkActive(...)
exports['sd-horde']:GetActivePerks(...)
exports['sd-horde']:GetActivePerksForHUD(...)
exports['sd-horde']:GetTotalDamageMultiplier(...)
exports['sd-horde']:GetDamageMultiplierForTarget(...)
exports['sd-horde']:GetWeaponHandlingModifiers(...)
exports['sd-horde']:GetLootValueMultiplier(...)
exports['sd-horde']:GetPointsMultiplier(...)
exports['sd-horde']:HasInfiniteAmmo(...)
exports['sd-horde']:HasExplosiveRounds(...)
exports['sd-horde']:HasThermiteRounds(...)
exports['sd-horde']:GetCurrencyMultiplier(...)
exports['sd-horde']:GetHeadshotCurrencyBonus(...)
exports['sd-horde']:GetKillCurrencyBonus(...)
exports['sd-horde']:GetEnemySpeedMultiplier(...)
exports['sd-horde']:GetEnemyHealthMultiplier(...)
exports['sd-horde']:GetEnemyDamageMultiplier(...)
exports['sd-horde']:GetEnemyArmorMultiplier(...)
exports['sd-horde']:GetEnemyAccuracyMultiplier(...)
exports['sd-horde']:OnEnemyKilled(...)
exports['sd-horde']:OnPlayerDamaged(...)
```

::: info
Perk exports are primarily used internally by the script's own systems. They are exposed for advanced integrations where you need to query or modify perk states from external scripts.
:::

## Mystery Box Exports

### Client

```lua
exports['sd-horde']:SpawnMysteryBox(...)
exports['sd-horde']:RemoveMysteryBox(...)
exports['sd-horde']:UseMysteryBox(...)
```

### Server

```lua
exports['sd-horde']:CleanupMysteryBoxForGame(...)
```

## Common Patterns

### Blocking Actions During Missions

```lua
-- Server-side: block job changes during horde
RegisterNetEvent('myresource:changeJob', function()
    local src = source
    local inGame = exports['sd-horde']:IsPlayerInHorde(src)
    if inGame then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Horde Mission',
            description = 'You cannot change jobs during a mission.',
            type = 'error'
        })
        return
    end
    -- Allow job change
end)
```

### Displaying Active Games

```lua
-- Server-side: admin command to list active games
RegisterCommand('hordestatus', function(source)
    local games = exports['sd-horde']:GetActiveGames()
    if #games == 0 then
        print('No active horde games.')
        return
    end
    for _, game in ipairs(games) do
        print(('Map: %s | Difficulty: %s | Round: %d | Players: %d | State: %s'):format(
            game.map, game.difficulty, game.currentRound, game.playerCount, game.state
        ))
    end
end, true)
```

### Starting a Game Programmatically

```lua
-- Server-side: start a game with specific players
local gameId, err = exports['sd-horde']:StartHordeWithPlayers(
    {playerId1, playerId2},
    "cayo_estate",
    "normal",
    { skipEntry = true }
)

if gameId then
    print("Game started: " .. gameId)
else
    print("Failed to start game: " .. (err or "unknown error"))
end
```

### Client-Side Game State Check

```lua
CreateThread(function()
    while true do
        local inGame, state = exports['sd-horde']:IsPlayerInHorde()
        if inGame and state == 'active' then
            -- Disable certain features during active combat
        end
        Wait(1000)
    end
end)
```

::: tip
Use exports sparingly in loops. Checking game state once per second (1000ms) is sufficient for most integration purposes.
:::
