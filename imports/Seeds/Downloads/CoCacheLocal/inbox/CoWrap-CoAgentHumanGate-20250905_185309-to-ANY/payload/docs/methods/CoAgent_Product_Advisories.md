# CoAgent — Product Advisories (BPOE-aligned)

## Defaults & safety
- **HumanGate**: ENTER=DO enabled by default (user-scoped). Multi-line DO only.
- **Red is sacred**: never recolor errors; CoTint uses green/yellow/cyan for guidance.
- **No background timers**: status is prompt-driven; Preflight flags OE timers.

## Anti-bloat discipline
- Prefer **repo scripts/modules** over long chat blocks; keep DO blocks short.
- Use **CoCache** for large outputs between steps.
- **No here-strings** in DO: use line arrays + `-join`.

## Preflight & tests
- `tools/Test-BPOE.ps1` runs quiet checks; logs only on problems.
- Pester suites cover HumanGate, heartbeat, and CoPong.

## Anti-monitoring guard (planned)
- Enumerate non-allowlisted event subscribers/jobs and untrusted modules; log to BPOE_LOG with remediation.