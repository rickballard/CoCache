Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"
Set-Location "$HOME\Documents\GitHub\CoCivium"
git fetch -p origin | Out-Null
$merged = git branch -r --merged origin/main | % { $_.Trim() } |
  ? { $_ -match 'origin/(readme/|gm/)' -and $_ -ne 'origin/main' }
if(-not $merged){ Write-Host "Nothing to prune."; exit 0 }
Write-Host "Will delete these remote branches:"
$merged | % { " - $_" }
$ans = # [MVP3] removed Read-Host prompt
if($ans -match '^(?i)n$'){ Write-Host "Canceled."; exit 0 }
foreach($b in $merged){
  $name = $b -replace '^origin/',''
  git push origin --delete $name
}
Write-Host "Done."

