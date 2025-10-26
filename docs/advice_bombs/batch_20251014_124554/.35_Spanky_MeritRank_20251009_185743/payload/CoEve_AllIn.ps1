param([string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'))
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
pwsh -f "$HOME\Downloads\CoEve_SyncMain.ps1" | Write-Host
$rc = pwsh -f "$HOME\Downloads\CoEve_Smoke.ps1" -RepoRoot $RepoRoot
Write-Host $rc

