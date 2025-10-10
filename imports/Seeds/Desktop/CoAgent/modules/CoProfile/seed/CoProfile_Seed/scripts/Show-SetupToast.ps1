\
Import-Module (Join-Path $PSScriptRoot 'CoProfile.psm1') -Force -ErrorAction SilentlyContinue
$p = Get-CoProfile
Write-Host ""
Write-Host "CoAgent Launcher – Setup" -ForegroundColor Cyan
if($p){
  Write-Host ("User: {0} ({1})" -f $p.user.display_name, $p.user.handle)
  Write-Host ("Session default: {0}   Tag: {1}" -f $p.bpoe.default_session, $p.bpoe.default_tag)
  Write-Host ("DO inbox: {0}" -f $p.bpoe.do_inbox)
  Write-Host ("Style: numbered={0}, 2-spaces={1}, buddy={2}" -f $p.style.prefer_numbered_steps, $p.style.two_spaces_after_periods, $p.style.buddy_mode)
} else {
  Write-Host "No CoProfile detected yet. Run scripts/Install-CoProfile.ps1" -ForegroundColor Yellow
}
