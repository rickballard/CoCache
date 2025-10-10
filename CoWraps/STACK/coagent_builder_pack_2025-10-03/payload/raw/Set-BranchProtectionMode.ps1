param([ValidateSet("fast","fast+checks","balanced")][string]$Mode="fast")
$Owner="rickballard"; $Repo="CoAgent"
$checks = @(@{ context = "gh-pages/deploy (push)" }, @{ context = "ci/lint (pull_request)" })
switch($Mode){
  "fast"         { $payload=@{ required_status_checks=@{ strict=$true; checks=@() }; enforce_admins=$true; required_pull_request_reviews=@{ required_approving_review_count=0 }; restrictions=$null; required_linear_history=$true } }
  "fast+checks"  { $payload=@{ required_status_checks=@{ strict=$true; checks=$checks }; enforce_admins=$true; required_pull_request_reviews=@{ required_approving_review_count=0 }; restrictions=$null; required_linear_history=$true } }
  "balanced"     { $payload=@{ required_status_checks=@{ strict=$true; checks=$checks }; enforce_admins=$true; required_pull_request_reviews=@{ required_approving_review_count=1; require_code_owner_reviews=$true }; restrictions=$null; required_linear_history=$true } }
}
($payload | ConvertTo-Json -Depth 6) | gh api -X PUT "repos/$Owner/$Repo/branches/main/protection" -H "Accept: application/vnd.github+json" --input -
Write-Host "✓ Applied branch protection mode: $Mode"
