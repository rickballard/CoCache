# CoAgent Packaging Snippets (Starter)

This bundle gives you starting points for packaging and post‑install verification.
It’s **not a finished package**—fill in the placeholders and commit these into your repo.

## Contents
- `winget/README.md` — overview of WinGet packaging and a minimal multi‑file manifest example.
- `choco/coagent.nuspec` — Chocolatey nuspec template with placeholders.
- `scripts/Install-CoAgentRuntime.ps1` — safe, local-only installer that lays down the CoTemp runtime.
- `scripts/PostInstall-Smoke.ps1` — queues a simple DO and tails a log to verify the runtime.
- `scripts/Fix-GreetingsEncoding.ps1` — normalizes greeting text files to UTF‑8 and sets console to UTF‑8.
- `docs/README_PACKAGING.md` — quick guide and next steps checklist.

## Suggested flow (local testing)
1. Run `scripts/Install-CoAgentRuntime.ps1 -From <unzipped runtime path> -To "$HOME\Downloads\CoTemp"`.
2. Run `scripts/PostInstall-Smoke.ps1` to validate the watcher and DO path.
3. When ready, adapt `winget` and/or `choco` templates to point to your signed ZIP artifacts.
4. Add a CI job to build the ZIP and run the post‑install smoke on a clean VM.

-- end --
