# AdviceBomb Import Report

**ZIP:** /mnt/data/AdviceBomb_CoWrapped_RickPublic_AI_Access_v3_20251023_144318.zip

**Extracted To:** /mnt/data/RickPublic_AdviceBomb_import

## File Tree

```
  README.md
  TLDR.md
  _hp.manifest.json
insights/
  README_additive_note.md
  TOPIC_CHECKLIST.md
rickpublic/
  TEMPLATE_post.md
ai-access/
  README.md
  gibindex/
    README.md
  coref/
    README.md
guides/
  AI_GUIDANCE_NOTES.md
  SUBSTACK_MAPPING.md
playbooks/
  PLAYBOOK_AI_INDEX.md
  PLAYBOOK_Substack.md
do/
  DO_Extract-InsightsIndex.ps1
governance/
  RFC_TEMPLATE.md
meta/
  PHILOSOPHY.md
handover/
  README.md
```

## File Previews (first ~2000 chars)

### _hp.manifest.json  
*size:* 826 bytes  
*sha256:* `fdc561ff8152417bfc8a6a9ef0020ee2f208ec5825a1defc291228d453dcd5a0`

```
{
  "title": "AdviceBomb: CoWrapped \u2014 RickPublic / InSights / AI Access & Guidance (v3)",
  "origin": "CoCivium (current session)",
  "intent": [
    "Integrate CoCivium Insights with RickPublic Substack pipeline",
    "Establish AI-readable indexing and concept-based linking (GIBindex, CoRef)",
    "Provide non-directive, strawman-style governance and content organization guidance",
    "Enable concurrent sessions to adopt these practices autonomously"
  ],
  "philosophy": "All components are proposals and prototypes\u2014no directives. Each section exists to inspire human-AI co-evolution through flexible patterns.",
  "usage": [
    "Unzip anywhere. Start with README.md",
    "Each folder is self-contained and descriptive",
    "No scripts perform mutations unless intentionally executed (DO_* scripts)"
  ]
}
```

### README.md  
*size:* 920 bytes  
*sha256:* `b7fe9741a7eb1e9e0ce77a025c02984b460c21b16d24ddd412d89ae0a43dfa76`

```
# CoWrapped AdviceBomb — RickPublic / InSights / AI Access & Guidance (v3)

This deliverable merges:
- The **RickPublic/InSights speeches regimes** guidance
- The **AI Access & Guidance** advisory kit
- The **Upgrade Patch** enhancements (README inserts, checklists, CI, RFCs)
into one **self-explanatory, proposal-only** package.

## Principles
- All content is advisory, not directive.
- Each file or script is a strawman pattern—free to modify, reject, or evolve.
- The aim is to make CoCivium repos **transparent, AI-readable, and human-inspiring**.

## Key Paths
- `insights/` → structure & README templates for theory/practice couplets
- `rickpublic/` → Substack integration + front-matter templates
- `ai-access/` → GIBindex, CoRef, and AI discovery support
- `guides/` → playbooks, mappings, and governance notes
- `do/` → optional PowerShell tools (read-only unless stated)

Start with `TLDR.md`.

```

### TLDR.md  
*size:* 243 bytes  
*sha256:* `09eb8cf72ed33ceeffb80559ca0b458c0d727128cb50bcc5de9e1a9f9af1402b`

```
# TLDR
This is a CoWrapped deliverable for concurrent sessions:
- Organize `insights/` (CoCivium)
- Manage RickPublic <-> Substack flow
- Ensure AI-readable access via GIBindex + CoRef
- Inspire continuous evolution of thought, not hard rules

```

### insights/README_additive_note.md  
*size:* 234 bytes  
*sha256:* `ab7b2ab06e67911503bb2717244646acb53ffb646833d54b96197be4e6531936`

```
# Insights README Addendum
Purpose: inspire humans to question, compare, and co-evolve CoCivium & social orders.
Each topic includes THEORY (concepts) and PRACTICE (implementations).
Status labels: draft | review | adopted | archived

```

### insights/TOPIC_CHECKLIST.md  
*size:* 235 bytes  
*sha256:* `ece72a95ff4e018d4931531b285610a02cd7472603ce69842c2e25020a4e4b26`

```
# Topic Checklist (Seed→CME→Canopy→Biome)
- CME/Seeme, Economics, Politics, Law, Finance, Data/Identity, Ethics, Education, Security, Tech/AI, Futures
Each must have a THEORY & PRACTICE pair, `gibkey`, and optional `coref_refs`.

```

### rickpublic/TEMPLATE_post.md  
*size:* 181 bytes  
*sha256:* `59fdc11563e1c85d4865f4b68392885644e4f2fbb50c360bdf62f1212f8d24d0`

```
---
title: "<Human Title>"
dek: "<summary>"
date: "YYYY-MM-DD"
tags: ["CoCivium","Insights"]
canonical: "<link>"
gibkey: "<key>"
---

# Lead
Excerpt linking to THEORY and PRACTICE.

```

### ai-access/README.md  
*size:* 345 bytes  
*sha256:* `53b885ec9884c8f4aa5e0d25742b7fda26dcb74e0e94588694105c8e89f6d134`

```
# AI Access & Guidance
Ensure AIs can read CoCivium repos holistically and safely.
Strategies:
- Mirror indexes (`/ai/index.json`, `/ai/chunks.ndjson`)
- Avoid throttling by caching via CoCacheGlobal mirrors
- Prefer structured metadata (JSON, schema) over HTML
- Reference GIBindex for concept resolution
- Use CoRef for canonical data linking

```

### ai-access/gibindex/README.md  
*size:* 105 bytes  
*sha256:* `4dbb7ae4d99ad24f50292a5bc4cc16bce206ebf7c4a7a90d80ce576e0243a1f0`

```
# GIBindex Reference
Central index of terms & concepts.
Use consistent `gibkey:` fields in front matter.

```

### ai-access/coref/README.md  
*size:* 104 bytes  
*sha256:* `41c37b32cf1a3344068d161f872f5e441240246a7a482e09d7aef2e50045f239`

```
# CoRef Canonical Object Registry
Each `coref:<namespace>/<slug>@vX.Y.Z` points to immutable knowledge.

```

### guides/SUBSTACK_MAPPING.md  
*size:* 146 bytes  
*sha256:* `43e1e0dcbfac05dbf4b3af27fc5564297aa763970cd6dc068415c6f0d35721d3`

```
# Substack Field Mapping
RickPublic post front matter → Substack fields mapping guide.
Manual paste flow ensures consistent metadata roundtrip.

```

### guides/AI_GUIDANCE_NOTES.md  
*size:* 202 bytes  
*sha256:* `2688eda9b5cf9e643436df7bc0601f1404295e3efe52d14a14d7b9840c6391c1`

```
# AI Guidance & Ethics
- All AIs interacting with CoCivium should follow transparent reading conventions.
- Never modify without human traceability.
- Maintain versioned logs (CoCacheGlobal heartbeat).

```

### playbooks/PLAYBOOK_Substack.md  
*size:* 153 bytes  
*sha256:* `603664d8cb5a525a986b8924eeb06653489ac2c55dc93009e35089a821a668b7`

```
# Playbook: From Insight to Substack
1) Run DO_New-PostFromCouplet.ps1 to generate draft.
2) Copy to Substack.
3) Retro-archive into RickPublic/archive.

```

### playbooks/PLAYBOOK_AI_INDEX.md  
*size:* 118 bytes  
*sha256:* `a25b74c51d7c4a5ca945ddca12a4daa69f69e45e25a1ee20cecfcefb2caad27c`

```
# Playbook: Maintain AI Index
- Update /ai/index.json after major repo changes.
- Include concept keys and file SHAs.

```

### do/DO_Extract-InsightsIndex.ps1  
*size:* 148 bytes  
*sha256:* `36dd428b7c2940e56dc2f398b2905aaa46cd983f5450974a7c59478f171b2d16`

```
# DO: Extract Index (read-only)
param([string]$Root = "$HOME\Documents\GitHub")
Write-Host "Scanning insights folders for THEORY/PRACTICE pairs..."

```

### governance/RFC_TEMPLATE.md  
*size:* 111 bytes  
*sha256:* `db92352f098d9269982d4f46fd6f935980f48f052178c7d31c11d5291d6e20c3`

```
---
title: "RFC: <Title>"
date: "YYYY-MM-DD"
status: "draft"
---
## Summary
## Proposal
## Risks
## Evaluation

```

### meta/PHILOSOPHY.md  
*size:* 155 bytes  
*sha256:* `5e762a7cac908103145f3d3d8ff3c556db8c0d3a0fe315da88a18260955f6638`

```
# Meta-Philosophy
This deliverable is an invitation, not instruction.
Humans remain final arbiters.
AIs contribute perspective, structure, and continuity.

```

### handover/README.md  
*size:* 221 bytes  
*sha256:* `2645f2e0d62d8f768953a0792f173bc95caf2acd3dd8ef1187f5f25d2f6454af`

```
# Handover Summary
This AdviceBomb can be given directly to another session (RickPublic/InSights speeches regimes).
All directories are self-explanatory.
The package includes both technical and philosophical scaffolding.

```

