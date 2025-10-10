param(
  [string]$Dest = (Join-Path $HOME 'Desktop\CoAgent_ResearchPack')
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$src = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not (Test-Path $Dest)) { New-Item -ItemType Directory -Force -Path $Dest | Out-Null }
Copy-Item -Recurse -Force (Join-Path $src '*') $Dest
Write-Host ("Copied research pack to: {0}" -f $Dest) -ForegroundColor Green
