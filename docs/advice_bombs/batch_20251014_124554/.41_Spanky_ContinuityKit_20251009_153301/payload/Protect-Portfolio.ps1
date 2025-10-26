# Protect-Portfolio.ps1
# Mirrors all repos (bare), pushes to secondary remotes, and creates signed archives.
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$Owner         = $env:GITHUB_OWNER      ?? 'rickballard'
$Token         = $env:GITHUB_TOKEN      ?? ''
$PrimaryURL    = "https://api.github.com"
$BackupRoot    = Join-Path $HOME "Documents\Backups\RepoMirrors"
$ArchivesRoot  = Join-Path $BackupRoot "archives"
$GPGKeyId      = $env:GPG_KEY_ID        ?? ''

$Mirror1Name   = "mirror1"
$Mirror1URLFmt = $env:MIRROR1_URL_FMT ?? "ssh://git@gitea.yourlan.local:2222/{0}.git"
$Mirror2Name   = "mirror2"
$Mirror2URLFmt = $env:MIRROR2_URL_FMT ?? ""

$Headers = @{ 'User-Agent'='repo-mirror'; Authorization = if ($Token) {"Bearer $Token"} else { $null } }
New-Item -ItemType Directory -Force -Path $BackupRoot,$ArchivesRoot | Out-Null

Write-Host "Fetching repo list for $Owner ..."
$repos = @(); $Page = 1
do {
  $url = "$PrimaryURL/users/$Owner/repos?per_page=100&page=$Page&type=all&sort=full_name&direction=asc"
  try { $batch = Invoke-RestMethod -Uri $url -Headers $Headers } catch { $batch = @() }
  $repos += $batch; $Page++
} while ($batch -and $batch.Count -gt 0)

if (-not $repos) { throw "No repositories found for $Owner (check token/owner)" }

foreach ($r in $repos) {
  $name = $r.name
  $cloneUrl = if ($Token) { $r.clone_url.Replace('https://', "https://$Token@") } else { $r.clone_url }
  $repoDir = Join-Path $BackupRoot "$name.git"
  if (-not (Test-Path $repoDir)) {
    Write-Host "==> Cloning bare mirror: $name"
    git clone --mirror $cloneUrl $repoDir
  } else {
    Write-Host "==> Updating mirror: $name"
    Push-Location $repoDir
    git remote set-url origin $cloneUrl
    git remote update --prune
    Pop-Location
  }

  Push-Location $repoDir
  if ($Mirror1URLFmt) {
    $m1 = $Mirror1URLFmt -f $name
    if ((git remote) -notcontains $Mirror1Name) { git remote add $Mirror1Name $m1 } else { git remote set-url $Mirror1Name $m1 }
  }
  if ($Mirror2URLFmt) {
    $m2 = $Mirror2URLFmt -f $name
    if ((git remote) -notcontains $Mirror2Name) { git remote add $Mirror2Name $m2 } else { git remote set-url $Mirror2Name $m2 }
  }
  if ($Mirror1URLFmt) { Write-Host "   -> Pushing to $Mirror1Name"; git push --mirror $Mirror1Name || $true }
  if ($Mirror2URLFmt) { Write-Host "   -> Pushing to $Mirror2Name"; git push --mirror $Mirror2Name || $true }

  $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
  $tar = Join-Path $ArchivesRoot "$($name)-mirror-$stamp.tar"
  Write-Host "   -> Archiving $name -> $tar"
  git repack -ad
  git gc --prune=now --aggressive
  Pop-Location

  $cwd = Get-Location; Set-Location $BackupRoot
  tar -cf $tar "$name.git"
  Set-Location $cwd

  if ($GPGKeyId) {
    $sig = "$tar.sig"
    Write-Host "   -> Signing archive with GPG key $GPGKeyId"
    & gpg --batch --yes --local-user $GPGKeyId --output $sig --detach-sign $tar
  }
}

Write-Host "DONE. Mirrors: $BackupRoot  Archives: $ArchivesRoot"

