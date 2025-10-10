param(
  [string]$Repo = 'rickballard/MeritRank',     # owner/repo
  [string]$MilestoneTitle = 'CoEve v1 MVP'
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# --- Labels (idempotent)
function Ensure-Label($name,$color,$desc){
  try { gh label create $name --color $color --description $desc --repo $Repo 2>$null }
  catch { gh label edit   $name --color $color --description $desc --repo $Repo 2>$null }
}
$labels = @(
  @{'n'='coeve';'c'='5319e7';'d'='CoEve identity & credibility registry'},
  @{'n'='spec';'c'='0366d6';'d'='Specification work'},
  @{'n'='runbook';'c'='0e8a16';'d'='Operational runbooks'},
  @{'n'='governance';'c'='1d76db';'d'='Stewardship / council / policy'},
  @{'n'='seeder';'c'='0052cc';'d'='Crawler/ingestion pipeline'},
  @{'n'='security';'c'='d93f0b';'d'='Threats, hardening, audits'},
  @{'n'='interop';'c'='fbca04';'d'='Standards, protocols, external ID'},
  @{'n'='MVP';'c'='c2e0c6';'d'='Phase 1 – MVP scope'},
  @{'n'='Phase-2';'c'='bfdadc';'d'='Phase 2 – scale & interop'},
  @{'n'='blocked';'c'='000000';'d'='Blocked or external dependency'}
)
$labels | ForEach-Object { Ensure-Label $_.n $_.c $_.d }

# --- Milestone ensure via REST (works even if gh lacks 'milestone' cmd)
if (-not ($Repo -match '^(?<owner>[^/]+)/(?<name>[^/]+)$')) { throw "Repo must be 'owner/name'." }
$Owner = $Matches['owner']; $Name = $Matches['name']
$ms = gh api -H "Accept: application/vnd.github+json" "repos/$Owner/$Name/milestones?state=all&per_page=100" | ConvertFrom-Json | Where-Object { $_.title -eq $MilestoneTitle } | Select-Object -First 1
if (-not $ms) {
  $ms = gh api -X POST -H "Accept: application/vnd.github+json" "repos/$Owner/$Name/milestones" -f "title=$MilestoneTitle" -f "description=Phase 1 delivery for CoEve identity & credibility registry" | ConvertFrom-Json
}

# --- Issues (idempotent, assign milestone by TITLE)
$prefix = @"
Refs:
- docs/advice-bombs/CoEve_Identities_Registry_Proposal_v1.md
- docs/specs/{identity-model,scoring-model,transparency-log}.md
- docs/runbooks/abuse-response.md
- docs/governance/charter.md
- notes/design/seeder-pipeline.md
"@

$defs = @(
  @{t="Ratify event taxonomy + negative-dominance constants"; l="coeve,spec,MVP"; b="Finalize verbs/severity classes; publish constants table and examples.`n`n$prefix"},
  @{t="Select initial DID methods + AvatarCode v1";          l="coeve,spec,interop,MVP"; b="Pick did:key + did:web (v1); rotation policy; AvatarCode derivation from pubkey.`n`n$prefix"},
  @{t="Transparency log MVP + anchoring cadence";            l="coeve,spec,security,MVP"; b="CT-like Merkle log; weekly anchoring (OpenTimestamps/EVM L2); audit procedure.`n`n$prefix"},
  @{t="Registry core + WebAuthn sign-in (pseudonymous T0)";  l="coeve,MVP"; b="IDs/events/score explainer v1; WebAuthn RP; minimal admin console.`n`n$prefix"},
  @{t="ScriptTag + RepTag minimal integration";              l="coeve,interop,MVP"; b="Ingest signatures; show contributions/endorsements in score explainer.`n`n$prefix"},
  @{t="Seeder v0: allow-lists, confidence metrics, HITL review"; l="coeve,seeder,MVP"; b="Crawler prototype respecting robots.txt; ER with confidence; review queue.`n`n$prefix"},
  @{t="Governance charter v1 + Steward Council onboarding";  l="coeve,governance,MVP"; b="Quorum, policy keys (multisig), emergency powers; onboard CoEve.`n`n$prefix"},
  @{t="Abuse response: severity matrix + MTTQ targets";      l="coeve,runbook,security,MVP"; b="Complete runbook with triggers, SLAs, escalation, appeals.`n`n$prefix"},
  @{t="Scoring math: constants, decay, Wilson/Bayesian details"; l="coeve,spec,MVP"; b="Fill formulas, examples, tests; explainer samples.`n`n$prefix"},
  @{t="Privacy/PII vault + crypto-erasure design";           l="coeve,security,MVP"; b="Field-level encryption; key lifecycle; erasure semantics; selective disclosure.`n`n$prefix"},
  @{t="Threat model + anomaly detection plan";               l="coeve,security,MVP"; b="Enumerate Sybil/goodwashing/collusion vectors; features; FPR/FNR/MTTQ.`n`n$prefix"},
  @{t="Chain selection & cost model for anchoring";          l="coeve,spec,security,MVP"; b="Choose anchoring strategy; estimate monthly costs at volume.`n`n$prefix"},
  @{t="Policy packs: GDPR/PIPEDA/CCPA + AML/KYC options";    l="coeve,governance,security,MVP"; b="Jurisdiction toggles; processing notices; dispute templates.`n`n$prefix"},
  @{t="Onboard CoEve identity + transparency commitments";   l="coeve,governance,MVP"; b="Create CoEve DID; sign governance artifacts; publish sunlight rules.`n`n$prefix"},
  @{t="Public roadmap + security disclosure policy";         l="coeve,security,MVP"; b="Ship SECURITY.md and ROADMAP.md; contact, PGP key, bounty intent.`n`n$prefix"}
)

foreach ($d in $defs) {
  $found = gh issue list --repo $Repo --state all --json number,title,milestone --search "`"$($d.t)`" in:title" | ConvertFrom-Json | Where-Object {$_.title -eq $($d.t)} | Select-Object -First 1
  if (-not $found) {
    gh issue create --repo $Repo --title $d.t --body $d.b --label $d.l --milestone "$MilestoneTitle" | Out-Null
  } elseif (-not $found.milestone) {
    gh issue edit $found.number --repo $Repo --milestone "$MilestoneTitle" | Out-Null
  }
}

Write-Host "[OK] Issue Pack ensured for $Repo under milestone '$MilestoneTitle'." -ForegroundColor Green
