# Santa's Gungame

A Gun Game mod for [IW4x](https://iw4x.io/) (Modern Warfare 2) by Santahunter. Every kill gives you the next weapon in a long list of guns, with killstreak-style perks along the way.

Updated to run on current IW4x builds (tested on r5154 server / r5278 client).

## Features

- Weapon progression through ~130 weapons: pistols, shotguns, SMGs, snipers, rifles, LMGs, akimbos and launchers
- Custom killstreaks: No Recoil, Speed, Explosive Bullets, Riotshield, Jetpack, Juggernaut, Radioactive, Bomber, XRay, GL Sentry, Godmode
- Throwing knife and dive/slide mechanics
- Custom HUD, spawn protection and spawn system
- Random map change after each match across 19 maps, including singleplayer maps (Gulag, Estate, Oil Rig and others)
- Built-in [Bot Warfare](https://github.com/ineedbots/iw4_bot_warfare) waypoints for many maps, so bots work out of the box

## Installation

1. Copy the `gungame` folder to `<IW4x install>/mods/`.
2. Start the game or a dedicated server with `fs_game mods/gungame2`.

Example dedicated server launch:

```
iw4x.exe -dedicated +set fs_game mods/gungame2 +set net_port 28960 +exec server.cfg +map_rotate
```

## Settings

Settings are plain variables in `gungame2/scripts/settings.gsc` (`Init()`). Edit the file and restart the server.

| Setting | Default | Description |
|---|---|---|
| `level.playerhealth` | `75` | Player health |
| `level.speed` | `1.15` | Movement speed multiplier (1.0 is normal) |
| `level.killstreaks` | `1` | `1` enables the custom killstreaks, `0` disables them |
| `level.devmode` | `0` | `1` enables developer/debug behaviour |

### Weapon order

The weapon list is in `Weapons()` in the same file. Each `AddWeapon("name_mp");` line is one level, in order. Reorder, add or remove lines to change the progression.

### Hardcoded values

These are set in `scripts/core.gsc` `Init()`:

| Dvar | Value |
|---|---|
| `jump_height` | `70` |
| `scr_game_hardpoints` | `0` |
| `scr_game_graceperiod` | `0` |
| `scr_game_matchstarttime` | `0` |
| `scr_game_playerwaittime` | `0` |
| `scr_gungame_timelimit` | `0` (changed at runtime by the mod) |
| `scr_gungame_scorelimit` | `0` |
| `ui_allow_teamchange` | `0` |

### Map list

The random map pool is in `randomMap()` in `scripts/core.gsc`. Remove entries to exclude maps, for example any singleplayer ports that give you trouble.

Maps: `mp_rust`, `mp_terminal`, `mp_highrise`, `mp_favela`, `mp_subbase`, `mp_nightshift`, `mp_boneyard`, `ending`, `airport`, `arcadia`, `co_hunted`, `oilrig`, `gulag`, `roadkill`, `cliffhanger`, `estate`, `mp_derail`, `mp_underpass`, `mp_trailerpark`

## Controls

| Action | Default key |
|---|---|
| Throwing knife | Action slot 3 (`+actionslot 3`) |
| Toggle FPS boost | Action slot 2 (`+actionslot 2`) |
| Use / activate ability | `+activate` |
| Scoreboard / info | `+scores` |

## Known issues

- The gametype description files (`gg.txt`, `oitc.txt`, `ss.txt`, `m40a3.txt`) are missing, so the server logs harmless "Could not load rawfile" errors.
- The original online player counter (`httpGet`) was removed because current IW4x no longer provides that function.
- Singleplayer maps ported to multiplayer (Gulag, Estate and others) are the least stable. Clients have reported crashes on them.

## Credits

- Mod by **Santahunter**
- Bot waypoints from [IW4 Bot Warfare](https://github.com/ineedbots/iw4_bot_warfare) (VicRattlehead, Boxhead78, IKennyAgain)
