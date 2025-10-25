param(
  [Parameter(Mandatory)] [string]$Root,
  [Parameter(Mandatory)] [string]$Topic,      # e.g., AI_BEACON_STRATEGY
  [Parameter(Mandatory)] [int]$Version,       # e.g., 1
  [Parameter(Mandatory)] [string]$Owner,      # e.g., "ThisSession"
  [Parameter(Mandatory)] [string]$Intent,
  [string]$Notes = ""
)
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$Inbox = Join-Path $Root 'advice\inbox'
New-Item -ItemType Directory -Force -Path $Inbox | Out-Null

$ts  = (Get-Date).ToString('yyyyMMdd_HHmmss')
$ts2 = (Get-Date).ToString('yyyy-MM-ddTHH-mm-ss')
$topicStem = $Topic
$zipBase   = "{0}_v{1}_{2}" -f $topicStem, $Version, $ts
$zipPath   = Join-Path $Inbox ($zipBase + '.zip')
$expDir    = Join-Path $Inbox $zipBase
New-Item -ItemType Directory -Force -Path $expDir | Out-Null

# Required deliverables
$readme = @"
Title: $Topic
Intent: $Intent
Owner: $Owner
Version: $ts2
Status: iterating
Guardrails:
  MaxSizeKB: 256
  MaxCadenceMins: 30
  MaxChangePct: 20
Change-Notes:
  - $Notes

## Context (session-summarized)
<add concise context here>

## Value / Justifications
<bullet list of expected value and why this is useful>

"@
Set-Content -Encoding utf8 (Join-Path $expDir 'README.md') $readme

$manifest = @"
filename: $($zipBase).zip
version: v$Version
timestamp: $ts
source_session: $Owner
target_session: CoPrime
status: ready-for-ingestion
"@
Set-Content -Encoding utf8 (Join-Path $expDir 'Deliverable_Manifest.md') $manifest

# Copy validator into the bundle for convenience
Copy-Item -Force (Join-Path $Inbox '.CoVerify.ps1') (Join-Path $expDir '.CoVerify.ps1')

# Add a seed payload file
"Seed notes for $Topic v$Version ($ts2)" | Set-Content -Encoding utf8 (Join-Path $expDir "$($topicStem)-v$Version.md")

# Zip + web readability (keep expanded)
if(Test-Path $zipPath){ Remove-Item -Force $zipPath }
[IO.Compression.ZipFile]::CreateFromDirectory($expDir,$zipPath)

Write-Host "AdviceBomb created:"
Write-Host " - $zipPath"
Write-Host " - $expDir (expanded for web viewing)"
