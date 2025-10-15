---
title: "Political–Economic Regimes & Falsifiers — Insights Pair"
version: "0.1.0"
created_utc: "2025-10-14T23:25:31.098116Z"
license: "CC-BY-4.0"
tags: [insights, political-economy, regimes, falsifiers, governance, metrics, CoSuite]
gibberlink_concept: "REGIME.FALSIFIER.FRAME"
gibberlink_aliases: [EPOCH.SCORECARD, PCTM.FRAME]
cosuite_module: "Insights"
pair_id: "epochs-and-regimes"
pair_role: "pragmatics"
human_gate: true
review_cadence: "Quarterly metrics; Annual composite scoring"
---

> CoSuite header: This file follows the Insights pair format (Theory + Pragmatics).     Edits that change scoring rules require **HumanGate** review and a version bump.

# Paper B — PRAGMATICS / OPERATIONAL PLAYBOOK
**Objective:** Score historical regimes consistently and **predict** CoCivium’s success/failure early.

## B1. Criteria, Metrics, and Falsifiers
We track each dimension with Lagging Outcomes, Leading Indicators, Stress Tests, and a hard **Falsifier** line.

**1) Efficiency/Productivity**
- Lagging: TFP growth; business investment/GDP; startup formation.
- Leading: time‑to‑integrate new protocol (days); API adoption half‑life; transaction latency.
- Stress: throughput at P95; fail‑forward recovery.
- **Falsifier:** 3‑year TFP avg ≤ pre‑epoch baseline **and** leading indicators flat/declining.

**2) Equity/Distribution**
- Lagging: Gini; top‑1% shares; mobility index.
- Leading: contribution→influence parity index; fee compression vs platform baselines; retention by income decile.
- Stress: targeted low‑income pilots.
- **Falsifier:** top decile locks >80% decisions with <30% verified contribution for 4 consecutive quarters.

**3) Resilience/Fragility**
- Lagging: crisis frequency/severity; recovery half‑life.
- Leading: supplier HHI; single‑maintainer dependency; chaos‑test pass rate.
- Stress: failover drills; supply reroutes; red‑team capture attempts.
- **Falsifier:** any single‑point failure causes >72h critical outage or irreversible data loss.

**4) Innovation/Diffusion**
- Lagging: time proto→50% adoption; code reuse; cost/feature.
- Leading: PR velocity; interop test passes; independent re‑implementations.
- Stress: plug‑compatible swaps.
- **Falsifier:** diffusion half‑life worsens two cycles in a row while costs rise.

**5) Legitimacy/Consent**
- Lagging: participation trend; dispute resolution time; churn.
- Leading: audit transparency score; explainability conformance; grievance SLA.
- Stress: governance‑load spikes; contested decisions.
- **Falsifier:** participation falls >50% YoY without compensating automation; grievances >30 days unresolved.

**6) Sustainability/Externalities**
- Lagging: emissions path vs target; footprint per service unit.
- Leading: learning rate in green stacks; recycled content share; energy/txn.
- Stress: carbon‑price sensitivity; scarcity drills.
- **Falsifier:** cost/ton abated >150% of comparable benchmarks for 8 quarters.

**7) Capture‑Resistance/Contestability**
- Lagging: provider HHI; turnover in seats; antitrust actions.
- Leading: fork rate; exit cost; independent validators; standards‑body diversity.
- Stress: coordinated capture simulations; token/role audits.
- **Falsifier:** inability to fork/exit in ≤30 days with full identity/data portability.

## B2. Composite Scoring (0–5)
0 catastrophic, 1 persistent fail, 2 partial under‑performance, 3 acceptable, 4 strong, 5 frontier.
- **Future‑proof rule:** Resilience ≥4 **and** no score <3 across dimensions for five consecutive annual reviews.

## B3. Review Cadence & Artefacts
- Quarterly: leading indicators, stress‑tests, audits → `/insights/epochs-and-regimes/scorecards/YYYYQ#.csv`
- Annual: lagging outcomes; composite score; narrative post‑mortem.

## B4. CoCivium Predictive Protocol
- Pre‑register hypotheses (see `cocivium_hypotheses.csv`).
- **Kill‑switches:** auto de‑promote failing modules; throttle budgets.
- **Decision gates:** move‑to‑scale only if Resilience≥4 and Capture‑Resistance≥4 proven twice in distinct demographics.
- Early‑warning dashboard: HHI↑, exit‑cost↑, participation↓, audit‑backlog↑ → Yellow; two Yellows → Red review.

## B5. Implementation Checklist
- Data plumbing: telemetry schema for all 7 dimensions; privacy guardrails.
- Governance: audit calendar; external reviewer rotation.
- Comparators: two baselines per use‑case (closed platform and traditional public service).
- Publishing: open scorecards + plain‑language summaries.


---
### CoSuite Footer

- **Provenance:** Generated collaboratively by GPT‑5 Thinking with Rick (Steward).
- **License:** CC‑BY‑4.0. Please attribute “CoCivium / InSeed”.
- **Change Policy:** Backwards‑incompatible changes require a major version bump.
- **Safeguards:** Run stress‑tests before scaling. See `pragmatics.md` §B5 for kill‑switches.
- **Contact:** Open a discussion in the CoSuite repos with tag `insights-epochs-regimes`.
