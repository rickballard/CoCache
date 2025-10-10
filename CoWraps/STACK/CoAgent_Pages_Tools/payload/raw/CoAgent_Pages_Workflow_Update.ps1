# Optional: land the gh-pages workflow on main and broaden triggers
# Run INSIDE: C:\Users\Chris\Documents\GitHub\CoAgent
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$def = (gh repo view --json defaultBranchRef --jq .defaultBranchRef.name); if(-not $def){$def='main'}
New-Item -ItemType Directory -Force .\.github\workflows | Out-Null

$yml = @'
name: gh-pages
on:
  push:
    branches: ["**"]   # any branch
  workflow_dispatch:
permissions:
  contents: write
jobs:
  deploy:
    if: contains(github.ref, 'refs/heads/') # simple guard
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Publish docs/ to gh-pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
'@
$path = ".github\workflows\gh-pages.yml"
$yml | Set-Content -Encoding UTF8 $path

$br = "ci/gh-pages-workflow-fix-$((Get-Date).ToString('yyyyMMdd-HHmmss'))"
git fetch origin --prune | Out-Null
git checkout -B $br "origin/$def" | Out-Null
git add $path
git commit -m "ci: broaden gh-pages triggers and land workflow on $def" | Out-Null
git push -u origin $br | Out-Null
gh pr create --head $br --base $def -t "ci: gh-pages workflow (any-branch trigger)" -b "Publishes /docs to gh-pages; triggers on any branch." --draft | Out-Null

Write-Host "✅ Opened PR to land gh-pages workflow on $def." -ForegroundColor Green