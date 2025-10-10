# Stops the CoInboxWatcher job (PS 5/7 safe)
$job = Get-Job -Name CoInboxWatcher -ErrorAction SilentlyContinue
if ($job) {
  try { Stop-Job -Id $job.Id -ErrorAction SilentlyContinue } catch {}
  try { Remove-Job -Id $job.Id -ErrorAction SilentlyContinue } catch {}
  Write-Host "Stopped CoInboxWatcher."
} else {
  Write-Host "No CoInboxWatcher to stop."
}
