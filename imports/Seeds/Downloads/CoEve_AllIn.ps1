param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank')
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

# 1) Sync main
pwsh -f "$HOME\Downloads\CoEve_SyncMain.ps1" | Write-Host

# 2) Smoke: seed + score
$rc = pwsh -f "$HOME\Downloads\CoEve_Smoke.ps1" -RepoRoot $RepoRoot
Write-Host $rc
