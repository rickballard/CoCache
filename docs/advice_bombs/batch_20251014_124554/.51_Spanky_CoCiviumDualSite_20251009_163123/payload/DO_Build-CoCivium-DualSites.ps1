# DO: Build-CoCivium-DualSites.ps1
param(
    [string]$RepoRoot = "$HOME\Documents\GitHub\CoCivium",
    [switch]$Init
)
Write-Host ">> CoCivium Dual-Sites bootstrap starting..."
if ($Init) {
  New-Item -ItemType Directory -Force -Path "$RepoRoot\site.org","$RepoRoot\site.com" | Out-Null
}
Write-Host ">> TODO: Add GitHub Actions workflows and JSON-LD schemas."

