
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)][string]$SourceRoot,
    [string]$StagingRepo = "$env:USERPROFILE\Documents\GitHub\CoCivium",
    [string]$OutRelDir   = "docs\cowrap-intake",
    [string]$BranchPrefix= "cowrap/generic-intake",
    [string]$BackchatTo  = "Grand Migration - vNext",
    [switch]$EmitBackchat
  )
  Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

  . "$env:USERPROFILE\Downloads\CoAgent_Bootstrap\scripts\Common.ps1"
  function _Safe([string]$s){ CoSafeName $s }

  # 1) validate staging repo
  if (-not (Test-Path (Join-Path $StagingRepo '.git'))) { throw "Staging repo is not a git repo: $StagingRepo" }

  # 2) resolve source root
  $SourceRoot = [IO.Path]::GetFullPath($SourceRoot)
  if (-not (Test-Path $SourceRoot)) { throw "SourceRoot not found: $SourceRoot" }

  # 3) find package-style folders (README.md / STATUS etc.)
  $markers  = @('README.md','Achievements.md','KnownIssues.md','NextSteps.md','Workflows.md','STATUS')
  $packages = Get-ChildItem $SourceRoot -Directory -Recurse | Where-Object {
    $p=$_; ($markers | ForEach-Object { Test-Path (Join-Path $p.FullName $_) }) -contains $true
  }
  if(-not $packages){ throw "No package-style CoWrap folders under $SourceRoot" }

  # 4) prepare intake dirs
  $ts        = CoTsFile
  $intakeRel = Join-Path $OutRelDir ("generic_intake_" + $ts)
  $intakeDir = Join-Path $StagingRepo $intakeRel
  $perPkgDir = Join-Path $intakeDir 'packages'
  [IO.Directory]::CreateDirectory($perPkgDir) | Out-Null

  # 5) synthesize summaries
  $top = New-Object System.Text.StringBuilder
  $null = $top.AppendLine("# CoWrap Generic Intake - " + (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))
  $null = $top.AppendLine()
  $all = @()

  foreach($pkg in $packages){
    $pname  = _Safe $pkg.Name
    $dest   = Join-Path $perPkgDir $pname
    $raw    = Join-Path $dest 'raw'
    [IO.Directory]::CreateDirectory($raw) | Out-Null

    # copy raw (redact SECRETS.txt)
    $files = Get-ChildItem $pkg.FullName -Recurse -File
    foreach($f in $files){
      $rel = $f.FullName.Substring($pkg.FullName.Length).TrimStart('\')
      $tgt = Join-Path $raw $rel
      [IO.Directory]::CreateDirectory((Split-Path $tgt -Parent)) | Out-Null
      if ($f.Name -ieq 'SECRETS.txt') {
        [IO.File]::WriteAllText($tgt.Replace('SECRETS.txt','SECRETS.REDACTED.txt'),
          "*** REDACTED ***`r`nOriginal path: $($f.FullName)`r`n",[Text.Encoding]::UTF8)
      } else {
        Copy-Item $f.FullName $tgt -Force
      }
    }

    # package summary
    $ordered = @('README.md','Achievements.md','KnownIssues.md','NextSteps.md','Workflows.md')
    $sb = New-Object System.Text.StringBuilder
    $null = $sb.AppendLine("# $($pkg.Name) - Intake ($ts)")
    $null = $sb.AppendLine("Source: $($pkg.FullName)")
    $null = $sb.AppendLine()

    foreach($n in $ordered){
      $p = Join-Path $pkg.FullName $n
      if(Test-Path $p){
        $null = $sb.AppendLine("## $n")
        $null = $sb.AppendLine((Get-Content $p -Raw))
        $null = $sb.AppendLine()
      }
    }

    $statusDir = Join-Path $pkg.FullName 'STATUS'
    if(Test-Path $statusDir){
      $statusFiles = Get-ChildItem $statusDir -File -Filter *.txt | Where-Object { $_.Name -ne 'SECRETS.txt' }
      if($statusFiles){
        $null = $sb.AppendLine("## STATUS")
        foreach($sf in $statusFiles){
          $null = $sb.AppendLine("### $($sf.Name)")
          $null = $sb.AppendLine((Get-Content $sf.FullName -Raw))
          $null = $sb.AppendLine()
        }
      }
    }

    $repoHints = @()
    if(Test-Path $statusDir){
      $repoHints = Get-ChildItem $statusDir -File -Filter 'Repo_*.txt' |
                   ForEach-Object { (Get-Content $_.FullName -Raw) } |
                   ForEach-Object { $_ -split "`r?`n" } |
                   Where-Object { $_ -match '\S' } | Select-Object -Unique
    }

    $pkgSummaryPath = Join-Path $dest ($pname + '__' + $ts + '.md')
    [IO.Directory]::CreateDirectory((Split-Path $pkgSummaryPath -Parent)) | Out-Null
    [IO.File]::WriteAllText($pkgSummaryPath,$sb.ToString(),[Text.Encoding]::UTF8)

    $all += [pscustomobject]@{ Name=$pkg.Name; Path=$pkg.FullName; Summary=$pkgSummaryPath; RepoHints=$repoHints }
  }

  # 6) top-level SUMMARY.md
  $sumPath = Join-Path $intakeDir 'SUMMARY.md'
  [IO.Directory]::CreateDirectory((Split-Path $sumPath -Parent)) | Out-Null
  $null = $top.AppendLine("## Packages")
  foreach($x in $all){
    $rh = if($x.RepoHints -and $x.RepoHints.Count){ (' - repos: ' + (($x.RepoHints | Select-Object -First 3) -join '; ') + (if($x.RepoHints.Count -gt 3){' ...'} else {''})) } else { '' }
    $null = $top.AppendLine(("- {0} - {1}{2}" -f $x.Name,(Resolve-Path $x.Summary),$rh))
  }
  [IO.File]::WriteAllText($sumPath,$top.ToString(),[Text.Encoding]::UTF8)

  # 7) commit
  Push-Location $StagingRepo
  try{
    $branch = "$BranchPrefix-$ts"
    git switch -c $branch 2>$null; if($LASTEXITCODE -ne 0){ git switch $branch | Out-Null }
    git add $intakeRel
    git commit -m "cowrap generic intake: $($all.Count) package(s) staged at $intakeRel"
    if((git remote) -match '\S'){ git push -u origin $branch }
  } finally { Pop-Location }

  # 8) paste-ready summary
  $pastePath = $sumPath.Replace('.md','.paste.md')
  $paste = "> Generic Intake: $($all.Count) package(s) staged at `"$intakeRel`"`r`n---`r`n" + (Get-Content $sumPath -Raw)
  [IO.File]::WriteAllText($pastePath,$paste,[Text.Encoding]::UTF8)

  if($EmitBackchat){
    & "$env:USERPROFILE\Downloads\CoAgent_Bootstrap\scripts\CoBackchat.Emit.ps1" `
       -To $BackchatTo -Type 'handoff' -From 'CoWrap Generic Intake' -BodyFile $pastePath
  }

  Write-Host ("Intake complete:`n  Summary: {0}`n  Branch : {1}`n  Paste  : {2}" -f $sumPath,$branch,$pastePath)

