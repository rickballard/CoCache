$ErrorActionPreference="Stop"; Set-StrictMode -Version Latest
try {
  Import-Module "$PSScriptRoot/../ops/bpoe/BPOE.Artifacts.psm1" -Force -ErrorAction Stop
} catch {
  Write-Host "BPOE (info): module missing; skipping artifact-name check this commit." -ForegroundColor Yellow
  exit 0
}
try {
  $root = (git rev-parse --show-toplevel)
  # limit check to packaged outputs; regular .ps1 etc. are not enforced
  Assert-ArtifactNamesAreVersioned -Root $root `
    -Globs @('*.zip','*.tar.gz','*.pdf') `
    -Paths @('docs','release','releases','dist','artifacts','downloads')
} catch {
  Write-Host "BPOE: Artifact names must include semver or timestamp (_YYYY-mm-dd_HHMMSS)" -ForegroundColor Red
  Write-Host $_
  exit 1
}
