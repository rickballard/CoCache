Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$OutDir = "$PSScriptRoot\output"
New-Item -ItemType Directory -Path $OutDir -Force | Out-Null

# Output demo artifact
@"
# Hitchhiker Plan — Demo Artifact

This file was generated as a test payload from the HH session.

> Session: HH-Plan-Build
> Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@ | Set-Content "$OutDir\HH_DemoArtifact.md" -Encoding UTF8

# Write short status line
'✅ HH Demo payload executed successfully.' | Set-Content "$OutDir\out.txt" -Encoding UTF8
