# 08 – Evaluation Framework (P1)

**Bench suites**
- Structured QA (majority vote)
- Freeform answers (judge rubric)
- Constraint cases (reject illegal outputs)

**Metrics**
- Exact-match / graded score
- Cost & latency
- Disagreement rate; escalation %
- Robustness to prompt perturbations

**Runbook**
- Pick 3–5 tasks from target users
- K=3 models; budgets set equal
- Log per-run JSON; compare single-best vs consensus
