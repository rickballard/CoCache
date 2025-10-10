# Ops Quickstart

### Bring-up (clean)
```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
Get-ChildItem -LiteralPath "$HOME\Downloads\CoTemp" -Recurse -Filter *.ps1 | Unblock-File

& "$HOME\Downloads\CoTemp\CoAgentLauncher.ps1" -OpenBrowser
& "$HOME\Downloads\CoTemp\scripts\Status-QuickCheck.ps1"
```

### Enforce single watcher + tidy panels
```powershell
& "$HOME\Downloads\CoAgent_Planning_Sprint1\scripts\Enforce-SingleWatcher.ps1"
```

### Queue tests
```powershell
# Smoke
Drop-CoDO -To 'co-migrate' -Title 'DO-Smoke' -Body @"
"Smoke test at $(Get-Date -Format o)"
$($PSVersionTable.PSVersion)
"@

# RepoScan (read-only)
& "$HOME\Downloads\CoAgent_Hotfix_RepoScan_UTF8\scripts\New-DO-RepoScan-ReadOnly.ps1"
```
