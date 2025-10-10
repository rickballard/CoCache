Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path ($env:COCACHE_LOCAL ?? (Join-Path $HOME 'Downloads/CoCacheLocal')) 'sessions'
$logs = Get-ChildItem $root -Recurse -Filter 'log.ndjson' -ErrorAction SilentlyContinue
if (-not $logs) { Write-Host "No logs yet."; return }
$events = New-Object System.Collections.Generic.List[object]
foreach($f in $logs){
  Get-Content $f.FullName -ReadCount 200 | ForEach-Object {
    foreach($line in $_){
      if ($line -and $line.Trim().Length -gt 0) {
        try { $events.Add( ($line | ConvertFrom-Json) ) } catch {}
      }
    }
  }
}
$byAgent = $events | Group-Object agent
foreach($g in $byAgent){
  $last = $g.Group | Select-Object -Last 1
  "{0}: {1} events; last {2} @ {3}" -f ($g.Name ?? 'U'), $g.Count, $last.type, $last.ts | Write-Host
}
