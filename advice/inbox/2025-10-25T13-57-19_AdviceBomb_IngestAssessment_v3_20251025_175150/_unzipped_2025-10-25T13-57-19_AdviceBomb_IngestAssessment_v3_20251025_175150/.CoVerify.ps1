Write-Host "🧪 CoVerify started..." -ForegroundColor Cyan
$path = Split-Path -Parent $MyInvocation.MyCommand.Definition
Get-ChildItem -Path $path | Format-List Name,Length,LastWriteTime
Write-Host "✅ Directory listing complete."
