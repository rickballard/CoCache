param([string]$Agent = "U", [string]$Msg = "ping")
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path ($env:COCACHE_LOCAL ?? (Join-Path $HOME 'Downloads/CoCacheLocal')) 'sessions'
$base = Join-Path $root $env:COSESSION_ID
$log  = Join-Path $base 'log.ndjson'
New-Item -Type Directory -Force -Path $base | Out-Null
"$(Get-Date -AsUTC -Format o) PING $Msg" | Set-Content -Encoding UTF8NoBOM (Join-Path $base 'coping.txt')
& (Join-Path $PSScriptRoot 'Emit.ps1') -Agent $Agent -Type ping -Msg $Msg | Out-Null
Start-Sleep -Milliseconds 300
"$(Get-Date -AsUTC -Format o) PONG ack" | Set-Content -Encoding UTF8NoBOM (Join-Path $base 'copong.txt')
& (Join-Path $PSScriptRoot 'Emit.ps1') -Agent $Agent -Type pong -Msg 'ack' | Out-Null
