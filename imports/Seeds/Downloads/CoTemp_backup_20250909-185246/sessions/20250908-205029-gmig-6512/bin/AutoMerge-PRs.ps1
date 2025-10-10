# shim -> AutoMerge-PRs.ps1
param([Parameter(ValueFromRemainingArguments=$true)][string[]]$ArgsFromCaller)
& (Join-Path "C:\Users\Chris\Downloads\CoTemp\_shared" "AutoMerge-PRs.ps1") @ArgsFromCaller
