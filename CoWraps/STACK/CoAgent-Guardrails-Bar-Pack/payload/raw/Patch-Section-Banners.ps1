[CmdletBinding()]
param([string]$RepoPath="$HOME\Documents\GitHub\CoAgent")
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { throw "Repo not found: $RepoPath" }
$sect = Join-Path $repo 'tools\Section-Banners.ps1'
if (-not (Test-Path $sect)) { return }
$raw = Get-Content -Raw $sect
# Replace huge demark lines with compact variant
$raw = $raw -replace 'Write-EndOfSet.*?{.*?}', r'''
function Write-EndOfSet {
  param([switch]$Colorblind)
  $w = [console]::WindowWidth
  if (-not $w -or $w -lt 20) { $w = 80 }
  $line = ('─' * ($w - 2))
  Write-Host ""
  Write-Host $line
  Write-Host ("  End of DO set".PadLeft([math]::Max(18, [int]($w/3)))) 
  Write-Host $line
}
'''
Set-Content -Encoding UTF8 $sect $raw
