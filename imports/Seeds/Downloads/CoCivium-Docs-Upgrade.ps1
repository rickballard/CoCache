param(
  [string]$RepoPath = "$HOME\Documents\GitHub\CoCivium",
  [switch]$Force
)
Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"
Set-Location $RepoPath
git fetch origin | Out-Null

# Create a fresh working branch
$ts = Get-Date -Format "yyyyMMdd_HHmmss"
$br = "docs/structured_stubs_$ts"
git switch -c $br origin/main | Out-Null

function Should-Upgrade([string]$Raw,[switch]$Force){
  if($Force){ return $true }
  if([string]::IsNullOrWhiteSpace($Raw)){ return $true }
  if($Raw -match '(?i)placeholder'){ return $true }
  $lines = ($Raw -split "`r?`n").Where({$_ -ne ''})
  if($lines.Count -lt 40){ return $true } # thin stub
  return $false
}

function Normalize([string]$RelPath,[string]$Title,[string]$Tail,[switch]$Force){
  $p = Join-Path (Get-Location) $RelPath
  if(-not (Test-Path $p)){ return }
  $raw = Get-Content -Raw -LiteralPath $p -Encoding utf8
  if(-not (Should-Upgrade $raw -Force:$Force)){ return }

  $content = @"
# $Title

> _Status: working draft. Expect changes; suggest improvements via Issues/PRs._

## Purpose
- What this is for
- Who should use it
- What it does **not** try to do

## Scope & Interfaces
- Inputs / responsibilities
- Outputs / artifacts
- Interfaces to other docs/processes

## Draft v0 Outline
- Key sections to be authored
- TODOs with checkboxes
  - [ ] Fill section 1
  - [ ] Fill section 2
  - [ ] Add references

## How to Propose Changes
- Open an Idea → PR
- Review path and decision trace

---
$Tail
"@

  [IO.File]::WriteAllText($p, ($content -replace "`r`n","`n").TrimEnd()+"`n", [Text.UTF8Encoding]::new($false))
  git add -- $RelPath
  Write-Host "Upgraded: $RelPath"
}

# Upgrade the README-linked docs (idempotent; add -Force when invoking to rewrite)
Normalize "docs/cc/PREAMBLE.md"           "CC Preamble"                "Context & values that motivate the CC."        $Force
Normalize "docs/cc/OVERVIEW.md"           "CC Overview"                "Components, lifecycle, and adoption."          $Force
Normalize "docs/cc/DECLARATIONS.md"       "CC Declarations — Index"    "List declarations and link each as they exist." $Force

Normalize "docs/process/OVERVIEW.md"      "Process Overview"           "Voice → Draft → Review → Decision → Action → Accountability." $Force

Normalize "docs/onboarding/Being-Noname.md" "Being Noname"             "Gentle onramp and first steps."                $Force
Normalize "docs/FAQ.md"                   "CoCivium FAQ"               "Quick answers to common questions."            $Force

Normalize "GOVERNANCE.md"                 "Governance"                 "Decision process, roles, transparency, appeals." $Force
Normalize "CONTINUITY.md"                 "Stewardship & Continuity"   "Key holders, backups, hand-off."               $Force
Normalize "SECURITY.md"                   "Security"                   "Reporting, triage, disclosure."                $Force
Normalize "CODE_OF_CONDUCT.md"            "Code of Conduct"            "Behavior, enforcement."                        $Force
Normalize "CONTRIBUTING.md"               "Contributing"               "How to propose and land changes."              $Force
Normalize "MAINTAINERS.md"                "Maintainers Guide"          "Triage, reviews, records."                     $Force

# README normalization: live Idea template link + svg assets
$rd  = Join-Path (Get-Location) 'README.md'
$raw = Get-Content -Raw $rd -Encoding utf8
$upd = $raw `
  -replace '\.\./\.\./issues/new/choose','../../issues/new?template=idea.yml' `
  -replace '(\./assets/diagrams/two-eyes)\.png','$1.svg' `
  -replace '(\./assets/cc/cc-crest)\.png','$1.svg'
if($upd -ne $raw){
  [IO.File]::WriteAllText($rd, ($upd -replace "`r`n","`n").TrimEnd()+"`n", [Text.UTF8Encoding]::new($false))
  git add -- README.md
  Write-Host "README normalized"
}

# Commit / push / PR
if(git diff --cached --quiet){
  Write-Host "No changes to commit."
  git switch main | Out-Null
  git branch -D $br | Out-Null
} else {
  git commit -m "docs: upgrade README-linked docs to structured drafts; normalize README links/assets" | Out-Null
  git push -u origin HEAD | Out-Null
  if(Get-Command gh -ErrorAction SilentlyContinue){
    gh pr create -B main -t "Docs: structured drafts for README links + README link/asset normalization" -b "Upgrades linked docs from placeholders to structured working drafts; normalizes README Idea link and asset refs."
  } else {
    Write-Host "Open PR at: https://github.com/rickballard/CoCivium/pull/new/$br"
  }
}