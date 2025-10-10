# 07 – MVP Spec: Multi-Model Orchestration & Consensus (v0.1)

**Pipeline**
1) Router (rules + simple budgeter)
2) Fan-out to K models (vendor adapters)
3) Normalizer → common JSON schema
4) Aggregator (choose per task): majority for structured, judge for freeform
5) Constraint checks (must-pass invariants)
6) Provenance log (prompts, outputs, votes, costs, timings)
7) Policy: redaction + shareable flags for cross-model sharing

**Interfaces**
- Task request schema (inputs, budgets, policy)
- Adapter interface (invoke, return normalized output + cost/meta)
- Aggregator interface (accept peer outputs + rubric, return consensus + confidence)

**MVP Out-of-scope**
- Learned weights, multi-round debates (planned P2)
