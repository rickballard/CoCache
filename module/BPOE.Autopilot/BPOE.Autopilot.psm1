function Invoke-BPOEAssetsManifest {
  param([string]$Repo = (Resolve-Path .))
  $img = @(".png",".jpg",".jpeg",".webp",".svg",".gif")
  $out = Join-Path $Repo 'docs\assets'
  New-Item -ItemType Directory -Force -Path $out | Out-Null
  $items = Get-ChildItem -Path $Repo -Recurse -File | ? { $img -contains $_.Extension.ToLower() -and $_.FullName -notmatch '\\.git\\' } |
    Select-Object @{n='path';e={Resolve-Path -Relative $_.FullName}}, @{n='bytes';e={$_.Length}},
                  @{n='modified';e={$_.LastWriteTime.ToString('o')}}, @{n='alt';e={""}}, @{n='placement';e={""}}, @{n='license';e={""}}
  $json = Join-Path $out 'manifest.json'; $md = Join-Path $out 'manifest.md'
  $items | ConvertTo-Json -Depth 5 | Set-Content -Path $json -Encoding UTF8
  ("# Assets Manifest`n`n" + ($items | ForEach-Object { "* `{0}` — **{1} bytes** — _{2}_".Replace("{0}",$_.path).Replace("{1}",$_.bytes).Replace("{2}",$_.modified) } | Out-String)) |
    Set-Content -Path $md -Encoding UTF8
}

function Test-BPOERepoSmoke {
  param([string]$Repo = (Resolve-Path .), [switch]$FailOnExternalLinks)
  $errors = @()
  $mds = Get-ChildItem -Path $Repo -Recurse -Include *.md -File | ? { $_.FullName -notmatch '\\.git\\' }
  foreach ($md in $mds) {
    $txt = Get-Content -Raw -Path $md.FullName -Encoding UTF8; if (!$txt) { $txt = "" }
    foreach ($m in [regex]::Matches($txt, '!\[[^\]]*\]\(([^)]+)\)')) {
      $u = $m.Groups[1].Value
      if ($u -notmatch '^(https?:)?//') {
        $p = Join-Path (Split-Path $md.FullName -Parent) $u
        if (-not (Test-Path $p)) { $errors += "Missing image '$u' in $($md.Name)" }
      }
    }
    if ($FailOnExternalLinks) {
      foreach ($m in [regex]::Matches($txt, '\[[^\]]+\]\(([^)]+)\)')) {
        $u = $m.Groups[1].Value
        if ($u -match '^https?://') { try { Invoke-WebRequest -Uri $u -Method Head -TimeoutSec 8 | Out-Null } catch { $errors += "External 404 '$u' in $($md.Name)" } }
      }
    }
  }
  if ($errors.Count) { throw "SMOKE FAIL:`n$($errors -join "`n")" } else { "SMOKE OK" }
}

Export-ModuleMember -Function Invoke-BPOEAssetsManifest, Test-BPOERepoSmoke

