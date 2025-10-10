param([Parameter(Mandatory)][int]$PR,[string]$Repo="",[string]$Base="origin/main",[switch]$ForcePush)
$ErrorActionPreference='Stop'
if ($Repo) { gh pr checkout $PR -R $Repo } else { gh pr checkout $PR }
git fetch --all
try { git rebase $Base } catch {
  Write-Warning "Conflicts detected. Resolve, then: git add -A; git rebase --continue"
  exit 2
}
if ($ForcePush) { git push --force-with-lease } else { git push }
