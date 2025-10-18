param(
  [string]$CoCache = "$HOME\Documents\GitHub\CoCache",
  [string[]]$Repos = @(
    "$HOME\Documents\GitHub\CoCache",
    "$HOME\Documents\GitHub\InSeed",
    "$HOME\Documents\GitHub\CoCivium",
    "$HOME\Documents\GitHub\CoPolitic",
    "$HOME\Documents\GitHub\CoSteward"
  )
)
$ErrorActionPreference="Stop"; Set-StrictMode -Version Latest

function ReadJsonTable($p){
  if(!(Test-Path $p)){ return $null }
  $raw = Get-Content $p -Raw
  if([string]::IsNullOrWhiteSpace($raw)){ return $null }
  try { return ($raw | ConvertFrom-Json -AsHashtable) } catch { return $null }
}

$indexPath = Join-Path $CoCache "docs\METRICS_INDEX.md"
ni -ItemType Directory -Force (Split-Path $indexPath) | Out-Null

$regArr = ReadJsonTable (Join-Path $CoCache "metrics\registry.json")
$latest = ReadJsonTable (Join-Path $CoCache "metrics\latest.json")

# Normalize registry to array of hashtables
if($null -eq $regArr){ $regArr=@() }
elseif($regArr -isnot [System.Collections.IEnumerable] -or $regArr -is [System.Collections.IDictionary]){
  $regArr = @($regArr)   # single object -> array
}

function GetLatestRow($id){
  if($null -eq $latest){ return $null }
  if($latest.ContainsKey($id)){ return $latest[$id] }
  return $null
}

$lines = @()
$lines += "# CoSuite Metrics & Watchers Index"
$lines += ""
$lines += ("_Generated: {0}Z_" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
$lines += ""
$lines += "## Metrics (from registry)"

if($regArr.Count -gt 0){
  $lines += "| status | id | cadence | latest ts | latest fields | history | log |"
  $lines += "|---|---|---|---|---|---|---|"
  foreach($m in $regArr){
    $id   = $m['id']
    $cad  = $m['cadence']
    $log  = $m['log_path']
    $hist = ("metrics/history/{0}.csv" -f $id)
    $lrow = GetLatestRow $id
    $lts  = if($lrow -and $lrow.ContainsKey('ts')){ $lrow['ts'] } else { "" }

    $lfPairs = @()
    if($lrow){
      foreach($k in $lrow.Keys){ if($k -ne 'ts'){ $lfPairs += ("{0}={1}" -f $k, $lrow[$k]) } }
    }
    $lf = ($lfPairs -join "; ")

    $lines += ("| ![](assets/brand/cocivium_logo_gray_tm.svg) | {0} | {1} | {2} | {3} | [{4}]({4}) | [{5}]({5}) |" -f $id,$cad,$lts,$lf,$hist,$log)
  }
} else {
  $lines += "_No registry found at metrics/registry.json._"
}

$lines += ""
$lines += "## Heartbeats & CoPingPong"
$hbDir = Join-Path $CoCache "docs\HEARTBEATS"
if(Test-Path $hbDir){
  $logs = Get-ChildItem $hbDir -Filter *.log -EA SilentlyContinue
  if($logs){
    foreach($l in $logs){
      $lines += ("- docs/HEARTBEATS/{0} (size: {1} KB, last: {2})" -f $l.Name, [math]::Round($l.Length/1KB,1), $l.LastWriteTimeUtc.ToString('yyyy-MM-ddTHH:mm:ssZ'))
    }
  } else { $lines += "_No heartbeat logs found._" }
} else { $lines += "_No docs/HEARTBEATS/ directory._" }

$lines += ""
$lines += "## Launchers & Jobs (workflows + scripts)"
foreach($r in $Repos){
  if(!(Test-Path $r)){ continue }
  $repoName = Split-Path $r -Leaf
  $lines += ""
  $lines += "### $repoName"

  $wfDir = Join-Path $r ".github\workflows"
  if(Test-Path $wfDir){
    $wfs = Get-ChildItem $wfDir -Filter *.yml -EA SilentlyContinue
    if($wfs){
      $lines += "- Workflows:"
      foreach($w in $wfs){ $lines += ("  - {0} — .github/workflows/{1}" -f ([IO.Path]::GetFileNameWithoutExtension($w.Name)), $w.Name) }
    }
  }

  $sdir = Join-Path $r "scripts"
  if(Test-Path $sdir){
    $scr = Get-ChildItem $sdir -File -EA SilentlyContinue
    if($scr){
      $lines += "- Scripts:"
      foreach($s in $scr){ $lines += ("  - scripts/{0} (last: {1})" -f $s.Name, $s.LastWriteTimeUtc.ToString('yyyy-MM-ddTHH:mm:ssZ')) }
    }
  }
}

$lines += ""
$lines += "## Notes"
$lines += "- Regenerate: pwsh -File scripts/metrics_index.ps1"
$lines += "- Retention: 90 days via scripts/metrics_harvest.ps1"
$lines += "- Staged scripts manifest: metrics/coops_manifest.json"

$lines -join "`r`n" | Set-Content -Encoding UTF8 $indexPath
Write-Host "✅ Wrote $indexPath"