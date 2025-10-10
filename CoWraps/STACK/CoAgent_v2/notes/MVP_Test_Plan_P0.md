# MVP Test Plan (P0)

Each test must PASS twice with logs attached.

P0 Hello (no writes)
- Steps: Run DO_00_Hello.ps1.
- Pass: Prints timestamp and PS version; no writes/network.

P1 File stability gate
- Steps: Background writer chunks a file; Wait-ForStableFile returns True.
- Pass: 'Stable? True' within timeout; size+hash stop changing.

P2 Repo mutex
- Steps: Two concurrent runs attempt to acquire same repo lock.
- Pass: One acquires; the other waits/defers and logs 'mutex busy'. No interleaved commits.

P3 ReadOnly default
- Steps: Run write DO with consent denied; then rerun with COAGENT_ALLOW_WRITES=1.
- Pass: First run logs 'WOULD WRITE'; second warns 'WROTE'.

P4 Per-run logging
- Steps: Execute any DO; verify log.txt and log.json created per run.
- Pass: Required fields present (see Logging_Design.md) and free of secrets.

P5 Header parser validation
- Steps: Valid sample passes; malformed header fails with clear errors.
- Pass: Detect title, repo.path, risk.*, consent.*, marker line.

P6 Rollback drill
- Steps: Commit then throw; execute rollback instruction; verify HEAD moved back.
- Pass: Working tree clean; run logs contain rollback steps.

P7 Network gating
- Steps: Network DO with consent denied then allowed.
- Pass: 'WOULD FETCH' then 'FETCHING... OK'.
