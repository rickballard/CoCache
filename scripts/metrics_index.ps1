param(
  [string]$CoCache   = "$HOME\Documents\GitHub\CoCache",
  [string[]]$Repos   = @(
    "$HOME\Documents\GitHub\CoCache",
    "$HOME\Documents\GitHub\InSeed",
    "$HOME\Documents\GitHub\CoCivium",
    "$HOME\Documents\GitHub\CoPolitic",
    "$HOME\Documents\GitHub\CoSteward"
  )
)
$ErrorActionPreference="Stop"; Set-StrictMode -Version Latest
function ReadJson($p){ if(Test-Path $p){ Get-Content $p -Raw | ConvertFrom-Json } else { $null } }
$indexPath = Join-Path $CoCache "docs\METRICS_INDEX.md"; ni -ItemType Directory -Force (Split-Path $indexPath) | Out-Null
$reg    = ReadJson (Join-Path $CoCache "metrics\registry.json")
$latest = ReadJson (Join-Path $CoCache "metrics\latest.json")
$lines = @()
$lines += "# CoSuite Metrics & Watchers Index"
$lines += ""
$lines += "_Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')Z_"
$lines += ""
$lines += "## Metrics (from registry)"
if($reg){
  $lines += "| id | cadence | latest ts | latest fields | history | log |"
  $lines += "|---|---|---|---|---|---|"
  foreach($m in $reg){
    $lid=$m.id; $cad=$m.cadence; $logRel=$m.log_path; $histRel="metrics/history/$($lid).csv"
    $lrow = if($latest -and $latest.PSObject.Properties.Name -contains $lid){ $latest.$lid } else { $null }
    $lts  = if($lrow){ $lrow.ts } else { "" }
    $lf   = if($lrow){ ($lrow.PSObject.Properties.Name | Where-Object { $_ -ne "ts" } | ForEach-Object { "$_=$($lrow.$_)" }) -join "; " } else { "" }
    $lines += "| `$lid` | $cad | $lts | $lf | [$histRel]($histRel) | [$logRel]($logRel) |"
  }
} else { $lines += "_No registry found at `metrics/registry.json`._" }
$lines += ""
$lines += "## Heartbeats & CoPingPong"
$hbDir = Join-Path $CoCache "docs\HEARTBEATS"
if(Test-Path $hbDir){
  $logs = Get-ChildItem $hbDir -Filter *.log -EA SilentlyContinue
  if($logs){ foreach($l in $logs){ $lines += "- `docs/HEARTBEATS/$($l.Name)` (size: $([math]::Round($l.Length/1KB,1)) KB, last: $($l.LastWriteTimeUtc.ToString('yyyy-MM-ddTHH:mm:ssZ')))" } }
  else { $lines += "_No heartbeat logs found._" }
} else { $lines += "_No `docs/HEARTBEATS/` directory._" }
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
      $lines += "- **Workflows:**"
      foreach($w in $wfs){ $lines += "  - $([IO.Path]::GetFileNameWithoutExtension($w.Name)) — `.github/workflows/$($w.Name)`" }
    }
  }
  $sdir = Join-Path $r "scripts";
  if(Test-Path $sdir){
    $scr = Get-ChildItem $sdir -File -EA SilentlyContinue
    if($scr){
      $lines += "- **Scripts:**"
      foreach($s in $scr){ $lines += "  - `scripts/$($s.Name)` (last: $($s.LastWriteTimeUtc.ToString('yyyy-MM-ddTHH:mm:ssZ')))" }
    }
  }
}
$lines += ""
$lines += "## Notes"
$lines += "- Regenerate: `pwsh -File scripts/metrics_index.ps1`"
$lines += "- Retention: 90 days via `scripts/metrics_harvest.ps1`"
$lines += "- Staged scripts manifest: `metrics/coops_manifest.json`"
$lines -join "`r`n" | Set-Content -Encoding UTF8 $indexPath
Write-Host "✅ Wrote $indexPath"