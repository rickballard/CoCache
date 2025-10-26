param(
  [string]$User = "rickballard",
  [string]$Out  = "$HOME\Documents\GitHub\CoCache\status\public_repos.json"
)
$ErrorActionPreference='Stop'
New-Item -ItemType Directory -Force -Path (Split-Path $Out) | Out-Null
function Save($o){ $o | ConvertTo-Json -Depth 6 | Set-Content -Encoding utf8 $Out }

$hasGh = (Get-Command gh -ErrorAction SilentlyContinue) -ne $null
if($hasGh){
  $json = gh repo list $User --visibility public --json name,sshUrl,defaultBranchRef,isArchived,isDisabled,updatedAt -L 2000
  $data = $json | ConvertFrom-Json
  Save $data
  Write-Host "Saved repo list via gh -> $Out" -ForegroundColor Cyan
  return
}

$repos = @()
$pg=1
while($true){
  $u = "https://api.github.com/users/$User/repos?per_page=100&page=$pg&type=public"
  try{
    $resp = Invoke-RestMethod -Uri $u -Headers @{ "User-Agent"="co-advice-scanner" }
  }catch{
    Write-Host "GitHub REST error: $($_.Exception.Message)" -ForegroundColor Yellow; break
  }
  if(-not $resp -or -not $resp.Count){ break }
  $repos += $resp | Select-Object name, ssh_url, default_branch, archived, disabled, updated_at, html_url
  $pg++
}
Save $repos
Write-Host "Saved repo list via REST -> $Out" -ForegroundColor Cyan
