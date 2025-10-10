param(
  [string]$Out = (Join-Path $HOME ("Desktop\CoAgent_private_{0}.7z" -f (Get-Date -Format "yyyyMMdd-HHmm")))
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$priv = Join-Path $HOME "Desktop\CoAgent\docs\private"
if (-not (Test-Path $priv)) { throw "Private folder not found: $priv" }

# Locate 7-Zip next to 7zFM.exe, adjust if needed
$sevenZipDir = Split-Path "C:\Program Files (x86)\7-Zip\7zFM.exe" -Parent
$sevenZipExe = @("$sevenZipDir\7z.exe","$sevenZipDir\7zG.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $sevenZipExe) { throw "7-Zip CLI not found (7z.exe / 7zG.exe). Open 7-Zip and check Tools > Options > Path." }

$pw = Read-Host "Enter passphrase (visible as you type)"
& $sevenZipExe a -t7z -mhe=on "-p$pw" "$Out" "$priv"
"Encrypted -> $Out"
