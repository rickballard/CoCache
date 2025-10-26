# Guardrails: Session Hygiene
**Problem:** Parallel sessions, heavy sidecar logging, and memory overlays increase lock-up risk.

## Rules
- Warn at N≥6 concurrent active CoAgent sessions; recommend CoWrap/close.
- Auto-suggest CoWrap when a session is idle ≥ 48h.
- JS-side memory monitor: if tab heap > threshold, show "Lighten Load" banner.
- Rate-limit sidecar writes and defer non-critical logging under load.
- One-click "Safe Mode" (no extensions, minimal UI, reduced watchers).

## Telemetry
- Count of active sessions
- Heap/CPU hints (best-effort, privacy-preserving)
- Sidecar write cadence

