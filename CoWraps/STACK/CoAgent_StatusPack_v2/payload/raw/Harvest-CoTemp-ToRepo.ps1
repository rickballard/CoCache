param([Parameter(Mandatory)][string]$RepoPath)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
$docsSrc = Join-Path $HOME 'Downloads\CoAgent_Planning_Sprint1\docs'
$destDocs = Join-Path $RepoPath 'docs'
$destScripts = Join-Path $RepoPath 'scripts\planning'

$null = New-Item -ItemType Directory -Force -Path $destDocs,$destScripts | Out-Null

# Copy docs if exist
if (Test-Path $docsSrc) { Copy-Item -Recurse -Force (Join-Path $docsSrc '*') $destDocs }

# .gitignore to keep private drafts out
$gi = Join-Path $RepoPath '.gitignore'
$add = @"
# CoAgent planning (private drafts)
docs/private/
docs/*.private.md
"@
if (Test-Path $gi) {
  if (-not (Select-String -Path $gi -Pattern 'docs/private/' -SimpleMatch -Quiet)) { Add-Content -LiteralPath $gi -Value $add }
} else { Set-Content -LiteralPath $gi -Value $add -Encoding UTF8 }

# Copy helper scripts if present
$ps1 = @(
  Join-Path $HOME 'Downloads\CoAgent_Planning_Sprint1\scripts\Run-SmoketestSuite.ps1',
  Join-Path $HOME 'Downloads\CoAgent_Planning_Sprint1\scripts\Build-StarterKit.ps1'
) | Where-Object { Test-Path $_ }
foreach ($p in $ps1) { Copy-Item -Force $p $destScripts }

"Harvested docs/scripts to $RepoPath"
