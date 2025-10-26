
param([string]$Path = ".")
$max = 100KB
$bad = @()
Get-ChildItem -Path $Path -Recurse -File | Where-Object { $_.Length -gt $max } | ForEach-Object {
  $bad += "$($_.FullName) size=$([Math]::Round($_.Length/1KB,2))KB > 100KB"
}
if ($bad.Count) { $bad | % { Write-Host $_ -ForegroundColor Red }; exit 1 } else { Write-Host "Size lint OK" -ForegroundColor Green }

