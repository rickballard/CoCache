Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
function Info($m){ Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Warn($m){ Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Die($m){ Write-Error $m; exit 1 }

$dl = Join-Path $env:USERPROFILE 'Downloads'
$pattern = 'Godspawn_Part3_AdviceBomb_v*.zip'
$files = Get-ChildItem -Path $dl -Filter $pattern -File -ErrorAction SilentlyContinue
if(-not $files){ Die "No Godspawn Part 3 packs found under $dl" }
function Parse-Ver([string]$name){ if($name -match 'v(\d+\.\d+\.\d+)'){ [version]$matches[1] } else { [version]'0.0.0' } }
$latest = $files | Sort-Object { Parse-Ver $_.Name } -Descending | Select-Object -First 1
$latestVer = (Parse-Ver $latest.Name).ToString()
Info "Using Godspawn P3: $($latest.FullName) (v$latestVer)"

$temp = Join-Path $env:TEMP ("GodspawnP3_" + (Get-Date -Format 'yyyyMMdd_HHmmss'))
Expand-Archive -Path $latest.FullName -DestinationPath $temp -Force
$man = Get-Content (Join-Path $temp 'manifest.json') | ConvertFrom-Json
if($man.version -ne $latestVer){ Die "Filename version ($latestVer) != manifest version ($($man.version))" }

$GodspawnRepo = Join-Path $env:USERPROFILE 'Documents\GitHub\Godspawn'
if(-not (Test-Path $GodspawnRepo)){ Die "Repo not found: $GodspawnRepo" }

$branch = "feature/godspawn-p3-advice-v$latestVer"

# Drop under HH/AdviceBombs
$dest = Join-Path $GodspawnRepo "HH\AdviceBombs\Godspawn_Part3_AdviceBomb_v$latestVer"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item -Path (Join-Path $temp '*') -Destination $dest -Recurse -Force

# Commit and push
Push-Location $GodspawnRepo
try {
  git fetch --all | Out-Null
  $exists = git branch -r --list "origin/$branch"
  if($exists){ git checkout $branch | Out-Null } else { git checkout -b $branch | Out-Null }
  git add -A
  if(git status --porcelain){
    git commit -m "Add Godspawn Part 3 Advice Bomb v$latestVer"
    git push -u origin (git rev-parse --abbrev-ref HEAD) | Out-Null
    Info "Committed and pushed in Godspawn"
  } else { Info "Nothing to commit in Godspawn" }
} finally { Pop-Location }

# Cleanup zips
$all = Get-ChildItem -Path $dl -Filter $pattern -File -ErrorAction SilentlyContinue
foreach($f in $all){ try { Remove-Item $f.FullName -Force } catch { Warn "Could not delete $($f.FullName)" } }

Info "Godspawn Part 3 v$latestVer deployment complete."
