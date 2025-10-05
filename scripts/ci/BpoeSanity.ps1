Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$errors = @()

# Cross-platform paths
$Hook   = Join-Path '.githooks' 'pre-push.ps1'
$Bpoe   = Join-Path 'bpoe' 'BPOE_Git-PR-Rescue-Playbook.md'
$Marker = '# --- AB bypass (must be first) ---'
$CiLeaf = 'BpoeSanity.ps1'

# 1) Hook has AB-bypass marker
if (Test-Path $Hook) {
  if (-not (Select-String -Path $Hook -SimpleMatch -Pattern $Marker -Quiet)) {
    $errors += 'pre-push hook missing AB-bypass prelude marker'
  }
} else {
  $errors += "pre-push hook not found at $Hook"
}

# 2) BPOE doc carries paste-safe marker
if (Test-Path $Bpoe) {
  if (-not (Select-String -Path $Bpoe -SimpleMatch -Pattern '<!-- BPOE_PASTE_SAFE_V1 -->' -Quiet)) {
    $errors += 'BPOE playbook missing paste-safe marker'
  }
} else {
  $errors += "BPOE playbook not found at $Bpoe"
}

# Helper: ignore vendor/infra folders cross-platform
function Is-IgnoredPath([string]$p){
  return ($p -like "*\.git\*"           -or $p -like "*/.git/*"           -or
          $p -like "*\.github\actions\runner*" -or $p -like "*/.github/actions/runner/*" -or
          $p -like "*\node_modules\*"   -or $p -like "*/node_modules/*"   -or
          $p -like "*\.venv\*"          -or $p -like "*/.venv/*")
}

# 3) No literal "<branch>" placeholders (exclude this CI script by LEAF name)
$hits = Get-ChildItem -Recurse -File |
  Where-Object { -not (Is-IgnoredPath $_.FullName) -and $_.Name -ne $CiLeaf } |
  Select-String -SimpleMatch -Pattern '<branch>' -List
if ($hits) { $errors += 'Found literal `<branch>` placeholder in repo: ' + ($hits.Path -join ', ') }

# 4) AB-bypass marker does not appear outside the hook
$hookPath = (Resolve-Path $Hook -ErrorAction SilentlyContinue)?.Path
$leaks = Get-ChildItem -Recurse -File |
  Where-Object {
    -not (Is-IgnoredPath $_.FullName) -and
    ($hookPath -and $_.FullName -ne $hookPath)
  } |
  Select-String -SimpleMatch -Pattern $Marker -List
if ($leaks) { $errors += "AB-bypass marker found outside $Hook: " + ($leaks.Path -join ', ') }

# 5) No "exit 0" in docs
$exitHits = Get-ChildItem -Recurse -File |
  Where-Object { $_.Extension -in '.md','.txt','.yml','.yaml' } |
  Select-String -Pattern '^\s*exit\s+0\b' -List
if ($exitHits) { $errors += "Found 'exit 0' in docs: " + ($exitHits.Path -join ', ') }

if ($errors.Count) {
  Write-Error ("BPOE sanity failed:`n - " + ($errors -join "`n - "))
  exit 1
} else {
  Write-Host "BPOE sanity passed."
}
