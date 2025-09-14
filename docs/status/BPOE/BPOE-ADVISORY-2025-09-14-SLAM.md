# BPOE Advisory: Session “Bloat” & **SLAM** KPI
_Recorded: 2025-09-14 17:57:25Z_

## Context (observed)
Long‑running work sessions sometimes feel “bloated” (slower responses, rising error rate, muddled state). Leaving a session idle or closed overnight often clears the symptoms. This pattern suggests deterioration is **session‑local and temporary** (state accumulation, tool drift, or resource fragmentation) rather than content‑wide.

## Operable definition of “bloat” (for ops)
> **Bloat**: a session state where **quality and responsiveness degrade** beyond acceptable thresholds _without_ any single failing component. Indicators include rising warnings, parser errors, “command not recognized” burst patterns (pane drift), and stalled watchers.

## KPI: **SLAM** — Session Load & Accumulated Muddle (0–100)
A lightweight, explainable forecast of bloat likelihood. High SLAM ⇒ consider **handoff/rotation**.

Let these normalized inputs be computed over a sliding window (e.g., last 90 minutes) with simple heuristics:
- **D** (duration): hours since session start → `dh = min(1, hours / 6)`
- **H** (heavy ops): repo scans / large zips / corpus builds → `ho = min(1, heavy_ops / 6)`
- **E** (error rate): count of `WARNING`, `ParserError`, `...not recognized...` in last 50 commands → `er = min(1, errors / 10)`
- **F** (fanout): concurrent workflows the session touches (CoAgent, Sites, CoModules, etc.) → `f = min(1, fanout / 4)`
- **P** (pane drift bursts): ≥3 consecutive “not recognized”/pane‑mismatch events → `pd ∈ {0,1}`

**Score**:  
`SLAM = round(100 * (0.35*dh + 0.25*ho + 0.25*er + 0.10*f + 0.05*pd))`

**Bands & actions**
- **0–39 (Green)**: continue; checkpoint every couple of hours.
- **40–69 (Amber)**: **checkpoint now** (bundle/export); consider rotating to a fresh session; keep watchers quiet.
- **70–100 (Red)**: **mandatory handoff**: snapshot, seal the session, spawn successor; schedule a cooldown.

## Decision & guardrails (BPOE)
- Sessions are **temporary robots** (anamorphized sub‑identities). The orchestrator identity remains clean.
- **Never** attempt to “nurse” a Red SLAM session back to health; rotate instead.
- **Do** leave breadcrumbs: update indexes, write handoff notes, push bundles/artifacts.
- **Do** keep watchers quiet (acks only) during Amber/Red; avoid focus‑steal.

## Operational playbook
1. **Detect** SLAM band from simple tallies (no fragile instrumentation required).
2. **Checkpoint**: write bundles (indexes, plan, beacon or corpus dumps as appropriate).
3. **Handoff**: open the successor session (e.g., “Master Plan”); link to the prior session’s bundles and notes.
4. **Cooldown**: let the bloated session idle/close overnight; archive if stable.
5. **Review**: next morning, log a brief BPOE note (what tripped SLAM; what fixed it).

## Instrumentation TODO (lightweight)
- `Measure-SLAM.ps1` to scan PowerShell transcripts / logs for D,H,E,F,P.
- `docs/status/metrics/SLAM.json` written at each checkpoint (timestamp + band + inputs).
- Optional: a **quiet** status badge in `HUMAN-INDEX.md` with the last SLAM band and time.

## Provenance
- Origin: observation that “overnight resets” reduce session bloat.
- Purpose: make **rotation** a normal operational behavior, not a last‑resort.

— _BPOE / Ops_
