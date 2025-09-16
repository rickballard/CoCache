# BPOE: Blob Guard (100 MB)

GitHub rejects any blob >= 100 MB. This repo installs a pre-push hook that blocks such pushes locally.

Install:
  1) core.hooksPath is set to .githooks in this kit.
  2) Hook files: .githooks/pre-push and .githooks/pre-push.ps1

If you already committed a big file (example paths shown):
  1) Backup:
       git bundle create ../pre-filter-YYYYmmddHHMMSS.bundle --all
  2) Rewrite history (requires git-filter-repo in PATH):
       git filter-repo --force ^
         --path docs/index/ADVICE-INDEX.md ^
         --path docs/index/TODO-INDEX.md ^
         --invert-paths
  3) Force-push (coordinate with any collaborators):
       git push --force-with-lease origin main
