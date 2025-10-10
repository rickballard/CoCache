param(
  [Parameter(Mandatory=$false)][string]$RepoRoot = (Get-Location).Path
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Get-FileUtf8($path) {
  if (Test-Path $path) { return Get-Content -Path $path -Raw -Encoding UTF8 }
  return $null
}
function Set-FileUtf8($path, [string]$content) {
  $dir = Split-Path -Parent $path
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  [IO.File]::WriteAllText($path, $content, [Text.UTF8Encoding]($true))
}

Write-Host ">> MeritRank Sprint-1 Patch: Badges + Quick Smoke + CI" -ForegroundColor Cyan
Write-Host "RepoRoot: $RepoRoot"

$readmePath = Join-Path $RepoRoot 'README.md'
$badgesSrc  = Join-Path $PSScriptRoot 'snippets\README_BADGES.md'
$smokeSrc   = Join-Path $PSScriptRoot 'snippets\README_QUICK_SMOKE_BLOCK.md'
$wfSrc      = Join-Path $PSScriptRoot '.github\workflows\merit-smoke.yml'
$wfDst      = Join-Path $RepoRoot '.github\workflows\merit-smoke.yml'

# 1) Ensure CI workflow in repo
Copy-Item -Path $wfSrc -Destination $wfDst -Force
Write-Host "✔ Installed CI workflow at .github/workflows/merit-smoke.yml"

# 2) Patch README.md with Badges (top) + Quick Smoke block (near top)
$readme = (Get-FileUtf8 $readmePath)
if (-not $readme) {
  $readme = "# MeritRank`n`n"
}
$badges = (Get-FileUtf8 $badgesSrc)
$smoke  = (Get-FileUtf8 $smokeSrc)

# Normalize EOLs
$readme = $readme -replace "`r`n", "`n"

# Inject badges at top if not present
if ($badges -and ($readme -notmatch '\[!\[CI\]')) {
  $readme = ($badges.Trim() + "`n`n" + $readme.TrimStart())
  Write-Host "✔ Inserted badges at top of README.md"
} else {
  Write-Host "• Badges already present or source missing; skipping."
}

# Insert Quick Smoke section after first heading if not present
if ($smoke -and ($readme -notmatch '##\s*Quick smoke')) {
  $lines = $readme -split "`n"
  $insertIdx = 0
  if ($lines[0] -match '^\s*#\s+') {
    for ($i=1; $i -lt $lines.Count; $i++) {
      if ($lines[$i].Trim() -eq '') { $insertIdx = $i+1; break }
    }
  }
  $before = ($lines[0..($insertIdx-1)] -join "`n")
  $after  = ($lines[$insertIdx..($lines.Count-1)] -join "`n")
  $readme = ($before + "`n`n" + $smoke.Trim() + "`n`n" + $after)
  Write-Host "✔ Inserted Quick smoke section in README.md"
} else {
  Write-Host "• Quick smoke already present or source missing; skipping."
}

Set-FileUtf8 $readmePath $readme
Write-Host "✔ README.md patched"

Write-Host ">> DONE: Sprint-1 patch applied" -ForegroundColor Green