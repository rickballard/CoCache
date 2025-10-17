# Requires: PowerShell 7+
# Usage examples:
#   pwsh ./Deploy-CoAgentBranding.ps1 -TargetRepo "C:\Users\Chris\Documents\GitHub\CoSteward" -Subdir "brand\coagent"
#   pwsh ./Deploy-CoAgentBranding.ps1 -TargetRepo "C:\Users\Chris\Documents\GitHub\CoAgent"   -Subdir "brand"

param(
  [Parameter(Mandatory=$true)]
  [string]$TargetRepo,
  [string]$Subdir = "brand\coagent",
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function New-TargetDir {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcBrand   = Join-Path $here "brand"
$srcStories = Join-Path $here "stories"
$srcDocs    = Join-Path $here "docs"

$destBase = Join-Path $TargetRepo $Subdir
$destBrand   = Join-Path $destBase "brand"
$destStories = Join-Path $destBase "stories"
$destDocs    = Join-Path $destBase "docs"

Write-Host "Staging to: $destBase"
if (-not $DryRun) { New-TargetDir -Path $destBrand; New-TargetDir -Path $destStories; New-TargetDir -Path $destDocs }

$copyMap = @{
  ($srcBrand)   = $destBrand
  ($srcStories) = $destStories
  ($srcDocs)    = $destDocs
}

foreach ($kv in $copyMap.GetEnumerator()) {
  $src = $kv.Key; $dst = $kv.Value
  Write-Host "Copying from $src to $dst"
  if (-not $DryRun) { Copy-Item -Path (Join-Path $src "*") -Destination $dst -Recurse -Force }
}

Write-Host "Done. Consider committing with a message like: 'Add CoAgent branding/messaging package (v1.1)'"
