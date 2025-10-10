param([string]$OutZip = (Join-Path $HOME ("Downloads\\CoAgent_StarterKit_v{0}.zip" -f (Get-Date -Format "yyyyMMdd-HHmm"))))
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$co  = Join-Path $HOME 'Downloads\\CoTemp'
$kit = Join-Path $HOME 'Downloads\\CoAgent_StarterKit_build'
Remove-Item $kit -Recurse -Force -ErrorAction SilentlyContinue; New-Item -ItemType Directory -Force -Path $kit | Out-Null
$rt = Join-Path $kit 'runtime'; $dc = Join-Path $kit 'docs'
$null = New-Item -ItemType Directory -Force -Path $rt,$dc | Out-Null
Copy-Item -Recurse -Force (Join-Path $co 'Join-CoAgent.ps1') $rt
Copy-Item -Recurse -Force (Join-Path $co 'CoAgentLauncher.ps1') $rt
Copy-Item -Recurse -Force (Join-Path $co 'common') $rt
Copy-Item -Recurse -Force (Join-Path $co 'scripts') $rt
$srcDocs = Join-Path $HOME 'Downloads\\CoAgent_Planning_Sprint1\\docs'
if (Test-Path $srcDocs) { Copy-Item -Recurse -Force $srcDocs\\* $dc }
Set-Content -Encoding UTF8 -LiteralPath (Join-Path $kit 'README_FIRST.md') -Value @"
# CoAgent Starter Kit — Read Me First
1) Set-ExecutionPolicy -Scope Process Bypass -Force
2) Get-ChildItem -LiteralPath `"$($HOME)\Downloads\CoTemp`" -Recurse -Filter *.ps1 | Unblock-File
3) .\runtime\CoAgentLauncher.ps1 -OpenBrowser
"@
if (Test-Path $OutZip) { Remove-Item $OutZip -Force }
Compress-Archive -Path (Join-Path $kit '*') -DestinationPath $OutZip -Force
"Built -> $OutZip"
