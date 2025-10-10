
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
function Info($m){ Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Warn($m){ Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Die($m){ Write-Error $m; exit 1 }

$dl = Join-Path $env:USERPROFILE 'Downloads'
$pattern = 'CoRender_Fallbacks_AdviceBomb_v*.zip'

# Pick newest by SemVer in filename
$files = Get-ChildItem -Path $dl -Filter $pattern -File -ErrorAction SilentlyContinue
if(-not $files){ Die "No CoRender advice bombs found under $dl" }
function Parse-Ver([string]$name){ if($name -match 'v(\d+\.\d+\.\d+)'){ [version]$matches[1] } else { [version]'0.0.0' } }
$latest = $files | Sort-Object { Parse-Ver $_.Name } -Descending | Select-Object -First 1
$latestVer = (Parse-Ver $latest.Name).ToString()
Info "Using Advice Bomb: $($latest.FullName) (v$latestVer)"

# Validate manifest
$temp = Join-Path $env:TEMP ("CoRenderAdviceBomb_" + (Get-Date -Format 'yyyyMMdd_HHmmss'))
Expand-Archive -Path $latest.FullName -DestinationPath $temp -Force
$man = Get-Content (Join-Path $temp 'manifest.json') | ConvertFrom-Json
if($man.version -ne $latestVer){ Die "Filename version ($latestVer) != manifest version ($($man.version))" }

# Repos
$CoAgentRepo  = Join-Path $env:USERPROFILE 'Documents\GitHub\CoAgent'
$CoCiviumRepo = Join-Path $env:USERPROFILE 'Documents\GitHub\CoCivium'
foreach($p in @($CoAgentRepo,$CoCiviumRepo)){ if(-not (Test-Path $p)){ Die "Repo not found: $p" } }

$branch = 'feature/corender-ci-fallbacks'

# CoAgent advice (optional)
$advice = Join-Path $CoAgentRepo 'AdviceBombs\GraphicsTooling_Fallbacks'
New-Item -ItemType Directory -Force -Path $advice | Out-Null
Copy-Item -Path (Join-Path $temp 'CoAgent\*') -Destination $advice -Recurse -Force -ErrorAction SilentlyContinue

# CoCivium CI workflow
$wf = Join-Path $CoCiviumRepo '.github\workflows'
New-Item -ItemType Directory -Force -Path $wf | Out-Null
Copy-Item -Path (Join-Path $temp '.github\workflows\render-assets.yml') -Destination $wf -Force

# Shared hooks with cross-platform wrappers
$shared = Join-Path $env:USERPROFILE 'Documents\GitHub\.git-hooks'
New-Item -ItemType Directory -Force -Path $shared | Out-Null
Copy-Item -Path (Join-Path $temp 'hooks\pre-commit')      -Destination (Join-Path $shared 'pre-commit')      -Force
Copy-Item -Path (Join-Path $temp 'hooks\pre-commit.ps1')  -Destination (Join-Path $shared 'pre-commit.ps1')  -Force
Copy-Item -Path (Join-Path $temp 'hooks\pre-commit.cmd')  -Destination (Join-Path $shared 'pre-commit.cmd')  -Force

git -C $CoAgentRepo  config core.hooksPath $shared
git -C $CoCiviumRepo config core.hooksPath $shared

# Tools
$tools = Join-Path $CoCiviumRepo 'tools\CoRender'
New-Item -ItemType Directory -Force -Path $tools | Out-Null
Copy-Item -Path (Join-Path $temp 'tools\*') -Destination $tools -Recurse -Force -ErrorAction SilentlyContinue

# Commit/push
foreach($repo in @($CoAgentRepo,$CoCiviumRepo)){ 
  Push-Location $repo
  try{ 
    git fetch --all | Out-Null
    $exists = git branch -r --list "origin/$branch"
    if($exists){ git checkout $branch | Out-Null } else { git checkout -b $branch | Out-Null }
    git add -A
    if(git status --porcelain){ 
      git commit -m "CoRender v0.2.1: CI workflow + cross-platform hooks (non-blocking)"
      git push -u origin (git rev-parse --abbrev-ref HEAD) | Out-Null
      Info "Committed and pushed in $repo"
    } else { Info "Nothing to commit in $repo" }
  } finally { Pop-Location }
}

# Cleanup all versioned zips in Downloads
$all = Get-ChildItem -Path $dl -Filter $pattern -File -ErrorAction SilentlyContinue
foreach($f in $all){ try { Remove-Item $f.FullName -Force } catch { Warn "Could not delete $($f.FullName)" } }

Info "CoRender v0.2.1 deployment complete."
