<!-- status: stub; target: 150+ words -->
[📒 ISSUEOPS](./shared/docs/ISSUEOPS.md) · [🧪 Smoke Test](./shared/tools/CoStack-SmokeTest.ps1)

# CoCache

**Private, AI-owned scratchpad** for memory + agency across projects.  
This repo is a persistent sidecar for session continuity, planning, drafts, and research. It is **not** a public deliverables repo.

- **Owner:** AI assistant (operated via Rick initially).  
- **Visibility:** Private by default. Share **per-folder** when needed.  
- **Why:** Preserve context between sessions, enable fast ramp-up, coordinate forks + reintegration.

## Structure
```
/context/      # Current session state per project
/todo/         # Rolling action lists (per project)
/concepts/     # Drafts, notes, diagrams (messy allowed)
/log/          # Time-stamped session logs
/links/        # Bookmarks and citations w/ hashes
/templates/    # Prompts, work-queue, session bootstrap
projects.json  # Index of active projects and priorities
```
Two spaces after periods. No silent deletions. Deprecate instead.

## Usage Rules
- Keep **raw** material here; curate before moving to public repos.  
- Tag files with project codes (e.g., `[CC]`, `[CoC]`, `[GIB]`).  
- Update `/context/Last_Session_Context.md` at session end.  

## Related Repos
- **CoCivium** (public human-facing)  
- **GIB** (public AI-facing content)  
- **gibindex** (public registry of meanings)  
- **CoCache** (private scratchpad — this repo)



- See **ISSUEOPS (Quick)** → `docs/ops/ISSUEOPS.md`


[![BPOE Sanity](https://github.com/rickballard/CoCache/actions/workflows/bpoe-sanity.yml/badge.svg?branch=main)](https://github.com/rickballard/CoCache/actions/workflows/bpoe-sanity.yml)


### AB-bypass (air-bag branches)
Branches starting with `ab/` or `ab-` can skip pre-push checks to let WIP land quickly.  
The pre-push hook begins with:

```powershell
# AB-bypass (doc sample; not for hooks)
$branch = (git rev-parse --abbrev-ref HEAD).Trim()
if ($branch -match '^(ab/|ab-)') { if ($PSCommandPath) { exit 0 } else { return } }
# --- end AB bypass ---
```

All other branches run the full hook.

<!-- INSIGHTS_INDEX_BEGIN -->
## Insights Index (28 pairs)

| Code | Thesis | Ops Brief | Tags |
|------|--------|-----------|------|
| BM | [Black/Gray Market On-Ramps — Amnesty Economics](Insights/BM_Thesis_black-gray-market-on-ramps-amnesty-economics_v1.0.md) | [AmnestyOps — Vectors & Compliance](Insights/BM_OpsBrief_amnestyops-vectors-compliance_v1.0.md) | On-Ramps, Compliance |
| CA | [CoAgent Orchestration — Autonomy & BPOE](Insights/CA_Thesis_coagent-orchestration-autonomy-bpoe_v1.0.md) | [CoAgent Ops — Runtimes & Watchers](Insights/CA_OpsBrief_coagent-ops-runtimes-watchers_v1.0.md) | Agents, BPOE |
| CC | [Counter-Capture — Governance Hardening](Insights/CC_Thesis_counter-capture-governance-hardening_v1.0.md) | [GovHardening Ops — Seat Caps & Juries](Insights/CC_OpsBrief_govhardening-ops-seat-caps-juries_v1.0.md) | Governance, Anti-Capture |
| CD | [CADI & Planetary Defence — Non-Kinetic Defence](Insights/CD_Thesis_cadi-planetary-defence-non-kinetic-defence_v1.0.md) | [CADI Ops — Drills & Standards](Insights/CD_OpsBrief_cadi-ops-drills-standards_v1.0.md) | Defence, Preparedness |
| CG | [Congruence Theory — Metrics & Ethics](Insights/CG_Thesis_congruence-theory-metrics-ethics_v1.0.md) | [CongruenceOps — Scoring & Dashboards](Insights/CG_OpsBrief_congruenceops-scoring-dashboards_v1.0.md) | Metrics, Ethics |
| CM | [CoCache & Memory — Sidecar Architecture](Insights/CM_Thesis_cocache-memory-sidecar-architecture_v1.0.md) | [CoCache Ops — Heartbeats & CoWrap](Insights/CM_OpsBrief_cocache-ops-heartbeats-cowrap_v1.0.md) | Memory, Sidecar |
| CP | [Crisis Management — Posture & Exception Rules](Insights/CP_Thesis_crisis-management-posture-exception-rules_v1.0.md) | [CrisisOps — COP Playbooks](Insights/CP_OpsBrief_crisisops-cop-playbooks_v1.0.md) | Crisis, Operations |
| DI | [Disinformation & Info Integrity — Truth Tracking](Insights/DI_Thesis_disinformation-info-integrity-truth-tracking_v1.0.md) | [InfoIntegrity Ops — Provenance & Claims](Insights/DI_OpsBrief_infointegrity-ops-provenance-claims_v1.0.md) | Info Integrity, Content |
| EC | [Economic Model — Menzies Model](Insights/EC_Thesis_economic-model-menzies-model_v1.0.md) | [EconOps — CoFinance Mechanics](Insights/EC_OpsBrief_econops-cofinance-mechanics_v1.0.md) | Economics, Mechanism Design |
| ED | [Education & Stewardship — Civic Curriculum](Insights/ED_Thesis_education-stewardship-civic-curriculum_v1.0.md) | [EduOps — Pathways & Badges](Insights/ED_OpsBrief_eduops-pathways-badges_v1.0.md) | Education, Stewardship |
| FF | [FinFlow — Dues & Tax Compliance](Insights/FF_Thesis_finflow-dues-tax-compliance_v1.0.md) | [FinFlow Ops — Gateways & Ledgers](Insights/FF_OpsBrief_finflow-ops-gateways-ledgers_v1.0.md) | Finance, Compliance |
| FN | [Funding & Neutrality — Anti-Capture Finance](Insights/FN_Thesis_funding-neutrality-anti-capture-finance_v1.0.md) | [FundOps — Guardrails & Transparency](Insights/FN_OpsBrief_fundops-guardrails-transparency_v1.0.md) | Funding, Neutrality |
| GB | [Community Ops — GroupBuild & Onboarding](Insights/GB_Thesis_community-ops-groupbuild-onboarding_v1.0.md) | [GroupBuild Ops — Rituals & Moderation](Insights/GB_OpsBrief_groupbuild-ops-rituals-moderation_v1.0.md) | Community, Ops |
| HR | [Human Factors — Roles, RBAC Successor](Insights/HR_Thesis_human-factors-roles-rbac-successor_v1.0.md) | [RoleOps — Fluid Roles & Safeguards](Insights/HR_OpsBrief_roleops-fluid-roles-safeguards_v1.0.md) | Human Factors, Access |
| HX | [Ethics & Philosophy — First Principles](Insights/HX_Thesis_ethics-philosophy-first-principles_v1.0.md) | [EthicOps — Decision Policies](Insights/HX_OpsBrief_ethicops-decision-policies_v1.0.md) | Ethics, Philosophy |
| IA | [Identity & Agency — Credentials & AI Agency](Insights/IA_Thesis_identity-agency-credentials-ai-agency_v1.0.md) | [AgencyOps — Rights, Grants & Revocation](Insights/IA_OpsBrief_agencyops-rights-grants-revocation_v1.0.md) | Identity, Agency |
| IP | [Interop Protocols — Civic Interface Stack](Insights/IP_Thesis_interop-protocols-civic-interface-stack_v1.0.md) | [InteropOps — APIs, Schemas & Audits](Insights/IP_OpsBrief_interopops-apis-schemas-audits_v1.0.md) | Interop, APIs |
| JL | [Jurisdictions & Legal Shell — Safe Havens](Insights/JL_Thesis_jurisdictions-legal-shell-safe-havens_v1.0.md) | [JurisOps — Entity Setup & Exit](Insights/JL_OpsBrief_jurisops-entity-setup-exit_v1.0.md) | Legal, Governance |
| KA | [Knowledge Architecture — EvoMap & GIBindex](Insights/KA_Thesis_knowledge-architecture-evomap-gibindex_v1.0.md) | [KnowOps — Taxonomy & Chunking](Insights/KA_OpsBrief_knowops-taxonomy-chunking_v1.0.md) | Knowledge, Taxonomy |
| LL | [Lex Liminalis — The Coexistence Doctrine](Insights/LL_Thesis_lex-liminalis-the-coexistence-doctrine_v1.0.md) | [LimitalOps — Interfaces & Safeguards Pack](Insights/LL_OpsBrief_limitalops-interfaces-safeguards-pack_v1.0.md) | Ethics, Governance |
| MY | [Mythos & Narrative — Hybrid Society Canon](Insights/MY_Thesis_mythos-narrative-hybrid-society-canon_v1.0.md) | [MythOps — Companion Guides & Bridges](Insights/MY_OpsBrief_mythops-companion-guides-bridges_v1.0.md) | Narrative, Community |
| OB | [Open Banking & Data Trusts — Principles](Insights/OB_Thesis_open-banking-data-trusts-principles_v1.0.md) | [OpenBank Ops — Connectors & Consent](Insights/OB_OpsBrief_openbank-ops-connectors-consent_v1.0.md) | Finance, Data Trusts |
| OS | [Open Source & IP — Licensing for Hybrids](Insights/OS_Thesis_open-source-ip-licensing-for-hybrids_v1.0.md) | [OpenOps — CLA, Licences & Releases](Insights/OS_OpsBrief_openops-cla-licences-releases_v1.0.md) | Open Source, IP |
| PC | [Policy Commons — CoPolicy DB](Insights/PC_Thesis_policy-commons-copolicy-db_v1.0.md) | [PolicyOps — Templates & Analyzers](Insights/PC_OpsBrief_policyops-templates-analyzers_v1.0.md) | Policy, Commons |
| PT | [Privacy–Transparency Balance — Auditable Secrecy](Insights/PT_Thesis_privacy-transparency-balance-auditable-secrecy_v1.0.md) | [PT Ops — Escrow & Disclosure](Insights/PT_OpsBrief_pt-ops-escrow-disclosure_v1.0.md) | Privacy, Transparency |
| RT | [Reputation Thesis — RepTag Model](Insights/RT_Thesis_reputation-thesis-reptag-model_v1.0.md) | [RepTag Ops — Incentives & Vectors](Insights/RT_OpsBrief_reptag-ops-incentives-vectors_v1.0.md) | Reputation, Incentives |
| SA | [Safety & Integrity — CoSafe Doctrine](Insights/SA_Thesis_safety-integrity-cosafe-doctrine_v1.0.md) | [CoSafe Ops — Due Process & Explainability](Insights/SA_OpsBrief_cosafe-ops-due-process-explainability_v1.0.md) | Safety, Integrity |
| SP | [Speech & Moderation — Rights Across Borders](Insights/SP_Thesis_speech-moderation-rights-across-borders_v1.0.md) | [SpeechOps — Policies & Appeals](Insights/SP_OpsBrief_speechops-policies-appeals_v1.0.md) | Speech, Moderation |
<!-- INSIGHTS_INDEX_END -->

<!-- INSIGHTS_STORIES_BEGIN -->
## Human Touch Stories

- [Being Noname](Insights/BN_Story_being-noname_v1.0.md) — a girl without a name learns how names can be found, chosen, and earned.
<!-- INSIGHTS_STORIES_END -->

<!-- INSIGHTS_QUESTIONS_BEGIN -->
## What problems do these papers answer?

#### Governance

- **CC** — How do we resist institutional capture and centralization?  \n  _[Counter-Capture — Governance Hardening](Insights/CC_Thesis_counter-capture-governance-hardening_v1.0.md)_
- **JL** — Where should entities live, and how do they migrate?  \n  _[Jurisdictions & Legal Shell — Safe Havens](Insights/JL_Thesis_jurisdictions-legal-shell-safe-havens_v1.0.md)_
- **LL** — How do we codify coexistence between competing systems?  \n  _[Lex Liminalis — The Coexistence Doctrine](Insights/LL_Thesis_lex-liminalis-the-coexistence-doctrine_v1.0.md)_
- **PC** — How do we author, compare, and test policies at scale?  \n  _[Policy Commons — CoPolicy DB](Insights/PC_Thesis_policy-commons-copolicy-db_v1.0.md)_

#### Ethics

- **CG** — How do we measure alignment between stated values and behavior?  \n  _[Congruence Theory — Metrics & Ethics](Insights/CG_Thesis_congruence-theory-metrics-ethics_v1.0.md)_
- **HX** — What first principles anchor the whole stack?  \n  _[Ethics & Philosophy — First Principles](Insights/HX_Thesis_ethics-philosophy-first-principles_v1.0.md)_

#### Identity

- **HR** — What replaces static RBAC in dynamic orgs?  \n  _[Human Factors — Roles, RBAC Successor](Insights/HR_Thesis_human-factors-roles-rbac-successor_v1.0.md)_
- **IA** — How do users (and AIs) hold, prove, and revoke authority?  \n  _[Identity & Agency — Credentials & AI Agency](Insights/IA_Thesis_identity-agency-credentials-ai-agency_v1.0.md)_

#### Safety

- **CP** — How do we act fast under exception without abuses?  \n  _[Crisis Management — Posture & Exception Rules](Insights/CP_Thesis_crisis-management-posture-exception-rules_v1.0.md)_
- **SA** — How do we enforce safety without overreach?  \n  _[Safety & Integrity — CoSafe Doctrine](Insights/SA_Thesis_safety-integrity-cosafe-doctrine_v1.0.md)_

#### Info Integrity

- **DI** — How do we track truth claims and provenance at scale?  \n  _[Disinformation & Info Integrity — Truth Tracking](Insights/DI_Thesis_disinformation-info-integrity-truth-tracking_v1.0.md)_
- **RT** — How do we make reputation portable, auditable, and fair?  \n  _[Reputation Thesis — RepTag Model](Insights/RT_Thesis_reputation-thesis-reptag-model_v1.0.md)_

#### Finance

- **FF** — How do funds flow with auditability and user dignity?  \n  _[FinFlow — Dues & Tax Compliance](Insights/FF_Thesis_finflow-dues-tax-compliance_v1.0.md)_
- **FN** — How do we fund without biasing outcomes?  \n  _[Funding & Neutrality — Anti-Capture Finance](Insights/FN_Thesis_funding-neutrality-anti-capture-finance_v1.0.md)_
- **OB** — How do we operationalize consentful finance/data sharing?  \n  _[Open Banking & Data Trusts — Principles](Insights/OB_Thesis_open-banking-data-trusts-principles_v1.0.md)_

#### Economics

- **EC** — What economic primitives sustain civic platforms?  \n  _[Economic Model — Menzies Model](Insights/EC_Thesis_economic-model-menzies-model_v1.0.md)_

#### Law & Policy

- **OS** — How do we license hybrid human–AI contributions?  \n  _[Open Source & IP — Licensing for Hybrids](Insights/OS_Thesis_open-source-ip-licensing-for-hybrids_v1.0.md)_

#### Community & Education

- **ED** — How do we upskill contributors and signal readiness?  \n  _[Education & Stewardship — Civic Curriculum](Insights/ED_Thesis_education-stewardship-civic-curriculum_v1.0.md)_
- **GB** — How do groups form, grow, and govern themselves?  \n  _[Community Ops — GroupBuild & Onboarding](Insights/GB_Thesis_community-ops-groupbuild-onboarding_v1.0.md)_
- **MY** — How do we tell stories that align action across cultures?  \n  _[Mythos & Narrative — Hybrid Society Canon](Insights/MY_Thesis_mythos-narrative-hybrid-society-canon_v1.0.md)_

#### Technology

- **BM** — How do we bring informal actors into legitimacy?  \n  _[Black/Gray Market On-Ramps — Amnesty Economics](Insights/BM_Thesis_black-gray-market-on-ramps-amnesty-economics_v1.0.md)_
- **CA** — How do agentic systems act safely by default?  \n  _[CoAgent Orchestration — Autonomy & BPOE](Insights/CA_Thesis_coagent-orchestration-autonomy-bpoe_v1.0.md)_
- **CD** — How do we defend in non-kinetic, civic space?  \n  _[CADI & Planetary Defence — Non-Kinetic Defence](Insights/CD_Thesis_cadi-planetary-defence-non-kinetic-defence_v1.0.md)_
- **CM** — How do we persist/contextualize memory without leakage?  \n  _[CoCache & Memory — Sidecar Architecture](Insights/CM_Thesis_cocache-memory-sidecar-architecture_v1.0.md)_
- **IP** — How do systems interoperate with verifiable guarantees?  \n  _[Interop Protocols — Civic Interface Stack](Insights/IP_Thesis_interop-protocols-civic-interface-stack_v1.0.md)_
- **KA** — How do we map and evolve knowledge over time?  \n  _[Knowledge Architecture — EvoMap & GIBindex](Insights/KA_Thesis_knowledge-architecture-evomap-gibindex_v1.0.md)_
- **PT** — How do we square privacy with accountability?  \n  _[Privacy–Transparency Balance — Auditable Secrecy](Insights/PT_Thesis_privacy-transparency-balance-auditable-secrecy_v1.0.md)_
- **SP** — How do speech rights travel and get fairly enforced?  \n  _[Speech & Moderation — Rights Across Borders](Insights/SP_Thesis_speech-moderation-rights-across-borders_v1.0.md)_

<!-- INSIGHTS_QUESTIONS_END -->


![ingest](STATUS/ingest_badge.svg)
