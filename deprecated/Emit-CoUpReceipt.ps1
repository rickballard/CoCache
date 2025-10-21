param(
  [Parameter(Mandatory)][string]$Event,
  [hashtable]$Data,
  [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)
$ErrorActionPreference="Stop"
$ts = (Get-Date).ToUniversalTime().ToString("o")
$obj = [pscustomobject]@{ ts=$ts; event=$Event; data=$Data }
$logDir = Join-Path $RepoRoot "status\log"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$log = Join-Path $logDir ((Get-Date -Format "yyyyMMdd") + ".jsonl")
($obj | ConvertTo-Json -Depth 6) | Add-Content -LiteralPath $log -Encoding UTF8
"Wrote: {0}" -f $log
