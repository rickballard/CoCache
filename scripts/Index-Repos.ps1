
param([string]$ReposPath,[string]$ManifestPath,[string]$MetricsPath)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

if(!(Test-Path $ReposPath)){ throw "missing $ReposPath" }
$all = Get-Content $ReposPath -Raw | ConvertFrom-Json
$stamp = Get-Date -Format o

$entries = foreach($r in $all.repos){
  [ordered]@{ name=$r.name; path=$r.path; role=$r.role }
}
$doc = [ordered]@{ updated=$stamp; repos=$entries }
($doc | ConvertTo-Json -Depth 6) | Out-File -Encoding UTF8 $ManifestPath

if(!(Test-Path $MetricsPath)){
@"
# Metrics Index (auto)
Updated: $stamp

| !Repo | Role | Path |
|------:|------|------|
"@ | Out-File -Encoding UTF8 $MetricsPath
}

$rows = @()
foreach($e in $entries){ $rows += "| !${($e.name)} | ${($e.role)} | ${($e.path)} |" }

$headerBlock = @"
# Metrics Index (auto)
Updated: $stamp

| !Repo | Role | Path |
|------:|------|------|
"@
($headerBlock + ($rows -join "`n") + "`n") | Out-File -Encoding UTF8 $MetricsPath

