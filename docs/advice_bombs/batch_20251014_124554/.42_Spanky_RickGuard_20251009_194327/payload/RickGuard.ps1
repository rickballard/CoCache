# RickGuard.ps1 — repo friction switches and helpers (PS7)

param()

$global:RickGuardOwner = 'rickballard'
$global:RickGuardCriticalDefault = @('CoCivium')

function Get-RepoInfo {
  param([Parameter(Mandatory)][string]$OwnerRepo)
  try {
    $json = gh repo view $OwnerRepo --json defaultBranchRef,isEmpty `
            --jq "{branch: .defaultBranchRef.name, isEmpty: .isEmpty}" 2>$null
    if ($json) { return ($json | ConvertFrom-Json) } else { return @{ branch=$null; isEmpty=$true } }
  } catch { return @{ branch=$null; isEmpty=$true } }
}

function Set-RepoMergeMode {
  param([Parameter(Mandatory)][string]$OwnerRepo) # owner/name
  @{ allow_auto_merge=$true; delete_branch_on_merge=$true; allow_squash_merge=$true;
     allow_merge_commit=$false; allow_rebase_merge=$false } |
    ConvertTo-Json | gh api -X PATCH repos/$OwnerRepo --input - 2>$null | Out-Null
}

function Ensure-Codeowners {
  param([Parameter(Mandatory)][string]$OwnerRepo, [string]$CodeOwner='@rickballard')
  $ri = Get-RepoInfo $OwnerRepo
  if ($ri.isEmpty -or [string]::IsNullOrWhiteSpace($ri.branch)) { return }
  $desired = "* $CodeOwner`n"
  try {
    $sha = gh api repos/$OwnerRepo/contents/.github/CODEOWNERS --jq .sha 2>$null
    $content = if ($sha) { gh api repos/$OwnerRepo/contents/.github/CODEOWNERS --jq .content 2>$null } else { "" }
    $existing = if ($content) { [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($content)) } else { "" }
  } catch { $sha = $null; $existing = "" }
  if ($existing -ne $desired) {
    $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($desired))
    $payload = @{ message="chore: set CODEOWNERS ($CodeOwner)"; content=$b64; branch=$ri.branch }
    if ($sha) { $payload.sha = $sha }
    ($payload | ConvertTo-Json -Depth 6) | gh api -X PUT repos/$OwnerRepo/contents/.github/CODEOWNERS --input - 2>$null | Out-Null
  }
}

function Enable-ClassicProtection {
  param(
    [Parameter(Mandatory)][string]$OwnerRepo,
    [string[]]$Checks = @(),
    [int]$Reviews = 0
  )
  $ri = Get-RepoInfo $OwnerRepo
  if (-not $ri.branch) { return }
  $bp = [ordered]@{
    enforce_admins = $false
    restrictions   = $null
    required_status_checks = $( if ($Checks.Count) { @{ strict=$false; contexts=$Checks } } else { $null } )
    required_pull_request_reviews = $( if ($Reviews -gt 0) { @{ required_approving_review_count=$Reviews; require_code_owner_reviews=$true } } else { $null } )
  } | ConvertTo-Json -Depth 6

  try {
    $bp | gh api -X PUT "repos/$OwnerRepo/branches/$($ri.branch)/protection" `
          -H "Accept: application/vnd.github+json" --input - | Out-Null
  } catch {
    if ($_.Exception.Message -notmatch 'Branch protection has been disabled') { throw }
  }

  # Optional: explicitly disable force-pushes (endpoint not everywhere)
  try {
    @{ enabled = $false } | ConvertTo-Json |
      gh api -X POST "repos/$OwnerRepo/branches/$($ri.branch)/protection/allow_force_pushes" `
        -H "Accept: application/vnd.github+json" --input - 2>$null | Out-Null
  } catch {}
}

function Disable-ClassicProtection {
  param([Parameter(Mandatory)][string]$OwnerRepo)
  $ri = Get-RepoInfo $OwnerRepo
  if ($ri.branch) {
    gh api -X DELETE "repos/$OwnerRepo/branches/$($ri.branch)/protection" `
      -H "Accept: application/vnd.github+json" 2>$null | Out-Null
  }
}

function Enable-RickGuardSeed {
  param([Parameter(Mandatory)][string]$OwnerRepo)
  Set-RepoMergeMode -OwnerRepo $OwnerRepo
  Ensure-Codeowners -OwnerRepo $OwnerRepo -CodeOwner '@rickballard'
  try { Enable-ClassicProtection -OwnerRepo $OwnerRepo -Checks @() -Reviews 0 } catch {}
}

function Enable-RickGuardCritical {
  param(
    [Parameter(Mandatory)][string]$OwnerRepo,
    [string[]]$Checks = @('ci/smoke','ci/test'),
    [int]$Reviews = 1
  )
  Set-RepoMergeMode -OwnerRepo $OwnerRepo
  Ensure-Codeowners -OwnerRepo $OwnerRepo -CodeOwner '@rickballard'
  Enable-ClassicProtection -OwnerRepo $OwnerRepo -Checks $Checks -Reviews $Reviews
}

function Disable-RickGuard {
  param([Parameter(Mandatory)][string]$OwnerRepo)
  Set-RepoMergeMode -OwnerRepo $OwnerRepo
  Ensure-Codeowners -OwnerRepo $OwnerRepo -CodeOwner '@rickballard'
  Disable-ClassicProtection -OwnerRepo $OwnerRepo
}

function Set-RickGuardAll {
  param(
    [Parameter(Mandatory)][string]$Owner,
    [ValidateSet('Seed','Critical','Off')][string]$Mode,
    [string[]]$CriticalSet = $global:RickGuardCriticalDefault,
    [string[]]$Checks = @('ci/smoke','ci/test'),
    [int]$Reviews = 1,
    [string[]]$Exclude = @()
  )
  $repos = gh repo list $Owner --visibility public `
           --json name,nameWithOwner,isArchived,isEmpty,defaultBranchRef --limit 200 | ConvertFrom-Json
  foreach ($r in $repos) {
    if ($r.isArchived -or $r.isEmpty -or ($Exclude -contains $r.name)) { continue }
    $or = $r.nameWithOwner
    if ($Mode -eq 'Critical' -or ($CriticalSet -contains $r.name)) {
      Write-Host "[$or] Critical"
      Enable-RickGuardCritical -OwnerRepo $or -Checks $Checks -Reviews $Reviews
    }
    elseif ($Mode -eq 'Seed') {
      Write-Host "[$or] Seed"
      Enable-RickGuardSeed -OwnerRepo $or
    }
    else {
      if ($CriticalSet -contains $r.name) {
        Write-Host "[$or] Critical (held)"
        Enable-RickGuardCritical -OwnerRepo $or -Checks $Checks -Reviews $Reviews
      } else {
        Write-Host "[$or] Off"
        Disable-RickGuard -OwnerRepo $or
      }
    }
  }
}

# Convenience wrappers
function rg-seed  { param([string[]]$Critical=$global:RickGuardCriticalDefault) Set-RickGuardAll -Owner $global:RickGuardOwner -Mode Seed     -CriticalSet $Critical }
function rg-off   { param([string[]]$Critical=$global:RickGuardCriticalDefault) Set-RickGuardAll -Owner $global:RickGuardOwner -Mode Off      -CriticalSet $Critical }
function rg-tight { param([string[]]$Critical=$global:RickGuardCriticalDefault) Set-RickGuardAll -Owner $global:RickGuardOwner -Mode Critical -CriticalSet $Critical }

function rg-status {
  $branch = gh repo view "$($global:RickGuardOwner)/CoCivium" --json defaultBranchRef --jq .defaultBranchRef.name
  if ($branch) {
    gh api "repos/$($global:RickGuardOwner)/CoCivium/branches/$branch/protection" `
      -H "Accept: application/vnd.github+json" `
      --jq '{CoCivium_checks: .required_status_checks.contexts, CoCivium_reviews: .required_pull_request_reviews.required_approving_review_count}'
  }
  gh api "repos/$($global:RickGuardOwner)/CoCache" `
    --jq "{allow_auto_merge,delete_branch_on_merge,allow_squash_merge,allow_merge_commit,allow_rebase_merge}"
}
