param(
  [string]$HistoryDir = "$HOME\Documents\GitHub\CoCache\metrics\history",
  [string]$OutMd      = "$HOME\Documents\GitHub\CoCache\docs\TOP_MOVERS.md",
  [int]$Window        = 30,
  [int]$TopN          = 5
)
$ErrorActionPreference="Stop"; Set-StrictMode -Version Latest

function Get-Slope([double[]]$y){
  if(-not $y -or $y.Count -lt 2){ return $null }
  $n = $y.Count
  # simple delta (last - first) for readability/robustness
  return ($y[-1] - $y[0])
}

$rowsOut = @()
Get-ChildItem $HistoryDir -Filter *.csv -EA SilentlyContinue | ForEach-Object {
  $id = [IO.Path]::GetFileNameWithoutExtension($_.Name)
  $rows = Import-Csv $_.FullName
  if(-not $rows){ return }
  # pick the first non-ts numeric column as the series (common pattern here)
  $cols = $rows[0].PSObject.Properties.Name | Where-Object { $_ -ne 'ts' }
  foreach($col in $cols){
    $vals = @()
    foreach($r in $rows[-1..-[Math]::Min($Window,$rows.Count)]){ } # noop to allow negative index in next block
    $take = [Math]::Min($Window, $rows.Count)
    for($i=$rows.Count-$take; $i -lt $rows.Count; $i++){
      $v = $rows[$i].$col
      if($v -ne $null -and $v -ne ''){ [double]$dv = 0; [void][double]::TryParse($v,[ref]$dv); $vals += $dv }
    }
    if($vals.Count -ge 2){
      $delta = Get-Slope $vals
      $abs   = [math]::Abs($delta)
      $rowsOut += [pscustomobject]@{
        id     = $id
        column = $col
        delta  = [math]::Round($delta, 3)
        abs    = [math]::Round($abs, 3)
        points = $vals.Count
      }
    }
  }
}

$sorted = $rowsOut | Sort-Object -Property @{e='abs';Descending=$true}, @{e='id';Descending=$false}
$top = $sorted | Select-Object -First $TopN

$lines = @()
$lines += "# Top Movers (last $Window points)"
$lines += ""
$lines += "_Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')Z_"
$lines += ""
if(-not $top){
  $lines += "_No trends available yet._"
} else {
  $lines += "| rank | metric | column | Δ (last-first) | points |"
  $lines += "|---:|---|---|---:|---:|"
  $rank = 1
  foreach($t in $top){
    $lines += "| $rank | `$($t.id)` | `$($t.column)` | $($t.delta) | $($t.points) |"
    $rank++
  }
}
$lines -join "`r`n" | Set-Content -Encoding UTF8 $OutMd
Write-Host "✅ Wrote $OutMd"
