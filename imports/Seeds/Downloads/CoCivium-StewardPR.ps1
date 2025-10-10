Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"
param([string]$Path = (Join-Path $HOME "Documents\GitHub\CoCivium"))
if(!(Test-Path $Path)){ throw "Repo not found: $Path" }
$branch = "governance/bootstrap-stewarded"
Push-Location $Path
git fetch --all | Out-Null
git checkout -B $branch | Out-Null

# banner snippet (non-personal)
$banner = @"
> **Stewarded, not owned.** CoCivium is a public, fork-first civic canon.
> Temporary stewards facilitate; the community owns the direction. See \`docs/governance/*\`.
"@
$readme = Join-Path $Path 'README.md'
if(Test-Path $readme){
  $txt = Get-Content $readme -Raw
  # Remove any direct personal "public-profile.md" front-and-center mention (keeps linklists elsewhere)
  $txt = $txt -replace '(?is)^.*?public-profile\.md.*?\r?\n',''
  $txt = $banner + "`r`n" + $txt
  $txt | Set-Content -Encoding UTF8 $readme
}else{
  $banner | Set-Content -Encoding UTF8 $readme
}

$gov = Join-Path $Path 'docs\governance'; New-Item -ItemType Directory -Force -Path $gov | Out-Null
@"
# Mission
No corruption. No coercion. No kings. Resist capture by any entity (human/AI/platform).
"@ | Set-Content -Encoding UTF8 (Join-Path $gov 'MISSION.md')
@"
# Governance (stewarded-not-owned)
- Stewards are temporary caretakers; ≥2 active; rotation; decisions transparent & reversible.
- Mirrors across platforms; signed releases.
"@ | Set-Content -Encoding UTF8 (Join-Path $gov 'GOVERNANCE.md')

$ops = Join-Path $Path 'docs\ops'; New-Item -ItemType Directory -Force -Path $ops | Out-Null
@("# Operating Log") | Set-Content -Encoding UTF8 (Join-Path $ops 'OPERATING_LOG.md')

git add -A
git commit -m "governance: stewarded-not-owned banner + bootstrap docs" | Out-Null
git push -u origin $branch | Out-Null
Write-Host "Pushed branch: $branch  → open PR in GitHub UI" -ForegroundColor Green
Pop-Location
