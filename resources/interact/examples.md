# Examples

Complete snippets for the common cases. Each goes in a client script of your own resource. The fields are explained on [Adding Prompts](./adding-prompts).

## A shopkeeper

A ped you spawned, with the prompt at chest height and the purchase checked on the server.

```lua
local model = `mp_m_shopkeep_01`
lib.requestModel(model)

local ped = CreatePed(4, model, 24.47, -1346.62, 28.5, 270.0, false, true)
FreezeEntityPosition(ped, true)
SetEntityInvincible(ped, true)
SetBlockingOfNonTemporaryEvents(ped, true)
SetModelAsNoLongerNeeded(model)

exports['sd-interact']:addLocalEntity(ped, {
    offset = vec3(0.0, 0.0, 0.3),
    interactDistance = 2.0, -- across the counter: the slack adds the rest
    options = {
        { label = 'Browse the shop', icon = 'fa-solid fa-basket-shopping', serverEvent = 'myshop:open' },
        { label = 'Ask about work', icon = 'message-circle', onSelect = function() lib.notify({ description = 'Nothing today.' }) end },
    },
})
```

On the server, `myshop:open` receives `data.entity` as 0 (the ped is local to each client), so check the player's position against the shop's own coordinates there.

## Every ATM

One registration covers every ATM model near the player, wherever it is on the map.

```lua
exports['sd-interact']:addModel({ 'prop_atm_01', 'prop_atm_02', 'prop_atm_03', 'prop_fleeca_atm' }, {
    interactDistance = 1.6,
    options = {
        { label = 'Use the ATM', icon = 'fa-solid fa-credit-card', event = 'mybank:openAtm' },
    },
})
```

## A car's boot that says Open or Close

A global vehicle option on the boot's bone. `canInteract` hides it on locked cars and cars without a boot, and its second return value is the label to show right now.

```lua
local BOOT = 5 -- the boot's door index

exports['sd-interact']:addGlobalVehicle({
    name = 'myres:boot',
    bone = 'boot',
    interactDistance = 1.8,
    options = {
        {
            label = 'Open the boot',
            icon = 'fa-solid fa-car-rear',
            canInteract = function(entity)
                if GetEntityBoneIndexByName(entity, 'boot') == -1 then return false end
                if GetVehicleDoorLockStatus(entity) >= 2 then return false end
                local open = GetVehicleDoorAngleRatio(entity, BOOT) > 0.1
                return true, open and 'Close the boot' or 'Open the boot'
            end,
            onSelect = function(data)
                if GetVehicleDoorAngleRatio(data.entity, BOOT) > 0.1 then
                    SetVehicleDoorShut(data.entity, BOOT, false)
                else
                    SetVehicleDoorOpen(data.entity, BOOT, false, false)
                end
            end,
        },
    },
})
```

Other bones work the same way: `'door_dside_f'` (driver's door), `'bonnet'`, `'wheel_lf'`, `'petrolcap'`.

## Police only, from a grade

```lua
exports['sd-interact']:addCoords(vec3(461.4, -981.1, 30.7), {
    options = {
        { label = 'Open the armoury', icon = 'fa-solid fa-gun', groups = { police = 2, sheriff = 2 }, event = 'mypd:armoury' },
        { label = 'Clock in', icon = 'fa-solid fa-id-badge', groups = 'police', serverEvent = 'mypd:clockIn' },
    },
})
```

A player who isn't police sees no prompt at all here, because the point has no option left for them.

## Only with an item, held to use

```lua
exports['sd-interact']:addLocalEntity(doorEntity, {
    options = {
        {
            label = 'Pick the lock',
            icon = 'fa-solid fa-unlock-keyhole',
            hold = 4000,
            canInteract = function()
                return exports.ox_inventory:Search('count', 'lockpick') > 0
            end,
            serverEvent = 'myheist:pickLock',
        },
    },
})
```

The hold is the player's commitment, not your check: `myheist:pickLock` still has to confirm on the server that they have a lockpick and are at the door.

## An entity the server made

The server spawns a networked prop and tells clients its network id. `addEntity` follows it as it streams in and out.

```lua
-- client
RegisterNetEvent('mydrop:spawned', function(netId)
    exports['sd-interact']:addEntity(netId, {
        name = 'mydrop',
        options = {
            { label = 'Open the crate', icon = 'fa-solid fa-box-open', hold = 2500, serverEvent = 'mydrop:open' },
        },
    })
end)

RegisterNetEvent('mydrop:removed', function(netId)
    exports['sd-interact']:removeEntity(netId, 'mydrop')
end)
```

The server gets `data.entity` as the crate's network id, so it can check `#(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(NetworkGetEntityFromNetworkId(data.entity)))` before giving anything out.

## Changing the options when something changes

Keep the id, and `update` it when your state changes:

```lua
local id = exports['sd-interact']:addCoords(stashCoords, {
    options = { { label = 'Open the stash', icon = 'fa-solid fa-box', onSelect = openStash } },
})

local function setRaided(raided)
    exports['sd-interact']:update(id, {
        options = raided
            and { { label = 'Search the remains', icon = 'search', onSelect = searchRemains } }
            or { { label = 'Open the stash', icon = 'fa-solid fa-box', onSelect = openStash } },
    })
end
```

For a label that follows the world (locked or not, open or not), a `canInteract` second return value is simpler: see [the boot](#a-car-s-boot-that-says-open-or-close).

## Hiding prompts during a minigame

```lua
exports['sd-interact']:disable(true)
local ok = lib.skillCheck({ 'easy', 'medium', 'hard' })
exports['sd-interact']:disable(false)
```

## Moving over from ox_target

Option tables carry over unchanged. Only the call around them changes:

::: code-group

```lua [ox_target]
exports.ox_target:addLocalEntity(ped, {
    {
        name = 'myshop:talk',
        label = 'Talk',
        icon = 'fa-solid fa-comment',
        distance = 2.0,
        onSelect = function(data) talkTo(data.entity) end,
    },
})
```

```lua [sd-interact]
exports['sd-interact']:addLocalEntity(ped, {
    options = {
        {
            name = 'myshop:talk',
            label = 'Talk',
            icon = 'fa-solid fa-comment',
            distance = 2.0,
            onSelect = function(data) talkTo(data.entity) end,
        },
    },
})
```

:::

To move a whole server at once without touching any script, sd-interact can answer ox_target's exports itself: see [Replacing ox_target / qb-target](./target-compatibility).
