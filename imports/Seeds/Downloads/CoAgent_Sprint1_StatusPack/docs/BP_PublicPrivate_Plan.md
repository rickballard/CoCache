# Business Plan: Public vs Private Split

**Fact:** A public GitHub repo cannot have a truly private subfolder. Everything in a public repo is public.

## Recommended
- **Public repo**: `CoAgent` → code, public docs (positioning, PRD outline, quickstarts)
- **Private repo**: `CoAgent-BP-Private` → detailed business plan, pricing experiments, sensitive research
  - Optionally reference public issues/PRs by link
- **(Optional)** Encrypted bundle in public (e.g., passworded zip) is possible but risky; you must not publish the key

## Practical Steps
1) Create/confirm the two repos (one public, one private)
2) Keep `docs/private/` out of the public repo via `.gitignore` if you keep drafts locally
3) Use the included `Harvest-CoTemp-ToRepo.ps1` only for **public**-safe docs
