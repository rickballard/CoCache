Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'; $common = Join-Path $root 'common'; $scripts = Join-Path $root 'scripts'; $greet = Join-Path $root 'greetings'
$null = New-Item -ItemType Directory -Force -Path $root,$common,$scripts,$greet | Out-Null
# Lay down core files from this pack (assuming you unzipped over CoTemp)
Write-Host "Ensured CoTemp structure at $root" -ForegroundColor Green
