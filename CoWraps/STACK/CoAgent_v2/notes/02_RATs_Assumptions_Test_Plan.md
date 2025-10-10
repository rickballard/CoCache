# RATs — Riskiest Assumptions Test Plan

## A1: Consensus beats single-best model
*Test:* Structured QA and code-fix tasks; compare EM/grade and error bands  
*Metric:* +X% accuracy at ≤ Y% cost delta

## A2: Cost/Latency acceptable with budgets
*Test:* Sweep tasks under token and time caps; track early exits  
*Metric:* 95p latency ≤ target; cost within budget

## A3: Safe cross-model sharing
*Test:* Redaction + shareable flags; inspect for leakage incidents  
*Metric:* 0 PII leak events in N trials

## A4: Usability of two-pane workflow
*Test:* Planning/Migrate demo; measure task throughput and user error rate  
*Metric:* Onboarding ≤ 15 min; < 1 blocking error per day
