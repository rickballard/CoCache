param(
  [Parameter(Mandatory)][string]$Path,
  [Parameter(Mandatory)][string[]]$Lines
)
$ErrorActionPreference="Stop"
$dir = Split-Path -Parent $Path
if($dir -and -not (Test-Path $dir)){ New-Item -ItemType Directory -Path $dir -Force | Out-Null }
Set-Content -LiteralPath $Path -Value $Lines -Encoding UTF8

