param(
  [Parameter(Mandatory=$true)] [string] $JsonPath,
  [Parameter(Mandatory=$false)] [string] $TopicDomainsPath = "$PSScriptRoot\thinkers.domains.json"
)
$ErrorActionPreference = "Stop"

if (!(Test-Path $JsonPath)) { throw "Missing JSON: $JsonPath" }
$data = Get-Content $JsonPath -Raw | ConvertFrom-Json

$allowed = @()
if (Test-Path $TopicDomainsPath) {
  $allowed = Get-Content $TopicDomainsPath -Raw | ConvertFrom-Json
}

$fail = 0
$i = 0
foreach($t in $data){
  $i++
  if (![string]::IsNullOrWhiteSpace($t.name) -eq $false){ Write-Host "[$i] missing name" -f Red; $fail++ }
  if ($t.alignment.fit -notin @("Strong","Medium","Weak")){
    Write-Host "[$i:$($t.name)] invalid fit: $($t.alignment.fit)" -f Yellow
  }
  if ($allowed.Count -gt 0){
    foreach($d in $t.domains){
      if ($allowed -notcontains $d){
        Write-Host "[$i:$($t.name)] unknown domain: $d" -f Yellow
      }
    }
  }
  foreach($s in $t.sources){
    if ($s.url -and ($s.url -notmatch '^https?://')){
      Write-Host "[$i:$($t.name)] malformed source url: $($s.url)" -f Yellow
    }
  }
}

if ($fail -eq 0){ Write-Host "Validation OK ($i records)" -f Green } else { exit 1 }

