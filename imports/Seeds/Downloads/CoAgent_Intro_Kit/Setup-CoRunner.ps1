$CT = Join-Path $env:USERPROFILE "Downloads\CoTemp"
$DL = Join-Path $env:USERPROFILE "Downloads"
$KitRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ToolsSrc = Join-Path $KitRoot "tools"
$ToolsDst = Join-Path $CT "tools"
New-Item -ItemType Directory -Force -Path $CT,$ToolsDst | Out-Null
Copy-Item -Recurse -Force -Path (Join-Path $KitRoot "tools\*") -Destination $ToolsDst

# Start cmd
$startCmd = Join-Path $CT "Start-CoPayloadRunner.cmd"
@"
@echo off
"%ProgramFiles%\PowerShell\7\pwsh.exe" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%CT%\tools\CoPayloadRunner.ps1"
"@ | Set-Content -Encoding ASCII $startCmd

# Desktop shortcut
try {
  $ws   = New-Object -ComObject WScript.Shell
  $desk = [Environment]::GetFolderPath('Desktop')
  $lnk  = $ws.CreateShortcut( (Join-Path $desk 'CoPayloadRunner (Manual).lnk') )
  $lnk.TargetPath = $startCmd
  $lnk.WorkingDirectory = $CT
  $lnk.IconLocation = "$env:SystemRoot\System32\shell32.dll,46"
  $lnk.Save()
} catch {}

# Place sample ZIP
$sampleSrc = Join-Path $KitRoot "samples\HH_SAMPLE.zip"
if (Test-Path $sampleSrc) {
  Copy-Item -Force $sampleSrc -Destination (Join-Path $DL "HH_SAMPLE.zip")
}

Write-Host "[OK] Installed to: $CT" -ForegroundColor Green
Write-Host "[OK] Shortcut: Desktop\CoPayloadRunner (Manual).lnk" -ForegroundColor Green
if (Test-Path (Join-Path $DL "HH_SAMPLE.zip")) {
  Write-Host "[OK] Sample:   $DL\HH_SAMPLE.zip" -ForegroundColor Green
}
