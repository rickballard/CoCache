Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
param(
  [string]$MigrateSessionId = 'co-migrate',
  [string]$PlanningSessionId = 'co-planning',
  [switch]$NotifyPlanning
)

function Write-Note {
  param([Parameter(Mandatory)][string]$SessionId,
        [Parameter(Mandatory)][string]$Text)
  $root = Join-Path $HOME 'Downloads\CoTemp'
  $inbox = Join-Path (Join-Path $root ("sessions\{0}" -f $SessionId)) 'inbox'
  if (-not (Test-Path $inbox)) { New-Item -ItemType Directory -Force -Path $inbox | Out-Null }
  $name = "NOTE_{0}.md" -f (Get-Date -Format 'yyyyMMdd-HHmmss')
  $path = Join-Path $inbox $name
  Set-Content -LiteralPath $path -Value $Text -Encoding UTF8
  Write-Host ("Note -> {0}" -f $path) -ForegroundColor Green
  return $path
}

$ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

$migrateNote = @"
# Stand down: watcher already running

This machine now uses a shared CoTemp two-session setup launched by **CoAgentLauncher**.
It starts one background watcher job per session:

- Planning  (co-planning)
- Migrate   (co-migrate)

What is live:
- Inbox/outbox/logs under: `$HOME\Downloads\CoTemp\sessions\<session-id>
- NOTE_*.md for back-channel messages
- DO_*.ps1 with a header for tasks

Please do **not** install or start another watcher here. Continue with the *ccts fallback* fix.
For a quick status:

  . "`$HOME\Downloads\CoTemp\CoAgentLauncher.ps1"
  Get-CoAgentStatus

-- sent at $ts
"@

$paths = @()
$paths += Write-Note -SessionId $MigrateSessionId -Text $migrateNote

if ($NotifyPlanning) {
  $planningNote = @"
FYI: Migrate (session `$MigrateSessionId) has been marked **stand down** for its local watcher setup.
Please continue coordinating via CoTemp. Primary focus remains the *ccts fallback* fix.

-- sent at $ts
"@
  $paths += Write-Note -SessionId $PlanningSessionId -Text $planningNote
}

$paths
