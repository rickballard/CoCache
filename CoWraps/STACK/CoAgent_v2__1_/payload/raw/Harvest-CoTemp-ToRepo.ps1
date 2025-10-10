param([Parameter(Mandatory)][string]$RepoPath)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $RepoPath)) { throw "RepoPath not found: $RepoPath" }
$docsDst  = Join-Path $RepoPath 'docs'; New-Item -ItemType Directory -Force -Path $docsDst | Out-Null

$pack = Join-Path $HOME 'Downloads\CoAgent_StatusPack_v2'
$docsSrc1 = Join-Path $HOME 'Downloads\CoAgent_Planning_Sprint1\docs'
$docsSrc2 = Join-Path $pack 'docs'
if (Test-Path $docsSrc1) { Copy-Item -Recurse -Force "$docsSrc1\*" $docsDst }
elseif (Test-Path $docsSrc2) { Copy-Item -Recurse -Force "$docsSrc2\*" $docsDst }
else { Write-Warning "No docs source found; created empty docs/." }

# install status tools into the repo
$tools = Join-Path $RepoPath 'tools\StatusPack'; New-Item -ItemType Directory -Force -Path $tools | Out-Null
Copy-Item -Recurse -Force (Join-Path $pack 'scripts\*.ps1') $tools -ErrorAction SilentlyContinue

# gitignore hardening
$gi = Join-Path $RepoPath '.gitignore'
$want = @('docs/private/','docs/*.private.md','docs/*_PRIVATE.md')
$existing = if (Test-Path $gi) { Get-Content -LiteralPath $gi -ErrorAction SilentlyContinue } else { @() }
$merged = New-Object System.Collections.Generic.HashSet[string]
$existing | ForEach-Object { [void]$merged.Add($_) }
$want     | ForEach-Object { [void]$merged.Add($_) }
$merged   | Set-Content -LiteralPath $gi -Encoding UTF8

# private placeholder (local only)
$priv = Join-Path $docsDst 'private'; New-Item -ItemType Directory -Force -Path $priv | Out-Null
Set-Content -LiteralPath (Join-Path $priv 'BP_Private.readme.md') -Encoding UTF8 -Value @"
# Private Business Plan (keep off public origin)
- Store pricing, partner lists, unit economics here.
- This folder is ignored by .gitignore.
"@
"Harvested docs/scripts to: $RepoPath"
