param(
  [Parameter(Mandatory=$true)][string]$From,  # path to unzipped Starter Kit root
  [string]$To = (Join-Path $HOME 'Downloads\CoTemp')
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $From)) { throw "Source not found: $From" }
if (-not (Test-Path $To))   { New-Item -ItemType Directory -Force -Path $To | Out-Null }

Copy-Item -Recurse -Force (Join-Path $From '*') $To
Get-ChildItem -LiteralPath $To -Recurse -Filter *.ps1 | Unblock-File

# Bootstrap: open two tabs + start watchers (optional for clean installs)
try { & (Join-Path $To 'CoAgentLauncher.ps1') -OpenBrowser } catch {}

Write-Host "Installed CoAgent runtime to $To" -ForegroundColor Green
