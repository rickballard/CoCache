Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$owner='rickballard'; $repo='CoAgent'
$base="https://$owner.github.io/$repo"
$urls = @("$base/","$base/index.html","$base/ui-mock/quad.html","$base/status.html")

$ok=@(); $fail=@()
foreach($u in $urls){
  try{
    if($env:NO_NETWORK){ throw "sandbox:no-network" }
    $r = Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 30
    if($r.StatusCode -ne 200){ throw "HTTP $($r.StatusCode)" }
    $ok += $u
  } catch {
    $fail += "$u → $($_.Exception.Message)"
  }
}

# status.json (optional)
$stat="$base/status.json"
$statOk=$false; $statMsg=""
try{
  if($env:NO_NETWORK){ throw "sandbox:no-network" }
  $r = Invoke-WebRequest -Uri $stat -UseBasicParsing -TimeoutSec 30
  if($r.StatusCode -eq 200 -and $r.Content.Trim().StartsWith('{')){ $statOk=$true }
}catch{ $statMsg = $_.Exception.Message }

# Guardrail smoke CI (optional)
$wfName='guardrail-smoke'
$wfFile='guardrail-smoke.yml'
$wfId = $null
try{ $wfId = (gh workflow list --json name,id | ConvertFrom-Json | ? { $_.name -eq $wfName } | Select-Object -First 1 -ExpandProperty id) } catch {}
if($wfId){ try{ gh workflow run $wfFile | Out-Null } catch {} }

"---- MVP Smoke Summary ----"
"Pages OK: {0}/{1}" -f $ok.Count, $urls.Count
$ok | % { "  ✓ $_" }
if($fail.Count){ "Pages FAIL:"; $fail | % { "  ✗ $_" } }
"status.json: " + ($(if($statOk){"✓ present"}else{"(optional) missing"+$(if($statMsg){" – $statMsg"}else{""})}))
if($wfId){ "Guardrail CI: triggered ($wfFile)" } else { "Guardrail CI: (workflow not found)" }
"---------------------------"

# BPOE log (best-effort)
try {
  $data = [ordered]@{
    okCount = $ok.Count
    failCount = $fail.Count
    statOk = $statOk
    durationSec = 0
  }
  pwsh -File tools\Log-Run.ps1 -Name "mvp-smoke" -Data $data | Out-Null
} catch {}
