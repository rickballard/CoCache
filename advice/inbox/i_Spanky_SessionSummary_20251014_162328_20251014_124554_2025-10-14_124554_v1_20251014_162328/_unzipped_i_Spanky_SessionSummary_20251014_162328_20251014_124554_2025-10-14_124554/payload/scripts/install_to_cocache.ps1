
param(
  [string]$CoCachePath = "$HOME\Documents\GitHub\CoCache"
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$Base = Split-Path -Parent $MyInvocation.MyCommand.Path
$AdviceZip = Join-Path $Base "zips\AdviceBomb_CoAgent_Breakout_20251013_181004.zip"
$InspoZip  = Join-Path $Base "zips\InspirationPack_CoAgent_20251013_181715.zip"

# Prepare dests
$AdviceDest = Join-Path $CoCachePath "AdviceBombs\AB-CoAgent-Breakout"
$InspoDest  = Join-Path $AdviceDest "_notes\_inspiration"
New-Item -ItemType Directory -Force -Path $AdviceDest, $InspoDest | Out-Null

# Unzip advisory if present
if (Test-Path $AdviceZip) {
  Expand-Archive -Path $AdviceZip -DestinationPath (Join-Path $AdviceDest "_imported") -Force
}
# Unzip inspiration if present
if (Test-Path $InspoZip) {
  Expand-Archive -Path $InspoZip -DestinationPath (Join-Path $InspoDest "_imported") -Force
}

# Drop index readme
$idx = @"
# AB-CoAgent-Breakout (canonical)
- Session summary is in this package: payload/summary/SESSION_SUMMARY.md
- Prior Advice Bomb and Inspiration Pack (if bundled) are under _imported/
"@
$idx | Set-Content -Encoding UTF8 (Join-Path $AdviceDest "README.md")

Write-Host "Installed summary and unpacked bundled zips (if present) into $AdviceDest" -ForegroundColor Green
