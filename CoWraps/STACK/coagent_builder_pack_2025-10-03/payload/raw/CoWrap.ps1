<#
CoWrap.ps1 — compact orchestrator to apply packs without leaking into chat.
Usage (run in repo root):
  pwsh -File tools\CoWrap.ps1 -Pack Docs|UI|Guardrails|Metrics|Sandbox|All
#>
param([ValidateSet('Docs','UI','Guardrails','Metrics','Sandbox','All')][string]$Pack='All')
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
function New-Branch { param($Name) git checkout -B $Name origin/main | Out-Null }
function Add-Docs      { New-Branch "docs/training-pack"; git add docs/HELP.md docs/TRAINING.md docs/BPOE.md .github/workflows/status-bot.yml docs/ui-mock/* docs/status.html; if(-not (git diff --cached --quiet 2>$null)){ git commit -m "docs: HELP+TRAINING+BPOE+status+ui-mock" }; git push -u origin HEAD; gh pr create --fill --draft | Out-Null }
function Add-UI        { New-Branch "docs/ui-quad-uplift"; git add docs/ui-mock/quad.html docs/ui-mock/quad.css; if(-not (git diff --cached --quiet 2>$null)){ git commit -m "docs: UI mock uplift" }; git push -u origin HEAD; gh pr create --fill --draft | Out-Null }
function Add-Guardrails{ New-Branch "guardrails/breadcrumbs"; New-Item -ItemType Directory -Force .coagent\guardrails | Out-Null; git add tools/Scan-AtRisk.ps1 .github/workflows/guardrail-smoke.yml; if(-not (git diff --cached --quiet 2>$null)){ git commit -m "guardrails: breadcrumbs + smoke" }; git push -u origin HEAD; gh pr create --fill --draft | Out-Null }
function Add-Metrics   { New-Branch "metrics/bpoe"; New-Item -ItemType Directory -Force .coagent\logs | Out-Null; git add tools/Log-Run.ps1 tools/Analyze-BPOE.ps1 tools/Test-MVP.ps1; if(-not (git diff --cached --quiet 2>$null)){ git commit -m "metrics: local logs + analyzer; wire MVP test" }; git push -u origin HEAD; gh pr create --fill --draft | Out-Null }
function Add-Sandbox   { New-Branch "sandbox/cocivium"; git add sandbox.config.json tools/Enter-Sandbox.ps1 tools/Test-MVP.ps1; if(-not (git diff --cached --quiet 2>$null)){ git commit -m "sandbox: CoCivium mode" }; git push -u origin HEAD; gh pr create --fill --draft | Out-Null }
switch($Pack){ 'Docs'{Add-Docs};'UI'{Add-UI};'Guardrails'{Add-Guardrails};'Metrics'{Add-Metrics};'Sandbox'{Add-Sandbox};'All'{Add-Docs;Add-UI;Add-Guardrails;Add-Metrics;Add-Sandbox}}
Write-Host "✓ CoWrap completed: $Pack"
