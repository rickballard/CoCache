param(
  [Parameter(Mandatory)][string]$Event,
  [string]$DataJson,
  [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
  [string]$GlobalRoot = (Join-Path $env:USERPROFILE "Documents\GitHub\CoCacheGlobal")
)
$ErrorActionPreference="Stop"
$ts=(Get-Date).ToUniversalTime().ToString("o")
if(-not (Test-Path $GlobalRoot)){ New-Item -ItemType Directory -Force -Path $GlobalRoot | Out-Null }
$repoName = Split-Path $RepoRoot -Leaf
$bucket   = Join-Path $GlobalRoot $repoName
$logDir   = Join-Path $bucket "status\log"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$data = $null
if($DataJson){ try{ $data = $DataJson | ConvertFrom-Json -Depth 24 } catch { $data = @{ raw=$DataJson } } }
$obj = [pscustomobject]@{ ts=$ts; repo=$repoName; event=$Event; data=$data }
$log = Join-Path $logDir ((Get-Date -Format "yyyyMMdd") + ".jsonl")
($obj | ConvertTo-Json -Depth 24) | Add-Content -LiteralPath $log -Encoding UTF8
"Global receipt: {0}" -f $log
