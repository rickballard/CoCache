param([string]$Target='inbox')
$root = Join-Path $HOME 'Downloads\CoTemp'
$inbox = if ($Target -and $Target -ne 'inbox') { Join-Path $root ("sessions\{0}\inbox" -f $Target) } else { Join-Path $root 'inbox' }
New-Item -ItemType Directory -Force -Path $inbox | Out-Null
$name = "DO_Smoke_{0}.ps1" -f (Get-Date -Format "HHmmss")
$path = Join-Path $inbox $name
$body = @"
"Smoke test at $(Get-Date -Format o)"
`$PSVersionTable.PSVersion
"@
Set-Content -LiteralPath $path -Encoding UTF8 -Value $body
Write-Host ("Queued -> {0}" -f $path) -ForegroundColor Green
$path
