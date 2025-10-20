$ErrorActionPreference="Stop"
$files = (& git diff --cached --name-only --diff-filter=ACMR)
$targets = $files | Where-Object { $_ -match "\.(ps1|psm1|psd1)$" }
$bad = @()
foreach($f in $targets){
  if(-not (Test-Path $f)){ continue }
  $t = Get-Content -LiteralPath $f -Raw
  if($t -match '@"'){ $bad += $f; continue }
  if($t -match "@'"){ $bad += $f; continue }
}
if($bad.Count){
  Write-Error ("BPOE: here-strings are banned. Fix these files:" + [Environment]::NewLine + (" - " + ($bad -join ([Environment]::NewLine + " - "))))
  exit 1
}
exit 0
