# Sound Mastering Reference for Gungame Killstreak Audio

## Quick Specs

This document provides technical specifications and best practices for creating killstreak sound effects for the IW4x Gungame mod.

### File Format & Encoding
- **Format**: WAV (RIFF)
- **Codec**: PCM
- **Bit Depth**: 16-bit
- **Sample Rate**: 8000 Hz, 16000 Hz, or 44100 Hz (8000 Hz minimum recommended for UI sounds)
- **Channels**: Mono (recommended) or Stereo
- **File Size Target**: 1–2 MB per sound (shorter is better, typically 0.5–2 seconds)

### Loudness & Dynamics
- **Peak Level**: -6 dB to -3 dB (leave headroom)
- **RMS Level (avg loudness)**: -18 dB to -15 dB
- **Compression**: Apply gentle compression (2:1 to 4:1 ratio) to control peaks
- **No clipping**: Ensure no digital distortion (peaks must stay ≤ 0 dB)

### Duration
- **Recommended**: 0.5–2 seconds per sound
- **Maximum**: Keep under 3 seconds for best performance

### EQ & Tone
- **Frequency Range**: Focus between 500 Hz – 8 kHz for clarity in game audio
- **Avoid**: Extreme low-end sub-bass (below 50 Hz) unless intentional
- **Presence Peak**: Subtle boost around 2–4 kHz for clarity
- **Highs**: Don't boost above 10 kHz excessively; can sound harsh in mono

### Game Audio Integration
The mod applies these settings to all killstreak sounds:

| Property | Value | Notes |
|----------|-------|-------|
| Volume Min | 0.64 | Minimum playback volume |
| Volume Max | 0.72 | Maximum playback volume |
| Pitch Min | 0.90 | Minimum pitch shift |
| Pitch Max | 0.95 | Maximum pitch shift |
| Type | 1 | 2D UI sound |
| Distance Max | 1000 units | Farthest audible distance |

## Reference Audio

To ensure your custom sounds match the original game audio in tone, loudness, and quality, **use the extracted game reference sound as a comparison baseline**.

**Reference File Provided:**
- **File**: `scriptdata/streaksounds/reference.wav`
- **Source**: `ui_suitcase_bomb_counter.wav` from IW4x `common_mp` zone
- **Purpose**: Loudness and tone template for custom killstreak sounds

**How to Use Reference File:**
1. Open your DAW (Audacity, Reaper, Logic, etc.)
2. Load the reference sound in one track
3. Load your custom sound in another track
4. Compare visually: waveform amplitude should be similar
5. Use level meters: peak should match -6 to -3 dB range
6. Listen critically: tone/character should fit CoD4 military aesthetic
7. Iterate until they match in volume and presence

---

## Killstreak Names & Sound File Mapping

| Killstreak | Filename | Suggested Sound Character |
|---|---|---|
| Riotshield | `riotshield.wav` | Heavy, metallic, defensive |
| No Recoil | `norecoil.wav` | Smooth, controlled, mechanical |
| Speed | `speed.wav` | Sharp, electric, quick |
| GL Sentry | `glsentry.wav` | Beep-beep targeting sound |
| Suicide Bomber | `suicidebomber.wav` | Warning/alarm tone |
| Jetpack | `jetpack.wav` | Whoosh, thruster, ascending |
| Bomber | `bomber.wav` | Explosion or impact |
| I.M.S | `ims.wav` | Robotic, targeting beep |
| Juggernaut | `juggernaut.wav` | Deep, powerful, heavy armor |
| Explosive Bullets | `explosivebullets.wav` | Crackle, electrical, chaos |
| Radioactive | `radioactive.wav` | Sci-fi, pulse, danger tone |
| XRay | `xray.wav` | Tech scan, ping, reveal |
| Godmode | `godmode.wav` | Triumphant, power-up, godlike |

---

## Creation Workflow

### Step 1: Obtain Reference Sound (Already Provided)
- Reference file: `scriptdata/streaksounds/reference.wav`
- Use as loudness/tone/duration template
- Compare against this while mastering your custom sounds

### Step 2: Source Audio
- Use stock UI/game sound libraries (Freesound, Epidemic Sound)
- Or record/synthesize your own (synth, foley, etc.)
- Aim for CoD4 sci-fi / modern-military aesthetic

### Step 3: Processing (in your DAW)
1. **Trim silence** at start and end
2. **Normalize** to -3 dB peak (leave headroom)
3. **Optional: Compress** with gentle 2:1–4:1 ratio
4. **Optional: EQ**:
   - High-pass filter at 100 Hz
   - Gentle 2–4 kHz boost (presence)
   - Roll-off above 10 kHz if needed

### Step 4: Compare Against Reference
1. Open `scriptdata/streaksounds/reference.wav` in your DAW
2. Open your custom sound in another track
3. Compare visually: waveform amplitude should be similar
4. Use meters: peak level should match (-6 to -3 dB)
5. Listen: tone/character should fit the CoD4 world
6. Adjust and repeat as needed

### Step 5: Export
- **Format**: WAV (Microsoft PCM)
- **Bit Depth**: 16-bit
- **Sample Rate**: 44100 Hz or 8000 Hz
- **Channels**: Mono or Stereo
- **Naming**: `<killstreak_name>.wav`

### Step 6: Test in Mod
1. Copy WAV file to `mods/gungame/scriptdata/streaksounds/`
2. Run `build-streak-sounds.ps1` to generate JSON alias
3. Rebuild `mod.ff` with zonebuilder (`buildzone mod`)
4. Start server and test the sound in-game

---

## Troubleshooting

| Issue | Cause | Fix |
|---|---|---|
| Sound doesn't play | WAV file missing or alias not in mod.ff | Rebuild mod.ff after adding file |
| Sound is distorted | Peak level ≥ 0 dB (clipping) | Reduce to -6 to -3 dB |
| Sound is too quiet | Peak level too low | Increase to -3 dB |
| Sounds don't match game tone | Reference not from game files | Use provided reference.wav |

---

**Last Updated**: Oct 22, 2026  
**Reference Source**: IW4x `common_mp` zone dump  
**Mod Version**: v1.1 (custom_sounds branch)
