<#
Sets the email nudge recipient for careerOS GitHub Actions.
Requires: gh CLI authenticated and repo remote 'origin' pointing to your careerOS repo.
#>
param(
  [string]$Email = "eliassokolova@gmail.com"
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI (gh) is required. Install and login: https://cli.github.com/"
}

# Ensure we're inside the repo (optional: allow override by cd)
try {
  $remote = git remote get-url origin 2>$null
} catch { $remote = $null }

if (-not $remote) {
  Write-Warning "No git remote found. If you're not in the repo folder, cd into it first."
} else {
  Write-Host "Using remote: $remote"
}

Write-Host "Setting TO_EMAIL secret to $Email ..."
& gh secret set TO_EMAIL --body "$Email"

Write-Host "Done. If you want monthly emails to send, also set Mailgun or SES secrets as documented in docs/automation.md."
