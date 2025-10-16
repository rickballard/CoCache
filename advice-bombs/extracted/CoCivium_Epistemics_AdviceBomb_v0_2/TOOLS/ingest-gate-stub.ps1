param(
  [string]$Path = "."
)
Write-Host "Ingest-Gate v0.2 (stub with checks) scanning $Path"
$required = @('source:', 'license:', 'timestamp:', 'hash:', 'generation:')
$files = Get-ChildItem -Path $Path -Recurse -File -Include *.md,*.mdx,*.yml,*.yaml,*.json,*.txt
$fail = 0
foreach ($f in $files) {
  $content = Get-Content -Path $f.FullName -Raw
  $hasProv = ($content -match '(?im)^provenance:')
  $isTierA = ($f.FullName -match 'Tier-A|POLICY|sites/|docs/')
  if ($isTierA -and -not $hasProv) {
    Write-Host "ERROR: $($f.FullName) missing 'provenance:' block"
    $fail = 1
    continue
  }
  if ($hasProv) {
    foreach ($key in $required) {
      if ($content -notmatch [regex]::Escape($key)) {
        Write-Host "ERROR: $($f.FullName) missing required key $key"
        $fail = 1
      }
    }
  }
}
if ($fail -ne 0) {
  Write-Error "Ingest-Gate failed. Add provenance blocks/keys."
  exit 1
} else {
  Write-Host "OK: Ingest-Gate checks passed (stub)"
}
