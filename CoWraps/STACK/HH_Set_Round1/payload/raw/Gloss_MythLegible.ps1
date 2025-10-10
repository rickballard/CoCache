
Set-StrictMode -Version Latest
$File = Join-Path $env:USERPROFILE 'Documents\GitHub\Godspawn\HH\gloss\meta_legible_myth.md'
@'
---
term: Meta-Legible Myth
scope: HH
export_to_gibindex: true
related: myth_legibility, symbolic_scaffolding
first_use: HH/0006_Mythframe.md
readable_synonym: self-aware story
---

A myth that encodes its own structure, purpose, and vulnerability.

Meta-legible myths reveal **how myths work**, not just what they say.
They’re stories that contain a mirror — enabling **debugging** of belief systems.

Useful for:
- Navigating myth collapse
- Training hybrid intelligences
- Building transparent civilizational scaffolds

If a myth can debug itself, it can survive transformation.
'@ | Set-Content -Encoding UTF8 -Path $File
