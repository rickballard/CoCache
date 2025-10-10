# CoAgent — BPOE (Best Practices & Operational Excellence)

## Principles
- Ship small, observable changes; everything has a probe.
- Protect users (guardrails), protect `main` (branch modes), protect time (scripts).

## Working agreements
- PRs only; linear history.
- Every docs/UI change must pass MVP Smoke (`tools/Test-MVP.ps1`).
- `status.json` is generated (Status Bot).

## Metrics (local only)
- JSONL logs for smoke runs: `tools/Log-Run.ps1`
- Analyze: `tools/Analyze-BPOE.ps1`
