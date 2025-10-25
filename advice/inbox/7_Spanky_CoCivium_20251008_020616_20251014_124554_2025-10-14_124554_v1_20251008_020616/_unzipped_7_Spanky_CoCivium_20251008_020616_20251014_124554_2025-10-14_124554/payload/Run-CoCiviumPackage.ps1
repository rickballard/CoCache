[CmdletBinding()]
param(
  [string]$Downloads = (Join-Path $HOME 'Downloads'),
  [string]$Pattern   = 'CoCivium_*_v*.zip',
  [switch]$KeepExtract
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
Write-Host "Looking in: $Downloads" -ForegroundColor Cyan
$z = Get-ChildItem -Path $Downloads -Filter $Pattern -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if(-not $z){ Write-Host "No packages found." -ForegroundColor Yellow; return }
$dest = Join-Path $env:TEMP ("pkg_{0}" -f (Get-Random)); New-Item -ItemType Directory -Force -Path $dest | Out-Null
Expand-Archive -LiteralPath $z.FullName -DestinationPath $dest -Force
$do = Join-Path $dest 'do.ps1'
if(Test-Path $do){ & pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File $do }
Remove-Item -Recurse -Force $dest -ErrorAction SilentlyContinue
