param([string]$OutDir = (Join-Path $HOME ("Desktop\CoAgent_Sprint1_Snapshot_{0}" -f (Get-Date -Format 'yyyyMMdd-HHmmss'))))
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\CoPanels.ps1') | Out-Null } catch {}
$null = New-Item -ItemType Directory -Force -Path $OutDir

# Panels
$panels = @()
$panelfiles = Get-ChildItem -LiteralPath (Join-Path $root 'panels') -Filter *.json -ErrorAction SilentlyContinue
foreach ($f in $panelfiles) {
  try {
    $rec = Get-Content -Raw -LiteralPath $f.FullName | ConvertFrom-Json
    $alive = $false
    if ($rec.pid) { $alive = [bool](Get-Process -Id $rec.pid -ErrorAction SilentlyContinue) }
    $panels += [pscustomobject]@{
      file=$f.Name; name=$rec.name; session_id=$rec.session_id; pid=$rec.pid; ts=$rec.ts; alive=$alive;
      inbox=$rec.inbox; outbox=$rec.outbox; logs=$rec.logs
    }
  } catch {}
}
$panels | Export-Csv (Join-Path $OutDir 'panels.csv') -NoTypeInformation -Encoding UTF8

# Jobs
Get-Job | Where-Object { $_.Name -like 'CoQueueWatcher-*' } |
  Select-Object Name, State, HasMoreData, Id, @{n='PSBeginTime';e={$_.PSBeginTime}} |
  Export-Csv (Join-Path $OutDir 'jobs.csv') -NoTypeInformation -Encoding UTF8

# Latest log per session
$sessions = @('co-planning','co-migrate')
$latestSumm = @()
foreach ($sid in $sessions) {
  $logs = Join-Path $root "sessions\$sid\logs"
  $latest = Get-ChildItem -LiteralPath $logs -Filter *.txt -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if ($null -ne $latest) {
    Copy-Item -LiteralPath $latest.FullName -Destination (Join-Path $OutDir ("latest-log-$sid.txt")) -Force
    $latestSumm += "Latest $sid log: $($latest.Name)"
  } else {
    $latestSumm += "Latest $sid log: (none)"
  }
}

# Greetings
$gdir = Join-Path $root 'greetings'
Get-ChildItem -LiteralPath $gdir -Filter *.txt -ErrorAction SilentlyContinue |
  ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $OutDir $_.Name) -Force }

# Status summary markdown
$md = @"
# CoAgent Sprint-1 Snapshot
Time: $(Get-Date -Format o)
Root: $root

## Panels
$(($panels | Sort-Object name | Format-Table -AutoSize | Out-String))

## Jobs
$(Get-Content (Join-Path $OutDir 'jobs.csv') | Select-Object -First 5 | Out-String)

## Latest Logs
- $($latestSumm -join "`n- ")
"@
Set-Content -LiteralPath (Join-Path $OutDir 'STATUS_SUMMARY.md') -Encoding UTF8 -Value $md

"Snapshot -> $OutDir"
