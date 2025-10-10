[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$ShortName,
  [string]$SourceRepo = (Join-Path $HOME 'Documents\GitHub\InSeed'),
  [switch]$IncludeRepoSnapshot
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Get-DownloadsPath {
  $d = Join-Path $HOME 'Downloads'
  if(Test-Path $d){ return $d } else { throw "Downloads folder not found: $d" }
}
function New-Timestamp { Get-Date -UFormat %Y%m%d_%H%M%S }
function Sanitize([string]$s){ [regex]::Replace($s,'[^\w\.-]','_') }
function Write-Utf8([string]$Path,[string]$Text){
  $dir = Split-Path -Parent $Path
  if(-not (Test-Path $dir)){ New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  $enc = [System.Text.UTF8Encoding]::new($false)
  [System.IO.File]::WriteAllText($Path, $Text, $enc)
}

$dl   = Get-DownloadsPath
$base = Join-Path $dl 'Spanky'
$null = New-Item -ItemType Directory -Force -Path $base
$now  = New-Timestamp
$safe = Sanitize($ShortName)

# Locate or create
$packDir = Get-ChildItem -Path $base -Directory |
  Where-Object { $_.Name -like ("Spanky_{0}_*" -f $safe) } |
  Sort-Object Name -Descending | Select-Object -First 1

if($null -eq $packDir){
  $packName = "Spanky_{0}_{1}" -f $safe, $now
  $root = Join-Path $base $packName
  $null = New-Item -ItemType Directory -Force -Path $root
}else{
  $packName = $packDir.Name
  $root = $packDir.FullName
}

$sp = Join-Path $root '_spanky'
$tx = Join-Path $root 'transcripts'
$pl = Join-Path $root 'payload'
$nt = Join-Path $root 'notes'
$su = Join-Path $root 'summaries'
$null = New-Item -ItemType Directory -Force -Path $sp,$tx,$pl,$nt,$su

# Core metadata
$copayload = [ordered]@{ spanky_version="2.2"; short_name=$safe; created_at=$now; author="CoWrap"; schema="Spanky/2.2" } | ConvertTo-Json -Depth 6
Write-Utf8 (Join-Path $sp '_copayload.meta.json') $copayload
$manifest = [ordered]@{
  wrap  = [ordered]@{ name="$safe-wrap"; version="1.0.0"; timestamp=$now; notes="Create/augment" }
  build = [ordered]@{ generator="Make-Or-Augment-Spanky.ps1"; host=$env:COMPUTERNAME }
} | ConvertTo-Json -Depth 6
Write-Utf8 (Join-Path $sp '_wrap.manifest.json') $manifest

# Transcript
$session = @"
# InSeed Website Session — condensed
- Email routing: contact@/feedback@ → Gmail; reply-from rballard@ not exposed on pages.
- Shipped: feedback qualifiers + rates ack + honeypot; billing noarchive; email reveal pill; button cleanup.
- Header/Logo ≈3× + dark/light SVG; strap unified; Engagement only on /engagement/.
- Whitepaper/Survival → Exec Summary; /whitepaper/ is a redirect.
- Footer recentered; sitemap.xml; robots.txt; 404.html; canonical + OG/Twitter.
- Home CTA trio: Start a conversation / See the real problems / See the real solutions.
- DNS auth: SPF include:_spf.google.com; DKIM selector "google"; DMARC rua=dmarc@inseed.com.
- Cloudflare: HTML dynamic; CSS cache-busted; auto-minify/Brotli when available.
- Deprecated/backups noindexed; multiple cache-bust passes.
"@
Write-Utf8 (Join-Path $tx 'session.md') $session

# Payload: snippets + helpers
Write-Utf8 (Join-Path $pl 'Header-Logo-DualMode-Snippet.html') @"
<span class=""site-logo"">
  <img src=""/assets/logo-dark.svg""  data-scheme=""dark""  alt=""InSeed"">
  <img src=""/assets/logo-light.svg"" data-scheme=""light"" alt=""InSeed"">
</span>
"@
Write-Utf8 (Join-Path $pl 'CTA-Trio-Snippet.html') @"
<div class=""cta-trio"">
  <a class=""button brand"" href=""/contact/"">Start a conversation</a>
  <a class=""button"" href=""/problems/"">See the real problems</a>
  <a class=""button"" href=""/solutions/"">See the real solutions</a>
</div>
"@
Write-Utf8 (Join-Path $pl 'site.css.patch') @"
/* spanky: header+cta+footer patch */
.header .brand{display:flex;align-items:center;gap:.6rem}
.header .brand img,.brand .site-logo img,header img[alt*=""InSeed""]{height:60px!important;max-height:60px!important;width:auto}
@media (max-width:720px){
  .header .brand img,.brand .site-logo img,header img[alt*=""InSeed""]{height:48px!important;max-height:48px!important}
}
a[href*=""/resources/billing/""][style*=""position:fixed""],
a[href*=""/resources/billing/""][class*=""corner|chip|floating|sticky""],
#corner-cta,.sticky-cta,.floating-cta{display:none!important}
.cta-trio{display:flex;flex-wrap:wrap;justify-content:center;gap:.75rem;margin:1.25rem auto 2.25rem;max-width:900px}
.cta-trio .button{min-width:13rem;text-align:center;padding:.7rem 1rem}
footer .container{max-width:1100px;margin:0 auto;padding:1rem}
footer .legal{text-align:center;opacity:.85}
"@
Write-Utf8 (Join-Path $pl 'InSeed-EmailAuth-DNS.txt') @"
SPF:  inseed.com TXT => v=spf1 include:_spf.google.com ~all
DKIM: google._domainkey.inseed.com TXT => (Google DKIM public key) ; selector=google
DMARC: _dmarc.inseed.com TXT => v=DMARC1; p=none; rua=mailto:dmarc@inseed.com; fo=1; aspf=s; adkim=s
Action: ensure dmarc@inseed.com exists (alias/Group) and forwards; Gmail label ""DMARC"", filter: has:report
"@
Write-Utf8 (Join-Path $pl 'Cloudflare-Checklist.md') @"
# Cloudflare Checklist
- CDN in front of GitHub Pages ✔
- HTML: standard/bypass; CSS/JS: cache with querystring cache-busting ✔
- Auto-minify + Brotli when available; otherwise rely on cache-busting ✔
- Purge Everything after big rewrites
"@
if(-not (Test-Path (Join-Path $pl 'MISSING_PROGRAMMATIC_DIAGRAMS.txt'))){
  Write-Utf8 (Join-Path $pl 'MISSING_PROGRAMMATIC_DIAGRAMS.txt') "If Mermaid/Graphviz etc. existed outside /assets, capture sources + renders here."
}

# Notes & summaries
Write-Utf8 (Join-Path $nt 'ACCESSIBILITY.md') @"
# ACCESSIBILITY
- Contrast AA; focus outlines; prefers-reduced-motion; mobile hit targets.
"@
Write-Utf8 (Join-Path $nt 'RELEASE_CHECKLIST.md') @"
# RELEASE_CHECKLIST
- Bump ?v= for /assets/site.css & /assets/site.js; commit/push
- Purge Cloudflare cache
- Spot-check: /, /engagement/, /resources/billing/, /feedback/, Problems/Solutions, /whitepaper redirect
- Verify dual-mode logo, unified strap, CTA trio, email reveal pill
"@
Write-Utf8 (Join-Path $nt 'OPEN_ITEMS.md') @"
# OPEN_ITEMS
- Create/route dmarc@inseed.com (Unfinished)
- Enable CF Brotli/Auto-minify if available (Unfinished)
- Flesh out /problems/ and /solutions/ beyond stubs (Unfinished)
"@
Write-Utf8 (Join-Path $su 'CHANGELOG.md') ("# CHANGELOG`n- {0}: Initial create/augment + supplementals." -f (Get-Date -Format 'yyyy-MM-dd'))

# Optional repo snapshot
if($IncludeRepoSnapshot -and (Test-Path $SourceRepo)){
  $snap = Join-Path $pl 'website_snapshot'
  $null = New-Item -ItemType Directory -Force -Path $snap
  try{
    $items = Get-ChildItem -Recurse -File -Path $SourceRepo -ErrorAction Stop
    $rel   = $items | ForEach-Object { $_.FullName.Substring($SourceRepo.Length).TrimStart('\') }
    Write-Utf8 (Join-Path $snap 'WEBSITE_SNAPSHOT_TREE.txt') ($rel -join [Environment]::NewLine)
  }catch{}
  $gitlog = & git -C $SourceRepo log --graph --decorate --oneline -n 80 2>$null
  if($LASTEXITCODE -eq 0){ Write-Utf8 (Join-Path $snap 'GIT_LOG_RECENT.txt') (($gitlog) -join [Environment]::NewLine) }
  foreach($rel in @('assets\logo.svg','assets\logo-dark.svg','assets\logo-light.svg','assets\site.css','assets\site.js','assets\maps','assets\img','assets\diagrams')){
    $src = Join-Path $SourceRepo $rel
    if(Test-Path $src){
      $dst = Join-Path $snap $rel
      New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
      if(Test-Path $src -PathType Container){ Copy-Item $src -Destination $dst -Recurse -Force -ErrorAction SilentlyContinue }
      else{ Copy-Item $src -Destination $dst -Force -ErrorAction SilentlyContinue }
    }
  }
}

# checksums + out.txt
$allFiles  = Get-ChildItem -Path $root -Recurse -File
$checks    = @{}
foreach($f in $allFiles){
  $rel = $f.FullName.Substring($root.Length).TrimStart('\').Replace('\','/')
  try{ $h = Get-FileHash -Algorithm SHA256 -LiteralPath $f.FullName; $checks[$rel] = @{ bytes=$f.Length; sha256=$h.Hash.ToLower() } }
  catch{ $checks[$rel] = @{ bytes=$f.Length; sha256="ERROR" } }
}
Write-Utf8 (Join-Path $sp 'checksums.json') (($checks | ConvertTo-Json -Depth 6))

$transcripts = (Get-ChildItem (Join-Path $root 'transcripts') -File | Measure-Object).Count
$payloadCnt  = (Get-ChildItem (Join-Path $root 'payload')     -File -Recurse | Measure-Object).Count
$notesCnt    = (Get-ChildItem (Join-Path $root 'notes')       -File | Measure-Object).Count
$sumsCnt     = (Get-ChildItem (Join-Path $root 'summaries')   -File | Measure-Object).Count

$status = "[STATUS] items={0} transcripts={1} payload={2} notes={3} summaries={4}" -f ($allFiles.Count),$transcripts,$payloadCnt,$notesCnt,$sumsCnt
Write-Utf8 (Join-Path $sp 'out.txt') ($status + "`npack=$packName`npath=$root`ncreated=$now`n")
Write-Host ("Spanky ready: {0} ({1})" -f $packName,$status) -ForegroundColor Green