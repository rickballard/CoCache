param(
  [string]$RepoName = "careerOS",
  [string]$GitHubUser = "",
  [string]$RemoteVisibility = "public"
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
function Assert-Tool($name){ if(-not (Get-Command $name -ErrorAction SilentlyContinue)){ throw "$name is required but not found on PATH." } }
Assert-Tool git
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $here
if (-not (Test-Path ".git")){ git init; git checkout -b main; git add .; git commit -m "careerOS: rainbow-sample scaffold" }
$useGh = $false; if (Get-Command gh -ErrorAction SilentlyContinue){ $useGh = $true }
if ($useGh){
  if ([string]::IsNullOrWhiteSpace($GitHubUser)){ $GitHubUser = (gh api user --jq .login) 2>$null }
  if ([string]::IsNullOrWhiteSpace($GitHubUser)){ throw "Could not determine GitHub username. Pass -GitHubUser." }
  $exists = (gh repo view "$GitHubUser/$RepoName" 2>$null)
  if (-not $exists){ gh repo create "$GitHubUser/$RepoName" --$RemoteVisibility --source . --push }
  else { git remote add origin "https://github.com/$GitHubUser/$RepoName.git" 2>$null; git push -u origin main }
} else {
  if ([string]::IsNullOrWhiteSpace($GitHubUser)){ throw "Pass -GitHubUser and create an empty repo named $RepoName first." }
  $remote = "https://github.com/$GitHubUser/$RepoName.git"
  git remote add origin $remote 2>$null
  git push -u origin main
}
Write-Host "Done. Repository pushed."
