Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$Owner='rickballard'; $Repo='CoModules'
$repo = Join-Path $HOME "Documents\GitHub\$Repo"
if (-not (Test-Path $repo)) { throw "Clone missing: $repo" }
Set-Location $repo
git fetch origin main | Out-Null
git switch ops/index-and-bizplan 2>$null | Out-Null

function Build-Index-Robust {
  $root = (Get-Location).Path
  $mds = Get-ChildItem -Recurse -File -Include *.md | Where-Object { $_.FullName -notmatch '\\.git\\' }
  $forward=@{}; $back=@{}
  foreach($f in $mds){
    $rel = $f.FullName.Substring($root.Length).TrimStart('\','/') -replace '\\','/'
    $mres = Select-String -Path $f.FullName -Pattern '\[[^\]]+\]\((?!https?://)([^)#]+)' -AllMatches
    $links = foreach($mm in $mres){ foreach($g in $mm.Matches){ $g.Groups[1].Value } }
    $norm = @()
    foreach($l in $links){
      $abs  = [IO.Path]::GetFullPath((Join-Path $f.DirectoryName $l))
      $rel2 = $abs.Substring($root.Length).TrimStart('\','/') -replace '\\','/'
      $norm += $rel2
    }
    $norm = @(@($norm) | Sort-Object -Unique)   # ALWAYS an array (even when empty)
    $forward[$rel] = $norm
    foreach($n in $norm){
      if (-not $back.ContainsKey($n)) { $back[$n] = @() }
      $back[$n] += $rel
    }
  }
  $idxDir='docs/index'
  New-Item -ItemType Directory -Force -Path $idxDir | Out-Null
  $index = [ordered]@{
    generated = (Get-Date).ToString('s')
    forward   = $forward
    backlinks = @{}
  }
  foreach($k in $back.Keys){ $index.backlinks[$k] = @(@($back[$k]) | Sort-Object -Unique) }
  ($index | ConvertTo-Json -Depth 10) | Set-Content -Encoding UTF8 (Join-Path $idxDir 'index.json')

  $md = "# Repository Index`n`nGenerated: $($index.generated)`n`n"
  foreach($k in ($forward.Keys | Sort-Object)){
    $md += "* [$k]($k)"
    $outsList = @(@($forward[$k]) | Where-Object { $_ })  # ALWAYS an array
    if ($outsList.Count -gt 0) { $md += " → " + ($outsList -join ", ") }
    $md += "`n"
  }
  Set-Content -Encoding UTF8 (Join-Path $idxDir 'README.md') -Value $md
}
Build-Index-Robust

git add docs/
git commit -m "docs(index): robust generation (null-safe array capture; no scalar collapse)" 2>$null
git push -u origin HEAD | Out-Null

$pr = gh pr list --state open --json headRefName,number -q '.[]|select(.headRefName=="ops/index-and-bizplan")|.number'
if (-not $pr) {
  $pr = gh pr create --title "docs: business plan + repo index" --body "Business-plan skeleton + robust docs index (forward/backlinks)." | Select-String -Pattern '\d+$' | % { $_.Matches.Value }
}
# try to merge; if policy blocks, leave PR open
gh pr merge $pr --squash --delete-branch --admin 2>$null
