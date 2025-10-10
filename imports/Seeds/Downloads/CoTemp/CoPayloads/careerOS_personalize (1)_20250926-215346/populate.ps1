param([string]$RepoPath="",[switch]$Confirm)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
if ([string]::IsNullOrWhiteSpace($RepoPath)){ throw "Pass -RepoPath pointing to your local careerOS folder." }
if (-not (Test-Path $RepoPath)){ throw "RepoPath not found: $RepoPath" }
if (-not $Confirm){ Write-Host "Use -Confirm to proceed."; exit 1 }
$payloadRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$starter = Get-Content (Join-Path $payloadRoot 'career_starter.json') -Raw | ConvertFrom-Json
function Overwrite-File($dest, $content){
  $d = Join-Path $RepoPath $dest
  New-Item -ItemType Directory -Force -Path (Split-Path $d) | Out-Null
  Set-Content -Path $d -Value $content -Encoding UTF8
}
foreach($k in $starter.PSObject.Properties.Name){
  Overwrite-File $k $starter.$k
}
if (Get-Command git -ErrorAction SilentlyContinue){
  Push-Location $RepoPath
  try{ git add .; git commit -m 'careerOS: apply personalization starter'; if (git remote){ git push } } catch {}
  Pop-Location
}
Write-Host 'Personalization applied.'
