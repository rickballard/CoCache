# XREF Guard Pack

Contents:
- `.github/workflows/bpoe-asset-xref.yml` — CI to validate XREF footers and publish a Mermaid graph.
- `tools/BPOE/Lint-AssetXref.ps1` — local/CI linter.
- `tools/BPOE/Render-XrefGraph.ps1` — emits `docs/bpoe/xref-graph.mmd`.
- `docs/bpoe/ASSET_XREF_SCHEMA.json` — minimal schema.
- `docs/bpoe/ASSET_XREF_SPEC.md` — which files are enforced.

## Quick install
1) Unzip into repo root.
2) Commit on a short branch, push, open PR.
3) CI will fail if critical assets lack valid XREF footers.