
param([string]$Path = "RickPublic/issues")
$errs = @()
Get-ChildItem -Path $Path -Recurse -Include *.md | ForEach-Object {
  $c = Get-Content $_.FullName -Raw
  if ($c -notmatch "\[link\]\(") { $errs += "No links/citations in: $($_.FullName)" }
}
if ($errs.Count) { $errs | % { Write-Host $_ -ForegroundColor Red }; exit 1 } else { Write-Host "Citation lint OK" -ForegroundColor Green }
