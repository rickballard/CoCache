# Fails PR if JSON XREF footers are missing/invalid on critical assets
param(
  [string]$Root = ".",
  [Parameter(Mandatory)][string]$Spec,
  [Parameter(Mandatory)][string]$Schema
)
$ErrorActionPreference='Stop'
function Read-XrefSpec([string]$specPath){
  $md = Get-Content $specPath -Raw
  $pattern = '(?s)```json\s*?xref-spec\s*(?<json>{.*?})\s*```'
  $m = [regex]::Match($md, $pattern)
  if(!$m.Success){ throw "Spec JSON block (```json xref-spec …```) not found in $specPath" }
  return ($m.Groups["json"].Value | ConvertFrom-Json)
}
function Get-Files([string]$root,[string[]]$globs){
  $acc=@()
  foreach($g in $globs){
    $acc += Get-ChildItem -Path (Join-Path $root $g) -Recurse -File -ErrorAction SilentlyContinue
  }
  return $acc | Sort-Object FullName -Unique
}
function Try-ParseXref([string]$text){
  $m = [regex]::Match($text, '(?s)<!--\s*XREF\b\s*(?<json>{.*?})\s*XREF\s*-->')
  if(!$m.Success){ return $null }
  try { return ($m.Groups['json'].Value | ConvertFrom-Json -ErrorAction Stop) } catch { return $null }
}
$schema = Get-Content $Schema -Raw | ConvertFrom-Json
function Test-AgainstSchema($obj,$schema){
  $required = @($schema.required)
  foreach($k in $required){ if(-not $obj.PSObject.Properties.Name.Contains($k)){ return "missing required key '$k'" } }
  return $null
}
$spec = Read-XrefSpec $Spec
$critical = Get-Files $Root $spec.critical
if(!$critical){ Write-Host "::warning ::No critical assets matched; check spec."; exit 0 }
$fail=$false
foreach($f in $critical){
  $txt = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
  $j = Try-ParseXref $txt
  if($null -eq $j){
    Write-Host "::error file=$($f.FullName)::missing or invalid XREF footer"
    $fail=$true; continue
  }
  $why = Test-AgainstSchema $j $schema
  if($why){
    Write-Host "::error file=$($f.FullName)::XREF schema violation: $why"
    $fail=$true
  }
}
if($fail){ exit 1 }