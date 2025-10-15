param(
  [string]$RepoPath = "$HOME\Documents\GitHub\CoCache",
  [string[]]$Include = @("*.md","*.pdf","*.zip","*.yml","*.yaml","*.json"),
  [string[]]$ExcludeDirs = @(".git",".github","node_modules",".pytest_cache",".venv","dist","build")
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
Push-Location $RepoPath
try{
  $root = Convert-Path .
  $files = Get-ChildItem -Recurse -File -Include $Include | Where-Object {
    $relDir = $_.DirectoryName.Substring($root.Length).TrimStart('\','/')
    -not (($ExcludeDirs | ForEach-Object { $relDir -split '[\\/]' -contains $_ }) -contains $true)
  }
  $items = @()
  foreach($f in $files){
    $rel = ($f.FullName.Substring($root.Length+1) -replace '\\','/')
    $name = $f.Name
    $stamp = $null
    if($name -match '_(\d{4}-\d{2}-\d{2})_(\d{6})'){ $stamp = "$($Matches[1])_$($Matches[2])" }
    elseif($name -match '_(\d{8})_(\d{6})'){ $d=$Matches[1]; $t=$Matches[2]; $stamp = "{0}-{1}-{2}_{3}" -f $d.Substring(0,4),$d.Substring(4,2),$d.Substring(6,2),$t }

    $ext = $f.Extension.ToLower()
    $kind = switch -regex ($ext){
      '\.md'   {'markdown'}
      '\.pdf'  {'pdf'}
      '\.zip'  {'archive'}
      '\.ya?ml'{ 'config'}
      '\.json' {'data'}
      default  {'blob'}
    }

    $words=$null; $heads=@()
    if($kind -eq 'markdown'){
      $txt = Get-Content $f.FullName -Raw
      $words = ($txt -split '\s+').Count
      $heads = ($txt -split "`n") | Where-Object { $_ -match '^\s*#' } | ForEach-Object { $_.Trim() }
    }

    $tags = @()
    if($rel -match '(?i)genexis'){ $tags += 'genexis' }
    if($rel -match '(?i)civium|cociv'){ $tags += 'civium' }
    if($rel -match '(?i)advice_bombs'){ $tags += 'advice_bomb' }

    $items += [pscustomobject]@{
      id       = [Guid]::NewGuid().ToString()
      path     = $rel
      name     = $name
      kind     = $kind
      origin   = $env.COMPUTERNAME
      stamp    = $stamp
      semver   = $null
      state    = 'draft'
      tags     = ($tags -join ',')
      bytes    = $f.Length
      words    = $words
      headings = ($heads -join ' | ')
      lineage  = ''
    }
  }
  New-Item -ItemType Directory -Force index | Out-Null
  $csv = Join-Path index "va_manifest.csv"
  $json= Join-Path index "va_manifest.json"
  $items | Sort-Object path | Export-Csv -NoTypeInformation -Encoding UTF8 $csv
  $items | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 $json
  Write-Host "VA index written: index/va_manifest.csv, index/va_manifest.json" -f Green
}
finally{ Pop-Location }
