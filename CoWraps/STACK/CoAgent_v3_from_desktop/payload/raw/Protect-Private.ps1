param(
  [string]$PrivateDir = (Join-Path $HOME "Desktop\CoAgent\docs\private"),
  [string]$Out7z      = (Join-Path $HOME ("Desktop\CoAgent_private_{0}.7z" -f (Get-Date -Format "yyyyMMdd-HHmm"))),
  [string]$Password   # optional; if empty, 7-Zip will prompt
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $PrivateDir)) { throw "Private folder not found: $PrivateDir" }

# Locate 7z.exe beside 7zFM.exe
$gui = "C:\Program Files (x86)\7-Zip\7zFM.exe"
$dir = Split-Path $gui -Parent
$cli = @("$dir\7z.exe","$dir\7zG.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $cli) { throw "7-Zip CLI not found. Open 7-Zip and check Tools > Options > Path." }

$pwArg = if ($Password) { "-p$Password" } else { "" }
& $cli a -t7z -mhe=on $pwArg "$Out7z" "$PrivateDir"
"Encrypted -> $Out7z"
