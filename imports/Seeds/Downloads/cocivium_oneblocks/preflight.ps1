
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-Timestamp { Get-Date -Format yyyyMMdd_HHmm }

function Ensure-Repo {
  param([string]$RepoRoot = "$HOME\Documents\GitHub\CoCivium")
  if (-not (Test-Path $RepoRoot)) { throw "RepoRoot not found: $RepoRoot" }
  Set-Location $RepoRoot
  $null = git rev-parse --is-inside-work-tree 2>$null
  if ($LASTEXITCODE -ne 0) { throw "Not a git repo: $RepoRoot" }
  return $RepoRoot
}

function Write-IfChanged {
  param([string]$Path,[string]$Content)
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
  if (Test-Path $Path) {
    $existing = Get-Content $Path -Raw
    if ($existing -eq $Content) { return $false }
  }
  Set-Content $Path $Content -Encoding UTF8
  return $true
}

function Assert-GH {
  $null = gh auth status 2>$null
  if ($LASTEXITCODE -ne 0) { throw "GitHub CLI not authenticated. Run: gh auth login" }
}

function Safe-CommitPush {
  param([string]$Message, [switch]$NoPush)
  $null = git add -A
  $status = git status --porcelain
  if ($status) {
    git commit -m $Message | Out-Null
    if (-not $NoPush) { git push -u origin HEAD | Out-Null }
    return $true
  } else {
    Write-Host "Nothing to commit."
    return $false
  }
}

param([string]$RepoRoot = "$HOME\Documents\GitHub\CoCivium")

Ensure-Repo -RepoRoot $RepoRoot | Out-Null

"Repo:    $(git remote get-url origin)"
"Branch:  $(git branch --show-current)"
$null = gh auth status 2>$null
"gh auth: " + ($(if($LASTEXITCODE -eq 0){"OK"}else{"NOT LOGGED IN"}))
"Vision:  " + (Test-Path 'docs/vision/CoCivium_Vision.md')
"Consenti:" + (Test-Path 'scroll/Cognocarta_Consenti.md')
"Image:   " + (Test-Path 'assets/img/consenti-scroll.png')
