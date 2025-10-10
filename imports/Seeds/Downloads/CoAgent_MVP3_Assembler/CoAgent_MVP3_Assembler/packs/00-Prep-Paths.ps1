Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$Logs  = Join-Path $ScriptRoot 'logs'
$State = Join-Path $ScriptRoot 'state'
New-Item -ItemType Directory -Force -Path $Logs,$State | Out-Null

"[00-Prep] Logs:  $Logs"
"[00-Prep] State: $State"
