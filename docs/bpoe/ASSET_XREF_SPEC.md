# BPOE Asset Cross-Reference Spec (v0.1)

**Goal:** keep critical assets co-evolving by embedding lightweight cross-references directly in files, then validating in CI.

## Footer marker
Add a JSON block between the markers at the end of any critical asset:

```html
<!-- XREF
{
  "title": "CoPatience helper",
  "type": "helper",
  "repo": "CoCache",
  "tags": ["ux","patience","dots"],
  "depends_on": [
    "tools/BPOE/Scan-DoBlocks.ps1"
  ],
  "see_also": [
    "public/bpoe/HELPERS_REGISTRY.md"
  ]
}
XREF -->
```

- `depends_on`: assets this file logically depends on.
- `see_also`: neighbors that should be updated/reviewed together.
- CI emits a **warning** if `A.depends_on B` but `B.see_also` does not include `A`. Tighten later to errors.

## Outputs
- `public/bpoe/ASSET_GRAPH.json` — machine graph (nodes/edges/warnings)
- `public/bpoe/ASSET_GRAPH.md` — human summary

## Rollout notes
- Start as **non-blocking**; flip to blocking after coverage improves.
- Prefer adding markers to **systematization-layer** assets first: guards, schemas, registries, governance docs.
