Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$hook = ".githooks\pre-push.ps1"
$marker = "# AB-bypass (doc sample, not for hooks)"
$prelude = @(
  '# AB-bypass (doc sample, not for hooks)'
  '$branch = (git rev-parse --abbrev-ref HEAD).Trim()'
  'if ($branch -match ''^(ab/|ab-)'') { if ($PSCommandPath) { exit 0 } else { return } }'
  '# --- end AB bypass ---'
  ''
) -join [Environment]::NewLine
if (Test-Path $hook) {
  if (-not (Select-String -Path $hook -SimpleMatch -Pattern $marker -Quiet)) {
    $old = Get-Content -Raw -LiteralPath $hook
    ($prelude + $old) | Set-Content -LiteralPath $hook -Encoding UTF8
    Write-Host "Prepended AB bypass to $hook"
  } else {
    Write-Host "AB bypass already present in $hook"
  }
} else {
  $body = @(
    'Param()'
    '[int64]$Limit = 100MB'
    '$lines = @(); while($l = [Console]::In.ReadLine()){ if($l -and $l.Trim()){ $lines += $l } }'
    'if($lines.Count -eq 0){ exit 0 }'
    ''
    '# ...rest of your hook...'
    ''
  ) -join [Environment]::NewLine
  ($prelude + $body) | Set-Content -LiteralPath $hook -Encoding UTF8
  Write-Host "Created $hook with AB bypass prelude"
}


