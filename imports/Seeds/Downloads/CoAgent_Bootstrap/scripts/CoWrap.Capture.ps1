. "C:\Users\Chris\Downloads\CoAgent_Bootstrap\scripts\Common.ps1"param(
  [Parameter(Mandatory=$true)][string[]]$RepoPaths,
  [string]$OutDir = "$HOME\Downloads\CoTemp\logs",
  [int]$MaxCommits = 30
)
Set-StrictMode -Version Latest; $ErrorActionPreference = 'Stop'

# Ensure OutDir exists and is a fully-qualified path
$OutDir = [System.IO.Path]::GetFullPath($OutDir)
[System.IO.Directory]::CreateDirectory($OutDir) | Out-Null

# Safe timestamp for filenames (no ":")
$stampFile = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd_HHmmssZ")
$summaryPath = Join-Path $OutDir ("CoWrap_Snapshot_" + $stampFile + ".md")

function SanitizeName([string]$name) {
  if (-not $name) { return "unknown" }
  # Allow only letters, digits, dot, underscore, hyphen; collapse runs; trim trailing dot/space
  $r = ($name -replace '[^A-Za-z0-9._-]', '-')
  $r = ($r -replace '-{2,}', '-').Trim().TrimEnd('.',' ')
  if ([string]::IsNullOrWhiteSpace($r)) { return "unknown" }
  return $r
}

$sb = New-Object System.Text.StringBuilder
$null = $sb.AppendLine("# CoWrap Snapshot")
$null = $sb.AppendLine("UTC: " + (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss 'Z'"))
$null = $sb.AppendLine("OutDir: " + $OutDir)
$null = $sb.AppendLine("")

foreach ($repo in $RepoPaths) {
  try {
    $null = $sb.AppendLine("## Repo: " + $repo)
    if (-not (Test-Path $repo)) {
      $null = $sb.AppendLine("WARN: path not found.")
      $null = $sb.AppendLine("")
      continue
    }

    Push-Location $repo
    try {
      $nameRaw = Split-Path -Leaf $repo
      $name = SanitizeName $nameRaw
      $branch = (git rev-parse --abbrev-ref HEAD) 2>$null
      $status = (git status -sb) 2>$null
      $log    = (git log -n $MaxCommits --oneline --decorate --graph) 2>$null

      $null = $sb.AppendLine("Name: " + $name)
      $null = $sb.AppendLine("Branch: " + $branch)
      $null = $sb.AppendLine("")
      $null = $sb.AppendLine("### Status")
      if ($status) { $null = $sb.AppendLine($status) } else { $null = $sb.AppendLine("(no status)") }
      $null = $sb.AppendLine("")
      $null = $sb.AppendLine("### Recent Commits")
      if ($log) { $null = $sb.AppendLine($log) } else { $null = $sb.AppendLine("(no commits)") }
      $null = $sb.AppendLine("")

    } finally { Pop-Location }
  } catch {
    $null = $sb.AppendLine("ERROR: " + $_.Exception.Message)
    $null = $sb.AppendLine("")
  }
}

try {
  [IO.File]::WriteAllText($summaryPath, $sb.ToString(), [Text.Encoding]::UTF8)
  Write-Host ("Snapshot complete: " + $summaryPath)
} catch {
  Write-Error ("Failed to write snapshot to: " + $summaryPath + " — " + $_.Exception.Message)
}

