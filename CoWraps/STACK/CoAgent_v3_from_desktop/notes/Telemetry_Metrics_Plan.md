# Minimal Telemetry/Metrics Plan (local only)

- Counters: DO queued, DO pass/fail, header reject, notes sent
- Emit JSON lines per event into session `logs/*.json`
- Summarize with `Status-QuickCheck.ps1 -Compact`
