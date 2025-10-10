param(
  [string]$Repo = "$env:USERPROFILE\Documents\GitHub\CoCivium",
  [string]$BranchPrefix = "test/corender-ping"
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if(-not (Test-Path $Repo)){ Write-Error "Repo not found: $Repo"; exit 1 }

$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$branch = "$BranchPrefix-$stamp"
$svgDir = Join-Path $Repo "branding\ping"
New-Item -ItemType Directory -Force -Path $svgDir | Out-Null
$svg = @"
<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">
  <rect width="512" height="512" fill="#111"/>
  <circle cx="256" cy="256" r="180" fill="#eee"/>
  <text x="50%" y="50%" font-size="48" fill="#111" dominant-baseline="middle" text-anchor="middle">CoRender Ping</text>
</svg>
"@
$svgPath = Join-Path $svgDir "ping.svg"
Set-Content -Path $svgPath -Value $svg -Encoding UTF8

Push-Location $Repo
try {
  git fetch --all | Out-Null
  git checkout -b $branch | Out-Null
  git add $svgPath
  if(git status --porcelain){
    git commit -m "Add ping.svg to trigger CoRender CI ($stamp)"
    git push -u origin $branch | Out-Null
    Write-Host "[CoRender-Ping] pushed branch $branch. Open a PR to watch renders."
  } else {
    Write-Host "[CoRender-Ping] nothing to commit"
  }
} finally { Pop-Location }
