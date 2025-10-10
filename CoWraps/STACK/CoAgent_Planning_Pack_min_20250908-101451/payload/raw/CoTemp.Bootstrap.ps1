# CoTemp.Bootstrap.ps1
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
if ($ExecutionContext.InvokeCommand.PSObject.Properties['LocationChangedAction']) {
  $ExecutionContext.InvokeCommand.LocationChangedAction = { try { [Environment]::CurrentDirectory = (Get-Location).Path } catch {} }
}
$script:CoRoot = Join-Path $HOME 'Downloads\CoTemp'
