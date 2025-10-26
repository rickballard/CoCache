# BPOE: Blob Guard (100 MB)

GitHub rejects any blob >= 100 MB. This repo installs a pre-push hook that blocks such pushes locally.

Install:
  1) core.hooksPath is set to .githooks in this kit.
  2) Hook files: .githooks/pre-push and .githooks/pre-push.ps1

If you already committed a big file (example heavy paths):
  - docs/index/ADVICE-INDEX.md
  - docs/index/TODO-INDEX.md

Rewrite steps (with backups):

  1) Backup everything to a bundle (outside the repo):
       git bundle create ../pre-filter-$(Get-Date -Format yyyyMMddHHmmss).bundle --all

  2) Remove heavy paths from history (requires git-filter-repo in PATH):
       # Install: pip install git-filter-repo   (or choco install git-filter-repo)
       git filter-repo --force
         --path docs/index/ADVICE-INDEX.md
         --path docs/index/TODO-INDEX.md
         --invert-paths

  3) Force-push (coordinate with collaborators):
       git push --force-with-lease origin main

