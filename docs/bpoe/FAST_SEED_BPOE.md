# FAST-SEED BPOE — 2025-10-10 15:49:03
- Seed to **main** quickly; squash-merge handover branches; delete branch.
- Use **gh --auto** when checks exist; **--admin** only when explicitly needed.
- Logs push with: git push origin HEAD (avoid upstream name mismatches).
- Scripts must print a green **DONE** sentinel on success.
- On any red: **stop + CoPong**; CoPanic captures error+git state to repo.
- Never rely on chat memory: INTENT/BPOE go under docs/advicebombs/ and docs/bpoe/.
- Orchestrate repos via ops/CoSuite/Invoke-CoSuiteSeed.ps1.

