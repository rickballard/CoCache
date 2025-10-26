#Requires -Version 7
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
param(
  [string]$TargetRoot = "$HOME\Documents\GitHub\CoCivium",
  [switch]$Apply
)

function Write-Status([string]$msg){
  $line = ("{0:o} {1}" -f (Get-Date), $msg)
  $line | Tee-Object -FilePath "$PSScriptRoot\out.txt" -Append
}

Write-Host "AdviceBomb: Contributors & Digital Halos (v0.1) — Dry-run=$(!$Apply)"
Write-Status "START: DryRun=$(!$Apply); TargetRoot=$TargetRoot"

$relPaths = @(
  "docs/policies/CONTRIBUTORS_POLICY.md",
  "docs/policies/MERITRANK_RUBRIC.md",
  "docs/policies/MAINTAINER_CHECKLIST.md",
  "docs/contributors/example-person.json",
  "docs/halos/example-person.json",
  "tools/seed.csv"
)

$srcRoot = Join-Path $PSScriptRoot "payload"
foreach($rel in $relPaths){
  $src = Join-Path $srcRoot $rel
  $dst = Join-Path $TargetRoot $rel
  if(-not (Test-Path $src)){ throw "Missing payload file: $rel" }

  if($Apply){
    New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
    Copy-Item -Force $src $dst
    Write-Status "WRITE: $rel -> $dst"
  } else {
    Write-Status "PLAN: would write $rel -> $dst"
  }
}

# Friendly reminders
$reminders = @(
  "Merge to main promptly after validation to keep assets visible.",
  "Record consent before publishing any halos beyond public facts.",
  "Log reviewers and COI scoring; store score breakdowns with profiles."
)
$reminders | ForEach-Object { Write-Status "NOTE: $_" }

Write-Status "DONE"
Write-Host "Completed. See out.txt for the status log."
