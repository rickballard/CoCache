# CoWrap finisher (safely move artifacts from Downloads into repo)
param(
  [string]$RepoPath = (Join-Path $env:USERPROFILE 'Documents\GitHub\CoCivium'),
  [string]$FromDownloadsPattern = 'Spanky_*'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
Push-Location $RepoPath
try {
  $dl = Join-Path $env:USERPROFILE 'Downloads'
  $packs = Get-ChildItem $dl -Filter $FromDownloadsPattern -File 2>$null
  foreach($p in $packs){
    $dst = Join-Path $RepoPath ("artifacts\" + $p.Name)
    New-Item -Force -ItemType Directory (Split-Path $dst) | Out-Null
    Move-Item -Force $p.FullName $dst
  }
  Write-Host "Moved $($packs.Count) Spanky packs into repo/artifacts."
} finally { Pop-Location 2>$null }