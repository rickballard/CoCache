# CoTemp.Bootstrap.ps1
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
$common = Join-Path $root 'common'
if (Test-Path $common) {
  Get-ChildItem -LiteralPath $common -Filter '*.ps1' -File -EA SilentlyContinue | ForEach-Object { . $_.FullName }
}
