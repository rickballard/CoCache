param([switch]$Public,[switch]$Full)

$ErrorActionPreference = "Stop"
$Root     = Split-Path -Parent $MyInvocation.MyCommand.Path
$manPath  = Join-Path $Root "hp.manifest.json"
$secretPs = Join-Path $Root "hp.secret.psd1"

if(-not (Test-Path $manPath)){ throw "Missing manifest: $manPath" }

$Man = Get-Content $manPath -Raw | ConvertFrom-Json

# util
function Unredact([string]$text){ return $text } # identity
function RedactHP57([string]$text){
  return ($text -replace '(?s)<!--\s*HP57:BEGIN\s*-->.*?<!--\s*HP57:END\s*-->','[redacted]')
}
function Build-One([bool]$isPublic){
  $buf = New-Object System.Collections.Generic.List[string]
  foreach($s in $Man.sections){
    $p = Resolve-Path (Join-Path $Root $s.path) -ErrorAction Stop
    $t = Get-Content $p -Raw
    if($isPublic){ $t = RedactHP57 $t }
    $buf.Add("<!-- SOURCE: $($s.path) -->`n"); $buf.Add($t); $buf.Add("`n`n---`n`n")
  }
  return ($buf -join "`n")
}

# always build public
$publicOut = Join-Path $Root 'HP_public.md'
(Build-One -isPublic:$true) | Set-Content -Encoding UTF8 -LiteralPath $publicOut
Write-Host "Wrote $publicOut"

# full build only on proof
if($Full){
  if(-not (Test-Path $secretPs)){
    throw "Full build requested, but secret file not found: $secretPs"
  }
  $HPAuth = Import-PowerShellDataFile -Path $secretPs
  $sec = Read-Host -AsSecureString "Enter CoSteward password"
  $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
  $plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
  [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

  # hash entered password
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($plain)
  $sha   = [System.Security.Cryptography.SHA256]::Create()
  $hash  = ($sha.ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join ''

  if($hash -ne $HPAuth.Hash){ throw "Auth failed. (Hint: $($HPAuth.Hint))" }

  $fullOut = Join-Path $Root 'HP_full.md'
  (Build-One -isPublic:$false) | Set-Content -Encoding UTF8 -LiteralPath $fullOut
  Write-Host "Wrote $fullOut  (NOT added to Git)"
}

