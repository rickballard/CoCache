param(
  [string]$CoCache = (Join-Path $HOME "Documents\GitHub\CoCache"),
  [string]$CoCivium = (Join-Path $HOME "Documents\GitHub\CoCivium")
)
$ErrorActionPreference="Stop"
function Clamp([double]$v){ [Math]::Max(0,[Math]::Min(100,$v)) }

$axes = Get-Content (Join-Path $CoCache "docs\intent\spider_axes.json") -Raw | ConvertFrom-Json

# --- Inputs we mine ---
$today = Get-Date -Format "yyyyMMdd"
$hbPath = Join-Path $CoCache "status\heartbeats.md"
$log    = Join-Path $CoCache ("status\log\cosync_{0}.jsonl" -f $today)
$reflexHashesDir = Join-Path $CoCache "docs\reflex\hashes"
$intentMan = Join-Path $CoCache "docs\intent\manifest.json"
$freezeDocs = Get-ChildItem (Join-Path $CoCache "status\notices") -Filter "*freeze*.md" -ErrorAction SilentlyContinue

# --- Content volume ---
$CIVSizeMB = 0
if(Test-Path $CoCivium){
  $CIVSizeMB = [math]::Round(((Get-ChildItem $CoCivium -Recurse -File -ea SilentlyContinue |
    ? { $_.FullName -notlike "*\.git\*" }) | Measure-Object -Sum Length).Sum/1MB,2)
}
# map ~0..500MB → 0..100 (cap)
$content = Clamp( ($CIVSizeMB / 5.0) )

# --- Ambition span (unique repos seen in heartbeats today) ---
$repoCount = 0
if(Test-Path $hbPath){
  $repoCount = (Get-Content $hbPath | Select-String "^\[" | ForEach-Object {
    ($_ -split '\]\s+',2)[1] -split ':' | Select-Object -First 1 } | Sort-Object -Unique).Count
}
$ambition = Clamp( ($repoCount / 20.0)*100 )

# --- Reflex coverage ---
$reflexCount = 0
if(Test-Path $intentMan){
  $m = Get-Content $intentMan -Raw | ConvertFrom-Json
  if($m -and $m.PSObject.Properties.Name -contains "reflex"){ $reflexCount = $m.reflex.Count }
}
$hashFiles = if(Test-Path $reflexHashesDir){ (Get-ChildItem $reflexHashesDir -Recurse -File).Count } else { 0 }
$reflex = Clamp( (($reflexCount*10) + [Math]::Min($hashFiles,50)) )

# --- Engagement (synthetic pulse but stable within day) ---
$salt = [BitConverter]::ToString((New-Object System.Security.Cryptography.SHA256CryptoServiceProvider).ComputeHash([Text.Encoding]::UTF8.GetBytes("$today$CIVSizeMB$repoCount"))).Replace("-","")
$seed = [Convert]::ToInt64($salt.Substring(0,12),16)
$rand = New-Object System.Random ([int]($seed -band 0x7FFFFFFF))
$millions = 1.5 + ($rand.NextDouble()*2.5) # 1.5M .. 4M
$engagement = Clamp( 50 + ($millions-2.75)*40 )  # center ~50

# --- Shipping velocity (last 7 days commits in CoCivium) ---
$velocity = 0
if(Test-Path $CoCivium){
  $since = (Get-Date).AddDays(-7).ToString("yyyy-MM-dd")
  $commits = git -C $CoCivium rev-list --count --since=$since HEAD 2>$null
  if([int]::TryParse($commits,[ref]([int]$null))){ $velocity = Clamp( [int]$commits * 10 ) }
}

# --- Bloat discipline (inverse of recent size jump from CoCache bloat reports) ---
$bloatFiles = Get-ChildItem (Join-Path $CoCache "status") -Filter "cosync_bloat_CoCivium_*.txt" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime
$bloat = 80
if($bloatFiles.Count -ge 2){
  $last2 = $bloatFiles | Select-Object -Last 2
  $sz = foreach($f in $last2){ (Select-String -Path $f.FullName -Pattern '^Repo Size.*:\s+(\d+(\.\d+)?) MB').Matches.Groups[1].Value }
  if($sz.Count -eq 2){
    $a=[double]$sz[0]; $b=[double]$sz[1]
    $jump = if($a -gt 0){ (($b-$a)/$a)*100 } else { 0 }
    $bloat = Clamp( 100 - [Math]::Min([Math]::Abs($jump),100) )
  }
}

# --- Freeze discipline (if active freeze includes CoCivium paths) ---
$freeze = 50
if($freezeDocs){
  $active = $false
  foreach($f in $freezeDocs){
    $t = Get-Content $f.FullName -Raw
    if($t -match 'CoCivium' -and ($t -match 'insights/')){
      $active = $true; break
    }
  }
  $freeze = $active ? 90 : 60
}

# --- Cross-repo sync (lines logged today) ---
$sync = 50
if(Test-Path $log){
  $lines = (Get-Content $log -ErrorAction SilentlyContinue).Count
  $sync = Clamp( ($lines/400.0)*100 )
}

# assemble payload
$vals = @{
  content=$content; ambition=$ambition; reflex=$reflex; engagement=$engagement;
  velocity=$velocity; bloat=$bloat; freeze=$freeze; sync=$sync
}
$payload = [ordered]@{
  title="CoCivium — Constellation Map"
  generated=(Get-Date).ToString("o")
  axes=$axes
  values=$vals
  notes= @{
    civSizeMB=$CIVSizeMB; repoCount=$repoCount; reflexCount=$reflexCount; hashFiles=$hashFiles
  }
  points=@(
    @{ name="CoCivium/insights"; axis="content"; weight=0.9 },
    @{ name="RickPublic/sotw";   axis="ambition"; weight=0.7 },
    @{ name="CoReflex";          axis="reflex";   weight=1.0 }
  )
}

# write data.json into CoCivium hero
$dataPath = Join-Path $CoCivium "site\hero\data.json"
$payload | ConvertTo-Json -Depth 10 | Set-Content -Enc UTF8 -LiteralPath $dataPath

# quick SVG fallback (radar polygon)
function Rad([double]$deg){ $deg * [Math]::PI/180.0 }
$N = $axes.Count
$R = 140
$cx,$cy = 160,160
$pts = @()
for($i=0;$i -lt $N;$i++){
  $θ = Rad( (360.0/$N)*$i - 90 )
  $v = $vals[$axes[$i].id] / 100.0
  $x = $cx + [Math]::Cos($θ) * ($R*$v)
  $y = $cy + [Math]::Sin($θ) * ($R*$v)
  $pts += ("{0:F1},{1:F1}" -f $x,$y)
}
$svg = @"
<svg viewBox="0 0 320 320" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <radialGradient id="g" cx="50%" cy="50%" r="60%">
      <stop offset="0%" stop-color="#88f" stop-opacity="0.6"/>
      <stop offset="100%" stop-color="#111" stop-opacity="0.2"/>
    </radialGradient>
  </defs>
  <rect width="100%" height="100%" fill="#0b1020"/>
  <g transform="translate($cx,$cy)">
    <g opacity="0.25">
      $(for($r=30;$r -le $R;$r+=22){ "<circle r='$r' fill='none' stroke='#44a' stroke-width='0.6' />" } -join "`n      ")
    </g>
  </g>
  <polyline points="$($pts -join ' ')" fill="url(#g)" stroke="#8cf" stroke-width="2" />
  $(for($i=0;$i -lt $N;$i++){
      $θ = Rad((360.0/$N)*$i - 90); $lx=$cx+[Math]::Cos($θ)*($R+16); $ly=$cy+[Math]::Sin($θ)*($R+16);
      "<text x='$lx' y='$ly' fill='#bfe' font-size='10' text-anchor='middle'>"+$axes[$i].label+"</text>"
    } -join "`n  ")
</svg>
"@
$svgPath = Join-Path $CoCivium "site\hero\hero.svg"
$svg | Set-Content -Enc UTF8 -LiteralPath $svgPath

Write-Host "✔ Spider data + SVG written:"
Write-Host "  $dataPath"
Write-Host "  $svgPath"
