# Common Issues

This page covers frequently encountered problems with sd-dumpsters and their solutions.

## Dumpsters Cannot Be Looted (Networking Issue)

### Symptom
Players cannot interact with or loot any dumpsters. No target option appears on dumpster props.

### Solutions

1. **Check if `Config.GlobalCooldown` is `true`** -- when enabled, the script networks dumpster entities to share cooldowns across all players. If your server has a very high volume of networked entities, the script may fail to network dumpsters.

2. **Set `Config.GlobalCooldown` to `false`** to use per-player cooldowns instead. This removes the networking requirement:
   ```lua
   Config.GlobalCooldown = false
   ```

3. **Reduce networked entities** on your server by auditing other scripts that create networked objects.

::: tip
This issue only affects a small number of servers with exceptionally high entity counts. If you cannot identify the source of excess entities, switching to per-player cooldowns is the simplest fix.
:::

## Cooldowns Not Working

### Symptom
Players can loot the same dumpster repeatedly without waiting, or the cooldown resets unexpectedly.

### Solutions

1. **Check the cooldown setting** in `configs/config.lua`:
   ```lua
   Config.DumpsterCooldown = 10 -- Minutes (not seconds)
   ```

2. **Verify oxmysql is running** -- player data is stored in the database. If oxmysql is not started before sd-dumpsters, data will not persist.

3. **Check ensure order** -- sd-dumpsters must start after oxmysql in your `server.cfg`.

4. **Global vs per-player** -- if `Config.GlobalCooldown` is `true`, cooldowns are shared. If `false`, each player has their own cooldown timer.

## Items Not Appearing in Inventory

### Symptom
Players loot a dumpster but receive no items, or items show in the console but not in the inventory.

### Solutions

1. **Verify items are registered** -- all loot table items must exist in your inventory system. Check the [Installation](/resources/dumpsters/installation) guide for item registration.

2. **Check loot-to-stash mode**:
   ```lua
   Config.LootToStash = false -- false = direct to inventory, true = into a temporary stash
   ```
   If set to `true`, items are placed in a temporary stash that opens after the progress bar. The player must take items from the stash. This requires `ox_inventory`.

3. **Check loot chance** -- each level has a `DumpsterLootChance` percentage. At level 1 this is only 60%, meaning 40% of searches find nothing. This is intentional.

4. **Inventory full** -- if the player's inventory is full (weight limit), items cannot be added. The notification `"You can't carry all of the loot"` will display.

5. **Check if minigame is enabled and failed** -- if `Config.Minigame.Dumpsters.Enable` is `true`, the player must pass the skill check before receiving loot. Failing the minigame results in no loot.

## Hobo King Not Spawning

### Symptom
The Hobo King NPC does not appear at the expected location, or the blip shows but no NPC is present.

### Solutions

1. **Check if the ped is enabled**:
   ```lua
   Config.Ped.Enable = true
   ```

2. **Verify the ped model** -- the default model is `"u_m_y_militarybum"`. Ensure this model is not blocked by your anticheat:
   ```lua
   Config.Ped.Model = "u_m_y_militarybum"
   ```

3. **Check location coordinates** -- verify the spawn locations in `Config.Ped.Location` are valid and accessible positions. The NPC spawns at a random location from this list each time the script starts:
   ```lua
   Config.Ped.Location = {
       {x = 3.152987, y = -1215.155, z = 25.70303, w = 267.1587}
   }
   ```

4. **Blip is disabled by default** -- `Config.Blip.Enable` defaults to `false`. Enable it to show the King's location on the map:
   ```lua
   Config.Blip.Enable = true
   ```

5. **Interaction distance** -- make sure you are within `Config.Ped.Interaction.Distance` (default 3.0) of the NPC to see the target option.

## Locked Dumpsters Not Working

### Symptom
Large dumpsters are never locked, or players cannot open locked dumpsters even with a power saw.

### Solutions

1. **Check if locked dumpsters are enabled**:
   ```lua
   Config.LockedDumpster = { Enable = true }
   ```

2. **Verify the grinder item name** matches your inventory:
   ```lua
   Config.Items.Grinder = 'powersaw'
   ```

3. **Check lock chance per level** -- at level 1, the default lock chance is 25%. At level 5, it drops to 5%. The chance is defined in `Config.Levels[level].LockChance`.

4. **Only large dumpsters can be locked** -- props in `Config.BinProps.Small` (trash cans) are never locked. Only props in `Config.BinProps.Large` (dumpsters/skips) can be locked.

## Rat Not Following Player

### Symptom
After calling the rat with `/CallRat` or the export, it does not appear or does not follow.

### Solutions

1. **Check if the command is enabled**:
   ```lua
   Config.RegisterCommandForFollow = true
   ```

2. **Check if the export is enabled**:
   ```lua
   Config.CreateExportForRatFollow = { Enable = true }
   ```

3. **Verify the player owns a rat** -- the notification `"You do not own a rat"` indicates no rat has been purchased.

4. **Rat may be injured or on expedition** -- an injured or deployed rat cannot follow. Check the rat menu for status.

5. **Distance limit** -- if the rat gets too far from the player, it automatically returns home. The notification `"Your rat got too far away and has returned home"` confirms this.

6. **Anticheat interference** -- some anticheat systems block client-side ped creation. Whitelist the rat ped model in your anticheat configuration.

## Rat Stuck as Injured

### Symptom
The rat shows as injured but the recovery timer does not count down or never completes.

### Solutions

1. **Wait the full recovery time** -- default is 600 seconds (10 minutes). Check the rat menu for the remaining time display.

2. **Quick Recovery perk** -- if the Quick Recovery perk is invested, the timer should be shorter. At level 3, recovery is 30% faster (420 seconds instead of 600).

3. **Database sync issue** -- verify the rat's injury state in the database. A corrupted entry can cause it to stay injured. Contact an admin to reset the rat state if needed.

## Recycler Not Processing

### Symptom
Items are inserted but the recycling process does not start, or the timer does not count down.

### Solutions

1. **Check if recycling is enabled**:
   ```lua
   Config.Recycling.Enable = true
   ```

2. **Verify items are inserted** -- use the "View Inserted Items" option to confirm items are in the recycler before starting.

3. **Check for finished products** -- if a previous cycle's products have not been collected, you cannot start a new cycle. Collect or discard old materials first.

4. **Recycler at capacity** -- if `Config.Recycling.RestrictAmount.Enable` is `true` and `Amount` is reached, the recycler will not accept more items. Default cap is 50 items.

5. **Shared recycler conflict** -- if `Config.Recycling.Shared` is `true`, another player may have started a cycle or have uncollected materials at that recycler.

6. **Check interaction method** -- ensure only one interaction method is enabled per location (`enablePed`, `enableProp`, or `enableBoxZone`).

## Minigame Not Triggering

### Symptom
Searching dumpsters or camps does not show a minigame/skill check.

### Solutions

1. **Check if minigames are enabled for dumpsters**:
   ```lua
   Config.Minigame.Dumpsters.Enable = true
   ```
   Note: Camps do not have an `Enable` toggle -- the minigame always runs for camps if configured.

2. **Verify the minigame resource is running** -- if `Config.Minigame.Dumpsters.Minigame` is set to `'lib.skillCheck'`, ensure `ox_lib` is started. If using `ps-ui`, `SN-Hacking`, etc., ensure that resource is running.

3. **Check arguments match the selected minigame** -- the `Args` table must contain a matching key for your chosen minigame:
   ```lua
   Minigame = 'lib.skillCheck',
   Args = {
       ['lib.skillCheck'] = {
           {'easy', 'medium', {areaSize = 40, speedMultiplier = 1.2}},
           {'w', 'a', 's', 'd'}
       }
   }
   ```

## Needle Prick / Hobo Attack Not Triggering

### Symptom
Random events never occur during looting.

### Solutions

1. **Check if events are enabled**:
   ```lua
   Config.Events.NeedlePrick.Enable = true
   Config.Events.HoboAttack.Enable = true
   ```

2. **Check per-level chance values** -- the chance is defined per level in `Config.Levels`, not in `Config.Events`:
   ```lua
   Config.Levels[1].NeedlePrickChance = 25  -- 25% at level 1
   Config.Levels[1].HoboAttackChance = 15   -- 15% at level 1
   ```

3. **Cooldown blocking events** -- both events have their own cooldowns (`Config.Events.NeedlePrick.Cooldown` and `Config.Events.HoboAttack.Cooldown`, both default 600 seconds). If an event triggered recently, it will not trigger again until the cooldown expires.

4. **Low sample size** -- at 15-25% chance, it is normal to loot many times without an event. The randomness is working as intended.

::: tip
To test events during development, temporarily increase the chance values in `Config.Levels` to `100` and set the cooldowns to `0`.
:::

## Locale / Translation Issues

### Symptom
Text appears in the wrong language or shows raw locale keys like `hobo.king_title`.

### Solutions

1. **Set the correct locale** at the top of `configs/config.lua`:
   ```lua
   Locale.LoadLocale('en') -- Options: 'en', 'es', 'de', 'fr', 'ar'
   ```

2. **Check locale files** -- ensure the JSON file for your chosen language exists in the `locales/` directory (e.g., `locales/en.json`).

3. **Missing translation keys** -- if you see raw keys, the translation file is missing that entry. Add it manually to the locale JSON file or switch to a fully supported locale.

4. **Locale keys use dot notation** -- the JSON structure is flattened. A key like `"hobo.king_title"` maps to `locales/en.json` -> `hobo` -> `king_title`.

## Target System Not Working

### Symptom
No interaction options appear on dumpsters, trash cans, the Hobo King, or other interactable objects.

### Solutions

1. **Verify a target resource is running** -- the script checks for `qb-target`, `qtarget`, or `ox_target` in that order. At least one must be started.

2. **Fallback to TextUI** -- if no target resource is found, the script falls back to a built-in TextUI system using `[E]` key prompts. This happens automatically but may behave differently from target-based interaction.

3. **Check ox_target compatibility** -- if using `ox_target`, the script maps it internally to the `qtarget` API. Ensure your `ox_target` version supports the `qtarget` export compatibility layer.

4. **Ensure the target resource starts before sd-dumpsters** in your `server.cfg`.
