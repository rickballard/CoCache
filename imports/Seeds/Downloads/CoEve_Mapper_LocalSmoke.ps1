param(
  [string]$RepoRoot = (Join-Path $HOME 'Documents\GitHub\MeritRank')
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$here   = Resolve-Path $RepoRoot
$allow  = Join-Path $here 'components\seeder\config\allowlist.txt'
$out    = Join-Path $here 'components\seeder\out\events.ndjson'
$score  = Join-Path $here 'tools\score_demo\out.json'

# 1) Write a local HTML sample with cred-bearing tokens
$sample = Join-Path $env:TEMP 'coeve_cred_sample.html'
@"
<!doctype html>
<html><head><meta charset="utf-8">
<meta name="c2pa.version" content="1.3">
<title>CoEve Cred Sample</title></head>
<body>
<h1>Cred Sample</h1>
<p>Demo DID reference: did:key:z6MkfDemoExampleDIDRef000000000000</p>
<pre>
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: OpenPGP

mQENBGQDemoBCACy0examplepayloadforheuristicsonly000000000000000000
=demo
-----END PGP PUBLIC KEY BLOCK-----
</pre>
</body></html>
"@ | Set-Content -LiteralPath $sample -Encoding UTF8

$uri = [System.Uri]::new($sample).AbsoluteUri
Write-Host "[INFO] Local sample page: $uri" -ForegroundColor Cyan

# 2) Ensure allowlist and append (dedupe)
if (-not (Test-Path $allow)) {
  New-Item -ItemType Directory -Force -Path (Split-Path $allow) | Out-Null
  New-Item -ItemType File -Force -Path $allow | Out-Null
}
$lines = Get-Content -LiteralPath $allow -ErrorAction SilentlyContinue
if (-not $lines -or ($lines -notcontains $uri)) {
  Add-Content -LiteralPath $allow -Value $uri
  Write-Host "[INFO] Added to allowlist: $uri" -ForegroundColor Green
} else {
  Write-Host "[INFO] Already in allowlist." -ForegroundColor Yellow
}

# 3) Run seeder with mapper=basic
Push-Location $here
python .\components\seeder\seeder.py --mapper basic --allowlist "$allow" --out "$out"
Pop-Location

# 4) Score
python "$RepoRoot\tools\score_demo\score.py" --in "$out" --out "$score"
Write-Host "[OK] Scored -> $score" -ForegroundColor Green
Get-Content -LiteralPath $score
