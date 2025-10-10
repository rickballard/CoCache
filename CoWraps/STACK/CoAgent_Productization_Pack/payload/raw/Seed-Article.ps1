# Seed-Article.ps1
param([Parameter(Mandatory=$true)][string]$RickPublicPath)
Set-Location $RickPublicPath
New-Item -ItemType Directory -Force -Path .\articles | Out-Null
@'
---
title: "DonDemogog"
date: "2025-09-14"
tags: [governance, corruption, cocivium]
---

# DonDemogog

- **Conjoint term, two caps.**
  - **Don** → gangster boss (fear, capture)
  - **Demogog** → manipulative populist (crisis-for-power)
  - **DonDemogog** → political gangster who *manufactures crisis* and *hijacks institutions*.
'@ | Set-Content .\articles\don-demogog.md -Encoding UTF8
git add .\articles\don-demogog.md
git commit -m "articles: add DonDemogog (concise)"
git push
