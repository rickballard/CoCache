param([string]$MigrateSessionId = 'co-migrate',[string]$PlanningSessionId = 'co-planning',[switch]$NotifyPlanning)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
function _drop($sid,$name,$text){ $inbox = Join-Path (Join-Path $root ("sessions\{0}" -f $sid)) 'inbox'; $null = New-Item -ItemType Directory -Force -Path $inbox | Out-Null; $p = Join-Path $inbox $name; Set-Content -LiteralPath $p -Value $text -Encoding UTF8; Write-Host ("Dropped -> {0}" -f $p) -ForegroundColor Green }
$ts = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
$body = @"
# Migrate: Stand Down (pre-CoAgent watcher)
Time: $ts

This pane is partnered with 'co-planning'. A centralized watcher already runs.
Please **do not** spin up a second inbox watcher or auto-runner here.

Focus areas to continue:
- **ccts fallback** remediation (priority)
- Migration-specific repo tasks

If you need to send a task to Planning, drop a DO into:
$HOME\Downloads\CoTemp\sessions\co-planning\inbox
"@
_drop $MigrateSessionId ("NOTE_STANDDOWN_{0}.md" -f (Get-Date -Format 'yyyyMMdd-HHmmss')) $body
if ($NotifyPlanning){
  $msg = "Migration has stood down its private watcher. Continuing with ccts fallback + repo tasks."
  _drop $PlanningSessionId ("NOTE_INFO_{0}.md" -f (Get-Date -Format 'yyyyMMdd-HHmmss')) $msg
}
