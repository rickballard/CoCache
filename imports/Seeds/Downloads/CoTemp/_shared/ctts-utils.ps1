# --- fallback (safe pass-through) ---
if (-not (Get-Command Convert-TranscriptToScript -ErrorAction SilentlyContinue)) {
  function Global:Convert-TranscriptToScript {
    param([string[]]$Text)
    if (-not $Text) { return "" }
    ($Text -join "`n")
  }
}
# ctts-utils.ps1 â€” transcriptâ†’script helpers (shared)
if (-not (Get-Command Convert-TranscriptToScript -ErrorAction SilentlyContinue)) {
  $guess = Join-Path $HOME 'Tools\Convert-TranscriptToScript.ps1'
  if (Test-Path $guess) { . $guess }
}
function ctts {
  [CmdletBinding()]
  param([switch]$FromClipboard,[Parameter(ValueFromPipeline,Position=0)][string[]]$Text)
  begin{ $buf=[System.Collections.Generic.List[string]]::new() }
  process{ if($Text){$buf.AddRange($Text)} elseif($null-ne $_){$buf.Add($_)} }
  end{
    if($FromClipboard -and $buf.Count -eq 0){ $buf.AddRange((Get-Clipboard -Raw) -split "`r?`n") }
    $raw = Convert-TranscriptToScript -Text $buf.ToArray()
    if($null -eq $raw){return}
    if($raw -is [string]){return $raw}
    if($raw -is [string[]]){return ($raw -join "`n")}
    if($raw -is [hashtable]){
      foreach($k in 'Script','Text','Content','Output'){ if($raw[$k]){return $raw[$k]} }
      return ($raw | Out-String).TrimEnd()
    }
    ($raw | Out-String).TrimEnd()
  }
}
function ctts-save { param([Parameter(Mandatory,Position=0)][string]$Path,[switch]$LF,[string]$Encoding='utf8NoBOM',[switch]$Append)
  $txt = ctts -FromClipboard; if($LF){$txt=$txt -replace "`r?`n","`n"}
  $full = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
  $dir  = Split-Path -Path $full -Parent
  if($dir -and -not (Test-Path -LiteralPath $dir)){ New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  if($($PSVersionTable.PSVersion).Major -ge 6){
    if($Append){Add-Content -LiteralPath $full -Value $txt -Encoding $Encoding}
    else{Set-Content -LiteralPath $full -Value $txt -Encoding $Encoding}
    return
  }
  switch -regex ($Encoding.ToLowerInvariant()){
    '^utf8nobom$'{$enc=New-Object System.Text.UTF8Encoding($false)}
    '^utf8$'{$enc=New-Object System.Text.UTF8Encoding($true)}
    '^ascii$'{$enc=[Text.Encoding]::ASCII}
    '^unicode$'{$enc=[Text.Encoding]::Unicode}
    '^bigendianunicode$'{$enc=[Text.Encoding]::BigEndianUnicode}
    '^utf7$'{$enc=[Text.Encoding]::UTF7}
    '^utf32$'{$enc=[Text.Encoding]::UTF32}
    '^default$'{$enc=[Text.Encoding]::Default}
    '^oem$'{$enc=[Text.Encoding]::GetEncoding([Console]::OutputEncoding.CodePage)}
    default{$enc=New-Object System.Text.UTF8Encoding($false)}
  }
  [IO.File]::WriteAllText($full,$txt,$enc)
}
function Invoke-WithDots { param([Parameter(Mandatory)][scriptblock]$Script,[int]$EveryMs=300,[string]$Label="")
  $job=Start-Job $Script
  try{
    $sw=[Diagnostics.Stopwatch]::StartNew()
    if($Label){Write-Host -NoNewline "$Label "}
    while($job.State -eq 'Running'){Write-Host -NoNewline '.'; Start-Sleep -Milliseconds $EveryMs}
    Write-Host " $($sw.Elapsed.ToString('mm\:ss'))"
    Receive-Job $job
  } finally{ Remove-Job $job -Force -ErrorAction SilentlyContinue }
}
Set-Alias dots Invoke-WithDots
function clipfix { ctts -FromClipboard | Set-Clipboard }
Set-Alias cf clipfix
# --- fallback inserted by setup ---
if (-not (Get-Command Convert-TranscriptToScript -ErrorAction SilentlyContinue)) {
  function Convert-TranscriptToScript {
    param([string[]]$Text)
    if (-not $Text) { return "" }
    # Minimal: just join lines; ctts will return it as the script text
    return ($Text -join "
")
  }
}
# --- fallback inserted by setup (safe pass-through) ---
if (-not (Get-Command Convert-TranscriptToScript -ErrorAction SilentlyContinue)) {
  function Convert-TranscriptToScript {
    param([string[]]$Text)
    if (-not $Text) { return "" }
    # Minimal pass-through: join lines so ctts returns usable script text
    return ($Text -join "`n")
  }
}
# --- fallback inserted by setup (safe pass-through) ---
if (-not (Get-Command Convert-TranscriptToScript -ErrorAction SilentlyContinue)) {
  function Convert-TranscriptToScript {
    param([string[]]$Text)
    if (-not $Text) { return "" }
    # Minimal pass-through: join lines so ctts returns usable script text
    return ($Text -join "`n")
  }
}


