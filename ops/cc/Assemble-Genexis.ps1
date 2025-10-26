param([string]$RepoPath="$HOME\Documents\GitHub\CoCache",[string]$OutPath="CC/sections/Genexis.md")
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
Push-Location $RepoPath
try{
  if(-not (Test-Path "index/va_manifest.csv")){ throw "Run ops/va/Build-VAIndex.ps1 first." }
  $manifest = Import-Csv "index/va_manifest.csv"
  $candidates = $manifest | Where-Object { $_.path -match '(?i)genexis' -and $_.kind -eq 'markdown' }
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.AppendLine("# Genexis")
  [void]$sb.AppendLine("Last updated: $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss zzz'))")
  [void]$sb.AppendLine()
  [void]$sb.AppendLine("> Assembled from VA manifest; curate freely.")
  [void]$sb.AppendLine()
  foreach($row in ($candidates | Sort-Object path)){
    $full = Join-Path (Get-Location) $row.path
    [void]$sb.AppendLine("---")
    [void]$sb.AppendLine(("## Source: {0}" -f $row.path))
    if(Test-Path $full){ (Get-Content $full -Raw) | ForEach-Object { [void]$sb.AppendLine($_) } }
    else { [void]$sb.AppendLine(("_missing: {0}_" -f $row.path)) }
    [void]$sb.AppendLine("")
  }
  [IO.File]::WriteAllText($OutPath, $sb.ToString(), $utf8NoBom)
  Write-Host "Wrote $OutPath" -f Green
}
finally{ Pop-Location }

