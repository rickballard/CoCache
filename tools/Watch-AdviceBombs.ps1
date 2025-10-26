Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"; $ProgressPreference="SilentlyContinue"
$GH       = Join-Path $HOME "Documents\GitHub"
$CoCache  = Join-Path $GH   "CoCache"
$Advice   = Join-Path $CoCache "advice"
$Inbox    = Join-Path $Advice  "inbox"
$Integrator = Join-Path (Join-Path $CoCache "tools") "Integrate-AdviceBombs.ps1"
if(-not (Test-Path $Integrator)){ throw "Integrator missing: $Integrator" }
$fsw = New-Object IO.FileSystemWatcher $Inbox, "*"; $fsw.IncludeSubdirectories=$false; $fsw.EnableRaisingEvents=$true
$action = {
  Start-Sleep -Milliseconds 300
  & $using:Integrator | Out-Null
}
$handlers=@(
  Register-ObjectEvent $fsw Created -Action $action,
  Register-ObjectEvent $fsw Changed -Action $action,
  Register-ObjectEvent $fsw Renamed -Action $action
)
Write-Host "Advice watcher running. Drop files into: $Inbox"
while($true){ Start-Sleep -Seconds 60 }

