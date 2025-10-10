# ctts-utils.ps1 — transcript→script helpers

# If Convert-TranscriptToScript isn’t loaded, try common location
if (-not (Get-Command Convert-TranscriptToScript -ErrorAction SilentlyContinue)) {
  $guess = Join-Path $HOME 'Tools\Convert-TranscriptToScript.ps1'
  if (Test-Path $guess) { . $guess }
}

function ctts {
  [CmdletBinding()]
  param(
    [switch]$FromClipboard,
    [Parameter(ValueFromPipeline, Position=0)]
    [string[]]$Text
  )
  begin { $buf = New-Object System.Collections.Generic.List[string] }
  process {
    if ($Text) { $buf.AddRange($Text) }
    elseif ($null -ne $_) { $buf.Add($_) }
  }
  end {
    if ($FromClipboard -and $buf.Count -eq 0) { $buf.AddRange((Get-Clipboard -Raw) -split "`r?`n") }
    $raw = Convert-TranscriptToScript -Text $buf.ToArray()
    if ($null -eq $raw) { return }
    if ($raw -is [string])   { return $raw }
    if ($raw -is [string[]]) { return ($raw -join "`n") }
    if ($raw -is [hashtable]) {
      foreach($k in 'Script','Text','Content','Output'){ if ($raw[$k]) { return $raw[$k] } }
      return ($raw | Out-String).TrimEnd()
    }
    ($raw | Out-String).TrimEnd()
  }
}

function ctts-save {
  param(
    [Parameter(Mandatory, Position=0)][string]$Path,
    [switch]$LF,
    [string]$Encoding = 'utf8NoBOM',  # utf8NoBOM|utf8|ascii|unicode|utf7|utf32|bigendianunicode|default|oem
    [switch]$Append
  )

  $txt = ctts -FromClipboard
  if ($LF) { $txt = $txt -replace "`r?`n","`n" }

  # Resolve relative to PowerShell location (not .NET CurrentDirectory)
  $full = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
  $dir  = Split-Path -Path $full -Parent
  if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }

  if ($PSVersionTable.PSVersion.Major -ge 6) {
    if ($Append) { Add-Content -LiteralPath $full -Value $txt -Encoding $Encoding }
    else         { Set-Content -LiteralPath $full -Value $txt -Encoding $Encoding }
    return
  }

  # PS 5.1 encodings
  switch -regex ($Encoding.ToLowerInvariant()) {
    '^utf8nobom$'        { $enc = New-Object System.Text.UTF8Encoding($false) }
    '^utf8$'             { $enc = New-Object System.Text.UTF8Encoding($true)  }
    '^ascii$'            { $enc = [System.Text.Encoding]::ASCII }
    '^unicode$'          { $enc = [System.Text.Encoding]::Unicode }
    '^bigendianunicode$' { $enc = [System.Text.Encoding]::BigEndianUnicode }
    '^utf7$'             { $enc = [System.Text.Encoding]::UTF7 }
    '^utf32$'            { $enc = [System.Text.Encoding]::UTF32 }
    '^default$'          { $enc = [System.Text.Encoding]::Default }
    '^oem$'              { $enc = [System.Text.Encoding]::GetEncoding([Console]::OutputEncoding.CodePage) }
    default              { $enc = New-Object System.Text.UTF8Encoding($false) }
  }
  if ($Append) { [IO.File]::AppendAllText($full, $txt + [Environment]::NewLine, $enc) }
  else         { [IO.File]::WriteAllText($full, $txt, $enc) }
}

function Invoke-WithDots {
  param([Parameter(Mandatory)][scriptblock]$Script,[int]$EveryMs=300,[string]$Label="")
  $job = Start-Job $Script
  try {
    $sw = [Diagnostics.Stopwatch]::StartNew()
    if ($Label) { Write-Host -NoNewline "$Label " }
    while ($job.State -eq 'Running') { Write-Host -NoNewline '.'; Start-Sleep -Milliseconds $EveryMs }
    Write-Host " $($sw.Elapsed.ToString('mm\:ss'))"
    Receive-Job $job
  } finally { Remove-Job $job -Force -ErrorAction SilentlyContinue }
}
Set-Alias dots Invoke-WithDots

function clipfix { ctts -FromClipboard | Set-Clipboard }
Set-Alias cf clipfix
