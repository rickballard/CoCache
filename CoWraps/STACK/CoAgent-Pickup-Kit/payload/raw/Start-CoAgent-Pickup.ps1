# Start-CoAgent-Pickup.ps1
[CmdletBinding(SupportsShouldProcess=$true)]
param(
  [string]$RepoPath = "$HOME\Documents\GitHub\CoAgent",
  [string]$DestSubdir = "tools/CoAgent-Pickup",
  [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Info($m){ Write-Host "[INFO] $m" }
function Warn($m){ Write-Warning $m }
function Die($m){ throw "[FATAL] $m" }

# Resolve paths
$KitRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$KitRoot = if ($KitRoot) { Resolve-Path $KitRoot } else { Get-Location }
$Repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $Repo) { Die "Repo not found: $RepoPath" }

# Verify repo
if (-not (Test-Path (Join-Path $Repo '.git'))) { Die "Not a git repo: $Repo" }

Push-Location $Repo
try {
  # Ensure on a working branch
  $branch = (git rev-parse --abbrev-ref HEAD).Trim()
  if ($branch -eq 'HEAD') { Die "Detached HEAD. Please checkout a branch." }
  if ($branch -eq 'main' -or $branch -eq 'master') {
    $new = "pickup/{0:yyyyMMdd}" -f (Get-Date)
    Info "On $branch; creating work branch $new"
    git switch -c $new | Out-Null
    $branch = $new
  } else {
    Info "Using existing branch $branch"
  }

  # Stage destination
  $dest = Join-Path $Repo $DestSubdir
  if (Test-Path $dest -and -not $Force) {
    Info "Destination exists: $dest (use -Force to allow overwrites)"
  } else {
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
  }

  # Copy core kit files (non-destructive unless -Force)
  $copyList = @(
    'README_COAGENT_PICKUP.md',
    'NEXT_ACTIONS.md',
    'MANIFEST.json',
    'inventory.csv'
  )
  foreach ($rel in $copyList) {
    $src = Join-Path $KitRoot $rel
    $dst = Join-Path $dest   $rel
    if ((Test-Path $dst) -and -not $Force) {
      Info "Skip existing: $rel"
    } else {
      Copy-Item -Path $src -Destination $dst -Force:$Force
      Info "Copied: $rel"
    }
  }

  # Provide signals/ previews
  $sigDst = Join-Path $dest 'signals'
  New-Item -ItemType Directory -Force -Path $sigDst | Out-Null
  Copy-Item -Path (Join-Path $KitRoot 'signals\*') -Destination $sigDst -Recurse -Force:$Force

  # Commit
  git add $DestSubdir
  git commit -m "chore(coagent): add CoAgent Pickup kit ($($Env:COMPUTERNAME))" | Out-Null
  Info "Committed kit into $branch at $DestSubdir"

  # Checklist
  Write-Host ""
  Write-Host "Resume Checklist:"
  Write-Host "  1) Open $DestSubdir/NEXT_ACTIONS.md"
  Write-Host "  2) Scan $DestSubdir/signals for DO blocks"
  Write-Host "  3) Run any safe, idempotent scripts as needed"
  Write-Host "  4) Push branch and open a PR (gh pr create -f)"
}
finally {
  Pop-Location
}
