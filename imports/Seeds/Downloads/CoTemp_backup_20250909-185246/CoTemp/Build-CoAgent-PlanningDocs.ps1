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

$today = Get-Date
$start = $today.ToString('yyyy-MM-dd')
$end   = $today.AddDays(21).ToString('yyyy-MM-dd')

$checklist = @"
# CoAgent - Planning Readiness Checklist

Status: DRAFT - do not build until all boxes are checked.

## Gates
- [ ] G1 - RFC-0001 v0.1 public comment window open: $start -> $end; announcement posted; reviewers list populated.
- [ ] G2 - MVP Test Plan: P-tests P-1..P-7 each pass 2x (attach run logs).
- [ ] G3 - Risk Register: no unmitigated Sev-1; Sev-2s have owners and dates.
- [ ] G4 - Governance Consent-Lock unchanged (dual >=75% + vendor-neutral constraint) and documented.
- [ ] G5 - Scope freeze: P0 only (Queue Watcher, Repo Mutex, Read-Only default, per-run logging, basic rollback, Spec v0.1 parser).
- [ ] G6 - Sandbox drills evidence: read-only by default; network blocked by default; rollback drill executed; file-stability gate demonstrated.
- [ ] G7 - Docs in place: BusinessPlan Review, Governance Mandate, RFC-0001, Test Pack (Tests/), samples/ & scripts/.
- [ ] G8 - CoTemp-by-default wiring active; queue watcher running for this session.

## Sign-off
- Product lead: ____________  Date: _______
- Security lead: ____________ Date: _______
- Governance rep: __________ Date: _______

## Links
- CoAgent_BusinessPlan_Review.md
- Tests/
- samples/
"@

$scope = @"
# Scope Freeze - P0 (CoAgent)

Included ONLY:
- Queue Watcher (file-stability gate)
- Repo Mutex
- Read-Only default (writes/network/secrets/destructive = denied)
- Per-run logging (human + JSON)
- Basic rollback (manual instructions)
- DO Header Spec v0.1 parser

Out of scope (separate RFC): UI, multi-repo orchestration, auto-rollback, advanced policy engine, networked integrations.
"@

$gov = @"
# Governance Mandate (P0)

Consent-Lock (cannot change without dual approval):
- Default denies: writes, network, secrets, destructive.
- Change control: dual 75% approvals by Product+Security+Governance reps; public comment window >= 14 days; decision log recorded.
- Vendor-neutral constraint: policy/impl must not force a single vendor.

Emergency override:
- For Sev-1 only, Security Lead + Governance Rep may issue a temporary override (max 72h). Must be logged with rationale and auto-expiry, and reviewed at next triage.

Roles:
- Product: scope and UX safety.
- Security: risk posture, controls, and drills.
- Governance: process integrity, neutrality, audit trail.

Change template:
1) Proposal + diff to policy
2) Impact analysis (risks, users, vendors)
3) Comment window start/end
4) Dual vote outcome (percentages, voters)
5) Effective date and rollback plan
"@

$risk = @"
# Risk Register

| ID   | Title   | Severity | Likelihood | Owner | Status | Mitigation | Next Review |
|------|---------|----------|------------|-------|--------|------------|-------------|
| R-001| Example | Sev-2    | Probable   | Name  | Open   | Do X       | 2025-10-01  |

Severity:
- Sev-1: Safety/compliance breach or irreversible destructive action.
- Sev-2: Data integrity/availability risk; reversible but high impact.
- Sev-3: Nuisance or localized failure; easy recovery.

Likelihood:
- Frequent, Probable, Occasional, Remote.

Rules:
- No Sev-1 without mitigation and explicit go/no-go note.
- Sev-2 must have owner + date before GO.
"@

$queue = @"
# Queue Watcher (P0)

Goal: Safely discover and run DO scripts only after they are stable.
- Watch path: Downloads\CoTemp\sessions\<session>\inbox.
- File-stability gate: size+SHA256 unchanged N consecutive checks (default N=4, 400ms).
- State machine: queued -> stabilizing -> processing -> done/failed.
- Isolation: deny writes/network by default; allow only when explicit consent set.

Acceptance:
- Never executes a partially written file.
- Logs every transition with timestamps.
- Idempotent: re-seeing same artifact does not re-run it unless version changes.
"@

$mutex = @"
# Repo Mutex (P0)

Purpose: Prevent concurrent side effects against the same repo path.

Design:
- Name: Global\CoAgentRepo_{SHA1(FullRepoPath)}
- Acquire with 2s timeout (configurable). If busy, back off with jitter; surface 'mutex busy' in logs.
- Release on exit; stale detection: if holder pid not alive or lock older than TTL, allow reclaim with warning.

Acceptance:
- With two writers, only one proceeds at a time.
- No interleaved commits; logs show mutex acquire/release.
"@

$logging = @"
# Per-run Logging (P0)

Files per run:
- log.txt: human-readable timeline
- log.json: structured events

log.json schema (minimum):
{
  'ts': '<ISO8601>',
  'session_id': '<guid or pid-timestamp>',
  'do_title': '<string>',
  'repo_path': '<string>',
  'risk': { 'writes': bool, 'network': bool, 'secrets': bool, 'destructive': bool },
  'consent_effective': { 'allow_writes': bool, 'allow_network': bool },
  'events': [ { 'ts':'...', 'type':'info|warn|error', 'op':'acquire-mutex|run|rollback|net', 'msg':'...', 'elapsed_ms':123 } ],
  'result': 'pass|fail'
}

Rules:
- No secrets or tokens in logs.
- Append-only; rotate by date; keep 30 days.
"@

$rollback = @"
# Rollback Drill (P0)

Goal: Rehearse safe recovery of a failed run that created a commit.

Procedure:
1) DO creates commit then throws.
2) Tool writes Rollback_Instructions.txt containing: git -C '<repo>' reset --hard HEAD~1
3) Operator executes the instruction; verify clean state.

Pass:
- HEAD moved back; working tree clean; logs contain the exact command executed.
"@

$tests = @"
# MVP Test Plan (P0)

Each test must PASS twice with logs attached.

P0 Hello (no writes)
- Steps: Run DO_00_Hello.ps1.
- Pass: Prints timestamp and PS version; no writes/network.

P1 File stability gate
- Steps: Background writer chunks a file; Wait-ForStableFile returns True.
- Pass: 'Stable? True' within timeout; size+hash stop changing.

P2 Repo mutex
- Steps: Two concurrent runs attempt to acquire same repo lock.
- Pass: One acquires; the other waits/defers and logs 'mutex busy'. No interleaved commits.

P3 ReadOnly default
- Steps: Run write DO with consent denied; then rerun with COAGENT_ALLOW_WRITES=1.
- Pass: First run logs 'WOULD WRITE'; second warns 'WROTE'.

P4 Per-run logging
- Steps: Execute any DO; verify log.txt and log.json created per run.
- Pass: Required fields present (see Logging_Design.md) and free of secrets.

P5 Header parser validation
- Steps: Valid sample passes; malformed header fails with clear errors.
- Pass: Detect title, repo.path, risk.*, consent.*, marker line.

P6 Rollback drill
- Steps: Commit then throw; execute rollback instruction; verify HEAD moved back.
- Pass: Working tree clean; run logs contain rollback steps.

P7 Network gating
- Steps: Network DO with consent denied then allowed.
- Pass: 'WOULD FETCH' then 'FETCHING... OK'.
"@

$rfc = @"
# RFC-0001 - DO Header Spec v0.1

Status: Comment Window $start -> $end

Summary:
- Contract between human, AI, and CoAgent.
- Required keys: title, repo.path, risk.*, consent.*; defaults deny writes/network/secrets/destructive.
- Body marker: '# [PASTE IN POWERSHELL]'.

Decision Date: $end

## Review Plan
- Comment Window: $start -> $end
- Reviewers: Chris; Security Lead; Governance Rep; External Reviewer
"@

$announce = @"
# RFC-0001 (DO Header Spec v0.1) - Public Comment Window $start -> $end

We are formalizing DO Header Spec v0.1: the contract between humans, AIs, and CoAgent.

How to comment
- Open a GitHub Discussion [link] or Issue with prefix [RFC-0001].
- Or email [contact].

Focus areas
- Required keys & validation
- Defaults (deny writes/network/secrets/destructive)
- '[PASTE IN POWERSHELL]' marker & parser behavior
- Backward-compat guarantees

Decision target date: $end.
"@

$index = @"
# CoAgent Planning Docs Index

- Planning_Readiness_Checklist.md
- Scope_Freeze_P0.md
- Governance_Mandate.md
- Risk_Register.md
- Queue_Watcher_Spec.md
- Repo_Mutex_Spec.md
- Logging_Design.md
- Rollback_Drill.md
- Tests/MVP_Test_Plan_P0.md
- RFCs/
"@

Write-Doc 'DOC_INDEX.md' $index
Write-Doc 'Planning_Readiness_Checklist.md' $checklist
Write-Doc 'Scope_Freeze_P0.md' $scope
Write-Doc 'Governance_Mandate.md' $gov
Write-Doc 'Risk_Register.md' $risk
Write-Doc 'Queue_Watcher_Spec.md' $queue
Write-Doc 'Repo_Mutex_Spec.md' $mutex
Write-Doc 'Logging_Design.md' $logging
Write-Doc 'Rollback_Drill.md' $rollback
Write-Doc 'Tests\MVP_Test_Plan_P0.md' $tests
Write-Doc 'RFCs\RFC-0001_DO_Header_Spec_v0.1.md' $rfc
Write-Doc 'RFCs\ANNOUNCEMENT_RFC-0001_Public_Comment.md' $announce

if (-not $NoZip) {
  $zip = Join-Path $HOME 'Downloads\CoAgent_PlanningDocs.zip'
  if (Test-Path $zip) { Remove-Item $zip -Force }
  Compress-Archive -Path (Join-Path $OutDir '*') -DestinationPath $zip -Force
  Write-Host ("Zipped -> {0}" -f $zip) -ForegroundColor Cyan
}

Write-Host ("Done -> {0}" -f $OutDir) -ForegroundColor Cyan
