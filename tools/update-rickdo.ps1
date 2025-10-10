param([Parameter(Mandatory=$true)][string]$RickDoPath,[Parameter(Mandatory=$true)][string]$CoCachePath,[double]$Accel=3.0)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function New-Badge([string]$Path,[string]$Label,[string]$Value){
  $fontSize  = 11; $charWidth = 6.2; $pad = 10
  $labelW = [math]::Ceiling(([math]::Max($Label.Length,3)*$charWidth)+2*$pad)
  $valueW = [math]::Ceiling(([math]::Max($Value.Length,3)*$charWidth)+2*$pad)
  $svgW   = $labelW + $valueW
  $svg = @(
    ('<svg xmlns="http://www.w3.org/2000/svg" width="{0}" height="20" role="img" aria-label="{1}: {2}">' -f $svgW, $Label, $Value)
    ('  <rect width="{0}" height="20" fill="#555"/>' -f $labelW)
    ('  <rect x="{0}" width="{1}" height="20" fill="#007ec6"/>' -f $labelW, $valueW)
    ('  <text x="{0}" y="14" fill="#fff" font-family="Verdana" font-size="{1}">{2}</text>' -f $pad, $fontSize, $Label)
    ('  <text x="{0}" y="14" fill="#fff" font-family="Verdana" font-size="{1}">{2}</text>' -f [math]::Ceiling($labelW+$pad), $fontSize, $Value)
    '</svg>'
  ) -join "
"
  $svg | Set-Content $Path -Encoding UTF8
}

function _CountSafe([string]$path,[string]$rx){ if(Test-Path $path){ ([regex]::Matches((Get-Content $path -Raw),$rx)).Count } else { 0 } }

# Inputs from CoCache
$map = if (Test-Path (Join-Path $CoCachePath 'imports\_discovery_map.csv')) { Join-Path $CoCachePath 'imports\_discovery_map.csv' } else { Join-Path $CoCachePath 'imports\_discovery_map_SLIM.csv' }
$hashDb  = Join-Path $CoCachePath 'imports\_ingest_hashes.json'
$session = Join-Path $CoCachePath 'STATUS\_SESSION_LOG.ndjson'
$beat    = Join-Path $CoCachePath 'STATUS\ingest_progress.txt'

$total  = (Test-Path $map)    ? ((Import-Csv $map | Measure-Object).Count) : 0
$done   = (Test-Path $hashDb) ? ((ConvertFrom-Json -AsHashtable -InputObject (Get-Content $hashDb -Raw)).Count) : 0
$remain = [math]::Max(0,$total-$done)

# Throughput estimate from last 7 days (session/beat)
$now = Get-Date; $cut = $now.AddDays(-7); [int]$copiedEst = 0
if (Test-Path $session){
  $rows = @(Get-Content $session | ForEach-Object { try { $_ | ConvertFrom-Json } catch { $null } } |
    Where-Object { $_ -and $_.'when' } |
    ForEach-Object { [pscustomobject]@{ when=[datetime]::Parse($_.'when'); note=$_.note } } |
    Where-Object { $_.'when' -ge $cut })
  if ($rows.Count -ge 2){
    $vals=@(); foreach($r in $rows){ if($r.note -match 'copied=(\d+)'){ $vals += [int]$Matches[1] } }
    if($vals.Count -ge 2){ $copiedEst = ($vals[-1]-$vals[0]) }
  }
}
if ($copiedEst -eq 0 -and (Test-Path $beat)){
  $beats = @(Get-Content $beat -Tail 2000 | Where-Object { $_ -match 'p=\d+ c=\d+ s=\d+' })
  if($beats.Count -ge 2){
    $c1=0; $c2=0; if($beats[0]-match 'c=(\d+)'){ $c1=[int]$Matches[1] }; if($beats[-1]-match 'c=(\d+)'){ $c2=[int]$Matches[1] };
    if($c2 -ge $c1){ $copiedEst = $c2-$c1 }
  }
}
$tpd = [math]::Round([double]$copiedEst/7.0,1); if($tpd -lt 0){ $tpd=0 }
function _ETA([int]$rem,[double]$pd){ if($pd -le 0){ '∞' } else { ('{0}d' -f [math]::Ceiling($rem/$pd)) } }
$etaBase = _ETA $remain ([math]::Max(1,$tpd)); $etaFast = _ETA $remain ([math]::Max(1,$tpd*$Accel))

# Repo sanitation + hitchhiker counts
$root = Split-Path $RickDoPath -Parent
$repos=@(); try { $repos = Get-ChildItem $root -Directory | Where-Object { Test-Path (Join-Path $_ '.git') } } catch { $repos=@() }
[int]$dirtyRepos=0; [int]$dirtyFiles=0; [int]$hhMissing=0; [int]$totalRepos=($repos|Measure-Object).Count
foreach($r in $repos){
  $rp = $r.FullName
  $st = git -C $rp status --porcelain 2>$null
  if($LASTEXITCODE -eq 0 -and $st){ $dirtyRepos++; $dirtyFiles += ($st|Measure-Object).Count }
  $hasHH = (Test-Path (Join-Path $rp 'HITCHHIKER.md')) -or (Test-Path (Join-Path $rp 'docs\HITCHHIKER.md'))
  if(-not $hasHH){ $hhMissing++ }
}

# Badges
$badges = Join-Path $RickDoPath 'STATUS\badges'; New-Item -ItemType Directory -Force -Path $badges | Out-Null
New-Badge (Join-Path $badges 'eta_badge.svg')        'ETA (base/CoAgent)' ('{0} / {1}' -f $etaBase, $etaFast)
New-Badge (Join-Path $badges 'throughput_badge.svg') 'Throughput (7d)'    ('{0}/day' -f $tpd)
New-Badge (Join-Path $badges 'last_tick_badge.svg')  'Last Tick'          ('{0:yyyy-MM-dd HH:mm}' -f (Get-Date))
New-Badge (Join-Path $badges 'sanitation_badge.svg') 'Sanitation'         ('{0} repos / {1} files' -f $dirtyRepos, $dirtyFiles)
New-Badge (Join-Path $badges 'hitchhiker_badge.svg') 'Hitchhikers'        ('{0} missing / {1}' -f $hhMissing, $totalRepos)

# Table rows
('| Ingest (CoCache map) | {0} | {1}/day | {2} | {3} |' -f $remain, $tpd, $etaBase, $etaFast) | Set-Content (Join-Path $RickDoPath 'STATUS\table_ingest_row.md') -Encoding UTF8
@(
  ('| Repo Sanitation | {0} repos / {1} files | — | — | — |' -f $dirtyRepos, $dirtyFiles)
  ('| Hitchhiker Docs | {0} / {1} repos missing | — | — | — |' -f $hhMissing, $totalRepos)
) | Set-Content (Join-Path $RickDoPath 'STATUS\table_ops_rows.md') -Encoding UTF8

# Notices (ensure pinned + today exist)
$notices = Join-Path $RickDoPath 'STATUS\notices'; New-Item -ItemType Directory -Force -Path $notices | Out-Null
$pinned = Join-Path $notices 'pinned.md'
if(-not (Test-Path $pinned)){ '# Pinned Notices
- ⭐ Keep CoAgent PRs moving.
- ⭐ Sanitation: commit/clean repos flagged above.' | Set-Content $pinned -Encoding UTF8 }
$today = Join-Path $notices ((Get-Date -Format 'yyyy-MM-dd') + '.md')
if(-not (Test-Path $today)){ '# Daily Notices

**Top 3 for today**
1. ☐
2. ☐
3. ☐' | Set-Content $today -Encoding UTF8 }

git -C $RickDoPath add -A
git -C $RickDoPath commit -m ('chore(dashboard): refresh from CoCache (remain={0}; tpd={1}; eta={2}->{3}; dirtyRepos={4})' -f $remain, $tpd, $etaBase, $etaFast, $dirtyRepos) 2>$null | Out-Null
git -C $RickDoPath push
