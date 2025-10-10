param(
  [string[]]$Sessions = @('co-planning','co-migrate')
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$root = Join-Path $HOME 'Downloads\CoTemp'
if (-not (Test-Path $root)) { throw "CoTemp not found at: $root" }

try { Get-ChildItem -LiteralPath $root -Recurse -Filter *.ps1 | Unblock-File } catch {}
try { Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force } catch {}

. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1')   | Out-Null } catch {}
try { . (Join-Path $root 'common\CoWatcher.ps1')  | Out-Null } catch {}
try { . (Join-Path $root 'common\NoteBridge.ps1') | Out-Null } catch {}

foreach($sid in $Sessions){
  Get-Job -Name ("CoQueueWatcher-{0}" -f $sid) -ErrorAction SilentlyContinue | Remove-Job -Force -ErrorAction SilentlyContinue
}

$panelDir = Join-Path $root 'panels'
$files = Get-ChildItem "$panelDir\*.json" -ErrorAction SilentlyContinue
$recs = foreach($f in $files){
  try {
    $j = Get-Content -Raw -LiteralPath $f.FullName | ConvertFrom-Json
    $j | Add-Member -NotePropertyName file -NotePropertyValue $f.FullName -Force
    $j
  } catch {}
}
$alive = foreach($r in $recs){
  if (Get-Process -Id $r.pid -ErrorAction SilentlyContinue) { $r } else { Remove-Item -LiteralPath $r.file -Force }
}
$alive | Group-Object name | ForEach-Object {
  $keep = $_.Group | Sort-Object ts -Descending | Select-Object -First 1
  $_.Group | Where-Object { $_ -ne $keep } | ForEach-Object { Remove-Item -LiteralPath $_.file -Force }
}

Register-CoPanel -Name 'Planning' -SessionId 'co-planning' | Out-Null
Register-CoPanel -Name 'Migrate'  -SessionId 'co-migrate'  | Out-Null
Start-CoQueueWatcherJob -SessionId 'co-planning' -PanelName 'Planning'
Start-CoQueueWatcherJob -SessionId 'co-migrate'  -PanelName 'Migrate'

$scriptsDir = Join-Path $root 'scripts'
New-Item -ItemType Directory -Force -Path $scriptsDir | Out-Null

$genSmoke = @'
param([string]$Target='co-migrate',[switch]$AllowWrites,[switch]$AllowNetwork)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}
$t = Resolve-CoTarget -To $Target
$name = "DO_Smoke_Minimal_{0}.ps1" -f (Get-Date -Format 'HHmmss')
$path = Join-Path $t.inbox $name
$aw=$AllowWrites.IsPresent.ToString().ToLower(); $an=$AllowNetwork.IsPresent.ToString().ToLower()

$header = @"
<# ---
title: "Smoke Minimal"
session_id: "$($t.session_id)"
repo: { name: "Sandbox", path: "$(Join-Path $HOME 'Desktop\CoAgent_SandboxRepo')" }
risk: { writes: $aw, network: $an, secrets: false, destructive: false }
brief: "Prints a timestamp and PS version. No side effects."
consent: { allow_writes: $aw, allow_network: $an }
--- #>
"@

$body = @'
# [PASTE IN POWERSHELL]
"Smoke test at $(Get-Date -Format o)"
$PSVersionTable.PSVersion
'@

Set-Content -LiteralPath $path -Value ($header + "`r`n" + $body) -Encoding UTF8
Write-Host ("Queued -> {0}" -f $path) -ForegroundColor Green
return $path
'@
Set-Content -LiteralPath (Join-Path $scriptsDir 'New-DO-Smoke-Minimal.ps1') -Encoding UTF8 -Value $genSmoke

$genCcts = @'
param([string]$Target='co-migrate',[switch]$AllowWrites,[switch]$AllowNetwork)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}
$t = Resolve-CoTarget -To $Target
$name = "DO_CCTS-Fallback_Smoke_{0}.ps1" -f (Get-Date -Format 'HHmmss')
$path = Join-Path $t.inbox $name
$aw=$AllowWrites.IsPresent.ToString().ToLower(); $an=$AllowNetwork.IsPresent.ToString().ToLower()

$header = @"
<# ---
title: "CCTS Fallback Smoke"
session_id: "$($t.session_id)"
repo: { name: "Sandbox", path: "$(Join-Path $HOME 'Desktop\CoAgent_SandboxRepo')" }
risk: { writes: $aw, network: $an, secrets: false, destructive: false }
brief: "Check fallback path returns a sane default without side effects."
consent: { allow_writes: $aw, allow_network: $an }
--- #>
"@

$body = @'
# [PASTE IN POWERSHELL]
"ccts-fallback-smoke at $(Get-Date -Format o)"
$PSVersionTable.PSVersion
'@

Set-Content -LiteralPath $path -Value ($header + "`r`n" + $body) -Encoding UTF8
Write-Host ("Queued -> {0}" -f $path) -ForegroundColor Green
return $path
'@
Set-Content -LiteralPath (Join-Path $scriptsDir 'New-DO-CCTS-Fallback-Test.ps1') -Encoding UTF8 -Value $genCcts

$policy = @"
# Watcher policy — centralized (pre-CoAgent)
Status: $(Get-Date -Format o)

We enforce **ONE watcher per session**:
- co-planning  → CoQueueWatcher-co-planning (background job)
- co-migrate   → CoQueueWatcher-co-migrate  (background job)

Please do **not** start additional watchers.
Coordinate via Drop-CoDO (runnable) and Send-CoNote (non-exec).

Migrate focus: **ccts fallback** remediation continues.
"@

$inPlan = Join-Path $root 'sessions\co-planning\inbox'
$inMig  = Join-Path $root 'sessions\co-migrate\inbox'
$null = New-Item -ItemType Directory -Force -Path $inPlan,$inMig | Out-Null
$fn = "NOTE_WATCHER_POLICY_{0}.md" -f (Get-Date -Format 'yyyyMMdd-HHmmss')
Set-Content -LiteralPath (Join-Path $inPlan $fn) -Value $policy -Encoding UTF8
Set-Content -LiteralPath (Join-Path $inMig  $fn) -Value $policy -Encoding UTF8

try { Send-CoNote -ToSessionId 'co-planning' -Text "Planning: central watcher active; coordinate via Drop-CoDO / Send-CoNote." } catch {}
try { Send-CoNote -ToSessionId 'co-migrate'  -Text "Migrate: central watcher active; keep ccts fallback going; use Drop-CoDO / Send-CoNote." } catch {}

$qc = Join-Path $scriptsDir 'Status-QuickCheck.ps1'
if (Test-Path $qc) { & $qc } else { Write-Host "Stabilize complete. Run Status-QuickCheck.ps1 to verify." -ForegroundColor Yellow }
