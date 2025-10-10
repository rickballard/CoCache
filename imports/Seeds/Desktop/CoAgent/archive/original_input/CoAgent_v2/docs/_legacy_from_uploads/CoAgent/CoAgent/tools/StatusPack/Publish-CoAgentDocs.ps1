param([Parameter(Mandatory)][string]$RepoPath)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
if (-not (Test-Path (Join-Path $RepoPath '.git'))) { throw "Not a git repo: $RepoPath" }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "git not found in PATH" }

Push-Location $RepoPath
try {
  git add docs .gitignore tools/StatusPack 2>$null
  $changes = git status --porcelain
  if (-not $changes) { "No changes to commit." }
  else {
    git commit -m "Planning: PRD/checklist/roadmap + status tools (StatusPack v2)"
    git log -1 --oneline
  }
} finally { Pop-Location }
