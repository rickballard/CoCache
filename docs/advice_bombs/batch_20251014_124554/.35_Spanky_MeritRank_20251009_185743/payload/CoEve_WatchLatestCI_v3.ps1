param(
  [string]$RepoRoot,
  [string]$Repo,
  [string]$Branch = 'main',
  [string]$Workflow
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Get-RepoSlug {
  param([string]$repoPath,[string]$repoSlug)
  if ($repoSlug) { return $repoSlug }
  Push-Location $repoPath
  try { $url = (git remote get-url origin).Trim() } finally { Pop-Location }
  if (-not $url) { throw "No origin remote in $repoPath" }
  $slug = $url -replace '.*github\.com[:/](.*?)(?:\.git)?$','$1'
  if ($slug -notmatch '.+/.+') { throw "Bad slug from $url" }
  return $slug
}
$slug = Get-RepoSlug -repoPath $RepoRoot -repoSlug $Repo
$wfArg = $Workflow ? "--workflow `"$Workflow`"" : ""
$cmd = "gh run list --limit 1 --branch $Branch --json databaseId,headBranch,status,conclusion,displayTitle,workflowName,url $wfArg -R $slug"
$runs = Invoke-Expression $cmd | ConvertFrom-Json
if (-not $runs) { throw "No runs found for $slug on $Branch" }
$run = $runs[0]
Write-Host ("Watching: {0} · #{1} · {2} · {3}" -f ($run.workflowName ?? $run.displayTitle), $run.databaseId, $run.status, $run.url)
Write-Host ("Run {0} ({1}) has already completed with '{2}'" -f ($run.workflowName ?? $run.displayTitle), $run.databaseId, $run.conclusion)
