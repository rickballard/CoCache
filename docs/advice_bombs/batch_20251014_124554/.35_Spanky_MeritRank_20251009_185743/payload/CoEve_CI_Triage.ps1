param([string]$Repo,[string]$Branch='main',[string]$Workflow='CI',[switch]$Open)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$run = gh run list --limit 1 -R $Repo --branch $Branch --workflow $Workflow --json databaseId,workflowName,url,status,conclusion | ConvertFrom-Json | Select-Object -First 1
if (-not $run) { throw "No runs for $Repo $Branch ($Workflow)" }
Write-Host ("Watching: {0} · #{1} · {2} · {3}" -f $run.workflowName,$run.databaseId,$run.status,$run.url)
Write-Host ("Run {0} ({1}) has already completed with '{2}'" -f $run.workflowName,$run.databaseId,$run.conclusion)
$log = gh run view $run.databaseId -R $Repo --log
$tail = ($log.splitlines()[-60:])
$markers = [string]::Join("`n",($_ for $_ in $log.splitlines() if $_ -match 'ERROR collecting|ModuleNotFoundError|##\[error\]'))
$body = @"
--- tail of logs ---

{0}

--- failure markers ---

{1}
"@ -f [string]::Join("`n",$tail), $markers
$dest = Join-Path $env:TEMP ("ci_run_{0}.log" -f $run.databaseId)
$body | Set-Content -Encoding UTF8 $dest
Write-Host "[LOG] Full logs -> $dest"
if ($Open) { Start-Process $run.url | Out-Null }

