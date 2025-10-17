param(
  [string]$Root = "$HOME\Documents\GitHub\CoCache"
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

function Parse-Line([string]$line){
  # "2025-10-17 16:21:46Z,memMB=85.3,handles=578,fsMs=7,zips=7,diagrams=9,handoff=HANDOFF.md"
  $parts = $line.Split(',',2)
  if($parts.Count -lt 2){ return $null }
  $obj = @{ ts = $parts[0].Trim() }
  foreach($kv in $parts[1].Split(',')){
    if(-not $kv){ continue }
    $p = $kv.Split('=',2)
    if($p.Count -eq 2){ $obj[$p[0]] = $p[1] }
  }
  return [pscustomobject]$obj
}

$regPath = Join-Path $Root "metrics\registry.json"
if(!(Test-Path $regPath)){ throw "Missing registry: $regPath" }
$registry = Get-Content $regPath -Raw | ConvertFrom-Json
$latestAll = @{}

foreach($m in $registry){
  $logRel  = $m.log_path
  $logPath = Join-Path $Root $logRel
  if(!(Test-Path $logPath)){ throw "Missing metric log: $logRel" }

  $last = Get-Content $logPath | Select-Object -Last 1
  $row  = Parse-Line $last
  if($null -eq $row){ continue }

  # latest.json payload
  $latestAll[$m.id] = $row

  # history CSV (header on create)
  $hist = Join-Path $Root ("metrics\history\{0}.csv" -f $m.id)
  $hasHeader = Test-Path $hist
  $cols = @("ts") + ($m.fields | Where-Object { $_ -ne "ts" })
  if(-not $hasHeader){
    ($cols -join ",") | Set-Content -Encoding UTF8 $hist
  }
  $vals = $cols | ForEach-Object { $row.$_ }
  $line = ($vals -join ",")
  Add-Content -Encoding UTF8 $hist $line

  # trim > 90 days
  $cutoff = (Get-Date).ToUniversalTime().AddDays(-90)
  $rows = Get-Content $hist
  if($rows.Count -gt 1){
    $hdr = $rows[0]
    $kept = @($hdr)
    foreach($r in $rows[1..($rows.Count-1)]){
      $ts = ($r.Split(',')[0])
      if([datetime]::TryParse($ts, [ref]([datetime]$null))){
        $dt = [datetime]::Parse($ts).ToUniversalTime()
        if($dt -ge $cutoff){ $kept += $r }
      } else { $kept += $r }
    }
    $kept | Set-Content -Encoding UTF8 $hist
  }
}

$latestPath = Join-Path $Root "metrics\latest.json"
($latestAll | ConvertTo-Json -Depth 6) | Set-Content -Encoding UTF8 $latestPath
Write-Host "✅ Harvested -> $latestPath"
