# BPOE — Steward Merge & Main-First Policy

- Seeding work lands on **main** by default when you (steward) are the author.
- Topic branches allowed only when CI or long review is required; auto-merge to main when checks pass.
- Pre-commit hooks **must not block**; CI performs renders and heavy checks.
- Inkscape optional locally; CI renders PNGs from SVG.
- Add a `land-on-main` workflow: if PR author is steward, allow fast-forward or squash-to-main.
