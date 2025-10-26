# CoSuite External Assets Advisory (v0.1)

**Purpose:** Curate external APIs, datasets, and standards we can leverage to accelerate CoSuite without reinventing wheels.
Each item notes **how to use**, **why we need it**, **cost/licensing**, **integration notes/risks**, and a **priority**.

---

## Prioritization rubric
- **Priority**: P0 (blocker/now), P1 (next), P2 (later), P3 (park).
- **Urgency**: Now (0–30 days), Next (1–2 quarters), Later (>2 quarters).
- **Leverage**: High/Med/Low. **Risk**: data quality, rate limits, TOS/licensing, sustainability.

---

## 1) Identity, Entity & Graph Backbone
- **GLEIF LEI API** — entity IDs; normalize legal entities; free; nightly sync; **P0**
- **OpenCorporates API** — registry/company/officers; broad coverage; free+paid; rate-limits; **P0**
- **Open Ownership (BODS)** — beneficial ownership; transparency; free; **P1**
- **ORCID** — researcher IDs; auth linkage; free; **P1**
- **ROR** — institution IDs; clean affiliations; free; **P1**
- **Wikidata / VIAF / ISNI** — multilingual enrichment; **P2**

## 2) Scholarly & Knowledge Graph
- **OpenAlex** — scholarly graph; evidence; free; **P0**
- **Crossref** — DOIs & events; provenance; free; etiquette header; **P0**
- **DataCite** — dataset/software DOIs; linkage; free; **P1**
- **arXiv** — preprints; fast signal; free; **P1**
- **Unpaywall / DOAJ / CORE** — OA status/journals/repos; **P1–P2**
- **Zenodo** — artifact hosting/DOIs; **P2**

## 3) News, Web & Claim-Checking
- **GDELT 2.0** — media/events monitoring; **P1**
- **Google Fact Check Tools** — ClaimReview; **P1**
- **Hypothes.is** — public/private annotations; **P2**
- **Wayback CDX / Common Crawl Index** — snapshots & discovery; **P0/P2**
- **Openverse** — CC media for UI; **P2**

## 4) Civic/Legal/Regulatory
- **SEC EDGAR** — filings & XBRL; **P0**
- **GovInfo (US)** / **EUR-Lex (EU)** / **legislation.gov.uk (UK)** / **CanLII (CA)** — statutes/regs/cases; **P1**
- **Companies House (UK)** — registry/officers/filings; **P1**
- **Open States + OCD IDs (US)** — state bills & normalized divisions; **P2**
- **OCCRP Aleph** — investigations; **P2**

## 5) Macro, Trade & Socio-economic (SDMX-friendly)
- **World Bank**, **OECD**, **Statistics Canada (WDS/RDaaS)**, **IMF**, **FRED**, **ECB**, **FAOSTAT**, **ILOSTAT** — authoritative indicators; **P1**

## 6) Geospatial & Environmental
- **OpenStreetMap (Overpass/Nominatim)**, **Pelias**, **OpenRouteService**, **MapLibre**, **Natural Earth** — geocoding/routing/maps; **P1**
- **Copernicus Data Space / NASA Earthdata** — remote sensing; **P2**
- **Open-Meteo / Meteostat** — weather; **P2**

## 7) Data Quality, Security & Provenance
- **W3C PROV-O**, **DCAT v3**, **SKOS** — lineage/catalog/vocabs; **P0**
- **Great Expectations (GX OSS)** — data tests; **P0**
- **OSV.dev** — dependency vulnerability scans; **P0**
- **OpenRefine** — cleanup & reconciliation; **P1**
- **Open Badges 3.0** — contributor attestations; **P2**

---

## 30–60 day Minimum Viable Asset Pack
1) **Entity Backbone:** GLEIF, OpenCorporates, ROR, ORCID, Open Ownership (where available)
2) **Evidence & Knowledge:** OpenAlex, Crossref, DataCite, arXiv, Unpaywall
3) **Claims & Web Provenance:** GDELT, Fact Check Tools, Wayback/CDX, Hypothes.is (read)
4) **Civic/Regulatory:** SEC EDGAR; GovInfo/EUR-Lex/legislation.gov.uk/CanLII; Companies House
5) **Indicators:** World Bank, OECD, StatsCan, IMF, FRED, ECB
6) **Geo:** OSM (Overpass/Nominatim), MapLibre, OpenRouteService, Natural Earth
7) **Quality/Security:** PROV-O/DCAT/SKOS, Great Expectations, OSV; OpenRefine for ops

---

## Integration Checklist (per source)
- Contract review (SLA/limits/auth/licensing)
- Schema map → CoCore (entities/events/sources)
- PROV capture at extract/transform/load; retain raw; checksums
- Monitoring (quota/latency/change-watch), retries/backoff
- Caching/materialization strategy; batch deltas
- GX validations; drift tests; PII handling
- Docs/playbook with example queries

