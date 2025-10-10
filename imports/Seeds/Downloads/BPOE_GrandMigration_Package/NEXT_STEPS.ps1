# Grand Migration — Next Steps (run in a PS7 shell)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$CoCache = 'C:\Users\Chris\Documents\GitHub\CoCache'

if (-not (Test-Path $CoCache)) { throw "CoCache clone not found: $CoCache" }

# A) Remove the accidental huge file from the index (leave working tree unchanged) and recommit
$bad = Join-Path $CoCache 'docs\index\ADVICE-INDEX.md'
if (Test-Path $bad) {
  git -C $CoCache rm --cached --force $bad
  # Optional: keep it ignored going forward
  Add-Content -Path (Join-Path $CoCache '.gitignore') -Value "`ndocs/index/ADVICE-INDEX.md"
  git -C $CoCache add .gitignore
  git -C $CoCache commit -m "chore(bpoe): drop oversized ADVICE-INDEX.md from repo"
} else {
  Write-Host "No giant ADVICE-INDEX.md found. Continuing."
}

# B) Ensure the smoke workflow uses the correct setup action
$Smoke = Join-Path $CoCache '.github\workflows\bpoe-smoke.yml'
if (-not (Test-Path $Smoke)) { throw "Missing smoke workflow: $Smoke" }
$txt = Get-Content -Raw -Path $Smoke -Encoding UTF8
$txt = $txt -replace 'PowerShell/PowerShell@v1','actions/setup-powershell@v2'
$txt = $txt -replace 'powershell/powershell@v1','actions/setup-powershell@v2'
Set-Content -Path $Smoke -Value $txt -Encoding UTF8

# C) Push to CoCache/main
git -C $CoCache add -A
if (-not (git -C $CoCache diff --cached --quiet)) {
  git -C $CoCache commit -m "fix(bpoe): correct setup action + housekeeping"
}
$remote = (git -C $CoCache remote) | Select-Object -First 1
if ($remote) { git -C $CoCache push -u $remote main }

# D) Re-dispatch InSeed smoke on your feature branch (consumes the fixed central workflow)
$Branch = 'polish/bpoe-centralize-20250915'
gh workflow run smoke.yml --repo rickballard/InSeed --ref $Branch
gh run list --repo rickballard/InSeed --limit 5 --branch $Branch
