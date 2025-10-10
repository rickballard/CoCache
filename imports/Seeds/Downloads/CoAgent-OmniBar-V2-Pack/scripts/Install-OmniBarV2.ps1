[CmdletBinding()]
param([string]$RepoPath="$HOME\Documents\GitHub\CoAgent")
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Info($m){ Write-Host "[INFO] $m" }
$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { throw "Repo not found: $RepoPath" }

# 1) Assets
$assets = Join-Path $repo "assets\ui"
New-Item -ItemType Directory -Force -Path $assets | Out-Null
Copy-Item -Path (Join-Path $PSScriptRoot "..\assets\ui\OmniBar.css") -Destination (Join-Path $assets "OmniBar.css") -Force
Copy-Item -Path (Join-Path $PSScriptRoot "..\assets\ui\OmniBar.js")  -Destination (Join-Path $assets "OmniBar.js")  -Force
Info "Installed OmniBar v2 assets -> $assets"

# 2) Renderer entries
$renderer = @(
  "electron\src\renderer\index.tsx","electron\src\renderer\index.jsx",
  "electron\renderer\index.tsx","electron\renderer\index.jsx",
  "electron\src\index.tsx","electron\src\index.jsx"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }
$html = @(
  "electron\public\index.html","electron\src\renderer\index.html",
  "electron\static\index.html","electron\index.html"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }

function InstallTsx($file){
  $raw = Get-Content -Raw $file
  $rel = [IO.Path]::GetRelativePath((Split-Path $file -Parent), (Join-Path $repo "assets\ui")) -replace '\\','/'
  # remove legacy imports
  $raw = $raw -replace 'import\s+["''].*GuardrailsBar\.css["''];?\s*', ''
  $raw = $raw -replace 'import\s+["''].*GuardrailsBar\.js["''];?\s*', ''
  $raw = $raw -replace 'import\s+["''].*OmniBar\.css["''];?\s*', ''
  $raw = $raw -replace 'import\s+["''].*OmniBar\.js["''];?\s*', ''
  $add = "import `"$rel/OmniBar.css`";`r`nimport `"$rel/OmniBar.js`";`r`n"
  if ($raw -notmatch [regex]::Escape("OmniBar.css")) { $raw = $add + $raw }
  Set-Content -Encoding UTF8 $file $raw
  Info "OmniBar v2 imports installed -> $file"
}

function InstallHtml($file){
  $raw = Get-Content -Raw $file
  # remove legacy links/scripts
  $raw = $raw -replace '<link[^>]+GuardrailsBar\.css[^>]*>\s*',''
  $raw = $raw -replace '<script[^>]+GuardrailsBar\.js[^>]*>\s*</script>\s*',''
  $raw = $raw -replace '<link[^>]+OmniBar\.css[^>]*>\s*',''
  $raw = $raw -replace '<script[^>]+OmniBar\.js[^>]*>\s*</script>\s*',''
  $rel = [IO.Path]::GetRelativePath((Split-Path $file -Parent), (Join-Path $repo "assets\ui")) -replace '\\','/'
  $link = "<link rel=""stylesheet"" href=""$rel/OmniBar.css"">"
  $script = "<script src=""$rel/OmniBar.js""></script>"
  $head = [regex]'<head[^>]*>'
  if ($head.IsMatch($raw)) {
    $raw = $head.Replace($raw, { param($m) $m.Value + "`r`n  $link`r`n  $script" }, 1)
    Set-Content -Encoding UTF8 $file $raw
    Info "OmniBar v2 <link>/<script> installed -> $file"
  } else {
    Write-Warning "No <head> tag in $file; add OmniBar links manually."
  }
}

if ($renderer) { foreach($f in $renderer){ InstallTsx $f } }
elseif ($html) { foreach($f in $html){ InstallHtml $f } }
else { Write-Warning "No renderer entry found; add OmniBar manually." }

# 3) Commit if repo
if (Test-Path (Join-Path $repo '.git')) {
  Push-Location $repo
  try { git add -A; if (-not (git diff --cached --quiet)) { git commit -m "feat(ui): OmniBar v2 (single bar, GI slider, KPI popups, SLAM high=good)" } }
  finally { Pop-Location }
}
