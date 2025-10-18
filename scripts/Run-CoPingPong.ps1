$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
function ShortSha(){ (git rev-parse --short HEAD) }
function Sha12($p){ if(Test-Path $p){ (Get-FileHash $p -Algorithm SHA256).Hash.Substring(0,12) } }
$Repo="$HOME\Documents\GitHub\CoCache"
$H  = Join-Path $Repo 'docs\HANDOFFS\HANDOFF_LATEST.md'
$C  = Join-Path $Repo 'docs\HANDOFFS\SessionContract.json'
$I  = Join-Path $Repo 'docs\HANDOFFS\CoPing.in.json'

Push-Location $Repo
git pull --ff-only | Out-Null

if(!(Test-Path $I)){ Write-Host "[idle] no CoPing.in.json"; Pop-Location; exit 0 }
$ping = Get-Content $I -Raw | ConvertFrom-Json
if(($ping.status ?? 'pending') -ne 'pending'){ Write-Host "[skip] status=$($ping.status)"; Pop-Location; exit 0 }

# --- Very lean actions (bootstrap-from-readmes / refresh-* / metrics-scan) ---
$now = Get-Date -Format o
# Ensure handoffs dir
New-Item -Force -ItemType Directory (Split-Path $H) | Out-Null

# HANDOFF_LATEST.md (≤10 KB, lean pointers)
$handoff = @"
# Handoff (LEAN)
Updated: $now
Session: $($ping.session_id)

## Canonicals
- HANDOFF: docs/HANDOFFS/HANDOFF_LATEST.md
- Contract: docs/HANDOFFS/SessionContract.json
- README:  README.md
- Metrics: docs/METRICS_INDEX.md
"@
$handoff | Out-File -Encoding UTF8 $H

# SessionContract.json (≤4 KB)
$contract = [ordered]@{
  session_id   = $ping.session_id
  ts           = $now
  repos        = $ping.repos
  intent       = $ping.intent
  next_actions = $ping.next_actions
  ttl_days     = 3
  pointers     = @{ handoff_latest='docs/HANDOFFS/HANDOFF_LATEST.md'; contract_json='docs/HANDOFFS/SessionContract.json' }
}
($contract | ConvertTo-Json -Depth 6) | Out-File -Encoding UTF8 $C

# Simple metrics sniff (optional)
$M = Join-Path $Repo 'docs\METRICS_INDEX.md'
$rows = (Test-Path $M) ? ((Select-String -Path $M -Pattern '^\|\s*[^-]').Count) : 0
$hdgs = (Test-Path $M) ? ((Select-String -Path $M -Pattern '^\s*#').Count) : 0

git add -- $H $C
git commit -m "CoPong: refresh handoff/contract for $($ping.session_id) @ $now" | Out-Null
git push | Out-Null
$sha = ShortSha

# Mark processed
$ping.status = 'done'
try {
  $ping | Add-Member -NotePropertyName processed_sha -NotePropertyValue $sha -Force
} catch {}
($ping | ConvertTo-Json -Depth 6) | Out-File -Encoding UTF8 $I

# Emit CoPong receipt (fenced)
$hLen=(Get-Item $H).Length; $cLen=(Get-Item $C).Length
$hHash=Sha12 $H; $cHash=Sha12 $C
$branch=(git rev-parse --abbrev-ref HEAD)
$cycle   = if($ping.PSObject.Properties.Name -contains 'cycle_id' -and $ping.cycle_id){ $ping.cycle_id } else { '0000' }
$attempt = if($ping.PSObject.Properties.Name -contains 'attempt'   -and $ping.attempt)  { [int]$ping.attempt } else { 1 }
$prev    = if($ping.PSObject.Properties.Name -contains 'prev'      -and $ping.prev)     { $ping.prev } else { '-' }

@"
===== CoPONG RECEIPT BEGIN =====
session_id: $($ping.session_id)  cycle_id: $cycle  attempt: $attempt  status: ready
commit: prev $prev -> new $sha  repo: CoCache  branch: $branch
wrote: HANDOFF_LATEST.md ($hLen B, sha256:$hHash)  SessionContract.json ($cLen B, sha256:$cHash)
metrics_index_rows: $rows  headings: $hdgs  last_updated: $now
links: https://github.com/rickballard/CoCache/blob/main/docs/HANDOFFS/HANDOFF_LATEST.md | https://github.com/rickballard/CoCache/blob/main/docs/HANDOFFS/SessionContract.json
TTL: 3d
===== CoPONG RECEIPT END =====
"@ | Write-Output
Pop-Location




