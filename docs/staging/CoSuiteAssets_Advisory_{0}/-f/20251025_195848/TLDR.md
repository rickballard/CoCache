# TL;DR — What to do now

**Ship P0 in this order:**
1) Wire **PROV-O / DCAT / SKOS** into CoCore; define adapter manifest; require lineage.
2) Stand up **Entity Backbone**: GLEIF LEI + OpenCorporates (+ ROR/ORCID for research scope).
3) Build **Evidence Graph**: OpenAlex + Crossref (+ DataCite for datasets/software).
4) Add **Reg/Legal**: SEC EDGAR; GovInfo (US); EUR-Lex (EU); legislation.gov.uk (UK); CanLII (CA).
5) Enable **Web Provenance**: Wayback CDX lookups in every ingestion.

**Next (P1):** indicators (World Bank/OECD/StatsCan/IMF/FRED/ECB), geospatial (OSM/ORS/MapLibre), OA access (arXiv/Unpaywall/DOAJ/CORE), quality/security (GX/OSV/OpenRefine).

**Guardrails:** cache + rate-limit; retain raw; checksums; nightly deltas; GX validations; OSV scans.
