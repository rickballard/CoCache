# Publish-CoModulesAssets.ps1
# Creates dist/careerOS/, uploads two zips, seeds CoModules product plans, writes CoWrap, pushes, and prints final URLs.

param(
  [string]$RepoOwner = "rickballard",            # change if different
  [string]$RepoName  = "CoModules",              # change if different
  [string]$LocalRepoPath = "$HOME\Documents\GitHub\CoModules",  # adjust if different
  [string]$Zip1Path = "$HOME\Downloads\careerOS_generic_v2.zip",
  [string]$Zip2Path = "$HOME\Downloads\careerOS_personalize_v2.zip",
  [switch]$InitIfMissing
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-Dir($p) { if(-not (Test-Path $p)){ New-Item -ItemType Directory -Path $p | Out-Null } }

# 1) Ensure local repo exists
if (-not (Test-Path $LocalRepoPath)) {
  if (-not $InitIfMissing) { throw "Local repo not found: $LocalRepoPath. Re-run with -InitIfMissing or point to your clone." }
  if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw "gh CLI required to clone when -InitIfMissing. Install from https://cli.github.com/" }
  Write-Host "Cloning $RepoOwner/$RepoName to $LocalRepoPath ..."
  gh repo clone "$RepoOwner/$RepoName" "$LocalRepoPath"
}

Set-Location $LocalRepoPath

# 2) Create dist/careerOS and copy zips
$dist = Join-Path $LocalRepoPath "dist\careerOS"
Ensure-Dir $dist

if (-not (Test-Path $Zip1Path)) { throw "Zip1 not found: $Zip1Path" }
if (-not (Test-Path $Zip2Path)) { throw "Zip2 not found: $Zip2Path" }

Copy-Item -Force $Zip1Path (Join-Path $dist "careerOS_generic_v2.zip")
Copy-Item -Force $Zip2Path (Join-Path $dist "careerOS_personalize_v2.zip")

# 3) Seed CoModules product plans
$careerOSDir = Join-Path $LocalRepoPath "careerOS"
$lifeOSDir   = Join-Path $LocalRepoPath "lifeOS"
Ensure-Dir $careerOSDir
Ensure-Dir $lifeOSDir

$careerPlan = @"
# careerOS — Product Plan (draft)

**Purpose**: a reusable, repo-native operating system for career design and job execution.
**Audience**: pros in transition, marginalized/introvert communities, creative technologists.
**Core**:
- Self-evolving repo (Issues, prompts, BPOE approvals)
- Market mapping + packaging options
- Portfolio outlines (code can live in separate repos)
- Orchestration hooks (CoAgent optional)
**Milestones**:
1. Bootstrap + rainbow demo
2. Personalization overlay
3. Autonomy add-on (bi-monthly + monthly)
4. CoAgent orchestration
5. Community templates and exemplars
"@
Set-Content -Path (Join-Path $careerOSDir "product-plan.md") -Value $careerPlan -Encoding UTF8

$lifePlan = @"
# lifeOS — Product Plan (draft)

**Purpose**: personal resilience, mindset, congruence, and long-horizon vision.
**Audience**: anyone balancing wellbeing with career demands.
**Core**:
- Reflections, resilience prompts, habit scaffolding
- Congruence maps with CoCivium BPOE
- Local nudges + optional email reminders
**Milestones**:
1. Vision + prompts library
2. Monthly cadence + check-in templates
3. Wellness/habit trackers
4. CoAgent orchestration
"@
Set-Content -Path (Join-Path $lifeOSDir "product-plan.md") -Value $lifePlan -Encoding UTF8

# 4) Write or update CoWrap
$coCache = Join-Path $LocalRepoPath "CoCache"
Ensure-Dir $coCache
$wrapPath = Join-Path $coCache "CoWrap.md"
$now = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss K")

$wrapEntry = @"
## $now — Session: careerOS & lifeOS bootstrap
- Added dist/careerOS/ with `careerOS_generic_v2.zip` and `careerOS_personalize_v2.zip`
- Seeded product plans: careerOS/product-plan.md, lifeOS/product-plan.md
- Links will be used in outgoing email to Elias
- Next: wire CoAgent MVP3, finalize BPOE sync, gather exemplars via PRs
"@

if (Test-Path $wrapPath) {
  $existing = Get-Content $wrapPath -Raw
  Set-Content -Path $wrapPath -Value ($existing + "`n`n" + $wrapEntry) -Encoding UTF8
} else {
  Set-Content -Path $wrapPath -Value ("# CoWrap — Running Summary`n`n" + $wrapEntry) -Encoding UTF8
}

# 5) Commit and push
git add .
git commit -m "CoModules: add careerOS v2 zips, seed product plans, update CoWrap"
git push

# 6) Print final raw URLs
$raw1 = "https://github.com/$RepoOwner/$RepoName/raw/main/dist/careerOS/careerOS_generic_v2.zip"
$raw2 = "https://github.com/$RepoOwner/$RepoName/raw/main/dist/careerOS/careerOS_personalize_v2.zip"

Write-Host ""
Write-Host "==== Paste these links into your email to Elias ===="
Write-Host "Zip1: $raw1"
Write-Host "Zip2: $raw2"
Write-Host "==============================================="
