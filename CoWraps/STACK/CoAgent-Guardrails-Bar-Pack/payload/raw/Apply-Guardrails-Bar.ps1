[CmdletBinding()]
param([string]$RepoPath="$HOME\Documents\GitHub\CoAgent")
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Info($m){ Write-Host "[INFO] $m" }

$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { throw "Repo not found: $RepoPath" }

# 1) Install assets
$assets = Join-Path $repo "assets\ui"
New-Item -ItemType Directory -Force -Path $assets | Out-Null
Copy-Item -Path (Join-Path $PSScriptRoot "..\assets\ui\GuardrailsBar.css") -Destination (Join-Path $assets "GuardrailsBar.css") -Force
Copy-Item -Path (Join-Path $PSScriptRoot "..\assets\ui\GuardrailsBar.js")  -Destination (Join-Path $assets "GuardrailsBar.js")  -Force
Copy-Item -Path (Join-Path $PSScriptRoot "..\assets\ui\DoBlocks.js")       -Destination (Join-Path $assets "DoBlocks.js")       -Force
Info "Assets installed to $assets"

# 2) Inject into renderer (TSX/JSX or HTML)
$rendererCandidates = @(
  "electron\src\renderer\index.tsx",
  "electron\src\renderer\index.jsx",
  "electron\renderer\index.tsx",
  "electron\renderer\index.jsx",
  "electron\src\index.tsx",
  "electron\src\index.jsx"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }

$htmlCandidates = @(
  "electron\public\index.html",
  "electron\src\renderer\index.html",
  "electron\static\index.html",
  "electron\index.html"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }

function Add-Import($file) {
  $raw = Get-Content -Raw $file
  $rel  = [IO.Path]::GetRelativePath((Split-Path $file -Parent), (Join-Path $repo "assets\ui")) -replace '\\','/'
  $css  = "import `"$rel/GuardrailsBar.css`";"
  $js1  = "import `"$rel/GuardrailsBar.js`";"
  $js2  = "import `"$rel/DoBlocks.js`";"
  foreach($line in @($css,$js1,$js2)){
    if ($raw -notmatch [regex]::Escape($line)) { $raw = $line + "`r`n" + $raw }
  }
  Set-Content -Encoding UTF8 $file $raw
  Info "Injected imports -> $file"
}

function Add-Link($file) {
  $raw = Get-Content -Raw $file
  $head = [regex]'<head[^>]*>'
  $rel  = [IO.Path]::GetRelativePath((Split-Path $file -Parent), (Join-Path $repo "assets\ui")) -replace '\\','/'
  $l1   = "<link rel=""stylesheet"" href=""$rel/GuardrailsBar.css"">"
  $s1   = "<script src=""$rel/GuardrailsBar.js""></script>"
  $s2   = "<script src=""$rel/DoBlocks.js""></script>"
  if ($head.IsMatch($raw)) {
    foreach($line in @($l1,$s1,$s2)){
      if ($raw -notmatch [regex]::Escape($line)) { $raw = $head.Replace($raw, {param($m) $m.Value + "`n  $line" }, 1) }
    }
    Set-Content -Encoding UTF8 $file $raw
    Info "Injected <link>/<script> -> $file"
  }
}

if ($rendererCandidates) { foreach($f in $rendererCandidates){ Add-Import $f } }
elseif ($htmlCandidates) { foreach($f in $htmlCandidates){ Add-Link $f } }
else { Write-Warning "No renderer entry found; import assets/ui manually." }

# 3) Commit
if (Test-Path (Join-Path $repo '.git')) {
  Push-Location $repo
  try {
    git add -A
    if (-not (git diff --cached --quiet)) { git commit -m "feat(ui): Guardrails status bar + DO-block compactor" }
  } finally { Pop-Location }
}
