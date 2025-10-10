\
param([string]$DestRoot = (Join-Path $env:USERPROFILE 'Documents\CoProfile'))

Set-ExecutionPolicy -Scope Process Bypass -Force | Out-Null
$here = Split-Path -Parent $PSCommandPath
New-Item -ItemType Directory -Force -Path $DestRoot | Out-Null

# Copy examples/schema
Copy-Item (Join-Path $here '..\examples\Rick.example.yaml') (Join-Path $DestRoot 'coprofile.yaml') -Force
Copy-Item (Join-Path $here '..\examples\Rick.example.json') (Join-Path $DestRoot 'coprofile.json') -Force
Copy-Item (Join-Path $here 'CoProfile.psm1') (Join-Path $DestRoot 'CoProfile.psm1') -Force

# First run summary
Import-Module (Join-Path $DestRoot 'CoProfile.psm1') -Force
Show-CoProfileSummary

"`nInstalled to: $DestRoot`nEdit 'coprofile.yaml' to customize.  Run 'Show-CoProfileSummary' to preview." | Write-Host -ForegroundColor Green
