
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = (git rev-parse --show-toplevel) 2>$null
if(-not $repo){ throw "Run inside a Git repo." }
Set-Location $repo

$destRel = "Insights\BN_Story_being-noname_v1.0.md"
$dest = Join-Path $repo $destRel

$local = @(
  "Recovery\CrossRepo\Insights__BN_Story_being-noname_v1.0.md",
  "Recovery\Strays\Insights__BN_Story_being-noname_v1.0.md"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ } | Select-Object -First 1

if(-not $local){
  Write-Host "Local fallback not found; creating placeholder if missing." -ForegroundColor Yellow
  if(-not (Test-Path $dest)){
    "# Being Noname (placeholder)" | Set-Content -LiteralPath $dest -Encoding UTF8
  }
} else {
  New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
  Copy-Item -LiteralPath $local -Destination $dest -Force
}

git add -- $destRel 2>$null
$st = git diff --cached --name-only
if($st){
  git commit -m "bn(sync): update canonical 'Being Noname'"
  Write-Host "Committed $destRel" -ForegroundColor Green
} else {
  Write-Host "No changes to commit — $destRel already up to date." -ForegroundColor DarkYellow
}
