
# BPOE — Minimal Local Metrics

Input: newline-delimited JSON (`.jsonl`) in `.coagent/logs`.
Fields used (optional): `user`, `intent`, `session_id`.

Run:
```pwsh
pwsh -File tools\Analyze-BPOE.ps1
```

Outputs simple counts + “top” summaries. Replace with your pipeline later.
