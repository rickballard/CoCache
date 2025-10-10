param(
  [string]$SrcRepo = "$HOME\Documents\GitHub\CoCivium",
  [string]$CoCache = "$HOME\Documents\GitHub\CoCache",
  [string]$CoModules = "$HOME\Documents\GitHub\CoModules"
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Mirror-ToRepo([string]$targetRepo,[string]$destRel){
  if(-not (Test-Path $targetRepo)){ Write-Host "Skip (missing): $targetRepo"; return }
  $src = Join-Path $SrcRepo 'admin/status/GRAND_MIGRATION.md'
  if(-not (Test-Path $src)){ throw "Source status not found: $src" }
  $body = Get-Content -Raw -LiteralPath $src -Encoding utf8

  Set-Location $targetRepo
  git fetch origin | Out-Null
  $ts = Get-Date -Format 'yyyyMMdd_HHmmss'
  $br = "admin/status_mirror_$ts"
  git switch -c $br origin/main | Out-Null

  $abs = Join-Path (Get-Location) $destRel
  $dir = Split-Path $abs
  if(-not (Test-Path $dir)){ New-Item -ItemType Directory -Force $dir | Out-Null }
  [IO.File]::WriteAllText($abs, ($body -replace "`r`n","`n").TrimEnd()+"`n", [Text.UTF8Encoding]::new($false))

  git add -- $destRel
  git commit -m "admin: mirror CoCivium grand-migration status board" | Out-Null
  git push -u origin HEAD | Out-Null
  if(Get-Command gh -ErrorAction SilentlyContinue){
    gh pr create -B main -t "Admin: mirror CoCivium status board" -b "Mirrors admin/status/GRAND_MIGRATION.md for cross-repo sync."
  } else {
    Write-Host "Open PR manually for $targetRepo"
  }
}

# Mirror to CoCache (breadcrumbs area)
Mirror-ToRepo -targetRepo $CoCache    -destRel 'clients/rick/CoCivium/GRAND_MIGRATION.md'

# Mirror to CoModules (adjacent pivot notes can link back)
Mirror-ToRepo -targetRepo $CoModules  -destRel 'admin/status/CoCivium-GRAND_MIGRATION.md'