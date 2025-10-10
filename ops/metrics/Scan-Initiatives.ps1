param(
  [string]$ReposList = "$(Resolve-Path ./ops/CoSuite/repos.txt)",
  [string]$OutDir    = "$(Resolve-Path ./docs/dashboards)"
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$rows = @()

# helpers
function Count-Files($root, [string[]]$globs){
  $total = 0
  foreach($g in $globs){
    $total += @(Get-ChildItem -LiteralPath $root -Recurse -File -Include $g -ErrorAction SilentlyContinue).Count
  }
  $total
}

$repos = Get-Content $ReposList | ? { $_ -and $_ -notmatch '^\s*#' } | % { $_.Trim() }
foreach($id in $repos){
  $owner,$name = $id.Split('/',2); if(-not $name){ continue }
  $path = Join-Path $HOME "Documents\GitHub\$name"
  if(!(Test-Path $path)){ git clone "https://github.com/$owner/$name" $path | Out-Null }

  # file-scan buckets (tweak anytime)
  $idea     = Count-Files $path @("docs\idea*\*.md","docs\ideacards\*.md")
  $insights = Count-Files $path @("docs\insights\*.md")
  $advice   = Count-Files $path @("docs\advice* \*.md","docs\advis* \*.md")  # advicebombs/advisories
  $roadmap  = Count-Files $path @("docs\roadmap\*.md","ROADMAP.md")
  $scrolls  = Count-Files $path @("docs\cc\scroll\README.md")

  # PR/issue inference via gh (best-effort; safe if gh is missing)
  $pr = 0; $iss = 0
  if (Get-Command gh -ErrorAction SilentlyContinue){
    Push-Location $path
    $pr  = @(gh pr list --state open --json number,title,headRefName --limit 200 2>$null | ConvertFrom-Json).Count
    $iss = @(gh issue list --state open --label "initiative,idea" --json number,title --limit 200 2>$null | ConvertFrom-Json).Count
    Pop-Location
  }

  $rows += [pscustomobject]@{
    Repo=$name; IdeaCards=$idea; Insights=$insights; Advice=$advice; Roadmap=$roadmap; Megascrolls=$scrolls; OpenPRs=$pr; OpenInitiativeIssues=$iss
  }
}

# write CSV + markdown
$csv = Join-Path $OutDir "initiatives_scan.csv"
$md  = Join-Path $OutDir "initiatives_scan.md"
$rows | Sort-Object Repo | Export-Csv -NoTypeInformation -Path $csv -Encoding UTF8

$tbl = ($rows | Sort-Object Repo | Format-Table -AutoSize | Out-String)
@"
# Initiatives Scan (approximate)
Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

\`$ gh\` optional; counts are best-effort. Includes explicit files + inferred (open PRs / initiative-labeled issues).

$tbl

CSV: docs/dashboards/initiatives_scan.csv
"@ | Set-Content $md -Encoding UTF8

Write-Host "==> DONE: initiatives scan written to $OutDir" -ForegroundColor Green
