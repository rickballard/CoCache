Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = (Get-Location).Path
$dir  = Join-Path $root ".coagent\logs"
if (!(Test-Path $dir)) { Write-Host "ℹ️ No logs at $dir"; exit 0 }
$files = Get-ChildItem $dir -Filter *.jsonl -ErrorAction SilentlyContinue
if (!$files) { Write-Host "ℹ️ No logs at $dir"; exit 0 }

$total=0; $lat=@(); $sat=@(); $routes=@{}
foreach($f in $files){
  Get-Content $f | ForEach-Object {
    if (-not $_) { return }
    try {
      $j = $_ | ConvertFrom-Json
      $total++
      if ($j.latency_ms) { $lat += [int]$j.latency_ms }
      if ($j.satisfaction) { $sat += [int]$j.satisfaction }
      $r = ($j.route ? $j.route : "unknown")
      if (-not $routes.ContainsKey($r)){ $routes[$r]=0 }
      $routes[$r]++
    } catch {}
  }
}

function Median($arr){ if(!$arr){ return $null } $s=$arr|Sort-Object; $n=$s.Count; if($n%2){$s[[int]($n/2)]}else{ [int](($s[$n/2-1]+$s[$n/2])/2) } }
$avgSat = if($sat){ [Math]::Round(($sat | Measure-Object -Average).Average,2) } else { $null }
$medLat = Median $lat

"---- BPOE Snapshot ----"
"events: $total"
"median_latency_ms: $medLat"
"avg_satisfaction: $avgSat"
"routes:"
$routes.GetEnumerator() | Sort-Object Name | ForEach-Object { "  $_" }
"-----------------------"
