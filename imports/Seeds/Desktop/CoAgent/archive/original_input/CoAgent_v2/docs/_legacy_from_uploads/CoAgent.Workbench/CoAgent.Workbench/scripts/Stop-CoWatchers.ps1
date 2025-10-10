# Stops the CoInboxWatcher job
Get-Job -Name CoInboxWatcher -ErrorAction SilentlyContinue | Stop-Job
Get-Job -Name CoInboxWatcher -ErrorAction SilentlyContinue | Remove-Job
Write-Host "Stopped CoInboxWatcher."
