Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"

function Write-TextFile {
  param([Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)][string[]]$Lines)
  $dir = Split-Path $Path
  if($dir -and -not (Test-Path $dir)){ New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  [System.IO.File]::WriteAllLines($Path,$Lines,[System.Text.UTF8Encoding]::new($false))
}

# --- repo root ---
$Repo = "$HOME\Documents\GitHub\CoCivium"
if(!(Test-Path $Repo)){ throw "Repo not found at $Repo" }
Set-Location $Repo

# ========== Profile.Snippet.ps1 ==========
$ProfSn = "admin/setup/Profile.Snippet.ps1"
$ProfLines = @(
  '# Profile helpers (safely dot-sourced)',
  'function cc-pr(){ gh pr list --state open --limit 20 }',
  'function cc-hub(){ pwsh -File "$PSScriptRoot/../tools/reminders/Run-ReminderHub.ps1" }',
  'function cc-sweep(){ pwsh -File "$PSScriptRoot/../tools/BackChats/Run-BackChatsSweep.ps1" }'
)
Write-TextFile -Path $ProfSn -Lines $ProfLines

# ========== RepoAccelerator.ps1 ==========
$Accel = "admin/setup/RepoAccelerator.ps1"
$AccelLines = @(
  '# RepoAccelerator — v0 (install)',
  '[CmdletBinding(SupportsShouldProcess)]',
  'param()',
  'Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"',
  '',
  '$repo  = (Get-Location).Path',
  '$hooks = Join-Path $repo ".githooks"',
  'if(!(Test-Path $hooks)){ New-Item -ItemType Directory -Force -Path $hooks | Out-Null }',
  'git config core.hooksPath .githooks',
  '',
  '$psProfileDir  = Join-Path $HOME "Documents\PowerShell"',
  '$psProfileFile = Join-Path $psProfileDir "Microsoft.PowerShell_profile.ps1"',
  'New-Item -ItemType Directory -Force -Path $psProfileDir | Out-Null',
  '$marker  = "# BEGIN CoCivium RepoAccelerator"',
  '$snippet = ". `"$repo\admin\setup\Profile.Snippet.ps1`""',
  '$body    = if(Test-Path $psProfileFile){ Get-Content -Raw $psProfileFile } else { "" }',
  'if($body -notmatch [regex]::Escape($marker)){',
  '  $append = @(',
  '    $marker,',
  '    $snippet,',
  '    "# END CoCivium RepoAccelerator"',
  '  ) -join [Environment]::NewLine',
  '  Add-Content -Encoding utf8 $psProfileFile $append',
  '  Write-Host "Profile updated: $psProfileFile"',
  '} else {',
  '  Write-Host "Profile already linked."',
  '}',
  'Write-Host "RepoAccelerator installed (hooksPath + profile link)."'
)
Write-TextFile -Path $Accel -Lines $AccelLines

# ========== RepoAccelerator-Uninstall.ps1 ==========
$Uninst = "admin/setup/RepoAccelerator-Uninstall.ps1"
$UninstLines = @(
  '# RepoAccelerator — v0 (uninstall)',
  '[CmdletBinding()]',
  'param()',
  'Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"',
  '',
  '$psProfileFile = Join-Path $HOME "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"',
  'if(Test-Path $psProfileFile){',
  '  $raw = Get-Content -Raw $psProfileFile',
  '  $raw = $raw -replace "(?s)# BEGIN CoCivium RepoAccelerator.*?# END CoCivium RepoAccelerator`r?`n?",""',
  '  $raw | Out-File -Encoding utf8 -Force $psProfileFile',
  '  Write-Host "Profile unlinked."',
  '}',
  'git config --unset core.hooksPath 2>$null',
  'Write-Host "RepoAccelerator uninstalled."'
)
Write-TextFile -Path $Uninst -Lines $UninstLines

# ========== REPO_ACCELERATOR.md ==========
$Doc = "docs/academy/REPO_ACCELERATOR.md"
$DocLines = @(
  '# RepoAccelerator (MVP)',
  '',
  '**What it does (opt-in):**',
  '- Sets `core.hooksPath` to use repo-local hooks (`.githooks`).',
  '- Adds a tiny PowerShell profile link to `admin/setup/Profile.Snippet.ps1` (aliases like `cc-hub`, `cc-pr`, `cc-sweep`).',
  '',
  '**What it never does:**',
  '- No secrets. No machine-wide installs. Fully removable (`RepoAccelerator-Uninstall.ps1`).',
  '',
  '**Install**',
  '```powershell',
  'Set-Location "$HOME\Documents\GitHub\CoCivium"',
  'pwsh -File admin/setup/RepoAccelerator.ps1',
  '# New aliases in fresh PS sessions:  cc-hub, cc-pr, cc-sweep',
  '```',
  '',
  '**Uninstall**',
  '```powershell',
  'pwsh -File admin/setup/RepoAccelerator-Uninstall.ps1',
  '```'
)
Write-TextFile -Path $Doc -Lines $DocLines

# ========== Run-ReminderHub.ps1 (v0.2, parser-safe) ==========
$Rem = "admin/tools/reminders/Run-ReminderHub.ps1"
$RemLines = @(
  '# Run-ReminderHub.ps1 — v0.2 (parser-safe)',
  '[CmdletBinding()]',
  'param([switch]$NoBackChats,[switch]$NoCIScan,[switch]$NoPRScan,[switch]$NoOESuggest)',
  'Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"',
  '',
  '$stamp = Get-Date -Format "yyyyMMdd_HHmm"',
  '$hist  = "admin/history"; New-Item -ItemType Directory -Force -Path $hist | Out-Null',
  '$out   = Join-Path $hist "Reminder_Run_$stamp.md"',
  '$lines = @("# Reminder Hub — $(Get-Date -Format ''yyyy-MM-dd HH:mm'')","")',
  'function Add-Section($title){ $script:lines += "## $title"; $script:lines += "" }',
  '',
  '# 1) PR surface',
  'if(-not $NoPRScan){',
  '  Add-Section "PR status"',
  '  try{',
  '    $json  = gh pr list --state open --json number,title,isDraft,createdAt,updatedAt,url',
  '    $items = if($json){ $json | ConvertFrom-Json } else { @() }',
  '    if(!$items){ $lines += "_No open PRs._"; $lines += "" }',
  '    else{',
  '      foreach($p in $items){',
  '        $age = [int]((New-TimeSpan -Start ([datetime]$p.createdAt) -End (Get-Date)).TotalDays)',
  '        $stale = ($age -gt 21 -and -not $p.isDraft)',
  '        $lines += ("- PR #{0} — {1}  (age:{2}d){3}  {4}" -f $p.number,$p.title,$age, $(if($p.isDraft){" [DRAFT]"}else{""}), $p.url)',
  '        if($stale){ $lines += "  - _Action:_ consider `gh pr ready --undo $($p.number)` or rebase/close." }',
  '      }',
  '      $lines += ""',
  '    }',
  '  } catch { $lines += "_PR scan error_: $($_.Exception.Message)"; $lines += "" }',
  '}',
  '',
  '# 2) CI snapshot',
  'if(-not $NoCIScan){',
  '  Add-Section "CI snapshot"',
  '  try{',
  '    $runs  = gh run list --limit 10 --json workflowName,status,conclusion,createdAt,url',
  '    $items = if($runs){ $runs | ConvertFrom-Json } else { @() }',
  '    if(!$items){ $lines += "_No recent runs._"; $lines += "" }',
  '    else{',
  '      $lines += "| Workflow | Status | Conclusion | Age(d) | URL |"',
  '      $lines += "|---|---|---|---:|---|"',
  '      foreach($r in $items){',
  '        $age = [int]((New-TimeSpan -Start ([datetime]$r.createdAt) -End (Get-Date)).TotalDays)',
  '        $lines += "| $($r.workflowName) | $($r.status) | $($r.conclusion) | $age | $($r.url) |"',
  '      }',
  '      $lines += ""',
  '    }',
  '  } catch { $lines += "_CI scan error_: $($_.Exception.Message)"; $lines += "" }',
  '}',
  '',
  '# 3) BackChats sweep (dry run)',
  'if(-not $NoBackChats){',
  '  Add-Section "BackChats sweep (summary)"',
  '  try{',
  '    $dry = pwsh -NoProfile -ExecutionPolicy Bypass -File "admin/tools/BackChats/Run-BackChatsSweep.ps1" -DryRun 2>$null',
  '    if([string]::IsNullOrWhiteSpace($dry)){ $lines += "_BackChats tool produced no output (ok if inbox empty)._"; $lines += "" }',
  '    else{',
  '      $head = ($dry -split "`r?`n") | Select-Object -First 40',
  '      $lines += $head; $lines += "…(truncated)…"; $lines += ""',
  '    }',
  '  } catch { $lines += "_BackChats error_: $($_.Exception.Message)"; $lines += "" }',
  '}',
  '',
  '# 4) OE snapshot hint',
  'if(-not $NoOESuggest){',
  '  Add-Section "OE snapshot hint"',
  '  $lines += "- If `admin/tools/*` changed recently or you updated tooling, capture OE:"',
  '  $lines += "  `pwsh -File admin/tools/bpoe/Record-Env.ps1`"',
  '  $lines += "- Weekly cadence reminder lives in docs/academy/BP_OE_WF.md."',
  '  $lines += ""',
  '}',
  '',
  '($lines -join "`r`n") | Out-File -Encoding utf8 -Force $out',
  'Write-Host "Reminder Hub wrote: $out"'
)
Write-TextFile -Path $Rem -Lines $RemLines

# --- quick smoke test: content exists and is non-empty
foreach($p in @($ProfSn,$Accel,$Uninst,$Doc,$Rem)){
  if(-not (Test-Path $p)){ throw "Expected file missing: $p" }
  if((Get-Item $p).Length -lt 10){ throw "File too small (write failed?): $p" }
}

git add -- "admin/setup/Profile.Snippet.ps1" "admin/setup/RepoAccelerator.ps1" "admin/setup/RepoAccelerator-Uninstall.ps1" "docs/academy/REPO_ACCELERATOR.md" "admin/tools/reminders/Run-ReminderHub.ps1"
git commit -m "setup: RepoAccelerator + ReminderHub (bootstrap via Downloads script)"
git push -u origin HEAD

Write-Host "Bootstrap complete. Try:  pwsh -File admin/tools/reminders/Run-ReminderHub.ps1"