param([string]$Logs="$HOME\Downloads\CoTemp\logs",[string]$StatusFile="$HOME\Downloads\CoTemp\logs\BPOE.status.txt",[int]$WarnStaleMinutes=25,[int]$WarnSlowDOsPerHour=2,[string]$AlertsDir="$HOME\Downloads\CoTemp\alerts")
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
if(-not(Test-Path $AlertsDir)){New-Item -ItemType Directory -Force -Path $AlertsDir|Out-Null}
$now=[DateTime]::UtcNow; $oneHour=$now.AddHours(-1)
$dos=(Test-Path $Logs)?(Get-ChildItem $Logs -Filter "DO-*.log" -Recurse|?{$_.LastWriteTimeUtc -ge $oneHour}).Count:0
$stale= (Test-Path $StatusFile)?([int]([DateTime]::UtcNow - (Get-Item $StatusFile).LastWriteTimeUtc).TotalMinutes):9999
$alerts=@(); if($dos -lt $WarnSlowDOsPerHour){$alerts+="Low DO throughput: $dos/h (<$WarnSlowDOsPerHour/h)"}; if($stale -gt $WarnStaleMinutes){$alerts+="Status stale: $stale min (>$WarnStaleMinutes)"}
if($alerts){$msg="[BLOAT?] "+($alerts -join " | ")+" — "+$now.ToString('yyyy-MM-ddTHH:mm:ssZ'); ($msg)|Out-File -Enc utf8 (Join-Path $AlertsDir 'BLOAT_ALERT.txt') -Append; Write-Warning $msg} else {Write-Host "Health OK — $now"}
