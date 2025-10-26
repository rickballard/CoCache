$ErrorActionPreference="Stop"; Set-StrictMode -Version Latest
$repo = (git rev-parse --show-toplevel) 2>$null
if(-not $repo){
  $fallback = Join-Path $HOME "Documents\GitHub\CoCache"
  if(Test-Path $fallback){ $repo = $fallback } else { throw "CoCache repo not found." }
}
Set-Location $repo
$lastWrap = (git tag --list "cowrap-*" --sort=-creatordate | Select-Object -First 1)
if($lastWrap){ $range = "$lastWrap..HEAD" } else { $first = (git rev-list --max-parents=0 HEAD | Select-Object -First 1); $range = "$first..HEAD" }
$shortstat = (git diff --shortstat $range)
$log      = (git log --oneline --decorate --no-merges $range)
$authors  = (git shortlog -sne $range)
$bnHook   = Test-Path ".git/hooks/pre-commit"
$ciFile   = Test-Path ".github/workflows/civium-safety.yml"
$wrapDir  = Join-Path $repo "WRAPS"; New-Item -ItemType Directory -Force -Path $wrapDir | Out-Null
$stamp    = Get-Date -Format "yyyyMMdd_HHmm"
$wrapPath = Join-Path $wrapDir ("CoWrap_{0}.md" -f $stamp)
$content = @"
# CoWrap — $([DateTime]::Now.ToString('s'))

## What shipped (since $lastWrap)
$shortstat

### Commits
$log

### Authors
$authors

## State checks
- BN pre-commit hook: $(if($bnHook){"enabled"}else{"missing"})
- Safety workflow: $(if($ciFile){"present"}else{"missing"})
"@
Set-Content -LiteralPath $wrapPath -Encoding UTF8 -Value $content
git add -- $wrapPath 2>$null
if(git diff --cached --name-only){ git commit -m ("docs(cowrap): session wrap {0}" -f $stamp) }
$tag = "cowrap-" + (Get-Date -Format "yyyyMMdd-HHmm")
git tag -a $tag -m ("CoWrap {0}" -f ([DateTime]::Now.ToString('s')))
git push origin HEAD --follow-tags
Write-Host ("CoWrap created: {0}  tag={1}" -f $wrapPath,$tag) -ForegroundColor Green

