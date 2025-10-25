param(
          [Parameter(Mandatory=$true)][string]$Owner,
          [Parameter(Mandatory=$true)][string]$Repo,
          [string]$Branch = "docs/cc-seed",
          [switch]$DryRun
        )
        Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
        function Say([string]$m){ "{0}  {1}" -f (Get-Date -Format s),$m | Write-Host }
        function Ensure([string]$path,[string]$content){
          if(Test-Path $path){ Say "keep: $path"; return $false }
          if($DryRun){ Say "would create: $path"; return $true }
          New-Item -Force -ItemType Directory (Split-Path $path) | Out-Null
          $content | Set-Content -Encoding UTF8 -NoNewline $path
          Say "create: $path"; return $true
        }

        $seed = [ordered]@{
          ".canon.CoCivium_Principles_v0.1.md" = @'
---
title: CoCivium Principles
version: 0.1
immutability:
  grade: canon
  policy: no-in-place-edits
provenance: seed
---

# CoCivium Principles (v0.1)
- Human limits are a design constraint.
- Multi-mind > single-hero.
- Small, reversible, audited steps.
'@
          ".cc.CC_Megascroll_Seed_v0.1.md" = @'
---
title: Cognocarta Consenti — Megascroll (Seed)
version: 0.1
immutability:
  grade: stable
  policy: edit-via-pr
includes:
  - .canon.CoCivium_Principles_v0.1.md
---

# CC Megascroll (Seed)
This file assembles core canon and CC components as a starting point.
'@
          "BPOE_Wisdom_Snippets.md" = @'
# BPOE / Human-Limits Snippets
- Yellow-Flag: "I need a cool-down; ETA next handoff window."
- Handoff note: who/what/rollback.
- Rest Block: minimum 8h within 24h rolling window.
'@
          "_Filename_Conventions.md" = @'
# Filename Conventions
- Canon: .canon.<Title>_vM.m.md  (immutable; supersede only)
- CC components: .cc.<Component>_vM.m.md (PR edits; bump version)
- Highlighted: read/.hl.<slug>_YYYY-MM-DD.md
- Notes: work/.note.<topic>_YYYYMMDD_HHMM.md
'@
          "docs/.do/DO-Canon-Change.md" = @'
# DO: Canon Change
1. Propose successor filename.
2. Link prior canon; state deltas + rollback.
3. PR with immutability grade + signoff.
'@
          "docs/.do/DO-CC-Seed.md" = @'
# DO: CC Seed
1. Audit overlap (tools/cc/Audit-Overlap.ps1).
2. Add missing seeds only.
3. PR: "docs: seed CC v0.1 (idempotent)".
'@
          "docs/.do/DO-Rest-Policy.md" = @'
# DO: Rest Policy
- Require handoff line in PR template.
- Block merges if no rollback plan.
- Cool-down checklist on failures.
'@
        }

        $changed=$false
        foreach($k in $seed.Keys){ if(Ensure $k $seed[$k]){ $changed=$true } }
        if($DryRun -or -not $changed){ Say "No file changes needed."; exit 0 }

        git fetch origin | Out-Null
        try { git switch -c $Branch 2>$null | Out-Null } catch { git switch $Branch 2>$null | Out-Null }
        git add .
        git commit -m "docs: seed CC v0.1 (canon/cc/bpoe/do) [idempotent]" | Out-Null
        git push -u origin $Branch | Out-Null
        $pr = gh pr create --fill --base main --head $Branch
        Say "PR opened: $pr"