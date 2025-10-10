Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null

$policy = @"
# Watcher policy — centralized (pre‑CoAgent)
Status: $(Get-Date -Format o)

We enforce **one watcher per session**:
- co-planning  → CoQueueWatcher-co-planning
- co-migrate   → CoQueueWatcher-co-migrate

Please do **not** start additional watchers.
Coordinate via:
- Drop-CoDO  (runnable tasks)
- Send-CoNote (human notes)

Migrate focus: **ccts fallback** remediation continues.
"@

$inPlan = Join-Path $root 'sessions\co-planning\inbox'
$inMig  = Join-Path $root 'sessions\co-migrate\inbox'
$null = New-Item -ItemType Directory -Force -Path $inPlan,$inMig | Out-Null
$fn = "NOTE_WATCHER_POLICY_{0}.md" -f (Get-Date -Format 'yyyyMMdd-HHmmss')
Set-Content -LiteralPath (Join-Path $inPlan $fn) -Value $policy -Encoding UTF8
Set-Content -LiteralPath (Join-Path $inMig  $fn) -Value $policy -Encoding UTF8

Send-CoNote -ToSessionId 'co-planning' -Text "Planning: central watcher active. Coordinate via Drop-CoDO/Send-CoNote."
Send-CoNote -ToSessionId 'co-migrate'  -Text "Migrate: central watcher active; keep **ccts fallback** rolling."
