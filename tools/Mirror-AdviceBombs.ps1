param(
  [string]$From = (Join-Path $HOME "Documents\GitHub\CoCache\advice\incoming"),
  [string]$To   = (Join-Path $HOME "Documents\GitHub\CoAgent\advice\incoming"),
  [string]$BranchPrefix = "advice/mirror"
)
$ErrorActionPreference='Stop'
$env:GIT_TERMINAL_PROMPT='0'

$GH = Join-Path $HOME 'Documents\GitHub'
$CA = Join-Path $GH   'CoAgent'
New-Item -ItemType Directory -Force -Path $To | Out-Null

$added=@()
Get-ChildItem $From -Filter *.zip -File -ErrorAction SilentlyContinue | ForEach-Object {
  $dst = Join-Path $To $_.Name
  Copy-Item -LiteralPath $_.FullName -Destination $dst -Force
  $added += $_.Name
}
if(-not $added.Count){ "No new zips to mirror."; exit 0 }

# Create topic branch, commit, push, PR
$ts = Get-Date -Format 'yyyyMMdd_HHmmss'
$branch = "$BranchPrefix-$ts"
git -C $CA checkout -b $branch | Out-Null
git -C $CA add -- 'advice/incoming/*.zip'
git -C $CA commit -m "advice: mirror $(($added -join ', ')) from CoCache" | Out-Null
git -C $CA push -u origin $branch | Out-Null

# Open PR if gh exists
if(Get-Command gh -ErrorAction SilentlyContinue){
  gh pr create --repo "rickballard/CoAgent" --head $branch `
    --base main --title "Mirror AdviceBombs ($ts)" `
    --body "Automated mirror from CoCache: $($added -join ', ')" 2>$null | Out-Null
}
"✔ Mirrored & PR ready: $branch`n  Files: $($added -join ', ')"
