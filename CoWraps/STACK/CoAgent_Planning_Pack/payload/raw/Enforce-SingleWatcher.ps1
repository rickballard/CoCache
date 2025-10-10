Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
param([string[]]$Sessions=@('co-planning','co-migrate'))
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null

# Clean panel records: drop dead PIDs, keep newest per name
$panelDir = Join-Path $root 'panels'
$recs = Get-ChildItem "$panelDir\*.json" -ErrorAction SilentlyContinue | ForEach-Object {
  try { $j = Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json; $j | Add-Member file $_.FullName -Force; $j } catch {}
}
$alive = foreach($r in $recs){ if (Get-Process -Id $r.pid -ErrorAction SilentlyContinue) { $r } else { Remove-Item -LiteralPath $r.file -Force } }
$alive | Group-Object name | ForEach-Object {
  $keep = $_.Group | Sort-Object ts -Descending | Select-Object -First 1
  $_.Group | Where-Object { $_ -ne $keep } | ForEach-Object { Remove-Item -LiteralPath $_.file -Force }
}

# Ensure single watcher per session
foreach($sid in $Sessions){
  $jn = "CoQueueWatcher-$sid"
  $jobs = @(Get-Job -Name $jn -ErrorAction SilentlyContinue)
  if ($jobs.Count -gt 1) { $jobs | Select-Object -Skip 1 | Remove-Job -Force -ErrorAction SilentlyContinue }
  if (-not (Get-Job -Name $jn -ErrorAction SilentlyContinue)) {
    $pname = if ($sid -eq 'co-planning') { 'Planning' } elseif ($sid -eq 'co-migrate') { 'Migrate' } else { $sid }
    Start-CoQueueWatcherJob -SessionId $sid -PanelName $pname
  }
}

& (Join-Path $root 'scripts\Status-QuickCheck.ps1')
