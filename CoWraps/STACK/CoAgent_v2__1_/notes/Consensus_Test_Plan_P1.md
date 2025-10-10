# Consensus Test Plan — P1

## T1 Majority Vote (structured)
**Given** JSON tasks with a single correct field  
**Expect** consensus equals ground truth ≥ target; logs include per-model votes

## T2 Judge Model
Competing freeform answers; rubric-based adjudication; record rationale

## T3 Constraint Checks
Illegal outputs rejected; consensus retries or escalates

## T4 Budget Guardrails
Enforce per-task token & time caps; early exit on high confidence

## T5 Privacy Guard
Peer-sharing disabled by default; if enabled, only redacted summaries

## T6 Robustness
Prompt perturbations; consensus degrades less than best single model
