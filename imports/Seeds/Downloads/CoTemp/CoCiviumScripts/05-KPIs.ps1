. "$PSScriptRoot/RepoConfig.ps1"
$ErrorActionPreference='Stop'
function WordCount([string]$s){ if([string]::IsNullOrEmpty($s)){0}else{ ([regex]::Matches($s,'\b[\p{L}\p{N}][\p{L}\p{N}\-\'']*\b','IgnoreCase')).Count } }

Push-Location $Repo
try{
  $statusDir = Join-Path $Repo "docs\status"; [IO.Directory]::CreateDirectory($statusDir)|Out-Null
  $docExts = ".md",".markdown",".txt",".rst",".adoc",".html",".htm"
  $allFiles = Get-ChildItem -Recurse -File
  $textDocs = $allFiles | ? { $docExts -contains $_.Extension.ToLowerInvariant() }
  $words = 0; foreach($f in $textDocs){ $words += (WordCount (Get-Content -Raw -LiteralPath $f.FullName)) }
  $lfs = (& git lfs ls-files 2>$null | Measure-Object -Line).Lines
  $metrics = [pscustomobject]@{
    timestamp=(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    totalFiles=$allFiles.Count; textDocs=$textDocs.Count; totalWords=$words
    stubThreshold=$StubThreshold; lfsTracked=$lfs
  }
  $metrics | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 -Path (Join-Path $statusDir "metrics.json")
@"
# Repo Status / KPIs

- **Timestamp:** $($metrics.timestamp)
- **Files:** $($metrics.totalFiles)
- **Text docs:** $($metrics.textDocs)
- **Total words (approx):** $($metrics.totalWords)
- **Stub threshold:** $StubThreshold
- **LFS objects (working copy):** $lfs
"@ | Set-Content -Encoding UTF8 -Path (Join-Path $statusDir "README.md")
  git add docs/status; git commit -m "status: KPIs snapshot" 2>$null | Out-Null
  Write-Host "KPIs written."
} finally { Pop-Location }
