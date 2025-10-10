# shim -> Rebase-PR.ps1
param([Parameter(ValueFromRemainingArguments=$true)][string[]]$ArgsFromCaller)
& (Join-Path "C:\Users\Chris\Downloads\CoTemp\_shared" "Rebase-PR.ps1") @ArgsFromCaller
