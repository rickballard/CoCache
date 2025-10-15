param([string]$RepoPath="$HOME\Documents\GitHub\CoCache")
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
Push-Location $RepoPath
try{
  if(-not (Test-Path "index/va_manifest.csv")){ throw "Run ops/va/Build-VAIndex.ps1 first." }
  $manifest = Import-Csv "index/va_manifest.csv"
  $out = New-Object System.Collections.Generic.List[object]
  foreach($row in $manifest){
    $p = $row.path
    if([string]::IsNullOrWhiteSpace($p)){ continue }
    $raw = git log --follow --pretty=format:"%H|%ct|%an|%s" -- "$p" 2>$null
    if(-not $raw){ continue }
    $lines = @($raw -split "`n") | Where-Object { $_ -match '^[0-9a-f]{7,40}\|' }
    if($lines.Count -eq 0){ continue }
    $entries = foreach($ln in $lines){
      $parts = $ln -split '\|',4
      [pscustomobject]@{ Sha=$parts[0]; Ts=[int64]$parts[1]; Author=$parts[2]; Msg=$parts[3] }
    }
    $entries = @($entries | Sort-Object Ts)
    $n = $entries.Count
    $spanDays = if($n -gt 1){ ([DateTimeOffset]::FromUnixTimeSeconds($entries[-1].Ts) - [DateTimeOffset]::FromUnixTimeSeconds($entries[0].Ts)).TotalDays } else { 0 }
    $maxBurst=0; $i=0
    for($j=0;$j -lt $n;$j++){
      while($i -le $j -and ([DateTimeOffset]::FromUnixTimeSeconds($entries[$j].Ts) - [DateTimeOffset]::FromUnixTimeSeconds($entries[$i].Ts)).TotalDays -gt 3){ $i++ }
      $win = $j-$i+1; if($win -gt $maxBurst){ $maxBurst=$win }
    }
    $tiny = (@($entries | Where-Object { $_.Msg -match '(?i)\b(fix|tweak|typo|minor|nits?)\b' })).Count
    $score = 0
    $score += [Math]::Min($n,20) * 2
    $score += [Math]::Min([int]$maxBurst,10) * 3
    $score += [Math]::Min($tiny,10) * 1
    if($spanDays -gt 30){ $score -= 3 }
    $out.Add([pscustomobject]@{ path=$p; commits=$n; burst=$maxBurst; tiny=$tiny; spanDays=[Math]::Round($spanDays,1); score=$score })
  }
  New-Item -ItemType Directory -Force index | Out-Null
  $csv="index/va_human_touch.csv"
  $out | Sort-Object score -Descending | Export-Csv -NoTypeInformation -Encoding UTF8 $csv
  Write-Host "Wrote $csv" -f Green
}
finally{ Pop-Location }
