# CoAgent × BPOE Advisory Pack

**Purpose:** Tell CoAgent “what to own” and “what to delegate” so BPOE stays our secret sauce while GitHub only enforces minimal, non-sensitive gates.

**Bottom line**
- CoAgent **owns** BPOE: preflight, postflight, heuristics, insights, and any logic that could reveal internal know‑how.
- GitHub Actions (and Branch Protection) **only enforce** presence/shape gates and fail fast — no proprietary logic, no sensitive printing, minimal logs.
- All memory/state is **externalized** (ADR‑0003). Built‑in LLM memory is treated as volatile/untrusted and never the source of truth.

**Pack contents**
- Strategy, scope-of-control, session bookends
- Minimal GH workflow + hook prelude helper
- Privacy/IP guard, telemetry, rollout plan
- API contract for CoAgent to trigger BPOE bookends
- Checklists & templates
