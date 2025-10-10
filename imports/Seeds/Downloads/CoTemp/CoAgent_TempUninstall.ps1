param([switch]$KeepStub)
$pattern = "CoAgent|CoCivium|CoCache|CoBreadcrumb|Lehane"
Write-Host "Disabling scheduled tasks matching: $pattern" -ForegroundColor Cyan
Get-ScheduledTask | Where-Object { $_.TaskName -match $pattern } | Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null

$paths = @(
  "$env:APPDATA\CoAgent\Cache","$env:APPDATA\CoAgent\GPUCache","$env:APPDATA\CoAgent\Code Cache","$env:APPDATA\CoAgent\DawnCache",
  "$env:APPDATA\coagent\Cache","$env:APPDATA\coagent\GPUCache","$env:APPDATA\coagent\Code Cache","$env:APPDATA\coagent\DawnCache"
)
foreach($p in $paths){ try{ if(Test-Path $p){ Remove-Item -Recurse -Force -LiteralPath $p } }catch{} }

if ($KeepStub) {
  $stub = Join-Path ([Environment]::GetFolderPath('Desktop')) 'CoAgent (Help Only).lnk'
  $ws = New-Object -ComObject WScript.Shell
  $lnk = $ws.CreateShortcut($stub)
  $lnk.TargetPath = "explorer.exe"
  $lnk.Arguments  = (Join-Path ((Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'GitHub\CoAgent\electron\help')) 'index.html')
  $lnk.IconLocation = "$env:SystemRoot\System32\shell32.dll,167"
  $lnk.Save()
  Write-Host "Left help-only stub on Desktop." -ForegroundColor Green
} else {
  Write-Host "No stub kept." -ForegroundColor DarkGray
}
Write-Host "Temp uninstall steps completed." -ForegroundColor Cyan
