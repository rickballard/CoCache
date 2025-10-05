Param(
  [string]$OutDir = (Join-Path $PSScriptRoot 'out')
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$report = Join-Path $OutDir 'report.md'
$status = Join-Path $OutDir 'out.txt'
@"
# AB-KA-01 — Insights Scaffold & Harvest Pack
Generated: $(Get-Date -AsUTC)
Contents:
- payload/CoCivium_Insights_Scaffold_v1.0.zip
Next steps:
1) Extract scaffold into target repo.
2) Run Harvest, then Chunk on large sources.
3) Fill priority pairs: LL, KA, CC, FF, RT.
"@ | Set-Content -Path $report -Encoding UTF8
"OK KA $(Get-Date -AsUTC)" | Set-Content -Path $status -Encoding UTF8