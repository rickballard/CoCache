# Orgs Module (Exemplars / Sponsors)

## Goal
Mirror the Thinkers gallery with **organizations** (nonprofits, labs, agencies, companies, foundations). Cards link to a deep-dive sheet hosted by CoCore.

## Steps

1. **Create the dataset in CoCore**
   - Path (recommended): `CoCore/best-practices/orgs/orgs.json`
   - See `orgs.sample.json` and `org.footprint.schema.json`.

2. **Generate sheets in CoCore**
   ```powershell
   .\Generate-OrgsSheets.ps1 -CoCore "$env:USERPROFILE\Documents\GitHub\CoCore"
   # commit/push CoCore after generation
   ```

3. **Create a CoPolitic page**
   - Copy `OrgsPage.template.html` → `CoPolitic/docs/orgs/index.html`.
   - Ensure the `fetch(...)` URL points at your CoCore CDN (or pinned commit).

4. **Add nav link on CoPolitic home (optional)**
   - Add `<a href='orgs/'>Organizations</a>` to `docs/index.html`.

## Data shape (summary)
See `org.footprint.schema.json` for the full schema.

Key fields:
- `name`, `kind` (enum),
- `domains` (UI topic domains), `system_domains` (CoCore systems),
- `alignment.fit|summary`,
- `logo_url`, `website`, `sheet_url`,
- `sources[]`, `provenance.last_checked`.

