param(
  [string]$CoTempRoot = (Join-Path $HOME "Downloads\\CoTemp"),
  [switch]$StartTickerIfMissing = $true,
  [switch]$TryStartWatchers     = $true
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$logDir = Join-Path $CoTempRoot 'logs'; New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$log    = Join-Path $logDir 'ensure-backchannel.log'
function Log([string]$m){ $line = "[{0}] {1}" -f (Get-Date -Format o),$m; $line | Add-Content -LiteralPath $log; Write-Host "[BPOE] $m" }

# Ensure core folders
$need=@('inbox','outbox','notes','logs','panels','coticker\inbox','coticker\processed')
$need | ForEach-Object { New-Item -ItemType Directory -Force -Path (Join-Path $CoTempRoot $_) | Out-Null }
Log "Ensured CoTemp folders"

# Detect CoTicker overlay; start if desired
$send  = Join-Path $CoTempRoot 'tools\CoTicker\Send-CoTickerEvent.ps1'
$start = Join-Path $CoTempRoot 'tools\CoTicker\Start-CoTicker.ps1'
$hasTickerProc = Get-CimInstance Win32_Process | Where-Object {
  $_.Name -match 'pwsh|powershell' -and ($_.CommandLine -match 'Start-CoTicker\.ps1')
}
if (!$hasTickerProc -and $StartTickerIfMissing -and (Test-Path $start)) {
  Start-Process -WindowStyle Hidden -FilePath (Get-Command pwsh -ErrorAction SilentlyContinue).Path `
    -ArgumentList @('-NoProfile','-File',$start,'-ClickThrough') -ErrorAction SilentlyContinue | Out-Null
  Log "Started CoTicker overlay"
}

# Detect watchers (very heuristic)
$watcherProcs = Get-CimInstance Win32_Process | Where-Object {
  $_.Name -match 'pwsh|powershell' -and ($_.CommandLine -match 'Watch-CoTemp|Start-CoWatchers|CoPanels')
}
if ($watcherProcs) {
  Log ("Watchers look active: {0}" -f ($watcherProcs.Count))
} elseif ($TryStartWatchers) {
  # Try to find a Start-CoWatchers script in likely places
  $candidates = @(
    (Join-Path $repo 'runtime\original-scripts\Start-CoWatchers.ps1'),
    (Join-Path $repo 'tools\legacy\CoAgent_v2\runtime\original-scripts\Start-CoWatchers.ps1'),
    (Get-ChildItem $repo -Recurse -Filter 'Start-CoWatchers.ps1' -ErrorAction SilentlyContinue | Select-Object -First 1 -Expand FullName)
  ) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -Unique
  if ($candidates) {
    $startWatch = $candidates | Select-Object -First 1
    Start-Process -WindowStyle Hidden -FilePath (Get-Command pwsh -ErrorAction SilentlyContinue).Path `
      -ArgumentList @('-NoProfile','-File',$startWatch) -ErrorAction SilentlyContinue | Out-Null
    Log "Launched watchers via $startWatch"
  } else {
    Log "No Start-CoWatchers.ps1 found; skipping auto-start"
  }
}

# Heartbeat note (lets sessions/watcher react)
$notes = Join-Path $CoTempRoot 'notes'
$evt=[ordered]@{kind='note';to='co-planning';from='ensure';ts=(Get-Date -Format o);text="heartbeat"}
$path=Join-Path $notes ("note_{0}.json" -f (Get-Date -Format 'yyyyMMdd-HHmmss'))
($evt|ConvertTo-Json -Depth 5)|Set-Content -LiteralPath $path -Encoding UTF8
Log "Heartbeat note -> $path"

# Friendly ticker ping if available
if (Test-Path $send) { & $send -Type block -Text "Backchannel ensure ✔" -Icon "✓" -Fg "LawnGreen" | Out-Null }
