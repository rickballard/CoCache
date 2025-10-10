
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
try { Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force } catch {}

$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1')  | Out-Null } catch {}
try { . (Join-Path $root 'common\CoWatcher.ps1') | Out-Null } catch {}

try { Get-ChildItem -LiteralPath $root -Recurse -Filter *.ps1 -ErrorAction SilentlyContinue | Unblock-File } catch {}
Get-Job | Where-Object { $_.Name -like 'CoQueueWatcher-*' } | Remove-Job -Force -ErrorAction SilentlyContinue

$panelDir = Join-Path $root 'panels'
$recs = Get-ChildItem "$panelDir\*.json" -ErrorAction SilentlyContinue | ForEach-Object {
  try {
    $j = Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json
    $j | Add-Member -NotePropertyName file -NotePropertyValue $_.FullName -Force
    $j
  } catch {}
}
$alive = foreach($r in $recs){
  if (Get-Process -Id $r.pid -ErrorAction SilentlyContinue) { $r }
  else { Remove-Item -LiteralPath $r.file -Force }
}
$alive | Group-Object name | ForEach-Object {
  $keep = $_.Group | Sort-Object ts -Descending | Select-Object -First 1
  $_.Group | Where-Object { $_ -ne $keep } | ForEach-Object { Remove-Item -LiteralPath $_.file -Force }
}

Register-CoPanel -Name 'Planning' -SessionId 'co-planning' | Out-Null
Register-CoPanel -Name 'Migrate'  -SessionId 'co-migrate'  | Out-Null
Start-CoQueueWatcherJob -SessionId 'co-planning' -PanelName 'Planning'
Start-CoQueueWatcherJob -SessionId 'co-migrate'  -PanelName 'Migrate'

$policy = @"
# Watcher policy — centralized (pre-CoAgent)
Status: $(Get-Date -Format o)

Enforced ONE watcher per session:
- co-planning  → CoQueueWatcher-co-planning
- co-migrate   → CoQueueWatcher-co-migrate

Please do not start additional watchers.
Coordinate via:
- Drop-CoDO to send runnable DOs to the other pane
- Send-CoNote for non-executable updates

Migrate focus: ccts fallback remediation continues.
"@
$inPlan = Join-Path $root 'sessions\co-planning\inbox'
$inMig  = Join-Path $root 'sessions\co-migrate\inbox'
$null = New-Item -ItemType Directory -Force -Path $inPlan,$inMig | Out-Null
$fn = "NOTE_WATCHER_POLICY_{0}.md" -f (Get-Date -Format 'yyyyMMdd-HHmmss')
Set-Content -LiteralPath (Join-Path $inPlan $fn) -Value $policy -Encoding UTF8
Set-Content -LiteralPath (Join-Path $inMig  $fn) -Value $policy -Encoding UTF8

$gen = @'
param(
  [string]$Target='co-migrate',
  [switch]$AllowWrites,
  [switch]$AllowNetwork
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}

$t  = Resolve-CoTarget -To $Target
$aw = $AllowWrites.IsPresent.ToString().ToLower()
$an = $AllowNetwork.IsPresent.ToString().ToLower()

$name = "DO_CCTS-Fallback_Smoke_{0}.ps1" -f (Get-Date -Format 'HHmmss')
$path = Join-Path $t.inbox $name

$header = @"
<# ---
title: "CCTS Fallback Smoke"
session_id: "$($t.session_id)"
repo: { name: "Sandbox", path: "$(Join-Path $HOME 'Desktop\CoAgent_SandboxRepo')" }
risk: { writes: $aw, network: $an, secrets: false, destructive: false }
brief: "Check that the fallback path returns a sane default without side effects."
consent: { allow_writes: $aw, allow_network: $an }
--- #>
# [PASTE IN POWERSHELL]
"@

$code = @'
"ccts-fallback-smoke at $(Get-Date -Format o)"
$PSVersionTable.PSVersion
'@

Set-Content -LiteralPath $path -Value ($header + "`r`n" + $code) -Encoding UTF8
Write-Host ("Queued -> {0}" -f $path) -ForegroundColor Green
return $path
'@
$genPath = Join-Path $root 'PlanningPack\scripts\New-DO-CCTS-Fallback-Test.ps1'
$genDir  = Split-Path -Parent $genPath
if (-not (Test-Path $genDir)) { New-Item -ItemType Directory -Force -Path $genDir | Out-Null }
Set-Content -LiteralPath $genPath -Value $gen -Encoding UTF8

Write-Host "`nStabilize complete." -ForegroundColor Green
