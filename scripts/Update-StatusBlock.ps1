param([string]$RepoRoot = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference="Stop"
$readme = Join-Path $RepoRoot "README.md"
$src = Join-Path $RepoRoot "status\codrift.json"
if(-not (Test-Path $src)){ "No codrift.json yet."; exit 0 }
$j = Get-Content $src -Raw | ConvertFrom-Json
$score  = [int]$j.score
$status = [string]$j.status
$comp   = $j.components
$block = @(
"<!-- BEGIN: STATUS -->",
"### Operational Status",
("CoDrift Index: {0} ({1})" -f $score,$status),
("- Dupes: {0}" -f $comp.dupes),
("- Missing manifests: {0}" -f $comp.missingManifests),
("- Missing tags: {0}" -f $comp.missingTags),
("- Here-strings hits: {0}" -f $comp.hereStrings),
"<!-- END: STATUS -->"
)
$text = ""; if(Test-Path $readme){ $text = Get-Content $readme -Raw }
if([string]::IsNullOrWhiteSpace($text)){ $text = "# CoCache`n" }
$begin = "<!-- BEGIN: STATUS -->"
$end   = "<!-- END: STATUS -->"
if($text -match [regex]::Escape($begin) -and $text -match [regex]::Escape($end)){
  $pre  = $text.Substring(0, $text.IndexOf($begin))
  $post = $text.Substring($text.IndexOf($end) + $end.Length)
  $text = ($pre.TrimEnd() + [Environment]::NewLine + ($block -join [Environment]::NewLine) + [Environment]::NewLine + $post.TrimStart())
} else {
  $text = ($text.TrimEnd() + [Environment]::NewLine + [Environment]::NewLine + ($block -join [Environment]::NewLine) + [Environment]::NewLine)
}
Set-Content -LiteralPath $readme -Value $text -Encoding UTF8
"Updated README status block."
