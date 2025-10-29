param(
  [string]$Topic = "",
  [string]$HarvestRoot = "private/bpoe/harvest",
  [string[]]$Globs = @("*.md","*.mdx","*.markdown","*.json","*.yml","*.yaml","*.ts","*.tsx","*.js","*.jsx"),
  [string]$Config = ".bpoe/priorart.json"
)

$ErrorActionPreference = "Stop"
$here     = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = (Resolve-Path "$here\..\..").Path

# Load JSON config (topics/excludes/include_harvest)
$cfg = $null
$cfgPath = Join-Path $repoRoot $Config
if (Test-Path $cfgPath) {
  try { $cfg = Get-Content $cfgPath -Raw | ConvertFrom-Json } catch { $cfg = $null }
}
if (-not $cfg) { $cfg = [pscustomobject]@{ topics=@(); excludes=@(); include_harvest=$true } }

# Topics
$topics = @()
if ($Topic) { $topics += $Topic }
$topics += @($cfg.topics) | Where-Object { $_ } | Select-Object -Unique
if (-not $topics -or $topics.Count -eq 0) {
  Write-Host "::notice::No topics provided/found. Pass -Topic or configure .bpoe/priorart.json"
  exit 0
}

# Gather candidate files (no empty-pipeline trap)
$allFiles = @()
foreach ($g in $Globs) {
  try {
    $gci = Get-ChildItem -Path $repoRoot -Recurse -File -Filter $g -ErrorAction SilentlyContinue
    if ($gci) { $allFiles += $gci }
  } catch {}
}

# Null-safe excludes (exact like semantics)
$excludes = @()
if ($cfg.PSObject.Properties.Match('excludes').Count -gt 0 -and $cfg.excludes) { $excludes = @($cfg.excludes) }

$files = foreach ($f in $allFiles) {
  $rel = $f.FullName.Substring($repoRoot.Length).TrimStart('\','/')
  $skip = $false
  foreach ($pat in $excludes) { if ($rel -like $pat) { $skip = $true; break } }
  if (-not $skip) { $f }
}

# Scan for topics
$hits = New-Object System.Collections.Generic.List[object]
foreach ($f in $files) {
  try {
    $match = Select-String -Path $f.FullName -Pattern $topics -SimpleMatch -CaseSensitive:$false -ErrorAction SilentlyContinue
    foreach ($m in $match) {
      $hits.Add([pscustomobject]@{
        file   = ($f.FullName.Substring($repoRoot.Length).TrimStart('\','/')).Replace('\','/')
        line   = $m.LineNumber
        text   = $m.Line.Trim()
        topic  = ($topics | Where-Object { $m.Line -match [regex]::Escape($_) } | Select-Object -First 1)
        source = "repo"
      })
    }
  } catch {}
}

# Optionally include prior harvest inventories (machine-written JSON rows)
if ($cfg.include_harvest -ne $false) {
  $hDir = Join-Path $repoRoot $HarvestRoot
  if (Test-Path $hDir) {
    $inv = Get-ChildItem -Path $hDir -Recurse -File -Filter "inventory.*.json" -ErrorAction SilentlyContinue
    foreach ($j in $inv) {
      try {
        $json = @(); try { $json = Get-Content $j.FullName -Raw | ConvertFrom-Json } catch {}
        foreach ($row in $json) {
          $lineTxt = $row.PSObject.Properties.Match('line').Count -gt 0 ? $row.line : ""
          $lineNo  = $row.PSObject.Properties.Match('line_no').Count -gt 0 ? $row.line_no : 0
          if ([string]::IsNullOrWhiteSpace($Topic) -or ($lineTxt -match [regex]::Escape($Topic))) {
            $hits.Add([pscustomobject]@{
              file   = "HARVEST://" + ($j.FullName.Substring($repoRoot.Length).TrimStart('\','/')).Replace('\','/')
              line   = $lineNo
              text   = $lineTxt
              topic  = $Topic
              source = "harvest"
            })
          }
        }
      } catch {}
    }
  }
}

# Print results (group for nicer CI logs)
$hitsArr = $hits.ToArray()
if ($hitsArr.Count -eq 0) {
  Write-Host "::warning::No prior-art hits for topic(s): $($topics -join ', ')"
} else {
  Write-Host "::group::Prior-art hits"
  $hitsArr | Sort-Object file,line | ForEach-Object { "{0}:{1} — {2}" -f $_.file, $_.line, $_.text }
  Write-Host "::endgroup::"
}

# Determine base ref for diffs (forks, dispatch, etc.)
$base = if ($env:GITHUB_BASE_REF) { $env:GITHUB_BASE_REF } else { "main" }
try { git fetch origin $base --depth=1 2>$null } catch {}

$changed = @()
try { $changed = (git diff --name-only ("origin/$base...HEAD")) -split "`n" | Where-Object { $_ } } catch {}

# Trigger ACK only when changed files *look* like topic files
$newTopicFiles = @()
foreach ($c in $changed) {
  foreach ($t in $topics) { if ($c -match [regex]::Escape($t)) { $newTopicFiles += $c; break } }
}

$ackNeeded = $newTopicFiles.Count -gt 0

# PR body/label ACK (only enforce in CI to allow local runs)
$inCI = [bool]$env:GITHUB_ACTIONS
$overrideLabel = $env:PRIORART_ACK
$eventBody = ""
if ($env:GITHUB_EVENT_PATH -and (Test-Path $env:GITHUB_EVENT_PATH)) {
  try { $eventBody = (Get-Content $env:GITHUB_EVENT_PATH -Raw | ConvertFrom-Json).pull_request.body } catch {}
}
$prHasAck = ($eventBody -match "(?i)PRIORART_ACK") -or ($overrideLabel -eq "I_KNOW")

if ($inCI -and $ackNeeded -and -not $prHasAck) {
  Write-Error "Prior-art found but PR adds/changes topic files without acknowledgement. Add: 'PRIORART_ACK: evolving canonical X, tombstoning Y' and reference at least one hit."
  exit 2
}

Write-Host "Prior-art check: OK"
exit 0