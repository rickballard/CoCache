# CoAgent Quick Start (paste into your README)

1) **Install prerequisites (once):**
   - PowerShell 7+ (pwsh), Git, GitHub CLI (`gh`), Git.
2) **Setup GitHub + repo:**
   ```powershell
   pwsh -ExecutionPolicy Bypass -File tools\Setup-GitHub.ps1 -Owner "<yourUser>" -Repo "CoAgent" -Public -RelaxProtections -EnablePages
   ```
3) **Run product UX:**
   ```powershell
   pwsh -ExecutionPolicy Bypass -File tools\Run-CoAgent.ps1 -BaseUrl "https://<yourUser>.github.io/CoAgent" -OpenGuides
   ```
4) **Smoke test (optional):**
   ```powershell
   pwsh -File tools\Test-MVP.ps1
   ```
