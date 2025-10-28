# CoPatience — “second dots” patience row

A tiny, non-blocking visual heartbeat for long-running steps. It renders a *second* status row of growing dots (one per second by default) while your pipeline streams normal output.

## Quick start
```pwsh
. tools/UX/CoPatience.ps1
$pat = Start-CoPatience -Message "Preparing" -IntervalSec 1 -MaxDots 60
try {
  Start-Sleep 7
} finally {
  Stop-CoPatience -State $pat -DoneMessage "Ready"
}
```
