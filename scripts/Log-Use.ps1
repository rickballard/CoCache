param([Parameter(Mandatory)][string]$Asset,[string]$Consumer="unknown",[string]$Purpose="use",[string]$RepoRoot=(Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference="Stop"; $ts=(Get-Date).ToUniversalTime().ToString("o")
$obj=[pscustomobject]@{ ts=$ts; event="use"; asset=$Asset; consumer=$Consumer; purpose=$Purpose }
$logDir=Join-Path $RepoRoot "status\log"; New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$log=Join-Path $logDir ((Get-Date -Format "yyyyMMdd") + ".jsonl")
($obj | ConvertTo-Json -Depth 6) | Add-Content -LiteralPath $log -Encoding UTF8
"use logged: {0} ← {1} ({2})" -f $Asset,$Consumer,$Purpose
