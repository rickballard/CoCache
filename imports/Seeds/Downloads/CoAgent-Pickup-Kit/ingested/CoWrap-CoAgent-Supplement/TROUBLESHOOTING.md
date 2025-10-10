# Troubleshooting

**Panel won’t launch / missing CoAgent.exe**
- Re-run: `npx electron-builder -w dir`
- Path: `electron/dist/win-unpacked/CoAgent.exe`

**Exec 127.0.0.1:7681 refused**
- Start Docker Desktop or run `tools/Start-CoExec.ps1` (stub fallback exists).

**Enter key “custom handler” errors**
- Run `Repair-Profile-EnterKey.ps1` (included previously) or copy snippet from the main CoWrap.
- Ensure PS7: `pwsh` → `Shell: Core`.

**Startup console pops up**
- Check `%APPDATA%\...\Startup\CoAgent_Delayed.vbs` — hidden launch flags set to window style 0.
