# requires -Version 7
[CmdletBinding()]
param(
  [switch]$Json,
  [string]$OutDir = (Join-Path $PSScriptRoot '..\health'),
  [int]$IdleMemWarnPct = 80
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$null = New-Item -ItemType Directory -Force $OutDir

function Get-ActiveAV {
  try {
    $s = Get-MpComputerStatus -ErrorAction Stop
    if ($s.AMServiceEnabled) { return 'Microsoft Defender' }
  } catch {}
  try {
    $mb = Get-Service MBAMService -ErrorAction Stop
    if ($mb.Status) { return 'Malwarebytes' }
  } catch {}
  return 'Unknown/None Detected'
}

function Get-NicSummary {
  $a = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} |
       Select-Object Name, LinkSpeed
  $e = Get-NetAdapterStatistics | Select-Object Name, ReceivedErrors, OutboundErrors, ReceivedDiscarded, SentDiscarded
  @{ Adapters = $a; Errors = $e }
}

function Get-StorageSummary {
  $p = Get-PhysicalDisk | Select FriendlyName, MediaType, Size, HealthStatus, OperationalStatus
  $v = Get-PSDrive -PSProvider FileSystem | Select Name,
      @{n='UsedGB';e={[math]::Round($_.Used/1GB,1)}},
      @{n='FreeGB';e={[math]::Round($_.Free/1GB,1)}}
  $trim = (fsutil behavior query DisableDeleteNotify) 2>$null
  @{ Physical = $p; Volumes = $v; TrimRaw = $trim }
}

function Get-ReliabilitySummary {
  try {
    $rel = Get-CimInstance -Namespace root\cimv2 -ClassName Win32_ReliabilityRecords -ErrorAction Stop |
      Where-Object { $_.TimeGenerated -gt (Get-Date).AddDays(-7) }
    $top = $rel | Group-Object -Property SourceName | Sort-Object Count -Descending | Select-Object -First 10
    return $top | Select Name,Count
  } catch { return @() }
}

# CPU/Power
$scheme = (powercfg /GetActiveScheme) -join ' '
$cpuMax = (Get-Counter '\Processor Information(_Total)\% of Maximum Frequency').CounterSamples.CookedValue
$mem   = Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory
$memPctUsed = [math]::Round((($mem.TotalVisibleMemorySize - $mem.FreePhysicalMemory)/$mem.TotalVisibleMemorySize)*100,1)

# Storage/Network/AV
$stor = Get-StorageSummary
$nic  = Get-NicSummary
$av   = Get-ActiveAV

# Basic verdicts
$issues = @()
if ($cpuMax -lt 95) { $issues += ("CPU MaxFrequency reported {0:n1}% (<95%). Check power plan / thermals." -f $cpuMax) }
$stor.Volumes | ForEach-Object {
  $total = $_.UsedGB + $_.FreeGB
  if ($total -gt 0 -and $_.FreeGB -lt ($total*0.20)) { $issues += ("{0}: low free space ({1} GB)" -f $_.Name, $_.FreeGB) }
}
if ($memPctUsed -gt $IdleMemWarnPct) { $issues += "Memory high at idle: ${memPctUsed}%" }

$report = [ordered]@{
  Timestamp = (Get-Date).ToString('s')
  PowerPlan = $scheme
  CpuMaxFrequencyPct = [math]::Round($cpuMax,1)
  MemoryUsedPct = $memPctUsed
  ActiveAV = $av
  Storage = $stor
  Network = $nic
  ReliabilityTop = Get-ReliabilitySummary
  Issues = $issues
  Verdict = if ($issues.Count -eq 0) { 'PASS' } else { 'WARN' }
}

# Markdown
$nl = "`r`n"
$md = @()
$md += "# HealthGate Report"
$md += "*Time:* $(Get-Date)"
$md += "*Verdict:* **$($report.Verdict)**"
$md += ""
$md += "## Power/CPU"
$md += "- Plan: `$($report.PowerPlan)`"
$md += ("- Max Frequency: {0}%" -f $report.CpuMaxFrequencyPct)
$md += ("- Memory used: {0}%" -f $report.MemoryUsedPct)
$md += ""
$md += "## Storage"
foreach($d in $report.Storage.Physical){
  $md += ("- {0}: {1} {2}GB, {3}/{4}" -f $d.FriendlyName, $d.MediaType, [math]::Round($d.Size/1GB), $d.HealthStatus, $d.OperationalStatus)
}
$md += "Volumes:"
foreach($v in $report.Storage.Volumes){
  $md += ("  - {0}: Used {1} GB, Free {2} GB" -f $v.Name, $v.UsedGB, $v.FreeGB)
}
$md += ""
$md += "## Network"
foreach($a in $report.Network.Adapters){
  $md += ("- {0}: {1}" -f $a.Name, $a.LinkSpeed)
}
$md += "Errors:"
foreach($e in $report.Network.Errors){
  $md += ("- {0}: RXErr={1} TXErr={2} RXDrop={3} TXDrop={4}" -f $e.Name,$e.ReceivedErrors,$e.OutboundErrors,$e.ReceivedDiscarded,$e.SentDiscarded)
}
$md += ""
$md += "## Active AV"
$md += ("- {0}" -f $report.ActiveAV)
$md += ""
$md += "## Reliability (7d Top offenders)"
foreach($r in $report.ReliabilityTop){
  $md += ("- {0}: {1}" -f $r.Name, $r.Count)
}
$md += ""
$md += "## Issues"
if ($report.Issues.Count) { foreach($i in $report.Issues){ $md += ("- {0}" -f $i) } } else { $md += "- None" }

$mdPath = Join-Path $OutDir "HealthGateReport.md"
$jsPath = Join-Path $OutDir "HealthGateReport.json"
$md -join $nl | Set-Content $mdPath -Encoding UTF8
$report | ConvertTo-Json -Depth 6 | Set-Content $jsPath -Encoding UTF8

if ($Json) { $report | ConvertTo-Json -Depth 6 } else { Write-Host "Report written:`n$mdPath`n$jsPath"; if ($report.Verdict -ne 'PASS') { exit 2 } }
