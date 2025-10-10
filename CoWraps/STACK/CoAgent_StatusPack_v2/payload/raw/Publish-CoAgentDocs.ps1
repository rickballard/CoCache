param(
  [string]$RepoPath = (Join-Path $HOME 'Desktop\CoAgent'),
  [string]$Message = "Add Sprint-1 planning docs"
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
Push-Location $RepoPath
try {
  git add docs scripts/planning .gitignore
  git status --short
  git commit -m $Message
} finally { Pop-Location }
