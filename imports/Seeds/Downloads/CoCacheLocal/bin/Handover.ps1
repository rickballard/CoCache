param([string]$Agent = "U", [string]$Note = "handover ready")
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path ($env:COCACHE_LOCAL ?? (Join-Path $HOME 'Downloads/CoCacheLocal')) 'sessions'
$base = Join-Path $root $env:COSESSION_ID
$log  = Join-Path $base 'log.ndjson'
$hand = Join-Path $base 'handover.json'
$handover = @{
  session_id = $env:COSESSION_ID
  ts         = (Get-Date).ToUniversalTime().ToString('o')
  repo       = (Get-Location).Path
  branch     = (git rev-parse --abbrev-ref HEAD 2>$null)
  status     = (git status --porcelain=v1 -b 2>$null) -split "`n"
  last200    = (Test-Path $log) ? (Get-Content $log -Tail 200) : @()
  note       = $Note
  agent      = $Agent
}
$handover | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8NoBOM $hand
& (Join-Path $PSScriptRoot 'Emit.ps1') -Agent $Agent -Type cowrap -Msg 'handover.json ready' -Data @{ path = $hand } | Out-Null
Write-Host "Handover at: $hand"
