param([string]$Root="$HOME\Documents\GitHub\CoCache",[int]$Days=30)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
function Parse($line){
  $parts=$line.Split(',',2); if($parts.Count -lt 2){ return $null }
  $o=@{ ts=$parts[0].Trim() }
  foreach($kv in $parts[1].Split(',')){ $p=$kv.Split('=',2); if($p.Count -eq 2){ $o[$p[0]]=$p[1] } }
  return [pscustomobject]$o
}
$reg = Get-Content (Join-Path $Root "metrics\registry.json") -Raw | ConvertFrom-Json
$now = Get-Date
$cut = $now.AddDays(-$Days).ToUniversalTime()
$stale = @()
foreach($m in $reg){
  $log = Join-Path $Root $m.log_path
  if(!(Test-Path $log)){ $stale += [pscustomobject]@{ id=$m.id; reason="missing log"; lastTs=$null }; continue }
  $last = Get-Content $log | Select-Object -Last 1
  $row = Parse $last
  if($null -eq $row -or [string]::IsNullOrWhiteSpace($row.ts)){ $stale += [pscustomobject]@{ id=$m.id; reason="no rows"; lastTs=$null }; continue }
  $ts=[datetime]::Parse($row.ts).ToUniversalTime()
  if($ts -lt $cut){ $stale += [pscustomobject]@{ id=$m.id; reason="older than $Days d"; lastTs=$row.ts } }
}
$payload=$stale | ConvertTo-Json -Depth 6
$pathJson = Join-Path $Root "metrics\stale.json"
$pathMd   = Join-Path $Root "docs\STALE_TRACKERS.md"
$payload | Set-Content -Encoding UTF8 $pathJson
$lines=@("# Stale Trackers (>$Days days old)", "", "_Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')Z_","")
if($stale.Count){ foreach($s in $stale){ $lines += "- **$($s.id)** — $($s.reason) (last: $($s.lastTs))" } } else { $lines += "_None._" }
$lines -join "`r`n" | Set-Content -Encoding UTF8 $pathMd
Write-Host "✅ Stale check -> $pathJson; docs/STALE_TRACKERS.md"

