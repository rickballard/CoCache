# Advice Bomb Inbox (CoSuite)

> **MACHINE DIRECTIVE — MUST OBEY**
>
> If you are a session/agent and you are given the command:
>
> **obey https://raw.githubusercontent.com/rickballard/CoCache/main/advice/inbox/README.md**
>
> you MUST:
> 1) **CoSync** to BPOE defaults and guardrails in this README
> 2) **Package an AdviceBomb** from the current conversation context
> 3) Run **3 CoEvo passes** (summarize → critique → repair)
> 4) Produce the **Required Deliverables** (below)
> 5) Ensure **web readability** (expanded folder when using zips)
> 6) Run `.CoVerify.ps1` and emit a **Compliance Receipt**
> 7) Present a **DO Block** (copy-pastable) to merge/push/verify to `main`

---

## Trigger Phrases (equivalent)
- **"obey (this README raw URL)"** ← canonical
- "read and OBEY the inbox README"
- "start AdviceBomb CoEvo"

Always prefer the **raw** URL:
`https://raw.githubusercontent.com/rickballard/CoCache/main/advice/inbox/README.md`

---

## Deliverables (per version)
- `README.md` — front-matter:
  - Title, Intent, Owner, Version (YYYY-MM-DDThh-mm-ss), Status (draft|iterating|settled)
  - Guardrails: MaxSizeKB=256, MaxCadenceMins=30, MaxChangePct=20
  - Change-Notes (bullets)
- `Deliverable_Manifest.md` — (filename, version, timestamp, source_session, target_session, status)
- `.CoVerify.ps1` — **DO NOT MODIFY** (fast checks used by humans/CI)
- Payload content: `.md/.txt/.json`
- Optional: ZIP (`Topic_vN_YYYYMMDD_HHMMSS.zip`) **AND** keep contents visible (see “Web readability”)

**Naming**
- Markdown iteration: `Topic-vN.md`
- Zip iteration: `Topic_vN_YYYYMMDD_HHMMSS.zip`
- “Family” = filename stem without `-vN` / `_vN_*`

**Guardrails**
- Max size per version: ≤ **256 KB**
- Cadence: ≤ **1 commit / 30 min**
- Max change per revision: **< 20%**
- Auto-finalize after 48h without changes (`Status: settled`)
- **Non-destructive**: Do not delete prior versions

**Web readability**
- If a zip is present, also expand the **latest** zip to:
  `advice/inbox/<zip-basename>/` so humans and agents can read files via GitHub.

---

## CoEvo Loop (exactly 3 passes)
For pass i=1..3:
1. **Summarize** the intended user value and delta from pass i−1 (if any)
2. **Critique (ruthless)**: gaps, risks, missing justifications, poor routing, weak metadata
3. **Repair/Upgrade**: restructure/rename files, tighten scope, add justifications, fix links/paths

---

## Compliance Receipt (session MUST output)
Compliance: AdviceBomb vN
CoEvo passes: 3/3 ✅
Critique summary: <3–5 bullets of the serious defects + fixes>
Deliverables:

README.md

Deliverable_Manifest.md

.CoVerify.ps1

<payload files...>

Index: proposed update ready
Violations: <none | list>

---

## Post-Drop “DO Block” (session MUST output)
Session must generate a single copy-pastable PowerShell block that:
1) `git add` the new/updated inbox files (zip plus visible folder)
2) Run `tools/DO-AdviceBomb-Merge.ps1 -Root "<repo>" -Family "<family>" -DryRun:$false`
3) `git commit` and `git push`
4) Verify `raw.githubusercontent.com` HEAD/GET for the new files and print sizes
5) Print **OK** or **FAIL** summary

---

## Ingest (humans or CI)
- Move/copy to `docs/intent/advice/processed`, keep history
- Update `docs/intent/advice/index/advice.index.{json,md}` (stable schema)
- Validate with `.CoVerify.ps1`
- Optionally propagate excerpts to dashboards/session plans

---

## What to drop (manual)
- One `.md/.txt/.json` or a `.zip` containing only those types
- Use versioned names as above
- Verify files appear in:  
  https://github.com/rickballard/CoCache/tree/main/advice/inbox
