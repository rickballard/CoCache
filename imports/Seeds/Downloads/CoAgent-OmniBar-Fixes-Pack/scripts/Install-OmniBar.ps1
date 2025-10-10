[CmdletBinding()]
param([string]$RepoPath="$HOME\Documents\GitHub\CoAgent")
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Info($m){ Write-Host "[INFO] $m" }
$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { throw "Repo not found: $RepoPath" }

# 1) Drop assets
$assets = Join-Path $repo "assets\ui"
New-Item -ItemType Directory -Force -Path $assets | Out-Null
Copy-Item -Path (Join-Path $PSScriptRoot "..\assets\ui\OmniBar.css") -Destination (Join-Path $assets "OmniBar.css") -Force
Copy-Item -Path (Join-Path $PSScriptRoot "..\assets\ui\OmniBar.js")  -Destination (Join-Path $assets "OmniBar.js")  -Force
Info "Installed OmniBar assets -> $assets"

# 2) Locate renderer entries
$renderer = @(
  "electron\src\renderer\index.tsx","electron\src\renderer\index.jsx",
  "electron\renderer\index.tsx","electron\renderer\index.jsx",
  "electron\src\index.tsx","electron\src\index.jsx"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }
$html = @(
  "electron\public\index.html","electron\src\renderer\index.html",
  "electron\static\index.html","electron\index.html"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }

# 3) Remove GuardrailsBar includes; add OmniBar includes
function InstallTsx($file){
  $raw = Get-Content -Raw $file
  $rel = [IO.Path]::GetRelativePath((Split-Path $file -Parent), (Join-Path $repo "assets\ui")) -replace '\\','/'
  $raw = $raw -replace 'import\s+["''].*GuardrailsBar\.css["''];?\s*', ''
  $raw = $raw -replace 'import\s+["''].*GuardrailsBar\.js["''];?\s*', ''
  $add = "import `"$rel/OmniBar.css`";`r`nimport `"$rel/OmniBar.js`";`r`n"
  if ($raw -notmatch [regex]::Escape("OmniBar.css")) { $raw = $add + $raw }
  Set-Content -Encoding UTF8 $file $raw
  Info "OmniBar imports installed -> $file"
}

function InstallHtml($file){
  $raw = Get-Content -Raw $file
  $rel = [IO.Path]::GetRelativePath((Split-Path $file -Parent), (Join-Path $repo "assets\ui")) -replace '\\','/'
  # Remove old includes
  $raw = $raw -replace '<link[^>]+GuardrailsBar\.css[^>]*>\s*',''
  $raw = $raw -replace '<script[^>]+GuardrailsBar\.js[^>]*>\s*</script>\s*',''
  # Add OmniBar
  $link = "<link rel=""stylesheet"" href=""$rel/OmniBar.css"">"
  $script = "<script src=""$rel/OmniBar.js""></script>"
  if ($raw -notmatch [regex]::Escape("OmniBar.css")) {
    $raw = $raw -replace '<head[^>]*>', { param($m) $m.Value + "`r`n  $link`r`n  $script" }
  }
  Set-Content -Encoding UTF8 $file $raw
  Info "OmniBar <link>/<script> installed -> $file"
}

if ($renderer) { foreach($f in $renderer){ InstallTsx $f } }
elseif ($html) { foreach($f in $html){ InstallHtml $f } }
else { Write-Warning "No renderer entry found; import OmniBar manually."; }

# 4) Commit
if (Test-Path (Join-Path $repo '.git')) { Push-Location $repo; try { git add -A; if (-not (git diff --cached --quiet)) { git commit -m "feat(ui): OmniBar (single status bar merging Guardrails+BPOE+IssueOps)" } } finally { Pop-Location } }
