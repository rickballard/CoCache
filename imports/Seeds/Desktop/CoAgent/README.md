# CoAgent (Consolidated Proto‑Repo)

This folder consolidates the three CoAgent folders from your desktop into **one** organized tree, preserves all originals under `archive/original_input/`, and adds tooling for **private encryption**, public redaction, feedback, and growth.

## Safe Setup
1. Unzip this package to **Desktop\CoAgent_Consolidated**.
2. Review the structure. Your **unaltered originals** are under `archive/original_input/`.
3. When satisfied, rename to **Desktop\CoAgent** (or merge into your existing folder).

## Private Materials
- Place plaintext private docs under `docs/private/` (git‑ignored).
- Create an encrypted archive (header‑encrypted) with:
  ```powershell
  & "$HOME\Desktop\CoAgent\tools\Protect-Private.ps1"  # passphrase prompt or provide -Password
  ```
- You may commit the **.7z** to a public repo; filenames are hidden. Use “Rick2025” for now; rotate later.

## Public Business Plan
- Edit `docs/private/CoAgent_BusinessPlan_PRIVATE_v2.md`.
- Generate public-safe draft:
  ```powershell
  & "$HOME\Desktop\CoAgent\tools\Export-Public-BP.ps1"
  ```

## Feedback & Donations
- See `docs/Feedback_And_Donations.md` and `schemas/feedback.schema.json` for structure.
- Consider GitHub Sponsors / Ko‑fi; add `.github/FUNDING.yml` when ready.

## Roadmap & GTM
- `docs/ROADMAP_NextSprints.md`, `docs/GTM_Motion.md`, `docs/Telemetry_Privacy.md`.

## CoModules
- Concept modules live in a separate repo; curated modules can be vendored here under `modules/` when stable.
- Included: `modules/CoProfile/seed/` if provided.

---

**Generated:** 2025-09-10T21:33:59.503424
