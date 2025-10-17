param(
  [Parameter(Mandatory=$false)] [string] $CoPolitic = "$env:USERPROFILE\Documents\GitHub\CoPolitic",
  [Parameter(Mandatory=$false)] [string] $CdnUrl = "https://cdn.jsdelivr.net/gh/rickballard/CoCore@main/best-practices/thinkers/thinkers.json"
)
$ErrorActionPreference = "Stop"
$Page = Join-Path $CoPolitic "docs\thinkers\index.html"
if (!(Test-Path $Page)) { throw "Not found: $Page" }
$html = Get-Content $Page -Raw

# Swap the fetch to point at the CDN URL (literal replace keeps it simple)
$html = $html -replace "fetch\([^)]*thinkers\.json[^)]*\)", "fetch('$CdnUrl', {cache:'no-store'})"

# Make title clickable if sheet_url present (regex-safe replace)
$html = $html -replace r"\$\{r\.name\}", "${r.sheet_url ? `<a href=""${r.sheet_url}"" target=""_blank"" rel=""noopener"">${r.name}</a>` : r.name}"

Set-Content $Page $html -NoNewline

Write-Host "Patched $Page"
Write-Host "Next: commit & push CoPolitic, e.g.:"
Write-Host "  cd `"$CoPolitic`"; git add docs/thinkers/index.html; git commit -m `"feat(thinkers): fetch from CoCore CDN + link card titles`"; git push"
