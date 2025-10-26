# Session Transcript (Narrative)

This pack summarizes a multi-step working session to shape and surface the **ScripTagger** concept (“Capture. Tag. Think.”) under the Opename / MeritRank initiative.

## Timeline highlights
- **Brand & site polish**: Added Opename logo in header across docs, responsive sizes via `/assets/style.css`, transparent logo backgrounds.
- **Docs surfacing**: GitHub Pages nudges to copy `MeritRank/docs/site` → `Opename/docs`.
- **ScripTagger public pages**:
  - `/docs/scripttagger/` — overview (summary-first; transcript optional).
  - `/docs/scripttagger/design.html` — kid-proof UX, consensus, positive-only publishing.
  - `/docs/scripttagger/methodology.html` — mic profiles, preliminary→upgraded transcripts, privacy.
  - `/docs/scripttagger/demo.html` — clickable demo (chips, summary panels, transcript toggle).
- **Demo niceties**: “Ask my AI” vendor-neutral hand-off (Web Share / clipboard / mailto).
- **Schema**: `schema/scripttagger-session.schema.json` v0 extended with
  `speaker_hypothesis`, `event_match`, `summary`, `handoff`, `audio_profile`, `stt`, `transcript_sources`.
- **Distribution**:
  - Downloads page with apology + early-access.
  - PWA service worker for offline cache.
  - GitHub Release created: portable Windows demo (`scripttagger-demo-windows-x64.zip`) + `checksums.txt`.
- **Marketing**: Tagline locked: **“Capture. Tag. Think.”** Short subtitle for stores: “Ethicality tags on voice or text.”
- **Principles**: Positive-only publication to RepTag; negatives used internally to sharpen separation but never published. Local-first, opt-in contributions; “assistance, not verdicts.”
- **Road to MVP**: Planned ingestion (paste/URL → later mic), event speaker inference, consensus logic, safe-guards & audits, release packaging.

## Notable pivots & constraints
- Default deliverable is a **two-panel summary** (Best claims / Questions to verify). Transcript is **off by default**.
- Vendor-neutral “Ask my AI” handoff acknowledges private AI chats remain private.
- Emphasis on **robustness & neutrality** before formal release; pre-MVP labeled clearly.
- Seed corpus & append-only log will start with **non-controversial exemplars** (clean bootstrap) with tombstone/redaction governance designed upfront.

(Generated 2025-10-09T19:32:24Z)

