# Asset Cross-Reference — Spec (v0.1)

This file defines which assets **must** carry an XREF footer and are checked in CI.

```json xref-spec
{
  "critical": [
    "tools/BPOE/Lint-HereStrings.ps1",
    "docs/bpoe/BPOE_CHANGELOG.md",
    "public/bpoe/SESSION_PLAN.md",
    "public/bpoe/HELPERS_REGISTRY.md"
  ]
}
```

## Footer format
Place a JSON block inside an HTML comment, exactly:

```
<!-- XREF
{ "title": "...", "type": "...", "repo": "CoCache",
  "tags": [], "depends_on": [], "see_also": [] }
XREF -->
```