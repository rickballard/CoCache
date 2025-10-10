# CoAgent — TRAINING (Guided walkthrough)

## Goal
Experience CoAgent MVP as a brand‑new user and verify end‑to‑end.

### Part 1: Orientation (5 min)
- Open `/` → click **UI Mock** → browse quadrants (Model, Guardrails, Status, Logs).
- Open `/status.html` → confirm it loads `status.json`.

### Part 2: Smoke test (2 min)
```pwsh
pwsh -File tools\Test-MVP.ps1
```

Expected: **4/4 OK** + **Guardrail CI** trigger.

### Part 3: Status update (3 min)
- Edit `docs/status.json` (or use Status Bot later).
- Create a PR → Merge → verify `/status.html` updates.

### Part 4: Guardrails (5 min)
- Read `.coagent/guardrails/*`.
- Review workflow `.github/workflows/guardrail-smoke.yml`.

### Part 5: What “good” looks like
- Green CI checks, fresh `status.json`, Pages 200s, guardrail smoke green.
