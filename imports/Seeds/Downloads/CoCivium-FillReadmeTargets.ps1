param([string]$RepoPath = "$HOME\Documents\GitHub\CoCivium")
Set-StrictMode -Version Latest; $ErrorActionPreference = "Stop"
Set-Location $RepoPath

$graph = Get-Content -Raw -LiteralPath "admin/index/link-graph.json" | ConvertFrom-Json
$targets = $graph.edges |
  Where-Object { $_.from -eq "README.md" -and -not $_.exists } |
  Where-Object { $_.to -match '\.md$' } |
  Where-Object { $_.to -notmatch '(^\.\./\.\./edit/)|(^\.\./\.\./issues/)|(\?template=)' }

$made = $false
foreach($t in $targets){
  $rel = ($t.to -replace '^/','') -replace '\\','/'
  $abs = Join-Path (Get-Location) ($rel -replace '/','\')
  $dir = Split-Path $abs
  if(-not (Test-Path $dir)){ New-Item -ItemType Directory -Force $dir | Out-Null }
  if(-not (Test-Path $abs)){
    $title = (Split-Path $abs -Leaf) -replace '\.md$','' -replace '[-_]+',' '
    $title = (Get-Culture).TextInfo.ToTitleCase($title.ToLower())
    $body  = "# $title (placeholder)`n`n_Status: placeholder. To be authored._"
    [IO.File]::WriteAllText($abs, ($body -replace "`r`n","`n"), [Text.UTF8Encoding]::new($false))
    git add -- "$rel"
    $made = $true
  }
}

if($made){
  git commit -m "docs: create placeholders for README targets (auto-generated)"
  git push -u origin HEAD
  if(Get-Command gh -ErrorAction SilentlyContinue){
    gh pr create -B main -t "Docs: placeholders so README links resolve" -b "Auto-created stubs for files linked from README. See admin/index for details."
  }
} else {
  Write-Host "No missing README targets to create."
}
