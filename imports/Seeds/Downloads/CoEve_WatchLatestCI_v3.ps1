param(
  [string]$RepoRoot,
  [string]$Repo,
  [string]$Branch = 'main',
  [string]$Workflow,
  [switch]$Open
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

function Get-Slug {
  param([string]$RepoRoot, [string]$Repo)
  if ($Repo) { return $Repo }
  if (-not $RepoRoot) { throw "Provide -Repo or -RepoRoot." }
  if (-not (Test-Path $RepoRoot)) { throw "RepoRoot not found: $RepoRoot" }
  $remote = git -C $RepoRoot remote get-url origin
  if ($remote -match 'github\.com[:/](.+?)/(.+?)(?:\.git)?$') { return "$($Matches[1])/$($Matches[2])" }
  throw "Cannot parse origin remote in $RepoRoot"
}

$slug = Get-Slug -RepoRoot $RepoRoot -Repo $Repo

# Get runs with fields supported by current gh versions (no workflowPath)
$runsJson = gh run list --repo $slug --json attempt,conclusion,createdAt,databaseId,displayTitle,event,headBranch,headSha,name,number,startedAt,status,updatedAt,url,workflowDatabaseId,workflowName --limit 50
$runs = $runsJson | ConvertFrom-Json

# Filter by branch
if ($Branch) {
  $runs = $runs | Where-Object { $_.headBranch -eq $Branch }
}

# Optional workflow filter: accept file name (ci.yml), base name (ci), or display title match
if ($Workflow) {
  $wfKey = [System.IO.Path]::GetFileNameWithoutExtension($Workflow)
  $runs = $runs | Where-Object {
    ($_.workflowName -and $_.workflowName -eq $wfKey) -or
    ($_.name -and $_.name -eq $wfKey) -or
    ($_.displayTitle -and $_.displayTitle -match [regex]::Escape($wfKey))
  }
}

if (-not $runs -or $runs.Count -eq 0) {
  throw "No runs found for $slug on branch '$Branch'" + ($(if($Workflow){" (workflow filter '$Workflow')"} else {""}))
}

# Pick the newest run
$run = $runs | Sort-Object -Property @{Expression={ [datetime]$_.createdAt }}, number -Descending | Select-Object -First 1

$wfShown = if ($run.workflowName) { $run.workflowName } elseif ($run.name) { $run.name } else { "(unknown)" }
Write-Host ("Watching: {0} · #{1} · {2} · {3}" -f $wfShown, $run.number, $run.status, $run.url)

if ($Open) { try { Start-Process $run.url | Out-Null } catch {} }

# Watch to completion and propagate exit status
try {
  gh run watch --repo $slug $($run.databaseId) --exit-status
} catch {
  Write-Warning "gh run watch failed. Open: $($run.url)"
  exit 1
}
