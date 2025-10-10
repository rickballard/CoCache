param(
  [string]$ListPath = "$(Resolve-Path ./ops/CoSuite/repos.txt)",
  [switch]$StopOnError
)
$ErrorActionPreference='Stop'
function Has($n){ (Get-Command $n -ErrorAction SilentlyContinue) -ne $null }
if (-not (Has gh)) { Write-Host "WARNING: gh not installed; will print PR URLs instead of auto-merging." -ForegroundColor Yellow }

$seedUrl = "https://raw.githubusercontent.com/rickballard/CoCache/main/HANDOVER/CoWrap-20251010-132935/ops/snippets/seed-finish.ps1"
$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path; $logPath = Join-Path $Root "docs\bpoe\SEED_RUNS.md"
New-Item -ItemType Directory -Force -Path (Split-Path $logPath) | Out-Null

$items = Get-Content $ListPath | Where-Object { $_ -and $_ -notmatch '^\s*#' } | ForEach-Object { $_.Trim() }
$stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

foreach ($id in $items) {
  try {
    $owner,$name = $id.Split('/',2)
    if (-not $name) { throw "Bad repo id: $id (use owner/name)" }
    $local = Join-Path $HOME "Documents\GitHub\$name"
    if (!(Test-Path $local)) {
      git clone "https://github.com/$owner/$name" $local | Out-Null
    }
    # Run the published finisher in that repo
    $script = Invoke-RestMethod -UseBasicParsing $seedUrl
    $sb = [scriptblock]::Create($script)
    & $sb -Repo $local -VerboseOut
    $ok = $true
  } catch {
    $ok = $false
    $err = $_.Exception.Message
    Write-Host ("FAIL {0} — {1}" -f $id, $err) -ForegroundColor Red
    if ($StopOnError) { throw }
  } finally {
    $line = if ($ok) { "- $stamp — **OK** — $id merged to main" } else { "- $stamp — **FAIL** — $id — $err" }
    Add-Content $logPath $line
  }
}

git add $logPath
git commit -m "CoSuite seed runs logged $stamp" | Out-Null
git push | Out-Null


