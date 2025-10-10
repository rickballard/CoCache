param(
  [string]$Agent = "U",
  [Parameter(Mandatory)][string]$Type,
  [Parameter(Mandatory)][string]$Msg,
  $Data
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path ($env:COCACHE_LOCAL ?? (Join-Path $HOME 'Downloads/CoCacheLocal')) 'sessions'
$base = Join-Path $root $env:COSESSION_ID
$log  = Join-Path $base 'log.ndjson'
New-Item -Type Directory -Force -Path $base | Out-Null
$evt = [ordered]@{
  ts         = (Get-Date).ToUniversalTime().ToString('o')
  session_id = $env:COSESSION_ID
  agent      = $Agent
  user       = $env:UserName
  host       = $env:COMPUTERNAME
  repo       = (Get-Location).Path
  branch     = (git rev-parse --abbrev-ref HEAD 2>$null)
  type       = $Type
  msg        = $Msg
  data       = $Data
}
$evt | ConvertTo-Json -Depth 6 | Add-Content -Encoding UTF8NoBOM $log
