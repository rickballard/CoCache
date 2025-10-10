
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
param([string]$BaseUrl = "https://rickballard.github.io/CoAgent")

$urls = @("$BaseUrl/","$BaseUrl/index.html","$BaseUrl/ui-mock/quad.html","$BaseUrl/status.html")

$ok=@(); $fail=@()
foreach($u in $urls){
  try{
    $r = Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 30
    if($r.StatusCode -ne 200){ throw "HTTP $($r.StatusCode)" }
    $ok += $u
  } catch {
    $fail += "$u → $($_.Exception.Message)"
  }
}

"---- MVP Smoke Summary ----"
"Pages OK: {0}/{1}" -f $ok.Count, $urls.Count
$ok   | % { "  ✓ $_" }
if($fail.Count){ "Pages FAIL:"; $fail | % { "  ✗ $_" } }
"status.json: " + ($(if(Test-Path "docs/status.json"){"✓ present (local)"}else{"(optional) missing"}))
"---------------------------"
