param([string]$RepoPath = "$HOME\Documents\GitHub\CoCivium")
Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"
Set-Location $RepoPath

function Normalize([string]$p,[string]$title,[string]$body){
  if(-not (Test-Path $p)){ return }
  $raw = Get-Content -Raw -LiteralPath $p -Encoding utf8
  if($raw -match '^\s*#\s+.+\(placeholder\)'){
    $content = @"
# $title

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
$body
"@
    [IO.File]::WriteAllText($p, ($content -replace "`r`n","`n").TrimEnd()+"`n", [Text.UTF8Encoding]::new($false))
    git add -- $p
  }
}

Normalize "docs/cc/PREAMBLE.md"    "CC Preamble"    "Context & values that motivate the CC."
Normalize "docs/cc/OVERVIEW.md"    "CC Overview"    "Components, lifecycle, and adoption."
Normalize "docs/cc/DECLARATIONS.md" "CC Declarations — Index" "List declarations and link each as they exist."

Normalize "docs/process/OVERVIEW.md" "Process Overview" "Voice → Draft → Review → Decision → Action → Accountability."

Normalize "docs/onboarding/Being-Noname.md" "Being Noname" "Gentle onramp and first steps."
Normalize "docs/FAQ.md"             "CoCivium FAQ"   "Quick answers to common questions."

Normalize "GOVERNANCE.md"           "Governance"     "Decision process, roles, transparency, appeals."
Normalize "CONTINUITY.md"           "Stewardship & Continuity" "Key holders, backups, hand-off."
Normalize "SECURITY.md"             "Security"       "Reporting, triage, disclosure."
Normalize "CODE_OF_CONDUCT.md"      "Code of Conduct" "Behavior, enforcement."
Normalize "CONTRIBUTING.md"         "Contributing"   "How to propose and land changes."
Normalize "MAINTAINERS.md"          "Maintainers Guide" "Triage, reviews, records."

if(git diff --cached --quiet){ Write-Host "No placeholders needed expansion." }
else{
  git commit -m "docs: upgrade placeholders to structured working drafts"
  git push -u origin HEAD
  if(Get-Command gh -ErrorAction SilentlyContinue){
    gh pr create -B main -t "Docs: upgrade placeholders to structured working drafts" -b "Raises README-linked placeholders from bare stubs to structured outlines."
  }
}
