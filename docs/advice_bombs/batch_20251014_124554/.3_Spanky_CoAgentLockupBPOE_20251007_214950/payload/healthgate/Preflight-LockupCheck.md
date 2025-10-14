# HealthGate: Preflight Lockup Check
Run before initializing CoAgent orchestration.

## Checks
- **Browser compatibility:** feature flags present; extensions permissive.
- **Resource budget:** available RAM/CPU within safe baseline.
- **Network/LLM health:** quick ping + token test-call to provider.
- **Sidecar readiness:** CoCache writable; quota not exceeded.

## Action
- If any check fails, block start and present targeted remediation.
