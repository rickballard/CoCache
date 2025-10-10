param(
  [string]$Repo = (Join-Path $HOME "Desktop\\CoAgent")
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$src = Join-Path $Repo "docs\\private\\CoProfile"
$dst = Join-Path $Repo "runtime\\config"
$null = New-Item -ItemType Directory -Force -Path $dst | Out-Null

function Copy-If([string]$name){
  $from = Join-Path $src $name
  if (Test-Path $from) { Copy-Item $from (Join-Path $dst $name) -Force; Write-Host "[prefs] copied $name" -ForegroundColor Cyan }
}

Copy-If "prefs.yaml"
Copy-If "prefs.json"
Copy-If "README_PRIVATE.md"
