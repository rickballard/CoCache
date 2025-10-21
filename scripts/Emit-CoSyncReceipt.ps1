param(
  [Parameter(Mandatory)][string]$Event,
  [string]$DataJson,
  [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)
$ErrorActionPreference="Stop"
$ts   = (Get-Date).ToUniversalTime().ToString("o")
$data = $null
if($DataJson){ try{ $data = $DataJson | ConvertFrom-Json -Depth 10 } catch { $data = @{ raw = $DataJson } } }
$obj  = [pscustomobject]@{ ts=$ts; event=$Event; data=$data }
$logDir = Join-Path $RepoRoot "status\log"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$log = Join-Path $logDir ((Get-Date -Format "yyyyMMdd") + ".jsonl")
($obj | ConvertTo-Json -Depth 10) | Add-Content -LiteralPath $log -Encoding UTF8
"Wrote: {0}" -f $log
