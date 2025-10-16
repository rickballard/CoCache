$hist="admin/durations.csv"
if(!(Test-Path $hist)){ exit 0 }
$cutoff=(Get-Date).AddHours(-2)
$recent = Import-Csv $hist | ? { [datetime]$_.Timestamp -ge $cutoff }
if(-not $recent){
  Write-Host "[BPOE] No recent dots durations found (last 2h). Consider using Run-WithDotsEx." -ForegroundColor Yellow
}
exit 0
