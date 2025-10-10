param(
  [string]$MigrateSessionId = 'co-migrate',
  [string]$PlanningSessionId = 'co-planning',
  [switch]$NotifyPlanning
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$root = Join-Path $HOME 'Downloads\CoTemp'
$now  = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

function Write-Note {
  param([Parameter(Mandatory)][string]$SessionId,
        [Parameter(Mandatory)][string]$Text,
        [string]$FilePrefix = 'NOTE')
  $inbox = Join-Path (Join-Path $root ("sessions\{0}" -f $SessionId)) 'inbox'
  if (-not (Test-Path $inbox)) { New-Item -ItemType Directory -Force -Path $inbox | Out-Null }
  $name = "{0}_{1}.md" -f $FilePrefix,(Get-Date -Format 'yyyyMMdd-HHmmss')
  $path = Join-Path $inbox $name
  Set-Content -LiteralPath $path -Value $Text -Encoding UTF8
  Write-Host ("Dropped -> {0}" -f $path) -ForegroundColor Green
}

$standDown = @"
# Migrate: Stand Down (pre-CoAgent watcher)
Time: $now

This pane is partnered with 'co-planning'. A centralized watcher already runs.
Please **do not** spin up a second inbox watcher or auto-runner here.

Focus areas to continue:
- **ccts fallback** remediation (priority)
- Migration-specific repo tasks

If you need to send a task to Planning, drop a DO into:
$($root)\sessions\co-planning\inbox
"@

Write-Note -SessionId $MigrateSessionId -Text $standDown -FilePrefix 'NOTE_STANDDOWN'

if ($NotifyPlanning) {
  $msg = "# Heads up`n`nAsked **co-migrate** to stand down on duplicate watcher. Continue with **ccts fallback** fixes."
  Write-Note -SessionId $PlanningSessionId -Text $msg -FilePrefix 'NOTE_INFO'
}
