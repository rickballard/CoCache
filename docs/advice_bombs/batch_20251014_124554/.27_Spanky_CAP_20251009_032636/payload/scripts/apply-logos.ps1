Param(
  [string]$Staged = ("{0}\logos\staged" -f $env:WRAP_ROOT),
  [string]$OutDir = ("{0}\assets\img\exemplars" -f $env:REPO_ROOT),
  [switch]$CommitAndPush = $true
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
function Have($n){ $null -ne (Get-Command $n -ErrorAction SilentlyContinue) }
$magick = Have 'magick'
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Force -Path $OutDir | Out-Null }

Write-Host "apply-logos: staged=$Staged out=$OutDir magick=$magick"
$exts = @('.svg','.png','.jpg','.jpeg','.webp','.pdf')
$files = Get-ChildItem -Path $Staged -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $exts -contains $_.Extension.ToLower() }
Write-Host ("apply-logos: found {0} staged files" -f $files.Count)

$processed=0; $failed=0; $made=@()
foreach($f in $files){
  $slug = ($f.BaseName -replace '[^a-zA-Z0-9]+','-').ToLower().Trim('-')
  if (-not $slug) { continue }
  $out  = Join-Path $OutDir ($slug + '.png')

  if ($magick) {
    $args = @()
    if ($f.Extension -match 'pdf') { $args += @('-density','256') }
    $args += @(
      $f.FullName,
      '-alpha','on',
      '-fuzz','2%','-trim','+repage',
      '-resize','148x148',
      '-gravity','center','-background','none','-extent','160x160',
      '-strip',
      'PNG32:' + $out
    )
    try{
      & magick @args 2>$null
      if (Test-Path $out){ $made += (Split-Path $out -Leaf); $processed++ }
      else { $failed++; Write-Warning "No output written: $($f.Name)" }
    } catch { $failed++; Write-Warning "magick failed: $($f.Name) :: $($_.Exception.Message)" }
  }
}

$manifestPath1 = Join-Path $OutDir 'manifest.json'
$manifestPath2 = Join-Path $OutDir '_manifest.json'
@{ generated=(Get-Date).ToString('o'); files=$made } | ConvertTo-Json | Tee-Object -FilePath $manifestPath1 -Encoding UTF8 | Set-Content -Path $manifestPath2 -Encoding UTF8

Write-Host "apply-logos: processed=$processed failed=$failed wrote=$($made.Count)"
if($CommitAndPush){
  Push-Location $env:REPO_ROOT
  try{
    git add --all assets/img/exemplars
    if((git status --porcelain).Trim()){ git commit -m "assets: reconvert logos (trim+pad 160x160) + refresh manifests"; git push origin HEAD:main }
    else { Write-Host "apply-logos: no changes to commit." }
  } finally { Pop-Location }
}

