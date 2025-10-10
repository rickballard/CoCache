# shim -> Save-DOFromClipboard.ps1
param([Parameter(ValueFromRemainingArguments=$true)][string[]]$ArgsFromCaller)
& (Join-Path "C:\Users\Chris\Downloads\CoTemp\_shared" "Save-DOFromClipboard.ps1") @ArgsFromCaller
