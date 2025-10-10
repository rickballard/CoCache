param(
  [Parameter(Mandatory)][string]$OutFile,
  [int]$TotalParts = 6,
  [int]$DelayMs = 700
)
$parts = @(
  "<# ---",
  "title: `"DO-slowly-rendered`"",
  "risk: { writes: false, network: false, secrets: false, destructive: false }",
  "--- #>",
  "# [PASTE IN POWERSHELL]",
  "Write-Host `"Hello from slowly rendered DO`""
)
Remove-Item -Force $OutFile -ErrorAction SilentlyContinue
for ($i=0; $i -lt [Math]::Min($TotalParts,$parts.Count); $i++) {
  Add-Content -Encoding UTF8 $OutFile $parts[$i]
  Start-Sleep -Milliseconds $DelayMs
}
