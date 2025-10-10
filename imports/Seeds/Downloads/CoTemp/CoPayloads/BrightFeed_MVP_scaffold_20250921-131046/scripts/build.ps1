
# [PASTE IN POWERSHELL] — Pack the extension into a zip
param(
  [string]$ProjectRoot = "$PSScriptRoot\..",
  [string]$OutDir = "$PSScriptRoot\..\dist"
)
Set-StrictMode -Version Latest; $ErrorActionPreference = 'Stop'
$src = Join-Path $ProjectRoot 'extension'
$out = Join-Path $OutDir 'brightfeed-extension.zip'
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
if(Test-Path $out){ Remove-Item $out -Force }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($src, $out)
Write-Host "Wrote $out"
