param([switch]$PublicOnly,[switch]$ForceOptIn)
$ErrorActionPreference="Stop"
$GitRoot = Join-Path $HOME "Documents\GitHub"
$CC     = Join-Path $GitRoot "CoCache"
$LogDir = Join-Path $CC "status\log"; New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$BeatMD = Join-Path $CC "status\heartbeats.md"
$Today  = Get-Date -Format "yyyyMMdd"
$Emit   = Join-Path $CC "tools\CoSync-Emit.ps1"

function IsPublic($root){
  $url = git -C $root ls-remote --get-url 2>$null
  return $true  # keep simple; include everything unless you add gh checks
}

$repos = Get-ChildItem -Directory $GitRoot | ? { Test-Path (Join-Path $_.FullName ".git") }
foreach($dir in $repos){
  $root = $dir.FullName
  if($PublicOnly -and -not (IsPublic $root)){ continue }
  $optIn = (Test-Path (Join-Path $root ".cosync.ok")) -or (Test-Path (Join-Path $root ".cosync-allow"))
  if(-not $optIn -and -not $ForceOptIn){ continue }

  $name   = Split-Path $root -Leaf
  $branch = (git -C $root rev-parse --abbrev-ref HEAD).Trim()
  $area   = switch -regex ($name) { '^Games$'{'FTW'} '^CoPolitic$'{'plane-app'} default{'general'} }

  $last = git -C $root log -1 --date=iso-strict --pretty='format:%h|%cd'
  $lastSha,$lastWhen = $last -split '\|',2
  & $Emit -RepoRoot $root -Area $area -Type intent   -Summary "all-repos sweep" -Data @{ branch=$branch }
  & $Emit -RepoRoot $root -Area $area -Type progress -Summary "heartbeat"       -Data @{ lastChange=$lastWhen; sha=$lastSha }

  $repoMB = [math]::Round(((Get-ChildItem $root -Recurse -File -ea SilentlyContinue |
     ? { $_.FullName -notlike "*\.git\*" } | Measure-Object -Sum Length).Sum/1MB),2)
  $tag = (git -C $root tag --sort=-creatordate | Select-Object -First 1); if(-not $tag){ $tag="(none)" }
  Add-Content -LiteralPath $BeatMD -Enc UTF8 -Value ('[{0}] {1}: branch={2} tag={3} last={4} sha={5} size={6}MB' -f (Get-Date -Format 'yyyy-MM-dd HH:mm'), $name, $branch, $tag, $lastWhen, $lastSha, $repoMB)

  $bloat = Join-Path $CC ("status\cosync_bloat_{0}_{1}.txt" -f $name, $Today)
  $top = Get-ChildItem $root -Recurse -File -ea SilentlyContinue | ? { $_.FullName -notlike "*\.git\*" } | Sort-Object Length -Descending | Select-Object FullName, @{n="MB";e={[math]::Round($_.Length/1MB,2)}} -First 12
  @(
    "CoSync Bloat Report — $name — $(Get-Date -Format s)"
    "Repo Size (excl .git): ${repoMB} MB"
    ""
    "Top 12 files (MB):"
  ) + ($top | % { "{0,6}  {1}" -f $_.MB, $_.FullName }) | Set-Content -Enc UTF8 -LiteralPath $bloat
}

git -C $CC add -- "status/log/*.jsonl" "status/*.txt" "status/heartbeats.md" 2>$null
if(!(git -C $CC diff --cached --quiet)){ git -C $CC commit -m "cosync(all-repos): heartbeats + receipts + bloat reports"; git -C $CC push }
Write-Host "✓ All-repos CoSync complete."
