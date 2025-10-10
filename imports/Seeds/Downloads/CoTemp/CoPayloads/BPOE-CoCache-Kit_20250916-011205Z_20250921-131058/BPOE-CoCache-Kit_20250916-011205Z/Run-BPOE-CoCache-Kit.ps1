Param(
  [string]$CoCache = "C:\Users\Chris\Documents\GitHub\CoCache",
  [string]$Owner   = "rickballard",
  [switch]$SkipPR
)
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$PSStyle.OutputRendering = 'PlainText'

# Resolve main script next to this wrapper
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Main = Join-Path $Here "BPOE-CoCache-Kit.ps1"

Write-Host "== Running BPOE-CoCache-Kit ==" -ForegroundColor Cyan
& pwsh -NoProfile -ExecutionPolicy Bypass -File $Main -CoCache $CoCache -Owner $Owner @(
  if($SkipPR) { "-SkipPR" } else { $null }
) | Write-Host
