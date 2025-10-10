param(
  [string]$Repo,                     # e.g. "owner/repo"
  [string]$RepoRoot,                 # local clone path (optional alternative to -Repo)
  [string]$Branch = 'main',
  [string]$Workflow,                 # optional: file name or display name filter (e.g. "ci.yml" or "CI")
  [switch]$Open                      # open the run URL in browser
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

# Pull recent runs (use fields supported by current gh)
$runsRaw = gh run list --repo $slug --json databaseId,number,name,displayTitle,conclusion,status,headBranch,headSha,url,workflowName,createdAt --limit 40
if ([string]::IsNullOrWhiteSpace($runsRaw)) { throw "No workflow runs returned for $slug." }
$runs = $runsRaw | ConvertFrom-Json

# Filter by branch
$runs = $runs | Where-Object { $_.headBranch -eq $Branch }

# Optional filter by workflow (matches workflowName, name, or displayTitle, OR file suffix)
if ($Workflow) {
  $wf = $Workflow.ToLowerInvariant()
  $runs = $runs | Where-Object {
    ($_.workflowName -and $_.workflowName.ToLowerInvariant() -like "*$wf*") -or
    ($_.name -and $_.name.ToLowerInvariant() -like "*$wf*") -or
    ($_.displayTitle -and $_.displayTitle.ToLowerInvariant() -like "*$wf*")
  }
}

if (-not $runs -or $runs.Count -eq 0) { throw "No runs found for $slug on branch '$Branch' with workflow filter '$Workflow'." }

# Pick newest by createdAt (fallback to number)
$run = $runs | Sort-Object -Property @{Expression="createdAt";Descending=$true},@{Expression="number";Descending=$true} | Select-Object -First 1

$rid = $run.databaseId
Write-Host ("Watching: {0} · #{1} · {2} · {3}" -f ($run.name ?? $run.workflowName ?? "workflow"),
            $run.number, $run.status, $run.url)

# If already completed, just say so; else show a live watch
if ($run.status -eq 'completed') {
  Write-Host ("Run {0} ({1}) has already completed with '{2}'" -f ($run.name ?? $run.workflowName), $rid, $run.conclusion)
} else {
  gh run watch --repo $slug $rid --exit-status
}

# Always fetch logs for triage
$logPath = Join-Path $env:TEMP ("ci_run_{0}.log" -f $rid)
$logs = gh run view --repo $slug $rid --log
$logs | Set-Content -LiteralPath $logPath -Encoding UTF8

# Heuristic: print last ~120 lines and any obvious failure markers
$tail = ($logs -split "`r?`n") | Select-Object -Last 120
Write-Host "`n--- tail of logs ---`n" -ForegroundColor Cyan
$tail | ForEach-Object { $_ }

$markers = ($logs -split "`r?`n") | Where-Object {
  $_ -match '(?i)\b(FAIL|ERROR|AssertionError|Traceback|E\s{2,})\b'
} | Select-Object -First 40
if ($markers) {
  Write-Host "`n--- failure markers ---`n" -ForegroundColor Yellow
  $markers | ForEach-Object { $_ }
}

Write-Host ("`n[LOG] Full logs -> {0}" -f $logPath) -ForegroundColor Green

if ($Open) {
  try { Start-Process $run.url | Out-Null } catch {}
}
