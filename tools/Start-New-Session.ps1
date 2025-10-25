param([switch]$Open)
$ErrorActionPreference='Stop'

$urls = @(
  'https://github.com/rickballard/CoCache/blob/main/docs/intent/SESSION_INDEX.md',
  'https://github.com/rickballard/CoCache/blob/main/docs/intent/SESSION_PLAN_20251025_0150.md',
  'https://github.com/rickballard/CoCache/blob/main/docs/intent/session_handoff_20251025_0132.md',
  'https://github.com/rickballard/CoCache/blob/main/docs/intent/NEXT_SESSION_START.md',
  'https://github.com/rickballard/CoCache/blob/main/docs/intent/COSYNC_GAPS.md',
  'https://raw.githubusercontent.com/rickballard/CoCache/main/docs/dashboards/cosync_validation.csv'
)

"
=== CoSuite Absolute Links (BPOE) ==="
foreach($u in $urls){ Write-Host " - $u" }

if($Open){
  foreach($u in $urls){ try { Start-Process $u } catch {} }
}
