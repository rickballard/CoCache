param([string]$Repo=".", [switch]$VerboseOut)
$ErrorActionPreference='Stop'
function Has($n){(Get-Command $n -ErrorAction SilentlyContinue) -ne $null}
Set-Location $Repo
$local = git for-each-ref --sort=-committerdate --format="%(refname:short)" refs/heads/handover/* 2>$null | Select-Object -First 1
if (-not $local) {
  $remote = git for-each-ref --sort=-committerdate --format="%(refname:short)" refs/remotes/origin/handover/* 2>$null | Select-Object -First 1
  if ($remote) { $local = ($remote -replace '^origin/',''); git checkout -b $local $remote | Out-Null }
}
if (-not $local) { throw "No handover/* branches found." }
git switch $local | Out-Null
git push -u origin HEAD | Out-Null
$Hando = (Get-ChildItem -Directory 'HANDOVER' | Sort-Object Name -Descending | Select-Object -First 1).Name
$Stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$TITLE = "HANDOVER $Hando — seed push ($Stamp)"
$BODY  = "Seed-phase; TODO=PUSH. Policy: docs/advicebombs/cocore-pointer.md"
$tmp = Join-Path $env:TEMP "seed_$Stamp.md"; Set-Content $tmp -Value $BODY -Encoding utf8
if (Has gh) {
  $prNum = gh pr view $local --json number --jq .number 2>$null
  if (-not $prNum) { gh pr create --base main --head $local --title $TITLE --body-file $tmp | Out-Null; $prNum = gh pr view $local --json number --jq .number }
  gh pr merge $prNum --squash --delete-branch --admin 2>$null `
    || gh pr merge $prNum --squash --delete-branch
} else {
  $url = "https://github.com/(git remote get-url origin | % { ($_ -replace '.*github.com[/:]','').TrimEnd('.git') })/compare/main...$local?expand=1&title=$([uri]::EscapeDataString($TITLE))"
  Write-Host "Open and merge: $url" -ForegroundColor Yellow
  return
}
git fetch --prune; git switch main; git branch --set-upstream-to=origin/main main 2>$null; git pull --ff-only
if ($VerboseOut){ Write-Host "Merged $local to main." -ForegroundColor Green }

