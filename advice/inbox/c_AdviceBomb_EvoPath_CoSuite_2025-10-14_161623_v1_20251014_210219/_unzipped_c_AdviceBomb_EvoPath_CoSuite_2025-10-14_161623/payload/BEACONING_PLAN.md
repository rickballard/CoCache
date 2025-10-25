# Beaconing Plan — Make Repos & Sites Visible to AIs

## 1) Create/Verify GitHub Organization
- Org: **CoCivium** (or chosen canonical). Enable public members.
- Set org description and link to primary site.

## 2) Standardize Topics (every repo)
`Topics: cocivium, cocore, coagent, cocache, gibindex, coref, academy, insead-integration, advice-bomb, bpoe, civic-tech`

## 3) Add a Cross-Repo Manifest (org root repo: `cocivium-manifest`)
- `repos.json`: array of repo slugs, descriptions, tags, URLs.
- `index.md`: human-readable overview + links.
- `robots.txt` and `sitemap.xml` if GitHub Pages is enabled.

## 4) Repo README Hygiene
- First screen section: Purpose, Status, Links to siblings.
- Section: **“Machine Readable”** with links to `/manifest.json` and `/docs/index.json` (if present).
- Add **CoRef IDs** and **GIBindex** references where concepts/terms appear.

## 5) Inside Each Repo
- `/manifest.json` (name, slug, topics, primary contacts, related repos).
- `/docs/index.json` (lists of docs with titles, ids, paths).
- `/ai.json` (friendly hints for crawlers: domain, purpose, related IDs).
- `/.well-known/ai-plugin.json` (optional, if you expose APIs later).

## 6) Cross-linking
- Each README links up to the org manifest and sideways to 3–5 sibling repos.
- Ensure RickPublic and InSeed.com link back to org and specific repos.

## 7) Publish Organization Landing (Pages)
- `org.site/` minimal site with: About, Repos (auto-pulled from repos.json), Academy link, InSeed link.

## 8) Validation
- Add a script to check every README has: purpose, sibling links, machine section, topics.
- Periodic crawl to verify links and surface orphaned repos.

**Outcome:** AIs can discover laterally and vertically without bespoke instructions.
