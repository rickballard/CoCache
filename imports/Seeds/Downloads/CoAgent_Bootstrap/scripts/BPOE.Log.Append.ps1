param([Parameter(Mandatory=$true)][string]$Title,[Parameter(Mandatory=$true)][string]$Body,[string]$LogDir="$HOME\Downloads\CoTemp\logs",[string]$LogFile="BPOE.workflow.log.md")
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$LogDir = [IO.Path]::GetFullPath($LogDir); [IO.Directory]::CreateDirectory($LogDir)|Out-Null
$path = Join-Path $LogDir $LogFile; $utc=(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
$entry = @"
### $Title
*UTC:* $utc

$Body

---
"@
Add-Content -Path $path -Value $entry -Encoding UTF8
Write-Host "Logged → $path"
