param(
    [Parameter(Mandatory = $true)]
    [string]$Template,
    [string]$ModName = "gungame",
    [string]$ModFolder = "",
    [string]$GameDir = "C:\Programs\IW4X server"
)

# Builds the zonebuilder sources for the killstreak sounds in scriptdata/streaksounds.
# Only sounds that actually have a .wav file there are included.
#
# -Template is a sound alias .json dumped from a 2D loaded sound (see scriptdata/streaksounds/README.txt).
# -ModFolder is the local mod folder with the .wav files (default: current working directory/.. or parent of script location).
# -GameDir is the IW4x game folder where zonebuilder.exe runs (default: C:\Programs\IW4X server).
#          Writes <GameDir>/zone_source/mod.csv and <GameDir>/mods/<ModName>/sounds/*, /loaded_sound/*

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrEmpty($ModFolder)) {
    $ModFolder = Split-Path -Parent $PSScriptRoot
}

$ids = @(
    "riotshield", "norecoil", "speed", "glsentry", "suicidebomber", "jetpack", "bomber",
    "ims", "juggernaut", "explosivebullets", "radioactive", "xray", "godmode"
)

$srcDir = Join-Path $ModFolder "scriptdata/streaksounds"
$serverModDir = Join-Path $GameDir "mods" $ModName
$soundsDir = Join-Path $serverModDir "sounds"
$loadedDir = Join-Path $serverModDir "loaded_sound"
$zoneSourceDir = Join-Path $GameDir "zone_source"

$tpl = Get-Content -Raw $Template | ConvertFrom-Json
if (-not $tpl.head -or $tpl.head.Count -lt 1) {
    throw "Template has no 'head' entries: $Template"
}
if ($tpl.head[0].type -ne 1) {
    Write-Warning "Template alias is not a 'loaded' sound (type $($tpl.head[0].type), expected 1). Use a loaded sound as template."
}

$csv = @("require,common_mp")
$count = 0

foreach ($id in $ids) {
    $wav = Join-Path $srcDir "$id.wav"
    if (-not (Test-Path $wav)) {
        continue
    }

    $alias = "gg_streak_$id"
    $loadedName = "$alias.wav"

    New-Item -ItemType Directory -Force $soundsDir, $loadedDir | Out-Null
    Copy-Item $wav (Join-Path $loadedDir $loadedName) -Force

    $entry = $tpl.head[0].PSObject.Copy()
    $entry.aliasName = $alias
    $entry.soundFile = $loadedName
    $entry.type = 1

    $json = [ordered]@{
        aliasName = $alias
        count     = 1
        head      = @($entry)
    }
    $json | ConvertTo-Json -Depth 20 | Set-Content -Encoding UTF8 (Join-Path $soundsDir "$alias.json")

    $csv += "sound,$alias"
    $count++
    Write-Host "Added $alias"
}

if ($count -eq 0) {
    Write-Host "No .wav files found in $srcDir, nothing to build."
    return
}

New-Item -ItemType Directory -Force $zoneSourceDir | Out-Null
$csvPath = Join-Path $zoneSourceDir "mod.csv"
$csv | Set-Content -Encoding ASCII $csvPath

Write-Host ""
Write-Host "Wrote $csvPath with $count sound(s)."
Write-Host "Now in zonebuilder.exe:"
Write-Host "  1. Run:  buildzone mod"
Write-Host "  2. Copy zonebuilder_out\mod.ff to mods\gungame\mod.ff"
