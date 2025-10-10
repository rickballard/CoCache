Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\\CoPanels.ps1') | Out-Null } catch {}

# Smoke DO
Drop-CoDO -To 'co-migrate' -Title 'DO-Smoke' -Body @"
"Smoke test at $(Get-Date -Format o)"
$($PSVersionTable.PSVersion)
"@

# RepoScan DO (uses your fixed generator)
& (Join-Path (Join-Path $HOME 'Downloads\\CoAgent_Hotfix_RepoScan_UTF8') 'scripts\\New-DO-RepoScan-ReadOnly.ps1') | Out-Null

# Tail latest logs
$S = Join-Path $HOME 'Downloads\\CoTemp\\sessions\\co-migrate\\logs'
"`n--- Latest Smoke ---"
Get-ChildItem "$S\\DO_DO-Smoke_*.txt" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Desc | Select-Object -First 1 | % { Get-Content $_.FullName -Tail 30 }
"`n--- Latest RepoScan ---"
Get-ChildItem "$S\\DO_RepoScan_ReadOnly_*.txt" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Desc | Select-Object -First 1 | % { Get-Content $_.FullName -Tail 50 }
