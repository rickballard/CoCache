
# CoAgent — TRAINING (Guided)

1) Run:
```pwsh
pwsh -ExecutionPolicy Bypass -File tools\Run-CoAgent.ps1
```
2) Review the browser pages (if online): `/`, `/ui-mock/quad.html`, `/status.html`.
3) Generate sample logs:
```pwsh
pwsh -File tools\Generate-MockLogs.ps1
```
4) Inspect metrics:
```pwsh
pwsh -File tools\Analyze-BPOE.ps1
```
This mirrors what a new tester would do with no prior context.
