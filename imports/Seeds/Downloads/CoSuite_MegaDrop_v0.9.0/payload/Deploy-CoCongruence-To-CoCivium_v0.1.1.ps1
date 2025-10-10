
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
function Info($m){ Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Warn($m){ Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Die($m){ Write-Error $m; exit 1 }

$dl = Join-Path $env:USERPROFILE 'Downloads'
$pattern = 'CoCongruence_Doctrine_Pack_v*.zip'
$files = Get-ChildItem -Path $dl -Filter $pattern -File -ErrorAction SilentlyContinue
if(-not $files){ Die "No CoCongruence doctrine packs found under $dl" }
function Parse-Ver([string]$name){ if($name -match 'v(\d+\.\d+\.\d+)'){ [version]$matches[1] } else { [version]'0.0.0' } }
$latest = $files | Sort-Object { Parse-Ver $_.Name } -Descending | Select-Object -First 1
$latestVer = (Parse-Ver $latest.Name).ToString()
Info "Using Doctrine Pack: $($latest.FullName) (v$latestVer)"

$temp = Join-Path $env:TEMP ("CoDoctrinePack_" + (Get-Date -Format 'yyyyMMdd_HHmmss'))
Expand-Archive -Path $latest.FullName -DestinationPath $temp -Force
$man = Get-Content (Join-Path $temp 'manifest.json') | ConvertFrom-Json
if($man.version -ne $latestVer){ Die "Filename version ($latestVer) != manifest version ($($man.version))" }

$CoCiviumRepo = Join-Path $env:USERPROFILE 'Documents\GitHub\CoCivium'
if(-not (Test-Path $CoCiviumRepo)){ Die "Repo not found: $CoCiviumRepo" }

$branch = "feature/congruence-doctrine-v$latestVer"
$target = Join-Path $CoCiviumRepo 'Insights\Congruence\Doctrine'
New-Item -ItemType Directory -Force -Path $target | Out-Null

Copy-Item -Path (Join-Path $temp 'docs\*') -Destination $target -Recurse -Force
$toolsSrc = Join-Path $temp 'tools\ps\Update-Doctrine-CoRef.ps1'
$toolsDst = Join-Path $CoCiviumRepo 'tools\CoRef\ps\Update-Doctrine-CoRef.ps1'
New-Item -ItemType Directory -Force -Path (Split-Path $toolsDst) | Out-Null
Copy-Item -Path $toolsSrc -Destination $toolsDst -Force
$schemaSrc = Join-Path $temp 'schema\concept_registry.links.json'
$schemaDst = Join-Path $CoCiviumRepo 'Insights\Indexing\concept_registry.links.json'
New-Item -ItemType Directory -Force -Path (Split-Path $schemaDst) | Out-Null
Copy-Item -Path $schemaSrc -Destination $schemaDst -Force

# Generate sidecar using CoRef generator if available
$genPS = Join-Path $CoCiviumRepo 'tools\CoRef\ps\Generate-CoRef.ps1'
$docPath = Join-Path $target 'doctrine-index.md'
if(Test-Path $genPS){
  & $genPS -Path $docPath -DocId "CD:doctrine-index" -Namespace "CD" -OutMap (Join-Path $target 'doctrine-index.coref.json') | Out-Null
  Info "Generated doctrine-index.coref.json"
} else {
  Warn "CoRef generator not found. Left placeholder sidecar."
}

# Commit and push
Push-Location $CoCiviumRepo
try {
  git fetch --all | Out-Null
  $exists = git branch -r --list "origin/$branch"
  if($exists){ git checkout $branch | Out-Null } else { git checkout -b $branch | Out-Null }
  git add -A
  if(git status --porcelain){
    git commit -m ("Seed Congruence Doctrine v{0}: index, links, and sidecar generator" -f $latestVer)
    git push -u origin (git rev-parse --abbrev-ref HEAD) | Out-Null
    Info "Committed and pushed in CoCivium"
  } else { Info "Nothing to commit in CoCivium" }
} finally { Pop-Location }

# Cleanup all doctrine zips in Downloads
$all = Get-ChildItem -Path $dl -Filter $pattern -File -ErrorAction SilentlyContinue
foreach($f in $all){ try { Remove-Item $f.FullName -Force } catch { Warn "Could not delete $($f.FullName)" } }

Info "Congruence Doctrine v$latestVer deployment complete."
