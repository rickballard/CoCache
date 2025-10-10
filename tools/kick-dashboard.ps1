param([string]$Note = "manual kick")
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSCommandPath | Split-Path -Parent  # tools -> repo root
$session = Join-Path $root "STATUS\_SESSION_LOG.ndjson"
$beat    = Join-Path $root "STATUS\ingest_progress.txt"
[int]$c = 0
if (Test-Path $beat) {
  $last = Get-Content $beat -Tail 1 2>$null
  if ($last -match "c=(\d+)") { $c = [int]$Matches[1] }
}
("{0}" -f (@{ when=(Get-Date -Format s); note=("copied={0} ({1})" -f $c,$Note) } | ConvertTo-Json -Compress)) |
  Add-Content $session -Encoding UTF8
git -C $root add STATUS/_SESSION_LOG.ndjson
git -C $root commit -m ("ops: heartbeat ({0})" -f $Note) 2>$null
git -C $root push
