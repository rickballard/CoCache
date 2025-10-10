Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
param(
  [Parameter(Mandatory=$true)][string]$BaseUrl,
  [switch]$OpenGuides,
  [switch]$Sandbox,
  [switch]$LocalBackup
)
# Optional sandbox flag
if($Sandbox){
  $dir = Join-Path $PSScriptRoot "..\.coagent"
  New-Item -ItemType Directory -Force $dir | Out-Null
  $cfg = @{ NO_NETWORK = 1; timestamp = (Get-Date).ToString("s") }
  $cfg | ConvertTo-Json | Set-Content -Encoding UTF8 (Join-Path $dir "sandbox.config.json")
  $env:NO_NETWORK = "1"
  Write-Host "✅ Sandbox ON (NO_NETWORK=1)"
}
# Local backup opt-in
if($LocalBackup){
  $dir = Join-Path $PSScriptRoot "..\.coagent\logs"
  New-Item -ItemType Directory -Force $dir | Out-Null
  Write-Host "🗂️  Local backup ENABLED → $dir"
}
# Open guides
if($OpenGuides){
  $guide = Join-Path $PSScriptRoot "..\docs\Onboarding.html"
  if(Test-Path $guide){ Start-Process $guide }
}
# Open product tabs
$tabs = @("$BaseUrl/","$BaseUrl/ui-mock/quad.html","$BaseUrl/status.html")
$tabs | % { Start-Process $_ }
# Quick smoke
$tester = Join-Path $PSScriptRoot "Test-MVP.ps1"
if(Test-Path $tester){ pwsh -File $tester -BaseUrl $BaseUrl }
