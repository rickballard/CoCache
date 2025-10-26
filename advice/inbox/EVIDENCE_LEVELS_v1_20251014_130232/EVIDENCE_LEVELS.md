# Evidence Levels (E0–E4)

- E0: opinion only → never merge.
- E1: unit tests + local evals → Yellow only in Idea/Proposal.
- E2: reproducible offline evals (fixed seeds, versioned metrics).
- E3: shadow/canary behind flags with SLO guard, OTel SLIs.
- E4: live canary + auto rollback; signed provenance (SLSA/in‑toto + cosign).

Promotion rules: Plan/Initiative require E3+, Extraordinary Evolution requires E4.
