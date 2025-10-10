Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
param(
  [string]$BaseUrl
)
if(-not $BaseUrl){ throw "Provide -BaseUrl like https://<user>.github.io/CoAgent" }
$urls = @("$BaseUrl/","$BaseUrl/index.html","$BaseUrl/ui-mock/quad.html","$BaseUrl/status.html")
$ok=@(); $fail=@()
foreach($u in $urls){
  try{ $r=Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 30; if($r.StatusCode -ne 200){ throw "HTTP $($r.StatusCode)" }; $ok += $u }
  catch{ $fail += "$u → $($_.Exception.Message)" }
}
$stat="$BaseUrl/status.json"; $statOk=$false; $statMsg=""
try{ $r = Invoke-WebRequest -Uri $stat -UseBasicParsing -TimeoutSec 30; if($r.StatusCode -eq 200 -and $r.Content.Trim().StartsWith('{')){ $statOk=$true } }
catch{ $statMsg = $_.Exception.Message }
"---- MVP Smoke Summary ----"
"Pages OK: {0}/{1}" -f $ok.Count, $urls.Count
$ok | % { "  ✓ $_" }
if($fail.Count){ "Pages FAIL:"; $fail | % { "  ✗ $_" } }
"status.json: " + ($(if($statOk){"✓ present"}else{"(optional) missing"+$(if($statMsg){" – $statMsg"}else{""})}))
if (Get-Command gh -ErrorAction SilentlyContinue) {
  $wf = "guardrail-smoke.yml"
  $wfId = (gh workflow list --json name,id | ConvertFrom-Json | ? {$_.name -eq 'guardrail-smoke'} | Select-Object -First 1 -ExpandProperty id)
  if($wfId){ gh workflow run $wf | Out-Null; "Guardrail CI: triggered ($wf)" } else { "Guardrail CI: (workflow not found)" }
} else { "Guardrail CI: (gh CLI not found)" }
"---------------------------"
