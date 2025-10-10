Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}

# Smoke DO
Drop-CoDO -To 'co-migrate' -Title 'DO-Smoke' -Body @"
"Smoke test at $(Get-Date -Format o)"
$($PSVersionTable.PSVersion)
"@

# RepoScan DO (read-only)
$repo = Join-Path $HOME 'Desktop\CoAgent_SandboxRepo'
if (-not (Test-Path $repo)) { New-Item -ItemType Directory -Force -Path $repo | Out-Null }
$t = Resolve-CoTarget -To 'co-migrate'
$name = "DO_RepoScan_ReadOnly_{0}.ps1" -f (Get-Date -Format 'HHmmss')
$dest = Join-Path $t.inbox $name
$script = @"
# [PASTE IN POWERSHELL]
"RepoScan (read-only) at $(Get-Date -Format o)"
Get-ChildItem -LiteralPath "$repo" -Recurse -File -ErrorAction SilentlyContinue |
  Select-Object FullName, Length, LastWriteTime -First 50
"@
Set-Content -LiteralPath $dest -Encoding UTF8 -Value $script
"Queued RepoScan -> $dest"

# Tail latest logs
$S = Join-Path $HOME 'Downloads\CoTemp\sessions\co-migrate\logs'
"`n--- Latest Smoke ---"
Get-ChildItem "$S\DO_DO-Smoke_*.txt" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Desc | Select-Object -First 1 | % { Get-Content $_.FullName -Tail 30 }
"`n--- Latest RepoScan ---"
Get-ChildItem "$S\DO_RepoScan_ReadOnly_*.txt" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Desc | Select-Object -First 1 | % { Get-Content $_.FullName -Tail 50 }
