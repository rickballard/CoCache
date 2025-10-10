<# 
CoCivium ChatGPT BPOE Bootstrap (v2)
- Creates a hardened ChatGPT working setup on Windows with two launch modes:
  1) App Window (extensions disabled)   -> CoCivium-Workbench.lnk
  2) Extensions Window (normal window)  -> CoCivium-Workbench (Extensions).lnk
- Uses a dedicated --user-data-dir for strict isolation (better than profile names).
- Works with Edge if available, else Chrome.
- Idempotent: re-run anytime to refresh shortcuts.
- Optional: install PowerShell aliases `cgpt` and `cgptx` for instant launch.

USAGE (PowerShell):
  # Quick run with defaults:
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
  & "$HOME\Downloads\cocivium_bpoe_bootstrap_v2.ps1" -LaunchAfterCreate -InstallShellAliases

#> 
[CmdletBinding()]
param(
  [string]$Url = "https://chatgpt.com/",
  [string]$FallbackUrl = "https://chat.openai.com/",
  [string]$UserDataDir = "$env:LOCALAPPDATA\ChatGPT-Profiles\CoCivium-Workbench",
  [string]$AppHotkey = "CTRL+ALT+G",
  [string]$ExtHotkey = "CTRL+ALT+E",
  [switch]$LaunchAfterCreate,
  [switch]$InstallShellAliases
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-BrowserPath {
  $edge   = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
  $chrome = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
  if (Test-Path $edge)   { return $edge }
  if (Test-Path $chrome) { return $chrome }
  throw "Neither Edge nor Chrome found.  Install one of them first."
}

function New-Shortcut {
  param(
    [Parameter(Mandatory)] [string]$Path,
    [Parameter(Mandatory)] [string]$Target,
    [Parameter(Mandatory)] [string]$Arguments,
    [string]$Hotkey = "",
    [string]$Icon = ""
  )
  $ws = New-Object -ComObject WScript.Shell
  $sc = $ws.CreateShortcut($Path)
  $sc.TargetPath = $Target
  $sc.Arguments  = $Arguments
  $sc.WorkingDirectory = Split-Path -Parent $Target
  if ($Icon)   { $sc.IconLocation = $Icon }
  if ($Hotkey) { $sc.Hotkey = $Hotkey } # e.g., "CTRL+ALT+G"
  $sc.Save()
}

function Test-ReachableUrl {
  param([string]$ProbeUrl)
  try {
    # HEAD often blocked; GET small and discard
    $r = Invoke-WebRequest -Uri $ProbeUrl -UseBasicParsing -MaximumRedirection 2 -TimeoutSec 8
    return $true
  } catch {
    return $false
  }
}

function Ensure-UserDataDir {
  param([string]$Path)
  New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

function Install-Aliases {
  param(
    [string]$ShellProfilePath,
    [string]$Browser,
    [string]$UserDataDir,
    [string]$Url
  )
  $block = @"
# === CoCivium ChatGPT BPOE aliases ===
function cgpt  { Start-Process -FilePath "$Browser" -ArgumentList @("--user-data-dir=`"$UserDataDir`"", "--disable-extensions", "--app=$Url") -NoNewWindow }
function cgptx { Start-Process -FilePath "$Browser" -ArgumentList @("--user-data-dir=`"$UserDataDir`"", "--new-window", "$Url") -NoNewWindow }
# === End aliases ===
"@
  if (-not (Test-Path $ShellProfilePath)) {
    New-Item -ItemType File -Force -Path $ShellProfilePath | Out-Null
  }
  $existing = Get-Content $ShellProfilePath -Raw
  if ($existing -notmatch "CoCivium ChatGPT BPOE aliases") {
    Add-Content -Path $ShellProfilePath -Value "`r`n$block`r`n"
    Write-Host "Added cgpt/cgptx aliases to $ShellProfilePath"
  } else {
    Write-Host "Aliases already present in $ShellProfilePath"
  }
}

# --- Resolve browser and URL ---
$Browser = Get-BrowserPath

# Use chatgpt.com if reachable, else fall back
$FinalUrl = if (Test-ReachableUrl -ProbeUrl $Url) { $Url } else { $FallbackUrl }
if ($FinalUrl -ne $Url) {
  Write-Warning "Primary URL '$Url' not reachable.  Falling back to '$FinalUrl'."
}

# --- Ensure user-data directory exists ---
Ensure-UserDataDir -Path $UserDataDir

$desktop   = [Environment]::GetFolderPath('Desktop')
$startMenu = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs"

# Paths
$appLnkName = "CoCivium-Workbench.lnk"
$extLnkName = "CoCivium-Workbench (Extensions).lnk"
$appLnk = Join-Path $desktop $appLnkName
$extLnk = Join-Path $desktop $extLnkName
$appLnkStart = Join-Path $startMenu $appLnkName
$extLnkStart = Join-Path $startMenu $extLnkName

# --- Create App Window shortcut (extensions disabled for max stability) ---
$appArgs = @(
  "--user-data-dir=""$UserDataDir""",
  "--disable-extensions",
  "--app=$FinalUrl"
) -join ' '
New-Shortcut -Path $appLnk -Target $Browser -Arguments $appArgs -Hotkey $AppHotkey -Icon "$Browser,0"
Copy-Item -Force $appLnk $appLnkStart

# --- Create Extensions Window shortcut (normal window, extensions allowed) ---
$extArgs = @(
  "--user-data-dir=""$UserDataDir""",
  "--new-window",
  $FinalUrl
) -join ' '
New-Shortcut -Path $extLnk -Target $Browser -Arguments $extArgs -Hotkey $ExtHotkey -Icon "$Browser,0"
Copy-Item -Force $extLnk $extLnkStart

Write-Host "Created/updated shortcuts:"
Write-Host " - $appLnk"
Write-Host " - $extLnk"
Write-Host "User data dir: $UserDataDir"
Write-Host "Browser: $Browser"
Write-Host "URL: $FinalUrl"
Write-Host ""

if ($InstallShellAliases) {
  try {
    $profilePath = if ($PSVersionTable.PSEdition -eq "Core") { $PROFILE } else { $PROFILE }
    Install-Aliases -ShellProfilePath $profilePath -Browser $Browser -UserDataDir $UserDataDir -Url $FinalUrl
  } catch {
    Write-Warning "Failed to install shell aliases: $($_.Exception.Message)"
  }
}

if ($LaunchAfterCreate) {
  Start-Process -FilePath $Browser -ArgumentList $appArgs
  Start-Sleep -Seconds 1
  Start-Process -FilePath $Browser -ArgumentList $extArgs
  Write-Host "Launched both windows for first-run checks."
}

Write-Host "Next steps:"
Write-Host " 1) Pin desired shortcuts to your taskbar."
Write-Host " 2) In the Extensions window, visit chrome://extensions (or edge://extensions) to set 'Site access: On click' and disable unneeded items."
Write-Host " 3) Enable passkeys/2FA in your ChatGPT account settings."
Write-Host ""
Write-Host "Rollback: delete the two .lnk files and remove '$UserDataDir'."
