\
function Get-CoProfilePath {
  param([string]$Root = $env:USERPROFILE)
  $candidates = @(
    Join-Path $Root 'Documents\CoProfile\coprofile.yaml',
    Join-Path $Root 'Documents\CoProfile\coprofile.json',
    Join-Path $Root 'Downloads\CoProfile\coprofile.yaml',
    Join-Path $Root 'Downloads\CoProfile\coprofile.json'
  )
  foreach($p in $candidates){ if(Test-Path $p){ return $p } }
  return $null
}

function Get-CoProfile {
  param([string]$Path = (Get-CoProfilePath))
  if(-not $Path){ return $null }
  $ext = [IO.Path]::GetExtension($Path).ToLowerInvariant()
  $raw = Get-Content -Raw -LiteralPath $Path
  if($ext -eq '.yaml' -or $ext -eq '.yml'){
    if(Get-Command ConvertFrom-Yaml -ErrorAction SilentlyContinue){
      return $raw | ConvertFrom-Yaml
    } else {
      # crude YAML fallback: assume it's also valid JSON5-ish or export a JSON alongside
      $jsonPath = [IO.Path]::ChangeExtension($Path, '.json')
      if(Test-Path $jsonPath){ return Get-Content -Raw $jsonPath | ConvertFrom-Json }
      Write-Warning "No ConvertFrom-Yaml; looked for $jsonPath as fallback."
      return $null
    }
  } else {
    return $raw | ConvertFrom-Json
  }
}

function Show-CoProfileSummary {
  $p = Get-CoProfile
  if(-not $p){ Write-Host "No CoProfile found." -ForegroundColor Yellow; return }
  Write-Host "== CoProfile summary ==" -ForegroundColor Cyan
  "{0}  ({1})" -f $p.user.display_name, $p.user.handle
  "BPOE: DOs={0}, Inbox={1}, Tag={2}, Session={3}" -f $p.bpoe.use_do_files, $p.bpoe.do_inbox, $p.bpoe.default_tag, $p.bpoe.default_session
  "Style: numbered={0}, 2-spaces={1}, buddy={2}" -f $p.style.prefer_numbered_steps, $p.style.two_spaces_after_periods, $p.style.buddy_mode
}

Export-ModuleMember -Function Get-CoProfilePath,Get-CoProfile,Show-CoProfileSummary
