param(
  [string]$RepoPath = "$HOME\Documents\GitHub\CoCivium",
  [switch]$Force
)
Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"
Set-Location $RepoPath
git fetch origin | Out-Null

# Create a fresh working branch up front
$ts = Get-Date -Format "yyyyMMdd_HHmmss"
$br = "docs/structured_stubs_$ts"
git switch -c $br origin/main | Out-Null

function Should-Upgrade([string]$raw,[switch]$Force){
  if($Force){ return $true }
  if($raw -match '(?i)placeholder'){ return $true }
  $lines = ($raw -split "`r?`n").Where({$_ -ne ''})
  if($lines.Count -lt 40){ return $true } # thin stub
  return $false
}

function Normalize([string]$p,[string]$title,[string]$body,[switch]$Force){
  if(-not (Test-Path $p)){ return }
  $raw = Get-Content -Raw -LiteralPath $p -Encoding utf8
  if(-not (Should-Upgrade $raw -Force:$Force)){ return }

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
  Write-Host "Upgraded: $p"
}

# CC
Normalize "docs/cc/PREAMBLE.md"        "CC Preamble"                  "Context & values that motivate the CC."        $Force
Normalize "docs/cc/OVERVIEW.md"        "CC Overview"                  "Components, lifecycle, and adoption."          $Force
Normalize "docs/cc/DECLARATIONS.md"    "CC Declarations — Index"      "List declarations and link each as they exist." $Force

# Process
Normalize "docs/process/OVERVIEW.md"   "Process Overview"             "Voice → Draft → Review → Decision → Action → Accountability." $Force

# Onboarding / FAQ
Normalize "docs/onboarding/Being-Noname.md" "Being Noname"            "Gentle onramp and first steps."                $Force
Normalize "docs/FAQ.md"                "CoCivium FAQ"                 "Quick answers to common questions."            $Force

# Repo governance / meta
Normalize "GOVERNANCE.md"              "Governance"                   "Decision process, roles, transparency, appeals." $Force
Normalize "CONTINUITY.md"              "Stewardship & Continuity"     "Key holders, backups, hand-off."               $Force
Normalize "SECURITY.md"                "Security"                     "Reporting, triage, disclosure."                $Force
Normalize "CODE_OF_CONDUCT.md"         "Code of Conduct"              "Behavior, enforcement."                        $Force
Normalize "CONTRIBUTING.md"            "Contributing"                 "How to propose and land changes."              $Force
Normalize "MAINTAINERS.md"             "Maintainers Guide"            "Triage, reviews, records."                     $Force

if(git diff --cached --quiet){
  Write-Host "No placeholders needed expansion."
  # Optional: clean up empty branch
  git switch main | Out-Null
  git branch -D $br | Out-Null
} else {
  git commit -m "docs: upgrade placeholders to structured working drafts" | Out-Null
  git push -u origin HEAD | Out-Null
  if(Get-Command gh -ErrorAction SilentlyContinue){
    gh pr create -B main -t "Docs: upgrade placeholders to structured working drafts" -b "Raises README-linked placeholders from bare stubs to structured outlines."
  }
}
