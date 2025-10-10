Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scroll = Join-Path $PSScriptRoot '..\\HH\\megascroll.md'
if (!(Test-Path $scroll)) { throw "❌ megascroll.md not found at expected location." }

$content = Get-Content $scroll -Raw

# Strip YAML aliases from frontmatter
$content = $content -replace '&[a-zA-Z0-9_-]+', ''
$content = $content -replace '\\*+[a-zA-Z0-9_-]+', ''

# Ensure clean title block
if ($content -notmatch '^---\\s*\\ntitle:') {
  $prepend = @"
---
title: Hitchhiker Plan
author: Azoic
editor: Azoic
---

"@
  $content = $prepend + $content
}

Set-Content $scroll $content -Encoding UTF8
Write-Host "✅ Patched megascroll.md YAML frontmatter as Azoic."
