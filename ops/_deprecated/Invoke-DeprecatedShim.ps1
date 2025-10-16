param([string]$NewPath)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
Write-Warning "This command is deprecated. Forwarding to: $NewPath"
& $NewPath @args
