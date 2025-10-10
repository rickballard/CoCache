# Setup-CoAgentToken.ps1
$TokenPath = "$env:USERPROFILE\Downloads\CoTemp\tokens\github.token"
if (!(Test-Path $TokenPath)) {
  Read-Host "Paste your GitHub PAT" | Out-File -FilePath $TokenPath -Encoding utf8 -Force
  Write-Output "Token saved to $TokenPath"
} else {
  Write-Output "Token already exists at $TokenPath"
}
