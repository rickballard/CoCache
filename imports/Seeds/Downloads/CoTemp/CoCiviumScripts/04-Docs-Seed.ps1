. "$PSScriptRoot/RepoConfig.ps1"
$ErrorActionPreference='Stop'
Push-Location $Repo
try{
  $docs = Join-Path $Repo "docs"; $const=Join-Path $docs "constitution"; $frag=Join-Path $docs "_fragments"
  foreach($d in @($docs,$const,$frag, (Join-Path $docs 'status'))){ [IO.Directory]::CreateDirectory($d)|Out-Null }

  $index = Join-Path $docs "INDEX.md"
  if(-not (Test-Path $index)){
@"
# CoCivium Docs (Master Index)

**Welcome.** This repo is the source of truth for the public site and developer/docs pipelines.

## Read First
- [CoCivium Constitution (scroll)](constitution/scroll.html)
- Vision & Principles — *coming together as one civics platform with many voices.*
- Being Noname — *kept canonical.*

## Navigation
- Constitution & Appendices
- Programs & Playbooks
- BPOE (Best Process of Execution)
- KPIs & Status
- Glossary

> This index lives in-repo so website & GitHub stay in sync.
"@ | Set-Content -Encoding UTF8 -Path $index }

  @"
---

<div align="center">

**CoCivium** — *for fair systems, transparent power, and enduring democracy.*

[Status](../status/README.md) • [Index](../INDEX.md)

</div>
"@ | Set-Content -Encoding UTF8 -Path (Join-Path $frag 'footer.md')

  $ccMd = Join-Path $const "CoCivium-Constitution.md"
  if(-not (Test-Path $ccMd)){
@"
# CoCivium Constitution (Working Draft)

> Preamble — *placeholder.*  
> This long-form document will render as a continuous scroll in the viewer.

<!-- include: ../_fragments/footer.md -->
"@ | Set-Content -Encoding UTF8 -Path $ccMd }

  @"
<!doctype html>
<html lang="en"><meta charset="utf-8"/>
<title>CoCivium Constitution — Scroll</title>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<style>
  body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,Helvetica,Arial,sans-serif;line-height:1.6}
  header{position:sticky;top:0;background:#fff8;border-bottom:1px solid #ddd;backdrop-filter:saturate(140%) blur(6px);padding:10px 16px}
  .wrap{max-width:900px;margin:24px auto;padding:0 16px}
  .scroll{background:#fefdf9;padding:24px 18px;border:1px solid #e5e0c8;border-radius:12px;box-shadow: inset 0 0 0 1px #fff, 0 1px 12px #0000000f}
  .scroll h1{font-size:1.8rem;margin-top:0}
  .rulers{height:10px;background:
    radial-gradient(ellipse at left,#dcc 0 8px,transparent 9px),
    radial-gradient(ellipse at right,#dcc 0 8px,transparent 9px);
    background-repeat:no-repeat;background-size:18px 10px;background-position:0 0,100% 0;margin:-24px -18px 16px -18px}
  .small{color:#666;font-size:0.9rem}
</style>
<header><strong>CoCivium Constitution</strong> — scroll view</header>
<div class="wrap"><div class="scroll"><div class="rulers"></div>
  <article id="content" class="markdown-body small">Loading…</article>
</div></div>
<script>
(async ()=>{
  const mdPath='CoCivium-Constitution.md';
  const res=await fetch(mdPath); const md=await res.text();
  const rules=[
    [/^### (.*)$/gm,'<h3>$1</h3>'],[/^## (.*)$/gm,'<h2>$1</h2>'],[/^# (.*)$/gm,'<h1>$1</h1>'],
    [/\*\*(.+?)\*\*/g,'<strong>$1</strong>'],[/\*(.+?)\*/g,'<em>$1</em>'],[/`([^`]+?)`/g,'<code>$1</code>'],
    /\[(.+?)\]\((.+?)\)/g
  ];
  let html=md.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/\r\n/g,"\n");
  html=html.replace(/^>(.*)$/gm,'<blockquote>$1</blockquote>');
  html=rules.slice(0,3).reduce((s,[re,rep])=>s.replace(re,rep),html);
  html=html.replace(rules[3][0],rules[3][1]).replace(rules[4][0],rules[4][1]).replace(rules[5][0],rules[5][1])
           .replace(rules[6],(m,txt,href)=>`<a href="${href}">${txt}</a>`);
  html=html.split(/\n{2,}/).map(p=>/^<h\d|<blockquote|<ul|<ol|<pre|<p|<code/.test(p)?p:`<p>${p}</p>`).join('\n');
  document.querySelector('#content').innerHTML=html;
})();
</script>
</html>
"@ | Set-Content -Encoding UTF8 -Path (Join-Path $const 'scroll.html')

  git add docs
  git commit -m "docs: index, footer, constitution scroll viewer" 2>$null | Out-Null
  Write-Host "Seeded docs/"
} finally { Pop-Location }
