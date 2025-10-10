param(
  [string]$ReposList,
  [string]$OutDir
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

# Resolve defaults AFTER we can create paths
$root    = (Resolve-Path .).Path
if (-not $ReposList) { $ReposList = Join-Path $root 'ops/CoSuite/repos.txt' }
if (-not $OutDir)    { $OutDir    = Join-Path $root 'docs/dashboards' }

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$rows = @()

function Count-Files([string]$root, [string[]]$globs){
  $total = 0
  foreach($g in $globs){
    $total += @(Get-ChildItem -LiteralPath $root -Recurse -File -Include $g -ErrorAction SilentlyContinue).Count
  }
  $total
}

$repos = Get-Content $ReposList | Where-Object { $_ -and $_ -notmatch '^\s*#' } | ForEach-Object { $_.Trim() }

foreach($id in $repos){
  $owner,$name = $id.Split('/',2); if(-not $name){ continue }
  $path = Join-Path $HOME "Documents\GitHub\$name"
  if(!(Test-Path $path)){ git clone "https://github.com/$owner/$name" $path | Out-Null }

  # file-scan buckets (adjust any time)
  $idea     = Count-Files $path @('docs\idea*\*.md','docs\ideacards\*.md')
  $insights = Count-Files $path @('docs\insights\*.md')
  $advice   = Count-Files $path @('docs\advice*\*.md','docs\advis*\*.md')  # fixed stray space
  $roadmap  = Count-Files $path @('docs\roadmap\*.md','ROADMAP.md')
  $scrolls  = Count-Files $path @('docs\cc\scroll\README.md')

  # PR / issue inference (best-effort if gh exists)
  $pr = 0; $iss = 0
  if (Get-Command gh -ErrorAction SilentlyContinue){
    Push-Location $path
    try {
      $pr  = @((gh pr list --state open --json number --limit 200 2>$null | ConvertFrom-Json)).Count
      # labels: support either label; fall back to 0 on error
      $iss = @((gh issue list --state open --json number --limit 200 --label idea 2>$null | ConvertFrom-Json)).Count +
             @((gh issue list --state open --json number --limit 200 --label initiative 2>$null | ConvertFrom-Json)).Count
    } catch { }
    Pop-Location
  }

  $rows += [pscustomobject]@{
    Repo=$name; IdeaCards=$idea; Insights=$insights; Advice=$advice; Roadmap=$roadmap; Megascrolls=$scrolls; OpenPRs=$pr; OpenInitiativeIssues=$iss
  }
}

# write CSV + markdown
$csv = Join-Path $OutDir 'initiatives_scan.csv'
$md  = Join-Path $OutDir 'initiatives_scan.md'
$rows | Sort-Object Repo | Export-Csv -NoTypeInformation -Path $csv -Encoding UTF8

$tbl = ($rows | Sort-Object Repo | Format-Table -AutoSize | Out-String)
@"
# Initiatives Scan (approximate)
Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

\`gh\` optional; counts are best-effort. Includes explicit files + inferred (open PRs / initiative-labeled issues).

$tbl

CSV: docs/dashboards/initiatives_scan.csv
"@ | Set-Content $md -Encoding UTF8

Write-Host "==> DONE: initiatives scan written to $OutDir" -ForegroundColor Green
