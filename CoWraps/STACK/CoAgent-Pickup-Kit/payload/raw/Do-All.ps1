param(
  [string]$SessionName = "Productize backchatter"
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# 1) Profile hardening
& (Join-Path $here 'Repair-Profile-EnterKey.ps1')

# 2) Patch rainbow banner
& (Join-Path $here 'Patch-Section-Banners.ps1')

# 3) Icons + Shortcuts
& (Join-Path $here 'Install-Icons-And-Shortcuts.ps1') -SessionName $SessionName

Write-Host "`nDone. Open 'CoAgent Panel (PS7 Tabs)' from your Desktop to pair the session." -ForegroundColor Green
