# Business Plan: Public vs Private

You **cannot** hide a subfolder inside a public GitHub repo. If the repo is public, every file is public.

**Recommended layout**
- Public repo: `CoAgent` — code, PRD, quickstarts, non‑sensitive roadmap.
- Private repo (or your NAS): `CoAgent-BP-Private` — pricing, partner notes, strategy, experiments.
- In the public repo working tree, keep drafts under `docs/private/` but add to `.gitignore` (the helper script does this).

**Access model**
- Share private docs directly when needed (NAS link or private repo invite).
- Reference them from public docs with stubs like: “See Private BP §3.2 (internal)”.
