# run.ps1 (template)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Example: gather markdown files (if any) and produce a merged report
$md = Get-ChildItem $PSScriptRoot -Recurse -File -Filter *.md -ErrorAction SilentlyContinue
$out = Join-Path $PSScriptRoot 'Report.md'

if ($md) {
  "# Report (Auto-built)`n`n> built: $(Get-Date -Format o)`n" | Set-Content -Encoding UTF8 $out
  foreach($m in $md){
    Add-Content -Encoding UTF8 -Path $out -Value "`n`n<!-- $($m.FullName) -->`n"
    Get-Content -Raw $m.FullName | Add-Content -Encoding UTF8 -Path $out
  }
  Write-Host "Merged $($md.Count) markdown files into $out"
} else {
  # Fallback: simple hello output
  $txt = Join-Path $PSScriptRoot 'out.txt'
  "Hello from payload at $(Get-Date -Format o)" | Set-Content -Encoding UTF8 $txt
  Write-Host "Wrote $txt"
}
