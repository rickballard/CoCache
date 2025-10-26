# Domain Taxonomy (Thinkers vs CoCore)

**Purpose:** make it explicit that the "domains" you select on the Thinkers page are *topic domains* for discovery/fit — **not** the same as the CoCore **system domains** used for modeling (e.g., legal/economic systems). Both can coexist if we keep the names clear and machine-typed.

## Two parallel taxonomies

1) **Thinker Topic Domains (for discovery/fit UI)**
   - Examples: *Humane Tech, AI Governance, Incentives, UX Patterns, Digital Democracy, Deliberation, Commons, Polycentric Governance, Mechanism Design, Public Goods Funding, Sustainability, Macroeconomics, Interoperability, Antitrust, User Agency, etc.*
   - Goal: help users find relevant thinkers and quickly filter the gallery.

2) **CoCore System Domains (for modeling/analysis)**
   - Tracks which **system layer** the work primarily affects:
     - `law.*` (legal systems/models, compliance, rights frameworks)
     - `econ.*` (economic systems/models, macro/micro design)
     - `governance.*` (institutional design, decision-mechanisms)
     - `infra.*` (technical standards, protocols, interop, portability)
     - `civic.*` (deliberation, participation, legitimacy)
     - `sustainability.*` (planetary boundaries, social floors)
   - Goal: normalize evidence across projects and evaluate *Congruence*.

## How to encode both on each thinker

Add two fields next to the existing ones:

```json
{
  "name": "Example Thinker",
  "domains": ["Humane Tech", "AI Governance"],   // UI-facing Topic Domains
  "system_domains": ["governance.incentives", "infra.interop"],  // CoCore System Domains
  "alignment": { "fit": "Strong", "summary": "..." },
  "sheet_url": "https://.../sheets/example-thinker.html",
  "sources": [ ... ]
}
```

- The Thinkers UI keeps using `domains`.
- CoCore analytics can pivot on `system_domains` without touching the UI.

## Allowed values (starter set)

- **Topic Domains (UI):** see `thinkers.domains.json`
- **System Domains (CoCore):**
  - `law.*` (e.g., `law.data_rights`, `law.liability`)
  - `econ.*` (e.g., `econ.public_goods`, `econ.mechanism_design`)
  - `governance.*` (e.g., `governance.sortition`, `governance.polycentric`)
  - `infra.*` (e.g., `infra.interop`, `infra.portability`, `infra.standards`)
  - `civic.*` (e.g., `civic.deliberation`, `civic.participation`)
  - `sustainability.*` (e.g., `sustainability.boundaries`)

Keep expanding both lists as needed, but **don’t overload** the UI set; keep it approachable.

