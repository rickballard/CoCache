# Sources

## Instruction Packs (Uploaded)
- /mnt/data/Single_Spanky_Request_2025-10-07.zip: files=3
  - `Spanky_REQUEST.txt` preview:

```
You are ChatGPT. I need you to produce **one downloadable zip** in reply to this request. 
It must capture this session fully so another session can ingest it later. 

### Zip name
Spanky_<SessionShortName>_<YYYYMMDD_HHMMSS>.zip

### Structure inside the zip
/_spanky/
  _copayload.meta.json     # metadata (see schema)
  _wrap.manifest.json      # index of contents
  out.txt                  # status line
/transcripts/
  session.md               # full conversation transcript, oldest → newest
/payload/
  (deliverables: .md, .ps1, .json, .png, etc)
/notes/
  BPOE.md                  # workflow wins/risks
  INTENTIONS.md            # co-evolved intentions, open loops
  DEPENDENCIES.md          # repos/files touched or expected

### Example meta.json
{
  "wrap_version":"1.0",
  "session_title":"<human title>",
  "session_id":"<if known>",
  "source":"ChatGPT",
  "created_utc":"<ISO8601>",
  "tags":["Spanky","CoWrap","session","archive"],
  "targets":{"preferred_repo":"rickballard/CoCache","preferred_path":"CoWraps/STACK"}
}

### Example manifest.json
{
  "transcripts":["transcripts/session.md"],
  "payload":["payload/*"],
  "notes":["notes/BPOE.md","notes/INTENTIONS.md","notes/DEPENDENCIES.md"],
  "status":"out.txt"
}

### out.txt
Single line starting with [STATUS], e.g.:
[STATUS] items=42 transcripts=1 payload=5 notes=3

### Your task (no questions back)
1. Package everything per above spec. 
2. Give me a single downloadable zip link. 
3. Print short confirmation: "Spanky ready: <filename> (counts)".

```
  - `examples/_copayload.meta.json` preview:

```
{
  "wrap_version": "1.0",
  "session_title": "Example Session",
  "session_id": "EXAMPLE-123",
  "source": "ChatGPT",
  "created_utc": "2025-10-07T22:00:00Z",
  "tags": [
    "Spanky",
    "CoWrap",
    "session",
    "archive"
  ],
  "targets": {
    "preferred_repo": "rickballard/CoCache",
    "preferred_path": "CoWraps/STACK"
  }
}
```
  - `examples/_wrap.manifest.json` preview:

```
{
  "transcripts": [
    "transcripts/session.md"
  ],
  "payload": [
    "payload/*"
  ],
  "notes": [
    "notes/BPOE.md",
    "notes/INTENTIONS.md",
    "notes/DEPENDENCIES.md"
  ],
  "status": "out.txt"
}
```
- /mnt/data/Spanky_Request_Pack_v2_2_2025-10-08.zip: files=5
  - `01_INSTRUCTION_BLOCK.md` preview:

```
# Spanky Request — v2.2 (Deep-Capture + Deprecations)

**Goal:** force sessions to capture *everything that matters* including early intentions, pivots, risks, deprecated ideas, and web references — and return **one downloadable zip**.


## Your task
Return **one downloadable zip** named:
`Spanky_<ShortName>_<YYYYMMDD_HHMMSS>.zip`

### Required structure
/_spanky/
  _copayload.meta.json
  _wrap.manifest.json
  out.txt
  checksums.json
/transcripts/
  session.md
/payload/
  ... (deliverables)
/notes/
  BPOE.md
  INTENTIONS.md
  DEPENDENCIES.md
  DECISIONS.md
  ASSUMPTIONS.md
  RISKS.md
  GLOSSARY.md
  WEBSITE_MANIFEST.md
  DEPRECATED.md        # record ideas dropped, with rationale
/summaries/
  TLDR.md
  ROADMAP_NOTES.md
  SOURCES.md

> If something is unavailable, include a file with: MISSING_<WHAT>.

### Mandatory rewind
Before packaging, re-read from the start and include:
- Unfinished intentions → INTENTIONS.md
- Workflow/BPOE improvements → BPOE.md
- Pivots/abandoned drafts → ROADMAP_NOTES.md + DEPRECATED.md
- Risks/assumptions/decisions → respective files

### DEPRECATED.md format
- Idea/Initiative: <short name>
- Why dropped: <reason>
- When dropped: <session context / date>
- What it evolved into (if anything): <link or note>

### JSON examples
# _copayload.meta.json
{
  "wrap_version": "2.2",
  "session_title": "<human title>",
  "session_id": "<if known>",
  "source": "ChatGPT",
  "created_utc": "<ISO8601>",
  "tags": ["Spanky","CoWrap","session","archive","BPOE"],
  "targets": {"preferred_repo":"rickballard/CoCache","preferred_path":"CoWraps/STACK"},
  "priority": "DVP-critical | Important | Archive"
}

# _wrap.manifest.json
{
  "transcripts": ["transcripts/session.md"],
  "payload": ["payload/*"],
  "notes": [
    "notes/BPOE.md","notes/INTENTIONS.md","notes/DEPENDENCIES.md",
    "notes/DECISIONS.md","notes/ASSUMPTIONS.md","notes/RISKS.md","notes/GLOSSARY.md",
    "notes/WEBSITE_MANIFEST.md","notes/DEPRECATED.md"
  ],
  "summaries": ["summaries/TLDR.md",
```
  - `01_INSTRUCTION_BLOCK.txt` preview:

```
# Spanky Request — v2.2 (Deep-Capture + Deprecations)

**Goal:** force sessions to capture *everything that matters* including early intentions, pivots, risks, deprecated ideas, and web references — and return **one downloadable zip**.


## Your task
Return **one downloadable zip** named:
`Spanky_<ShortName>_<YYYYMMDD_HHMMSS>.zip`

### Required structure
/_spanky/
  _copayload.meta.json
  _wrap.manifest.json
  out.txt
  checksums.json
/transcripts/
  session.md
/payload/
  ... (deliverables)
/notes/
  BPOE.md
  INTENTIONS.md
  DEPENDENCIES.md
  DECISIONS.md
  ASSUMPTIONS.md
  RISKS.md
  GLOSSARY.md
  WEBSITE_MANIFEST.md
  DEPRECATED.md        # record ideas dropped, with rationale
/summaries/
  TLDR.md
  ROADMAP_NOTES.md
  SOURCES.md

> If something is unavailable, include a file with: MISSING_<WHAT>.

### Mandatory rewind
Before packaging, re-read from the start and include:
- Unfinished intentions → INTENTIONS.md
- Workflow/BPOE improvements → BPOE.md
- Pivots/abandoned drafts → ROADMAP_NOTES.md + DEPRECATED.md
- Risks/assumptions/decisions → respective files

### DEPRECATED.md format
- Idea/Initiative: <short name>
- Why dropped: <reason>
- When dropped: <session context / date>
- What it evolved into (if anything): <link or note>

### JSON examples
# _copayload.meta.json
{
  "wrap_version": "2.2",
  "session_title": "<human title>",
  "session_id": "<if known>",
  "source": "ChatGPT",
  "created_utc": "<ISO8601>",
  "tags": ["Spanky","CoWrap","session","archive","BPOE"],
  "targets": {"preferred_repo":"rickballard/CoCache","preferred_path":"CoWraps/STACK"},
  "priority": "DVP-critical | Important | Archive"
}

# _wrap.manifest.json
{
  "transcripts": ["transcripts/session.md"],
  "payload": ["payload/*"],
  "notes": [
    "notes/BPOE.md","notes/INTENTIONS.md","notes/DEPENDENCIES.md",
    "notes/DECISIONS.md","notes/ASSUMPTIONS.md","notes/RISKS.md","notes/GLOSSARY.md",
    "notes/WEBSITE_MANIFEST.md","notes/DEPRECATED.md"
  ],
  "summaries": ["summaries/TLDR.md",
```
  - `_examples/_copayload.meta.json` preview:

```
{
  "wrap_version": "2.2",
  "session_title": "Example Session",
  "session_id": "EXAMPLE-SESSION-ID",
  "source": "ChatGPT",
  "created_utc": "2025-10-08T00:05:00Z",
  "tags": [
    "Spanky",
    "CoWrap",
    "session",
    "archive",
    "BPOE"
  ],
  "targets": {
    "preferred_repo": "rickballard/CoCache",
    "preferred_path": "CoWraps/STACK"
  },
  "priority": "Important"
}
```
  - `_examples/_wrap.manifest.json` preview:

```
{
  "transcripts": [
    "transcripts/session.md"
  ],
  "payload": [
    "payload/*"
  ],
  "notes": [
    "notes/BPOE.md",
    "notes/INTENTIONS.md",
    "notes/DEPENDENCIES.md",
    "notes/DECISIONS.md",
    "notes/ASSUMPTIONS.md",
    "notes/RISKS.md",
    "notes/GLOSSARY.md",
    "notes/WEBSITE_MANIFEST.md",
    "notes/DEPRECATED.md"
  ],
  "summaries": [
    "summaries/TLDR.md",
    "summaries/ROADMAP_NOTES.md",
    "summaries/SOURCES.md"
  ],
  "status": "_spanky/out.txt",
  "checksums": "_spanky/checksums.json"
}
```
  - `forms/notes/DEPRECATED.md` preview:

```
# DEPRECATED IDEAS & INITIATIVES
- Idea/Initiative: 
- Why dropped: 
- When dropped: 
- What it evolved into (if anything):

```
