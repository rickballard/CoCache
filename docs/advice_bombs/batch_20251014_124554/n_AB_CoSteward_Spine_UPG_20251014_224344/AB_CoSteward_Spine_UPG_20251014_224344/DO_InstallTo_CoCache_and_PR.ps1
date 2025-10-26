# One-touch installer for the repo-reorg session
Param(
  [string]$RepoPath = "$HOME\Documents\GitHub\CoCache",
  [string]$Branch = "feature/costeward-seed",
  [switch]$NoPR
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
$here = $PSScriptRoot
# 1) Install files (non-destructive)
pwsh "$here\run.ps1" -TargetRoot $RepoPath

# 2) Git branch, commit, push
Push-Location $RepoPath
try {
  git rev-parse --is-inside-work-tree | Out-Null
} catch { throw "Not a git repo: $RepoPath" }

$existing = (git branch --list $Branch)
if ($existing) { git checkout $Branch } else { git checkout -b $Branch }
git add CoSteward
git commit -m "Seed CoSteward (human WIP cap + Co: sandbox + IdeaCards + weekly ritual)"
git push -u origin $Branch

if (-not $NoPR) {
  try {
    gh --version | Out-Null
    gh pr create --title "Seed CoSteward (Steward operating spine)" --body-file "$here\_handoff\PR_BODY.md" --label "steward,advice-bomb" --base main --head $Branch
  } catch {
    Write-Host "GitHub CLI not available. Create PR manually in the browser."
  }
}
Pop-Location
Write-Host "Done. Branch: $Branch"

