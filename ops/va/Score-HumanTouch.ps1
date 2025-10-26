param([string]$RepoPath="$HOME\Documents\GitHub\CoCache")
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

function Dot([int]$n=12,[int]$ms=60){1..$n|%{Write-Host -NoNewline "."; Start-Sleep -Milliseconds $ms}; Write-Host ""}

Push-Location $RepoPath
try{
  if(-not (Test-Path "index/va_manifest.csv")){ throw "Run ops/va/Build-VAIndex.ps1 first." }
  $manifest = Import-Csv "index/va_manifest.csv"
  $out = New-Object System.Collections.Generic.List[object]
  $i=0; $total=@($manifest).Count
  Write-Host ("Scoring human-touch for {0} assets..." -f $total) -ForegroundColor Cyan

  foreach($row in $manifest){
    $i++
    if([string]::IsNullOrWhiteSpace($row.path)){ continue }
    if(($i % 50) -eq 1){ Write-Host -NoNewline ("[{0}/{1}] " -f $i,$total); Dot 3 }

    $raw = & git -c core.quotepath=false log --follow --pretty=format:"%H|%ct|%an|%s" -- "--$($row.path)" 2>$null
    if(-not $raw){ continue }

    $lines = @(($raw -split "`n") | Where-Object { $_ -match '^[0-9a-f]{7,40}\|' })
    if(@($lines).Count -eq 0){ continue }

    $entries = foreach($ln in $lines){
      $parts = $ln -split '\|',4
      [pscustomobject]@{ Sha=$parts[0]; Ts=[int64]$parts[1]; Author=$parts[2]; Msg=$parts[3] }
    }
    $entries = @($entries | Sort-Object Ts)

    $n = @($entries).Count
    $spanDays = if($n -gt 1){
      ([DateTimeOffset]::FromUnixTimeSeconds($entries[-1].Ts) - [DateTimeOffset]::FromUnixTimeSeconds($entries[0].Ts)).TotalDays
    } else { 0 }

    $maxBurst=0; $lo=0
    for($hi=0;$hi -lt $n;$hi++){
      while($lo -le $hi -and ([DateTimeOffset]::FromUnixTimeSeconds($entries[$hi].Ts) - [DateTimeOffset]::FromUnixTimeSeconds($entries[$lo].Ts)).TotalDays -gt 3){ $lo++ }
      $win = $hi-$lo+1; if($win -gt $maxBurst){ $maxBurst=$win }
    }

    $tiny = @($entries | Where-Object { $_.Msg -match '(?i)\b(fix|tweak|typo|minor|nits?)\b' }).Count

    $score = 0
    $score += [Math]::Min($n,20) * 2
    $score += [Math]::Min([int]$maxBurst,10) * 3
    $score += [Math]::Min($tiny,10) * 1
    if($spanDays -gt 30){ $score -= 3 }

    $out.Add([pscustomobject]@{
      path=$row.path; commits=$n; burst=$maxBurst; tiny=$tiny
      spanDays=[Math]::Round($spanDays,1); score=$score
    })
  }

  New-Item -ItemType Directory -Force index | Out-Null
  $csv="index/va_human_touch.csv"
  $out | Sort-Object score -Descending | Export-Csv -NoTypeInformation -Encoding UTF8 $csv
  Write-Host "Wrote $csv" -ForegroundColor Green
}
finally{ Pop-Location }

