param([string]$MsgFile)
$c = Get-Content $MsgFile -Raw
if($c -notmatch "(?m)^BPOE-Dots:"){
  Add-Content $MsgFile "`nBPOE-Dots: encouraged (Run-WithDotsEx)"
}
