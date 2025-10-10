# CoAgent — BDBP (Business‑Development Business Plan) — **Private**
**Date:** 20250905  
**Owner:** CoModules / CoCivium (Rick — HumanGate ON)  
**Scope:** Investor + BizDev perspective for internal planning. Mirrors a public BP with additional candid details (pricing bands, partner strategy, risk notes).

---

## 0) Executive Summary (BD Lens)
CoAgent is a small, signed, cross‑platform agent (CLI + background service) that converts casual participants into **Contributors** and moves their work into GitHub‑centric flows safely and repeatably.  Free core builds ubiquity; revenue comes from fleet control, compliance, white‑labelling, and curated Job Packs.  
**BD thesis:** Win the “install → first success” loop on Windows/macOS/Ubuntu, then sell **control, compliance, and brand** to orgs that standardize on the agent.

**Why now**
- GitHub is the de facto source of truth.  Contribution friction + governance risk are rising.  
- Security posture for endpoint helpers is scrutinized by EDR/IT; signed native agents with clear provenance win.  
- AI‑assisted contribution increases volume; quality gates and templating are required.

---

## 1) Segments & ICPs (prioritized)
1. **Open‑source maintainers & foundations (free → Pro seats)** — raise submission quality, template PRs, lower triage load.  
2. **Civic/NGO networks (NGO packs; org plan)** — volunteers submit ideas/evidence with consent flows; offline queue; proxy‑friendly.  
3. **Enterprise DevEx/Platform teams (Enterprise)** — standardized contribution path to inner‑source repos; policy‑locked agents; SSO/SCIM; audit.  
4. **Education & Labs (site license)** — classroom submissions to course repos; rubrics as Job Packs.  
5. **DAOs / web3 collectives (Pro/Enterprise)** — governance submissions with identity attestations; deterministic templates.

**Buyer personas**: Head of DevEx/Platform, OSS Program Office, CIO security delegate, NGO program lead, university lab lead.

---

## 2) Top Use Cases (beyond CoCivium)
- **Issue/PR templating at scale** with local linting and repo policy hints.  
- **Incident post‑mortems**: structured capture, offline, later submits to the SRE repo.  
- **Data‑governance change requests**: schema/contract change proposals with approver routing.  
- **Policy acknowledgement**: push signed acknowledgements to a governance repo.  
- **Security disclosure intake** (non‑PII) with safe redaction before submit.  
- **Education homework pipeline**: collect labs as PRs with standard metadata.  
- **Field research capture** (NGOs): timestamped notes/artifacts → curated Discussions.  
- **Internal RFC process**: scaffold, lint, submit, and track status from the desktop.  
- **Release notes harvester**: collect fragments from teams, dedupe, open a scoped PR.  
- **“Submit once, mirror many”**: one local capture fans out to multiple repos (with policy).

---

## 3) CoCivium Applicability (framed for skeptics)
**Pitch:** CoAgent is not “just for CoCivium.”  It is a general **Contributor Agent** that happens to make CoCivium contributions first‑class.  
- For CoCivium, it standardizes **Idea Cards → ADRs → PRs**, preserving consent and traceability.  
- For any GitHub‑centric org, it reduces time‑to‑first‑contribution, raises quality, and lowers compliance friction.

**Example flow (CoCivium):**
`capture -> local lint (consent/format) -> queue -> enroll (GitHub App) -> submit to Discussions/PR -> status/doctor -> merge metrics`.

---

## 4) Value Proposition (per segment)
- **OSS maintainers:** +30–50% reduction in low‑quality issues; faster triage; consistent metadata.  
- **Enterprises:** policy‑locked routes, version floors, inventory, audit exports; fewer shadow tools.  
- **NGOs:** offline/low‑bandwidth capture; consentful submissions; human‑readable logs for auditing donors.  
- **Education:** identical workflows across OSes; grading automation via Job Packs.

(Internal ROI model in §11.)

---

## 5) Product & Packaging (free core → paid control)
**Free (Apache‑2.0):** `coagent` CLI + `coagentd` service; enroll (device flow); native keychains; queue; status/doctor; templates; signed releases; SBOM/SLSA.  
**Pro (per‑seat):** tray UI, richer queue ops, personal cloud mirror, advanced templates, priority support.  
**Enterprise (org):** Fleet Manager (open‑core server), ADMX/policy packs, SSO/SCIM, audit exports (CSV/Parquet), FIPS builds, offline bundles, whitelabelling (name/icon), private release channels.  
**Job Packs Marketplace:** curated integrations (ticketing/LMS/civic‑vote), revenue share 70/30.

---

## 6) GTM & BizDev Motions
- **Bottom‑up OSS motion:** seed free installs via Winget/Homebrew/apt; feature in README templates; community AMAs.  
- **Top‑down enterprise trials:** 30‑day pilots with Fleet Manager lite; KPI: time‑to‑first‑PR, upgrade adoption, queue drains.  
- **NGO & EDU partnerships:** provide site licenses + training packs; co‑brand success stories.  
- **Alliances:** DevEx vendors, MDMs, and security tool partners for mutual allow‑listing.

**Pricing bands (confidential, rev‑test):** Pro USD 4–8 seat/mo; Enterprise USD 2–5 per managed endpoint/mo with minimums.

---

## 7) Competitive / Alternative Landscape (high‑level)
- **DIY scripts + GitHub CLI** — brittle, unsupportable at scale; poor security posture.  
- **RPA tools** — heavy, not Git‑native; risky permissions.  
- **IT agents/MDM** — focus on device config, not contribution UX.  
- **Dev portals** — web‑first; lack offline capture and native keychain security.

**Position:** “The signed, Git‑native, offline‑capable contribution agent.”

---

## 8) Implementation Plan (condensed)
- **Language:** Rust; single static binaries per OS/arch.  IPC via named pipe/Unix socket; loopback ACLs; per‑boot auth token.
- **Auth:** GitHub App + device flow; short‑lived tokens cached in OS keychains.
- **Updates:** native package managers (Winget/MSIX; Homebrew cask/pkg; apt/dnf).  TUF‑style metadata; no bespoke updater.
- **Supply chain:** EV/Developer‑ID signing, macOS notarization, repo GPG keys, CycloneDX SBOM, SLSA attestations.
- **Network:** full proxy support; TLS1.2+; hostname pinning; backoff+jitter; offline spool.
- **CI/CD:** GH Actions matrix (win/macos/ubuntu × amd64/arm64); signing on trusted runners; release gates (upgrade/downgrade, proxy, service restart).
- **Security:** least‑privilege services; opt‑in telemetry (health only); PII scrubbing; `doctor` playbooks.

---

## 9) Metrics & Milestones
**Adoption:** installs by OS/arch, DAU of `status`, first‑success time p50/p90, upgrade adoption curve.  
**Quality:** rejected‑issue rate ↓, PR pass‑rate ↑, queue drain times.  
**Reliability:** crash‑free sessions %, upgrade failure rate %, proxy/offline success %.  
**Revenue (post‑GA):** Pro seats, Enterprise endpoints, marketplace GMV.

**Milestones:** Proto (T‑8w) → P0 GA (T0) → Ops Hardening (T+8w) → Pro/Ent (T+16w) → Mobile (T+24w).

---

## 10) Risks & Mitigations
- **EDR/Defender false positives** → signed MSIX/pkg; ADMX templates; minimal on‑disk writes; doc’d exclusions.  
- **Supply‑chain compromise** → notarization, attestations, multiple key custodians, reproducible builds.  
- **Proxy/air‑gap failures** → offline bundles; PAC/WPAD test coverage; support runbooks.  
- **Scope creep** → Job Pack API with clear IO contracts; ADRs for big changes.

---

## 11) ROI Model (internal)
Assume 500 engineers; baseline 2 hrs/week lost to contribution friction.  If CoAgent recovers **0.5 hr/person/week** at $100/hr fully loaded → $2,000/week → **$104k/year** saved.  Enterprise at $3/endpoint/mo × 500 = $18k/year; gross ROI ~6× before quality/compliance gains.

---

## 12) CoCivium Alignment
- Preserves consent (“Contributor” identity), traceability, and reversibility; fits the **Cognocarta Consenti** ethos.  
- Acts as the **Expert path** in the “Quick/Easy/Engaging/Expert” on‑ramp hierarchy.  
- Feeds metrics to CoCivium’s progress/eyes maps without exposing content.

---

## Appendix A — Support Matrix (P0/P1/P2)
- **P0:** Windows 10/11 (amd64/arm64 emu), macOS 13+/14+, Ubuntu 22.04/24.04.  
- **P1:** RHEL/Rocky 9, iOS/Android companions.  
- **P2:** Debian 12, ChromeOS (Crostini/Android), Raspberry Pi OS, Windows Server/Ubuntu Server.

## Appendix B — Commands (v1)
`enroll`, `status`, `doctor`, `secrets`, `queue (ls|rm|retry)`, `logs --follow`, `self‑update`.

## Appendix C — File Layout (defaults)
Windows `%ProgramData%/CoAgent` & `%AppData%/CoAgent`; macOS `/Library/Application Support/CoAgent` & `~/Library/...`; Linux `/etc/coagent`, `/var/lib/coagent`, `/var/log/coagent`.