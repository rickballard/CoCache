Param(
  [string]$Dest = (Join-Path $HOME 'Desktop\CoAgent_ResearchPack')
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $src
if (-not (Test-Path $Dest)) { New-Item -ItemType Directory -Force -Path $Dest | Out-Null }
Copy-Item -Recurse -Force -Path (Join-Path $root '*') -Exclude 'tools' -Destination $Dest
Write-Host ("Installed research pack -> {0}" -f $Dest) -ForegroundColor Green
