Write-Host "Hello from HH payload."
"Hello from HH payload at $(Get-Date -Format o)" | Set-Content -Encoding UTF8 (Join-Path $PSScriptRoot "out.txt")
