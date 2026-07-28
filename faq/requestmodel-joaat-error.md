# requestModel / joaat Errors on Qbox

If you run **Qbox** (`qbx_core`), you may see one of these in your client console (F8):

```
@ox_lib/imports/requestModel/client.lua:14: bad argument #1 to 'joaat' (string expected, got nil)
```

```
[ox_lib] [WARN] lib.requestModel received invalid prop data from resource 'qbx_core' (table is empty)
```

Despite naming `requestModel`, **this is not caused by our scripts.** It is a version mismatch between `ox_lib` and `qbx_core`, and it can appear with any resource that uses the Qbox progress bar compatibility layer.

## What causes it

Qbox ships a QBCore compatibility layer for progress bars (`QBCore.Functions.Progressbar`). In `qbx_core` **v1.23.0** — currently the newest tagged release — that layer always builds an **empty prop table** and passes it to `ox_lib`, even when no prop was requested.

`ox_lib` **v3.37.2** added prop validation that rejects an empty table. The empty table then fails validation, and the progress bar is cancelled before it ever appears — which is why the action itself silently fails.

## The fix

### Update ox_lib

Download **ox_lib v3.39.0 or newer**:

[github.com/overextended/ox_lib/releases/tag/v3.39.0](https://github.com/overextended/ox_lib/releases/tag/v3.39.0)

v3.39.0 downgraded the failed validation from an **error** to a **warning**. Progress bars work normally again.

::: tip
This is the only step most people need. The remaining warning is cosmetic — it prints to the client console only, never to your server console, and nothing is broken.
:::

### Enable ox_lib progress bars in the script

Many of our scripts include a bridge switch that makes them call `ox_lib` directly instead of routing through the Qbox compatibility layer. Turning it on avoids the problem entirely — both the error and the warning — on any `ox_lib` version.

Open `bridge/client.lua` in the script and set:

```lua
local EnableOX = true
```

Then restart the resource. The setting is read once when the script loads, so a live edit will not apply until you restart it.

::: tip
Some of our scripts already ship with this enabled, so you may find it is already set to `true`. If there is no `EnableOX` in `bridge/client.lua`, that script uses a different bridge setup — updating `ox_lib` as described above still resolves the error, or open a support ticket and we will take a look.
:::

### Remove the warning entirely (optional)

The warning comes from `qbx_core`, and it is already fixed there — but **only on the `main` branch**, not in any tagged release. The fix is [commit `30d0ee2`](https://github.com/Qbox-project/qbx_core/commit/30d0ee2fc52eb756fbbf8fee72580952434ca118) (19 May 2026).

::: warning
`v1.23.0` was tagged in April 2025, so moving to `main` is roughly 62 commits of core framework changes — not a drop-in hotfix. Only do this if you want the warning gone across every resource on your server, and test it first.
:::

## Version reference

| ox_lib | qbx_core v1.23.0 (latest release) | qbx_core `main` |
| --- | --- | --- |
| Below 3.37.2 | Works | Works |
| 3.37.2 – 3.38.0 | **Error** — progress bars fail | Works |
| 3.39.0 or newer | Works, prints a warning | Works, no warning |

::: tip
Downloading the newest release of a script always requires the newest release of `ox_lib`. We recommend keeping `ox_lib` up to date regardless of this issue.
:::
