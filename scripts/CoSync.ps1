param([string]$RepoRoot = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference='Stop'
Set-Location $RepoRoot

# Refresh CoDrift Index, if present
$codrift = Join-Path $RepoRoot 'scripts\Measure-CoDrift.ps1'
if (Test-Path $codrift) { & $codrift }

# Update README status block, if present
$upd = Join-Path $RepoRoot 'scripts\Update-StatusBlock.ps1'
if (Test-Path $upd) { & $upd }

# Ensure opt-in marker exists
$allow1 = Join-Path $RepoRoot '.cosync.ok'
$allow2 = Join-Path $RepoRoot '.cosync-allow'
if (-not (Test-Path $allow1) -and -not (Test-Path $allow2)) {
  Set-Content -Path $allow1 -Value '' -NoNewline
  git add $allow1 | Out-Null
}

# Stage, commit, push
git add status README.md 2>$null
$changed = git status --porcelain
$did = $false
if ($changed) { git commit -m "CoSync: status + README refresh" | Out-Null; $did = $true }
if ($did) { git push | Out-Null }

# Friendly summary
$codriftJson = Join-Path $RepoRoot 'status\codrift.json'
if (Test-Path $codriftJson) {
  try {
    $c = Get-Content $codriftJson -Raw | ConvertFrom-Json
    Write-Host ("CoSync: CDI {0}% ({1}); committed: {2}; pushed: {3}" -f $c.cdi, $c.status, $did, $did)
  } catch { Write-Host ("CoSync: committed: {0}; pushed: {1}" -f $did, $did) }
} else {
  Write-Host ("CoSync: committed: {0}; pushed: {1}" -f $did, $did)
}