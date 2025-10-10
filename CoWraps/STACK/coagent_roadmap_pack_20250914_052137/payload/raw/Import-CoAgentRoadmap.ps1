param(
  [string]$RepoRoot = (Join-Path $env:HOME 'Documents\GitHub\CoAgent')
)
$src = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "Importing roadmap pack into: $RepoRoot"
Copy-Item -Recurse -Force (Join-Path $src 'docs') $RepoRoot
Set-Location $RepoRoot
try{
  git add docs/*
  git commit -m "docs(roadmap): seed CoAgent roadmap, index, notes [+sidecars]" *> $null
  git push *> $null
  Write-Host "✓ Committed and pushed."
}catch{
  Write-Warning "Skipped git steps (ensure repo exists and you have rights)."
}
