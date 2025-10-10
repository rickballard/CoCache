param([switch]$Commit,[switch]$Push)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Note($m){ Write-Host "[60-Build] $m" }
$wt = Get-ChildItem "$HOME\Documents\GitHub\CoAgent__mvp3*" -Directory -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Desc | Select-Object -First 1
if(-not $wt){ Note "Skipped (worktree not found)"; return }
Set-Location $wt.FullName
git status | Out-Null
if($Commit){
  git add .
  git commit -m "MVP3: add plan + help/training docs (auto)" | Out-Null
  Note "Committed changes."
}
if($Push){
  git push | Out-Null
  Note "Pushed to remote."
}
if(-not $Commit -and -not $Push){
  Note "Nothing to build yet (docs only). Consider -Commit/-Push."
}
