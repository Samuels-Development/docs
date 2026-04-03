# Common Issues

Troubleshooting guide for sd-beekeeping.

## Main Menu Not Opening

**Symptom:** Walking up to a hive and interacting does nothing.

**Solutions:**

1. **Check your target system** — verify the correct target resource is running:
   ```lua
   Beekeeping.Interaction = 'target'  -- Must match your installed system
   ```
   One of these must be started: `ox_target`, `qb-target`, or `qtarget`.

2. **Increase interaction distance** — you may be too far:
   ```lua
   Beekeeping.InteractionDistance = 3.0  -- Try increasing to 5.0
   ```

3. **TextUI mode** — if using `'textui'`, ensure you press the prompted key when it appears.

4. **Lock access** — if `Beekeeping.LockAccess = true`, only the owner and collaborators can interact. If you're testing, temporarily set to `false`.

5. **ox_lib version** — update ox_lib to the latest version. Outdated versions may cause menu issues.

::: tip
Enable `Beekeeping.DebugZones = true` temporarily to visualize interaction zones around facilities.
:::

## Hives Not Producing Honey

**Symptom:** Hive is placed but no honey accumulates.

**Solutions:**

1. **Missing queen or workers** — production requires at least **1 queen** and **5 workers**:
   ```lua
   Beekeeping.Hives.NeededQueens = 1
   Beekeeping.Hives.NeededWorkers = 5
   ```
   Open the hive menu to check current bee counts. Add bees through the management interface.

2. **Infection slowing production** — infected hives produce much slower:

   | Severity | Production Speed |
   |---|---|
   | 1 | 2x slower |
   | 2 | 2.5x slower |
   | 3 | 3x slower |

   Use a **thymol** item to treat the infection.

3. **Low durability** — degraded hives may have reduced or halted production. Repair at the hive menu.

4. **Production cycle time** — honey is not instant. Default cycle is **600 seconds** (10 minutes):
   ```lua
   Beekeeping.Hives.HoneyTime = 600
   ```

5. **Max capacity reached** — hives cap at **100 honey** and **20 wax**. Harvest before they fill up:
   ```lua
   Beekeeping.Hives.MaxHoney = 100
   Beekeeping.Hives.MaxWax = 20
   ```

6. **Save method** — if using `resourceStop` and the server crashes, production data since the last save is lost. Switch to `interval`:
   ```lua
   Beekeeping.Saving = { Method = 'interval', Interval = 30 }
   ```

## Bees Are Aggressive / Getting Stung

**Symptom:** Player takes damage every time they interact with a hive.

**Solutions:**

1. **Use the bee smoker** — the smoker resets aggression. By default it drops aggression to level 1 (Calm):
   ```lua
   Beekeeping.Aggression.SmokerReduceBy = 'all'  -- Drops to calm
   ```
   Note: there's a **25% chance** the smoker breaks on use (`SmokerRemoveChance = 25`).

2. **Wear protective clothing** — configure which clothing items count as protection. The default mode is `"any"` (any single protective item works):
   ```lua
   Beekeeping.Aggression.ProtectiveClothing.Enable = true
   Beekeeping.Aggression.ProtectiveClothing.Mode = "any"
   ```

3. **Check sting chances by level:**

   | Level | Name | Sting Chance | Damage |
   |---|---|---|---|
   | 1 | Calm | 0% | 0 |
   | 2 | Alert | 20% | 5 |
   | 3 | Defensive | 50% | 10 |
   | 4 | Aggressive | 80% | 20 |

4. **Reduce aggression factors** — aggression builds faster with more workers and higher infection:
   ```lua
   Beekeeping.Aggression.Chance.Base = 5        -- Lower this
   Beekeeping.Aggression.Chance.PerWorker = 0.1 -- Lower this
   Beekeeping.Aggression.UpdateInterval = 120   -- Increase = slower rolls
   ```

5. **Disable aggression entirely** (if desired):
   ```lua
   Beekeeping.Aggression.Enable = false
   ```

## Collaborator Issues

**Symptom:** Cannot invite collaborators, or collaborators cannot interact.

**Solutions:**

1. **Nearby invite distance** — the target player may be too far:
   ```lua
   Beekeeping.NearbyInvite = {
       Enable = true,
       Distance = 10.0  -- Increase if needed
   }
   ```

2. **Collaborator limit reached** — if limits are enabled, check the cap:
   ```lua
   Beekeeping.LimitCollaborators = {
       Enable = false,  -- Set to true to enforce
       Max = 5          -- Max facilities per collaborator
   }
   ```

3. **Lock access must be on** — collaborator permissions only matter when `Beekeeping.LockAccess = true`. If it's `false`, anyone can interact regardless.

4. **Correct permissions** — collaborators can harvest, repair, and treat. They **cannot** pick up, destroy, or manage the collaborator list. Only the owner has full control.

## Hive Cannot Be Picked Up

**Symptom:** The pickup option is missing or doesn't work.

**Solutions:**

1. **Durability too low** — minimum 95% is required by default:
   ```lua
   Beekeeping.Pickup = {
       Enable = true,
       MinDurability = 95  -- Repair hive to this % first
   }
   ```
   Repair the hive, then try again.

2. **Pickup disabled**:
   ```lua
   Beekeeping.Pickup.Enable = true  -- Must be true
   ```

3. **Not the owner** — only the facility owner can pick it up. Collaborators cannot.

## Hives Disappear After Restart

**Symptom:** Placed hives are gone after a server restart.

**Solutions:**

1. **Check save method** — `txadmin` only saves on scheduled restarts, not crashes:
   ```lua
   Beekeeping.Saving = {
       Method = 'interval',  -- Recommended
       Interval = 30         -- Every 30 minutes
   }
   ```

2. **Verify oxmysql** — ensure it's running and connected before sd-beekeeping starts.

3. **Check the database table**:
   ```sql
   SELECT COUNT(*) FROM sd_beekeeping;
   ```
   If the count is 0 after placing hives, there's a database connection issue.

4. **Ensure order in server.cfg** — oxmysql must load first:
   ```ini
   ensure oxmysql
   ensure ox_lib
   ensure qb-core
   ensure sd-beekeeping
   ```

## Beekeeper NPC Not Spawning

**Symptom:** No beekeeper NPC or blip on the map.

**Solutions:**

1. **Check if enabled**:
   ```lua
   Beekeeping.Beekeeper.Enable = true
   Beekeeping.Blip.Enable = true
   ```

2. **Check spawn distance** — the NPC only spawns when a player is within range:
   ```lua
   Beekeeping.Beekeeper.SpawnDistance = 50.0  -- Increase if needed
   ```

3. **Verify the ped model** — ensure the model exists:
   ```lua
   Beekeeping.Beekeeper.Model = "a_m_m_farmer_01"
   ```

4. **Check location coords** — verify the coordinates are at ground level and accessible:
   ```lua
   Beekeeping.Beekeeper.Location = {
       { x = 426.05, y = 6478.9, z = 27.84, w = 234.9 }
   }
   ```

::: tip
The default location is near Paleto Bay. If you can't find it, look for the blip (sprite 106) on the map.
:::
