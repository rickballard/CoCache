Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"
cd "$HOME\Documents\GitHub\CoAgent"
git fetch origin --prune | Out-Null
if (git show-ref --verify --quiet refs/heads/gh-pages) { git branch -D gh-pages | Out-Null }
git subtree split --prefix docs -b gh-pages
git push origin gh-pages -f
$owner="rickballard"; $name="CoAgent"
$null = gh api -X POST "repos/$owner/$name/pages" -H "Accept: application/vnd.github+json" -f "source[branch]=gh-pages" -f "source[path]=/" 2>$null
if ($LASTEXITCODE -ne 0) { $null = gh api -X PUT "repos/$owner/$name/pages" -H "Accept: application/vnd.github+json" -f "source[branch]=gh-pages" -f "source[path]=/" }
Write-Host "✅ Pages updated: https://$owner.github.io/$name/" -ForegroundColor Green
