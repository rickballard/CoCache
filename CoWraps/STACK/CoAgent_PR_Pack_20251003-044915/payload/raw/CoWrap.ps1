Param(
  [ValidateSet('All')] [string]$Pack='All',
  [string]$Branch = "pack/all-"+(Get-Date -Format yyyyMMdd-HHmmss)
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
git checkout -B $Branch origin/main | Out-Null
git add plans/ docs/ app/ launchers/ .github/workflows/status-bot.yml
if(-not (git diff --cached --quiet 2>$null)){
  git commit -m "pack: add product stub + plans + status-bot"
  git push -u origin $Branch
  $url = gh pr create --fill --draft
  Write-Host $url
  Write-Host "✓ Opened draft PR → $Branch"
}else{
  Write-Host "No changes to commit."
}
