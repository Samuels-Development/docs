# How to Add Police Alerts

Many of our scripts support police/dispatch alerts for illegal activities. This guide explains how to integrate your preferred dispatch system.

## Using the Bridge System

Our scripts use a **bridge system** that abstracts dispatch calls. You can find the dispatch bridge file in:

```
bridge/server/dispatch.lua
```

## Common Dispatch Systems

### ps-dispatch

```lua
exports['ps-dispatch']:CustomAlert({
    coords = coords,
    message = 'Suspicious Activity',
    dispatchCode = '10-90',
    description = 'Suspicious activity reported',
    radius = 0,
    sprite = 161,
    color = 1,
    scale = 1.0,
    length = 3,
})
```

### cd_dispatch

```lua
local data = exports['cd_dispatch']:GetPlayerInfo(source)
exports['cd_dispatch']:AddNotification({
    job_table = {'police', 'sheriff'},
    coords = coords,
    title = 'Suspicious Activity',
    message = 'A suspicious activity has been reported',
    flash = 0,
    unique_id = tostring(math.random(0000000, 9999999)),
    blip = {
        sprite = 161,
        scale = 1.0,
        colour = 1,
        flashes = false,
        text = 'Suspicious Activity',
        time = 5,
        radius = 0,
    }
})
```

### qs-dispatch

```lua
exports['qs-dispatch']:CustomAlert({
    coords = coords,
    job = 'police',
    callCode = '10-90',
    message = 'Suspicious Activity',
    flashes = false,
    image = nil,
    blip = {
        sprite = 161,
        scale = 1.0,
        colour = 1,
        flash = false,
        text = 'Suspicious Activity',
        time = 5,
    }
})
```

::: tip
Edit the bridge file to match your server's dispatch system. The bridge is called from the server-side script logic, so you only need to modify it in one place.
:::
