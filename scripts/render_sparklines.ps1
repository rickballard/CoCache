param(
  [string]$HistoryDir = "$HOME\Documents\GitHub\CoCache\metrics\history",
  [string]$OutDir     = "$HOME\Documents\GitHub\CoCache\docs\assets\metrics"
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
ni -ItemType Directory -Force $OutDir | Out-Null

function Render-Spark([double[]]$vals,[string]$name){
  if(!$vals -or $vals.Count -lt 2){ return }
  $w=320; $h=48
  $min=($vals | Measure-Object -Minimum).Minimum
  $max=($vals | Measure-Object -Maximum).Maximum
  if($max -eq $min){ $max += 0.0001 }
  $sx=[double]$w/[math]::Max(1,$vals.Count-1)
  $sy=[double]$h/($max-$min)
  $pts=@()
  for($i=0;$i -lt $vals.Count;$i++){
    $x=[math]::Round($i*$sx,2)
    $y=[math]::Round($h - (($vals[$i]-$min)*$sy),2)
    $pts+="$x,$y"
  }
  $svg=@()
  $svg+='<?xml version="1.0" encoding="UTF-8"?>'
  $svg+= "<svg xmlns='http://www.w3.org/2000/svg' width='$w' height='$h' viewBox='0 0 $w $h' role='img' aria-label='$name sparkline'>"
  $svg+= "  <polyline fill='none' stroke='black' stroke-width='1' points='" + ($pts -join ' ') + "'/>"
  $svg+= '</svg>'
  Set-Content -Encoding UTF8 (Join-Path $OutDir ("{0}.svg" -f $name)) ($svg -join "`n")
}

# Heartbeat fsMs
$hbCsv = Join-Path $HistoryDir "heartbeat.core.csv"
if(Test-Path $hbCsv){
  $rows = Import-Csv $hbCsv
  $vals = @()
  foreach($r in $rows){ if($r.fsMs){ [double]$v=0; [void][double]::TryParse($r.fsMs,[ref]$v); $vals += $v } }
  if($vals.Count -gt 1){ Render-Spark -vals $vals -name "heartbeat.fsMs" }
}

# Git ahead/behind (CoCache)
$gcCsv = Join-Path $HistoryDir "git.sanity.cocache.csv"
if(Test-Path $gcCsv){
  $rows = Import-Csv $gcCsv
  $a=@(); $b=@()
  foreach($r in $rows){ if($r.ahead){ $a += [double]$r.ahead }; if($r.behind){ $b += [double]$r.behind } }
  if($a.Count -gt 1){ Render-Spark -vals $a -name "git.cocache.ahead" }
  if($b.Count -gt 1){ Render-Spark -vals $b -name "git.cocache.behind" }
}

# Git ahead/behind (InSeed)
$giCsv = Join-Path $HistoryDir "git.sanity.inseed.csv"
if(Test-Path $giCsv){
  $rows = Import-Csv $giCsv
  $a=@(); $b=@()
  foreach($r in $rows){ if($r.ahead){ $a += [double]$r.ahead }; if($r.behind){ $b += [double]$r.behind } }
  if($a.Count -gt 1){ Render-Spark -vals $a -name "git.inseed.ahead" }
  if($b.Count -gt 1){ Render-Spark -vals $b -name "git.inseed.behind" }
}

Write-Host "✅ Sparklines rendered -> $OutDir"
