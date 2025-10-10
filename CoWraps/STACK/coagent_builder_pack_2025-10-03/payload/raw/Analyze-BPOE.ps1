Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$path=".coagent\logs\events.jsonl"
if(!(Test-Path $path)){ Write-Host "No logs yet."; exit 0 }
$lines = Get-Content $path | Where-Object { $_.Trim() -ne "" } | % { $_ | ConvertFrom-Json }
$total = $lines.Count
$smokes = $lines | ? { $_.name -eq 'mvp-smoke' }
$rateOK = if($smokes.Count){ ($smokes | ? { $_.okCount -ge 4 }).Count / $smokes.Count } else { 0 }
$avgDur = if($smokes.Count){ [Math]::Round(($smokes | Measure-Object durationSec -Average).Average,2) } else { 0 }
[PSCustomObject]@{
  total=$total; smokes=$($smokes.Count); passRate=$rateOK; avgDurationSec=$avgDur
} | Format-List
