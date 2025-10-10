param([int]$Port = 7681)
# Very small mock backend for UI bootstrap. Not production.
Add-Type -AssemblyName System.Net.HttpListener

$prefix = "http://127.0.0.1:{0}/" -f $Port
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Host "Mock backend listening at $prefix (Ctrl+C to stop)" -ForegroundColor Cyan

function Write-Json($ctx, $obj, [int]$status=200){
  $bytes = [System.Text.Encoding]::UTF8.GetBytes(($obj | ConvertTo-Json -Depth 8))
  $ctx.Response.StatusCode = $status
  $ctx.Response.ContentType = "application/json"
  $ctx.Response.ContentLength64 = $bytes.Length
  $ctx.Response.OutputStream.Write($bytes,0,$bytes.Length)
  $ctx.Response.OutputStream.Close()
}

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $path = $ctx.Request.Url.AbsolutePath.ToLowerInvariant()

    switch ($path) {
      "/"         { Write-Json $ctx @{ ok=$true; name="MockBackend"; time=(Get-Date).ToString("o") } }
      "/health"   { Write-Json $ctx @{ status="ok"; time=(Get-Date).ToString("o") } }
      "/version"  { Write-Json $ctx @{ version="mock-0.1"; api="v0" } }
      default     { Write-Json $ctx @{ error="not_found"; path=$path } 404 }
    }
  }
} finally {
  $listener.Stop()
  $listener.Close()
}
