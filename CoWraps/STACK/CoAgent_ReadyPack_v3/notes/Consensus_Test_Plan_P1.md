# Consensus Test Plan (P1)

**T1 — Majority Vote (structured)**  
- Input: JSON tasks with a single “correct” field.  
- Expect: consensus equals ground truth ≥ target; logs include per-model votes.

**T2 — Adjudicator**  
- Competing freeform answers; judge rubric chooses winner; record rationale.

**T3 — Constraint Check**  
- Illegal outputs rejected; consensus retries or escalates.

**T4 — Cost/Latency Budget**  
- Enforce per-task token/time caps; early exit when consensus confidence ≥ threshold.

**T5 — Privacy Guard**  
- Peer-sharing disabled by default; when enabled, only redacted summaries are visible to peers.

**T6 — Robustness**  
- Prompt perturbations; consensus accuracy degrades less than any single-model baseline.
