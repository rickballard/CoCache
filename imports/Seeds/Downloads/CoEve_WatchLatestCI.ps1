param(
  [string]$Branch = 'main',
  [string]$Workflow = ''  # e.g., 'ci.yml' or 'mapper-smoke.yml'; empty = latest across all workflows
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$cmd = @('run','list','--branch', $Branch,'--limit','1','--json','databaseId,name,displayTitle,headSha,headBranch,workflowName,conclusion,status')
if ($Workflow) { $cmd += @('--workflow', $Workflow) }
$r = gh @cmd | ConvertFrom-Json
if (-not $r -or $r.Count -eq 0) { throw "No runs found for branch '$Branch'." }
$id = $r[0].databaseId
gh run view $id
gh run watch $id --exit-status