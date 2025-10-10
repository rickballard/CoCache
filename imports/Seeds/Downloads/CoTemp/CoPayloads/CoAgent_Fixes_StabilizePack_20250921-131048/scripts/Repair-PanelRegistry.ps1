
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
$panelDir = Join-Path $root 'panels'

$recs = Get-ChildItem "$panelDir\*.json" -ErrorAction SilentlyContinue | ForEach-Object {
  try {
    $j = Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json
    $j | Add-Member -NotePropertyName file -NotePropertyValue $_.FullName -Force
    $j
  } catch {}
}

$alive = foreach($r in $recs){
  if (Get-Process -Id $r.pid -ErrorAction SilentlyContinue) { $r }
  else { Remove-Item -LiteralPath $r.file -Force }
}

$alive | Group-Object name | ForEach-Object {
  $keep = $_.Group | Sort-Object ts -Descending | Select-Object -First 1
  $_.Group | Where-Object { $_ -ne $keep } | ForEach-Object { Remove-Item -LiteralPath $_.file -Force }
}
"Done."
