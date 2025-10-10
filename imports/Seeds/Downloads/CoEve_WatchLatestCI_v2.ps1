param(
  [string]$Repo,
  [string]$RepoRoot,
  [string]$Branch = 'main',
  [string]$Workflow,
  [switch]$Open
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RepoSlug {
  param([string]$Repo,[string]$RepoRoot)
  if ($Repo) { return $Repo }
  try {
    if ($RepoRoot) {
      $remote = git -C $RepoRoot remote get-url origin 2>$null
    } else {
      $remote = git remote get-url origin 2>$null
    }
    if ($LASTEXITCODE -ne 0 -or -not $remote) { return $null }
    if ($remote -match 'github\.com[:/](.+?)/(.+?)(?:\.git)?$') { return "$($Matches[1])/$($Matches[2])" }
    return $null
  } catch { return $null }
}

$slug = Get-RepoSlug -Repo $Repo -RepoRoot $RepoRoot
if (-not $slug) { throw "Unable to determine repo slug. Pass -Repo 'owner/repo' or -RepoRoot 'path\to\repo'." }

# Ensure GitHub CLI is available
try { gh --version *>$null } catch { throw "GitHub CLI 'gh' not found. Install from https://cli.github.com/ and authenticate with 'gh auth login'." }

# Build list args
$common = @('run','list','--repo', $slug, '--branch', $Branch, '--json', 'databaseId,headSha,headBranch,displayTitle,workflowName,workflowPath,status,conclusion,createdAt,updatedAt,htmlUrl', '--limit','30')
if ($Workflow) { $common += @('--workflow', $Workflow) }

# Fetch runs
$runsRaw = & gh @common
if ([string]::IsNullOrWhiteSpace($runsRaw)) { throw "No workflow runs returned for $slug on branch '$Branch'." }
try { $runs = $runsRaw | ConvertFrom-Json } catch { throw "Failed to parse gh JSON output." }
if (-not $runs -or $runs.Count -eq 0) { throw "No runs found for $slug on '$Branch'." }

# Pick latest
$latest = $runs | Sort-Object -Property @{Expression='createdAt';Descending=$true}, @{Expression='databaseId';Descending=$true} | Select-Object -First 1
if (-not $latest) { throw "No runs available after filtering." }

$wf = if ($latest.workflowName) { $latest.workflowName } elseif ($latest.workflowPath) { $latest.workflowPath } else { 'workflow' }
Write-Host ("Watching run {0} · {1} [{2}]" -f $latest.databaseId, $wf, $latest.headBranch) -ForegroundColor Cyan

if ($Open) { gh run view $latest.databaseId --repo $slug --web | Out-Null }

# Watch until completion and set exit code accordingly
gh run watch $latest.databaseId --repo $slug --exit-status
