param(
  [Parameter(Mandatory=$false)] [string] $CoCore = "$env:USERPROFILE\Documents\GitHub\CoCore",
  [Parameter(Mandatory=$false)] [string] $JsonRel = "best-practices\orgs\orgs.json",
  [Parameter(Mandatory=$false)] [string] $SheetsRel = "docs\orgs\sponsors"
)
$ErrorActionPreference = "Stop"
$JsonIn = Join-Path $CoCore $JsonRel
$SheetsDir = Join-Path $CoCore $SheetsRel
if (!(Test-Path $JsonIn)) { throw "Dataset not found: $JsonIn (start from orgs.sample.json)" }
New-Item -ItemType Directory -Force -Path $SheetsDir | Out-Null

$data = Get-Content $JsonIn -Raw | ConvertFrom-Json
function To-Slug([string]$s){ ($s.ToLower() -replace "[^a-z0-9]+","-").Trim("-") }

foreach($o in $data){
  $slug = To-Slug $o.name
  $sheet = Join-Path $SheetsDir "$slug.html"
  $sheetUrl = "https://rickballard.github.io/CoCore/orgs/sponsors/$slug.html"
  $o | Add-Member -NotePropertyName sheet_url -NotePropertyValue $sheetUrl -Force

  $domains = ($o.domains | ForEach-Object { "<span class='pill'>$_</span>" }) -join " "
  $mods = ($o.system_domains -join ", ")

  $html = @"
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"/><meta name="viewport" content="width=device-width, initial-scale=1">
<title>$($o.name) · CoCore Orgs</title>
<style>
body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:#0e0e10;color:#eee;margin:0;padding:24px}
a{color:#74b9ff;text-decoration:none} a:hover{text-decoration:underline}
.wrap{max-width:900px;margin:0 auto}
.pill{display:inline-block;padding:4px 10px;border-radius:999px;font-size:12px;background:#1c1c22;margin:2px 6px 0 0}
.meta{opacity:.8;font-size:14px}
.card{background:#141418;border:1px solid #23232a;border-radius:16px;padding:20px;margin-top:16px}
h1{margin:0 0 8px}.badge{display:inline-block;padding:2px 8px;border-radius:999px;font-size:12px;border:1px solid #2b2b32;margin-left:8px;opacity:.9}
.logo{height:40px;vertical-align:middle;margin-left:8px}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:12px}
</style></head><body>
<div class="wrap">
<a href="../../orgs/">← Back to orgs</a>
<h1>$($o.name)<span class="badge">$($o.alignment.fit)</span>$(if($o.logo_url){"<img class='logo' src='"+$o.logo_url+"'/>"})</h1>
<div class="meta">$domains</div>
<div class="card">
  <p>$($o.alignment.summary)</p>
  $(if($mods){ "<p><strong>System domains:</strong> $mods</p>" })
  $(if($o.website){ "<p><strong>Website:</strong> <a href='"+$o.website+"' target='_blank' rel='noopener'>"+$o.website+"</a></p>" })
  <div class="meta">Last-checked: $($o.provenance.last_checked)</div>
</div>
</div></body></html>
"@

  Set-Content -Path $sheet -Value $html -NoNewline
}

$JsonOut = $data | ConvertTo-Json -Depth 8
Set-Content -Path $JsonIn -Value $JsonOut -NoNewline

Write-Host "Org sheets in $SheetsDir"
Write-Host "Updated dataset $JsonIn"

