param(
  [string]$RepoRoot = ".",
  [string]$Stamp    = (Get-Date -Format "yyMMdd")
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$root     = (Resolve-Path $RepoRoot).Path
$trustDir = Join-Path $root 'docs\bpoe\trust'
$allow    = Join-Path $trustDir 'allow.txt'
$warn     = Join-Path $trustDir 'warn.txt'
$deny     = Join-Path $trustDir 'deny.txt'
$indexDir = Join-Path $root 'index'
$icDir    = Join-Path $root ("intake\ideacards\session_{0}" -f $Stamp)
$cwDir    = Join-Path $root ("intake\cowraps\session_{0}"   -f $Stamp)

$null = New-Item -ItemType Directory -Force -Path $indexDir -ErrorAction SilentlyContinue

function Load-List($path){
  if (-not (Test-Path $path)) { return @() }
  Get-Content $path -EA SilentlyContinue |
    Where-Object { $_ -match '\S' -and -not $_.Trim().StartsWith('#') } |
    ForEach-Object { $_.Trim().ToLowerInvariant() } |
    Where-Object { $_ -ne "" } | Select-Object -Unique
}

$AllowSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$WarnSet  = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$DenySet  = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
(Load-List $allow) | ForEach-Object { $AllowSet.Add($_) | Out-Null }
(Load-List $warn)  | ForEach-Object { $WarnSet.Add($_)  | Out-Null }
(Load-List $deny)  | ForEach-Object { $DenySet.Add($_)  | Out-Null }

# find http(s) links in session markdown files
$files = @(Get-ChildItem $icDir,$cwDir -Filter *.md -File -Recurse -EA SilentlyContinue)
$links = New-Object System.Collections.Generic.List[object]

$rx = '(https?://[^\s\)\]>"]+)'  # catch bare URLs and inside () of [text](url)
foreach($f in $files){
  try{
    $text = Get-Content $f.FullName -Raw -EA Stop
    [System.Text.RegularExpressions.Regex]::Matches($text, $rx) | ForEach-Object {
      $url = $_.Value
      try {
        $u = [Uri]$url
        if ($u.Host) {
          $links.Add([pscustomobject]@{ file=$f.FullName; url=$url; host=$u.Host.ToLowerInvariant() })
        }
      } catch {}
    }
  } catch {}
}

# classify
$flags = New-Object System.Collections.Generic.List[object]
foreach($L in $links | Select-Object -Unique url,host,file){
  $host = $L.host
  $level = 'OK'
  $reason = ''
  if ($DenySet.Contains($host)) { $level='DENY'; $reason='domain in deny.txt' }
  elseif ($WarnSet.Contains($host)) { $level='WARN'; $reason='domain in warn.txt' }
  elseif (-not $AllowSet.Contains($host)) { $level='WARN'; $reason='domain unknown (not in allow/warn/deny)' }

  if ($level -ne 'OK') {
    $flags.Add([pscustomobject]@{
      file   = $L.file.Substring($root.Length).TrimStart('\','/')
      url    = $L.url
      domain = $host
      level  = $level
      reason = $reason
    })
  }
}

$summaryLevel = if ($flags.Count -eq 0) { 'OK' } elseif ($flags | Where-Object {$_.level -eq 'DENY'}) { 'DENY' } else { 'WARN' }

# write artifacts
$trustJson = Join-Path $indexDir 'TRUST_FLAGS.json'
$trustMd   = Join-Path $indexDir 'TRUST_STATUS.md'
$payload = @{
  ts      = (Get-Date).ToString('o')
  session = $Stamp
  level   = $summaryLevel
  count   = $flags.Count
  flags   = $flags
}
$payload | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $trustJson

$lines = @()
$lines += "# Trust Status"
$lines += ""
$lines += "**Overall:** $summaryLevel  •  **Flags:** $($flags.Count)"
$lines += ""
foreach($f in $flags){
  $lines += "- `$( $f.level )` **$($f.domain)** — $($f.reason)  (`$($f.file)`) → <$($f.url)>"
}
if ($flags.Count -eq 0) { $lines += "- No questionable sources detected for this session." }
$lines -join "`n" | Set-Content -Encoding UTF8 $trustMd

Write-Host ("Trust: {0} • flags {1}" -f $summaryLevel, $flags.Count)
