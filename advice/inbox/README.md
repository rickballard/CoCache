## How to add an Advice Bomb (fast path)

1) Prepare the inbox folder or ZIP
   - Each slug lives under: `advice/inbox/<slug>_YYYYMMDD_HHMMSS/`
   - Three-pass style is fine: keep `coevo-1/2/3` with a `MANIFEST.json` in each.
   - Optional ZIPs are allowed; `.CoVerify.ps1` accepts `.zip`, `.md`, `.txt`, `.json`.

2) Self-check before PR
   - Run: `& advice\inbox\.CoVerify.ps1`
     - **OK** = shape acceptable.
     - **FAIL** = lists problems to fix (oversize files, bad extensions, missing docs).

3) Open a PR from a topic branch (squash-merge)
   - Example (PowerShell):
     ```
     $R = "$HOME\Documents\GitHub\CoCache"
     Set-Location $R
     $slug = "<your-slug>"   # e.g., cocivium-money-claimflow
     git checkout -B ("advice/{0}" -f $slug)
     git add advice/inbox/$slug*/**
     git commit -m ("CoEvo-1: add {0} (pass 1)" -f $slug)
     git commit -m ("CoEvo-2: refine {0} (pass 2)" -f $slug) --allow-empty
     git commit -m ("CoEvo-3: finalize {0} (pass 3)" -f $slug) --allow-empty
     git push -u origin ("advice/{0}" -f $slug)
     gh pr create --base main --head ("advice/{0}" -f $slug) `
       --title ("Advice: {0}" -f $slug) `
       --body  "Inbox verified by .CoVerify; squash-merge on green."
     ```
   - This repo prefers **Squash & merge** (merge commits are disallowed).

4) After merge: verify it really landed on `main` (cloud + local)
   - Browser (cloud): switch to `main` and confirm your folder under `advice/inbox/`.
   - Local:
     ```
     git switch main
     git pull --ff-only
     $slug="<your-slug>"
     git ls-tree --name-only -r HEAD | Select-String ("advice/inbox/{0}" -f $slug)
     ```
   - If you keep only `coevo-1/2/3/MANIFEST.json`, that’s OK. If you also want a single root file,
     generate `INBOX_MANIFEST.json` with `tools/New-InboxManifest.ps1`.

Troubleshooting
- If the shell prints “term not recognized”, you’re probably in `cmd.exe`. Run `pwsh` first.
- First full scan can take several minutes; prefer a background job:
Start-Job -Name scan -ScriptBlock { & "$env:USERPROFILE\Documents\GitHub\CoCache\tools\Scan-CoAdvice.ps1" -Root "$env:USERPROFILE\Documents\GitHub\CoCache" }
Receive-Job -Name scan -AutoRemoveJob -Wait
- CI noise: mark docs-only or add `paths-ignore: advice/inbox/**` to workflows if needed.
