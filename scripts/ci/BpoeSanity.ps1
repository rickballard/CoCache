Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$errors = @()

$hook = ".githooks\pre-push.ps1"
$bpoe = "bpoe\BPOE_Git-PR-Rescue-Playbook.md"

if (Test-Path $hook) {
  if (-not (Select-String -Path $hook -SimpleMatch -Pattern "# --- AB bypass (must be first) ---" -Quiet)) {
    $errors += "pre-push hook missing AB-bypass prelude marker"
  }
} else {
  $errors += "pre-push hook not found at $hook"
}

if (Test-Path $bpoe) {
  if (-not (Select-String -Path $bpoe -SimpleMatch -Pattern "<!-- BPOE_PASTE_SAFE_V1 -->" -Quiet)) {
    $errors += "BPOE playbook missing paste-safe marker"
  }
} else {
  $errors += "BPOE playbook not found at $bpoe"
}

$hits = Get-ChildItem -Recurse -File |
  Where-Object { $_.FullName -notmatch "\\.git\\" -and $_.FullName -notmatch "\\.github\\actions\\runner" } |
  Select-String -SimpleMatch -Pattern "<branch>" -List
if ($hits) { $errors += "Found literal `<branch>` placeholder in repo: " + ($hits.Path -join ", ") }

if ($errors.Count) {
  Write-Error ("BPOE sanity failed:`n - " + ($errors -join "`n - "))
  exit 1
} else {
  Write-Host "BPOE sanity passed."
}
