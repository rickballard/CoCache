
param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank'),
  [string]$PythonExe = 'python'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Test-Path $RepoRoot)) { throw "Repo not found: $RepoRoot" }
$RepoRoot = (Resolve-Path $RepoRoot).Path
Push-Location $RepoRoot

# Ensure venv
$venvPy = Join-Path $RepoRoot '.venv\Scripts\python.exe'
if (-not (Test-Path $venvPy)) {
  & $PythonExe -m venv .venv
}

# Upgrade pip + install pytest
& $venvPy -m pip install --upgrade pip | Out-Null
& $venvPy -m pip install -U pytest | Out-Null

# Write dev requirements for future convenience
$devReq = Join-Path $RepoRoot 'tools\requirements-dev.txt'
New-Item -ItemType Directory -Force -Path (Split-Path $devReq) | Out-Null
@"
pytest
"@ | Set-Content -LiteralPath $devReq -Encoding UTF8

# Run tests (quiet); if none, just continue
try {
  & $venvPy -m pytest -q tools/score_demo/tests
} catch {
  Write-Host "[WARN] pytest run failed: $($_.Exception.Message)" -ForegroundColor Yellow
}

Pop-Location
Write-Host "[OK] Dev venv ready (.venv) with pytest installed." -ForegroundColor Green
