function Start-DotTicker { if(!(Get-Job DotTicker -EA SilentlyContinue)){ Start-Job -Name DotTicker -ScriptBlock {while($true){Write-Host -NoNewline "."; Start-Sleep 1}} | Out-Null } }
function Stop-DotTicker  { Get-Job DotTicker -EA SilentlyContinue | % { Stop-Job $_ -Force; Remove-Job $_ -Force }; Write-Host "" }
function Invoke-WithDots([scriptblock]$Work,[object[]]$Args){
  try{
    Start-DotTicker
    $j = Start-Job -ScriptBlock $Work -ArgumentList $Args
    while((Get-Job $j).State -notin 'Completed','Failed','Stopped'){ Start-Sleep 1 }
    $e = $j.ChildJobs[0].Error; $o = Receive-Job $j -Keep
    if($e.Count){ throw ($e|Out-String) }
    $o
  } finally { Stop-DotTicker }
}
$env:ADVICE_BOMBS_SKIP = '1'
. "C:\Users\Chris\Documents\GitHub\CoCache\ops\bpoe\PermissiveVersionRegex.ps1"

