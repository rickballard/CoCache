param([int]$From=1,[int]$To=7)
. "$PSScriptRoot/RepoConfig.ps1"
for($i=$From;$i -le $To;$i++){
  $p = (Join-Path $PSScriptRoot ("{0:D2}-*.ps1" -f $i))
  $f = Get-ChildItem $p | Select-Object -First 1
  if(!$f){ Write-Warning ("Step {0} missing" -f $i); continue }
  Write-Host ("`n==> STEP {0}: {1}" -f $i, $f.Name) -ForegroundColor Cyan
  & $f.FullName
  if($LASTEXITCODE -ne 0){ throw ("Step {0} failed." -f $i) }
}
