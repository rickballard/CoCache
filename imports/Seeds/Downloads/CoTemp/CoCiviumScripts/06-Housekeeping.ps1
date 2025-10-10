. "$PSScriptRoot/RepoConfig.ps1"
$ErrorActionPreference='Stop'
Push-Location $Repo
try{
  if(-not (Test-Path ".gitattributes")){
@"
* text=auto
*.ps1 text eol=crlf
*.bat text eol=crlf
*.sh  text eol=lf
"@ | Set-Content -Encoding UTF8 ".gitattributes" } else { Add-Content ".gitattributes" "`n* text=auto`n*.ps1 text eol=crlf`n*.bat text eol=crlf`n*.sh  text eol=lf" }

  if(-not (Test-Path ".gitignore")){
@"
# OS / tooling
Thumbs.db
.DS_Store
*.tmp
*.bak
"@ | Set-Content -Encoding UTF8 ".gitignore" } else { Add-Content ".gitignore" "`n# OS / tooling`nThumbs.db`n.DS_Store`n*.tmp`n*.bak" }

  git add .gitattributes .gitignore
  git commit -m "chore: EOL + ignore baselines" 2>$null | Out-Null
  Write-Host "Housekeeping done."
} finally { Pop-Location }
