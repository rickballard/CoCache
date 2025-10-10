# CoPingLauncher.ps1
[CmdletBinding()]
param([string]$FromFile,[string]$FromUrl,[switch]$HitEnter)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module (Join-Path $here 'CoPing.psm1') -Force
if ($FromFile) { Invoke-CoPing -FromFile $FromFile -HitEnter:$HitEnter; exit }
if ($FromUrl)  { Invoke-CoPing -FromUrl  $FromUrl  -HitEnter:$HitEnter; exit }
throw "Specify -FromFile or -FromUrl"