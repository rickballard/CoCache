param(
  [string]$Topic = "",
  [string]$HarvestRoot = "private/bpoe/harvest",
  [string[]]$Globs = @("*.md","*.mdx","*.markdown","*.json","*.yml","*.yaml","*.ts","*.tsx","*.js","*.jsx"),
  [string]$Config = ".bpoe/priorart.json"
)

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = (Resolve-Path "$here\..\..").Path

# Load JSON config (topics/excludes/include_harvest)
$cfg = $null
if(Test-Path (Join-Path $repoRoot $Config)){
  try { $cfg = Get-Content (Join-Path $repoRoot $Config) -Raw | ConvertFrom-Json } catch { $cfg = $null }
}
if(-not $cfg){ $cfg = [pscustomobject]@{ topics=@(); excludes=@(); include_harvest=$true } }

$topics = @()
if($Topic){ $topics += $Topic }
$topics += @($cfg.topics) | Where-Object { $_ } | Select-Object -Unique
if(-not $topics){ Write-Host "No topics provided/found. Pass -Topic or configure .bpoe/priorart.json"; exit 0 }

# Gather candidate files (current repo)
$files = foreach($g in $Globs){
  Get-ChildItem -Path $repoRoot -Recurse -File -Filter $g -ErrorAction SilentlyContinue
} | Where-Object {
  $rel = $_.FullName.Substring($repoRoot.Length).TrimStart('\','/')
  -not ($cfg.excludes | ForEach-Object { $rel -like $_ })
}

# Scan for topics
$hits = New-Object System.Collections.Generic.List[object]
foreach($f in $files){
  $match = Select-String -Path $f.FullName -Pattern $topics -SimpleMatch -CaseSensitive:$false -ErrorAction SilentlyContinue
  foreach($m in $match){
    $hits.Add([pscustomobject]@{
      file = ($f.FullName.Substring($repoRoot.Length).TrimStart('\','/')).Replace('\','/')
      line = $m.LineNumber
      text = $m.Line.Trim()
      topic = ($topics | Where-Object { $m.Line -match [regex]::Escape($_) } | Select-Object -First 1)
      source = "repo"
    })
  }
}

# Optionally include harvest inventories (JSON rows previously written by CoCache harvests)
if($cfg.include_harvest -ne $false){
  $hDir = Join-Path $repoRoot $HarvestRoot
  if(Test-Path $hDir){
    $inv = Get-ChildItem -Path $hDir -Recurse -File -Filter "inventory.*.json" -ErrorAction SilentlyContinue
    foreach($j in $inv){
      try{
$json = @(); try { $json = Get-Content $j.FullName -Raw | ConvertFrom-Json } catch {}
        foreach($row in $json){
          if([string]::IsNullOrWhiteSpace($Topic) -or ($row.line -match [regex]::Escape($Topic))){
            $hits.Add([pscustomobject]@{
              file   = "HARVEST://"+($j.FullName.Substring($repoRoot.Length).TrimStart('\','/')).Replace('\','/')
              line   = $row.line_no
              text   = $row.line
              topic  = $Topic
              source = "harvest"
            })
          }
        }
      }catch{}
    }
  }
}

# Print results
$hitsArr = $hits.ToArray()
if($hitsArr.Count -eq 0){
  Write-Host "::warning::No prior-art hits for topic(s): $($topics -join ', ')"
  exit 0
}
Write-Host "== Prior-art hits =="
$hitsArr | Sort-Object file,line | ForEach-Object { "{0}:{1} — {2}" -f $_.file, $_.line, $_.text }

# Require explicit ACK in PR body when NEW/CHANGED files appear to be topic files
$ackNeeded = $false; $newTopicFiles = @()
try{
  $changed = git diff --name-only origin/main...HEAD 2>$null
  foreach($c in $changed){ if($topics | Where-Object { $c -match $_ }){ $newTopicFiles += $c } }
}catch{}
if($newTopicFiles.Count -gt 0){ $ackNeeded = $true }

# GH Actions will pass PRIORART_ACK via env; local PRs won't have it—only enforce when running in CI
$inCI = [bool]$env:GITHUB_ACTIONS
$overrideLabel = $env:PRIORART_ACK
$eventBody = ""
if($env:GITHUB_EVENT_PATH -and (Test-Path $env:GITHUB_EVENT_PATH)){
  try{ $eventBody = (Get-Content $env:GITHUB_EVENT_PATH -Raw | ConvertFrom-Json).pull_request.body }catch{}
}
$prHasAck = ($eventBody -match "(?i)PRIORART_ACK") -or ($overrideLabel -eq "I_KNOW")

if($inCI -and $ackNeeded -and -not $prHasAck){
  Write-Error "Prior-art found but PR adds/changes topic files without acknowledgement. Add to PR body: 'PRIORART_ACK: evolving canonical X, tombstoning Y' and reference at least one hit above."
  exit 2
}

Write-Host "Prior-art check: OK"

