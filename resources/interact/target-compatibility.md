# Replacing ox_target / qb-target

`sd-interact` can answer the exports of `ox_target`, `qtarget` and `qb-target` itself. Scripts written for them then get floating prompts instead of the target eye, without a line of them changed: zones, entities, models, bones, global options, the item, job and gang checks, and every way of handling an option.

## Setting it up

### 1. Turn it on

In `server.cfg`, before `ensure sd-interact`, name the ones to answer:

```cfg
setr sd_interact:replace "ox_target,qtarget"
ensure sd-interact
```

`ox_target` answers as `qtarget` too, so on an ox_target server turn both on to keep scripts that still call `exports.qtarget` working. On a qb-target server use `"qb-target"`.

Start `sd-interact` before `[ox]` and anything else that adds targets as it starts (ox_inventory registers its shop targets that way).

### 2. Take the real resource out

Remove `ensure ox_target` (or qb-target) from your `server.cfg` and move the folder out of `resources`. Two resources answering one export fight, so never run both: if something called `ox_target` is still started, sd-interact prints a warning in the F8 console.

### 3. Give dependents something to start after

Scripts that list `ox_target` as a dependency in their `fxmanifest.lua` won't start unless something by that name exists. Pick one:

**An empty stand-in resource** (recommended). Create `resources/[ox]/ox_target/fxmanifest.lua`:

```lua
fx_version 'cerulean'
game 'gta5'

description 'Stand-in for ox_target: its exports are answered by sd-interact'
version '1.17.2'            -- the ox_target API sd-interact answers
sd_interact_stand_in 'yes'  -- sd-interact recognises it and doesn't warn
dependency 'sd-interact'
```

`GetResourceState('ox_target')` then reports `started`, so scripts that check for ox_target before using it find it. It lives outside sd-interact, so updating sd-interact never undoes it.

**Or `provide`.** Uncomment the matching `provide` line at the bottom of sd-interact's `fxmanifest.lua`: FiveM then treats sd-interact itself as ox_target. Remember to do it again after each update, since a new release replaces that file.

## What is answered

### ox_target

`addBoxZone`, `addSphereZone`, `addPolyZone`, `removeZone`, `zoneExists`, `addLocalEntity`, `removeLocalEntity`, `addEntity`, `removeEntity`, `addModel`, `removeModel`, `addGlobalVehicle` / `Ped` / `Object` / `Player` and their `removeGlobal*`, `addGlobalOption`, `removeGlobalOption`, `addSelfTarget`, `removeSelfTarget`, `disableTargeting`, `isActive`, `getTargetOptions`, `entityHasTargets`, `entityHasSpecificTargets`, `getEntityTargetDistance` and `getEntitySpecificTargetDistance`.

Matched against ox_target 1.17.2:

- **Handler data.** `onSelect`, `export`, `event` and `serverEvent` get what ox_target gives them: a copy of the option with `entity`, `coords`, `distance` and `zone` set on it. `serverEvent` gets the entity as its network id. An option marked `qtarget` gets only the entity in `onSelect`.
- **`export`** is called on the resource that added the option, as in ox_target.
- **Checks.** `groups`, `items` and `anyItem` (read from ox_inventory, else the framework's inventory), `distance` and `canInteract` (with ox_target's arguments: entity, distance, coords, name, bone).
- **Placement.** Options with `bones` get a prompt on each bone. Options with `offset` get a prompt of their own. A zone becomes a prompt at its middle, reachable from the options' distance plus up to 1.5 m of the zone's own size.
- **Self targets** open on your own ped while the camera looks down at it.
- **Removing** by option name only touches the calling resource's options, and adding an option again under the same name replaces it.

### qtarget and qb-target

`AddBoxZone`, `AddCircleZone`, `AddPolyZone`, `AddComboZone`, `AddEntityZone`, `RemoveZone`, `AddTargetEntity`, `RemoveTargetEntity`, `AddTargetModel`, `RemoveTargetModel`, `AddTargetBone`, `RemoveTargetBone`, `AddGlobalPed` / `Vehicle` / `Object` / `Player` and their `RemoveGlobal*`, `AllowTargeting`, `IsTargetActive` and `IsTargetSuccess`.

Matched against qb-target 5.5.0: `action`, `event` with `type = 'client' | 'server' | 'command' | 'qbcommand'`, `job`, `gang`, `item`, `citizenid` and `canInteract`. Handlers get the option as qb-target stores it. Options are removed by label, and adding one again under the same label replaces it. The ox_target and qtarget layers keep their points apart, so removing through one never removes the other's.

## Known differences

- ox_target's `offset` without `absoluteOffset` is a fraction of the model's size; here it is metres.
- Submenus (`menuName` / `openMenu`) show flat, with the other options.
- qb-target's `job = 'all'`, `excludejob`, `jobType`, `excludejobType` and `excludegang` aren't read yet.
- `getTargetOptions()` with no entity answers for the open prompt, since there is no target eye.

## Going back

Delete the stand-in (or comment the `provide` line again), move the real resource back into `resources`, `ensure` it again, and remove the `setr sd_interact:replace` line.
