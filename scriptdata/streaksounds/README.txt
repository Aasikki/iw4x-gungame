Killstreak sounds
=================
When a killstreak is given, the mod plays the sound alias "gg_streak_<name>" to that player,
but only if <name>.wav exists in this folder. Missing files are skipped silently.

Files (16-bit PCM .wav, mono works best):
  riotshield.wav        norecoil.wav        speed.wav
  glsentry.wav          suicidebomber.wav   jetpack.wav
  bomber.wav            ims.wav             juggernaut.wav
  explosivebullets.wav  radioactive.wav     xray.wav
  godmode.wav

The game can only play sounds that are inside a fastfile, so after adding or changing
files you have to rebuild mod.ff:

1. One-time: get a template alias.
   Start zonebuilder.exe and run:  dumpzone common_mp
   Copy a sound alias .json from userraw/dump/common_mp/sounds/ somewhere handy.
   Pick a 2D UI-style sound whose "type" is 1 (c4_bounce_default.json works well).

2. Put your .wav files in this folder.

3. Run (PowerShell), pointing -Template at the .json from step 1:
     tools/build-streak-sounds.ps1 -Template C:\path\to\c4_bounce_default.json -ModFolder (pwd) -GameDir C:\Programs\IW4X\ server

   This copies the sounds into loaded_sound/, writes sounds/gg_streak_<name>.json and
   creates zone_source/mod.csv in the game folder (only for files that exist).

4. In zonebuilder.exe, run:  buildzone mod
   This writes zonebuilder_out/mod.ff.

5. Copy it to the mod folder:
     copy C:\Programs\IW4X\ server\zonebuilder_out\mod.ff C:\Programs\IW4X\ server\mods\gungame\mod.ff
   
   Players download it automatically when they join.

Always rebuild mod.ff after adding a .wav. If a .wav exists here but mod.ff does not contain
its alias, clients get a "Could not find sound alias" error and drop from the match.
