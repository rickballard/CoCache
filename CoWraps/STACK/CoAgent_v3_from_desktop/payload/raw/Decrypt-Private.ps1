param(
  [Parameter(Mandatory)][string]$Archive,
  [string]$Dest = (Join-Path $HOME "Desktop\CoAgent_private_unpacked")
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$gui = "C:\Program Files (x86)\7-Zip\7zFM.exe"
$dir = Split-Path $gui -Parent
$cli = @("$dir\7z.exe","$dir\7zG.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $cli) { throw "7-Zip CLI not found." }

New-Item -ItemType Directory -Force -Path $Dest | Out-Null
& $cli x "$Archive" "-o$Dest"
"Decrypted -> $Dest"
