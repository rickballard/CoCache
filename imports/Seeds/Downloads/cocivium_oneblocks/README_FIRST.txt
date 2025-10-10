CoCivium — ONEBLOCK Toolkit
Created: 2025-08-14 (UTC)

How to use
==========
1) Extract this zip anywhere (e.g., Downloads\cocivium_oneblocks\).
2) Open PowerShell, then run scripts one by one:

   ./preflight.ps1
   ./apply_master_backlog.ps1
   ./create_finance_brief_pr.ps1
   ./wiki_seed.ps1
   ./patch_wiki_domains.ps1
   ./style_paste_safety.ps1
   ./labels_and_meta_issues.ps1

Notes
-----
- Scripts default to: $HOME\Documents\GitHub\CoCivium
  Pass -RepoRoot 'C:\path\to\CoCivium' to override.
- Requires GitHub CLI auth (`gh auth status` shows OK).
- Paste-safe here-strings; idempotent; no `$home` variable.
