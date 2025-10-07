# CoWrap Specification v1.0

**Purpose:**  
CoWraps capture *semantic intent, inference, conceptual seeds, and impact patterns* from an AI-human session — not instructions, not transcripts, but thought fossils. They allow continuity, wisdom extraction, and multi-agent coevolution even if the original session is lost or the agent changes.

## What Goes Into a CoWrap
- Summary of session purpose and major epiphanies
- Inferred intentions or ideas not yet implemented
- Guidance for future agents or humans that may take over
- Pointers to zipped Advice Bombs (if any)
- Optional tracebacks to CoAgent panel names (CoPing, CoPong, etc.)

## Format
- Markdown (`*.md`) as baseline
- Stored in `cowrap/` folder of repo (e.g., CoRef)
- May be augmented by `cowrap.json` if structured metadata is required

## Usage
- Passive storage in `CoCache` or `CoRef`
- AI agents may ingest to resume or review session
- Human curators may fold insights into CoStd/CoImp artifacts