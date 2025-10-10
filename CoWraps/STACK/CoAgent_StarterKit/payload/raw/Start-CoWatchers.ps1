# Starts the CoInboxWatcher as a background job
param()
$root = Join-Path $HOME "Downloads\CoTemp"
$inbox = Join-Path $root "inbox"
$processed = Join-Path $inbox "processed"
$run = Join-Path $root "_shared\Run-DO.ps1"
$watch = Join-Path $root "scripts\Watch-CoTempInbox.ps1"

if (-not (Get-Job -Name CoInboxWatcher -ErrorAction SilentlyContinue)) {
  Start-Job -Name CoInboxWatcher -ScriptBlock {
    param($i,$p,$r,$w)
    & $w -Inbox $i -Processed $p -RunDO $r
  } -ArgumentList $inbox,$processed,$run,$watch | Out-Null
  Write-Host "Started CoInboxWatcher."
} else {
  Write-Host "CoInboxWatcher already running."
}
