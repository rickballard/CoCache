Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
function Info($m){ Write-Host "[INFO] $m" -ForegroundColor Cyan }
function MaybeRemove($path){
  if(Test-Path $path){
    Remove-Item $path -Force
    return $true
  }
  return $false
}

$repos = @{
  "Godspawn" = Join-Path $env:USERPROFILE 'Documents\GitHub\Godspawn';
  "CoCivium" = Join-Path $env:USERPROFILE 'Documents\GitHub\CoCivium'
}

$targets = @{
  "Godspawn" = @('HH\docs\something.md');
  "CoCivium" = @()
}

foreach($name in $repos.Keys){
  $repo = $repos[$name]
  if(-not (Test-Path $repo)){ continue }
  $removed = @()
  foreach($rel in $targets[$name]){
    $p = Join-Path $repo $rel
    if(MaybeRemove $p){ $removed += $rel }
  }
  if($removed.Count -gt 0){
    Push-Location $repo
    try {
      git fetch --all | Out-Null
      $branch = "chore/remove-stubs-" + (Get-Date -Format 'yyyyMMdd_HHmmss')
      git checkout -b $branch | Out-Null
      git add -A
      git commit -m ("Remove placeholder files: " + ($removed -join ', '))
      git push -u origin $branch | Out-Null
      Info "[$name] removed: $($removed -join ', ')"
    } finally { Pop-Location }
  } else {
    Info "[$name] no placeholders to remove"
  }
}
