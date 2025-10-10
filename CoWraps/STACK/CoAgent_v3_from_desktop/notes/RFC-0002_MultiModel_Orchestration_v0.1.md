# RFC-0002 — Multi-Model Orchestration & Consensus v0.1

**Status:** Open for comments (updated 2025-09-09)  
**Problem:** Relying on one model limits reliability and leverage. CoAgent should fan out across models, compare/critique outputs, and produce a policy-constrained consensus with audit trails.

## Goals
- Vendor-neutral adapters; no lock-in.
- Deterministic pipelines where policy + input ⇒ reproducible consensus.
- Transparent provenance (per-model prompts, outputs, votes, weights).
- Safety by design (redaction, sharing policy, constraint checks).

## Architecture
1. **Router**: choose models by task domain, budget, latency.
2. **Normalizer**: map outputs to a common schema (text/JSON/tools).
3. **Cross-exam**: optional peer/self critique rounds N.
4. **Aggregators** (selectable):
   - Majority/median on structured fields
   - Self-consistency (K-sampling) + tie-breaks
   - Judge model with rubric
   - Constraint solver (hard invariants)
   - Weighted MoE (learned per domain)
5. **Safety layer**: PII redaction; shareable flags; disagreement budgets; human escalation.
6. **Learner**: bandit-style weight updates using outcomes.

## Policies
- Default deny peer-output sharing; allow redacted summaries only.
- Cap debate rounds and token/time budgets.
- Persist provenance; never log secrets.

## Evaluation
- Benchmarks: structured QA, code fixes, RAG tasks.
- Metrics: exact match/grade, cost, latency, disagreement rate.
- A/B: single-best-model vs. consensus.

## Risks
- Error correlation across similar models → diversify vendors/sampling.
- Leakage across vendors → redaction + shareable flags.
- Cost/latency blowup → router budgets and early-exit consensus.

## Rollout
- **P0:** fan-out + normalizer + majority vote + logging.
- **P1:** judge model + constraint checks.
- **P2:** debate rounds + learned weights.
