param([string]$ReposPath,[string]$ManifestPath,[string]$MetricsPath)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

if(!(Test-Path $ReposPath)){ throw "missing $ReposPath" }
$all = Get-Content $ReposPath -Raw | ConvertFrom-Json
$stamp = Get-Date -Format o

# simple manifest (name/path only; roles preserved if present)
$entries = foreach($r in $all.repos){
  [ordered]@{ name=$r.name; path=$r.path; role=$r.role }
}
$doc = [ordered]@{ updated=$stamp; repos=$entries }
($doc | ConvertTo-Json -Depth 6) | Out-File -Encoding UTF8 $ManifestPath

# minimal metrics table header if missing
if(!(Test-Path $MetricsPath)){
@"
# Metrics Index (auto)
Updated: $stamp

| !Repo | Role | Path |
|------:|------|------|
"@ | Out-File -Encoding UTF8 $MetricsPath
}

# append/refresh rows (idempotent naive: rewrite table)
$rows = @()
foreach($e in $entries){
  $rows += "| !${($e.name)} | ${($e.role)} | ${($e.path)} |"
}
$hdr = (Select-String -Path $MetricsPath -Pattern '^\| !Repo' -Context 0,0 -SimpleMatch)
if($hdr){ 
  # rewrite file as header + rows
  $head = Get-Content $MetricsPath | Select-String -Pattern '^\| !Repo' -Context 0,0
}
$headerBlock = @"
# Metrics Index (auto)
Updated: $stamp

| !Repo | Role | Path |
|------:|------|------|
"@
($headerBlock + ($rows -join "`n") + "`n") | Out-File -Encoding UTF8 $MetricsPath
