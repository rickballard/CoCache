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
