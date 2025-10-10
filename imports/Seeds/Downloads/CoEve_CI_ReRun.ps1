param(
  [string]$Repo,
  [string]$RepoRoot,
  [string]$Branch = 'main',
  [string]$Workflow,     # optional: specific workflow name/file
  [switch]$Watch,        # watch after rerun
  [switch]$Open
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Resolve-RepoSlug {
  param([string]$Repo,[string]$RepoRoot)
  if ($Repo) { return $Repo }
  if ($RepoRoot) {
    if (-not (Test-Path $RepoRoot)) { throw "RepoRoot not found: $RepoRoot" }
    $remote = git -C $RepoRoot remote get-url origin
    if ($remote -match 'github\.com[:/](.+?)/(.+?)(?:\.git)?$') { return "$($Matches[1])/$($Matches[2])" }
    throw "Cannot resolve repo slug from origin remote."
  }
  throw "Provide -Repo or -RepoRoot."
}

$slug = Resolve-RepoSlug -Repo $Repo -RepoRoot $RepoRoot

$runs = gh run list --repo $slug --json databaseId,number,name,displayTitle,conclusion,status,headBranch,url,workflowName,createdAt --limit 50 | ConvertFrom-Json
if (-not $runs) { throw "No workflow runs returned for $slug." }
$runs = $runs | Where-Object { $_.headBranch -eq $Branch }

if ($Workflow) {
  $wf = $Workflow.ToLowerInvariant()
  $runs = $runs | Where-Object {
    ($_.workflowName -and $_.workflowName.ToLowerInvariant() -like "*$wf*") -or
    ($_.name -and $_.name.ToLowerInvariant() -like "*$wf*") -or
    ($_.displayTitle -and $_.displayTitle.ToLowerInvariant() -like "*$wf*")
  }
}

# Prefer most recent failed; else most recent completed; else newest
$pick = $runs | Where-Object { $_.status -eq 'completed' -and $_.conclusion -eq 'failure' } |
        Sort-Object -Property @{Expression="createdAt";Descending=$true} | Select-Object -First 1
if (-not $pick) {
  $pick = $runs | Sort-Object -Property @{Expression="createdAt";Descending=$true} | Select-Object -First 1
}

if (-not $pick) { throw "No suitable run to rerun for $slug on branch '$Branch'." }

$rid = $pick.databaseId
$nm  = $pick.name ?? $pick.workflowName ?? 'workflow'
Write-Host ("Re-running: {0} · #{1} · {2}" -f $nm, $pick.number, $pick.url)

gh run rerun --repo $slug $rid | Out-Null

if ($Open) { try { Start-Process $pick.url | Out-Null } catch {} }
if ($Watch) { gh run watch --repo $slug $rid --exit-status }
