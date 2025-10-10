param([string]$ListPath = "$(Resolve-Path ./ops/CoSuite/repos.txt)")
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
$items = Get-Content $ListPath | ? { $_ -and $_ -notmatch '^\s*#' } | % { $_.Trim() }
foreach($id in $items){
  $owner,$name = $id.Split('/',2); if(-not $name){ continue }
  $repo = Join-Path $HOME "Documents\GitHub\$name"
  if(!(Test-Path $repo)){ git clone "https://github.com/$owner/$name" $repo | Out-Null }
  Set-Location $repo; git switch main 2>$null; git pull --ff-only 2>$null
  pwsh -NoProfile -File "$HOME\Documents\GitHub\CoCache\ops\humanize\Build-FrontDoor.ps1" -RepoPath "$PWD" -Title $name
  pwsh -NoProfile -File "$HOME\Documents\GitHub\CoCache\ops\humanize\Write-HumansIndex.ps1" -RepoPath "$PWD"
  if(!(Test-Path .gitattributes)){
    @"
ops/**/* linguist-generated=true
.github/**/* linguist-generated=true
docs/**/* linguist-documentation=true
"@ | Set-Content .gitattributes -Encoding UTF8
  }
  git add README.md docs/HUMANS.md .gitattributes
  git commit -m "humanize: FrontDoor + HUMANS + .gitattributes" 2>$null
  git push origin HEAD 2>$null
}
Write-Host "==> DONE: Humanize-All sweep" -ForegroundColor Green
