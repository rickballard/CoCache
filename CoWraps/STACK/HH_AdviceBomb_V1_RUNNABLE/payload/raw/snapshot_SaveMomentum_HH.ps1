Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$hh = Join-Path $HOME 'Documents\GitHub\Godspawn\HH'
$dest = Join-Path $hh '_session_snapshots\handoff_to_CoAgent.txt'
$content = @"
HH session paused.
PayloadRunner working.
Autonomous delivery loop validated.
Waiting on CoAgent product upgrade (MVP2) to resume full HH stitching.
Pseudonym: Azoic
"@

$content | Set-Content -Encoding UTF8 -Path $dest
Write-Host "📌 Snapshot written to: $dest"