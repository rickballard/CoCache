# DO_CopyToWeb.ps1 — quick helper to stage About/Press
param(
  [Parameter(Mandatory=$true)][string]$WebRoot # e.g. C:\Sites\cocivium.org
)

$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$pressKit = Join-Path $src "04_Press_Kit"

# Ensure folders exist
New-Item -ItemType Directory -Force (Join-Path $WebRoot "about") | Out-Null
New-Item -ItemType Directory -Force (Join-Path $WebRoot "press") | Out-Null

Copy-Item (Join-Path $pressKit "about.html") (Join-Path $WebRoot "about\index.html") -Force
Copy-Item (Join-Path $pressKit "press.html") (Join-Path $WebRoot "press\index.html") -Force

Write-Host "Staged /about and /press. Review and publish."

