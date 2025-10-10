
param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$Base = 'main'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
$RepoRoot = (Resolve-Path $RepoRoot).Path
Push-Location $RepoRoot

git fetch --all --prune | Out-Null
git checkout $Base | Out-Null
git pull --ff-only | Out-Null

$remote = git remote get-url origin
if ($remote -match 'github\.com[:/](.+?)/(.+?)(?:\.git)?$') { $Owner=$Matches[1]; $Repo=$Matches[2] } else { throw "Cannot parse origin remote." }
$branch = "advice/readme-badges-" + (Get-Date -Format 'yyyyMMdd-HHmmss')
git checkout -b $branch | Out-Null

$readme = Join-Path $RepoRoot 'README.md'
if (-not (Test-Path $readme)) { New-Item -ItemType File -Path $readme | Out-Null }

$badge = "[![Mapper Smoke](https://github.com/$Owner/$Repo/actions/workflows/mapper-smoke.yml/badge.svg?branch=$Base)](https://github.com/$Owner/$Repo/actions/workflows/mapper-smoke.yml)"
$content = Get-Content -LiteralPath $readme -Raw -ErrorAction SilentlyContinue
if ($content -notmatch 'Mapper Smoke') {
  $header = "# MeritRank`n`n" + $badge + "`n`n"
  if ($content) { $content = $header + $content } else { $content = $header + "Starter README." }
  Set-Content -LiteralPath $readme -Value $content -Encoding UTF8
}

$changed = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changed)) {
  Write-Host "[SKIP] No README changes to commit." -ForegroundColor Yellow
} else {
  git add $readme
  git commit -m "docs: add CI badge for mapper-smoke" | Out-Null
  git push -u origin $branch | Out-Null
  try {
    gh pr create --title "docs: add CI badge for mapper-smoke" --body "Adds a status badge to README." --base $Base --head $branch | Out-Null
    gh pr merge $branch --squash --delete-branch | Out-Null
    Write-Host "[OK] Badge PR merged." -ForegroundColor Green
  } catch {
    Write-Host "[INFO] PR created but not merged automatically." -ForegroundColor Yellow
  }
}

Pop-Location
