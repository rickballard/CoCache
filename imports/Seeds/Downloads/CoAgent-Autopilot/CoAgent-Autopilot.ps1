# CoAgent-Autopilot.ps1
[CmdletBinding(SupportsShouldProcess=$true)]
param(
  [string]$Downloads = "$HOME\Downloads",
  [string]$KitName   = "CoAgent-Pickup-Kit",
  [string]$RepoPath  = "$HOME\Documents\GitHub\CoAgent",
  [string]$Session   = "Productize backchatter",
  [switch]$SkipPR,
  [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Info([string]$m){ Write-Host "[INFO]  $m" }
function Warn([string]$m){ Write-Warning $m }
function Note([string]$m){ Write-Host "[NOTE]  $m" -ForegroundColor Yellow }
function Die([string]$m){ throw "[FATAL] $m" }

$pwshPath = (Get-Command pwsh).Source
if (-not $pwshPath) { Die "PowerShell 7+ required." }

$Repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $Repo) { Die "Repo not found: $RepoPath" }
if (-not (Test-Path (Join-Path $Repo '.git'))) { Die "Not a git repo: $Repo" }

function Has-Git { git --version *>$null }
function Has-GH { gh --version *>$null }
$hasGit = Has-Git
$hasGH  = Has-GH

$kitDir = Join-Path $Downloads $KitName
$kitZip = Join-Path $Downloads ($KitName + ".zip")
if (-not (Test-Path $kitDir) -and -not (Test-Path $kitZip)) {
  Die "Pickup Kit not found at `"$kitDir`" or `"$kitZip`"."
}
if (-not (Test-Path $kitDir) -and (Test-Path $kitZip)) {
  Info "Expanding $kitZip ..."
  Expand-Archive -Path $kitZip -DestinationPath $Downloads -Force
}
$starter = Join-Path $kitDir "scripts\Start-CoAgent-Pickup.ps1"
if (-not (Test-Path $starter)) { Die "Starter not found at $starter" }
$copyArgs = @("-File", $starter, "-RepoPath", $Repo)
if ($Force) { $copyArgs += "-Force" }
Info "Copying kit into repo via Start-CoAgent-Pickup.ps1"
& pwsh @copyArgs

# Profile dropper (dedupe)
$profileFile = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$newSnippet  = @"
# ChatGPT: dropper
if (`$env:COAGENT_PROFILE_READY -ne '1') {
  `$env:COAGENT_PROFILE_READY = '1'
}
# ChatGPT: /dropper
"@
New-Item -ItemType Directory -Force -Path (Split-Path $profileFile) | Out-Null
$raw = if (Test-Path $profileFile) { Get-Content -Raw $profileFile } else { "" }
if ($raw -notmatch '(?ms)^#\s*ChatGPT:\s*dropper\b.*?#\s*ChatGPT:\s*/dropper\b') {
  Info "Injecting ChatGPT dropper into profile."
  Add-Content -Encoding UTF8 $profileFile "`r`n$newSnippet"
} else {
  Info "Profile already contains ChatGPT dropper; leaving as-is."
}

# Startup VBS
$startup = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup'
$vbsPath = Join-Path $startup 'CoAgent_Delayed.vbs'
$vbs = @'
Option Explicit
Dim sh, fso, ps
Set sh  = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
ps = fso.BuildPath(sh.ExpandEnvironmentStrings("%USERPROFILE%"), _
      "Documents\GitHub\CoAgent\tools\Start-CoInboxWatcher.ps1")
If Not fso.FileExists(ps) Then WScript.Quit
sh.Run "pwsh.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & ps & """", 0, False
'EOF
'@
Set-Content -Encoding ASCII -Path $vbsPath -Value $vbs

# Electron build check
Push-Location (Join-Path $Repo 'electron')
try {
  if (-not (Test-Path '.\dist\win-unpacked\CoAgent.exe')) {
    Info "Packing Electron app (win-unpacked)..."
    $npx = Join-Path $env:ProgramFiles 'nodejs\npx.cmd'
    if (-not (Test-Path $npx)) { Die "NodeJS (npx) not found at $npx" }
    & $npx electron-builder -w dir
  }
}
finally { Pop-Location }

$unpack = Join-Path $Repo 'electron\dist\win-unpacked\CoAgent.exe'
if (-not (Test-Path $unpack)) { Warn "CoAgent.exe missing; Pair will skip launch." }

# Shortcuts
$desktop = [Environment]::GetFolderPath('Desktop')
$wt      = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\wt.exe'
$pwsh    = $pwshPath
$pair    = Join-Path $Repo 'tools\Pair-CoSession.ps1'

function New-Shortcut {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][string]$Target,
    [string]$Args = '',
    [string]$WorkingDir = $HOME,
    [string]$IconLocation = $null
  )
  $shell = New-Object -ComObject WScript.Shell
  $sc = $shell.CreateShortcut($Path)
  $sc.TargetPath = $Target
  $sc.Arguments  = $Args
  $sc.WorkingDirectory = $WorkingDir
  if ($IconLocation) { $sc.IconLocation = $IconLocation }
  $sc.Save()
}

$icoCo = Join-Path $Repo 'electron\build\icon.ico'
$icoWT = if (Test-Path $wt) { "$wt,0" } else { $null }
$icoPS = if (Test-Path $pwsh){ "$pwsh,0"} else { $null }
if (-not (Test-Path $icoCo)) { $icoCo = $icoWT }

$lnk1 = Join-Path $desktop 'PowerShell 7 (Tabs).lnk'
if (Test-Path $wt) { New-Shortcut -Path $lnk1 -Target $wt -Args '-w 0 nt -p "PowerShell"' -IconLocation $icoPS }
else { New-Shortcut -Path $lnk1 -Target $pwsh -Args '-NoLogo' -IconLocation $icoPS }

$lnk2 = Join-Path $desktop 'CoAgent Panel (PS7 Tabs).lnk'
$psCmd = '$env:COAGENT_SESSION="{0}"; & "{1}"' -f $Session, $pair
if (Test-Path $wt) {
  $args2 = '-w 0 nt -d "~" pwsh -NoLogo -NoExit -Command "{0}"' -f ($psCmd.Replace('"','"'))
  New-Shortcut -Path $lnk2 -Target $wt -Args $args2 -IconLocation $icoCo
} else {
  $args2 = "-NoLogo -NoExit -Command `"$env:COAGENT_SESSION='$Session'; & '$pair'`""
  New-Shortcut -Path $lnk2 -Target $pwsh -Args $args2 -IconLocation $icoCo
}

$lnk3 = Join-Path $desktop 'Dev Terminal – PS7 + CoAgent.lnk'
if (Test-Path $wt) {
  $args3 = @(
    '-w 0'
    'nt -p "PowerShell"'
    ('nt -d "~" pwsh -NoLogo -NoExit -Command "{0}"' -f ($psCmd.Replace('"','"')))
  ) -join ' ; '
  New-Shortcut -Path $lnk3 -Target $wt -Args $args3 -IconLocation $icoWT
} else {
  $cmdPath = Join-Path $Repo 'tools\CoAgentTwoTabs.cmd'
  @"
@echo off
start "" "" "$pwsh" -NoLogo
start "" "" "$pwsh" -NoLogo -NoExit -Command "$env:COAGENT_SESSION='$Session'; & '$pair'"
"@ | Set-Content -Encoding ASCII $cmdPath
  New-Shortcut -Path $lnk3 -Target $cmdPath -IconLocation $icoWT
}

$env:COAGENT_SESSION = $Session
try { & $pair -WaitExec:$false -AutoExec:$false } catch { Warn "Pair skipped: $($_.Exception.Message)" }

# Optional protected business plan
$bpZip = Join-Path "$HOME\Documents\GitHub\CoCache" "private\CoAgent_BusinessPlan.zip"
$bpOut = Join-Path $Repo "docs\private"
if (Test-Path $bpZip) {
  New-Item -ItemType Directory -Force -Path $bpOut | Out-Null
  Note "Found protected business plan zip at $bpZip"
  $pw = # [MVP3] removed Read-Host prompt
  if ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw))) {
    $tmp = Join-Path $env:TEMP ("bp_" + [guid]::NewGuid().ToString() + ".zip")
    Copy-Item $bpZip $tmp -Force
    try {
      Expand-Archive -Path $tmp -DestinationPath $bpOut -Force -ErrorAction Stop
    } catch {
      $seven = "${env:ProgramFiles}\7-Zip\7z.exe"
      if (Test-Path $seven) {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw)
        $plain = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        & $seven x $tmp "-o$bpOut" "-p$plain" -y | Out-Null
      } else {
        Warn "7-Zip not found; cannot extract encrypted archive."
      }
    }
    Remove-Item $tmp -Force -ErrorAction SilentlyContinue
  } else {
    Note "Skipped extracting business plan (no password provided)."
  }
}

Push-Location $Repo
try {
  if (Has-Git) {
    $branch = (git rev-parse --abbrev-ref HEAD).Trim()
    if ($branch -eq 'HEAD') { Die "Detached HEAD; checkout a branch first." }
    git add -A
    if (-not (git diff --cached --quiet)) {
      git commit -m "chore(coagent): bootstrap pickup kit & desktop wiring"
    }
    $remote = (git remote) | Select-Object -First 1
    if ($remote -and -not $SkipPR) {
      if (Has-GH) {
        $title = "CoAgent Autopilot: pickup kit, wiring, pairing, startup, shortcuts"
        $body  = @"
Automated bootstrap:
- Installed Pickup Kit, pairing, startup VBS, desktop shortcuts.
- Electron win-unpacked packaging check.
- Optional business-plan extraction path.
- Idempotent profile injection (ChatGPT dropper).
"@
        try { gh pr create --fill --title $title --body $body 2>$null | Out-Null } catch {}
        try { gh pr view --json number | Out-Null; Write-Host "Use: gh pr merge --squash --delete-branch" -ForegroundColor Yellow } catch {}
      }
    }
  }
}
finally { Pop-Location }

Info "CoAgent-Autopilot complete."

