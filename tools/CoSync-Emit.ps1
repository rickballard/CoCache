param(
  [string]$RepoRoot = (Resolve-Path ".").Path,
  [string]$Area='generic',
  [ValidateSet('progress','alert','note','error','handoff','intent','housekeeping','plan')]
  [string]$Type='progress',
  [string]$Summary='',
  [hashtable]$Data,
  [string]$DataJson,
  [switch]$RunHousekeeping
)
$ErrorActionPreference='Stop'
if($DataJson){ $Data = ConvertFrom-Json -AsHashtable $DataJson }

# CoCache base (receipts live here)
$GH = Join-Path $HOME 'Documents\GitHub'
$CC = Join-Path $GH 'CoCache'
$LogDir = Join-Path $CC 'status\log'; New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Jsonl  = Join-Path $LogDir ("cosync_{0}.jsonl" -f ([DateTime]::UtcNow.ToString('yyyyMMdd')))

# Repo name for the emitter
$root = (git -C $RepoRoot rev-parse --show-toplevel 2>$null); if(-not $root){ $root = $RepoRoot }
$repo = Split-Path $root -Leaf

function Get-GitHubMeta([string]$repoPath){
  $origin = (git -C $repoPath remote get-url origin 2>$null)
  if(!$origin){ return $null }
  if($origin -match 'github\.com[:/]+([^/]+)/([^/\.]+)'){
    $owner = $Matches[1]; $r = $Matches[2]
  } else { return $null }
  $branch = (git -C $repoPath rev-parse --abbrev-ref HEAD 2>$null); if(!$branch){ $branch='main' }
  [pscustomobject]@{
    owner=$owner; repo=$r; branch=$branch;
    blobBase="https://github.com/$owner/$r/blob/$branch/";
    rawBase ="https://raw.githubusercontent.com/$owner/$r/$branch/"
  }
}

$metaCC = Get-GitHubMeta $CC

function Add-Abs([hashtable]$h, [string]$key, [string]$root){
  if(-not $h) { return }
  if(-not $h.ContainsKey($key)) { return }
  if(-not $metaCC) { return }
  $p = [string]$h[$key]
  if([string]::IsNullOrWhiteSpace($p)) { return }
  # allow plain relative like 'docs/intent/SESSION_PLAN_*.md'
  if(Test-Path (Join-Path $root $p)){
    $full = Join-Path $root $p
  } elseif(Test-Path $p){
    $full = (Resolve-Path $p).Path
  } else {
    # leave as-is; still attempt to craft URL under CoCache
    $full = Join-Path $root $p
  }
  $rel = $full -replace [regex]::Escape("$root\"), '' -replace '\\','/'
  $h["${key}_abs_blob"] = $metaCC.blobBase + $rel
  $h["${key}_abs_raw"]  = $metaCC.rawBase  + $rel
}

# payload
$payload = [pscustomobject]@{
  repo=$repo
  commit=(git -C $root rev-parse --short HEAD 2>$null)
  when=[DateTime]::UtcNow.ToString('o')
  area=$Area
  type=$Type
  summary=$Summary
  data=$Data
  user=@{ anon = $true; hint = "$env:USERNAME@local" }
  session=@{ role = 'CoPrime' }
  actor=@{ type='ai'; name='GPT-5 Thinking' }
  source='cosync-emit'
}

# Attach absolute URLs for well-known data keys (under CoCache)
if($payload.data -is [hashtable]){
  $keys = @('handoff_md','plan','start','index','gaps','csv')
  foreach($k in $keys){ Add-Abs -h $payload.data -key $k -root $CC }
}

((( $payload | ConvertTo-Json -Depth 12) + "`n")) | Add-Content -Encoding UTF8 -LiteralPath $Jsonl
Write-Host "✔ CoSync emit → $Jsonl"

if($RunHousekeeping){
  $hk = Join-Path $CC 'tools\Housekeep-Bloat.ps1'
  if(Test-Path $hk){ pwsh -NoLogo -NoProfile -File $hk | Out-Null }
}

