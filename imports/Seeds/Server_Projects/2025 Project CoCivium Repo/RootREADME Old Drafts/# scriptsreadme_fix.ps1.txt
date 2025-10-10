# scripts/readme_fix.ps1
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Get-RepoRoot {
  try { return (git rev-parse --show-toplevel) } catch { return "$HOME\Documents\GitHub\CoCivium" }
}

$root = Get-RepoRoot
$readme = Join-Path $root 'README.md'
if (!(Test-Path $readme)) { Write-Error "README.md not found at $readme"; exit 1 }
$t = Get-Content -LiteralPath $readme -Raw
$ver = Get-Date -Format 'yyyyMMddHHmmss'

# 1) Canonicalize ALL acrostic icon srcs (fixes broken cases like -linelife, missing .svg, dup ?v, etc.)
$t = [regex]::Replace(
  $t,
  'src="\./assets/icons/(?<name>life|feels|broken|until|governments|coevolve|solutions|for-you)(?:-line)?[^"]*"',
  { param($m) 'src="./assets/icons/{0}-line.svg?v={1}"' -f $m.Groups['name'].Value, $ver }
)

# 2) Make icon imgs decorative + ensure spacing before bold label
$t = [regex]::Replace($t,'(<img\s+[^>]*src="\./assets/icons/[^"]+")([^>]*?)\s+alt="[^"]*"','$1$2')
$t = [regex]::Replace($t,'(<img\s+[^>]*src="\./assets/icons/[^"]+")(?![^>]*\salt=)([^>]*>)','$1 alt=""$2')
$t = $t -replace '\s*/>\s*&nbsp;\s+\*\*',' />&nbsp;&nbsp; **'

# 3) Strip stray '**' immediately after labels like "**LIFE:** **"
$t = [regex]::Replace($t,'(?m)(?<=\*\*[A-Za-z][A-Za-z \-]+:\*\*)\s*\*\*\s+',' ')

# 4) Rebuild ONE left-aligned Why/Who/How block directly under the H2, remove any duplicate W/W/H elsewhere
$lines = $t -split "`n", 0
$h = -1; for($i=0;$i -lt $lines.Length;$i++){ if($lines[$i] -match '^\s*##\s+We The People, Empowered\.\s*$'){ $h=$i; break } }
if ($h -ge 0) {
  # drop any existing icon/bold W/W/H lines anywhere
  $lines = $lines | Where-Object { $_ -notmatch '^\s*<img\s+[^>]*\./assets/icons/(why|who|how)-line\.svg' -and $_ -notmatch '^\s*\*\*(Why|Who|How):\*\*' }
  # find first acrostic (LIFE/FEELS/…)
  $first = (1..($lines.Length-1) | ForEach-Object {
    if ($lines[$_] -match '^\s*<img\s+[^>]*\./assets/icons/(life|feels|broken|until|governments|coevolve|solutions|for-you)-line\.svg') { $_ }
  } | Select-Object -First 1)
  if ($first) {
    $wwh = @(
      ''
      "<img src=""./assets/icons/why-line.svg?v=$ver""  alt="""" width=""20"" height=""20"" />&nbsp;&nbsp; **Why:** Democracy needs to be rescued. Digital life is faster than law. Guardrails<<link>> must scale with agency."
      "<img src=""./assets/icons/who-line.svg?v=$ver""  alt="""" width=""20"" height=""20"" />&nbsp;&nbsp; **Who:** Humans and AIs who accept consent-first rules. Temporary stewards/founders, federated ASAP."
      "<img src=""./assets/icons/how-line.svg?v=$ver""  alt="""" width=""20"" height=""20"" />&nbsp;&nbsp; **How:** CoConstitution, process specs, and adapters that embed dignity into civic tools."
      ''
    )
    $prefix = $lines[0..$h]
    $suffix = $lines[$first..($lines.Length-1)]
    $lines  = @($prefix + $wwh + $suffix)
  }
}

# 5) Enforce **COEVOLVE:** label casing (label only)
$lines = $lines | ForEach-Object { $_ -replace '\*\*CoEvolve:\*\*','**COEVOLVE:**' }

# 6) De-dup acrostic lines (keep first label)
$seen = @{}
$result = New-Object System.Collections.Generic.List[string]
foreach ($ln in $lines) {
  $m = [regex]::Match($ln,'^\s*<img[^>]*>\s*&nbsp;&nbsp;\s+\*\*([A-Za-z][A-Za-z \-]+):\*\*')
  if ($m.Success) {
    $label = $m.Groups[1].Value.ToUpperInvariant()
    if ($seen[$label]) { continue } else { $seen[$label] = $true }
  }
  $null = $result.Add($ln)
}

# 7) Normalize EOL + save (UTF-8 no BOM)
$new = (($result -join "`n") -replace "`r`n","`n" -replace "`r","`n").TrimEnd("`n") + "`n"
if ($new -ne $t) { [IO.File]::WriteAllText($readme, $new, [Text.UTF8Encoding]::new($false)) }
Write-Host "README normalized." -ForegroundColor Green
