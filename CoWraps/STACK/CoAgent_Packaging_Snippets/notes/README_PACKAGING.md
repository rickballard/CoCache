# Packaging Guide (Quick)

## Local ZIP (current approach)
- Build a signed ZIP of the Starter Kit (runtime + docs).
- Distribute via GitHub Releases.
- Users run `CoAgentLauncher.ps1 -OpenBrowser` after unzip.

## WinGet (later)
1. Produce versioned ZIP artifact and compute SHA256.
2. Fill the three manifests in `/winget` using your identifiers.
3. Submit PR to `microsoft/winget-pkgs`.

## Chocolatey (later)
1. Drop the ZIP beside `coagent.nuspec` and the `tools/` scripts.
2. `choco pack` then `choco push` (to an org feed first).
3. Installer extracts to `~/Downloads/CoTemp` and leaves user data on uninstall.

## Post‑install Smoke (always)
- Run `scripts/PostInstall-Smoke.ps1` on a fresh VM to verify:
  - Watchers running (1 per session)
  - DO executes and logs
  - No writes/network unless allowed

## Next
- Decide your canonical package id (e.g., `CoCivium.CoAgent`).
- Create CI that builds ZIP and updates manifests automatically.
