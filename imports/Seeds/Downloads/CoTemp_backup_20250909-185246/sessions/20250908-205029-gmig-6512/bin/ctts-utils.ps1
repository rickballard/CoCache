# shim -> ctts-utils.ps1
param([Parameter(ValueFromRemainingArguments=$true)][string[]]$ArgsFromCaller)
& (Join-Path "C:\Users\Chris\Downloads\CoTemp\_shared" "ctts-utils.ps1") @ArgsFromCaller
