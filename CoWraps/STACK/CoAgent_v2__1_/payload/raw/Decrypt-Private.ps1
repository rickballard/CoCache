param(
  [Parameter(Mandatory)][string]$Archive,
  [string]$Dest = (Join-Path $HOME "Desktop\CoAgent_private_unpacked")
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$sevenZipDir = Split-Path "C:\Program Files (x86)\7-Zip\7zFM.exe" -Parent
$sevenZipExe = @("$sevenZipDir\7z.exe","$sevenZipDir\7zG.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $sevenZipExe) { throw "7-Zip CLI not found (7z.exe/7zG.exe)." }

$null = New-Item -ItemType Directory -Force -Path $Dest
& $sevenZipExe x "$Archive" "-o$Dest"
"Decrypted -> $Dest"
