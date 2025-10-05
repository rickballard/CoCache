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


