
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
function Info($m){ Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Warn($m){ Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Die($m){ Write-Error $m; exit 1 }

$dl = Join-Path $env:USERPROFILE 'Downloads'
$pattern = 'CoRef_ConceptFirst_AdviceBomb_v*.zip'

# Select newest by SemVer
$files = Get-ChildItem -Path $dl -Filter $pattern -File -ErrorAction SilentlyContinue
if(-not $files){ Die "No CoRef advice bombs found under $dl" }
function Parse-Ver([string]$name){ if($name -match 'v(\d+\.\d+\.\d+)'){ [version]$matches[1] } else { [version]'0.0.0' } }
$latest = $files | Sort-Object { Parse-Ver $_.Name } -Descending | Select-Object -First 1
$latestVer = (Parse-Ver $latest.Name).ToString()
Info "Using Advice Bomb: $($latest.FullName) (v$latestVer)"

# Validate manifest
$temp = Join-Path $env:TEMP ("CoRefAdviceBomb_" + (Get-Date -Format 'yyyyMMdd_HHmmss'))
Expand-Archive -Path $latest.FullName -DestinationPath $temp -Force
$man = Get-Content (Join-Path $temp 'manifest.json') | ConvertFrom-Json
if($man.version -ne $latestVer){ Die "Filename version ($latestVer) != manifest version ($($man.version))" }

# Repos
$CoCiviumRepo = Join-Path $env:USERPROFILE 'Documents\GitHub\CoCivium'
$GodspawnRepo = Join-Path $env:USERPROFILE 'Documents\GitHub\Godspawn'
foreach($p in @($CoCiviumRepo,$GodspawnRepo)){ if(-not (Test-Path $p)){ Die "Repo not found: $p" } }

$branch = 'feature/coref-indexing-setup'

# Godspawn: drop bundle
$hhTarget = Join-Path $GodspawnRepo 'HH\AdviceBombs\CoRef_ConceptFirst_AdviceBomb_v0.3.0'
New-Item -ItemType Directory -Force -Path $hhTarget | Out-Null
Copy-Item -Path (Join-Path $temp '*') -Destination $hhTarget -Recurse -Force

# Install shared no-op hooks to avoid spawn errors
$shared = Join-Path $env:USERPROFILE 'Documents\GitHub\.git-hooks'
New-Item -ItemType Directory -Force -Path $shared | Out-Null
Copy-Item -Path (Join-Path $temp 'hooks\pre-commit')     -Destination (Join-Path $shared 'pre-commit')     -Force
Copy-Item -Path (Join-Path $temp 'hooks\pre-commit.ps1') -Destination (Join-Path $shared 'pre-commit.ps1') -Force
Copy-Item -Path (Join-Path $temp 'hooks\pre-commit.cmd') -Destination (Join-Path $shared 'pre-commit.cmd') -Force
git -C $GodspawnRepo config core.hooksPath $shared

# Commit Godspawn
Push-Location $GodspawnRepo
try {
  git fetch --all | Out-Null
  $exists = git branch -r --list "origin/$branch"
  if($exists){ git checkout $branch | Out-Null } else { git checkout -b $branch | Out-Null }
  git add -A
  if(git status --porcelain){
    git commit -m "Add CoRef v0.3.0 Advice Bomb under HH/AdviceBombs"
    git push -u origin (git rev-parse --abbrev-ref HEAD) | Out-Null
    Info "Committed and pushed in Godspawn"
  } else { Info "Nothing to commit in Godspawn" }
} finally { Pop-Location }

# CoCivium: seed standards + tools + exemplar and generate sidecar
$insightsRoot = Join-Path $CoCiviumRepo 'Insights'
$doctrineDir  = Join-Path $insightsRoot 'Congruence'
$indexingDir  = Join-Path $insightsRoot 'Indexing'
$toolsDir     = Join-Path $CoCiviumRepo 'tools\CoRef'
New-Item -ItemType Directory -Force -Path $doctrineDir,$indexingDir,$toolsDir | Out-Null
Copy-Item (Join-Path $temp 'docs\HH_alignment.md') $indexingDir -Force
Copy-Item (Join-Path $temp 'docs\standards') $indexingDir -Recurse -Force
Copy-Item (Join-Path $temp 'schema\concept_registry.coref.json') (Join-Path $indexingDir 'concept_registry.coref.json') -Force
Copy-Item (Join-Path $temp 'tools\ps') $toolsDir -Recurse -Force
Copy-Item (Join-Path $temp 'tools\py') $toolsDir -Recurse -Force

$docDir = Join-Path $doctrineDir 'FaithsInDialogue'
New-Item -ItemType Directory -Force -Path $docDir | Out-Null
Copy-Item (Join-Path $temp 'docs\examples\faiths-in-dialogue.md') $docDir -Force

# Generate sidecar
$genPS = Join-Path $toolsDir 'ps\Generate-CoRef.ps1'
if(Test-Path $genPS){
  & $genPS -Path (Join-Path $docDir 'faiths-in-dialogue.md') -DocId "FD:faiths-in-dialogue" -Namespace "FD" -OutMap (Join-Path $docDir 'faiths-in-dialogue.coref.json') | Out-Null
  Info "Generated faiths-in-dialogue.coref.json"
} else { Warn "Generator missing at $genPS" }

# Commit CoCivium
Push-Location $CoCiviumRepo
try {
  git fetch --all | Out-Null
  $exists = git branch -r --list "origin/$branch"
  if($exists){ git checkout $branch | Out-Null } else { git checkout -b $branch | Out-Null }
  git add -A
  if(git status --porcelain){
    git commit -m "Seed CoRef v0.3.0: indexing standards, tools, and exemplar"
    git push -u origin (git rev-parse --abbrev-ref HEAD) | Out-Null
    Info "Committed and pushed in CoCivium"
  } else { Info "Nothing to commit in CoCivium" }
} finally { Pop-Location }

# Cleanup all versioned CoRef zips in Downloads
$all = Get-ChildItem -Path $dl -Filter $pattern -File -ErrorAction SilentlyContinue
foreach($f in $all){ try { Remove-Item $f.FullName -Force } catch { Warn "Could not delete $($f.FullName)" } }

Info "CoRef v0.3.0 deployment complete."
