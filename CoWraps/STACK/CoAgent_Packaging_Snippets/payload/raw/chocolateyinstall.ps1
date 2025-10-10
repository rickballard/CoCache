$ErrorActionPreference = 'Stop'
$tools = Split-Path -Parent $MyInvocation.MyCommand.Definition
$zip   = Join-Path $tools 'CoAgent_StarterKit_0.1.0.zip'
$dest  = Join-Path $env:USERPROFILE 'Downloads\CoTemp'
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Force -Path $dest | Out-Null }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $dest, $true)
Write-Host "Extracted CoAgent Starter Kit to $dest"
