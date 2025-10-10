# scripts/readme_lint.ps1
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$readme = Join-Path (git rev-parse --show-toplevel) 'README.md'
$t = (Get-Content -LiteralPath $readme -Raw) -replace "`r`n","`n" -replace "`r","`n"

$fail = @()

# 1) Exactly one W/W/H block (iconized)
$wwh = ([regex]::Matches($t,'^\s*<img[^>]+/(why|who|how)-line\.svg', 'Multiline')).Count
if ($wwh -ne 3) { $fail += "Expected 3 iconized Why/Who/How lines under the H2; found $wwh." }

# 2) Acrostic labels appear once each
$labels = 'LIFE','FEELS','BROKEN','UNTIL','GOVERNMENTS','COEVOLVE','SOLUTIONS','FOR YOU'
foreach ($L in $labels) {
  $c = ([regex]::Matches($t,"(?m)\*\*$([regex]::Escape($L)):\*\*")).Count
  if ($c -ne 1) { $fail += "Label **$L:** appears $c times (expected 1)." }
}

# 3) Icon src form: NAME-line.svg?v=digits; no duplicates or broken strings
if ([regex]::Matches($t,'src="\./assets/icons/(life|feels|broken|until|governments|coevolve|solutions|for-you)-line\.svg\?v=\d{6,}"').Count -lt 8) {
  $fail += "Some acrostic icons do not match ./assets/icons/NAME-line.svg?v=TIMESTAMP."
}
if ([regex]::IsMatch($t,'\?v=\d+\?v=')) { $fail += "Found duplicate ?v= cache-busters in icon URLs." }

# 4) No stray '**' directly after label colons
if ([regex]::IsMatch($t,'(?m)(?<=\*\*[A-Za-z][A-Za-z \-]+:\*\*)\s*\*\*\s+')) {
  $fail += "Found stray '**' immediately after a label."
}

if ($fail.Count) {
  Write-Host "README LINT FAIL:" -ForegroundColor Red
  $fail | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
} else {
  Write-Host "README LINT PASS" -ForegroundColor Green
}
