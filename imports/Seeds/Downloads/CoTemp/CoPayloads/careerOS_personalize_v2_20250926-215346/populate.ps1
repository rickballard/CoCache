param([string]$RepoPath="",[switch]$Confirm)
if (-not $Confirm){ exit 1 }
$starter=Get-Content (Join-Path (Split-Path $MyInvocation.MyCommand.Path) 'career_starter.json') -Raw | ConvertFrom-Json
foreach($k in $starter.PSObject.Properties.Name){ $dest=Join-Path $RepoPath $k; New-Item -ItemType Directory -Force -Path (Split-Path $dest)|Out-Null; Set-Content $dest $starter.$k -Encoding UTF8 }
