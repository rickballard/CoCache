param([string]$HistoryCsv = ".meritrank_cache/history.csv", [string]$SummaryPath = (Join-Path (Get-Location).Path 'out\LOCAL_SUMMARY.md'), [string]$ConfigPath = "config\meritrank.config.json")
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$score = (Get-Content -Raw -Encoding UTF8 'out/meritrank_score.txt').Split('=')[1] -as [double]
$config = Get-Content -Raw -Encoding UTF8 $ConfigPath | ConvertFrom-Json
$lines=@("### MeritRank: Summary","Score: $score")
if (Test-Path 'out/explanations.txt') { $lines += "#### Components"; $lines += (Get-Content 'out/explanations.txt') }
[IO.File]::WriteAllLines($SummaryPath,$lines,[Text.UTF8Encoding]::new($true))
Write-Host "Wrote $SummaryPath"