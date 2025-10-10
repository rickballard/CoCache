# BPOE · Notes & Measures (MVP)
We snapshot per-event JSONL logs (opt-in) under `.coagent/logs/*.jsonl` with:
- `ts`, `route`, `latency_ms`, `satisfaction`, `notes`
- route ∈ { normal, guardrails_redirect, tool_success, tool_error }

`tools/Analyze-BPOE.ps1` reduces to:
- count, median latency, avg satisfaction, route histogram.
