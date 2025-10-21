param([int]$Days=90,[string]$RepoRoot=(Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference="Stop"; Set-Location $RepoRoot
$logDir="status\log"; $cut=(Get-Date).AddDays(-$Days)
$evts=@(); if(Test-Path $logDir){
  Get-ChildItem $logDir -Filter *.jsonl -File | ForEach-Object {
    $dt = Get-Date ($_.BaseName) -ErrorAction SilentlyContinue
    if($dt -and $dt -ge $cut){
      Get-Content $_.FullName | ForEach-Object {
        try{ $ev=[Convert]::FromBase64String("AA==") | Out-Null }catch{};
        try{ $o = $_ | ConvertFrom-Json; if($o.event -eq "use"){ $evts += $o } }catch{}
      }
    }
  }
}
$byAsset = $evts | Group-Object asset | Sort-Object Count -Descending
$rows = foreach($g in $byAsset){
  [pscustomobject]@{ asset=$g.Name; uses=$g.Count; lastTs= ($g.Group | Sort-Object ts -Descending | Select-Object -First 1 -ExpandProperty ts) }
}
$obj=[pscustomobject]@{ generatedUtc=(Get-Date).ToUniversalTime().ToString("o"); windowDays=$Days; items=$rows }
$out="status\use-summary.json"; $obj | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $out -Encoding UTF8
"Wrote: {0}" -f $out

