# Configuration

The configs are split by who may read them:

- **`configs/shared/`** is read by the client and the server: what the phone shows, which items exist, the turf map.
- **`configs/server/`** never reaches a client: prices, XP, odds, stock and locations. It is merged over the shared files on the server only, so players can't read your economy out of the resource.

Each file is commented line by line. This page says what each one is for and lists the settings most servers change first.

## config.lua

| Option | Default | Description |
|---|---|---|
| `Locale` | `'en'` | Which `locales/*.json` to use: `'en'` or `'zh-CN'` (Simplified Chinese). Customer texts, contact lines and names are in the config files below, not the locale |
| `Debug` | `false` | Dev logging, target zone outlines and the `/trap_*` test commands |
| `AdminAce` | `'command.trapphone'` | The ace needed for `/trapadmin` |

## Shared

### phone.lua: the handset

| Option | Default | Description |
|---|---|---|
| `Items` | the ten `trap_phone_*` items | Item name to faceplate colour. Each colour has its own model in the hand |
| `Item` | `'trap_phone_graphite'` | The colour handed out by default (`/trapadmin give`, shops) |
| `UniqueMetadataPhones` | `true` | Every phone item is its own business: progress, contacts and messages are stored against an id in the item's metadata, so a stolen or sold phone carries everything with it (keep the item unstackable). `false`: progress belongs to the character and any trap phone opens it |
| `MaxMessagesPerThread` / `MaxThreads` | `50` / `40` | Older messages and customer threads fall off past these (contacts are kept) |
| `NumberPrefix` | `'555'` | Burner numbers read `<prefix>-<4 digits>` |
| `OpenCommand` / `OpenKey` | `'trapphone'` / `''` | A command to open the phone, and an optional default key for it (players can bind their own) |
| `Prop` / `Anim` | | The in-hand model and how it's held |
| `Wallpapers` / `Ringtones` | | The choices in the phone's settings |

![The ten props, faces and backs](/trapphone/04-props.webp)

### drugs.lua: what can be sold

| Option | Description |
|---|---|
| `Families` | Products that share XP, levels and demand: `weed`, `coke`, `meth` |
| `Items` | Each sellable item: its family, its unit (`gram`, `quarter`, `ounce`, `kilo`), the prop handed over, and `largePackage` for bricks carried two-handed. Point these at the item names your server uses |
| `Units` | How a unit reads on the phone |

Prices, sale sizes and cooldowns per item are in `configs/server/economy.lua`, keyed by the same item names.

### selling.lua: corner sales as the client plays them

| Option | Default | Description |
|---|---|---|
| `CustomerSearchRadius` | `45.0` | How far an ambient ped can be to be sent over on foot |
| `VehicleSpawnRadius` | `80.0` | How far away a buyer's car is created before it drives to your spot |
| `ServeDistance` | `2.2` | How close you must be to hand over |
| `OfferSeconds` | `75` | How long a texted offer stays open |
| `CustomerOnRouteTimeout` / `ParkUpTimeout` / `VehicleCustomerWaitTime` | `180` / `30` / `30` | Seconds before a customer who never arrives, a car that can't park, or a buyer at the window gives up |
| `Cinematics` / `HandOff` | | The short camera on a deal, and the hand-to-hand animation |
| `IgnorePedTypes` | cops, medics, fire, SWAT, animals, army | Peds that are never customers |

### zones.lua: the turf map

Each area is a circle, and the smallest circle containing a point wins, so a tight block can sit inside a wide district. Anything outside every circle is `Default`. Each area has a `wealth` from 0 (broke) to 5 (loaded), the products it craves, and the crew that runs it. The zone is always worked out on the server from the player's real position.

### gangs.lua, contacts.lua, scales.lua, services.lua

| File | |
|---|---|
| `gangs.lua` | The crews: names, colours, which ambient peds count as theirs, the weapons their encounters and riots use. `Enabled` turns turf politics off entirely |
| `contacts.lua` | Contact types as the phone shows them, and how meetings work (`MeetRadius` 60 m, `MeetWaitMinutes` 10) |
| `scales.lua` | Bagging up: the items, the splits each size breaks into, battery drain, and `UseBaggies` |
| `services.lua` | Switches for the money wash and the black market, and how you interact with them |

## Server only

### economy.lua: the money and the progression

| Option | Default | Description |
|---|---|---|
| `PayoutAccount` | `'cash'` | Where sale money goes |
| `Prices` | | The base price per item |
| `DemandBonus` | `1.25` | Price multiplier in a zone that craves the product |
| `OfferSpread` | `0.15` | Each offer rolls this share either side of the price |
| `RelationshipBonus` | `0.12` | At +100 relationship an offer is up by this share, at -100 down by it |
| `LevelBonusPerLevel` / `LevelBonusCap` | `0.02` / `0.20` | What each level adds to prices, and the cap |
| `Haggle` | | How a counter-offer is judged |
| `XP` / `Titles` / `ShowLevelNumbers` | | The XP curve, and the street titles shown instead of level numbers ("Nobody", "Corner boy", ...) |

### selling.lua: the odds

| Option | Default | Description |
|---|---|---|
| `CustomerInterval` | `{ min = 12, max = 28 }` | Seconds between customers while serving |
| `CustomerInVehicleChance` | `35` | Percent of customers who pull up in a car, when a spot is set |
| `RefuseDrugsChance` | `40` | Percent of peds you pitch yourself who say no |
| `RobberyChance` | `4` | Percent of sales where the customer tries to take it instead of paying |
| `MinServeSeconds` | `4` | A sale can't complete sooner than this after its offer |
| `Relationship` / `Personalities` / `TipShare` | | How customers remember you, the kinds of customer, and tips |

### dispatch.lua: police pressure

| Option | Default | Description |
|---|---|---|
| `PoliceJobs` | `{ 'police', 'sheriff' }` | Who counts as police |
| `CheckForPolice` / `RequiredPolice` | `false` / `3` | Require police on duty before anyone can start selling |
| `Cooldown` | `90` | Seconds between alerts about the same player |
| `Snitch` / `Heat` / `Alert` | | Witness odds, how heat builds and fades, and the alert sent to your dispatch resource |

### deliveries.lua: drop-off runs

| Option | Default | Description |
|---|---|---|
| `Enabled` / `RequireVehicle` | `true` / `true` | Drop-offs on, and only while in a vehicle |
| `MaxQueue` / `RequestDelay` | `5` / `60` | Open orders at once, and seconds between orders |
| `AcceptSeconds` / `DeliverMinutes` | `120` / `12` | How long an order waits for an answer, and to be delivered |
| `CompleteRadius` | `6.0` | How close to the door you must be (checked on the server) |
| `MinDistance` / `MaxDistance` | `250.0` / `3500.0` | How far the doors can be from you |
| `Spots` | | The doors |

### The rest

| File | |
|---|---|
| `contacts.lua` | The people you meet: who they are, what they stock and where they meet. `IntroChance` (60) is the percent chance a level-up makes one reach out |
| `gangs.lua` | Standing, tax, bribes, encounters and riots. `SharedJobRep` lets a job (police) share one standing with each crew |
| `services.lua` | Money wash rates and black market stock and locations. A location is only sent to players who have unlocked it |
| `dialogue.lua` / `lines.lua` | Everything customers, contacts and crews text, by moment and personality |
| `logs.lua` | Audit logging through ox_lib's logger, per event |
