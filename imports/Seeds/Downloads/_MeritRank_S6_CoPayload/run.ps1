param([string]$RepoRoot = (Get-Location).Path)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$validatorConf = Join-Path $PSScriptRoot 'scripts\validate_config.ps1'
$validatorReg  = Join-Path $PSScriptRoot 'scripts\validate_registry.ps1'
$reg      = Join-Path $PSScriptRoot 'scripts\registry_ingest.ps1'
$mapper   = Join-Path $PSScriptRoot 'scripts\mapper_demo.ps1'
$scorer   = Join-Path $PSScriptRoot 'scripts\score_demo.ps1'
$prov     = Join-Path $PSScriptRoot 'scripts\weights_provenance.ps1'
$config   = Join-Path $PSScriptRoot 'config\meritrank.config.json'

pwsh -File $validatorConf -ConfigPath $config
pwsh -File $validatorReg -RepoRoot $RepoRoot
pwsh -File $reg -RepoRoot $RepoRoot -OutDir (Join-Path $RepoRoot 'out')
pwsh -File $mapper -RepoRoot $RepoRoot -OutDir (Join-Path $RepoRoot 'out')
pwsh -File $scorer -MapPath (Join-Path $RepoRoot 'out\map_demo.json') -OutDir (Join-Path $RepoRoot 'out') -ConfigPath $config
pwsh -File $prov -ConfigPath $config -OutDir (Join-Path $RepoRoot 'out')

$score  = Get-Content -Raw -Encoding UTF8 (Join-Path $RepoRoot 'out\meritrank_score.txt')
$detail = Get-Content -Raw -Encoding UTF8 (Join-Path $RepoRoot 'out\meritrank_detail.json')
$exps   = (Test-Path (Join-Path $RepoRoot 'out\explanations.txt')) ? (Get-Content -Encoding UTF8 (Join-Path $RepoRoot 'out\explanations.txt')) : @()
$badge  = (Test-Path (Join-Path $RepoRoot 'out\badge.json')) ? (Get-Content -Raw -Encoding UTF8 (Join-Path $RepoRoot 'out\badge.json')) : '{}'
$wmsg   = (Test-Path (Join-Path $RepoRoot 'out\weights_change.txt')) ? (Get-Content -Raw -Encoding UTF8 (Join-Path $RepoRoot 'out\weights_change.txt')) : 'Weights unchanged'

$reportPath = Join-Path $RepoRoot 'out\MeritRank_Local_Report_S6.md'
$lines = @(
  '# MeritRank Local Report (Sprint 6)',
  '',
  "**$score**",
  '',
  'Components:',
  '```'
)
$lines += $exps
$lines += @('```', '', 'Detail JSON:', '```', $detail, '```', '', 'Badge JSON:', '```', $badge, '```', '', "Weights: $wmsg")
[IO.File]::WriteAllLines($reportPath, $lines, [Text.UTF8Encoding]::new($true))
Write-Host "Wrote $reportPath"
Get-Content $reportPath