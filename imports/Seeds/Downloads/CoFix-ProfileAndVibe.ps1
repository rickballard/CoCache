# CoFix-ProfileAndVibe.ps1
# Purpose: Make PowerShell profile resilient and patch common CoVibe errors.
# Safe to re-run.  Creates timestamped backups.  No destructive moves.

[CmdletBinding()]
param(
  [string]$UserProfilePath = "$HOME\Documents\PowerShell\profile.ps1",
  [string]$SearchRoot      = "$HOME\Documents\GitHub"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Backup-File([string]$Path){
  if(Test-Path $Path){
    $ts = Get-Date -Format 'yyyyMMdd_HHmmss'
    $bak = "$Path.bak.$ts"
    Copy-Item -LiteralPath $Path -Destination $bak -Force
    Write-Host "Backup: $bak"
    return $bak
  }
}

# 1) Harden the profile so missing scripts don't break PS start
if(Test-Path $UserProfilePath){
  $orig = Get-Content -Raw -LiteralPath $UserProfilePath
  $modified = $orig

  # Wrap any bare dot-source lines to CoVibe.*.ps1 with a guard
  $pattern = '(?m)^\s*\.\s*("|\')(?<path>.+?CoVibe\..+?\.ps1)\1\s*$'
  if([regex]::IsMatch($modified, $pattern)){
    Backup-File $UserProfilePath | Out-Null
    $modified = [regex]::Replace($modified, $pattern, @'
try {
  $p = "$${path}"
  if(Test-Path $p){
    . $p
  } else {
    Write-Verbose "CoVibe script not found: $p"
    if(-not (Get-Command CoChatStart -ErrorAction SilentlyContinue)){
      function CoChatStart { param([string]$Message='') Write-Verbose "CoChatStart stub: $Message" }
    }
    if(-not (Get-Command CoSidecar -ErrorAction SilentlyContinue)){
      function CoSidecar { param([string]$Message='') CoChatStart $Message }
    }
  }
} catch {
  Write-Warning "Failed to import CoVibe script: $($_.Exception.Message)"
}
'@)
    Set-Content -LiteralPath $UserProfilePath -Value $modified -Encoding UTF8
    Write-Host "Hardened profile: $UserProfilePath"
  } else {
    Write-Host "Profile already guarded or no CoVibe dot-source found."
  }
} else {
  Write-Warning "Profile not found at $UserProfilePath"
}

# 2) Patch CoVibe.CoLex.ps1 common syntax error (function CoSidecar([string]=''){...})
$targets = @()
if(Test-Path $SearchRoot){
  $targets = Get-ChildItem -LiteralPath $SearchRoot -Recurse -Filter 'CoVibe.CoLex.ps1' -ErrorAction SilentlyContinue
}

foreach($t in $targets){
  $text = Get-Content -Raw -LiteralPath $t.FullName
  if($text -match 'function\s+CoSidecar\s*\(\s*\[string\]\s*=\s*""\s*\)\s*\{'){
    Backup-File $t.FullName | Out-Null
    $fixed = $text -replace 'function\s+CoSidecar\s*\(\s*\[string\]\s*=\s*""\s*\)\s*\{', 'function CoSidecar { param([string]$Message = "")'
    Set-Content -LiteralPath $t.FullName -Value $fixed -Encoding UTF8
    Write-Host "Patched CoSidecar signature in $($t.FullName)"
  } elseif($text -match 'function\s+CoSidecar\s*\(\s*\[string\]\$?[A-Za-z0-9_]*\s*=\s*""\s*\)\s*\{'){
    Backup-File $t.FullName | Out-Null
    $fixed = $text -replace 'function\s+CoSidecar\s*\(\s*\[string\]\$?[A-Za-z0-9_]*\s*=\s*""\s*\)\s*\{', 'function CoSidecar { param([string]$Message = "")'
    Set-Content -LiteralPath $t.FullName -Value $fixed -Encoding UTF8
    Write-Host "Normalized CoSidecar signature in $($t.FullName)"
  } else {
    Write-Host "No CoSidecar signature issue detected in $($t.FullName)"
  }

  # Ensure body calls CoChatStart safely
  if($fixed -notmatch 'CoChatStart'){
    # no-op; we avoid opinionated edits here
    $null = $true
  }
}

Write-Host "Done."
