param(
  [string]$BaseUrl = "https://$env:GITHUB_REPOSITORY_OWNER.github.io/$($env:GITHUB_REPOSITORY.Split('/')[1])"
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$urls = @('/','/index.html','/ui-mock/quad.html','/status.html') | % { "$BaseUrl$_" }
$probes = @()
foreach($u in $urls){
  try{
    if($env:NO_NETWORK){ throw "sandbox:no-network" }
    $r=Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 25
    $probes += @{ url=$u; ok=($r.StatusCode -eq 200); sc=$r.StatusCode }
  } catch {
    $probes += @{ url=$u; ok=$false; sc=-1 }
  }
}
$sha  = try{ (git rev-parse HEAD) } catch { "" }
$short= if($sha){ $sha.Substring(0,7) } else { "" }
$now  = (Get-Date).ToString("s")
$payload = [ordered]@{
  commit    = $short
  updated   = $now
  probes    = $probes
  mvp_smoke = (@($probes | ? { $_.ok }) ).Count
}
($payload | ConvertTo-Json -Depth 6) | Set-Content -Encoding UTF8 docs\status.json
Write-Host "Wrote docs/status.json ($now)"
