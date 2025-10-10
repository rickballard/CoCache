# CoWrap – CoAgent Next Session

This bundle sets up:
- Distinct taskbar shortcuts (PowerShell 7, CoAgent Panel, 2‑tab Dev Terminal) with cat icons.
- Rainbow `EndOfSet` banner.
- Safe PS7‑only `ChatGPT:` dropper (Enter key handler), guarded behind PSReadLine checks.
- Electron builder icon path (`build.icon = build/icon.ico`).

## Quick Start (PowerShell 7)
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
& "$PWD/Do-All.ps1" -SessionName "Productize backchatter"
```

If you only want shortcuts + icons:
```powershell
& "$PWD/Install-Icons-And-Shortcuts.ps1" -SessionName "Productize backchatter"
```

If Electron is present at `~/Documents/GitHub/CoAgent/electron`, rebuild to apply the app icon:
```powershell
pushd "$HOME\Documents\GitHub\CoAgent\electron"
& "$env:ProgramFiles\nodejs\npx.cmd" electron-builder -w dir
popd
```

## Files
- Do-All.ps1 — runs everything (profile hardening, banners, icons/shortcuts).
- Install-Icons-And-Shortcuts.ps1 — create the three shortcuts and set app icon path.
- Patch-Section-Banners.ps1 — rainbow top/bottom with centered label; includes colorblind mode.
- Repair-Profile-EnterKey.ps1 — safe Enter handler for `ChatGPT:` lines (PS7+ only).
- CatFace.ico / CatPaw.ico / CatEye.ico — icons.
