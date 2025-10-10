BPOE-CoCache Kit
Timestamp (UTC): 20250916-022017Z

Files:
- Run-BPOE-CoCache-Kit.ps1  -> main entrypoint; updates CoCache docs + hooks, pushes a branch, opens PR.
- BPOE-Cleanup.ps1          -> removes temp kit folders from %TEMP%.

How to run (PowerShell):
1) Expand the zip anywhere or use the two-line CoPing I provided.
2) Run:
   pwsh -NoProfile -ExecutionPolicy Bypass -File .\Run-BPOE-CoCache-Kit.ps1
   # Add -SkipPR if you don't want a PR opened automatically.