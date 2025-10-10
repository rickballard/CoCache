
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-Timestamp { Get-Date -Format yyyyMMdd_HHmm }

function Ensure-Repo {
  param([string]$RepoRoot = "$HOME\Documents\GitHub\CoCivium")
  if (-not (Test-Path $RepoRoot)) { throw "RepoRoot not found: $RepoRoot" }
  Set-Location $RepoRoot
  $null = git rev-parse --is-inside-work-tree 2>$null
  if ($LASTEXITCODE -ne 0) { throw "Not a git repo: $RepoRoot" }
  return $RepoRoot
}

function Write-IfChanged {
  param([string]$Path,[string]$Content)
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
  if (Test-Path $Path) {
    $existing = Get-Content $Path -Raw
    if ($existing -eq $Content) { return $false }
  }
  Set-Content $Path $Content -Encoding UTF8
  return $true
}

function Assert-GH {
  $null = gh auth status 2>$null
  if ($LASTEXITCODE -ne 0) { throw "GitHub CLI not authenticated. Run: gh auth login" }
}

function Safe-CommitPush {
  param([string]$Message, [switch]$NoPush)
  $null = git add -A
  $status = git status --porcelain
  if ($status) {
    git commit -m $Message | Out-Null
    if (-not $NoPush) { git push -u origin HEAD | Out-Null }
    return $true
  } else {
    Write-Host "Nothing to commit."
    return $false
  }
}

param([string]$RepoRoot = "$HOME\Documents\GitHub\CoCivium")

Ensure-Repo -RepoRoot $RepoRoot | Out-Null
Assert-GH

$labels = @(
  @{n="ops";      c="BFD4F2"; d="Operational chores & glue"},
  @{n="ci";       c="D4C5F9"; d="Checks, actions, automation"},
  @{n="wiki";     c="FBE090"; d="GitHub Wiki pages & flow"},
  @{n="content";  c="C2F0C2"; d="Docs & writing"},
  @{n="funding";  c="F9D0C4"; d="Funding & donations"}
)
foreach($L in $labels){ gh label create $L.n --color $L.c --description $L.d 2>$null }

$issues = @(
@{
  t="Instruction paste reliability & chunking (meta)";
  l=@("ops","ci");
  b=@'
We’ve had long, interleaved instruction drops cause PowerShell parser errors.

**Standards**
- All helper snippets are *paste-safe* ONEBLOCKs (no `>>`, no REPL prompts).
- Use PowerShell here-strings (`@' … '@`) to write multi-line files.
- Avoid `$home` variable name (collides with `$HOME`).
- Include a Preflight block (repo/branch/gh auth) in big sets.

**Tasks**
- Add a “Copy/Paste Safety” section to docs/STYLE.md.
- Ship `scripts/paste_hardener.ps1` (write + verify size > 100 bytes).
- Record common failure signatures and fixes in notes/triage_playbook.md.
'@
},
@{
  t="CI: guards for README assets & temporary funding links";
  l=@("ci","content");
  b=@'
Add checks:
- Verify `assets/img/consenti-scroll.png` exists when README references it.
- Keep `.lychee.toml` excludes for temporary endpoints (OpenCollective/DogsnHomes).
- Fail with clear remediation messages.
'@
},
@{
  t="Wiki scaffolding helper & sync map";
  l=@("wiki","ops");
  b=@'
Script to (re)seed wiki pages safely:
- Enable wiki, clone wiki repo to temp, write Home/Getting-Started/Decision-Flow/Roles/Domains/FAQ/Links.
- Map each wiki page to canonical doc (Vision, Consenti, Domains index).
- Avoid `$home` as a variable name; use `$homePageContent`.
'@
}
)

foreach($i in $issues){
  $args = @('-t', $i.t, '-b', $i.b)
  foreach($lab in $i.l){ $args += @('-l', $lab) }
  gh issue create @args
}
