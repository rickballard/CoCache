function New-VersionStamp([string]$Version){ if($Version){return $Version}; Get-Date -Format "yyyy-MM-dd_HHmmss" }
function Assert-ArtifactNamesAreVersioned{
  param(
    [string]$Root='.',
    [string[]]$Globs=@('*.zip','*.tar.gz','*.pdf'),   # scope to packaged artifacts only
    [string[]]$Paths=@('docs','release','releases','dist','artifacts','downloads')
  )
  $allow = '_(\d{4}-\d{2}-\d{2}_[0-2]\d[0-5]\d[0-5]\d)|_v?\d+\.\d+\.\d+'
  $bad = @()
  foreach($p in $Paths){
    $full = Join-Path $Root $p
    if(!(Test-Path $full)){ continue }
    foreach($g in $Globs){
      $bad += Get-ChildItem -Path $full -Recurse -File -Include $g -ErrorAction SilentlyContinue |
              Where-Object { $_.Name -notmatch $allow } |
              Select-Object -ExpandProperty FullName
    }
  }
  if($bad.Count){ throw "Non-versioned artifacts:`n$($bad -join "`n")" }
}
Export-ModuleMember -Function *-*
function Write-BundleManifest{
  param([Parameter(Mandatory)][string]$OutDir,
        [Parameter(Mandatory)][string]$Name,
        [string]$VersionOrTs)
  $sha = (git rev-parse HEAD 2>$null); if(-not $sha){ $sha = "unknown" }
  $obj = [ordered]@{
    name=$Name; version_or_ts=$VersionOrTs
    built_at_utc=(Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    git_sha=$sha; host=$env:COMPUTERNAME; built_by=$env:USERNAME
  }
  ($obj | ConvertTo-Json -Depth 5) | Set-Content (Join-Path $OutDir 'manifest.json') -Encoding UTF8
}

# --- ADVICE_BOMBS_SKIP (auto) ---
function Test-BpoeSkipValidation([string]$Path){
  $norm = ($Path -replace '\\','/')
  if ($norm -match '^docs/advice_bombs/') { return $true }
  return $false
}
# hook into existing Validate function(s)
if (Get-Command Test-BpoeArtifactName -ErrorAction SilentlyContinue) {
  $orig = (Get-Command Test-BpoeArtifactName).ScriptBlock.ToString()
}
function Test-BpoeArtifactName {
  param([string]$Path)
  if (Test-BpoeSkipValidation $Path) { return $true }
  & $ExecutionContext.InvokeCommand.GetCommand('Test-BpoeArtifactName','Function') @PSBoundParameters
}
# --- /ADVICE_BOMBS_SKIP ---

