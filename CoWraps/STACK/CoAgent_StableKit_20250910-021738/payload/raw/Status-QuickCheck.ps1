$root = Join-Path $HOME 'Downloads\CoTemp'
Write-Host "CoTemp session: $env:COSESSION_ID"
Get-Job | Where-Object { $_.Name -like 'CoInboxWatcher' -or $_.Name -like 'CoQueueWatcher-*' } | ft Id,Name,State

$log = Get-ChildItem (Join-Path $root 'logs') -File -EA SilentlyContinue | Sort LastWriteTime -desc | Select -First 1
if ($log) { "Latest log: $($log.FullName)"; Get-Content $log.FullName -Tail 20 }
