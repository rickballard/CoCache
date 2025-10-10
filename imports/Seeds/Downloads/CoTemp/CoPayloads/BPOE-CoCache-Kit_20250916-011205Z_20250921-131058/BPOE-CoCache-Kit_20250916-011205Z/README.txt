BPOE-CoCache-Kit
================

This package updates CoCache with BPOE docs and a pre-push blob guard,
creates a timestamped branch, pushes it, and optionally opens a PR.

Included files:
  • Run-BPOE-CoCache-Kit.ps1   – wrapper you execute
  • BPOE-CoCache-Kit.ps1       – main logic
  • BPOE-Cleanup.ps1           – removes CoTemp staging folder (optional)
  • VERSION.txt                – 20250916-011205Z

Safe-by-default design:
  • Timestamped package; idempotent scripts
  • Works offline (no web downloads)
  • Only touches your local CoCache working copy
  • Pre-push hook stops blobs ≥100MB before they hit GitHub

Usage summary (also shown in chat as a 2‑line CoPing):
  1) Extract the zip
  2) Run Run-BPOE-CoCache-Kit.ps1 (supports -SkipPR)
