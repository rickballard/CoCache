# CoAgentTokenLoader.ps1
$TokenPath = "$env:USERPROFILE\Downloads\CoTemp\tokens\github.token"
if (!(Test-Path $TokenPath)) {
  throw "GitHub token not found at $TokenPath"
}
$Env:GITHUB_TOKEN = Get-Content $TokenPath -Raw
Write-Output "GITHUB_TOKEN environment variable set."
