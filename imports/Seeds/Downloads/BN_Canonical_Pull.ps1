# BN_Canonical_Pull.ps1
# Purpose: Promote the CoCivium "Being Noname" story into CoCache at
#          Insights\BN_Story_being-noname_v1.0.md, pulling from the
#          canonical CoCivium path (web) or a local CoCivium clone.
# Usage:   Run from inside your CoCache repo
#          PS> Set-Location 'C:\Users\Chris\Documents\GitHub\CoCache'
#          PS> .\BN_Canonical_Pull.ps1

Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Get-RepoRoot {
  $root = (git rev-parse --show-toplevel) 2>$null
  if(-not $root){ throw "Run this from inside the CoCache repo (git root not found)." }
  return $root
}

$repo = Get-RepoRoot
Set-Location $repo

$destRel = "Insights\BN_Story_being-noname_v1.0.md"
$destAbs = Join-Path $repo $destRel
New-Item -ItemType Directory -Force -Path (Split-Path $destAbs) | Out-Null

# Preferred source (web): CoCivium main branch
$rawUrl = "https://raw.githubusercontent.com/rickballard/CoCivium/main/insights/Insight_Story_Being_Noname_c2_20250801.md"

$content = $null

# Try web first
try {
  $content = Invoke-RestMethod -Uri $rawUrl -TimeoutSec 25
} catch {
  Write-Host "Web fetch failed, trying local fallback…" -ForegroundColor Yellow
}

# Fallback: local CoCivium clone next to CoCache
if(-not $content){
  $coLocal = Join-Path (Split-Path $repo -Parent) "CoCivium\insights\Insight_Story_Being_Noname_c2_20250801.md"
  if(Test-Path $coLocal){
    $content = Get-Content -LiteralPath $coLocal -Raw -ErrorAction Stop
  }
}

if(-not $content){
  throw "Couldn't retrieve Being Noname (web and local clone both unavailable). Check network or clone CoCivium next to CoCache."
}

# Guard: exact name should appear
if(-not ($content -match '(?im)\bBeing\s+Noname\b')){
  throw "Guard: pulled text does not contain the exact phrase 'Being Noname'. Aborting."
}

# Write destination
Set-Content -LiteralPath $destAbs -Value $content -Encoding UTF8

# Stage + commit if changed
$changed = git status --porcelain -- $destRel
if([string]::IsNullOrWhiteSpace($changed)){
  Write-Host "No changes to commit — $destRel already up to date." -ForegroundColor Cyan
} else {
  git add -- $destRel | Out-Null
  git commit -m "docs(Insights): set canonical Being Noname from CoCivium (c2_20250801)" | Out-Null
  Write-Host "Committed $destRel" -ForegroundColor Green
}

Write-Host "Done: $destRel" -ForegroundColor Green
