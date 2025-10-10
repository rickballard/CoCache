param([switch]$Strict)
$ErrorActionPreference='Stop'

function Try-LoadDotenv($path){
  if(Test-Path $path){
    Get-Content $path | ? {$_ -and $_ -notmatch "^\s*#"} | %{
      $k,$v = $_ -split "=",2
      if($k){ [Environment]::SetEnvironmentVariable($k.Trim(), $v.Trim(), "Process") }
    }
    return $true
  }
  return $false
}

# 1) local .env wins (fast path)
$loaded = Try-LoadDotenv ".env"

# 2) (later) Bitwarden fallback will be added here, when we harden.

if($Strict){
  $required = @("COAGENT_BOT_TOKEN")  # add as needed
  $missing = $required | ? { -not $env:$_ }
  if($missing.Count){ throw "Missing required secrets: $($missing -join ', ')" }
}
