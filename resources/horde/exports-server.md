# Server Exports

Horde Mission provides server-side exports for managing games programmatically, querying player data, and integrating with other scripts.

## IsPlayerInHorde

Check if a specific player is in a horde game.

**Syntax**
```lua
local inGame, game, gameId = exports['sd-horde']:IsPlayerInHorde(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | The player's server ID |

| Return | Type | Description |
|---|---|---|
| `inGame` | `boolean` | Whether the player is in a game |
| `game` | `table?` | The game session data table |
| `gameId` | `string?` | The game ID string |

**Example**
```lua
local inGame, game, gameId = exports['sd-horde']:IsPlayerInHorde(source)
if inGame then
    print('Player is in game ' .. gameId)
    print('Map: ' .. game.map .. ', Round: ' .. game.currentRound)
else
    print('Player is not in a horde game')
end
```

## StartHordeGame

Start a horde game for a player (or their group). Creates a pending game and shows the entry location.

**Syntax**
```lua
local gameId = exports['sd-horde']:StartHordeGame(source, mapName, difficultyId)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID (host) |
| `mapName` | `string` | Map ID from config (e.g. `"server_farm"`) |
| `difficultyId` | `string` | Difficulty ID (e.g. `"easy"`, `"normal"`, `"hard"`, `"nightmare"`) |

| Return | Type | Description |
|---|---|---|
| `gameId` | `string?` | The created game ID, or `nil` on failure |

**Example**
```lua
local gameId = exports['sd-horde']:StartHordeGame(source, 'server_farm', 'normal')
if gameId then
    print('Game created: ' .. gameId .. ' — player must walk to entry point')
else
    print('Failed to create game')
end
```

## ForceStartHordeGame

Force start a horde game immediately, skipping the entry location walkup. Same parameters as `StartHordeGame`.

**Syntax**
```lua
local gameId = exports['sd-horde']:ForceStartHordeGame(source, mapName, difficultyId)
```

| Return | Type | Description |
|---|---|---|
| `gameId` | `string?` | The created game ID, or `nil` on failure |

**Example**
```lua
local gameId = exports['sd-horde']:ForceStartHordeGame(source, 'cayo_estate', 'hard')
if gameId then
    print('Game started immediately: ' .. gameId)
end
```

## StartHordeWithPlayers

The most flexible way to start a horde game. Pass any list of players in various formats.

**Syntax**
```lua
local gameId, error = exports['sd-horde']:StartHordeWithPlayers(players, mapName, difficultyId, options)
```

| Parameter | Type | Description |
|---|---|---|
| `players` | `table` | Array of players — `{1, 2, 3}`, `{ {source = 1} }`, or `{ {serverId = 1, name = "Player1"} }` |
| `mapName` | `string` | Map ID |
| `difficultyId` | `string` | Difficulty ID |
| `options` | `table?` | Optional settings (see below) |

| Option | Type | Default | Description |
|---|---|---|---|
| `skipEntry` | `boolean` | `false` | Skip entry location, start immediately |
| `host` | `number` | First player | Which player is the host |

| Return | Type | Description |
|---|---|---|
| `gameId` | `string?` | The created game ID, or `nil` on failure |
| `error` | `string?` | Error message on failure |

**Example**
```lua
local gameId, err = exports['sd-horde']:StartHordeWithPlayers(
    {1, 2, 3},
    'server_farm',
    'easy',
    { skipEntry = true, host = 1 }
)
if gameId then
    print('Game started with 3 players: ' .. gameId)
else
    print('Failed to start: ' .. err)
end
```

## ForceEndGame

Force end a player's current game.

**Syntax**
```lua
local success = exports['sd-horde']:ForceEndGame(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |

| Return | Type | Description |
|---|---|---|
| `success` | `boolean` | Whether the game was ended |

**Example**
```lua
local success = exports['sd-horde']:ForceEndGame(source)
if success then
    print('Game ended for player ' .. source)
end
```

## GetActiveGames

Get a list of all currently active horde games.

**Syntax**
```lua
local games = exports['sd-horde']:GetActiveGames()
```

| Return | Type | Description |
|---|---|---|
| `games` | `table` | Array of game info tables |

Each game table contains:

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

**Example**
```lua
local games = exports['sd-horde']:GetActiveGames()
print(#games .. ' active games')
for _, game in ipairs(games) do
    print(('  [%s] %s %s — round %d, %d players'):format(
        game.gameId, game.map, game.difficulty,
        game.currentRound, game.playerCount
    ))
end
```

## GetPlayerGameInfo

Get detailed information about a player's current game.

**Syntax**
```lua
local info = exports['sd-horde']:GetPlayerGameInfo(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |

| Return | Type | Description |
|---|---|---|
| `info` | `table?` | Game info table, or `nil` if not in a game |

The returned table contains:

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

**Example**
```lua
local info = exports['sd-horde']:GetPlayerGameInfo(source)
if info then
    print(('Playing %s on %s — round %d/%d'):format(
        info.mapLabel, info.difficultyLabel,
        info.currentRound, info.maxRounds
    ))
    print('Team money: ' .. info.money)
    print('Player is ' .. (info.isDead and 'dead' or 'alive'))
end
```

## GetPlayerStats

Get a player's persistent horde stats.

**Syntax**
```lua
local stats = exports['sd-horde']:GetPlayerStats(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |

| Return | Type | Description |
|---|---|---|
| `stats` | `table?` | Stats table, or `nil` if not found |

The returned table contains:

| Field | Type | Description |
|---|---|---|
| `level` | `number` | Current horde level |
| `xp` | `number` | Total XP earned |
| `stats` | `table` | Detailed statistics (kills, games, etc.) |
| `completedMaps` | `table` | Maps and difficulties completed |

**Example**
```lua
local stats = exports['sd-horde']:GetPlayerStats(source)
if stats then
    print('Level ' .. stats.level .. ' (' .. stats.xp .. ' XP)')
    print('Total kills: ' .. (stats.stats.kills or 0))
    print('Games played: ' .. (stats.stats.gamesPlayed or 0))
end
```

## AddPlayerXP

Add XP to a player.

**Syntax**
```lua
local success, newLevel = exports['sd-horde']:AddPlayerXP(source, amount)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `amount` | `number` | Amount of XP to add (must be > 0) |

| Return | Type | Description |
|---|---|---|
| `success` | `boolean` | Whether XP was added |
| `newLevel` | `number?` | New level if the player leveled up, otherwise `nil` |

**Example**
```lua
local success, newLevel = exports['sd-horde']:AddPlayerXP(source, 500)
if success and newLevel then
    print('Player leveled up to ' .. newLevel .. '!')
elseif success then
    print('Added 500 XP')
end
```

## SetPlayerLevel

Set a player's level directly.

**Syntax**
```lua
local success = exports['sd-horde']:SetPlayerLevel(source, level)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `level` | `number` | Level to set |

| Return | Type | Description |
|---|---|---|
| `success` | `boolean` | Whether the level was set |

**Example**
```lua
local success = exports['sd-horde']:SetPlayerLevel(source, 10)
if success then
    print('Player level set to 10')
end
```

## IsPlayerOnCooldown

Check if a player is on cooldown from a recent mission.

**Syntax**
```lua
local onCooldown, remainingSeconds, formattedTime = exports['sd-horde']:IsPlayerOnCooldown(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |

| Return | Type | Description |
|---|---|---|
| `onCooldown` | `boolean` | Whether on cooldown |
| `remainingSeconds` | `number?` | Seconds remaining |
| `formattedTime` | `string?` | Formatted time string (e.g. `"2m 30s"`) |

**Example**
```lua
local onCooldown, _, formattedTime = exports['sd-horde']:IsPlayerOnCooldown(source)
if onCooldown then
    print('Player is on cooldown for ' .. formattedTime)
else
    print('Player can start a new game')
end
```

## SetPlayerCooldown

Set a player's cooldown duration. Pass `0` or `nil` for minutes to clear the cooldown.

**Syntax**
```lua
local success = exports['sd-horde']:SetPlayerCooldown(source, minutes)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |
| `minutes` | `number?` | Cooldown duration in minutes (`0` or `nil` to clear) |

| Return | Type | Description |
|---|---|---|
| `success` | `boolean` | Whether the cooldown was set |

**Example**
```lua
-- Set a 5-minute cooldown
exports['sd-horde']:SetPlayerCooldown(source, 5)

-- Clear the cooldown
exports['sd-horde']:SetPlayerCooldown(source, 0)
```

## ClearPlayerCooldown

Clear a player's cooldown.

**Syntax**
```lua
local success = exports['sd-horde']:ClearPlayerCooldown(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |

| Return | Type | Description |
|---|---|---|
| `success` | `boolean` | Whether the cooldown was cleared |

**Example**
```lua
local success = exports['sd-horde']:ClearPlayerCooldown(source)
if success then
    print('Cooldown cleared')
end
```

## GetAvailableMaps

Get all available maps and their difficulties.

**Syntax**
```lua
local maps = exports['sd-horde']:GetAvailableMaps()
```

| Return | Type | Description |
|---|---|---|
| `maps` | `table` | Array of map info tables |

Each map table contains:

| Field | Type | Description |
|---|---|---|
| `id` | `string` | Map identifier |
| `label` | `string` | Map display name |
| `difficulties` | `table` | Array of `{ id, label, maxRounds }` |

**Example**
```lua
local maps = exports['sd-horde']:GetAvailableMaps()
for _, map in ipairs(maps) do
    print(map.label .. ' (' .. map.id .. ')')
    for _, diff in ipairs(map.difficulties) do
        print('  ' .. diff.label .. ' — ' .. diff.maxRounds .. ' rounds')
    end
end
```

## RemovePlayerFromGame

Remove a specific player from their current game (handles inventory return, bucket reset, etc.).

**Syntax**
```lua
local success = exports['sd-horde']:RemovePlayerFromGame(source)
```

| Parameter | Type | Description |
|---|---|---|
| `source` | `number` | Player server ID |

| Return | Type | Description |
|---|---|---|
| `success` | `boolean` | Whether the player was removed |

**Example**
```lua
local success = exports['sd-horde']:RemovePlayerFromGame(source)
if success then
    print('Player removed from game safely')
end
```

## Perk Exports

::: info
Server perk exports manage perks across all players in a game session. Perk IDs are strings matching the keys in the `VotePerks` config (e.g. `"double_damage"`, `"speed_demon"`).
:::

### ApplyPerkToAllPlayers

Apply a perk to all players in a specific game session.

**Syntax**
```lua
exports['sd-horde']:ApplyPerkToAllPlayers(gameId, perkId)
```

| Parameter | Type | Description |
|---|---|---|
| `gameId` | `string` | The game session ID |
| `perkId` | `string` | The perk ID to apply |

**Example**
```lua
local inGame, _, gameId = exports['sd-horde']:IsPlayerInHorde(source)
if inGame then
    exports['sd-horde']:ApplyPerkToAllPlayers(gameId, 'double_damage')
    print('Applied double damage to all players in game ' .. gameId)
end
```

### ClearAllPerksForAllPlayers

Remove all active perks from every player in a game session.

**Syntax**
```lua
exports['sd-horde']:ClearAllPerksForAllPlayers(gameId)
```

| Parameter | Type | Description |
|---|---|---|
| `gameId` | `string` | The game session ID |

**Example**
```lua
exports['sd-horde']:ClearAllPerksForAllPlayers(gameId)
print('Cleared all perks for game ' .. gameId)
```

### GetActivePerks

Get the list of active perks for a game session.

**Syntax**
```lua
local perks = exports['sd-horde']:GetActivePerks(gameId)
```

| Parameter | Type | Description |
|---|---|---|
| `gameId` | `string` | The game session ID |

| Return | Type | Description |
|---|---|---|
| `perks` | `table` | Array of active perk ID strings |

**Example**
```lua
local perks = exports['sd-horde']:GetActivePerks(gameId)
print(#perks .. ' perks active in game ' .. gameId)
for _, perkId in ipairs(perks) do
    print('  - ' .. perkId)
end
```

### ProcessWinningPerk

Process the result of a perk vote — applies the winning perk to all players in the game.

**Syntax**
```lua
exports['sd-horde']:ProcessWinningPerk(gameId, perkId)
```

| Parameter | Type | Description |
|---|---|---|
| `gameId` | `string` | The game session ID |
| `perkId` | `string` | The winning perk ID from the vote |

### GetServerLootValueMultiplier

Get the server-side loot value multiplier for a game session, accounting for all active perks.

**Syntax**
```lua
local multiplier = exports['sd-horde']:GetServerLootValueMultiplier(gameId)
```

| Parameter | Type | Description |
|---|---|---|
| `gameId` | `string` | The game session ID |

| Return | Type | Description |
|---|---|---|
| `multiplier` | `number` | Combined loot value multiplier (1.0 = no change) |

**Example**
```lua
local mult = exports['sd-horde']:GetServerLootValueMultiplier(gameId)
print('Loot in this game is worth ' .. (mult * 100) .. '% of base value')
```

## Mystery Box Exports

### CleanupMysteryBoxForGame

Remove all mystery boxes associated with a game session. Called automatically when a game ends, but available for manual cleanup.

**Syntax**
```lua
exports['sd-horde']:CleanupMysteryBoxForGame(gameId)
```

| Parameter | Type | Description |
|---|---|---|
| `gameId` | `string` | The game session ID |

**Example**
```lua
exports['sd-horde']:CleanupMysteryBoxForGame(gameId)
print('Mystery boxes cleaned up for game ' .. gameId)
```
