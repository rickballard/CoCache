
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-Timestamp { Get-Date -Format yyyyMMdd_HHmm }

function Ensure-Repo {
  param([string]$RepoRoot = "$HOME\Documents\GitHub\CoCivium")
  if (-not (Test-Path $RepoRoot)) { throw "RepoRoot not found: $RepoRoot" }
  Set-Location $RepoRoot
  $null = git rev-parse --is-inside-work-tree 2>$null
  if ($LASTEXITCODE -ne 0) { throw "Not a git repo: $RepoRoot" }
  return $RepoRoot
}

function Write-IfChanged {
  param([string]$Path,[string]$Content)
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
  if (Test-Path $Path) {
    $existing = Get-Content $Path -Raw
    if ($existing -eq $Content) { return $false }
  }
  Set-Content $Path $Content -Encoding UTF8
  return $true
}

function Assert-GH {
  $null = gh auth status 2>$null
  if ($LASTEXITCODE -ne 0) { throw "GitHub CLI not authenticated. Run: gh auth login" }
}

function Safe-CommitPush {
  param([string]$Message, [switch]$NoPush)
  $null = git add -A
  $status = git status --porcelain
  if ($status) {
    git commit -m $Message | Out-Null
    if (-not $NoPush) { git push -u origin HEAD | Out-Null }
    return $true
  } else {
    Write-Host "Nothing to commit."
    return $false
  }
}

param([string]$RepoRoot = "$HOME\Documents\GitHub\CoCivium")

Ensure-Repo -RepoRoot $RepoRoot | Out-Null

$path = "docs/STYLE.md"
if (-not (Test-Path $path)) {
  New-Item -ItemType Directory -Force (Split-Path -Parent $path) | Out-Null
  Set-Content $path "# CoCivium Writing & File Style`r`n" -Encoding UTF8
}
$style = Get-Content $path -Raw

$block = @'
<!-- PASTE-SAFETY-START -->
## Copy/Paste Safety (PowerShell)

- Instruction sets are **ONEBLOCK** chunks.
- Use here-strings to write files:
  - `$md = @'`n…content…`n'@`
  - `Set-Content path $md -Encoding UTF8`
- Avoid `$home` variable name (collides with `$HOME`).
- Prefer file writes over REPL edits; include a **Preflight** block for big sets.
<!-- PASTE-SAFETY-END -->
'@

if ($style -match '(?s)<!-- PASTE-SAFETY-START -->.*?<!-- PASTE-SAFETY-END -->') {
  $style = [regex]::Replace($style,'(?s)<!-- PASTE-SAFETY-START -->.*?<!-- PASTE-SAFETY-END -->',$block)
} else {
  $style = $style.TrimEnd() + "`r`n`r`n" + $block
}
Set-Content $path $style -Encoding UTF8

git add $path
git commit -m "style: add Copy/Paste Safety (PowerShell) section" | Out-Null
git push | Out-Null
