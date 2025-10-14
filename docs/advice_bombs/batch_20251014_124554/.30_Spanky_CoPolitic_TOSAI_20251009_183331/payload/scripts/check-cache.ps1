param([string]$Url = "https://copolitic.org/?nocache=$([guid]::NewGuid())")
$h = Invoke-WebRequest $Url -UseBasicParsing -Headers @{ "Cache-Control"="no-cache"; "Pragma"="no-cache" }
$age  = ($h.Headers["Age"]        | Select-Object -First 1)
$etag = ($h.Headers["ETag"]       | Select-Object -First 1)
$node = ($h.Headers["X-Served-By"]| Select-Object -First 1)
"Age=$age  ETag=$etag  Node=$node"
if ([int]($age | ForEach-Object { $_ -as [int] }) -gt 5) { Write-Warning "Edge cache looks warm (>5s). Try again shortly." }
if ($h.Content -notmatch '<section id="exemplars"') { Write-Warning "Exemplar grid not detected in HTML." }
