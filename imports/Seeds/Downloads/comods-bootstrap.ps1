param([string]$Name,[string]$Body)
$dl = Join-Path $HOME "Downloads\\$Name"
Set-Content -Encoding UTF8 $dl -Value $Body
& $dl
