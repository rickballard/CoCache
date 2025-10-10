# shim -> PR-Status.ps1
param([Parameter(ValueFromRemainingArguments=$true)][string[]]$ArgsFromCaller)
& (Join-Path "C:\Users\Chris\Downloads\CoTemp\_shared" "PR-Status.ps1") @ArgsFromCaller
