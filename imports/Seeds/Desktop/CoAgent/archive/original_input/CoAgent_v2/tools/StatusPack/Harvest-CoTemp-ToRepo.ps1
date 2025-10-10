param([Parameter(Mandatory)][string]$RepoPath)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $RepoPath)) { throw "RepoPath not found: $RepoPath" }
$docsDst  = Join-Path $RepoPath 'docs'; New-Item -ItemType Directory -Force -Path $docsDst | Out-Null

$pack = Split-Path -Parent $MyInvocation.MyCommand.Path
$pack = Split-Path -Parent $pack   # StatusPack
$docsSrc = Join-Path $pack '..\..\docs'  # repo root → docs
$docsSrc = Resolve-Path $docsSrc

Copy-Item -Recurse -Force "$docsSrc\*" $docsDst

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
if (-not (Test-Path (Join-Path $priv 'BP_Private.readme.md'))) {
  Set-Content -LiteralPath (Join-Path $priv 'BP_Private.readme.md') -Encoding UTF8 -Value @"
# Private Business Plan (keep off public origin)
- Store pricing, partner lists, unit economics here.
- This folder is ignored by .gitignore.
"@
}

"Harvested docs to: $RepoPath"
