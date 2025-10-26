param(
  [string]$OutRoot = (Join-Path $HOME "Documents\GitHub\CoCache"),
  [int]$MaxPerTopic = 25,
  [switch]$Download
)
$ErrorActionPreference='Stop'
if(!(Get-Command gh -ErrorAction SilentlyContinue)){ throw "GitHub CLI (gh) required" }

$topics = @(
  'link-checker','markdown-linter','docusaurus','mkdocs','mdbook',
  'knowledge-graph','graphviz','mermaid','site-search','algolia-docsearch',
  'documentation-generator','static-analysis','table-of-contents','sitemap'
)

$csv = New-Object System.Collections.Generic.List[Object]
$manifest = @()
$outDash = Join-Path $OutRoot 'docs\dashboards\systematization_scan.csv'
$outMan  = Join-Path $OutRoot 'docs\intent\systematization_manifest.json'
New-Item -ItemType Directory -Force -Path (Split-Path $outDash),(Split-Path $outMan) | Out-Null

function Search-Topic([string]$t,[int]$limit){
  $q = "q=topic:$t+stars:%3E50+archived:false"
  $url = "search/repositories?${q}&sort=stars&order=desc&per_page=$limit"
  (gh api -X GET $url | ConvertFrom-Json).items
}

foreach($t in $topics){
  $items = Search-Topic $t $MaxPerTopic
  foreach($r in $items){
    $lic = $r.license.spdx_id; if(-not $lic){ $lic = $r.license.name }
    $csv.Add([pscustomobject]@{
      topic=$t; full_name=$r.full_name; stars=$r.stargazers_count; license=$lic;
      homepage=$r.homepage; description=$r.description; default_branch=$r.default_branch
    })
    $manifest += [pscustomobject]@{
      topic=$t; owner=$r.owner.login; repo=$r.name; license=$lic;
      default_branch=$r.default_branch; clone="https://github.com/$($r.full_name).git";
      codeload="https://codeload.github.com/$($r.full_name)/zip/refs/heads/$($r.default_branch)"
    }
  }
}

$csv | Sort-Object topic,-stars | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $outDash
$manifest | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 -LiteralPath $outMan

if($Download){
  $incoming = Join-Path $OutRoot 'thirdparty\incoming'
  New-Item -ItemType Directory -Force -Path $incoming | Out-Null
  foreach($m in $manifest){
    $zip = Join-Path $incoming ("{0}_{1}.zip" -f $m.owner,$m.repo)
    try { Invoke-WebRequest -Uri $m.codeload -OutFile $zip -UseBasicParsing -TimeoutSec 120 } catch {}
  }
}

# receipt
$log = Join-Path $OutRoot ('status\log\cosync_{0}.jsonl' -f ([DateTime]::UtcNow.ToString('yyyyMMdd')))
$rx  = [pscustomobject]@{
  repo='CoCache'; when=[DateTime]::UtcNow.ToString('o'); area='systematization'; type='progress'
  summary="Scan complete"; data=@{ topics=$topics; dashboard=($outDash -replace '^.*Documents\\GitHub\\'); manifest=($outMan -replace '^.*Documents\\GitHub\\'); downloaded=[bool]$Download }
  source='agent'
}
((($rx|ConvertTo-Json -Depth 10)+"`n"))|Add-Content -LiteralPath $log -Encoding UTF8

"✔ Wrote:
 - $outDash
 - $outMan
 - Downloaded: $Download"

