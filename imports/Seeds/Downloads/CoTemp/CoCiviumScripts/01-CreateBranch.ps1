param()
. "$PSScriptRoot/RepoConfig.ps1"
$ErrorActionPreference='Stop'
$repoItem = Get-Item -LiteralPath $Repo; $Repo=$repoItem.FullName
Push-Location $Repo
try{
  foreach($p in @($Repo, ($Repo -replace '\\','/'), (Join-Path $Repo '.git'), ((Join-Path $Repo '.git') -replace '\\','/'))){
    git config --global --add safe.directory $p 2>$null
  }
  $ts = (Get-Date).ToString('yyyyMMdd-HHmmss')
  $branch = "refactor/seed-structure-$ts"
  git switch -c $branch
  Write-Host "On branch $branch"
} finally { Pop-Location }
