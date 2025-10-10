param([int]$Port = 7681, [string]$Root = "")
$ErrorActionPreference = 'Stop'
if(-not $Root -or -not (Test-Path $Root)){
  $Root = Join-Path (Split-Path -Parent (Split-Path -Parent $PSCommandPath)) "www"
}
if(!(Test-Path $Root)){ throw "Static root not found: $Root" }
Add-Type -AssemblyName System.Net.Primitives, System.Net.Sockets
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
$listener.Start()
Write-Host ("📡 Static backend listening on http://127.0.0.1:{0}/  (root: {1})" -f $Port, $Root) -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop." -ForegroundColor Yellow

$mime = @{
  ".html"="text/html"; ".htm"="text/html"; ".js"="application/javascript"; ".css"="text/css";
  ".json"="application/json"; ".svg"="image/svg+xml"; ".png"="image/png"; ".jpg"="image/jpeg"; ".jpeg"="image/jpeg"
}

function Send-Response([System.Net.Sockets.TcpClient]$client, [int]$code, [string]$status, [byte[]]$body, [string]$contentType="text/plain"){
  $stream = $client.GetStream()
  $headers = ("HTTP/1.1 {0} {1}`r`nContent-Type: {2}`r`nContent-Length: {3}`r`nConnection: close`r`n`r`n" -f $code, $status, $contentType, $body.Length)
  $buf = [System.Text.Encoding]::UTF8.GetBytes($headers)
  $stream.Write($buf,0,$buf.Length)
  if($body.Length -gt 0){ $stream.Write($body,0,$body.Length) }
  $stream.Flush()
  $client.Close()
}

while ($true){
  try{
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()
    $reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
    $requestLine = $reader.ReadLine()
    if(-not $requestLine){ $client.Close(); continue }
    $parts = $requestLine.Split(' ')
    $path  = [uri]::UnescapeDataString(($parts[1] -split '\?')[0])
    if($path -eq "/"){ $path = "/index.html" }
    $fsPath = Join-Path $Root ($path.TrimStart("/") -replace "[/\\]+","/")
    if(!(Test-Path $fsPath)){
      $body = [System.Text.Encoding]::UTF8.GetBytes("Not Found")
      Send-Response $client 404 "Not Found" $body "text/plain"; continue
    }
    $bytes = [System.IO.File]::ReadAllBytes($fsPath)
    $ext = [System.IO.Path]::GetExtension($fsPath).ToLowerInvariant()
    $ct = $mime[$ext]; if(-not $ct){ $ct="application/octet-stream" }
    Send-Response $client 200 "OK" $bytes $ct
  } catch {
    try{ if($client){ $client.Close() } }catch{}
  }
}
