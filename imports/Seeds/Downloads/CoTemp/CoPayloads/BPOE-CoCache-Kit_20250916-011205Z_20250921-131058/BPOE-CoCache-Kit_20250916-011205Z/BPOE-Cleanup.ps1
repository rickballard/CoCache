param([string]$CoTemp = "C:\Users\Chris\Documents\CoTemp\BPOE")
if(Test-Path $CoTemp){
  Remove-Item -Recurse -Force $CoTemp
  Write-Host "🧹 Removed $CoTemp" -ForegroundColor Green
} else {
  Write-Host "Nothing to clean at $CoTemp"
}
