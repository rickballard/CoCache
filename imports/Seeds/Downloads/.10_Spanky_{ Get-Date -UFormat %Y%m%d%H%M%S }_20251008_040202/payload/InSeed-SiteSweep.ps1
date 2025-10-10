# payload/InSeed-SiteSweep.ps1
param([string]$Repo = (Join-Path $HOME "Documents\GitHub\InSeed"))
Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"
if(!(Test-Path $Repo)){ throw "Repo not found: $Repo" }
$build = Get-Date -UFormat %Y%m%d%H%M%S
$assets= Join-Path $Repo 'assets'
$css   = Join-Path $assets 'site.css'

$marker='/* spanky: header+cta+footer patch */'
if(-not (Select-String -Path $css -SimpleMatch $marker -Quiet)){
@"
$marker
.header .brand{display:flex;align-items:center;gap:.6rem}
.header .brand img,.brand .site-logo img,header img[alt*="InSeed"]{height:60px!important;max-height:60px!important;width:auto}
@media (max-width:720px){ .header .brand img,.brand .site-logo img,header img[alt*="InSeed"]{height:48px!important;max-height:48px!important} }
.strap,.announce,.top-strap,.strapline{font-size:1.06rem;line-height:1.25}
.strap a,.announce a,.strapline a{padding:.2rem .45rem}
a[href*="/resources/billing/"][style*="position:fixed"],a[href*="/resources/billing/"][class*="corner"],a[href*="/resources/billing/"][class*="chip"],a[href*="/resources/billing/"][class*="floating"],a[href*="/resources/billing/"][class*="sticky"],#corner-cta,.sticky-cta,.floating-cta{display:none!important}
.cta-trio{display:flex;flex-wrap:wrap;justify-content:center;gap:.75rem;margin:1.25rem auto 2.25rem;max-width:900px}
.cta-trio .button{min-width:13rem;text-align:center;padding:.7rem 1rem}
@media (max-width:640px){ .cta-trio .button{flex:1 1 100%} }
footer .container{max-width:1100px;margin:0 auto;padding:1rem}
footer .legal{text-align:center;opacity:.85}
"@ | Add-Content -Encoding utf8 $css
}

$newStrap = 'TxO Steward · Week-0 CoAudit · Evidence cadence · Portable artifacts'
$wpTarget = '/resources/insights/ceo-steward-exec-summary.html'
$logoBlock= '<span class="site-logo"><img src="/assets/logo-dark.svg" data-scheme="dark" alt="InSeed"><img src="/assets/logo-light.svg" data-scheme="light" alt="InSeed"></span>'

Get-ChildItem $Repo -Recurse -Include *.html | ForEach-Object {
  $p=$_.FullName; $h=Get-Content $p -Raw
  $h = [regex]::Replace($h,'(?is)\s*<div[^>]+class="[^"]*\bannounce\b[^"]*"[^>]*>[\s\S]*?</div>','')
  $h = [regex]::Replace($h,'AI-Expert Advisors .*? Systems Evolution',$newStrap)
  $h = [regex]::Replace($h,'AI-Expert Interim Executives .*? implementation talent\.?',$newStrap)
  $h = [regex]::Replace($h,'(?is)<a(?=[^>]*href="/resources/billing/")(?=[^>]*(?:position:\s*fixed|class="[^"]*(?:corner|chip|floating|sticky)[^"]*")).*?>[\s\S]*?</a>','')
  $h = [regex]::Replace($h,'(?is)<img[^>]+/assets/logo[^">]*\.svg[^>]*>',$logoBlock)
  $h = [regex]::Replace($h,'href="(?:/whitepaper/|/docs/whitepaper/[^"]*|/resources/[^"]*(?:whitepaper|survival)[^"]*)"','href="'+$wpTarget+'"')
  if($p -notmatch '\\engagement\\'){ $h = [regex]::Replace($h,'(?is)<a[^>]*>\s*Engagement\s*</a>','') }
  $h = $h -replace "script-src 'self'(?! 'unsafe-inline')","script-src 'self' 'unsafe-inline'"
  if((Split-Path $p -Leaf) -eq 'index.html' -and ($p -match '\\InSeed($|\\)')){
    if($h -notmatch 'class="cta-trio"'){
      $cta = '<div class="cta-trio"><a class="button brand" href="/contact/">Start a conversation</a><a class="button" href="/problems/">See the real problems</a><a class="button" href="/solutions/">See the real solutions</a></div>'
      $h = [regex]::Replace($h,'(?is)</main>',$cta+'</main>',1)
    }
  }
  $build = Get-Date -UFormat %Y%m%d%H%M%S
  $h = $h -replace 'href="/assets/site\.css(\?[^"]*)?"', "href=""/assets/site.css?v=$build"""
  $h = $  Set-Content -Encoding utf8 $p $h
}
& git -C $Repo add -A | Out-Null
& git -C $Repo commit -m ("spanky sweep: header/strap/nav/cta/seo/footer/cache") | Out-Null
& git -C $Repo push | Out-Null
Write-Host "InSeed-SiteSweep complete."