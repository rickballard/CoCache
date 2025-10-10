param([string]$RepoRoot = (Get-Location).Path)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$mapper    = Join-Path $PSScriptRoot 'scripts\mapper_demo.ps1'
$scorer    = Join-Path $PSScriptRoot 'scripts\score_demo.ps1'
$validator = Join-Path $PSScriptRoot 'scripts\validate_config.ps1'
$config    = Join-Path $PSScriptRoot 'config\meritrank.config.json'

pwsh -File $validator -ConfigPath $config
pwsh -File $mapper -RepoRoot $RepoRoot -OutDir (Join-Path $RepoRoot 'out')
pwsh -File $scorer -MapPath (Join-Path $RepoRoot 'out\map_demo.json') -OutDir (Join-Path $RepoRoot 'out') -ConfigPath $config

$score  = Get-Content -Raw -Encoding UTF8 (Join-Path $RepoRoot 'out\meritrank_score.txt')
$detail = Get-Content -Raw -Encoding UTF8 (Join-Path $RepoRoot 'out\meritrank_detail.json')
$reportPath = Join-Path $RepoRoot 'out\MeritRank_Local_Report.md'
$lines = @(
  '# MeritRank Local Report',
  '',
  "**$score**",
  '',
  'Details:',
  '```',
  $detail,
  '```'
)
[IO.File]::WriteAllLines($reportPath, $lines, [Text.UTF8Encoding]::new($true))
Write-Host "Wrote $reportPath"
Get-Content $reportPath
