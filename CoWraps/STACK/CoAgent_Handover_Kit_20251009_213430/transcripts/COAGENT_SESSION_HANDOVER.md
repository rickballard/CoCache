# COAGENT SESSION HANDOVER & COWRAP STANDARD

## Purpose
Keep CoAgent sessions lean (8–16h), reproducible, and handover-safe. Prevent “silent bloat,” odd behavior spirals, and lost work by enforcing a consistent **CoWrap** (session package) + verification loop.

## Core principles
- **Short & sealed:** time-box sessions; each end produces a sealed, verifiable artifact.
- **Source of truth:** the artifact—not the live session—is canonical.
- **Two-stage QA:** structural (automated) **then** qualitative (session-aware).
- **Self-repair:** only the originating session (or its successor) evolves its own artifact.

## Lifecycle (8–16h)
**Triggers:** time budget hit; model context >70%; behavior drift; milestone snapshot.  
**Pre-handover checklist:** decisions/risks/assumptions logged; open items tagged **(Unfinished)**; links/IDs recorded; CoWrap built and verified.

## CoWrap package (Spanky format)
**Filename:** `Spanky_<ShortName>_<YYYYMMDD_HHMMSS>.zip`

**Required structure**
```
/_spanky/
  _copayload.meta.json
  _wrap.manifest.json
  out.txt                 # first line = STATUS line
  checksums.json
/transcripts/
  session.md
/payload/
/notes/
  BPOE.md
  INTENTIONS.md
  DEPENDENCIES.md
  DECISIONS.md
  ASSUMPTIONS.md
  RISKS.md
  GLOSSARY.md
  WEBSITE_MANIFEST.md
  DEPRECATED.md
/summaries/
  TLDR.md
  ROADMAP_NOTES.md
  SOURCES.md
```

**`out.txt` first line**
```
[STATUS] items=<#> transcripts=<#> payload=<#> notes=<#> summaries=<#>
```
Where `items = transcripts + payload + notes + summaries`.

## Verification: Structural → Qualitative

### 1) Structural (automated, read-only)
- Required files present.
- `out.txt` counts match real entries.
- Any `MISSING_*` stubs flagged.
- If present, `checksums.json` verified (SHA-256).

**Tools:** see `ops/Spanky-GlobalVerify.ps1` and `ops/Spanky-BuildQAPacks.ps1`.

**Exit line convention:**  
`Spanky ready: <filename> ([STATUS] items=... transcripts=... payload=... notes=... summaries=...)`

### 2) Qualitative (session-aware)
- **Intent completeness:** scope, audience, deliverables; `(Unfinished)` tagged in `INTENTIONS.md`.
- **Traceability:** `DECISIONS.md` links to sources/commits/issues; missing links added to `SOURCES.md`.
- **Coherence:** duplicates/contradictions folded; stale moved to `DEPRECATED.md` with pointers.
- **Two faces:**  
  - AI-face: concise facts, stable IDs, permalinks, schemas.  
  - Human-face: diagrams, workflows, narrative; see `WEBSITE_MANIFEST.md`.

## Handover protocol
- Next session inherits `<ShortName>`; new timestamp per build.
- Handover bundle: latest “Spanky ready” line + the zip + `summaries/TLDR.md` (≤10 lines).
- Acceptance gate: successor runs structural verify. If `MISSING/ERROR`, origin self-repairs (no cross-session mutation).

## Repo hygiene
- Docs here under `docs/`, ops scripts under `ops/`.
- Issue templates for: Session Handover, CoWrap Repair, Verification Failure.
- (Optional CI) Lint `out.txt` counts and `checksums.json` on committed zips.

## Definition of done
1) CoWrap exists and passes structural verify (OK/OK*).  
2) Qualitative checklist satisfied; `(Unfinished)` items listed.  
3) Final console line recorded: “Spanky ready: … ([STATUS] …)”.

## Ops quickstart
- **Global verify (read-only):** `ops/Spanky-GlobalVerify.ps1`
- **Build QA packs:** `ops/Spanky-BuildQAPacks.ps1`