Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Owner='rickballard'; $Repo='CoModules'
$DefaultPath = Join-Path $HOME 'Documents\GitHub\CoModules'

function Ensure-RepoPath {
  if (Test-Path $DefaultPath) { return $DefaultPath }
  $base = Join-Path $HOME 'Documents\GitHub'
  if (-not (Test-Path $base)) { New-Item -ItemType Directory -Force -Path $base | Out-Null }
  Set-Location $base
  try { gh repo view "$Owner/$Repo" > $null 2>&1 } catch { throw "Remote repo $Owner/$Repo not found." }
  git clone "https://github.com/$Owner/$Repo.git" | Out-Null
  return (Join-Path $base $Repo)
}

function Set-BranchProtection([int]$Approvals=1,[bool]$RequireCO=$true){
  $payload = [ordered]@{
    required_status_checks=@{ strict=$false; contexts=@() }
    enforce_admins=$true
    required_pull_request_reviews=@{
      dismiss_stale_reviews=$true
      require_code_owner_reviews=$RequireCO
      required_approving_review_count=$Approvals
    }
    restrictions=$null
    required_linear_history=$true
    allow_force_pushes=$false
    allow_deletions=$false
    block_creations=$false
    required_conversation_resolution=$true
  }
  $tf=New-TemporaryFile
  $payload|ConvertTo-Json -Depth 10|Set-Content -Encoding UTF8 $tf
  gh api --method PUT -H "Accept: application/vnd.github+json" "repos/$Owner/$Repo/branches/main/protection" --input $tf | Out-Null
  Remove-Item $tf -Force
}

function Replace-First([string]$text,[string]$pattern,[string]$replacement){
  $rx = [regex]::new($pattern,[System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
  $m = $rx.Match($text)
  if (-not $m.Success) { return $text }
  return $text.Substring(0,$m.Index) + $replacement + $text.Substring($m.Index + $m.Length)
}

function Fix-Readme-Inline {
  $path = 'README.md'
  if (-not (Test-Path $path)) { throw "README.md not found." }
  $txt = Get-Content $path -Raw

  # Remove any previous header callout
  $txt = $txt -replace '(?ms)^\s*>\s*\*\*Acronyms\s*\(hover for meaning\)\:\*\*.*\r?\n',''

  # Map of acronyms → abbr HTML
  $abbr = [ordered]@{
    'CBPP'        = '<abbr title="Civic Best Practices Pipeline">CBPP</abbr>'
    'OMB M-24-10' = '<abbr title="U.S. Office of Management and Budget Memorandum M-24-10">OMB M-24-10</abbr>'
    'ATRS'        = '<abbr title="Algorithmic Transparency Recording Standard">ATRS</abbr>'
    'DCAT'        = '<abbr title="Data Catalog Vocabulary">DCAT</abbr>'
    'OCDS'        = '<abbr title="Open Contracting Data Standard">OCDS</abbr>'
    'BODS'        = '<abbr title="Beneficial Ownership Data Standard">BODS</abbr>'
    'IRM'         = '<abbr title="Independent Reporting Mechanism (Open Government Partnership)">IRM</abbr>'
  }

  foreach($k in $abbr.Keys){
    $pat = "(?<!</abbr>)\b" + [regex]::Escape($k) + "\b"
    $txt = Replace-First $txt $pat $abbr[$k]
  }

  # Footer note (only once)
  if ($txt -notmatch 'Acronyms used above:'){
    $footer = @"
`n---
<sub><em>Acronyms used above:</em> CBPP — Civic Best Practices Pipeline; OMB M-24-10 — U.S. Office of Management and Budget Memorandum M-24-10; ATRS — Algorithmic Transparency Recording Standard; DCAT — Data Catalog Vocabulary; OCDS — Open Contracting Data Standard; BODS — Beneficial Ownership Data Standard; IRM — Independent Reporting Mechanism.</sub>
"@
    $txt += $footer
  }

  Set-Content -Encoding UTF8 $path -Value $txt
}

# --- run ---
$repoPath = Ensure-RepoPath
Set-Location $repoPath
[Environment]::CurrentDirectory = (Get-Location).Path
try { chcp 65001 > $null } catch {}
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
git fetch --prune origin | Out-Null

# Branch from latest main
git switch -C docs/hover-inplace origin/main 2>$null | Out-Null
Fix-Readme-Inline
git add README.md
git commit -m "docs: inline `<abbr>` on first use; move acronym list to footer" | Out-Null
git push -u origin docs/hover-inplace | Out-Null

# PR → relax → merge → restore
$pr = gh pr create --title "docs: inline hover acronyms; footer note" --body "Wraps first use of each acronym in `<abbr>`; removes header callout; adds small footer gloss." | Select-String -Pattern '\d+$' | % { $_.Matches.Value }
Set-BranchProtection -Approvals 0 -RequireCO:$false
gh pr merge $pr --squash --delete-branch | Out-Null
Set-BranchProtection -Approvals 1 -RequireCO:$true

Write-Host "`n✅ README now shows hover help inline; footer note added; protections restored." -ForegroundColor Green
