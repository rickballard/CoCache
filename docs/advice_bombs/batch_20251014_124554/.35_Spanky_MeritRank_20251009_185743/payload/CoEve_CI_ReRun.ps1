param([string]$Repo,[string]$Branch='main',[string]$Workflow='CI',[switch]$Watch,[switch]$Open)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$run = gh run list --limit 1 -R $Repo --branch $Branch --workflow $Workflow --json databaseId,url | ConvertFrom-Json | Select-Object -First 1
if (-not $run) { throw "No runs" }
Write-Host ("Re-running: {0} · #{1} · {2}" -f $Workflow,$run.databaseId,$run.url)
gh run rerun $run.databaseId -R $Repo | Out-Null
if ($Open) { Start-Process $run.url | Out-Null }
if ($Watch) { gh run watch $run.databaseId -R $Repo --exit-status }
