# RFC-0002 — Multi-Model Orchestration & Consensus (v0.1)

**Status:** Open for comment until 2025-09-09 + 21 days  
**Owner:** CoAgent

## Problem
Single-vendor reliance limits reliability, safety, leverage, and differentiation. CoAgent must orchestrate multiple models,
compare outputs, and reach a policy-driven consensus with auditability.

## Goals
- **Vendor-neutral:** pluggable model adapters; no exclusive dependencies.  
- **Deterministic pipelines:** same input + policy ⇒ reproducible consensus.  
- **Transparent provenance:** per-model prompts, outputs, votes, and weights logged.  
- **Safety-first:** gated cross-sharing; redaction; consistency & constraint checks.

## Architecture (v0.1)
1. **Router** — selects models per task, cost, latency, and domain.
2. **Normalizer** — maps outputs to a common schema (text, JSON, tool results).
3. **Cross-exam** — models critique peers (or self); optional debate rounds _N_.
4. **Aggregators** (selectable):
   - Majority/median vote for structured fields  
   - Self-consistency (K-sampling) with tie-breaks  
   - Judge model (adjudicator) with rubric  
   - Constraint solver (must-pass invariants)  
   - Weighted Mixture-of-Experts (weights learned per domain)
5. **Safety layer** — PII redaction, vendor-sharing policy, disagreement budget, escalation-to-human.
6. **Learner** — bandit-style weight updates using task outcomes.

## Policies
- Default **deny** sharing peer outputs; allow only redacted summaries `shareable: true`.
- Cap debate rounds and token budgets; enforce timeouts & early-exit when confidence ≥ threshold.
- Persist full provenance; never log secrets.

## Evaluation
- **Benchmarks:** structured QA, code fixes, retrieval-augmented tasks.
- **Metrics:** exact-match/grade, robustness under prompt perturbation, cost, latency, disagreement rate.
- **A/B:** single-best-model vs consensus.

## Risks & Mitigations
- **Error correlation:** diversify vendors and sampling.  
- **Leakage across vendors:** redaction + explicit `shareable` flags.  
- **Latency/cost blowup:** router budgets + early-exit consensus.

## Rollout
- **P0:** fan-out + normalizer + majority vote (structured tasks), per-run logs.  
- **P1:** adjudicator + constraint checks.  
- **P2:** debate rounds + learned weights.
