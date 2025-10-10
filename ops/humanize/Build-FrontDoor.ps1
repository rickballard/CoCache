param(
  [Parameter(Mandatory)][string]$RepoPath,
  [string]$Title = (Split-Path $RepoPath -Leaf),
  [string]$Flavor = "Human-friendly overview + Megascroll"
)
$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest

function P($s){ if($s){ $s.Trim().TrimEnd()} }

$repo = Resolve-Path $RepoPath
Set-Location $repo

# Collect human content candidates
$sections = @()
$add = {
  param($name,$path,$hint)
  if(Test-Path $path){
    $rel = (Resolve-Path $path).Path.Replace((Resolve-Path .).Path+'\','')
    $sections += "- [$name]($rel) — $hint"
  }
}
$add.Invoke("Megascroll","docs\cc\scroll\README.md","Single-file canon scroll (read-only)")
$add.Invoke("Canon Index","docs\canon\README.md","Curated canon starting point")
$add.Invoke("Insights","docs\insights\README.md","Narratives, essays, idea-cards")
$add.Invoke("Advisories","docs\advicebombs\README.md","Decision helpers / BPOE")
$add.Invoke("Roadmap","docs\roadmap\README.md","Where this is going")
$add.Invoke("Changelog","CHANGELOG.md","What changed recently")

# Slim badges (adjust as needed)
$ownerRepo = (git remote get-url origin) -replace '.*github.com[/:]','' -replace '\.git$',''
$badges = @(
  "[![Open issues](https://img.shields.io/github/issues/$ownerRepo)](../../issues)",
  "[![PRs](https://img.shields.io/github/issues-pr/$ownerRepo)](../../pulls)",
  "[![License](https://img.shields.io/github/license/$ownerRepo)](./LICENSE)"
) -join " "

# Quick start (links for humans; ops tucked lower)
$quick = @"
### Quick start
- **Read**: the Megascroll (single-page canon) if present.
- **Skim**: the Canon Index to jump to what you need.
- **Contribute**: open a Discussion, then a small PR.
"@

# Developer/ops section (folded)
$ops = @"
<details>
<summary><b>For maintainers / ops</b></summary>

- Scripts live under `ops/` and `.github/`.
- Seed-kit: see CoCache → `ops/kits/Build-CoSuiteSeedKit.ps1`.

</details>
"@

$explore = if($sections){ $sections -join "`n" } else { "_(Content map will grow as repo fills out.)_" }

$hero = if(Test-Path "branding\logo.svg"){ "![logo](branding/logo.svg)" } else { "" }

$readme = @"
# $Title

$hero

$badges

$Flavor

$quick

## Explore
$explore

$ops
"@

Set-Content -Path "README.md" -Value $readme -Encoding UTF8
Write-Host "==> DONE: FrontDoor updated for $Title" -ForegroundColor Green
