# Apply staged candidates into a live repo; run from repo root
param([switch]$Push=$true)
try { $top = (git rev-parse --show-toplevel) } catch { throw "Run this from your live repo root to apply logos." }
$dest = Join-Path $top "assets\img\exemplars"; New-Item -ItemType Directory -Force $dest | Out-Null
$wrap = Split-Path -Parent $PSScriptRoot | Split-Path -Parent
$staged = Join-Path $wrap "logos\staged"
Get-ChildItem $staged -File | ForEach-Object {
  $name = $_.BaseName -replace '-candidate$',''
  $out  = Join-Path $dest ($name + ".png")
  & (Join-Path $PSScriptRoot 'prep-logo.ps1') -Src $_.FullName -Out $out
}
git add $dest
git commit -m "assets: normalize exemplar logos (Spanky bundle)"
if($Push){ git push }
Write-Host "Applied and (optionally) pushed normalized logos."

