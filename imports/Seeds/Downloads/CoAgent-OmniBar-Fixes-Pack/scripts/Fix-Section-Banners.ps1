[CmdletBinding()]
param([string]$RepoPath="$HOME\Documents\GitHub\CoAgent")
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { throw "Repo not found: $RepoPath" }
$sect = Join-Path $repo 'tools\Section-Banners.ps1'
if (-not (Test-Path $sect)) { Write-Host "[INFO] Section-Banners.ps1 not found; skip"; return }

$raw = Get-Content -Raw $sect
$body = @'
function Write-EndOfSet {
  param([switch]$Colorblind)
  $w = $Host.UI.RawUI.WindowSize.Width
  if (-not $w -or $w -lt 40) { $w = 80 }
  $line = ('─' * ($w - 2))
  Write-Host ""
  Write-Host $line
  Write-Host "  End of DO set"
  Write-Host $line
}
'@

if ($raw -match 'function\s+Write-EndOfSet\s*{') {
  $raw = [regex]::Replace($raw, 'function\s+Write-EndOfSet\s*{.*?}\s*', $body, [System.Text.RegularExpressions.RegexOptions]::Singleline)
} else {
  $raw = $raw.TrimEnd() + "`r`n`r`n" + $body
}
Set-Content -Encoding UTF8 $sect $raw
Write-Host "[INFO] Patched compact Write-EndOfSet in Section-Banners.ps1"
