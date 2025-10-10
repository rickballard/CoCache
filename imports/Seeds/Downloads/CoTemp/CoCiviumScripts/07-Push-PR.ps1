param([switch]$Draft=$true)
$cfg = Join-Path $PSScriptRoot 'RepoConfig.ps1'
if(-not (Test-Path $cfg)){ $cfg = "$env:USERPROFILE\Downloads\CoTemp\CoCiviumScripts\RepoConfig.ps1" }
. $cfg
$ErrorActionPreference='Stop'

Push-Location $Repo
try{
  $branch = (git rev-parse --abbrev-ref HEAD).Trim()
  git push -u origin $branch

  $haveGh = $false; try{ gh --version *> $null; $haveGh = $true }catch{}
  if($haveGh){
    # If a PR for this branch exists, show it; else create one (draft by default)
    $url = (& gh pr view --head $branch --json url -q .url 2>$null)
    if([string]::IsNullOrWhiteSpace($url)){
      $args = @('pr','create',
        '--title','Seed: nav, CC scroll, KPIs, stub audit, Civium→CoCivium',
        '--body','- Structure + status pass; content-only transforms; reversible.',
        '--base','main','--head',$branch)
      if($Draft){ $args += '--draft' }
      & gh @args
      $url = (& gh pr view --head $branch --json url -q .url)
    }
    Write-Host "PR: $url" -ForegroundColor Green
  } else {
    Write-Host "Pushed $branch. Open PR on GitHub." -ForegroundColor Yellow
  }
}
finally{ Pop-Location }
