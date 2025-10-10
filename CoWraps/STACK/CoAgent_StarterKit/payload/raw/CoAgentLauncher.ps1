param([switch]$OpenBrowser,
  [string[]]$ExtraTabs = @(
    "https://github.com/CoCivium/CoCivium/blob/main/README.md",
    "https://github.com/CoCivium/CoCivium/blob/main/ISSUEOPS.md"
  ))
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1')  # autoloads commons

if (-not (Get-Command Start-CoQueueWatcherJob -ErrorAction SilentlyContinue)) {
  . (Join-Path (Join-Path $root 'common') 'CoWatcher.ps1')
}
if (-not (Get-Command Register-CoPanel -ErrorAction SilentlyContinue)) {
  . (Join-Path (Join-Path $root 'common') 'CoPanels.ps1')
}
if (-not (Get-Command Send-CoNote -ErrorAction SilentlyContinue)) {
  . (Join-Path (Join-Path $root 'common') 'NoteBridge.ps1')
}

$pairs = @(@{ Name='Planning'; Id='co-planning' }, @{ Name='Migrate'; Id='co-migrate' })
foreach($p in $pairs){ try { Register-CoPanel -Name $p.Name -SessionId $p.Id | Out-Null } catch {}; Start-CoQueueWatcherJob -SessionId $p.Id -PanelName $p.Name }

try { Send-CoNote -ToSessionId 'co-migrate' -Text "Planning says hi. Sync link up." } catch {}
try { Send-CoNote -ToSessionId 'co-planning' -Text "Migrate says hi. Sync link up." } catch {}

function Open-CoChats { param([string]$ChatUrl = "https://chat.openai.com", [switch]$AlsoOpenDocs, [string[]]$DocsTabs)
  try { Start-Process $ChatUrl; Start-Sleep -Milliseconds 250; Start-Process $ChatUrl } catch {}
  $greetDir = Join-Path $HOME 'Downloads\CoTemp\greetings'; $null = New-Item -ItemType Directory -Force -Path $greetDir | Out-Null
  $g1 = Get-Content -Raw -LiteralPath (Join-Path $greetDir 'GREETING_Planning.txt'); try { Set-Clipboard -Value $g1 } catch {}
  if ($AlsoOpenDocs -and $DocsTabs) { foreach($u in $DocsTabs){ try { Start-Process $u } catch {} } }
  Write-Host "Opened two Chat tabs. Clipboard primed with PLANNING greeting." -ForegroundColor Yellow
}

if ($OpenBrowser) { Open-CoChats -AlsoOpenDocs -DocsTabs $ExtraTabs }

function Get-CoAgentStatus {
  $db = @(Get-CoPanels)
  $rows = foreach($r in $db){
    $in = (Get-ChildItem -LiteralPath $r.inbox  -Filter '*.ps1' -ErrorAction SilentlyContinue).Count
    $ou = (Get-ChildItem -LiteralPath $r.outbox -Filter '*.ps1' -ErrorAction SilentlyContinue).Count
    $lg = (Get-ChildItem -LiteralPath $r.logs   -Filter '*.txt' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -desc | Select-Object -First 1)
    [pscustomobject]@{ name=$r.name; session=$r.session_id; pid=$r.pid; inbox_ps1=$in; outbox_ps1=$ou; last_log=($lg.Name) }
  }
  $jobs = Get-Job | Where-Object { $_.Name -like 'CoQueueWatcher-*' } | Select-Object Name, State, HasMoreData
  $rows | Format-Table -AutoSize; "`nJobs:"; $jobs | Format-Table -AutoSize
}
