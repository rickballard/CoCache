# 📂 Document Categories in the Cognocarta-Consenti Repo

This file defines the standardized categories of documents within the Civium Constitution repo and distinguishes the singular Scroll from all supporting materials.

---

## 📜 1. The Scroll

- **File:** `Cognocarta_Consenti.md`
- **Alias:** CC
- **Purpose:** The foundational civic constitution of Civium.
- **Rule:** Only one file is designated as a "scroll." All others are supporting documents.

---

## 📘 2. Codex Files (`/codex/`)

- **Purpose:** Define enforceable subsystems, governance mechanisms, and protocol logic supporting the CC.
- **Format:** `codex###-name.md`
- **Examples:**
  - `codex001-repmod.md`
  - `codex005-truth-metrics.md`

---

## 🔤 3. Glossary Files (`/glossary/`)

- **Purpose:** Establish canonical definitions for foundational terms across all repo content.
- **Format:** One file per term, e.g., `Accurate.md`, `Scoped.md`
- **Rule:** Glossary terms should be referenced from scroll, codex, and language documents.

---

## 🧠 4. Language Files (`/language/`)

- **Purpose:** Define key concepts, system primitives, civic terminology, or philosophical structures.
- **Note:** Language files are more interpretive than glossary entries.
- **Examples:** `repmod.md`, `scroll.md`, `axiom.md`

---

## 🧾 5. Meta Files (`/meta/`)

- **Purpose:** Contributor instructions, editorial logs, repository protocol scaffolding.
- **Subfolders:**
  - `legend/`: Symbolic and mythic documents (e.g., `Seven_Minds_Legend.md`)
  - `deprecated/`: Archived or outdated documents retained for historical traceability.

---

## 🧬 6. Insight and Limbic Layers (`/insight/`, `/limbic/`)

- **Purpose:** Contain normative and interpretive guides to ethical, philosophical, and social frameworks.
- **Examples:**
  - `/limbic/civic_decalogue.md`
  - `/insight/radiant_network.md`
- **Note:** These two folders are conceptually related and may eventually be merged under a single `framework/` or `ethics/` folder.

---

## 🧠 7. Memory (`/memory/`)

- **Purpose:** Tracks the evolving state of the scrolls, contributors, logs, and meta-status markers.
- **Examples:**
  - `scroll_status_dashboard.yaml`
  - `contributors.yaml`

---

## 🗺️ 8. Maps (`/maps/`)

- **Purpose:** Visualize dependencies, structural relationships, or social-intelligence topologies.
- **Examples:**
  - `scroll_dependency_map.md`
  - `thinking_constitution.svg`

---

## 🧹 Folder Consolidation Notes

- ✅ `insight/` and `limbic/` are both ethical/metaphysical layers.
  - Suggested Future Merge: `ethics/` or `frameworks/`

- ✅ `meta/deprecated/` should remain for traceability, but all active work should stay in top-level folders.

---

## 🔐 Naming Enforcement

| Term | Reserved? | Notes |
|------|-----------|-------|
| **Scroll** | ✅ Yes | Only `Cognocarta_Consenti.md` |
| **Codex** | ✅ Yes | Numbered subsystems |
| **Glossary** | ✅ Yes | Canonical definitions |
| **Language** | ✅ Yes | Conceptual primitives |
| **Legend / Insight / Limbic** | ⚠️ Provisional | Will stabilize post-publication |

