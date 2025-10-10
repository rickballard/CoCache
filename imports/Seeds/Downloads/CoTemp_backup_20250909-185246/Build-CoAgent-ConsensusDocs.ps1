param(
  [string]$OutDir = (Join-Path $HOME 'Desktop\CoAgent_BusinessPlan'),
  [switch]$NoZip,
  [switch]$NoClobber
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Write-Doc([string]$Rel,[string]$Text){
  $p = Join-Path $OutDir $Rel
  $dir = Split-Path -Parent $p
  if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  if ($NoClobber -and (Test-Path $p)) { Write-Host "Exists, skipped: $Rel" -ForegroundColor Yellow; return }
  Set-Content -LiteralPath $p -Value $Text -Encoding UTF8
  Write-Host "Wrote: $Rel" -ForegroundColor Green
}

$start = (Get-Date).ToString('yyyy-MM-dd')
$end   = (Get-Date).AddDays(21).ToString('yyyy-MM-dd')

$rfc = @"
# RFC-0002 — Multi-Model Orchestration & Consensus v0.1

Status: Comment Window $start -> $end

## Problem
Single-vendor reliance limits reliability, safety, and leverage. CoAgent must orchestrate multiple models, compare outputs, and reach a policy-driven consensus with auditability.

## Goals
- Vendor-neutral: pluggable adapters, no exclusive dependencies.
- Deterministic pipelines: same input + policy -> reproducible consensus.
- Transparent provenance: per-model prompts, outputs, votes, and weights logged.
- Safety first: gated cross-sharing; redaction; consistency and constraint checks.

## Architecture (v0.1)
1. Router: selects models by task, cost, latency, domain.
2. Normalizer: maps outputs to a common schema (text, JSON, tool results).
3. Cross-exam: models critique peers or self; optional debate rounds N.
4. Aggregators (selectable):
   - Majority/median on structured fields
   - Self-consistency (K-sampling) with tie-breaks
   - Judge model (adjudicator) with rubric
   - Constraint solver (must-pass invariants)
   - Weighted MoE (weights learned per domain)
5. Safety layer: PII redaction, vendor-sharing policy, disagreement budget, escalation-to-human.
6. Learner: bandit-style weight updates using task outcomes.

## Policies
- Default deny sharing peer outputs; allow only redacted summaries tagged shareable:true.
- Cap debate rounds and total tokens per task; enforce timeouts.
- Persist full provenance; never log secrets.

## Evaluation
- Benchmarks: structured QA, code fixes, retrieval-augmented tasks.
- Metrics: exact-match/grade, robustness under prompt perturbation, cost, latency, disagreement rate.
- A/B: single-best-model vs consensus.

## Risks
- Model error correlation: diversify vendors and sampling.
- Leakage across vendors: redaction + shareable flags.
- Latency/cost blowup: router budgets and early-exit consensus.

## Rollout
- P0: fan-out + normalizer + majority vote on structured tasks, per-run logs.
- P1: adjudicator + constraint checks.
- P2: debate rounds + learned weights.

Decision target: $end
"@

$tests = @"
# Consensus Test Plan (P1)

T1 Majority Vote (structured)
- Input: JSON tasks with single correct field.
- Expect: consensus equals ground truth >= target, logs include per-model votes.

T2 Adjudicator
- Competing freeform answers; judge rubric chooses winner; record rationale.

T3 Constraint Check
- Illegal outputs rejected; consensus retries or escalates.

T4 Cost/Latency Budget
- Enforce per-task token/time caps; early exit when consensus confidence >= threshold.

T5 Privacy Guard
- Peer-sharing disabled by default; when enabled, only redacted summaries are visible to peers.

T6 Robustness
- Prompt perturbations; consensus accuracy degrades less than any single model baseline.
"@

$idxAppend = @"
- RFCs/RFC-0002_MultiModel_Orchestration_v0.1.md
- Tests/Consensus_Test_Plan_P1.md
"

Write-Doc 'RFCs\RFC-0002_MultiModel_Orchestration_v0.1.md' $rfc
Write-Doc 'Tests\Consensus_Test_Plan_P1.md' $tests

$idx = Join-Path $OutDir 'DOC_INDEX.md'
if (Test-Path $idx -and -not $NoClobber) {
  Add-Content -LiteralPath $idx -Value $idxAppend -Encoding UTF8
  Write-Host 'Updated: DOC_INDEX.md' -ForegroundColor Green
}

if (-not $NoZip) {
  $zip = Join-Path $HOME 'Downloads\CoAgent_PlanningDocs.zip'
  if (Test-Path $zip) { Remove-Item $zip -Force }
  Compress-Archive -Path (Join-Path $OutDir '*') -DestinationPath $zip -Force
  Write-Host ("Zipped -> {0}" -f $zip) -ForegroundColor Cyan
}

Write-Host ("Done -> {0}" -f $OutDir) -ForegroundColor Cyan
