param()
$ErrorActionPreference = 'SilentlyContinue'
Import-Module PSReadLine -ErrorAction SilentlyContinue
$ErrorActionPreference = 'Continue'

$profileFile = $PROFILE.CurrentUserAllHosts
$newSnippet = @'
# CoAgent: safe ChatGPT: dropper (PS7 + PSReadLine only)
try {
  if ($PSVersionTable.PSEdition -eq "Core" -and (Get-Module -ListAvailable PSReadLine)) {
    Import-Module PSReadLine -ErrorAction SilentlyContinue
    if (Get-Command Get-PSReadLineBuffer -ErrorAction SilentlyContinue) {
      Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
        try {
          $line = (Get-PSReadLineBuffer).InputText
          if ($line -match "^\s*ChatGPT:") {
            $log = "$HOME\Documents\GitHub\CoAgent\docs\status\chat-drops.log"
            New-Item -ItemType Directory -Force -Path (Split-Path $log) | Out-Null
            Add-Content -Encoding UTF8 $log ("{0:o} {1}" -f (Get-Date), $line)
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0,$line.Length,'')
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
          } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
          }
        } catch { [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine() }
      }
    }
  }
} catch {}
'@

if (-not (Test-Path $profileFile)) {
  New-Item -ItemType File -Force -Path $profileFile | Out-Null
}
Add-Content -Path $profileFile -Encoding UTF8 "`r`n$newSnippet"
Write-Host "Profile hardened at: $profileFile"
