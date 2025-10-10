param([Parameter(Mandatory=$true)][string]$RepoPath)
$ErrorActionPreference = 'Stop'
$devDir = Join-Path $RepoPath '.dev\backend-interceptor'
if (Test-Path $devDir) {
  Remove-Item -Recurse -Force $devDir
  Write-Host "🧹 Removed $devDir" -ForegroundColor Green
} else {
  Write-Host "Nothing to remove at $devDir"
}
