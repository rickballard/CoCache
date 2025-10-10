# run.ps1 (sample)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$out = Join-Path $PSScriptRoot 'out.txt'
"Hello from sample at $(Get-Date -Format o)" | Set-Content -Encoding UTF8 $out
Write-Host "Wrote $out"
