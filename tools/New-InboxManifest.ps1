param(
[Parameter(Mandatory)] [string]$Slug,  # e.g. "cocivium-money-claimflow_20251026_014919"
[string]$Root = "$HOME\Documents\GitHub\CoCache"
)
$ErrorActionPreference = "Stop"
$path = Join-Path $Root ("advice\inbox\{0}" -f $Slug)
if (!(Test-Path $path)) { throw "Not found: $path" }

# Collect coevo manifests if present
$co = @{}
foreach($n in 1..3){
$m = Join-Path $path ("coevo-{0}\MANIFEST.json" -f $n)
if(Test-Path $m){
  try{ $co["$n"] = (Get-Content $m -Raw | ConvertFrom-Json) }catch{}
}
}

$summary = [pscustomobject]@{
slug    = $Slug
created = (Get-Item $path).LastWriteTime.ToString("o")
coevo   = $co
}
$target = Join-Path $path "INBOX_MANIFEST.json"
$summary | ConvertTo-Json -Depth 10 | Set-Content -Encoding utf8 $target
Write-Host "Wrote $target" -ForegroundColor Green

