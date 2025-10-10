CoAgent Backend Interceptor Pack
================================

What this pack does
- Adds a *dev-only* backend "interceptor" config under your CoAgent repo.
- Provides a tiny local mock backend you can start on a port (default 7681) so the Electron shell has something to talk to while offline.
- Makes no permanent changes to your system and is safe to remove.

Quick start
1) Apply to your repo (replace the path as needed):
   pwsh -NoProfile -ExecutionPolicy Bypass -File "<DL>\CoAgent-Backend-Interceptor-Pack\scripts\Apply-Backend-Interceptor.ps1" -RepoPath "$HOME\Documents\GitHub\CoAgent"

2) (Optional) Start a minimal mock backend:
   pwsh -NoProfile -ExecutionPolicy Bypass -File "<DL>\CoAgent-Backend-Interceptor-Pack\scripts\Start-StaticBackend.ps1" -Port 7681

3) Launch the app (example):
   $env:COAGENT_FORCE_LOCAL = '1'
   & "$HOME\Documents\GitHub\CoAgent\tools\Pair-CoSession.ps1"

Notes
- The mock backend only serves a small set of endpoints and is for UI bootstrapping; use the real backend for full features.
- You can remove all files created by this pack with Remove-Backend-Interceptor.ps1.
