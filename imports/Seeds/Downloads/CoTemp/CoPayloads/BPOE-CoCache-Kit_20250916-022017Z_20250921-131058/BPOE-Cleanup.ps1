param([string]$TempRoot = $env:TEMP)
$prefix = 'BPOE-CoCache-Kit_'
$dirs = Get-ChildItem -Path $TempRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "$prefix*" }
foreach($d in $dirs){
  try { Remove-Item -Recurse -Force $d.FullName; Write-Host "Removed $($d.FullName)" -ForegroundColor Green } catch {}
}