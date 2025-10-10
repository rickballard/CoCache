# Set-CoPanelTag.ps1
[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$Tag,[string]$ChatUrl)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
$env:CO_TAG=$Tag
if ($PSBoundParameters.ContainsKey('ChatUrl')) { $env:CO_CHAT_URL=$ChatUrl }
Write-Host "CO_TAG=$($env:CO_TAG)"
if ($env:CO_CHAT_URL){Write-Host "CO_CHAT_URL=$($env:CO_CHAT_URL)"}